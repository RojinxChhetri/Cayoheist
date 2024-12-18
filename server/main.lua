local QBCore = exports['qb-core']:GetCoreObject()

local isActive = false
local CopCount = 0
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
local heistEnded = false
local isKeyFound = false

local npcSpawnedHack2 = false
local npcSpawnedHack3 = false
local npcSpawnedHack4 = false

local function SyncAllClients()
    local data = {
        isActive = isActive,
        isHacked1 = isHacked1,
        isHacked2 = isHacked2,
        isHacked3 = isHacked3,
        isHacked4 = isHacked4,
        isHacked5 = isHacked5,
        door1 = door1,
        door2 = door2,
        door3 = door3,
        door4 = door4,
        door5 = door5,
        door6 = door6,
        Loot1 = Loot1,
        Loot2 = Loot2,
        Loot3 = Loot3
    }
    for _, src in pairs(QBCore.Functions.GetPlayers()) do
        TriggerClientEvent('ilv-cayo:client:sync', src, data)
    end
end

local function ResetHeist()
    if heistEnded then return end
    heistEnded = true

    isActive = false
    isHacked1 = false
    isHacked2 = false
    isHacked3 = false
    isHacked4 = false
    isHacked5 = false
    door1 = false
    door2 = false
    door3 = false
    door4 = false
    door5 = false
    door6 = false
    Loot1 = false
    Loot2 = false
    Loot3 = false
    isKeyFound = false

    npcSpawnedHack2 = false
    npcSpawnedHack3 = false
    npcSpawnedHack4 = false

    TriggerEvent('ilv-cayo:server:closedoor', 'loot-door-1')
    TriggerEvent('ilv-cayo:server:closedoor', 'loot-door-main')
    TriggerEvent('ilv-cayo:server:closedoor', 'loot-door-cash')
    TriggerEvent('ilv-cayo:server:closedoor', 'loot-door-glass')
    TriggerEvent('ilv-cayo:server:closedoor', 'cayo-upper-door')
    TriggerEvent('ilv-cayo:server:closedoor', 'loot-door-2')

    SyncAllClients()
end

RegisterNetEvent('QBCore:Server:PlayerLoaded', function()
    local src = source
    local data = {
        isActive = isActive,
        isHacked1 = isHacked1,
        isHacked2 = isHacked2,
        isHacked3 = isHacked3,
        isHacked4 = isHacked4,
        isHacked5 = isHacked5,
        door1 = door1,
        door2 = door2,
        door3 = door3,
        door4 = door4,
        door5 = door5,
        door6 = door6,
        Loot1 = Loot1,
        Loot2 = Loot2,
        Loot3 = Loot3
    }
    TriggerClientEvent('ilv-cayo:client:sync', src, data)
end)

RegisterNetEvent('ilv-cayo:server:ResetHeist', function()
    ResetHeist()
end)

RegisterNetEvent('ilv-cayo:server:getcops', function()
    local amount = 0
    for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    CopCount = amount
    TriggerClientEvent('ilv-cayo:client:updatecops', -1, amount)
end)

RegisterNetEvent('ilv-cayo:server:removemoney', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.RemoveMoney('cash', tonumber(amount))
    end
end)

RegisterNetEvent('ilv-cayo:server:opendoor', function(doorid)
    local src = source
    TriggerClientEvent('qb-doorlock:client:setState', -1, src, doorid, false, false, false, false)
end)

RegisterNetEvent('ilv-cayo:server:closedoor', function(doorid)
    local src = source
    TriggerClientEvent('qb-doorlock:client:setState', -1, src, doorid, true, false, false, false)
end)

RegisterNetEvent('ilv-cayo:server:RemoveItem', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player and item then
        local hasItem = Player.Functions.GetItemByName(item)
        if hasItem and hasItem.amount >= 1 then
            Player.Functions.RemoveItem(item, 1)
        else
            TriggerClientEvent('QBCore:Notify', src, "Not enough items.", 'error')
        end
    end
end)

RegisterNetEvent('ilv-cayo:server:AddItem', function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddItem(item, amount)
    end
end)

RegisterNetEvent('ilv-cayo:server:setactive', function(status) isActive = status; SyncAllClients() end)
RegisterNetEvent('ilv-cayo:server:sethack1', function(status) isHacked1 = status; SyncAllClients() end)
RegisterNetEvent('ilv-cayo:server:sethack2', function(status) isHacked2 = status; SyncAllClients() end)
RegisterNetEvent('ilv-cayo:server:sethack3', function(status) isHacked3 = status; SyncAllClients() end)
RegisterNetEvent('ilv-cayo:server:sethack4', function(status) isHacked4 = status; SyncAllClients() end)
RegisterNetEvent('ilv-cayo:server:sethack5', function(status) isHacked5 = status; SyncAllClients() end)

RegisterNetEvent('ilv-cayo:server:setdoor1', function(status) door1 = status; SyncAllClients() end)
RegisterNetEvent('ilv-cayo:server:setdoor2', function(status) door2 = status; SyncAllClients() end)
RegisterNetEvent('ilv-cayo:server:setdoor3', function(status) door3 = status; SyncAllClients() end)
RegisterNetEvent('ilv-cayo:server:setdoor4', function(status) door4 = status; SyncAllClients() end)
RegisterNetEvent('ilv-cayo:server:setdoor5', function(status) door5 = status; SyncAllClients() end)
RegisterNetEvent('ilv-cayo:server:setdoor6', function(status) door6 = status; SyncAllClients() end)

RegisterNetEvent('ilv-cayo:server:setloot1', function(status) Loot1 = status; SyncAllClients() end)
RegisterNetEvent('ilv-cayo:server:setloot2', function(status) Loot2 = status; SyncAllClients() end)
RegisterNetEvent('ilv-cayo:server:setloot3', function(status) Loot3 = status; SyncAllClients() end)

QBCore.Functions.CreateCallback('ilv-cayo:server:CheckKey', function(source, cb)
    cb(isKeyFound)
end)

RegisterNetEvent('ilv-cayo:server:SetKeyFound', function(state)
    isKeyFound = state
end)

local function SpawnGuards(setNumber, count)
    TriggerClientEvent('cayoheist:spawnGuards', -1, setNumber, count)
end

RegisterNetEvent('ilv-cayo:server:SpawnGuardsHack2', function()
    if not npcSpawnedHack2 and Config.SpawnPedOnHack2 then
        npcSpawnedHack2 = true
        -- Use setNumber = 1 because config only has locations[1], [2], [3]
        SpawnGuards(1, 7)
    end
end)

RegisterNetEvent('ilv-cayo:server:SpawnGuardsHack3', function()
    if not npcSpawnedHack3 and Config.SpawnPedOnHack3 then
        npcSpawnedHack3 = true
        SpawnGuards(2, 5)
    end
end)

RegisterNetEvent('ilv-cayo:server:SpawnGuardsHack4', function()
    if not npcSpawnedHack4 and Config.SpawnPedOnHack4 then
        npcSpawnedHack4 = true
        SpawnGuards(3, 4)
    end
end)

QBCore.Commands.Add("startcayo", "Start Cayo Heist (Admin)", {}, false, function(source)
    TriggerClientEvent("ilv-cayo:client:startheist", source)
end, "admin")
