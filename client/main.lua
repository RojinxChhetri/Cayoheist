local QBCore = exports['qb-core']:GetCoreObject()

-- Heist State
local Buyer = nil
local CopCount = 0
local isActive = false
local isHacked1 = false
local isHacked2 = false
local isHacked3 = false
local isHacked4 = false
local isHacked5 = false
local door1 = false
local door2 = false
local door3 = false
local door4 = false
local door5 = false
local door6 = false
local Loot1 = false
local Loot2 = false
local Loot3 = false

local hackBlip = nil
local laptopprop = nil

local lastLaserHit = 0 -- Laser hit cooldown

-- Laser Door Mapping
local doorMapping = {
    ['door1'] = 'loot-door-1',
    ['door2'] = 'loot-door-main',
    ['door3'] = 'loot-door-cash',
    ['door4'] = 'loot-door-glass',
    ['door6'] = 'loot-door-2'
}

-- Load props once heist starts
local function LoadHeistProps()
    if DoesEntityExist(laptopprop) then DeleteEntity(laptopprop) end
    laptopprop = CreateObject(`hei_prop_hst_laptop`, 5082.89, -5758.54, 15.77, true, false, false)
    local upperLaptop = CreateObject(`hei_prop_hst_laptop`, 5009.68, -5748.4, 28.79, true, false, false)
    SetEntityHeading(laptopprop, 144.12)
    SetEntityHeading(upperLaptop, 334.43)
    FreezeEntityPosition(laptopprop, true)
    FreezeEntityPosition(upperLaptop, true)
end

-- Reset client states
local function ResetHeistClient()
    if hackBlip then RemoveBlip(hackBlip); hackBlip = nil end
    if DoesEntityExist(laptopprop) then DeleteEntity(laptopprop); laptopprop = nil end
    Buyer = nil
    StopLasers()
end

-- Sync event
RegisterNetEvent('ilv-cayo:client:sync', function(data)
    isActive = data.isActive
    isHacked1 = data.isHacked1
    isHacked2 = data.isHacked2
    isHacked3 = data.isHacked3
    isHacked4 = data.isHacked4
    isHacked5 = data.isHacked5
    door1 = data.door1
    door2 = data.door2
    door3 = data.door3
    door4 = data.door4
    door5 = data.door5
    door6 = data.door6
    Loot1 = data.Loot1
    Loot2 = data.Loot2
    Loot3 = data.Loot3
end)

RegisterNetEvent('ilv-cayo:client:updatecops', function(amount)
    CopCount = amount
end)

RegisterNetEvent('ilv-cayo:client:ResetHeist', function()
    ResetHeistClient()
end)

-- Start Heist
RegisterNetEvent('ilv-cayo:client:startheist', function()
    TriggerServerEvent('ilv-cayo:server:getcops')
    TriggerServerEvent('ilv-cayo:server:setactive', false)

    local Player = QBCore.Functions.GetPlayerData()
    local cash = Player.money.cash
    local ped = PlayerPedId()
    SetEntityCoords(ped, vector3(110.46, -2566.45, 10.81))
    SetEntityHeading(ped, 101.9)

    local dict = "timetable@jimmy@doorknock@"
    RequestAnimDict(dict); while not HasAnimDictLoaded(dict) do Wait(10) end
    TaskPlayAnim(ped, dict, "knockdoor_idle", 8.0,8.0,-1,49,0,false,false,false)

    QBCore.Functions.Progressbar("knock","Knocking on door...",4000,false,false,{disableMovement=true}, {},{}, {}, function()
        StopAnimTask(ped, dict, "knockdoor_idle",1.0)
        RemoveAnimDict(dict)

        if not isActive then
            if CopCount >= Config.MinCop then
                if cash >= Config.JobPrice then
                    Buyer = Player.citizenid
                    LoadHeistProps()
                    TriggerServerEvent('ilv-cayo:server:setactive', true)
                    QBCore.Functions.Notify('You purchased the GPS location!', 'success')
                    TriggerServerEvent('ilv-cayo:server:removemoney', Config.JobPrice)
                    local hackCoord = vector3(4491.46, -4583.42, 5.57)
                    hackBlip = AddBlipForCoord(hackCoord)
                    SetBlipSprite(hackBlip, 521)
                    SetBlipColour(hackBlip, 2)
                    SetBlipDisplay(hackBlip, 4)
                    SetBlipScale(hackBlip, 0.5)
                    SetBlipAsShortRange(hackBlip, false)
                    BeginTextCommandSetBlipName('STRING')
                    AddTextComponentString('Hack')
                    EndTextCommandSetBlipName(hackBlip)
                else
                    QBCore.Functions.Notify('Not enough money.', 'error')
                end
            else
                QBCore.Functions.Notify('Not enough police on duty.', 'error')
            end
        else
            QBCore.Functions.Notify('No one seems to be home.', 'error')
        end
    end, function()
        StopAnimTask(ped, dict, "knockdoor_idle",1.0)
        RemoveAnimDict(dict)
        QBCore.Functions.Notify('Cancelled.', 'error')
    end)
end)

