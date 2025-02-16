MOD_FILE_NAME="consulscriptum.pack"
#IMG_FILE_NAME="consulscriptum.png"

# required
init:
	mkdir rpfm || true
	cd rpfm && \
	rpfm_cli --game rome_2 schemas update --schema-path ./

build:
	./contrib/etwng/xml2ui "./pack/ui/common ui/multiplayer_chat.xml" "./pack/ui/common ui/multiplayer_chat"
	./contrib/etwng/xml2ui "./pack/ui/common ui/menu_bar.xml" "./pack/ui/common ui/menu_bar"
	./contrib/etwng/xml2ui "./pack/ui/frontend ui/sp_frame.xml" "./pack/ui/frontend ui/sp_frame"
	rpfm_cli --game rome_2 pack create --pack-path=${MOD_FILE_NAME}
	rpfm_cli --game rome_2 pack add --pack-path=${MOD_FILE_NAME} -F './pack/;' -t contrib/rpfm/schema_rom2.ron

copy: build
	cp ${MOD_FILE_NAME} "C:\Games\Total War - Rome 2\data"
	cp ${MOD_FILE_NAME} "C:\Program Files (x86)\Steam\steamapps\common\Total War Rome II\data"
	#cp ${IMG_FILE_NAME} "C:\Games\Total War - Rome 2\data"

kill:
	python -u scripts/kill_rome.py && sleep 1 || true

start:
	start "" ./scripts/run.lnk

setmod:
	echo 'mod "consulscriptum.pack";' > "${HOME}/AppData\Roaming\The Creative Assembly\Rome2\scripts/user.script.txt"

all: build kill copy setmod start

steam: build kill copy