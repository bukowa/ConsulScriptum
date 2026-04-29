

-- clear out loaded files
system.ClearRequiredFiles();

-- load in battle script library
require "lua_scripts.Battle_Script_Header";

-- load in generic prologue advice file
package.path = package.path .. ";data/Script/default_battle/?.lua";

bm = battle_manager:new(empire_battle:new());
eh = event_handler:new(AddEventCallBack);

bm:out("");
bm:out("* No battle script defined - default script loaded *");
bm:out("");

--[[
if core:is_tweaker_set("ALLOW_ADVICE_IN_CUSTOM_BATTLE") then
	bm:out("\tLoading advice");
	require("wh_battle_advice");
else
	bm:out("\tNot loading advice");
end;
]]


if ScriptedValueRegistry:new():LoadBool("battle_loaded_from_campaign") or is_tweaker_set("SHOW_ADVICE_IN_CUSTOM_BATTLE") then
	bm:out("Loading advice");
	require("battle_advice");
else
	bm:out("Not loading advice");
end;

consul.ui._UIComponent = UIComponent
consul.ui.tob.OnUICreated()
consul.bm = bm
consul.is_in_battle_script = true

if consul.uidebug.is_hooked then
    function __consul_tob_uidebug_battle_single_shot_timer()
        consul.uidebug.process_commands()
    end

    consul.bm:register_repeating_timer("__consul_tob_uidebug_battle_single_shot_timer", 0.5)
end
