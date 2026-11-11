#!/usr/bin/env python3
import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import urllib.request
from pathlib import Path
from typing import Dict, List, Optional, Tuple

REPO_ROOT = Path(__file__).resolve().parent.parent

WORKSHOP_TARGETS = {
    "rome2": {
        "name": "Total War: Rome II",
        "appid": "214950",
        "itemid": "3435375001",
        "pack_name": "consulscriptum.pack",
        "build_subpath": "Rome2",
        "preview_path": "consulscriptum.png",
        "description_path": "steam/rome2_description.txt",
        "title": "Consul Scriptum | Rome 2 Scripting Console",
    },
    "attila": {
        "name": "Total War: Attila",
        "appid": "325610",
        "itemid": "3717893382",
        "pack_name": "consulscriptum_attila.pack",
        "build_subpath": "Attila",
        "preview_path": "consulscriptum.png",
        "description_path": "steam/attila_description.txt",
        "title": "Consul Scriptum | Attila Scripting Console",
    },
    "tob": {
        "name": "Total War Saga: Thrones of Britannia",
        "appid": "712100",
        "itemid": "3717928343",
        "pack_name": "consulscriptum_tob.pack",
        "build_subpath": "TOB",
        "preview_path": "consulscriptum.png",
        "description_path": "steam/tob_description.txt",
        "title": "Consul Scriptum | ToB Scripting Console",
    },
}

GITHUB_REPO = "bukowa/ConsulScriptum"
MAX_IMAGE_SIZE_BYTES = 1048576


def get_current_project_version() -> str:
    consul_lua = REPO_ROOT / "src" / "consul" / "consul.lua"
    if consul_lua.exists():
        content = consul_lua.read_text(encoding="utf-8")
        match = re.search(r'VERSION\s*=\s*["\']([^"\']+)["\']', content)
        if match:
            return match.group(1).strip()
    return "1.1.0"


def fetch_release_from_github(tag: str, target_games: List[str]) -> Tuple[Dict[str, Path], Dict[str, str], str, str]:
    clean_tag = tag.strip()
    if clean_tag.lower() == "latest":
        api_url = f"https://api.github.com/repos/{GITHUB_REPO}/releases/latest"
    else:
        tag_name = clean_tag if clean_tag.startswith("v") else f"v{clean_tag}"
        api_url = f"https://api.github.com/repos/{GITHUB_REPO}/releases/tags/{tag_name}"

    req = urllib.request.Request(
        api_url,
        headers={
            "User-Agent": "ConsulScriptum-Workshop-Publisher",
            "Accept": "application/vnd.github.v3+json",
        },
    )

    try:
        with urllib.request.urlopen(req) as resp:
            data = json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        if e.code == 404:
            raise RuntimeError(f"GitHub Release for tag '{tag}' not found in {GITHUB_REPO}.")
        raise RuntimeError(f"GitHub API error (HTTP {e.code}): {e.reason}")

    resolved_tag = data.get("tag_name", clean_tag)
    release_body = data.get("body", "").strip()
    assets = data.get("assets", [])

    download_dir = REPO_ROOT / "build" / "release_downloads" / resolved_tag
    download_dir.mkdir(parents=True, exist_ok=True)

    asset_by_name = {a["name"]: a for a in assets}
    pack_map = {}
    hash_map = {}

    for game_key in target_games:
        pack_name = WORKSHOP_TARGETS[game_key]["pack_name"]
        if pack_name not in asset_by_name:
            raise FileNotFoundError(
                f"Release {resolved_tag} missing asset '{pack_name}'. Available: {list(asset_by_name.keys())}"
            )

        asset = asset_by_name[pack_name]
        download_url = asset["browser_download_url"]
        expected_digest = asset.get("digest", "")

        dest_file = download_dir / pack_name
        print(f"Downloading {pack_name} from GitHub release {resolved_tag}...")

        with urllib.request.urlopen(download_url) as resp:
            content = resp.read()

        dest_file.write_bytes(content)
        computed_sha256 = hashlib.sha256(content).hexdigest()

        if expected_digest:
            expected_hash = expected_digest.split(":")[-1].lower()
            if computed_sha256.lower() != expected_hash:
                dest_file.unlink(missing_ok=True)
                raise ValueError(
                    f"SHA-256 mismatch for {pack_name}!\n"
                    f"  Expected: {expected_hash}\n"
                    f"  Computed: {computed_sha256}"
                )
            hash_map[game_key] = expected_hash
        else:
            hash_map[game_key] = computed_sha256

        pack_map[game_key] = dest_file

    return pack_map, hash_map, release_body, resolved_tag


