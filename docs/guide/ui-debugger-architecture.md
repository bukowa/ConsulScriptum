# UI Debugger Architecture

This document explains the technical architecture behind the Consul UI Debugger, detailing how the game communicates with the external browser-based frontend, and outlining the roadmap for future development.

## Core Architecture

The UI Debugger operates on a decoupled architecture consisting of two main components:
1. **The Backend (Game Interface):** Written in Lua (`src/consul/consul_uidebug.lua` and `src/consul/consul.lua`), running inside the Total War engine.
2. **The Frontend (User Interface):** An HTML/JS single-page application (`tools/consul_uidebug.html`), running in a modern web browser.

These two environments do not share memory and cannot communicate via standard network sockets (due to game engine limitations). Instead, they communicate asynchronously through the local file system using the **File System Access API**.

### State Synchronization (Game to Frontend)

1. **Tree Traversal:** The game utilizes a recursive function (`traverse_ui` in `consul_uidebug.lua`) to traverse the entire UI component tree, capturing properties like Address, Id, Bounds, Visibility, etc.
2. **State Dumping:** The collected data is serialized and dumped into a local text file named `consul_debug_ui_state.txt`. This process can be triggered manually or run automatically during specific events.
3. **Frontend Polling:** The HTML frontend uses the browser's File System Access API (`showDirectoryPicker`) to obtain read access to the directory. It rapidly polls `consul_debug_ui_state.txt` (e.g., every 250ms).
4. **Parsing & Rendering:** When a modification is detected, the frontend reads the file, parses the hierarchy, and dynamically re-renders the interactive DOM tree, ensuring the UI explorer accurately reflects the game's current UI state.

### Command Execution (Frontend to Game)

To achieve two-way communication and allow the debugger to actually *modify* the game UI in real-time, a command file mechanism is utilized:

1. **Input Generation:** When a user modifies a property in the frontend (e.g., changing opacity or position), the frontend generates a string of valid Lua code (e.g., `local c = consul.uidebug.cache["0x123"]; if c then c:SetOpacity(200) end`).
2. **Command Writing:** The frontend writes this Lua snippet to a separate file named `consul_debug_ui_command.txt`.
3. **TimeTrigger Processing:** Inside the game, a `TimeTrigger` event periodically checks for the existence and contents of `consul_debug_ui_command.txt` (handled via `uidebug.process_commands()`).
4. **Execution & Cleanup:** If a command is found:
   - The game reads the file and clears it immediately to prevent duplicate executions.
   - It uses `loadstring` to compile and safely execute (`pcall`) the Lua snippet.
   - It immediately forces a fresh UI tree dump (`uidebug.dump_tree`) so that the frontend polls the newly updated state, completing the real-time feedback loop.

---

### Schema-Driven Architecture (New Implementation)

To support the massive list of properties efficiently, the debugger now operates on a **Schema-Driven Architecture**. This completely removes the need for spaghetti HTML and manual serialization.

### 1. The Property Index Protocol
To ensure Lua and JS never fall out of sync, they iterate over an identical, strictly ordered list of properties:
- **Lua:** `uidebug.PROPERTIES = { "Id", "Address", "CallbackId", ... }`
- **JS:** `const UI_PROPERTIES = [ "Id", "Address", "CallbackId", ... ]`

The Lua backend safely calls each property in the array and dumps the values using a robust separator (`<||_CONSUL_SEP_||>`). The JavaScript frontend simply splits the string by this separator and maps the values back to the exact same index. To add a new property, you only need to append it to both lists.

### 2. Functional JS Schema
The HTML file defines a `UI_SCHEMA` object that controls how each property is rendered and updated. Instead of hardcoded DOM elements, the schema defines the data type and the functional logic for generating Lua commands:

```javascript
const UI_SCHEMA = {
    "Visible": { type: "boolean", setter: (v) => `c:SetVisible(${v === 'true'})` },
    "Position": { type: "vector2", setter: (v) => { ... } },
    "SimulateClick": { type: "action", setter: () => `c:SimulateClick()` }
};
```
When a node is selected, the inspector dynamically generates inputs (textareas, dropdowns, buttons) based strictly on this schema.

### Game-Specific Support

The debugger supports properties across different Total War engines, adapting to the target game (`consul_build` variable). 

#### Core & Rome II Properties
The following properties are currently mapped or planned for Rome II:
`Address`, `Adopt`, `AttachCustomControl`, `Bounds`, `CallbackId`, `ChildCount`, `CurrentAnimationId`, `CurrentState`, `CurrentStateUI`, `DestroyChildren`, `Dimensions`, `Divorce`, `DockingPoint`, `Find`, `FindPositionIntoCurrentText`, `FindTextSnapPosition`, `ForceEvent`, `GetProperty`, `GetStateText`, `GetStateTextDetails`, `GetTooltipText`, `GlobalExists`, `HasInterface`, `Height`, `Highlight`, `Id`, `InterfaceFunction`, `IsCharPrintable`, `IsDragged`, `IsInteractive`, `IsMouseOverChildren`, `IsMoveable`, `Layout`, `LockPriority`, `LuaCall`, `MoveTo`, `Parent`, `PopulateTextures`, `Position`, `Priority`, `PropagateImageColour`, `PropagateOpacity`, `PropagatePriority`, `PropagateVisibility`, `ReorderChildren`, `Resize`, `RestoreUIHeirarchy`, `RunScript`, `SaveUIHeirarchy`, `SequentialFind`, `SetDisabled`, `SetDockingPoint`, `SetDragged`, `SetEventCallback`, `SetGlobal`, `SetImageColour`, `SetImageRotation`, `SetInteractive`, `SetMoveable`, `SetOpacity`, `SetProperty`, `SetState`, `SetStateColours`, `SetStateText`, `SetStateTextDetails`, `SetStateTextXOffset`, `SetTooltipText`, `SetVisible`, `ShaderTechniqueGet`, `ShaderTechniqueSet`, `ShaderVarsGet`, `ShaderVarsSet`, `SimulateClick`, `SimulateKey`, `StealInputFocus`, `StealShortcutKey`, `TextDimensions`, `TextShaderTechniqueSet`, `TextShaderVarsGet`, `TextShaderVarsSet`, `TriggerAnimation`, `TriggerShortcut`, `UnLockPriority`, `Visible`, `Width`, `WidthOfTextLine`, `new`

#### Total War: Attila
Attila expands upon the Rome II foundation. Properties strictly tagged with `games: ["Attila"]` in the schema (such as `ClearSound`, `SimulateLClick`) will only render when the game context is Attila.

#### API References (Total War Saga: Troy)
While we do not actively develop tools for *Total War Saga: Troy*, the underlying UI architecture remains largely similar to older titles. Because there is no official UI component documentation for Rome II or Attila, we use the extensive Troy documentation available via [ChadVandy's Modding Resources](https://chadvandy.github.io/tw_modding_resources/Troy/campaign/uicomponent.html#) as a primary reference to understand how most of these undocumented UI functions operate.
