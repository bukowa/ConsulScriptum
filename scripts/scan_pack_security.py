#!/usr/bin/env python3
import os
import sys
import re
import tempfile
import shutil
import subprocess
from pathlib import Path

VALID_PFH_HEADERS = {
    b"PFH4": "PFH4",
    b"PFH5": "PFH5",
}

ALLOWED_ROOT_DIRS = {
    "consul",
    "db",
    "lua_scripts",
    "script",
    "text",
    "ui",
}

ALLOWED_ROOT_FILES = {
    "notes.rpfm_reserved.md",
    "settings.rpfm_reserved.json",
}

BANNED_EXTENSIONS = {
    ".exe", ".dll", ".bat", ".cmd", ".ps1", ".vbs", ".js", ".scr",
    ".bin", ".jar", ".com", ".pif", ".so", ".dylib", ".sh", ".py",
    ".msi", ".cpl", ".hta", ".wsf", ".vbe", ".jse",
}

ALLOWED_EXTENSIONS = {
    "", ".lua", ".xml", ".tsv", ".loc", ".png", ".tga", ".dds",
    ".txt", ".md", ".json", ".animpack",
}

APPROVED_LUA_EXCEPTIONS = [
    (r"consul[\\/]consul\.lua", re.compile(r"loadstring\s*\(\s*cmd\s*\)")),
    (r"consul[\\/]consul_uidebug\.lua", re.compile(r'os\.execute\s*\(\s*"mkdir\s+"')),
    (r"consul[\\/]consul_uidebug\.lua", re.compile(r'os\.execute\s*\(\s*"start\s+"')),
    (r"consul[\\/]consul_uidebug\.lua", re.compile(r"loadstring\s*\(\s*content\s*\)")),
    (r"consul[\\/]penlight[\\/]compat\.lua", re.compile(r"loadstring\s*\(")),
    (r"consul[\\/]penlight[\\/]compat\.lua", re.compile(r"os\.execute\s*\(")),
]


def check_pack_header(pack_path: Path) -> str:
    with open(pack_path, "rb") as f:
        magic = f.read(4)
    if magic not in VALID_PFH_HEADERS:
        raise ValueError(f"invalid magic {magic!r}")
    return VALID_PFH_HEADERS[magic]


def find_rpfm_cli() -> str:
    candidates = [
        Path(".deps/rpfm_cli/rpfm_cli.exe"),
        Path(".deps/rpfm_cli/rpfm_cli"),
        Path("rpfm_cli.exe"),
        Path("rpfm_cli"),
    ]
    for c in candidates:
        if c.exists() and os.access(c, os.X_OK):
            return str(c.resolve())
    which_cmd = shutil.which("rpfm_cli")
    if which_cmd:
        return which_cmd
    return ""


def list_pack_files(pack_path: Path, rpfm_cli: str) -> list[str]:
    cmd = [rpfm_cli, "--game", "rome_2", "pack", "list", "--pack-path", str(pack_path)]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        raise RuntimeError(f"rpfm_cli pack list failed: {result.stderr.strip()}")

    files = []
    for line in result.stdout.splitlines():
        line = line.strip()
        if not line or line.startswith("[INFO]") or "Logger initialized" in line or "Sentry" in line:
            continue
        files.append(line.replace("\\", "/"))
    return sorted(files)


