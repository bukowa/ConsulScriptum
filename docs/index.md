---
layout: home
title: ConsulScriptum
titleTemplate: Scripting Console for Total War

hero:
  name: "ConsulScriptum"
  text: "Scripting Interface & Console"
  tagline: "A direct UI bridge to the game's internal scripting engine. Automate your campaign via the Consul module—no technical knowledge or pack editing required. For detailed control, use Lua Console and Scriptum modules."
  actions:
    - theme: brand
      text: Getting Started
      link: /guide/getting-started
    - theme: alt
      text: Limitations
      link: /guide/limitations
    - theme: alt
      text: GitHub
      link: https://github.com/bukowa/ConsulScriptum

features:
  - icon: 📋
    title: Consul
    details: The entry point for all players. Modify your live campaign instantly with one-click actions—like using the *Exterminare* script to kill characters or *Adice Provinciam* to transfer settlements on the campaign map. No technical knowledge required.

  - icon: ⌨️
    title: Console & Scriptum
    details: The advanced interface for script interactions. Use the console for immediate slash-commands and raw Lua snippets or execute complex external .lua files live from your game folder without restarting the game. Technical knowledge required.

  - icon: 🛡️
    title: Scope & Safety
    details: Strictly non-invasive. This tool interacts with official game Lua APIs to change the game state; it does not bypass engine constraints, modify core files, extend the engine, or function as a hack.
---

<div class="disclaimer-section">

<!-- @include: ./guide/parts/disclaimer.md -->

</div>

<style scoped>
.disclaimer-section {
  max-width: 720px;
  margin: 4rem auto;
  padding: 0 2rem;
  text-align: center;
}
.disclaimer-section h2 {
  margin-bottom: 2.5rem;
  font-family: 'Cinzel', serif;
  color: var(--cs-crimson-light);
  letter-spacing: 0.1em;
}
.disclaimer-section p {
  margin-bottom: 2rem;
  color: var(--cs-text-muted);
}
.disclaimer-section table {
  width: 95%;
  border-collapse: collapse;
  font-family: 'Crimson Text', serif;
  font-size: 1rem;
  margin-left: auto !important;
  margin-right: 0 !important;
}
.disclaimer-section th {
  text-align: center !important;
  padding-bottom: 1rem;
  color: var(--cs-gold);
  border-bottom: 1px solid var(--cs-border-strong);
  text-transform: uppercase;
  font-size: 0.85rem;
  letter-spacing: 0.05em;
}
.disclaimer-section td {
  padding: 1.25rem 0.5rem;
  border-bottom: 1px solid var(--cs-border-faint);
  color: var(--cs-text-muted);
  text-align: center !important;
}
.disclaimer-section tr:last-child td {
  border-bottom: none;
}
.disclaimer-section strong {
  color: var(--cs-gold-light);
}
</style>
