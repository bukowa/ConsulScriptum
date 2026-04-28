---
outline: deep
---

# HTML UI Debugger

<video :src="$withBase('/videos/ui_debugger_showcase.mp4')" data-title="HTML UI Debugger Showcase" autoplay loop muted playsinline></video>

The **HTML UI Debugger** is an interactive tool for inspecting and manipulating the game's User Interface. It provides a visual tree view of all components, making it easier to understand hierarchies than using console commands alone.

::: warning Alpha Version
This tool is currently in **Alpha**. Bugs and crashes are to be expected as the architecture is still being refined. Feedback and suggestions are highly welcome on **[GitHub](https://github.com/bukowa/ConsulScriptum)**.
:::

::: tip Recommended Tool
This is the standard way to debug UI in Rome II and Attila as of version **0.8.0**. It provides a live view of the UI state and allows for direct interaction with components.
:::

## Launching the Debugger

To open the debugger, type the following command in the Consul console:

```text
/debug_html
```

This will generate a `consul_uidebug.html` file in your game root and automatically open it in your default web browser.

## Key Features

### 1. Interactive Hierarchy Tree
The sidebar displays the entire UI tree starting from the `root`. 
- **Auto-Sync**: The debugger automatically highlights the component you are currently hovering over in-game (note: some elements may not trigger this depending on their configuration).
- **Auto-Expand**: Folders automatically open to show the path to the hovered component.
- **Manual Selection**: Click any node in the tree to "Lock" the view to that specific component.

### 2. Property Inspector
The main panel shows all properties of the selected component in real-time.
- **Live Updates**: Values like `Position`, `Width`, and `Text` update instantly as they change in-game.
- **Direct Editing**: Change values (like `Visible`, `Priority`, or `Text`) directly in the browser. The changes are sent back to the game immediately.
- **Actions**: Trigger actions like `SimulateClick`, `DestroyChildren`, or `Layout` with a single click.

### 3. Lock & Follow Mode
In the inspector header, you can toggle between two modes:
- **🖱️ FOLLOWING MOUSE**: (Default) The inspector automatically switches to whatever you hover over in the game.
- **🔒 LOCKED**: The inspector stays on the current component, allowing you to move your mouse without losing your place.

### 4. Global Search
Use the search bar at the top of the sidebar to find components by:
- **ID** (e.g., `button_ok`)
- **Address** (e.g., `0x12345`)
- **Text content** (e.g., "Declare War")
- **Tooltip text**

Matches are highlighted in the tree, and you can navigate through multiple results using the arrow buttons.

### 5. Drag and Drop (Hierarchy Manipulation)
You can rearrange the UI hierarchy directly from the tree:
- **Adopt**: Drag one component onto another to make it a child (calls `Adopt` in-game).
- **Reorder**: Drag a component between its siblings to change its index (calls `Adopt` with an index).

## Workflow Tips

### Finding IDs for Scripts
Enable the debugger and hover over any element in the game. The ID will instantly appear in the inspector. This is the fastest way to find targets for `consul.ui.find("id")`.

### Testing UI States
You can manually change the `CurrentState` of a component in the inspector to see how it looks in different states (e.g., `hover`, `active`, `down`) without actually interacting with it in-game.

### Persistent Customization
- **Hide Properties**: If there are properties you never use, click the `×` next to them. This preference is saved in your browser's local storage.
- **Restore**: Use the "Restore Hidden" button to bring them back.

## Troubleshooting

### Connection Status
The debugger uses a local file polling system to communicate with the game.
1. Click the **Connect** button in the sidebar.
2. Select your game root folder (where `consul_debug_ui_state.txt` is located).
3. The status should change to **Live Sync**.

### Capture Toggle (F7)
You can pause the game-side data stream by pressing **F7** in-game. This stops the game from writing updates to the state file, which is useful if you want to freeze the entire debugger state.
## How It Works (Technical Overview)

The UI Debugger uses a "File-based Bridge" to communicate between the game engine and your web browser. 

### 1. Game Side (Lua)
The game acts as the **Data Provider**. When you hover, click, or move components, a Lua script snapshots the UI state and writes it to a local file (`consul_debug_ui_state.txt`). It also polls a second file (`consul_debug_ui_commands.txt`) for instructions sent from the browser.

### 2. Browser Side (JavaScript)
The browser acts as the **Interface**. When you click "Connect", it uses the File System Access API to monitor the state file. It polls the file for changes every 250ms and updates the visual tree. When you trigger an action in the browser, it writes a command to the command file for the game to execute.

### 3. The Bridge
The local filesystem serves as the communication layer. This allows for a "live" experience without needing an external web server or complex network protocols, keeping the tool lightweight and compatible with the game's restricted environment.