RegisterNetEvent('cayoheist:spawnGuards', function(setNumber, count)
    if not Config or not Config.Shooters or not Config.Shooters['soldiers'] or not Config.Shooters['soldiers'].locations[setNumber] then
        print("cayoheist:spawnGuards error: Invalid setNumber or config missing")
        return
    end

    local coordsSet = Config.Shooters['soldiers'].locations[setNumber].peds
    if not coordsSet or #coordsSet == 0 then
        print("cayoheist:spawnGuards error: No peds defined for setNumber "..setNumber)
        return
    end

    local totalCoords = #coordsSet
    local perCoord = math.floor(count / totalCoords)
    local remainder = count % totalCoords
    local spawnPoints = {}

    for i, coord in ipairs(coordsSet) do
        local spawnCount = perCoord
        if remainder > 0 then
            spawnCount = spawnCount + 1
            remainder = remainder - 1
        end

        for x = 1, spawnCount do
            table.insert(spawnPoints, coord)
        end
    end

    local model = `s_m_m_security_01`
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end

    -- Create and set up a relationship group for guards
    local relHash = GetHashKey("CayoGuards")
    AddRelationshipGroup("CayoGuards")
    SetRelationshipBetweenGroups(5, relHash, `PLAYER`)
    SetRelationshipBetweenGroups(5, `PLAYER`, relHash)

    for _, coord in ipairs(spawnPoints) do
        local npc = CreatePed(30, model, coord.x, coord.y, coord.z, 0.0, true, true)
        if npc ~= 0 then
            SetPedRelationshipGroupHash(npc, relHash)
            SetPedDropsWeaponsWhenDead(npc, false)
            
            -- Give them an SMG
            GiveWeaponToPed(npc, Config.PedGun, 250, false, true)

            SetPedMaxHealth(npc,300)
            SetEntityHealth(npc,300)
            SetPedArmour(npc,200)

            -- Make them very aggressive
            SetPedCombatAttributes(npc, 46, true)
            SetPedCombatAbility(npc, 2)
            SetPedCombatMovement(npc, 3)
            SetPedCombatRange(npc, 2)
            SetPedHearingRange(npc, 9999.0)
            SetPedSeeingRange(npc, 9999.0)
            SetPedAlertness(npc, 3)
            SetBlockingOfNonTemporaryEvents(npc, true)

            -- Immediately engage the player
            TaskCombatPed(npc, PlayerPedId(), 0, 16)
        else
            print("Failed to create guard ped at "..coord.x..", "..coord.y..", "..coord.z)
        end
    end

    SetModelAsNoLongerNeeded(model)
end)



-- Generic Anim Functions
local function PlayHackAnim(ped)
    local dict = "anim@heists@prison_heiststation@cop_reactions"
    RequestAnimDict(dict); while not HasAnimDictLoaded(dict) do Wait(10) end
    TaskPlayAnim(ped, dict, "cop_b_idle", 8.0, -8.0, -1, 49, 0, false, false, false)