def parse_changelog_entries() -> List[Tuple[str, Dict[str, str]]]:
    changelog_lua = REPO_ROOT / "src" / "consul" / "consul_changelog.lua"
    if not changelog_lua.exists():
        return []

    content = changelog_lua.read_text(encoding="utf-8")
    version_pattern = re.compile(r'\[["\']([^"\']+)["\']\]\s*=\s*\{(.*?)\n\s*\}', re.DOTALL)
    matches = list(version_pattern.finditer(content))
    entries = []

    for match in matches:
        version = match.group(1).strip()
        body = match.group(2)
        note_data = {}
        current_key = None

        for line in body.split("\n"):
            line = line.strip()
            if not line:
                continue
            field_start = re.match(r"^(\w+)\s*=\s*(.*)$", line)
            if field_start:
                current_key = field_start.group(1)
                note_data[current_key] = field_start.group(2)
            elif current_key:
                note_data[current_key] += " " + line

        for k in note_data:
            v = note_data[k].strip().rstrip(",")
            v = re.sub(r'["\']\s*\.\.\s*["\']', "", v)
            v = re.sub(r'["\']\s*\.\.\s*', "", v)
            v = re.sub(r'\s*\.\.\s*["\']', "", v)
            v = re.sub(r'\s*\.\.\s*', "", v)
            if v.startswith('"') or v.startswith("'"):
                v = v[1:]
            if v.endswith('"') or v.endswith("'"):
                v = v[:-1]
            v = v.replace("\\n", "\n")
            note_data[k] = v.strip()

        entries.append((version, note_data))

    return entries


def format_markdown_changenote(version: str, game_key: Optional[str] = None) -> str:
    entries = parse_changelog_entries()
    if not entries:
        return f"## v{version}\n\nBug fixes and compatibility improvements."

    target_ver = version.lstrip("v").strip()
    idx = -1
    for i, (v, _) in enumerate(entries):
        if v.lstrip("v").strip() == target_ver:
            idx = i
            break

    if idx == -1:
        return f"## v{version}\n\nUpdate version {version}."

    _, note_data = entries[idx]
    prev_ver = None
    if idx + 1 < len(entries):
        prev_ver = entries[idx + 1][0].lstrip("v").strip()

    lines = [f"## v{target_ver}\n"]

    if "common" in note_data and note_data["common"]:
        lines.append("**Common:**\n")
        for line in note_data["common"].split("\n"):
            line = line.strip()
            if not line:
                continue
            if not line.startswith("-"):
                lines.append(f"- {line}\n")
            else:
                lines.append(f"{line}\n")
        lines.append("\n")

    game_names = {
        "rome2": ("Rome2", "Rome II specific:"),
        "attila": ("Attila", "Attila specific:"),
        "tob": ("TOB", "Thrones of Britannia specific:"),
    }

    if game_key and game_key in game_names:
        key_name, header = game_names[game_key]
        if key_name in note_data and note_data[key_name]:
            lines.append(f"**{header}**\n")
            for line in note_data[key_name].split("\n"):
                line = line.strip()
                if not line:
                    continue
                if not line.startswith("-"):
                    lines.append(f"- {line}\n")
                else:
                    lines.append(f"{line}\n")
            lines.append("\n")
    else:
        for key_name, header in [
            ("Rome2", "Rome II specific:"),
            ("Attila", "Attila specific:"),
            ("TOB", "Thrones of Britannia specific:"),
        ]:
            if key_name in note_data and note_data[key_name]:
                lines.append(f"**{header}**\n")
                for line in note_data[key_name].split("\n"):
                    line = line.strip()
                    if not line:
                        continue
                    if not line.startswith("-"):
                        lines.append(f"- {line}\n")
                    else:
                        lines.append(f"{line}\n")
                lines.append("\n")

    lines.append("---\n\n")
    if prev_ver:
        lines.append(
            f"**Full Changelog**: https://github.com/{GITHUB_REPO}/compare/v{prev_ver}...v{target_ver}\n"
        )
    else:
        lines.append(
            f"**Full Changelog**: https://github.com/{GITHUB_REPO}/releases/tag/v{target_ver}\n"
        )

    return "".join(lines).strip()


