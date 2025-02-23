CONSUL = {
    VERSION = "0.1.0",
    AUTHOR = "Mateusz Kurowski",
    CONTACT = "gitbukowa@gmail.com",

    CONFIG = {
        FILE = "consul.config",
        DEFAULT = [[
consul.root.visible=0
consul.root.position.x=0
consul.root.position.y=0
consul.consul.visible=1
consul.scriptum.visible=1
]],
    },
    COMPONENT = {
        ROOT = "consul_scriptum",
        BUTTON_TOGGLE = {
            ROOT = "consul_scriptum_button_toggle",
        },
        CONSOLE = {
            ROOT = "consul_scriptum_console",
        },
        CONSUL = {
            ROOT = "room_list",
            TOGGLE_BUTTON = "room_list_button_minimize"
        },
        SCRIPTUM = {
            ROOT = "friends_list",
            TOGGLE_BUTTON = "friends_list_button_minimize"
        }
    }
}