end

local function StopAnim(ped)
    ClearPedTasksImmediately(ped)
end

-- Hack 1 (VarHack)
RegisterNetEvent('ilv-cayo:client:hack1', function()
    if not isActive then QBCore.Functions.Notify('No active heist.', 'error') return end
    if isHacked1 then QBCore.Functions.Notify('Already done this hack.', 'error') return end
    if not QBCore.Functions.HasItem(Config.Hack1Item) then QBCore.Functions.Notify('Missing hack item!', 'error') return end

    local ped = PlayerPedId()
    PlayHackAnim(ped)

    QBCore.Functions.Progressbar("hack1_prep","Preparing equipment...",4000,false,false,{disableMovement=true}, {}, {}, {}, function()
        StopAnim(ped)
        FreezeEntityPosition(ped,true)
        exports['ps-ui']:VarHack(function(success)
            FreezeEntityPosition(ped,false)
            TriggerServerEvent('ilv-cayo:server:RemoveItem', Config.Hack1Item)
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.Hack1Item], 'remove')
            if success then
                QBCore.Functions.Notify('Power Plant overloaded! Blackout triggered.', 'success')
                TriggerServerEvent('ilv-cayo:server:sethack1', true)
                if hackBlip then RemoveBlip(hackBlip) end
                local coord = vector3(5084.7, -5731.45, 15.77)
                hackBlip = AddBlipForCoord(coord)
                SetBlipSprite(hackBlip, 521)
                SetBlipColour(hackBlip, 2)
                SetBlipDisplay(hackBlip, 4)
                SetBlipScale(hackBlip, 0.5)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString('Hack')
                EndTextCommandSetBlipName(hackBlip)

                Wait(Config.Hack1ExplosionDelay * 1000)
                TriggerEvent("cayoblackout:setexplosion", source)
            else
                QBCore.Functions.Notify('Hack failed! Try again with another device.', 'error')
            end
        end, Config.Hack1Blocks, Config.Hack1Time)
    end, function()
        StopAnim(ped)
        QBCore.Functions.Notify('Cancelled.', 'error')
    end)
end)

-- Hack 2 (Thermite)
RegisterNetEvent('ilv-cayo:client:hack2', function()
    if not isActive then QBCore.Functions.Notify('No active heist.', 'error') return end
    if isHacked2 then QBCore.Functions.Notify('Already hacked.', 'error') return end
    if not isHacked1 then QBCore.Functions.Notify('Do the previous hack first.', 'error') return end
    if not QBCore.Functions.HasItem(Config.Hack2Item) then QBCore.Functions.Notify('Missing tools!', 'error') return end

    local ped = PlayerPedId()
    PlayHackAnim(ped)

    QBCore.Functions.Progressbar("hack2_prep","Setting up...",3000,false,false,{disableMovement=true}, {}, {}, {}, function()
        StopAnim(ped)
        FreezeEntityPosition(ped,true)
        exports['ps-ui']:Thermite(function(success)
            FreezeEntityPosition(ped,false)
            TriggerServerEvent('ilv-cayo:server:RemoveItem', Config.Hack2Item)
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.Hack2Item], 'remove')
            if success then
                QBCore.Functions.Notify('Door lock hacked!', 'success')
                TriggerServerEvent('ilv-cayo:server:sethack2', true)
                TriggerServerEvent('ilv-cayo:server:opendoor', 'cayo-side-door')
                if hackBlip then RemoveBlip(hackBlip) end
                local coord = vector3(5083.31, -5757.89, 15.83)
                hackBlip = AddBlipForCoord(coord)
                SetBlipSprite(hackBlip, 521)
                SetBlipColour(hackBlip, 2)
                SetBlipDisplay(hackBlip, 4)
                SetBlipScale(hackBlip, 0.5)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString('Hack')
                EndTextCommandSetBlipName(hackBlip)

                -- Spawn guards for hack2 only once
                TriggerServerEvent('ilv-cayo:server:SpawnGuardsHack2')
            else
                QBCore.Functions.Notify('Failed to hack door! You can try again if you have more kits.', 'error')
            end
        end, Config.Hack2Time, Config.Hack2GridSize, Config.Hack2Incorrect)
    end, function()
        StopAnim(ped)
        QBCore.Functions.Notify('Cancelled.', 'error')
    end)
