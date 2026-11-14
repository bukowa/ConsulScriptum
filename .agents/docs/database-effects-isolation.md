# Total War Database Effects Architecture & Isolation

This document outlines the relational mechanics of the Total War engine database regarding effect bundles, effects, and bonus value junctions, establishing the architectural rules required to prevent cross-contamination of vanilla campaign systems.

---

## 1. Relational Flow of Effects

In the Total War engine (Rome II, Attila, Thrones of Britannia), effects do not attach directly to gameplay mechanics. They function as intermediary relational nodes:

```
effect_bundles_tables (e.g. consul_scriptum_aedificatio)
       │
       ▼ (effect_bundles_to_effects_junctions_tables)
effects_tables (e.g. consul_scriptum_aedificatio_build)
       │
       ▼ (effect_bonus_value_*_junctions_tables)
Bonus Values & Target Sets (e.g. add_build_time / building_sets)
```

1. **`effect_bundles`:** Faction or province-level containers applied via Lua (`apply_effect_bundle`) or campaign events.
2. **`effects`:** Abstract keys representing a specific modifier type with UI icons and localized descriptions.
3. **`effect_bonus_value_*_junctions`:** Relational tables that bind an effect key to actual C++ engine operations (such as `add_build_time`, `add_conversion_time`, or `stat_melee_attack`) and target sets (building sets, unit sets).

---

## 2. Downstream Consumption vs. Upstream Mutation

Because `effects_tables` keys are globally shared across all database packs, modifications operate in two distinct directions:

### Safe: Downstream Consumption
Referencing an existing vanilla effect inside a custom bundle via `effect_bundles_to_effects_junctions_tables`:
- **Scope:** Strictly isolated to the faction, province, or character receiving the bundle.
- **Safety:** Safe only when the vanilla effect already provides the exact scope and bonus values required, without needing new rows in junction tables.

### Hazardous: Upstream Mutation
Adding new rows to `effect_bonus_value_*_junctions_tables` using an existing vanilla `effect_key`:
- **Scope:** Global across the entire game runtime.
- **Consequence:** Expands or alters the behavior of that vanilla effect everywhere it is used. Any vanilla technology, royal decree, random dilemma, or incident referencing that effect key will immediately apply the newly added bonus values, scopes, or target sets.
- **Example:** Attaching conversion time reduction to a vanilla build time effect used by random campaign dilemmas causes those dilemmas to unexpectedly grant conversion time reductions to all linked building sets across both player and AI factions.

---

## 3. The Isolation Mandate

To guarantee that custom mod features never alter vanilla balance or mechanics:

1. **Dedicated Effect Keys:** Any feature requiring custom bonus value junctions, modified scopes, or specific target sets must declare its own unique effect key prefixed with `consul_scriptum_` in `effects_tables` and `_consul.loc.tsv`.
2. **Dedicated Junctions:** All custom entries in `effect_bonus_value_*_junctions_tables` must reference the dedicated mod effect key.
3. **Bundle Binding:** Mod effect bundles must bind strictly to the dedicated effect key in `effect_bundles_to_effects_junctions_tables`.

---

## 4. Foreign Key Tolerance & Graceful Degradation

Total War database loaders gracefully handle unmapped foreign keys in junction tables:
- If a junction table (e.g. `building_set_to_building_junctions_tables`) references keys from external DLCs or overhaul mods (such as Divide et Impera) that are not present in the current installation:
  - **Runtime behavior:** The engine silently drops the individual unresolvable junction rows during pack initialization.
  - **Stability:** No crash, assert, or database loading failure occurs.
  - **Implication:** Broad coverage for DLC and overhaul sets can be safely shipped in the base mod table without breaking pure vanilla installations.
