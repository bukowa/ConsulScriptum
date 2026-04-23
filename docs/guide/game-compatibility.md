---
title: "Game Compatibility"
description: "Check supported games and feature compatibility for Consul Scriptum in Total War: Rome II and Attila. Learn about mod compatibility and stability."
---

# Games and compatibility

<!-- @include: ./parts/status-table.md -->


## Feature Comparison

| Feature | Rome II | Attila |
|---------|:-------:|:------:|
| **One-Click Scripts (Consul)** | ✅ Full | ✅ Full |
| **Script Runner (Scriptum)** | ✅ Full | ✅ Full |
| **Lua Console** | ✅ Full | ✅ Full |
| **Commands** | ✅ Full | ⚠️ Partial |
| **Battle Mode** | ✅ Experimental | ✅ Experimental |
| **Stability Level** | Stable | Experimental |


## Mod Compatibility

ConsulScriptum is designed to be highly non-invasive. It uses a single entry point (all_scripted.lua) to hook into the game, leaving all others untouched! This makes it **fully compatible** with nearly every mod and overhaul (like Divide et Impera or The Dawnless Days). 

In the rare event that another mod also uses all_scripted.lua, compatibility can be restored by adding just a few lines of code.

## Detailed Compatibility Notes

### Total War: Rome II
The primary development platform. Most features, scripts, and commands are tested and verified. Fully compatible with major mods like **Divide et Impera (DEI)**.

- **Status**: Stable
- **Battle Mode**: Experimental workaround available. Run `/use_in_battle` in a campaign session, then start a battle (**Campaign only**).

### Total War: Attila
Currently in a **General Alpha** phase. While core features (Consul Scripts, Scriptum, Lua Console) are functional, some engine-level differences apply.

- **Status**: Alpha / Experimental
- **Legacy UI**: The Attila version reuses the UI framework and files from the Rome II version. While bugs are to be expected, the core functionality is remarkably stable.
- **Commands**: **Partial Support**. Many built-in slash commands from Rome II have been ported, but certain Attila-specific engine calls are still being investigated.
- **Battle Mode**: **Experimental**. The Rome II workaround has been successfully adapted for Attila. Run `/use_in_battle` in a campaign session to enable.

