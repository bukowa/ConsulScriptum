### Battle Mode Support

**Rome II**  
The console does not show in battle by default because the battle interface is not loaded. Current workaround: The mod registers a custom battlefield override using `game_interface:add_custom_battlefield`, which causes the Rome II battle UI to load and makes the console accessible. 
- **How to enable**: Run `/use_in_battle` inside a campaign session, then start a battle. Note that this command **only works within a campaign session** (cannot be used for custom battles from the main menu). 
- **Status**: Experimental.

**Attila**  
Battle mode is not supported yet. Whether Attila's battle interface can be made available without the Rome II override trick is still under research.


---

::: tip Full Guide
See the [Battle Mode Guide](../battle) for detailed instructions and a video tutorial on how to enable the console in Rome II.
:::
