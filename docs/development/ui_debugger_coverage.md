# UI Debugger Coverage Map (Source of Truth)

This document tracks the implementation status of `UIComponent` methods within the Consul UI Debugger. It serves as the reference for feature parity between games and identifying missing functionality.

## 1. Core Properties (Getters)
These are properties extracted during the UI tree crawl in `consul_uidebug.lua`.

| Property | Rome II | Attila | Status | Tested | Note                         |
| :--- | :---: | :---: | :---: | :---: |:-----------------------------|
| `Id` | ✅ | ✅ | ✅ | ✅ | Primary identifier           |
| `Address` | ✅ | ✅ | ✅ | ✅ | Memory address (hex)         |
| `Priority` | ✅ | ✅ | ✅ | ✅ | Z-order priority             |
| `Visible` | ✅ | ✅ | ✅ | ✅ | Visibility state             |
| `IsInteractive` | ✅ | ✅ | ✅ | ✅ | Responds to mouse/keys       |
| `Position` | ✅ | ✅ | ✅ | ✅ | X,Y screen coordinates       |
| `Bounds` | ✅ | ✅ | ✅ | ✅ | Full bounding box            |
| `Dimensions` | ✅ | ✅ | ✅ | ✅ | Width x Height               |
| `GetStateText` | ✅ | ✅ | ✅ | ✅ | Localized text content       |
| `GetTooltipText` | ✅ | ✅ | ✅ | ✅ | Hover tooltip text           |
| `Opacity` | 🚫 | ✅ | ⚠️ | ✅ | Getter exists in Attila only |
| `CurrentState` | ✅ | ✅ | ✅ | ✅ | Current active state name    |
| `ChildCount` | ✅ | ✅ | ✅ | ✅ | Number of direct children    |
| `Height` / `Width` | ✅ | ✅ | ✅ | ✅ | Individual dimensions        |
| `TextDimensions` | ✅ | ✅ | ✅ | ✅ | Area occupied by text        |
| `IsDragged` | ✅ | ✅ | ✅ | ✅ | Drag state                   |
| `IsMoveable` | ✅ | ✅ | ✅ | ✅ | Can be moved by user         |
| `Parent` | ✅ | ✅ | ✅ | ✅ | Already known from the tree. |
| `IsMouseOverChildren` | ✅ | ✅ | ✅ | ✅ | Hover state propagation      |
| `HasInterface` | ✅ | ✅ | ✅ | ✅ | Checks component interface   |
| `DockingPoint` | ✅ | ✅ | ✅ | ✅ | Component anchor point       |
| `CurrentAnimationId` | ✅ | ✅ | ✅ | ❌ | Running animation            |
| `ShaderTechniqueGet` | ✅ | ✅ | ✅ | ❌ | Get rendering technique      |
| `ShaderVarsGet` | ✅ | ✅ | ✅ | ❌ | Get shader parameters        |
| `CallbackId` | ✅ | ✅ | ✅ | ❌ | Internal engine callback     |
| `GetStateTextDetails` | ✅ | ✅ | ✅ | ❌ | ?                            |
| `IsCharPrintable` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `CurrentStateUI` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `WidthOfTextLine` | ✅ | ✅ | ❌ | ❌ | Requires text string param   |
| `GlobalExists` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `InterfaceFunction` | ✅ | ✅ | ❌ | ❌ | Call internal interface      |
| `TextShaderVarsGet` | ✅ | ✅ | ❌ | ❌ | Get text shader params       |
| `GetProperty` | ✅ | ✅ | ❌ | ❌ | Dynamic property access      |

## 2. State Modifiers (Setters)
These are triggered via `dispatchCommand` from the HTML property grid.

