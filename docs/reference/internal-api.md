---
outline: deep
---

# Internal API

The `consul` global table is the entire ConsulScriptum API. Everything described here is accessible from Scriptum files and custom commands.

## Bundled libraries

These are available in any script or command:

| Name | Library | Common use |
| --- | --- | --- |
| `consul.serpent` | [Serpent](https://github.com/pkulchenko/serpent) | Serialize/deserialize tables |
| `consul.inspect(v)` | [inspect.lua](https://github.com/kikito/inspect.lua) | Pretty-print any value |
| `consul.pretty(v)` | [Penlight pretty](https://lunarmodules.github.io/Penlight/) | Formatted table output |

---

<!-- @include: ./parts/generated-internal-api.md -->