def locate_steamcmd(custom_path: Optional[str] = None) -> Optional[Path]:
    if custom_path:
        p = Path(custom_path)
        if p.exists() and p.is_file():
            return p
        raise FileNotFoundError(f"Custom SteamCMD executable not found at: {custom_path}")

    deps_steamcmd = REPO_ROOT / ".deps" / "steamcmd" / "steamcmd.exe"
    if deps_steamcmd.exists():
        return deps_steamcmd

    which_steamcmd = shutil.which("steamcmd") or shutil.which("steamcmd.exe")
    if which_steamcmd:
        return Path(which_steamcmd)

    common_paths = [
        Path(r"C:\steamcmd\steamcmd.exe"),
        Path(r"C:\Program Files (x86)\Steam\steamcmd.exe"),
        Path(r"C:\Program Files\Steam\steamcmd.exe"),
    ]
    for p in common_paths:
        if p.exists():
            return p

    return None


def download_steamcmd(target_dir: Path) -> Path:
    import zipfile

    url = "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"
    target_dir.mkdir(parents=True, exist_ok=True)
    zip_dest = target_dir / "steamcmd.zip"
    exe_dest = target_dir / "steamcmd.exe"

    print(f"Downloading SteamCMD from {url}...")
    urllib.request.urlretrieve(url, zip_dest)

    with zipfile.ZipFile(zip_dest, "r") as z:
        z.extractall(target_dir)

    if zip_dest.exists():
        zip_dest.unlink()

    if not exe_dest.exists():
        raise FileNotFoundError(f"Failed to extract steamcmd.exe into {target_dir}")

    return exe_dest


def escape_vdf_string(text: str) -> str:
    return text.replace("\\", "\\\\").replace('"', '\\"')


def prepare_staging_directory(
    game_key: str, config: Dict[str, str], custom_pack_path: Optional[Path] = None
) -> Tuple[Path, Path]:
    staging_dir = REPO_ROOT / "build" / "staging_workshop" / game_key
    staging_dir.mkdir(parents=True, exist_ok=True)

    source_pack: Optional[Path] = custom_pack_path
    if not source_pack:
        pack_release = REPO_ROOT / "release" / config["pack_name"]
        pack_build = REPO_ROOT / "build" / config["build_subpath"] / config["pack_name"]
        if pack_release.exists():
            source_pack = pack_release
        elif pack_build.exists():
            source_pack = pack_build

    if not source_pack or not source_pack.exists():
        raise FileNotFoundError(
            f"Compiled pack for {config['name']} not found at:\n"
            f"  {source_pack or 'release/' + config['pack_name']}\n"
            f"Run with '--tag <version>' to download from GitHub, or 'make GAME={config['build_subpath']} release' locally."
        )

    dest_pack = staging_dir / config["pack_name"]
    shutil.copy2(source_pack, dest_pack)

    preview_src = REPO_ROOT / config["preview_path"]
    if not preview_src.exists():
        preview_src = REPO_ROOT / "consulscriptum.png"

    if not preview_src.exists():
        raise FileNotFoundError(f"Preview thumbnail not found at: {preview_src}")

    image_size = preview_src.stat().st_size
    if image_size > MAX_IMAGE_SIZE_BYTES:
        raise ValueError(
            f"Preview image {preview_src.name} is {image_size:,} bytes (exceeds Steam 1 MB limit)."
        )

    pack_stem = Path(config["pack_name"]).stem
    launcher_thumbnail = staging_dir / f"{pack_stem}.png"
    shutil.copy2(preview_src, launcher_thumbnail)

    return staging_dir, preview_src


