return [[
> local lev = ldoc.level or 2
> local h1 = ('#'):rep(lev)
> local h2 = ('#'):rep(lev + 1)
> local h3 = ('#'):rep(lev + 2)
$(h1) API: $(module.name)

> if module.summary and module.summary ~= '' then
$(module.summary)

> end
> if module.description and module.description ~= '' then
$(module.description)

> end
> for kind, items in module.kinds() do
>   local kitem = module.kinds:get_item(kind)
$(h2) $(kind)

> if kitem then
$(ldoc.descript(kitem))

> end
>   for item in items() do
$(h3) `$(ldoc.display_name(item))`

```lua
$(ldoc.display_name(item))
```

$(ldoc.descript(item))

---

>   end
> end
]]