| Action / Setter | Rome II | Attila | Status | Tested | Note                                        |
| :--- | :---: | :---: | :---: | :---: |:--------------------------------------------|
| `SetVisible` | ✅ | ✅ | ✅ | ✅ | Toggle visibility                           |
| `SetInteractive` | ✅ | ✅ | ✅ | ✅ | Toggle interaction                          |
| `SetDragged` | ✅ | ✅ | ✅ | ✅ | Force drag state                            |
| `SetMoveable` | ✅ | ✅ | ✅ | ✅ | Toggle moveability                          |
| `SetDisabled` | ✅ | ✅ | ✅ | ✅ | Toggle disabled state (Buttons)             |
| `PropagatePriority` | ✅ | ✅ | ✅ | ✅ | Set priority (recursive)                    |
| `SetOpacity` | ✅ | ✅ | ✅ | ✅ | Set alpha transparency                      |
| `MoveTo` | ✅ | ✅ | ✅ | ✅ | Manual positioning                          |
| `Resize` | ✅ | ✅ | ✅ | ✅ | Manual sizing                               |
| `SetStateText` | ✅ | ✅ | ✅ | ✅ | Update text content                         |
| `SetTooltipText` | ✅ | ✅ | ✅ | ✅ | Update tooltip                              |
| `SetState` | ✅ | ✅ | ✅ | ✅ | Switch component state                      |
| `SetDockingPoint` | ✅ | ✅ | ✅ | ✅ | Anchor point control                        |
| `StealInputFocus` | ✅ | ✅ | ❌ | ❌ | Steal all keyboard input (true/false param) |
| `TextShaderTechniqueSet` | ✅ | ✅ | ❌ | ❌ | Set text shader tech                        |
| `TextShaderVarsSet` | ✅ | ✅ | ❌ | ❌ | Set text shader params                      |
| `ShaderTechniqueSet` | ✅ | ✅ | ❌ | ❌ | Set rendering technique                     |
| `ShaderVarsSet` | ✅ | ✅ | ❌ | ❌ | Set shader parameters                       |
| `SetImageColour` | ✅ | ✅ | ❌ | ❌ | ?                                           |
| `SetImageRotation` | ✅ | ✅ | ❌ | ❌ | ?                                           |
| `SetStateColours` | ✅ | ✅ | ❌ | ❌ | ?                                           |
| `SetStateTextXOffset` | ✅ | ✅ | ❌ | ❌ | ?                                           |
| `SetGlobal` | ✅ | ✅ | ❌ | ❌ | ?                                           |
| `PropagateImageColour` | ✅ | ✅ | ❌ | ❌ | ?                                           |
| `SetEventCallback` | ✅ | ✅ | ❌ | ❌ | ?                                           |
| `SetProperty` | ✅ | ✅ | ❌ | ❌ | ?                                           |
| `SetStateTextDetails` | ✅ | ✅ | ❌ | ❌ | ?                                           |
| `SetTooltipTextWithRLSKey` | 🚫 | ✅ | ❌ | ❌ | ?                                           |
| `PropagateOpacity` | ✅ | ✅ | ❌ | ❌ | ?                                           |
| `PropagateVisibility` | ✅ | ✅ | ❌ | ❌ | ?                                           |

## 3. Interactive Actions
One-shot functions triggered by buttons in the "Actions" section of the debugger.

| Method | Rome II | Attila | Status | Tested | Note                         |
| :--- | :---: | :---: | :---: | :---: |:-----------------------------|
| `Find` | ✅ | ✅ | ❌ | ❌ | Search for child             |
| `SimulateClick` | ✅ | ✅ | ✅ | ❌ | Generic click                |
| `SimulateLClick` | 🚫 | ✅ | ⚠️ | ❌ | Attila-only                  |
| `SimulateRClick` | 🚫 | ✅ | ⚠️ | ❌ | Attila-only                  |
| `SimulateMouseOn` | 🚫 | ✅ | ⚠️ | ❌ | Attila-only                  |
| `SimulateMouseOff` | 🚫 | ✅ | ⚠️ | ❌ | Attila-only                  |
| `ClearSound` | 🚫 | ✅ | ⚠️ | ❌ | Attila-only                  |
| `DestroyChildren` | ✅ | ✅ | ✅ | ❌ | Wipe child hierarchy         |
| `Layout` | ✅ | ✅ | ✅ | ❌ | Force UI refresh/layout call |
| `SimulateMouseMove` | 🚫 | ✅ | ❌ | ❌ | Mouse movement simulation    |
| `CreateComponent` | 🚫 | ✅ | ❌ | ❌ | Dynamic UI creation          |
| `Highlight` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `TriggerAnimation` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `RunScript` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `Adopt` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `AttachCustomControl` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `Divorce` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `FindPositionIntoCurrentText` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `FindTextSnapPosition` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `ForceEvent` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `LockPriority` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `LuaCall` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `PopulateTextures` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `ReorderChildren` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `RestoreUIHeirarchy` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `SaveUIHeirarchy` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `SequentialFind` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `SimulateKey` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `StealShortcutKey` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `TriggerShortcut` | ✅ | ✅ | ❌ | ❌ | ?                            |
| `UnLockPriority` | ✅ | ✅ | ❌ | ❌ | ?                            |

## 4. Planned Improvements
1.  **Visual Highlight**: Add a button to call `c:Highlight(true)` to see the component flicker in-game.
2.  **Parent Navigation**: Display the Parent Address and allow "jumping" to it.
3.  **Search/Filter**: Filter the tree by ID or StateText.
4.  **Custom Property Fetcher**: Input box to call `GetProperty(key)` on the selected component.

