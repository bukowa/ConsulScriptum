# UI Debugger Coverage Map (Source of Truth)

This document tracks the implementation status of `UIComponent` methods within the Consul UI Debugger. It serves as the reference for feature parity between games and identifying missing functionality.

## 1. Core Properties (Getters)
These are properties extracted during the UI tree crawl in `consul_uidebug.lua`.

| Property | Rome II | Attila | Status | Note |
| :--- | :---: | :---: | :---: | :--- |
| `Id` | ✅ | ✅ | ✅ | Primary identifier |
| `Address` | ✅ | ✅ | ✅ | Memory address (hex) |
| `Priority` | ✅ | ✅ | ✅ | Z-order priority |
| `Visible` | ✅ | ✅ | ✅ | Visibility state |
| `IsInteractive` | ✅ | ✅ | ✅ | Responds to mouse/keys |
| `Position` | ✅ | ✅ | ✅ | X,Y screen coordinates |
| `Bounds` | ✅ | ✅ | ✅ | Full bounding box |
| `Dimensions` | ✅ | ✅ | ✅ | Width x Height |
| `GetStateText` | ✅ | ✅ | ✅ | Localized text content |
| `GetTooltipText` | ✅ | ✅ | ✅ | Hover tooltip text |
| `Opacity` | 🚫 | ✅ | ⚠️ | Getter exists in Attila only |
| `CurrentState` | ✅ | ✅ | ✅ | Current active state name |
| `ChildCount` | ✅ | ✅ | ✅ | Number of direct children |
| `Height` / `Width` | ✅ | ✅ | ✅ | Individual dimensions |
| `TextDimensions` | ✅ | ✅ | ✅ | Area occupied by text |
| `CurrentAnimationId` | ✅ | ✅ | ✅ | Running animation |
| `IsDragged` | ✅ | ✅ | ✅ | Drag state |
| `IsMoveable` | ✅ | ✅ | ✅ | Can be moved by user |
| `IsMouseOverChildren` | ✅ | ✅ | ✅ | Hover state propagation |
| `Layout` | ✅ | ✅ | ✅ | Current layout type |
| `GetStateTextDetails` | ✅ | ✅ | ✅ | Extended text info |
| `CallbackId` | ✅ | ✅ | ✅ | Internal engine callback |
| `NumStates` | 🚫 | 🚫 | 👻 | **GHOST**: Not in API docs |
| `IsDisabled` | 🚫 | 🚫 | 👻 | **GHOST**: Use `SetDisabled` only |
| `VisibleFromRoot` | 🚫 | 🚫 | 👻 | **GHOST**: Not in API docs |
| `IsCharPrintable` | ✅ | ✅ | ❌ | Missing from debugger |
| `CurrentStateUI` | ✅ | ✅ | ❌ | Returns state UIComponent |
| `HasInterface` | ✅ | ✅ | ❌ | Checks component interface |
| `WidthOfTextLine` | ✅ | ✅ | ❌ | Requires line index param |
| `Parent` | ✅ | ✅ | ⚠️ | Tracked in Lua, missing in UI |
| `DockingPoint` | ✅ | ✅ | ❌ | Component anchor point |
| `GlobalExists` | ✅ | ✅ | ❌ | Check engine global |
| `InterfaceFunction` | ✅ | ✅ | ❌ | Call internal interface |
| `ShaderTechniqueGet` | ✅ | ✅ | ❌ | Get rendering technique |
| `ShaderVarsGet` | ✅ | ✅ | ❌ | Get shader parameters |
| `TextShaderVarsGet` | ✅ | ✅ | ❌ | Get text shader params |
| `GetProperty` | ✅ | ✅ | ❌ | Dynamic property access |

## 2. State Modifiers (Setters)
These are triggered via `dispatchCommand` from the HTML property grid.

