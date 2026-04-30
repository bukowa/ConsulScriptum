import os

# Configuration for each game
GAMES = {
    "rome2": {
        "youtube_id": "6WbE6nKbPTQ",
        "interface_image": "https://images.steamusercontent.com/ugc/16988052029949233469/C5BE5EB74DC0A02F7F2E9DB0D0099827EB7B315A/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "consul_image": "https://images.steamusercontent.com/ugc/17036728790708406025/0A9651581C3D1AF0D86D2DBEF6A5952334D3C2A1/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "console_image": "https://images.steamusercontent.com/ugc/10820139722107472780/EA230A3029BC0ED8F2C39109598586575FB0CBCD/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "scriptum_image": "https://images.steamusercontent.com/ugc/11605380554018906578/C89A2DFA05DFFA01EECE5D01F74BFEC355DED8FF/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "manual_image": "https://images.steamusercontent.com/ugc/15350833015911593758/9B093006760F620A00B3727ADB4F81932A7B2CD0/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "docs_link": "https://consulscriptum.com/rome2",
        "compatibility_text": "Modifies only highly specific UI files. Compatible with everything, save game compatible.",
    },
    "attila": {
        "youtube_id": "YOUR_YOUTUBE_VIDEO_ID",
        "interface_image": "https://images.steamusercontent.com/ugc/16988052029949233469/C5BE5EB74DC0A02F7F2E9DB0D0099827EB7B315A/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "consul_image": "https://images.steamusercontent.com/ugc/17036728790708406025/0A9651581C3D1AF0D86D2DBEF6A5952334D3C2A1/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "console_image": "https://images.steamusercontent.com/ugc/10820139722107472780/EA230A3029BC0ED8F2C39109598586575FB0CBCD/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "scriptum_image": "https://images.steamusercontent.com/ugc/11605380554018906578/C89A2DFA05DFFA01EECE5D01F74BFEC355DED8FF/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "manual_image": "https://images.steamusercontent.com/ugc/15350833015911593758/9B093006760F620A00B3727ADB4F81932A7B2CD0/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "docs_link": "https://consulscriptum.com/attila",
        "compatibility_text": "Modifies only the [b]all_scripted.lua[/b] entry point. Compatible with virtually everything, save game compatible.",
    },
    "tob": {
        "youtube_id": "YOUR_YOUTUBE_VIDEO_ID",
        "interface_image": "https://images.steamusercontent.com/ugc/16988052029949233469/C5BE5EB74DC0A02F7F2E9DB0D0099827EB7B315A/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "consul_image": "https://images.steamusercontent.com/ugc/17036728790708406025/0A9651581C3D1AF0D86D2DBEF6A5952334D3C2A1/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "console_image": "https://images.steamusercontent.com/ugc/10820139722107472780/EA230A3029BC0ED8F2C39109598586575FB0CBCD/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "scriptum_image": "https://images.steamusercontent.com/ugc/11605380554018906578/C89A2DFA05DFFA01EECE5D01F74BFEC355DED8FF/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "manual_image": "https://images.steamusercontent.com/ugc/15350833015911593758/9B093006760F620A00B3727ADB4F81932A7B2CD0/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "docs_link": "https://consulscriptum.com/tob",
        "compatibility_text": "Modifies only the [b]all_scripted.lua[/b] entry point. Compatible with virtually everything, save game compatible.",
    }
}

SCRIPTS = [
    ("[b]Ad Rebellos[/b] — Spawns a rebellion in the selected settlement.", ["rome2", "attila", "tob"]),
    ("[b]Adice Provinciam[/b] — Transfers settlement ownership to another faction.", ["rome2", "attila", "tob"]),
    ("[b]Casus Belli[/b] — Forces a war declaration between two selected factions.", ["rome2", "attila", "tob"]),
    ("[b]Custodes Vocati[/b] — Exchanges the garrison of a settlement with a field army.", ["rome2", "attila"]),
    ("[b]Exterminare[/b] — Kills any selected character.", ["rome2", "attila", "tob"]),
    ("[b]Impetus[/b] — Fully restores action points for any selected character.", ["rome2", "attila", "tob"]),
    ("[b]Incrementum[/b] — Grants +1 Growth Point to the selected settlement.", ["rome2", "attila"]),
    ("[b]Pax Aeterna[/b] — Forces a peace agreement between two selected factions.", ["rome2", "attila", "tob"]),
    ("[b]Sedatio[/b] — Boosts public order by +10 across the selected settlement's province.", ["rome2", "attila"]),
    ("[b]Subiugatio[/b] — Forces vassalage between two selected factions.", ["rome2", "attila", "tob"]),
    ("[b]Vexatio[/b] — Penalizes public order by -10 across the selected settlement's province.", ["rome2", "attila"]),
]

def generate_scripts_list(game_id):
    lines = []
    for text, supported_games in SCRIPTS:
        if game_id in supported_games:
            lines.append(f"[*]{text}")
    return "\n".join(lines)

def main():
    template_path = os.path.join(os.path.dirname(__file__), "description_template.txt")
    with open(template_path, "r", encoding="utf-8") as f:
        template = f.read()

    for game_id, config in GAMES.items():
        scripts_list = generate_scripts_list(game_id)
        
        content = template.format(
            youtube_id=config["youtube_id"],
            interface_image=config["interface_image"],
            consul_image=config["consul_image"],
            console_image=config["console_image"],
            scriptum_image=config["scriptum_image"],
            manual_image=config["manual_image"],
            docs_link=config["docs_link"],
            compatibility_text=config["compatibility_text"],
            included_scripts=scripts_list
        )
        
        output_filename = f"{game_id}_description.txt"
        output_path = os.path.join(os.path.dirname(__file__), output_filename)
        
        with open(output_path, "w", encoding="utf-8") as f:
            f.write(content)
        
        print(f"Generated {output_filename}")

if __name__ == "__main__":
    main()