def generate_vdf_file(
    game_key: str,
    config: Dict[str, str],
    staging_dir: Path,
    preview_file: Path,
    changenote: str,
    visibility: str = "0",
    update_description: bool = False,
    update_title: bool = False,
) -> Path:
    # Write VDF outside staging_dir so it is not packaged into the upload
    vdf_path = staging_dir.parent / f"{game_key}_upload.vdf"

    contentfolder_str = str(staging_dir.resolve()).replace("\\", "/")
    previewfile_str = str(preview_file.resolve()).replace("\\", "/")
    escaped_changenote = escape_vdf_string(changenote)

    lines = [
        '"workshopitem"',
        "{",
        f'    "appid"            "{config["appid"]}"',
        f'    "publishedfileid"  "{config["itemid"]}"',
        f'    "contentfolder"    "{contentfolder_str}"',
        f'    "previewfile"      "{previewfile_str}"',
        f'    "visibility"       "{visibility}"',
        f'    "changenote"       "{escaped_changenote}"',
    ]

    if update_title:
        escaped_title = escape_vdf_string(config["title"])
        lines.append(f'    "title"            "{escaped_title}"')

    if update_description:
        desc_path = REPO_ROOT / config["description_path"]
        if desc_path.exists():
            desc_text = desc_path.read_text(encoding="utf-8")
            escaped_desc = escape_vdf_string(desc_text)
            lines.append(f'    "description"      "{escaped_desc}"')
        else:
            print(f"Warning: Description file {desc_path} not found, skipping.")

    lines.append("}\n")
    vdf_content = "\n".join(lines)
    vdf_path.write_text(vdf_content, encoding="utf-8")

    return vdf_path


def get_cached_username(steamcmd_path: Path) -> Optional[str]:
    config_vdf = steamcmd_path.parent / "config" / "config.vdf"
    if not config_vdf.exists():
        return None
    try:
        content = config_vdf.read_text(encoding="utf-8", errors="ignore")
        match = re.search(r'"Accounts"\s*\{\s*"([^"]+)"', content, re.IGNORECASE)
        if match:
            return match.group(1)
    except Exception:
        pass
    return None


def has_cached_credentials(steamcmd_path: Path, username: str) -> bool:
    config_vdf = steamcmd_path.parent / "config" / "config.vdf"
    if not config_vdf.exists():
        return False
    try:
        content = config_vdf.read_text(encoding="utf-8", errors="ignore").lower()
        return "accounts" in content and username.lower() in content
    except Exception:
        return False


def ensure_steam_login(steamcmd_path: Path, username: str, password: Optional[str] = None):
    if has_cached_credentials(steamcmd_path, username):
        return

    print(f"No cached credentials found for '{username}'. Initial interactive login required.")
    cmd = [str(steamcmd_path), "+login", username]
    if password:
        cmd.append(password)
    cmd.append("+quit")

    # Inherit standard I/O so the user can enter password and Steam Guard code interactively
    subprocess.run(cmd)

    if not has_cached_credentials(steamcmd_path, username):
        print(f"Login for '{username}' was not completed or credentials were not cached.")
        sys.exit(1)


