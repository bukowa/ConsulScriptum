---
next:
  text: Scripting Manual
  link: /guide/scripting-manual
---

# Debugging The UI

Consul Scriptum includes tools to inspect the game's User Interface hierarchy directly. By using the UI debugging
commands, you can identify component IDs, understand nested structures, and find exactly what you need to target in your
scripts.


:::tabs key:game

== Attila
<video :src="$withBase('/videos/attila_debugging_ui.mp4')" data-title="Killing Multiple Characters" data-game="Attila" autoplay loop muted playsinline></video>

== Rome II
<video :src="$withBase('/videos/rome2_debugging_ui.mp4')" data-title="Transferring Settlement & Killing Character" data-game="Rome II" autoplay loop muted playsinline></video>

:::

## The /debug_mouseover Command

To start hover debugging, type the following command:

```
/debug_mouseover
```

Once active, metadata for any UI element you hover over is printed in real-time.

## The /debug_onclick Command

To start click debugging, type the following command:

```
/debug_onclick
```

Information is printed only when you explicitly click on a UI component.

## How It Works

When either UI debug mode is active, the console will automatically clear and refresh with information about the
component you are currently interacting with.

### Example Output

```text
Hierarchy:  root > battle_setup > dock_area > main
--------------------------------------------------------------------------------
Id:                          listview_army
Address:                     Pointer<Component> (0x009ba318c)
Visible:                     true
IsInteractive:               true
CurrentState:                NewState
Priority:                    10
Position:                    61, 438
Bounds:                      344, 628
Dimensions:                  328, 628
Width:                       328
Height:                      628
TextDimensions:              0, 0, 0
--------------------------------------------------------------------------------
```

This trace tells you exactly how the component is nested within the UI tree. 
<br>This is useful for:

- Finding the unique ID of a component.
- Understanding the layout structure.
- Verifying the parent-child relationships.

### Raw Components vs. Wrapped UIComponents

> [!WARNING]
> Every function that returns a component — and every event that provides a component in its context — gives you a **raw** C++ pointer. You **must** wrap it with `UIComponent(...)` before calling any methods on it.

The game differentiates between UIComponents in two ways: first, there is a raw component address reference in the C++
game, and second, there is the wrapper named "UIComponent" that is used in Lua. You cannot interact with the raw component
address; you must wrap it first in the UIComponent wrapper to be able to use it in Lua. This is a common source of
confusion and errors, so always make sure you are working with the wrapped UIComponent when trying to interact with the
UI in your scripts.

For example, imagine getting a handle for a component in an event like this:

```lua
-- listening for the click event, in the context we will receive the raw component clicked
table.insert(events.ComponentLClickUp, function(context)
    -- this is a raw component reference, you cannot use it directly
    local component = context.component 
    -- this is the wrapped component, now you can use it in your Lua scripts
    local wrapped_component = UIComponent(component) 
    -- this is how you can interact with the component, by using the wrapped version of it
    local children = wrapped_component:Find("child_id")
    -- again, if the function returns a component, you have to wrap it first before using it
    -- remember that the Find function can return nil if the child is not found
    if children then
        local wrapped_child = UIComponent(children)
        -- now you can interact with the child component as well
        wrapped_child:SimulateClick()
    end
end)
```

## Interacting With Components

To start interacting with components, you should first grab a handle to the UI Root component (the top-level parent of
all UI elements).
There are two options that are guaranteed to work:

#### While Consul mod is active:

Consul provides its own reference to the UI Root handle, which is always up-to-date and safe to use in your scripts. You
can access it via:

```lua
ui_root = consul._UIRoot
```

Consul provides another shortcut that is extremely well-suited while working with the console. You can use the
`consul.ui.find("id")` function to find any component by its ID; this function will search through the entire UI tree
starting from the UI Root and return the first component that matches the given ID.
It's just a simple shortcut for the internal UIComponent:Find("id") function, but it also includes some error handling
and logging to make it easier to use in the console.

> [!TIP]
> **Auto-Wrapping**: Unlike `UIComponent:Find()`, `consul.ui.find()` returns an **already wrapped** component. You can call methods on it directly without the extra `UIComponent(...)` step.

Console example that prints the state text of the component with ID "listview_army":
```lua
/p consul.ui.find("listview_army"):GetStateText()
```

#### In your own Lua scripts:

Here it gets a bit trickier, but it is still a very simple process. This is the same way that the base games and Consul use to get
the UI Root.
You have to register an event listener for the UICreated event; keep in mind that registering this listener must happen early
in the lifecycle of your script (before the UI is created), otherwise you will miss the event and won't be able to get
the reference to the UI Root.

