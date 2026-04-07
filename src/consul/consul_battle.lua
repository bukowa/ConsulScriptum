-- load in battle script library
require "lua_scripts.Battle_Script_Header";

-- declare battlemanager object
bm = battle_manager:new(empire_battle:new());

-- consul
require 'consul'

-- ui handling
-- UIComponent is nil when UICreated fires,
-- we have to grab it here and recreate the UIRoot
consul.ui._UIComponent = UIComponent
if consul_build == "Rome2" then
    local layout = UIComponent(bm:ui_component('layout'))
    consul.ui._UIRoot = UIComponent(layout:Parent())
end
if consul_build == "Attila" then
    consul.ui._UIRoot = UIComponent(consul.ui._UIContextComponent)
end

_G.consul = consul
_G.bm = bm
consul.bm = bm
consul.is_in_battle_script = true
-- consul end

if consul_build == "Attila" then
    table.insert(events.PanelOpenedBattle, function(context)
        consul.ui.attila.OnUICreated({})
    end)
end
