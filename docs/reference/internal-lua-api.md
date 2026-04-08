---
outline: deep
---

# Consul API (reference)

The `consul` global table constitutes the entire ConsulScriptum API. Everything described here is accessible from Scriptum files and custom commands. Because consul is loaded in all_scripted.lua, you can use the API anywhere in your scripts, provided that consul is included in your load order.

## Bundled libraries

These are available in any script or command:

| Name | Library | Common use |
| --- | --- | --- |
| `consul.serpent` | [Serpent](https://github.com/pkulchenko/serpent) | Serialize/deserialize tables |
| `consul.inspect(v)` | [inspect.lua](https://github.com/kikito/inspect.lua) | Pretty-print any value |
| `consul.pretty(v)` | [Penlight pretty](https://lunarmodules.github.io/Penlight/) | Formatted table output |

---

<!-- @include: ./parts/generated-internal-api.md -->