end)

-- Hack 3 (VarHack)
RegisterNetEvent('ilv-cayo:client:hack3', function()
    if not isActive then QBCore.Functions.Notify('No active heist.', 'error') return end
    if isHacked3 then QBCore.Functions.Notify('Already done this hack.', 'error') return end
    if not isHacked2 then QBCore.Functions.Notify('Do the previous hack first.', 'error') return end
    if not QBCore.Functions.HasItem(Config.Hack3Item) then QBCore.Functions.Notify('Missing hack device!', 'error') return end

    local ped = PlayerPedId()
    PlayHackAnim(ped)

    QBCore.Functions.Progressbar("hack3_prep","Preparing hack...",3000,false,false,{disableMovement=true}, {}, {}, {}, function()
        StopAnim(ped)
        FreezeEntityPosition(ped,true)
        exports['ps-ui']:VarHack(function(success)
            FreezeEntityPosition(ped,false)
            TriggerServerEvent('ilv-cayo:server:RemoveItem', Config.Hack3Item)
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.Hack3Item], 'remove')
            if success then
                QBCore.Functions.Notify('Camera system hacked! Basement doors can be blasted.', 'success')
                TriggerServerEvent('ilv-cayo:server:sethack3', true)
                StartLasers()

                -- Spawn guards for hack3 only once
                TriggerServerEvent('ilv-cayo:server:SpawnGuardsHack3')
            else
                QBCore.Functions.Notify('Hack failed! Try again with another device.', 'error')
            end
        end, Config.Hack3Blocks, Config.Hack3Time)
    end, function()
        StopAnim(ped)
        QBCore.Functions.Notify('Cancelled.', 'error')
    end)
end)

-- Hack 4 (VarHack - Upper Hack)
RegisterNetEvent('ilv-cayo:client:hack4', function()
    if not isActive then QBCore.Functions.Notify('No active heist.', 'error') return end
    if isHacked4 then QBCore.Functions.Notify('Already done this hack.', 'error') return end
    if not isHacked3 then QBCore.Functions.Notify('Finish previous hacks first.', 'error') return end
    if not QBCore.Functions.HasItem(Config.Hack1Item) then QBCore.Functions.Notify('Missing hack device!', 'error') return end

    local ped = PlayerPedId()
    PlayHackAnim(ped)

    QBCore.Functions.Progressbar("hack4_prep","Weakening upper security...",3000,false,false,{disableMovement=true}, {}, {}, {}, function()
        StopAnim(ped)
        FreezeEntityPosition(ped,true)
        exports['ps-ui']:VarHack(function(success)
            FreezeEntityPosition(ped,false)
            TriggerServerEvent('ilv-cayo:server:RemoveItem', Config.Hack1Item)
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.Hack1Item], 'remove')
            if success then
                QBCore.Functions.Notify('Upper security weakened. Proceed with final hack.', 'success')
                TriggerServerEvent('ilv-cayo:server:sethack4', true)
                if hackBlip then RemoveBlip(hackBlip) end
                local coord = vector3(5143.05, -4955.69, 14.36)
                hackBlip = AddBlipForCoord(coord)
                SetBlipSprite(hackBlip, 521)
                SetBlipColour(hackBlip, 2)
                SetBlipDisplay(hackBlip, 4)
                SetBlipScale(hackBlip, 0.5)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString('Hack')
                EndTextCommandSetBlipName(hackBlip)

                -- Spawn guards for hack4 only once
                TriggerServerEvent('ilv-cayo:server:SpawnGuardsHack4')
            else
                QBCore.Functions.Notify('Hack failed! Try again if you have another device.', 'error')
            end
        end, Config.Hack3Blocks, Config.Hack3Time)
    end, function()
        StopAnim(ped)
        QBCore.Functions.Notify('Cancelled.', 'error')
    end)
