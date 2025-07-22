-- Modify the existing steam condensation recipe
if data.raw.recipe["steam-condensation"] then
  data.raw.recipe["steam-condensation"].results = {
    {type = "fluid", name = "water", amount = 90},
    {type = "fluid", name = "steam", amount = 100, temperature = 15}
  }
end
