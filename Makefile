MOD_FILE_NAME="consulscriptum.pack"
#IMG_FILE_NAME="consulscriptum.png"

build:
	rpfm_cli --game rome_2 pack create --pack-path=${MOD_FILE_NAME}
	rpfm_cli --game rome_2 pack add --pack-path=${MOD_FILE_NAME} -F './pack;'

copy: build
	cp ${MOD_FILE_NAME} "C:\Games\Total War - Rome 2\data"
	#cp ${IMG_FILE_NAME} "C:\Games\Total War - Rome 2\data"

kill:
	python -u scripts/kill_rome.py && sleep 1 || true

start:
	start "" ./scripts/run.lnk

setmod:
	echo 'mod "consulscriptum.pack";' > "${HOME}/AppData\Roaming\The Creative Assembly\Rome2\scripts/user.script.txt"


all: build kill copy setmod start