end)

-- Hack 5 (Thermite - Deactivate Lasers)
RegisterNetEvent('ilv-cayo:client:hack5', function()
    if not isActive then QBCore.Functions.Notify('No active heist.', 'error') return end
    if isHacked5 then QBCore.Functions.Notify('Already done this hack.', 'error') return end
    if not isHacked4 then QBCore.Functions.Notify('Do the previous hack first.', 'error') return end
    if not QBCore.Functions.HasItem(Config.Hack2Item) then QBCore.Functions.Notify('Missing tools!', 'error') return end

    local ped = PlayerPedId()
    PlayHackAnim(ped)

    QBCore.Functions.Progressbar("hack5_prep","Deactivating Security...",3000,false,false,{disableMovement=true}, {}, {}, {}, function()
        StopAnim(ped)
        FreezeEntityPosition(ped,true)
        exports['ps-ui']:Thermite(function(success)
            FreezeEntityPosition(ped,false)
            TriggerServerEvent('ilv-cayo:server:RemoveItem', Config.Hack2Item)
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.Hack2Item], 'remove')
            if success then
                TriggerServerEvent('ilv-cayo:server:sethack5', true)
                QBCore.Functions.Notify('Lasers deactivated! You can now loot safely.', 'success')
                if hackBlip then RemoveBlip(hackBlip) end
                StopLasers()
            else
                QBCore.Functions.Notify('Failed to deactivate lasers! Try again if you have another kit.', 'error')
            end
        end, Config.Hack2Time, Config.Hack2GridSize, Config.Hack2Incorrect)
    end, function()
        StopAnim(ped)
        QBCore.Functions.Notify('Cancelled.', 'error')
    end)
end)

-- Bomb planting animation
local function PlayBombAnim(ped)
    local dict = "anim@heists@ornate_bank@thermal_charge"
    RequestAnimDict(dict); while not HasAnimDictLoaded(dict) do Wait(10) end
    TaskPlayAnim(ped, dict, "thermal_charge", 8.0, -8.0, -1, 1, 0, false, false, false)
end

-- Plant Bomb Door
local function PlantBombDoor(doorEvent, x, y, z, h)
    if not QBCore.Functions.HasItem(Config.BombItem) then QBCore.Functions.Notify('Missing bomb!', 'error') return end

    local ped = PlayerPedId()
    SetEntityCoords(ped, x, y, z - 0.5)
    SetEntityHeading(ped, h)
    PlayBombAnim(ped)

    QBCore.Functions.Progressbar("bomb_plant","Placing bomb...",3000,false,false,{disableMovement=true}, {}, {}, {}, function()
        StopAnim(ped)
        FreezeEntityPosition(ped,true)
        exports['ps-ui']:Thermite(function(success)
            FreezeEntityPosition(ped,false)
            TriggerServerEvent('ilv-cayo:server:RemoveItem', Config.BombItem)
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.BombItem], 'remove')
            if success then
                QBCore.Functions.Notify('Bomb placed, stand back!', 'success')
                local charge = CreateObject(`prop_bomb_01`, x, y, z, true, true, true)
                FreezeEntityPosition(charge,true)
                QBCore.Functions.Notify('Bomb will explode in '..Config.BombTimer..' seconds!', 'success')
                Wait(Config.BombTimer*1000)
                if DoesEntityExist(charge) then DeleteEntity(charge) end

                AddExplosion(x,y,z,2,5.0,true,false,15.0)
                TriggerServerEvent('ilv-cayo:server:set'..doorEvent, true)
                local doorID = doorMapping[doorEvent]
                if doorID then
                    TriggerServerEvent('ilv-cayo:server:opendoor', doorID)
                    QBCore.Functions.Notify('Door opened!', 'success')
                end
            else
                QBCore.Functions.Notify('Failed to plant bomb! Try again if you have another one.', 'error')
            end
        end, Config.BombTime, Config.BombGridSize, Config.BombIncorrect)
    end, function()
        StopAnim(ped)
        QBCore.Functions.Notify('Cancelled.', 'error')
    end)
