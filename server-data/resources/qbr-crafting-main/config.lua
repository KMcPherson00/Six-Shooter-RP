Config = {}

Config.AttachmentCrafting = {
    ['location'] = vector3(-277.2096, 779.3605, 119.504), 
    ["items"] = {
        [1] = {
            name = "weapon_revolver01",
            amount = 50,
            info = {},
            costs = {
                ["metalscrap"] = 140,
            },
            type = "item",
            slot = 1,
            threshold = 0,
            points = 1,
        },
    }
}

Config.CraftingItems = {
    [1] = {
        name = "lockpick",
        amount = 50,
        info = {},
        costs = {
            ["metalscrap"] = 20,
            ["plastic"] = 20,
        },
        type = "item",
        slot = 1,
        threshold = 0,
        points = 1,
    },
    [2] = {
        name = "coffee",
        amount = 1,
        info = {},
        costs = {
            ["coffeeseeds"] = 20,
            ["water"] = 20,
        },
        type = "item",
        slot = 2,
        threshold = 0,
        points = 2,
    },
}
