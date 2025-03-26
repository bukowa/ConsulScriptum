-- load in battle script library
require "lua_scripts.Battle_Script_Header";

-- declare battlemanager object
bm = battle_manager:new(empire_battle:new());

-- consul
require 'consul'
local layout = UIComponent(bm:ui_component('layout'))
consul.ui._UIRoot = UIComponent(layout:Parent())
consul.ui._UIComponent = UIComponent
_G.consul = consul
_G.bm = bm
consul.bm = bm
consul.is_in_battle_script = true
-- consul end