end

-- Doors
RegisterNetEvent('ilv-cayo:client:door1', function()
    if not isActive or not isHacked3 then QBCore.Functions.Notify('Not ready yet.', 'error') return end
    if door1 then QBCore.Functions.Notify('Already opened.', 'error') return end
    PlantBombDoor('door1', 4992.27, -5756.36, 15.89, 328.39)
end)

RegisterNetEvent('ilv-cayo:client:door2', function()
    if not isActive or not isHacked3 then QBCore.Functions.Notify('Not ready yet.', 'error') return end
    if door2 then QBCore.Functions.Notify('Already opened.', 'error') return end
    PlantBombDoor('door2', 4997.95, -5742.42, 14.84, 240.72)
end)

RegisterNetEvent('ilv-cayo:client:door3', function()
    if not isActive or not isHacked3 then QBCore.Functions.Notify('Not ready yet.', 'error') return end
    if door3 then QBCore.Functions.Notify('Already opened.', 'error') return end
    PlantBombDoor('door3', 5002.05, -5746.07, 14.84, 147.54)
end)

RegisterNetEvent('ilv-cayo:client:door4', function()
    if not isActive then QBCore.Functions.Notify('No active heist.', 'error') return end
    if door4 then QBCore.Functions.Notify('Already opened.', 'error') return end
    PlantBombDoor('door4', 5008.68, -5753.76, 15.48, 154.61)
end)

RegisterNetEvent('ilv-cayo:client:door5', function()
    if not isActive then QBCore.Functions.Notify('No active heist.', 'error') return end
    if door5 then QBCore.Functions.Notify('Already opened.', 'error') return end
    if not QBCore.Functions.HasItem(Config.UpperDoorItem) then QBCore.Functions.Notify('Missing key!', 'error') return end

    local ped = PlayerPedId()
    RequestAnimDict("mp_common"); while not HasAnimDictLoaded("mp_common") do Wait(10) end
    TaskPlayAnim(ped, "mp_common", "givetake1_a", 8.0, -8.0, -1, 49, 0, false, false, false)

    QBCore.Functions.Progressbar("unlocking_door","Unlocking the door...",5000,false,true,{disableMovement=true}, {}, {}, {}, function()
        ClearPedTasksImmediately(ped)
        TriggerServerEvent('ilv-cayo:server:setdoor5', true)
        TriggerServerEvent('ilv-cayo:server:RemoveItem', Config.UpperDoorItem)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.UpperDoorItem], 'remove')
        TriggerServerEvent('ilv-cayo:server:opendoor','cayo-upper-door')
        QBCore.Functions.Notify('Door unlocked! Proceed to the upper hack.', 'success')
    end, function()
        ClearPedTasksImmediately(ped)
        QBCore.Functions.Notify('Cancelled.', 'error')
    end)
end)

RegisterNetEvent('ilv-cayo:client:door6', function()
    if not isActive or not isHacked3 then QBCore.Functions.Notify('Not ready yet.', 'error') return end
    if door6 then QBCore.Functions.Notify('Already opened.', 'error') return end
    PlantBombDoor('door6', 5006.47, -5733.66, 15.84, 137.66)
end)

-- Animations for Searching/Looting
local function PlaySearchAnim(ped)
    local dict = "amb@prop_human_bum_bin@idle_b"
    RequestAnimDict(dict); while not HasAnimDictLoaded(dict) do Wait(10) end
    TaskPlayAnim(ped, dict, "idle_d", 8.0, -8, -1, 1, 0, false, false, false)
