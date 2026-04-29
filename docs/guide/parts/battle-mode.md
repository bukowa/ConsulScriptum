Access to the console during campaign battles is available natively in ToB, while Rome II and Attila require an experimental workaround.

**Technical Note**: In Rome II and Attila, the game engine uses distinct "modes" for campaign and standalone battles. The campaign UI and scripting environment (which Consul depends on) are typically unloaded when a battle starts. Our workaround forces these interfaces to remain active, but this only works when the battle is launched from an active campaign session where the interfaces are already initialized.

See the full [Battle Mode Scripting](./battle-mode-scripting) guide for instructions and example scripts.