| Action / Setter | Rome II | Attila | Status | Note |
| :--- | :---: | :---: | :---: | :--- |
| `SetVisible` | ✅ | ✅ | ✅ | Toggle visibility |
| `SetInteractive` | ✅ | ✅ | ✅ | Toggle interaction |
| `SetDragged` | ✅ | ✅ | ✅ | Force drag state |
| `SetMoveable` | ✅ | ✅ | ✅ | Toggle moveability |
| `SetDisabled` | ✅ | ✅ | ✅ | Toggle disabled state |
| `PropagatePriority` | ✅ | ✅ | ✅ | Set priority (recursive) |
| `SetOpacity` | ✅ | ✅ | ✅ | Set alpha transparency |
| `SetDockingPoint` | ✅ | ✅ | ✅ | Anchor point control |
| `MoveTo` | ✅ | ✅ | ✅ | Manual positioning |
| `Resize` | ✅ | ✅ | ✅ | Manual sizing |
| `SetStateText` | ✅ | ✅ | ✅ | Update text content |
| `SetTooltipText` | ✅ | ✅ | ✅ | Update tooltip |
| `SetState` | ✅ | ✅ | ✅ | Switch component state |
| `SetImageColour` | ✅ | ✅ | ❌ | Needs RGBA picker |
| `SetImageRotation` | ✅ | ✅ | ❌ | Needs degree input |
| `SetStateColours` | ✅ | ✅ | ❌ | Advanced styling |
| `SetStateTextXOffset` | ✅ | ✅ | ❌ | Text positioning tweak |
| `StealInputFocus` | ✅ | ✅ | ❌ | Force input capture |
| `SetGlobal` | ✅ | ✅ | ❌ | Set component global var |
| `PropagateImageColour` | ✅ | ✅ | ❌ | Recursive colour set |
| `PropagateOpacity` | ✅ | ✅ | ❌ | Recursive alpha set |
| `PropagateVisibility` | ✅ | ✅ | ❌ | Recursive visibility |
| `SetEventCallback` | ✅ | ✅ | ❌ | Scripted event hook |
| `SetProperty` | ✅ | ✅ | ❌ | Set engine property |
| `SetStateTextDetails` | ✅ | ✅ | ❌ | Advanced text formatting |
| `SetTooltipTextWithRLSKey` | 🚫 | ✅ | ❌ | Localized tooltip (RLS) |
| `ShaderTechniqueSet` | ✅ | ✅ | ❌ | Set rendering technique |
| `ShaderVarsSet` | ✅ | ✅ | ❌ | Set shader parameters |
| `TextShaderTechniqueSet` | ✅ | ✅ | ❌ | Set text shader tech |
| `TextShaderVarsSet` | ✅ | ✅ | ❌ | Set text shader params |

## 3. Interactive Actions
One-shot functions triggered by buttons in the "Actions" section of the debugger.

| Method | Rome II | Attila | Status | Note |
| :--- | :---: | :---: | :---: | :--- |
| `SimulateClick` | ✅ | ✅ | ✅ | Generic click |
| `SimulateLClick` | 🚫 | ✅ | ⚠️ | Attila-only |
| `SimulateRClick` | 🚫 | ✅ | ⚠️ | Attila-only |
| `SimulateMouseOn` | 🚫 | ✅ | ⚠️ | Attila-only |
| `SimulateMouseOff` | 🚫 | ✅ | ⚠️ | Attila-only |
| `ClearSound` | 🚫 | ✅ | ⚠️ | Attila-only |
| `DestroyChildren` | ✅ | ✅ | ✅ | Wipe child hierarchy |
| `Highlight` | ✅ | ✅ | ❌ | **PRIORITY**: Visual ID |
| `TriggerAnimation` | ✅ | ✅ | ❌ | Needs animation ID input |
| `SimulateMouseMove` | 🚫 | ✅ | ❌ | Mouse movement simulation |
| `CreateComponent` | 🚫 | ✅ | ❌ | Dynamic UI creation |
| `RunScript` | ✅ | ✅ | ❌ | Run script on component |
| `Adopt` | ✅ | ✅ | ❌ | Reparent component |
| `AttachCustomControl` | ✅ | ✅ | ❌ | Custom engine control |
| `Divorce` | ✅ | ✅ | ❌ | Remove from parent |
| `Find` | ✅ | ✅ | ❌ | Search for child |
| `FindPositionIntoCurrentText` | ✅ | ✅ | ❌ | Text cursor positioning |
| `FindTextSnapPosition` | ✅ | ✅ | ❌ | UI snap to text |
| `ForceEvent` | ✅ | ✅ | ❌ | Manually trigger event |
| `LockPriority` | ✅ | ✅ | ❌ | Freeze Z-order |
| `LuaCall` | ✅ | ✅ | ❌ | Script-to-UI callback |
| `PopulateTextures` | ✅ | ✅ | ❌ | Force texture load |
| `ReorderChildren` | ✅ | ✅ | ❌ | Adjust child Z-order |
| `RestoreUIHeirarchy` | ✅ | ✅ | ❌ | Reset structure |
| `SaveUIHeirarchy` | ✅ | ✅ | ❌ | Persist structure |
| `SequentialFind` | ✅ | ✅ | ❌ | Ordered child search |
| `SimulateKey` | ✅ | ✅ | ❌ | Keyboard simulation |
| `StealShortcutKey` | ✅ | ✅ | ❌ | Override engine keys |
| `TriggerShortcut` | ✅ | ✅ | ❌ | Fire shortcut event |
| `UnLockPriority` | ✅ | ✅ | ❌ | Unfreeze Z-order |

## 4. Planned Improvements
1.  **Visual Highlight**: Add a button to call `c:Highlight(true)` to see the component flicker in-game.
2.  **Parent Navigation**: Display the Parent Address and allow "jumping" to it.
3.  **Search/Filter**: Filter the tree by ID or StateText.
4.  **Custom Property Fetcher**: Input box to call `GetProperty(key)` on the selected component.
5.  **Clean up Ghosts**: Remove `NumStates`, `IsDisabled`, and `VisibleFromRoot` from the Lua properties list to reduce log noise.

