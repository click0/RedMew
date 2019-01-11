local ob = require 'map_gen.presets.crash_site.outpost_builder'
local Token = require 'utils.token'

local loot = {
    {weight = 5},
    {stack = {name = 'coin', count = 250, distance_factor = 1 / 20}, weight = 5},
    {stack = {name = 'stone', count = 1600}, weight = 8},
    {stack = {name = 'stone-brick', count = 2000, distance_factor = 1 / 2}, weight = 5},
    {stack = {name = 'concrete', count = 2000, distance_factor = 1 / 2}, weight = 5},
    {stack = {name = 'refined-concrete', count = 4000, distance_factor = 1 / 2}, weight = 10},
    {stack = {name = 'stone-wall', count = 1000, distance_factor = 1 / 5}, weight = 5},
    {stack = {name = 'gate', count = 250, distance_factor = 1 / 5}, weight = 1}
}

local weights = ob.prepare_weighted_loot(loot)

local loot_callback =
    Token.register(
    function(chest)
        ob.do_random_loot(chest, weights, loot)
    end
)

local factory = {
    callback = ob.magic_item_crafting_callback,
    data = {
        furance_item = 'stone',
        output = {min_rate = 2 / 60, distance_factor = 2 / 60 / 512, item = 'stone-brick'}
    }
}

local factory_b = {
    callback = ob.magic_item_crafting_callback,
    data = {
        recipe = 'refined-concrete',
        output = {min_rate = 2 / 60, distance_factor = 2 / 60 / 512, item = 'refined-concrete'}
    }
}

local factory_c = {
    callback = ob.magic_item_crafting_callback,
    data = {
        recipe = 'electric-engine-unit',
        output = {min_rate = 2 / 60, distance_factor = 2 / 60 / 512, item = 'electric-engine-unit'}
    }
}

local market = {
    callback = ob.market_set_items_callback,
    data = {
        market_name = 'Big Stone Factory',
        {
            name = 'stone',
            price = 0.25,
            distance_factor = 0.125 / 512,
            min_price = 0.025
        },
        {
            name = 'stone-brick',
            price = 0.5,
            distance_factor = 0.25 / 512,
            min_price = 0.05
        },
        {
            name = 'concrete',
            price = 0.5,
            distance_factor = 0.25 / 512,
            min_price = 0.05
        },
        {
            name = 'refined-concrete',
            price = 1,
            distance_factor = 0.5 / 512,
            min_price = 0.1
        },
        {
            name = 'stone-wall',
            price = 1,
            distance_factor = 0.5 / 512,
            min_price = 0.1
        },
        {
            name = 'gate',
            price = 2,
            distance_factor = 1 / 512,
            min_price = 0.2
        }
    }
}

local base_factory = require 'map_gen.presets.crash_site.outpost_data.big_furance'
local base_factory2 = require 'map_gen.presets.crash_site.outpost_data.big_factory'

local level2 = ob.extend_1_way(base_factory[1], {loot = {callback = loot_callback}})
local level3 =
    ob.extend_1_way(
    base_factory[2],
    {
        factory = factory,
        fallback = level2,
        max_count = 1
    }
)
local level3b =
    ob.extend_1_way(
    base_factory2[2],
    {
        factory = factory_b,
        fallback = level3,
        max_count = 2
    }
)
local level4 =
    ob.extend_1_way(
    base_factory[3],
    {
        market = market,
        fallback = level3b
    }
)
return {
    settings = {
        blocks = 9,
        variance = 3,
        min_step = 2,
        max_level = 2
    },
    walls = {
        require 'map_gen.presets.crash_site.outpost_data.heavy_gun_turrets',
        require 'map_gen.presets.crash_site.outpost_data.walls'
    },
    bases = {
        {level4, level2}
    }
}
