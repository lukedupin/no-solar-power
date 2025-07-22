-- Super heated water fluid definition
data:extend({
  {
    type = "fluid",
    name = "super-heated-water",
    icon = "__base__/graphics/icons/fluid/steam.png",
    icon_size = 64,
    icon_mipmaps = 4,
    base_color = {r=1, g=0.5, b=0.2},
    flow_color = {r=1, g=0.7, b=0.4},
    default_temperature = 500,
    max_temperature = 1000,
    heat_capacity = "1kJ",
    fuel_value = "1MJ",
    emissions_multiplier = 1,
    subgroup = "fluid",
    order = "a[fluid]-z[super-heated-water]",
    auto_barrel = false
  }
})

-- Recipe to convert super heated water to regular water
data:extend({
  {
    type = "recipe",
    name = "cool-super-heated-water",
    category = "chemistry",
    enabled = false,
    energy_required = 2,
    ingredients = {
      {type = "fluid", name = "super-heated-water", amount = 100}
    },
    results = {
      {type = "fluid", name = "water", amount = 10}
    },
    main_product = "water",
    icon = "__base__/graphics/icons/fluid/water.png",
    icon_size = 64,
    icon_mipmaps = 4,
    subgroup = "fluid-recipes",
    order = "a[fluid]-z[cool-super-heated-water]"
  }
})

-- Copy the existing fusion generator and modify it
local steam_condenser_turbine = table.deepcopy(data.raw["fusion-generator"]["fusion-generator"])

-- Update the name and internal name
steam_condenser_turbine.name = "steam-condenser-turbine"
steam_condenser_turbine.minable.result = "steam-condenser-turbine"

steam_condenser_turbine.graphics_set.north_graphics_set.fluid_input_graphics={[1]={sprite={filename="__base__/graphics/entity/land-mine/land-mine-set-enemy.png",priority="medium",width=1,height=1}}}
steam_condenser_turbine.graphics_set.east_graphics_set.fluid_input_graphics={[1]={sprite={filename="__base__/graphics/entity/land-mine/land-mine-set-enemy.png",priority="medium",width=1,height=1}}}
steam_condenser_turbine.graphics_set.south_graphics_set.fluid_input_graphics={[1]={sprite={filename="__base__/graphics/entity/land-mine/land-mine-set-enemy.png",priority="medium",width=1,height=1}}}
steam_condenser_turbine.graphics_set.west_graphics_set.fluid_input_graphics={[1]={sprite={filename="__base__/graphics/entity/land-mine/land-mine-set-enemy.png",priority="medium",width=1,height=1}}}

-- Add the energy source configuration
steam_condenser_turbine.energy_source = {
  type = "electric",
  usage_priority = "secondary-output",
  output_flow_limit = "500kW"
}

-- Add fluid handling properties
steam_condenser_turbine.max_fluid_usage = 3

-- Add input fluid box for steam
steam_condenser_turbine.input_fluid_box = {
  production_type = "input",
  filter = "steam",
  maximum_temperature = 500,
  volume = 200,
  pipe_connections = {
    {
      flow_direction = "input",
      direction = defines.direction.south,
      position = {0, 2}
    }
  },
  pipe_covers = pipecoverspictures()
}

-- Add output fluid box for processed steam
steam_condenser_turbine.output_fluid_box = {
  production_type = "output",
  filter = "super-heated-water",
  volume = 200,
  pipe_connections = {
    {
      flow_direction = "output",
      direction = defines.direction.north,
      position = {0, -2}
    }
  },
  pipe_covers = pipecoverspictures()
}

-- Optional: Modify other properties if needed
steam_condenser_turbine.localised_name = {"entity-name.steam-condenser-turbine"}
steam_condenser_turbine.localised_description = {"entity-description.steam-condenser-turbine"}

-- Add the modified entity to the data
data:extend({steam_condenser_turbine})

-- Create an item for the steam condenser turbine
local steam_condenser_turbine_item = table.deepcopy(data.raw["item"]["fusion-generator"])
steam_condenser_turbine_item.name = "steam-condenser-turbine"
steam_condenser_turbine_item.place_result = "steam-condenser-turbine"
steam_condenser_turbine_item.localised_name = {"item-name.steam-condenser-turbine"}
steam_condenser_turbine_item.localised_description = {"item-description.steam-condenser-turbine"}

data:extend({steam_condenser_turbine_item})

-- Create a recipe for the steam condenser turbine
local steam_condenser_recipe = {
  type = "recipe",
  name = "steam-condenser-turbine",
  category = "crafting",
  enabled = false,
  energy_required = 30,
  ingredients = {
    {type = "item", name = "steam-engine", amount = 1},
    {type = "item", name = "pipe", amount = 10},
    {type = "item", name = "steel-plate", amount = 20},
    {type = "item", name = "advanced-circuit", amount = 5}
  },
  results = {
    {type = "item", name = "steam-condenser-turbine", amount = 1}
  }
}

data:extend({steam_condenser_recipe})

-- Add technology to unlock the steam condenser turbine
local steam_condenser_tech = {
  type = "technology",
  name = "steam-condenser-power",
  icon = "__space-age__/graphics/technology/fusion-reactor.png",
  icon_size = 256,
  effects = {
    {
      type = "unlock-recipe",
      recipe = "steam-condenser-turbine"
    },
    {
      type = "unlock-recipe",
      recipe = "burner-assembling-machine",
    },
    {
      type = "unlock-recipe",
      recipe = "cool-super-heated-water"
    }
  },
  prerequisites = {"rocket-silo"},
  unit = {
    count = 150,
    ingredients = {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1},
      {"chemical-science-pack", 1}
    },
    time = 30
  },
  order = "e-p-b-c"
}

data:extend({steam_condenser_tech})








-- Burner assembler for unbarrling
-- Create burner assembling machine entity
local burner_assembler = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
burner_assembler.name = "burner-assembling-machine"
burner_assembler.minable.result = "burner-assembling-machine"
burner_assembler.crafting_speed = 0.2
burner_assembler.energy_usage = "6MW"
burner_assembler.energy_source = {
  type = "burner",
  fuel_categories = {"chemical"},
  effectivity = 1,
  fuel_inventory_size = 1,
  emissions_per_minute = { pollution = 4 }
}

-- Make it look brown
-- burner_assembler.pictures.layers[1].tint = {r = 0.8, g = 0.6, b = 0.4}

-- Create item
local burner_assembler_item = table.deepcopy(data.raw["item"]["assembling-machine-2"])
burner_assembler_item.name = "burner-assembling-machine"
burner_assembler_item.place_result = "burner-assembling-machine"
burner_assembler_item.order = "a[assembling-machine-0]"

-- Create recipe
local burner_assembler_recipe = {
  type = "recipe",
  name = "burner-assembling-machine",
  energy_required = 0.5,
  ingredients = {
    {type = "item", name = "iron-gear-wheel", amount = 5},
    {type = "item", name = "electronic-circuit", amount = 3},
    {type = "item", name = "iron-plate", amount = 9},
    {type = "item", name = "stone-furnace", amount = 1}
  },
  results = {{type = "item", name = "burner-assembling-machine", amount = 1}},
  enabled = false
}

-- Add everything to data
data:extend({burner_assembler, burner_assembler_item, burner_assembler_recipe})