def extract_pack_files(pack_path: Path, dest_dir: Path, rpfm_cli: str) -> None:
    cmd = [
        rpfm_cli,
        "--game", "rome_2",
        "pack", "extract",
        "--pack-path", str(pack_path),
        "-F", f"/;{dest_dir}",
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        raise RuntimeError(f"rpfm_cli pack extract failed: {result.stderr.strip()}")


def scan_file_structure(pack_name: str, file_paths: list[str]) -> list[str]:
    violations = []
    if not file_paths:
        violations.append(f"{pack_name}: empty pack")
        return violations

    for path_str in file_paths:
        if ".." in path_str or path_str.startswith("/") or "\\." in path_str:
            violations.append(f"{pack_name}: path traversal in '{path_str}'")

        parts = path_str.split("/")
        root_entry = parts[0]
        if len(parts) == 1:
            if root_entry not in ALLOWED_ROOT_FILES:
                violations.append(f"{pack_name}: invalid root file '{root_entry}'")
        else:
            if root_entry not in ALLOWED_ROOT_DIRS:
                violations.append(f"{pack_name}: invalid root directory '{root_entry}'")

        ext = os.path.splitext(path_str)[1].lower()
        if ext in BANNED_EXTENSIONS:
            violations.append(f"{pack_name}: banned extension '{ext}' in '{path_str}'")
        elif ext not in ALLOWED_EXTENSIONS:
            violations.append(f"{pack_name}: unlisted extension '{ext}' in '{path_str}'")

    return violations


def is_approved_lua_call(rel_path: str, line: str) -> bool:
    for pattern_path, pattern_re in APPROVED_LUA_EXCEPTIONS:
        if re.search(pattern_path, rel_path, re.IGNORECASE) and pattern_re.search(line):
            return True
    return False


def strip_lua_line_comment(line: str) -> str:
    stripped = line.strip()
    if stripped.startswith("--"):
        return ""
    idx = line.find("--")
    if idx != -1:
        pre = line[:idx]
        single_quotes = pre.count("'") - pre.count("\\'")
        double_quotes = pre.count('"') - pre.count('\\"')
        if single_quotes % 2 == 0 and double_quotes % 2 == 0:
            return pre
    return line


def scan_lua_security(pack_name: str, extracted_dir: Path) -> list[str]:
    violations = []
    patterns = [
        ("os.execute", re.compile(r"\bos\.execute\s*\(")),
        ("io.popen", re.compile(r"\bio\.popen\s*\(")),
        ("package.loadlib", re.compile(r"\bpackage\.loadlib\s*\(")),
        ("loadstring", re.compile(r"\bloadstring\s*\(")),
        ("socket", re.compile(r"""require\s*\(?["']socket(\.[\w]+)?["']\)?""")),
        ("network", re.compile(r"\b(socket\.tcp|socket\.connect|socket\.http)\b")),
        ("binary_payload", re.compile(r"(TVqQAAMAAAAEAAAA|\\x4d\\x5a\\x90\\x00|\b0x5A4D\b)")),
    ]

    for lua_file in extracted_dir.rglob("*.lua"):
        rel_path = str(lua_file.relative_to(extracted_dir))
        try:
            with open(lua_file, "r", encoding="utf-8", errors="replace") as f:
                lines = f.readlines()
        except Exception as e:
            violations.append(f"{pack_name}: cannot read '{rel_path}': {e}")
            continue

        for line_num, line in enumerate(lines, start=1):
            code_line = strip_lua_line_comment(line)
            if not code_line.strip():
                continue

            for rule_name, rule_regex in patterns:
                if rule_regex.search(code_line):
                    if is_approved_lua_call(rel_path, code_line):
                        continue
                    clean_line = line.strip()[:80]
                    violations.append(
                        f"{pack_name}:{rel_path}:{line_num}: forbidden pattern '{rule_name}' -> {clean_line}"
                    )

    return violations


def audit_pack(pack_path: Path, rpfm_cli: str) -> tuple[bool, list[str]]:
    issues = []
    try:
        check_pack_header(pack_path)
    except Exception as e:
        issues.append(f"{pack_path.name}: header check failed: {e}")
        return False, issues

    try:
        files = list_pack_files(pack_path, rpfm_cli)
    except Exception as e:
        issues.append(f"{pack_path.name}: file list failed: {e}")
        return False, issues

    struct_issues = scan_file_structure(pack_path.name, files)
    if struct_issues:
        issues.extend(struct_issues)

    with tempfile.TemporaryDirectory(prefix="pack_scan_") as tmp_dir:
        tmp_path = Path(tmp_dir)
        try:
            extract_pack_files(pack_path, tmp_path, rpfm_cli)
        except Exception as e:
            issues.append(f"{pack_path.name}: extract failed: {e}")
            return False, issues

        lua_issues = scan_lua_security(pack_path.name, tmp_path)
        if lua_issues:
            issues.extend(lua_issues)

    if not issues:
        print(f"{pack_path.name} ({len(files)} files): ok")
    return len(issues) == 0, issues


def main():
    packs = sys.argv[1:]
    if not packs:
        default_packs = [
            "consulscriptum.pack",
            "consulscriptum_attila.pack",
            "consulscriptum_tob.pack",
        ]
        packs = [p for p in default_packs if os.path.exists(p)]

    if not packs:
        print("error: no pack files found", file=sys.stderr)
        sys.exit(1)

    rpfm_cli = find_rpfm_cli()
    if not rpfm_cli:
        print("error: rpfm_cli not found in .deps or PATH", file=sys.stderr)
        sys.exit(1)

    all_passed = True
    all_violations = []

    for pack_str in packs:
        pack_path = Path(pack_str)
        if not pack_path.exists():
            all_violations.append(f"file not found: {pack_str}")
            all_passed = False
            continue

        passed, issues = audit_pack(pack_path, rpfm_cli)
        if not passed:
            all_passed = False
            all_violations.extend(issues)

    if not all_passed:
        for v in all_violations:
            print(f"error: {v}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