def run_steamcmd(
    steamcmd_path: Path,
    username: str,
    vdf_path: Path,
    password: Optional[str] = None,
    no_prompt_password: bool = True,
    dry_run: bool = False,
) -> bool:
    cmd = [str(steamcmd_path)]

    if no_prompt_password and not password:
        cmd.extend(["+@NoPromptForPassword", "1"])

    cmd.extend(["+login", username])
    if password:
        cmd.append(password)

    cmd.extend(["+workshop_build_item", str(vdf_path.resolve())])
    cmd.append("+quit")

    if dry_run:
        print("[DRY-RUN] " + " ".join(cmd))
        return True

    print(f"Running: {' '.join(cmd)}")

    process = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        encoding="utf-8",
        errors="replace",
        bufsize=1,
    )

    success = False
    need_relogin = False
    if process.stdout:
        for line in process.stdout:
            sys.stdout.write(line)
            sys.stdout.flush()
            if "Success." in line or "Success" in line or "Successfully published" in line:
                success = True
            if "No cached credentials" in line or "Cached credentials not found" in line:
                need_relogin = True

    process.wait()

    if need_relogin:
        print(f"\nCached credentials invalid. Triggering interactive login for '{username}'...")
        relogin_cmd = [str(steamcmd_path), "+login", username]
        if password:
            relogin_cmd.append(password)
        relogin_cmd.append("+quit")
        subprocess.run(relogin_cmd)
        # Retry once after interactive login
        return run_steamcmd(
            steamcmd_path=steamcmd_path,
            username=username,
            vdf_path=vdf_path,
            password=password,
            no_prompt_password=no_prompt_password,
            dry_run=dry_run,
        )

    if process.returncode == 0 and success:
        return True
    elif process.returncode == 0 and not success:
        print("SteamCMD exited 0 but success message not found in log.")
        return False
    else:
        print(f"SteamCMD exited with code {process.returncode}")
        return False


def verify_workshop_download(
    steamcmd_path: Optional[Path],
    username: str,
    appid: str,
    itemid: str,
    pack_name: str,
    expected_sha256: str,
    password: Optional[str] = None,
    no_prompt_password: bool = True,
    dry_run: bool = False,
) -> bool:
    if dry_run:
        print(f"[DRY-RUN] Verifying item {itemid} SHA-256 against: {expected_sha256}")
        return True

    if not steamcmd_path:
        print("Skipping verification: SteamCMD path not found.")
        return False

    print(f"Downloading item {itemid} for verification...")

    steamcmd_dir = steamcmd_path.parent
    possible_locations = [
        steamcmd_dir / "steamapps" / "workshop" / "content" / appid / itemid / pack_name,
        Path("steamapps/workshop/content") / appid / itemid / pack_name,
        Path.home() / "Steam" / "steamapps" / "workshop" / "content" / appid / itemid / pack_name,
    ]
    for loc in possible_locations:
        if loc.exists():
            loc.unlink(missing_ok=True)

    cmd = [str(steamcmd_path)]
    if no_prompt_password and not password:
        cmd.extend(["+@NoPromptForPassword", "1"])
    cmd.extend(["+login", username])
    if password:
        cmd.append(password)
    cmd.extend(["+workshop_download_item", str(appid), str(itemid), "validate", "+quit"])

    process = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        encoding="utf-8",
        errors="replace",
        bufsize=1,
    )

    if process.stdout:
        for line in process.stdout:
            sys.stdout.write(line)
            sys.stdout.flush()

    process.wait()

    steamcmd_dir = steamcmd_path.parent
    possible_locations = [
        steamcmd_dir / "steamapps" / "workshop" / "content" / appid / itemid / pack_name,
        Path("steamapps/workshop/content") / appid / itemid / pack_name,
        Path.home() / "Steam" / "steamapps" / "workshop" / "content" / appid / itemid / pack_name,
    ]

    downloaded_pack: Optional[Path] = None
    for loc in possible_locations:
        if loc.exists():
            downloaded_pack = loc
            break

    if not downloaded_pack:
        print(f"Verification error: Downloaded file '{pack_name}' not found.")
        return False

    downloaded_bytes = downloaded_pack.read_bytes()
    computed_sha256 = hashlib.sha256(downloaded_bytes).hexdigest()

    print(f"Workshop SHA-256: {computed_sha256}")
    print(f"Expected SHA-256: {expected_sha256}")

    if computed_sha256.lower() == expected_sha256.lower():
        print(f"[OK] Item {itemid} verified clean (SHA-256 matches release).")
        return True
    else:
        print(f"[ERROR] SHA-256 mismatch on item {itemid}!")
        return False


