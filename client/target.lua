local QBCore = exports['qb-core']:GetCoreObject()

-- start heist
exports['qb-target']:AddBoxZone("ilv-cayo:startheist", vector3(109.49, -2566.49, 10.81), 1, 1.6, {
	name = "ilv-cayo:startheist",
	heading = 0,
	debugPoly = false,
	minZ = 9.81,
	maxZ = 13.81,
}, {
	options = {
		{
            type = "client",
            event = "ilv-cayo:client:startheist",
			icon = "fas fa-circle",
			label = "Knock on door",
		},
	},
	distance = 2.5
})

-- hack 1
exports['qb-target']:AddBoxZone("ilv-cayo:hack1", vector3(4491.68, -4582.49, 6.74), 0.4, 0.9, {
	name = "ilv-cayo:hack1",
	heading = 200.46,
	debugPoly = false,
	minZ = 5.8,
	maxZ = 6.9,
}, {
	options = {
		{
            type = "client",
            event = "ilv-cayo:client:hack1",
			icon = "fas fa-circle",
			label = "Hack",
		},
	},
	distance = 2.5
})

-- hack 2
exports['qb-target']:AddBoxZone("ilv-cayo:hack2", vector3(5084.25, -5731.81, 17.14), 0.14, 0.2, {
	name = "ilv-cayo:hack2",
	heading = 325,
	debugPoly = false,
	minZ = 16.05,
	maxZ = 16.3,
}, {
	options = {
		{
            type = "client",
            event = "ilv-cayo:client:hack2",
			icon = "fas fa-circle",
			label = "Hack",
		},
	},
	distance = 2.5
})

-- hack 3
exports['qb-target']:AddBoxZone("ilv-cayo:hack3", vector3(5082.89, -5758.54, 15.77), 0.4, 0.4, {
	name = "ilv-cayo:hack3",
	heading = 144.12,
	debugPoly = false,
	minZ = 15.77,
	maxZ = 16.0,
}, {
	options = {
		{
            type = "client",
            event = "ilv-cayo:client:hack3",
			icon = "fas fa-circle",
			label = "Hack",
		},
	},
	distance = 2.5
})

-- hack 4 (Upper hack weak lazer security)
exports['qb-target']:AddBoxZone("ilv-cayo:hack4", vector3(5009.74, -5748.67, 28.89), 0.3, 0.3, {
	name = "ilv-cayo:hack4",
	heading=330,
	debugPoly = false,
	minZ=26.29,
	maxZ=30.29,
}, {
	options = {
		{
            type = "client",
            event = "ilv-cayo:client:hack4",
			icon = "fas fa-circle",
			label = "Weak Lazers",
		},
	},
	distance = 2.5
})

-- hack 5 (Deactivate Lazers)
exports['qb-target']:AddBoxZone("ilv-cayo:hack5", vector3(5143.05, -4955.69, 14.36), 0.8, 0.8, {
	name = "ilv-cayo:hack5",
	heading=50,
	debugPoly = false,
	minZ=11.56,
	maxZ=15.56,
}, {
	options = {
		{
            type = "client",
            event = "ilv-cayo:client:hack5",
			icon = "fas fa-circle",
			label = "Deactivate Security",
		},
	},
	distance = 2.5
})

-- door1
exports['qb-target']:AddBoxZone("ilv-cayo:door1", vector3(4992.19, -5756.6, 15.89), 1, 1, {
	name = "ilv-cayo:door1",
	heading = 328.0,
	debugPoly = false,
	minZ = 15,
	maxZ = 17.2,
}, {
	options = {
		{
            type = "client",
            event = "ilv-cayo:client:door1",
			icon = "fas fa-circle",
			label = "Open Door",
		},
	},
	distance = 2.5
})
-- door 2
exports['qb-target']:AddBoxZone("ilv-cayo:door2", vector3(4998.39, -5742.69, 15.98), 1, 1, {
	name = "ilv-cayo:door2",
	heading = 237.99,
	debugPoly = false,
	minZ = 14.0,
	maxZ = 16.2,
}, {
	options = {
		{
            type = "client",
            event = "ilv-cayo:client:door2",
			icon = "fas fa-circle",
			label = "Open Door",
		},
	},
	distance = 2.5
})
-- door 3
exports['qb-target']:AddBoxZone("ilv-cayo:door3", vector3(5001.99, -5746.21, 14.84), 1, 1, {
	name = "ilv-cayo:door3",
	heading = 237.99,
	debugPoly = false,
	minZ = 14.0,
	maxZ = 16.0,
}, {
	options = {
		{
            type = "client",
            event = "ilv-cayo:client:door3",
			icon = "fas fa-circle",
			label = "Open Door",
		},
	},
	distance = 2.5
})

