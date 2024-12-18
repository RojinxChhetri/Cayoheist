local QBCore = exports['qb-core']:GetCoreObject()

local State = {
    isBlackoutActive = false,
    lastTriggerTime = 0,
    COOLDOWN_PERIOD = 1800000
}

local REQUIRED_ITEMS = {
    hackingDevice = "trojan_usb"
}

QBCore.Functions.CreateCallback('cayoblackout:checkHackingDevice', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local hasDevice = Player.Functions.GetItemByName(REQUIRED_ITEMS.hackingDevice)
    cb(hasDevice ~= nil)
end)

RegisterServerEvent('cayoblackout:removeHackingDevice')
AddEventHandler('cayoblackout:removeHackingDevice', function()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem(REQUIRED_ITEMS.hackingDevice, 1)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[REQUIRED_ITEMS.hackingDevice], "remove")
end)

RegisterServerEvent('cayoblackout:triggerBlackout')
AddEventHandler('cayoblackout:triggerBlackout', function()
    local currentTime = GetGameTimer()
    
    State.isBlackoutActive = true
    State.lastTriggerTime = currentTime
    
    TriggerClientEvent("cayoblackout:setBlackoutState", -1, true)
    
    TriggerClientEvent("chat:addMessage", -1, {
        color = {255, 0, 0},
        multiline = true,
        args = {"ALERT", "⚡ Explosion reported at Cayo Perico power station! Island-wide blackout in effect!"}
    })
    
    SetTimeout(3592000, function()
        State.isBlackoutActive = false
        TriggerClientEvent("cayoblackout:setBlackoutState", -1, false)
        TriggerClientEvent("chat:addMessage", -1, {
            color = {0, 255, 0},
            multiline = true,
            args = {"ALERT", "Emergency generators online. Power restored to Cayo Perico."}
        })
    end)
end)

QBCore.Commands.Add("cayoblackout", "Toggle blackout in Cayo PolyZone", {}, false, function(source, args)
    State.isBlackoutActive = not State.isBlackoutActive
    TriggerClientEvent("cayoblackout:setBlackoutState", -1, State.isBlackoutActive)

    if State.isBlackoutActive then
        TriggerClientEvent("QBCore:Notify", source, "Cayo blackout has been **activated**.", "error")
        TriggerClientEvent("chat:addMessage", source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Blackout", "Cayo blackout has been **activated**."}
        })
    else
        TriggerClientEvent("QBCore:Notify", source, "Cayo blackout has been **deactivated**.", "success")
        TriggerClientEvent("chat:addMessage", source, {
            color = {0, 255, 0},
            multiline = true,
            args = {"Blackout", "Cayo blackout has been **deactivated**."}
        })
    end
end, "admin")

QBCore.Commands.Add("cayoblast", "Cayo Blast", {}, false, function(source, args)
    TriggerClientEvent("cayoblackout:setexplosion", source)
end, "admin")
