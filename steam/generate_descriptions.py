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
        "compatibility_text": "Modifies only the [b]all_scripted.lua[/b] [b]menu_bar[/b] [b]sp_frame.xml[/b].\nCompatible with everything, save game compatible.",
        "debug_image": "https://images.steamusercontent.com/ugc/10705253734120946644/1E1A6CECE39CEE1423071FADAB30D8059F4F4C52/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "debugui_image": "https://images.steamusercontent.com/ugc/17770116618949680108/CB63C850E0E87D2AC101956231F1400932AC1B34/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
    },
    "attila": {
        "youtube_id": "6WbE6nKbPTQ",
        "interface_image": "https://images.steamusercontent.com/ugc/11728230172789067062/EC9C0B54987C275304C96C37A61EB07725657D48/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "consul_image": "https://images.steamusercontent.com/ugc/13084413983348014747/FF62B03651F469A4B106AF56673C354309DE3C1E/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "console_image": "https://images.steamusercontent.com/ugc/9393493980529326132/C56BDB4C37EAC4B873CE7259969D47AA00150096/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "scriptum_image": "https://images.steamusercontent.com/ugc/15046468668295812664/EEB226321FAAC39FCF184C1EDC3D5F1EC751930B/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "manual_image": "https://images.steamusercontent.com/ugc/12572422953631299009/9B093006760F620A00B3727ADB4F81932A7B2CD0/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "docs_link": "https://consulscriptum.com/attila",
        "compatibility_text": "Modifies only the [b]all_scripted.lua[/b] entry point.\nCompatible with virtually everything, save game compatible.",
        "debug_image": "https://images.steamusercontent.com/ugc/10705253734120946644/1E1A6CECE39CEE1423071FADAB30D8059F4F4C52/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "debugui_image": "https://images.steamusercontent.com/ugc/10705253734120946644/1E1A6CECE39CEE1423071FADAB30D8059F4F4C52/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
    },
    "tob": {
        "youtube_id": "6WbE6nKbPTQ",
        "interface_image": "https://images.steamusercontent.com/ugc/9717864786029459653/05FFA0181EAAB76C0B53610332338FCDDCDFE598/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "consul_image": "https://images.steamusercontent.com/ugc/14649163570047731721/8B72C00D2BAFB48A7DF53555D71EE10AB852A30E/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "console_image": "https://images.steamusercontent.com/ugc/17707165145996182708/4785DD3BC9D6769718B7A2D2DB77F5F6C8952E78/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "scriptum_image": "https://images.steamusercontent.com/ugc/10805962928374584558/55DD16022A8AD6F3ED469BFF0E13F2BF68A74433/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "manual_image": "https://images.steamusercontent.com/ugc/15350833015911593758/9B093006760F620A00B3727ADB4F81932A7B2CD0/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "docs_link": "https://consulscriptum.com/tob",
        "compatibility_text": "Modifies only the [b]all_scripted.lua[/b] entry point.\nCompatible with virtually everything, save game compatible.",
        "debug_image": "https://images.steamusercontent.com/ugc/10705253734120946644/1E1A6CECE39CEE1423071FADAB30D8059F4F4C52/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
        "debugui_image": "https://images.steamusercontent.com/ugc/10705253734120946644/1E1A6CECE39CEE1423071FADAB30D8059F4F4C52/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
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
            included_scripts=scripts_list,
            debug_image=config['debug_image'],
            debugui_image=config['debugui_image']
        )
        
        output_filename = f"{game_id}_description.txt"
        output_path = os.path.join(os.path.dirname(__file__), output_filename)
        
        with open(output_path, "w", encoding="utf-8") as f:
            f.write(content)
        
        print(f"Generated {output_filename}")

if __name__ == "__main__":
    main()