-- door 4
exports['qb-target']:AddBoxZone("ilv-cayo:door4", vector3(5008.12, -5753.83, 16.68), 1, 1, {
	name = "ilv-cayo:door4",
	heading = 327.76,
	debugPoly = false,
	minZ = 14.4,
	maxZ = 16.6,
}, {
	options = {
		{
            type = "client",
            event = "ilv-cayo:client:door4",
			icon = "fas fa-circle",
			label = "Open Door",
		},
	},
	distance = 2.5
})


-- door 5
exports['qb-target']:AddBoxZone("ilv-cayo:door5", vector3(5006.07, -5751.0, 28.68), 1, 1, {
	name = "ilv-cayo:door5",
	heading = 330,
	debugPoly = false,
	minZ=27.68,
	maxZ=31.68,
}, {
	options = {
		{
            type = "client",
            event = "ilv-cayo:client:door5",
			icon = "fas fa-circle",
			label = "Unlock Door",
		},
	},
	distance = 2.5
})

-- door 6
exports['qb-target']:AddBoxZone("ilv-cayo:door6", vector3(5006.1, -5734.15, 15.84), 1, 1, {
	name = "ilv-cayo:door6",
	heading = 50,
	debugPoly = false,
	minZ=14.84,
	maxZ=18.84,
}, {
	options = {
		{
            type = "client",
            event = "ilv-cayo:client:door6",
			icon = "fas fa-circle",
			label = "Open Door",
		},
	},
	distance = 2.5
})


-- loot 1
exports['qb-target']:AddBoxZone("ilv-cayo:loot1", vector3(5001.67, -5753.8, 16.4), 0.8, 0.7, {
	name = "ilv-cayo:loot1",
	heading = 20.12,
	debugPoly = false,
	minZ = 14.0,
	maxZ = 15.3,
}, {
	options = {
		{
            type = "client",
            event = "ilv-cayo:client:loot1",
			icon = "fas fa-circle",
			label = "Search",
		},
	},
	distance = 2.5
})

-- loot 2
exports['qb-target']:AddBoxZone("ilv-cayo:loot2", vector3(5011.34, -5757.71, 17.23), 1, 1, {
	name = "ilv-cayo:loot2",
	heading =  57.49,
	debugPoly = false,
	minZ = 14.4,
	maxZ = 16.2,
}, {
	options = {
		{
            type = "client",
            event = "ilv-cayo:client:loot2",
			icon = "fas fa-circle",
			label = "Search",
		},
	},
	distance = 2.5
})



-- loot 3
exports['qb-target']:AddBoxZone("ilv-cayo:loot3", vector3(5017.29, -5746.63, 16.11), 1, 1, {
	name = "ilv-cayo:loot3",
	heading =  63.75,
	debugPoly = false,
	minZ = 14.4,
	maxZ = 15.3,
}, {
	options = {
		{
            type = "client",
            event = "ilv-cayo:client:loot3",
			icon = "fas fa-circle",
			label = "Search",
		},
	},
	distance = 2.5
})

-- Search key
exports['qb-target']:AddBoxZone("ilv-cayo:searchkey", vector3(5144.58, -4954.65, 14.36), 0.5, 0.5, {
	name = "ilv-cayo:searchkey",
	heading=50,
	debugPoly = false,
	minZ=13.36,
	maxZ=17.36,
}, {
	options = {
		{
            type = "client",
            event = "ilv-cayo:searchkey",
			icon = "fas fa-circle",
			label = "Look for Key",
		},
	},
	distance = 2.5
})