```lua
-- your global variable to hold the reference to the UI Root
ui_root = nil

-- listen for the event that is fired when the UI is created, 
-- this event will provide the raw component reference to the UI Root in its context
table.insert(events.UICreated, function(context)
    ui_root = UIComponent(context.component);
end)
```

## Practical Use: Clicking a Button via Lua

The UI debugging tools are the primary way to find IDs for use with the `consul.ui.find("id")` function.

1. Enable `/debug_mouseover`.
2. Hover over the button or panel you want to automate.
3. Look for the ID of the item in the console output.
4. Use that ID in your Lua scripts to interact with the component.

Console example:
```lua
consul.ui.find("<id-of-your-component>"):SimulateClick()
```
Lua script example:
```lua
-- assuming you have already obtained the ui_root 
-- reference as explained in the previous section
local raw_component = ui_root:Find("<id-of-your-component>")
local component = UIComponent(raw_component)
component:SimulateClick()
```

### Console Output Mirroring

Just like world debugging, all UI debug output is mirrored to the local file:

**`consul.output`** (located in your game root folder)

Use this file to copy-paste long UI chains or inspect complex nested structures without having to stay alt-tabbed in the
game.

## Common UIComponent Methods

Once you have a wrapped UIComponent, these are the most commonly used methods for inspecting and manipulating UI elements:

| Category | Method | What It Does |
| :--- | :--- | :--- |
| **Identity** | `Id()` | Returns the component's string ID |
| **Hierarchy** | `Find("id")` | Finds a child by ID (**returns raw!**) |
| **Hierarchy** | `Parent()` | Returns the parent component (**raw!**) |
| **Hierarchy** | `ChildCount()` | Number of direct children |
| **Visibility** | `Visible()` | Is the component visible? |
| **Visibility** | `SetVisible(bool)` | Show or hide the component |
| **State** | `CurrentState()` | Current visual state name |
| **State** | `SetState("state")` | Switch to a different visual state |
| **Text** | `GetStateText()` | Read the component's displayed text |
| **Text** | `SetStateText("text")` | Change the displayed text |
| **Text** | `GetTooltipText()` | Read the tooltip text |
| **Text** | `SetTooltipText("text")` | Set the tooltip text |
| **Interaction** | `SimulateClick()` | Programmatically click the component |
| **Interaction** | `SetInteractive(bool)` | Enable or disable user interaction |
| **Layout** | `Position()` | Get x, y position |
| **Layout** | `MoveTo(x, y)` | Move the component |
| **Layout** | `Resize(w, h)` | Resize the component |

> [!NOTE]
> Methods like `Find()` and `Parent()` return **raw** component pointers. Remember to wrap them with `UIComponent(...)` before calling further methods. See the [full method list](#further-reading-uicomponent-api) for your game below.

## Technical Overview

Under the hood, these commands register listeners for the `ComponentMouseOn` and `ComponentLClickUp` engine events. When
an event fires, Consul retrieves `UIComponent` and recursively traverses its `Parent()` property to build the ID
chain. It then safe-calls a suite of UI methods (using `pcall`) to gather the component's state without risking a game
crash. The resulting unified report is then pretty-printed to both the visual console and the log file.

## Further Reading: UIComponent API

The UIComponent methods in the ConsulScriptum API reference are **raw engine dumps** — they list which methods exist but don't include parameter documentation. For detailed descriptions of what each method does and its expected arguments, refer to the **Troy** documentation linked below.

> [!IMPORTANT]
> The Troy docs cover a **superset** of methods. Not all methods listed there are available in Rome II or Attila. Always check your game's API reference first to confirm a method exists before using it.

:::tabs key:game

== Rome II
- **Your game's methods**: [Rome II — UIComponent Reference](../reference/rome2-api#uicomponent)
- **Detailed docs (Troy)**: [Troy — UIComponent Documentation](https://chadvandy.github.io/tw_modding_resources/Troy/campaign/uicomponent.html#)

== Attila
- **Your game's methods**: [Attila — UIComponent Reference](../reference/attila-api#uicomponent)
- **Detailed docs (Troy)**: [Troy — UIComponent Documentation](https://chadvandy.github.io/tw_modding_resources/Troy/campaign/uicomponent.html#)

:::

> [!TIP]
> **Workflow**: First check your game's reference to confirm the method exists, then look it up in the Troy docs for the full description and parameter details.