def main():
    parser = argparse.ArgumentParser(description="Publish Consul Scriptum mods to Steam Workshop.")
    parser.add_argument(
        "--tag",
        "-t",
        help="GitHub release tag to download and publish (e.g. v1.1.0 or latest).",
    )
    parser.add_argument(
        "--local",
        action="store_true",
        help="Use local build/release pack files instead of downloading from GitHub Releases.",
    )
    parser.add_argument(
        "--game",
        "-g",
        choices=["rome2", "attila", "tob", "all"],
        default="all",
        help="Target game to publish (default: all).",
    )
    parser.add_argument(
        "--version",
        "-v",
        help="Version string for changelog (default: read from src/consul/consul.lua or GitHub tag).",
    )
    parser.add_argument(
        "--changenote",
        help="Explicit changenote text override.",
    )
    parser.add_argument(
        "--changenote-file",
        help="Path to file containing changenote text.",
    )
    parser.add_argument(
        "--username",
        "-u",
        help="Steam username (or set STEAM_USER).",
    )
    parser.add_argument(
        "--password",
        "-p",
        help="Steam password.",
    )
    parser.add_argument(
        "--visibility",
        choices=["0", "1", "2", "3"],
        default="0",
        help="0=Public, 1=Friends Only, 2=Private, 3=Unlisted (default: 0).",
    )
    parser.add_argument(
        "--update-description",
        action="store_true",
        help="Update Workshop description from steam/<game>_description.txt.",
    )
    parser.add_argument(
        "--update-title",
        action="store_true",
        help="Update Workshop item title.",
    )
    parser.add_argument(
        "--steamcmd",
        help="Path to steamcmd executable.",
    )
    parser.add_argument(
        "--interactive",
        action="store_true",
        help="Prompt interactively for password/2FA (disables @NoPromptForPassword).",
    )
    parser.add_argument(
        "--verify",
        "--verify-only",
        dest="verify_only",
        action="store_true",
        help="Download and verify live Steam Workshop items against release hashes without uploading.",
    )
    parser.add_argument(
        "--no-verify",
        action="store_true",
        help="Skip post-publish download and SHA-256 verification.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Stage and generate VDF without executing SteamCMD.",
    )

    args = parser.parse_args()

    target_games = ["rome2", "attila", "tob"] if args.game == "all" else [args.game]

    downloaded_packs: Dict[str, Path] = {}
    expected_hashes: Dict[str, str] = {}
    github_release_body = ""
    tag_name = ""

    if args.tag:
        try:
            downloaded_packs, expected_hashes, github_release_body, tag_name = fetch_release_from_github(args.tag, target_games)
        except Exception as e:
            print(f"Error fetching release: {e}")
            sys.exit(1)
        version = tag_name.lstrip("v")
    else:
        version = args.version or get_current_project_version()
        for g in target_games:
            cfg = WORKSHOP_TARGETS[g]
            p_rel = REPO_ROOT / "release" / cfg["pack_name"]
            p_bld = REPO_ROOT / "build" / cfg["build_subpath"] / cfg["pack_name"]
            src = p_rel if p_rel.exists() else p_bld
            if src.exists():
                expected_hashes[g] = hashlib.sha256(src.read_bytes()).hexdigest()

    steamcmd_path: Optional[Path] = None
    if not args.dry_run:
        steamcmd_path = locate_steamcmd(args.steamcmd)
        if not steamcmd_path:
            if sys.platform == "win32":
                download_prompt = input("SteamCMD not found. Download to .deps/steamcmd/? [Y/n]: ").strip().lower()
                if download_prompt in ("", "y", "yes"):
                    try:
                        steamcmd_path = download_steamcmd(REPO_ROOT / ".deps" / "steamcmd")
                    except Exception as e:
                        print(f"Error downloading SteamCMD: {e}")
                        sys.exit(1)
                else:
                    sys.exit(1)
            else:
                print("Error: steamcmd executable not found.")
                sys.exit(1)

    username = args.username or os.getenv("STEAM_USER")
    if not username and steamcmd_path:
        username = get_cached_username(steamcmd_path)

    if not username and not args.dry_run:
        try:
            username = input("Enter Steam username: ").strip()
        except EOFError:
            pass

    if not username and not args.dry_run:
        print("Error: Steam username required. Provide --username or set STEAM_USER.")
        sys.exit(1)

    if not args.dry_run and steamcmd_path:
        ensure_steam_login(steamcmd_path, username, args.password)

    failures = []
    successes = []

    if args.verify_only:
        for game_key in target_games:
            config = WORKSHOP_TARGETS[game_key]
            print(f"\n[{game_key}] Verifying {config['name']} (Item: {config['itemid']})...")
            if game_key not in expected_hashes:
                print(f"Error: Expected hash not found for {game_key}.")
                failures.append(game_key)
                continue

            verified = verify_workshop_download(
                steamcmd_path=steamcmd_path,
                username=username or "steam_user",
                appid=config["appid"],
                itemid=config["itemid"],
                pack_name=config["pack_name"],
                expected_sha256=expected_hashes[game_key],
                password=args.password,
                no_prompt_password=not args.interactive,
                dry_run=args.dry_run,
            )
            if verified:
                successes.append(game_key)
            else:
                failures.append(game_key)

        print(f"\nVerification Result: {len(successes)} verified, {len(failures)} failed.")
        sys.exit(0 if not failures else 1)

    for game_key in target_games:
        config = WORKSHOP_TARGETS[game_key]
        print(f"\n[{game_key}] {config['name']} (AppID: {config['appid']}, Item: {config['itemid']})")

        if args.changenote:
            changenote = args.changenote
        elif args.changenote_file:
            changenote = Path(args.changenote_file).read_text(encoding="utf-8")
        elif github_release_body:
            changenote = github_release_body
        else:
            changenote = format_markdown_changenote(version, game_key=game_key)

        custom_pack = downloaded_packs.get(game_key)
        try:
            staging_dir, preview_file = prepare_staging_directory(
                game_key, config, custom_pack_path=custom_pack
            )
        except Exception as e:
            print(f"Staging failed: {e}")
            failures.append(game_key)
            continue

        try:
            vdf_path = generate_vdf_file(
                game_key=game_key,
                config=config,
                staging_dir=staging_dir,
                preview_file=preview_file,
                changenote=changenote,
                visibility=args.visibility,
                update_description=args.update_description,
                update_title=args.update_title,
            )
        except Exception as e:
            print(f"VDF generation failed: {e}")
            failures.append(game_key)
            continue

        if args.dry_run:
            print(f"VDF: {vdf_path}")
            if not args.no_verify and game_key in expected_hashes:
                verify_workshop_download(
                    steamcmd_path=steamcmd_path,
                    username=username or "steam_user",
                    appid=config["appid"],
                    itemid=config["itemid"],
                    pack_name=config["pack_name"],
                    expected_sha256=expected_hashes[game_key],
                    dry_run=True,
                )
            successes.append(game_key)
            continue

        no_prompt = not args.interactive
        ok = run_steamcmd(
            steamcmd_path=steamcmd_path,
            username=username,
            vdf_path=vdf_path,
            password=args.password,
            no_prompt_password=no_prompt,
            dry_run=args.dry_run,
        )

        if not ok:
            print(f"Upload failed for {config['name']}.")
            failures.append(game_key)
            continue

        print(f"Upload complete for {config['name']}.")

        if not args.no_verify and game_key in expected_hashes:
            verified = verify_workshop_download(
                steamcmd_path=steamcmd_path,
                username=username,
                appid=config["appid"],
                itemid=config["itemid"],
                pack_name=config["pack_name"],
                expected_sha256=expected_hashes[game_key],
                password=args.password,
                no_prompt_password=no_prompt,
                dry_run=False,
            )
            if not verified:
                failures.append(game_key)
                continue

        successes.append(game_key)

    print(f"\nResult: {len(successes)} succeeded, {len(failures)} failed.")
    if failures:
        sys.exit(1)


if __name__ == "__main__":
    main()