end

local function DoLoot(lootVar, lootSetEvent, normalItem, normalMin, normalMax, rareItem, rareMin, rareMax, message)
    if not isActive then QBCore.Functions.Notify('No active heist.', 'error') return end
    if not isHacked3 then QBCore.Functions.Notify('Open basement first.', 'error') return end
    if lootVar then QBCore.Functions.Notify('Already looted.', 'error') return end

    local ped = PlayerPedId()
    PlaySearchAnim(ped)

    QBCore.Functions.Progressbar("loot_search", message, 5000, false, false, {disableMovement=true}, {}, {}, {}, function()
        ClearPedTasksImmediately(ped)
        local random = math.random(1,10)
        if random >= 2 then
            local amount = math.random(normalMin, normalMax)
            TriggerServerEvent('ilv-cayo:server:AddItem', normalItem, amount)
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[normalItem], 'add', amount)
        else
            local amount = math.random(rareMin, rareMax)
            TriggerServerEvent('ilv-cayo:server:AddItem', rareItem, amount)
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[rareItem], 'add', amount)
        end
        TriggerServerEvent('ilv-cayo:server:'..lootSetEvent, true)
    end, function()
        ClearPedTasksImmediately(ped)
        QBCore.Functions.Notify('Cancelled.', 'error')
    end)
end

RegisterNetEvent('ilv-cayo:client:loot1', function()
    DoLoot(Loot1, 'setloot1', Config.Loot1Item, Config.Loot1AmountMin, Config.Loot1AmountMax, Config.Loot1RareItem, Config.Loot1RareAmountMin, Config.Loot1RareAmountMax, "Searching...")
end)

RegisterNetEvent('ilv-cayo:client:loot2', function()
    DoLoot(Loot2, 'setloot2', Config.Loot2Item, Config.Loot2AmountMin, Config.Loot2AmountMax, Config.Loot2RareItem, Config.Loot2RareAmountMin, Config.Loot2RareAmountMax, "Searching...")
end)

RegisterNetEvent('ilv-cayo:client:loot3', function()
    DoLoot(Loot3, 'setloot3', Config.Loot3Item, Config.Loot3AmountMin, Config.Loot3AmountMax, Config.Loot3RareItem, Config.Loot3RareAmountMin, Config.Loot3RareAmountMax, "Searching...")
end)

-- Search Key
RegisterNetEvent('ilv-cayo:searchkey', function()
    QBCore.Functions.TriggerCallback('ilv-cayo:server:CheckKey', function(isFound)
        if isFound then
            QBCore.Functions.Notify('Drawer is empty.', 'error')
        else
            if QBCore.Functions.HasItem('officekey') then
                QBCore.Functions.Notify('You already have the key.', 'error')
                return
            end

            local ped = PlayerPedId()
            PlaySearchAnim(ped)

            QBCore.Functions.Progressbar("search_drawer","Searching drawer...",5000,false,false,{disableMovement=true}, {}, {}, {}, function()
                ClearPedTasksImmediately(ped)
                TriggerServerEvent('ilv-cayo:server:SetKeyFound', true)
                TriggerServerEvent('ilv-cayo:server:AddItem', 'officekey', 1)
                TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['officekey'], 'add', 1)
                QBCore.Functions.Notify('You found an office key!', 'success')
            end, function()
                ClearPedTasksImmediately(ped)
                QBCore.Functions.Notify('Cancelled.', 'error')
            end)
        end
    end)
end)

-- Lasers
local laser13e = Laser.new(
    {vector3(5001.8208, -5743.5332, 16.8967), vector3(5001.9629, -5743.5386, 15.5613), vector3(5001.856, -5743.5552, 14.2873)},
    {vector3(5000.7324, -5745.3301, 16.9155), vector3(5000.7061, -5745.397, 15.6029), vector3(5000.6929, -5745.3057, 14.3717)},
    {travelTimeBetweenTargets = {1.0, 1.0}, waitTimeAtTargets = {0.0, 0.0}, name = "lasereasy05"}
)

