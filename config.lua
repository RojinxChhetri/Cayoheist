Config = {}

Config.MinCop = 0
Config.JobPrice = 10000
Config.StartTimer = 120
Config.FinishTimer = 60

-- Hack Config
Config.Hack1Item = 'trojan_usb'
Config.Hack1Blocks = 2
Config.Hack1Time = 10
Config.Hack1ExplosionDelay = 12

Config.Hack2Item = 'electronickit'
Config.Hack2Time = 10
Config.Hack2GridSize = 5
Config.Hack2Incorrect = 2

Config.Hack3Item = 'trojan_usb'
Config.Hack3Blocks = 2
Config.Hack3Time = 10

Config.BombItem = 'thermite'
Config.BombTime = 10
Config.BombGridSize = 5
Config.BombIncorrect = 2
Config.BombTimer = 10
Config.UpperDoorItem = 'officekey'

-- Loot Config
Config.Loot1Item = 'weapon_combatpistol'
Config.Loot1AmountMin = 1
Config.Loot1AmountMax = 3
Config.Loot1RareItem = 'weapon_microsmg'
Config.Loot1RareAmountMin = 1
Config.Loot1RareAmountMax = 3

Config.Loot2Item = 'goldbar'
Config.Loot2AmountMin = 1
Config.Loot2AmountMax = 4
Config.Loot2RareItem = 'weapon_assaultrifle'
Config.Loot2RareAmountMin = 1
Config.Loot2RareAmountMax = 2

Config.Loot3Item = 'goldbar'
Config.Loot3AmountMin = 1
Config.Loot3AmountMax = 4
Config.Loot3RareItem = 'weapon_assaultrifle'
Config.Loot3RareAmountMin = 1
Config.Loot3RareAmountMax = 2

-- NPC Settings
Config.SpawnPedOnHack2 = true
Config.SpawnPedOnHack3 = true
Config.SpawnPedOnHack4 = true -- Upper hack (Hack4)
Config.PedGun = 'weapon_microsmg'
Config.SetPedAccuracy = 100

-- NPC spawn points
-- We'll use these three sets of coordinates for the three guard spawn events:
-- Hack2 success -> locations[1]
-- Hack3 success -> locations[2]
-- Hack4 success -> locations[3]
Config.Shooters = {
    ['soldiers'] = {
        locations = {
            [1] = {
                peds = {
                    vector3(5078.72, -5739.53, 16.87),
                    vector3(5093.39, -5745.87, 15.68),
                    vector3(5086.05, -5758.86, 15.68),
                    vector3(5078.81, -5752.72, 15.68),
                    vector3(5066.15, -5751.54, 15.68),
                    vector3(5066.22, -5746.52, 15.88),
                    vector3(5070.26, -5741.37, 15.88),
                }
            },
            [2] = {
                peds = {
                    vector3(5051.71, -5747.07, 15.68),
                    vector3(5056.3, -5759.12, 15.73),
                    vector3(5062.53, -5764.15, 15.73),
                    vector3(5064.51, -5773.18, 16.28),
                    vector3(5057.13, -5781.83, 16.28),
                }
            },
            [3] = {
                peds = {
                    vector3(5004.33, -5762.26, 19.88),
                    vector3(5004.77, -5766.37, 19.88),
                    vector3(5007.33, -5768.6, 19.88),
                    vector3(5015.8, -5751.61, 24.27),
                    vector3(5016.14, -5744.86, 25.09),
                    vector3(5011.95, -5743.19, 26.49),
                    vector3(5019.3, -5746.18, 24.27),
                }
            },
        },
    }
}
