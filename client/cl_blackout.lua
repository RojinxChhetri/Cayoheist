local QBCore = exports['qb-core']:GetCoreObject()

local Config = {
    BLACKOUT_INTENSITY = 0.0,
    POWER_STATION = {
        location = vector3(4478.0, -4583.0, 4.2),
        hackDuration = 20,
        explosionDelay = 3,
        hackDifficulty = "medium",
        blastRadius = 40.0,
        interactDistance = 2.5
    }
}

local isBlackoutActive = false
local isInsideCayo = false

local cayoZone = PolyZone:Create({
    vector2(3829.4670410156, -4747.5048828125),
    vector2(3846.7958984375, -4790.9873046875),
    vector2(4743.5830078125, -5987.8212890625),
    vector2(4826.8779296875, -6029.0087890625),
    vector2(4856.201171875, -5995.4453125),
    vector2(4992.3305664062, -5933.7866210938),
    vector2(5027.7426757812, -5892.5908203125),
    vector2(5449.2612304688, -5960.5776367188),
    vector2(5527.1528320312, -5925.8662109375),
    vector2(5616.0571289062, -5797.4165039062),
    vector2(5635.2197265625, -5666.6772460938),
    vector2(5648.8403320312, -5448.6484375),
    vector2(5658.0063476562, -5233.5942382812),
    vector2(5594.4262695312, -5143.7563476562),
    vector2(5504.2602539062, -5026.8681640625),
    vector2(5380.2280273438, -4818.8315429688),
    vector2(5257.0302734375, -4587.908203125),
    vector2(5041.94140625, -4386.2377929688),
    vector2(4835.0190429688, -4252.484375),
    vector2(4729.84765625, -4249.9619140625),
    vector2(4254.58203125, -4235.650390625),
    vector2(4161.890625, -4285.3842773438),
    vector2(3820.9458007812, -4595.072265625),
    vector2(3818.5275878906, -4679.4965820312)
}, {
    name = "cayo"
})

RegisterNetEvent("cayoblackout:setBlackoutState")
AddEventHandler("cayoblackout:setBlackoutState", function(state)
    isBlackoutActive = state
    if isBlackoutActive and isInsideCayo then
        applyBlackout()
    elseif not isBlackoutActive and isInsideCayo then
        removeBlackout()
    end
end)

cayoZone:onPlayerInOut(function(isInside)
    isInsideCayo = isInside
    
    if isBlackoutActive then
        if isInside then
            applyBlackout()
        else
            removeBlackout()
        end
    end
end)

function applyBlackout()
    Citizen.CreateThread(function()
        while isBlackoutActive and isInsideCayo do
            SetArtificialLightsState(true)
            SetArtificialLightsStateAffectsVehicles(false)
            
            local coords = GetEntityCoords(PlayerPedId())
            local vehicles = GetGamePool('CVehicle')
            for _, vehicle in ipairs(vehicles) do
                if #(GetEntityCoords(vehicle) - coords) < 100.0 then
                    SetVehicleLights(vehicle, 0)
                    SetVehicleInteriorlight(vehicle, false)
                end
            end
            
            Wait(0)
        end
    end)
    
    Citizen.CreateThread(function()
        while isBlackoutActive and isInsideCayo do
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                SetVehicleLights(veh, 0)
                SetVehicleInteriorlight(veh, false)
                SetVehicleLightMultiplier(veh, 0.0)
            end
            Wait(0)
        end
    end)
end

function removeBlackout()
    SetArtificialLightsState(false)
    SetArtificialLightsStateAffectsVehicles(true)
    
    local coords = GetEntityCoords(PlayerPedId())
    local vehicles = GetGamePool('CVehicle')
    for _, vehicle in ipairs(vehicles) do
        if #(GetEntityCoords(vehicle) - coords) < 100.0 then
            SetVehicleLightMultiplier(vehicle, 1.0)
        end
    end
    
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        SetVehicleLightMultiplier(veh, 1.0)
        SetVehicleInteriorlight(veh, true)
    end
end

RegisterNetEvent('cayoblackout:setexplosion', function()
    local explosionCoords = Config.POWER_STATION.location
    
    AddExplosion(explosionCoords.x, explosionCoords.y, explosionCoords.z, 29, 1.0, true, false, 1.0)
    
    UseParticleFxAssetNextCall("core")
    StartParticleFxLoopedAtCoord("exp_grd_grenade_smoke", explosionCoords.x, explosionCoords.y, explosionCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    
    for i = 1, 5 do
        local offset = vector3(
            math.random(-Config.POWER_STATION.blastRadius, Config.POWER_STATION.blastRadius) / 2,
            math.random(-Config.POWER_STATION.blastRadius, Config.POWER_STATION.blastRadius) / 2,
            0.0
        )
        local delayTime = math.random(500, 2000)
        
        Wait(delayTime)
        AddExplosion(
            explosionCoords.x + offset.x,
            explosionCoords.y + offset.y,
            explosionCoords.z + offset.z,
            29, 1.0, true, false, 1.0
        )
    end

    TriggerServerEvent("cayoblackout:triggerBlackout")
end)