local laser14e = Laser.new(
    {vector3(5005.918, -5748.6406, 16.9404), vector3(5005.8799, -5748.7002, 16.0076), vector3(5005.8628, -5748.6895, 14.967)},
    {vector3(5007.1318, -5746.7388, 16.8839), vector3(5007.1387, -5746.6602, 15.8203), vector3(5007.165, -5746.6768, 14.8843)},
    {travelTimeBetweenTargets = {1.0, 1.0}, waitTimeAtTargets = {0.0, 0.0}, name = "lasereasy06"}
)

local laser15e = Laser.new(
    vector3(5003.45, -5741.008, 17.353),
    {vector3(5000.107, -5741.953, 13.841), vector3(5001.514, -5742.79, 13.841), vector3(5004.056, -5744.331, 13.841), vector3(5005.044, -5742.417, 13.841), vector3(5000.941, -5742.37, 13.841)},
    {travelTimeBetweenTargets = {1.0, 1.0}, waitTimeAtTargets = {0.0, 0.0}, randomTargetSelection = true, name = "laser2"}
)

local laser16e = Laser.new(
    vector3(5006.984, -5752.913, 16.761),
    {vector3(5013.154, -5741.683, 16.639)},
    {travelTimeBetweenTargets = {1.0, 1.0}, waitTimeAtTargets = {0.0, 0.0}, randomTargetSelection = true, name = "fsfs"}
)

local laser17e = Laser.new(
    vector3(5012.936, -5742.604, 15.593),
    {vector3(5004.851, -5755.655, 15.31)},
    {travelTimeBetweenTargets = {1.0, 1.0}, waitTimeAtTargets = {0.0, 0.0}, randomTargetSelection = true, name = "laser3"}
)

local laser18e = Laser.new(
    vector3(5009.561, -5747.983, 17.288),
    {vector3(5007.754, -5746.659, 14.484), vector3(5008.151, -5750.397, 14.484), vector3(5006.23, -5749.151, 14.484), vector3(5006.864, -5747.799, 14.483)},
    {travelTimeBetweenTargets = {1.0, 1.0}, waitTimeAtTargets = {0.0, 0.0}, randomTargetSelection = true, name = "laser3"}
)

StartLasers = function()
    laser13e.setActive(true)
    laser13e.setMoving(true)
    laser14e.setActive(true)
    laser15e.setActive(true)
    laser15e.setMoving(true)
    laser16e.setActive(true)
    laser16e.setMoving(true)
    laser17e.setActive(true)
    laser17e.setMoving(true)
    laser18e.setActive(true)
    laser18e.setMoving(true)

    local function onLaserHit(playerBeingHit, hitPos)
        if playerBeingHit then
            local now = GetGameTimer()
            if now - lastLaserHit > 1000 then
                lastLaserHit = now
                QBCore.Functions.Notify("You are hit by a laser!", "error", 2500)
                ApplyDamageToPed(PlayerPedId(), 50, false)
            end
        end
    end

    laser14e.onPlayerHit(onLaserHit)
    laser15e.onPlayerHit(onLaserHit)
    laser13e.onPlayerHit(onLaserHit)
    laser16e.onPlayerHit(onLaserHit)
    laser17e.onPlayerHit(onLaserHit)
    laser18e.onPlayerHit(onLaserHit)
end

StopLasers = function()
    laser13e.setActive(false)
    laser13e.setMoving(false)
    laser14e.setActive(false)
    laser14e.setMoving(false)
    laser15e.setActive(false)
    laser15e.setMoving(false)
    laser16e.setActive(false)
    laser16e.setMoving(false)
    laser17e.setActive(false)
    laser17e.setMoving(false)
    laser18e.setActive(false)
    laser18e.setMoving(false)
end


RegisterCommand('startlasers', function(source, args)
    StartLasers()
end, false)


RegisterCommand('stoplasers', function(source, args)
    StopLasers()
end, false)