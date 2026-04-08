# Consul Scripts

This guide is the simplest flow to add one custom Consul script.

## Before You Start

If you don't have make installed, follow the setup steps in the [Build guide](./build.md#windows-setup-step-by-step).

## Step 1) Add the Consul entry

Run this once per game; if your script supports both games, run it two times (`GAME=Attila` and `GAME=Rome2`).

```bash
make GAME=Attila insert-consul-entry \
  ARG1='consul_my_feature' \
  ARG2='Your tooltip description.' \
  ARG3='Your Latin Name'
```

## Step 2) Edit `src/consul/consul.lua`

In this example, you create a `create_two_faction_script` and wire it to UI.
Edit these exact anchors:<br>
`consul.ui = {}`<br>
`consul.consul_scripts_v2.initialize()`<br>
`consul.consul_scripts.OnComponentLClickUp()` - `click_map`.

```lua
-- 1) consul.ui = { ... }
consul.ui = {
    -- ...existing keys...
    consul_my_feature_entry = "consul_my_feature_entry",
    consul_my_feature_script = "consul_my_feature_script",
}

-- 2) consul.consul_scripts_v2.initialize() for a two-faction action
scripts.instances["my_feature"] = scripts.create_two_faction_script(
    "my_feature",
    function(faction1, faction2)
        consul._game():force_make_peace(faction1, faction2)
    end,
    "Forcing peace between"
)

-- 3) consul.consul_scripts.OnComponentLClickUp -> click_map (same for both)
local click_map = {
    -- ...existing entries...
    [ui.consul_my_feature_entry] = {
      script = scripts2.instances.my_feature,
      component = ui.consul_my_feature_script,
      log_msg = "Clicked on consul_my_feature"
  }
}
```

## Step 2.1) If you need advanced custom logic

`create_two_faction_script(...)` returns a script object with `setup()`, `start()`, and `stop()`; use helpers for common patterns, and write a custom object when you need multi-step or special behavior.

```lua
-- A) custom script object in consul.consul_scripts
consul.consul_scripts.my_feature = {
    
    -- 1. Setup is executed only once, when the mod loads for the first  time.
    setup = function()
        local scripts = consul.consul_scripts
        
        -- Ensure the event handler tables exist 
        -- before trying to assign keys inside them
        scripts.event_handlers['SomeGameEvent'] =
            scripts.event_handlers['SomeGameEvent'] or {}
            
        scripts.event_handlers['SettlementSelected'] = 
            scripts.event_handlers['SettlementSelected'] or {}
        
        -- Clear any existing handlers for this feature to ensure a clean state
        scripts.event_handlers['SomeGameEvent']['my_feature'] = nil
        scripts.event_handlers['SettlementSelected']['my_feature'] = nil
    end,
    
    -- 2. Triggered when the Consul menu entry is selected (highlighted green).
    start = function()
        local scripts = consul.consul_scripts
        
        scripts.event_handlers['SomeGameEvent']['my_feature'] = 
        function(context)
            if not context:character():faction():is_human() then return end
        end

        scripts.event_handlers['SettlementSelected']['my_feature'] = 
        function(context)
            -- your action here
        end
    end,
    
    -- 3. Triggered when the entry is deselected (no longer green). 
    stop = function()
        local scripts = consul.consul_scripts
        
        -- We set these to nil to stop listening to the events.
        scripts.event_handlers['SomeGameEvent']['my_feature'] = nil
        scripts.event_handlers['SettlementSelected']['my_feature'] = nil
    end
}

-- B) wire it in consul.consul_scripts.OnComponentLClickUp() -> click_map
local click_map = {
    -- ...existing entries...
    [ui.consul_my_feature_entry] = {
        script = scripts.my_feature,
        component = ui.consul_my_feature_script,
        log_msg = "Clicked on consul_my_feature"
    }
}
```

## Step 3) Regenerate docs

Run this after adding or renaming a script entry.

```bash
py ./scripts/generate_consul_scripts_docs.py
```

## Step 4) Optional: Submit Changes

If you want to share your script in the main repo, open a pull request on GitHub:

- [ConsulScriptum Pull Requests](https://github.com/bukowa/ConsulScriptum/pulls)
