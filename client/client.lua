Framework = Config.Framework == "esx" and exports['es_extended']:getSharedObject() or exports['qb-core']:GetCoreObject()
PlayerData = {}
blips = {}
PlayerJob = ""
latestDispatch = nil
WaitTimes = {
    Shooting = 0,
    Speeding = 0,
}

CreateThread(function()
    while true do
        if Config.Framework == "esx" then
            PlayerData = Framework.GetPlayerData()
            if table_size(PlayerData) > 6 then
                PlayerJob = PlayerData.job.name
            end
        else
            PlayerData = Framework.Functions.GetPlayerData()
            if table_size(PlayerData) > 6 then
                PlayerJob = PlayerData.job.name
            end
        end

        for key, time in pairs(WaitTimes) do
            if WaitTimes[key] > 0 then
                WaitTimes[key] = WaitTimes[key] - 1
            end
        end

        for i, blip in pairs(blips) do
            if blip[2] > 0 then
                blip[2] = blip[2] - 1
            elseif blip[2] == 0 then
                RemoveBlip(blip[1])
                table.remove(blips, i)
            end
        end

        Wait(1000)
    end
end)

CreateThread(function()
    while true do
        local sleep = 500
        local ped = PlayerPedId()

        if Config.Enable.Shooting then
            if IsPedArmed(ped, 4) then
                sleep = 5
                
                if IsPedShooting(ped) and WaitTimes.Shooting == 0 and not IsWeaponBlackListed(ped) then

                    if Config.Enable.UseSuppressorControl and IsWeaponHasSuppressor(ped) then
                        return
                    end

                    for k, jobs in pairs(Config.WhitelistedJobs) do
                        if jobs == PlayerJob then
                            return
                        end
                    end
                                        
                    local coords = GetEntityCoords(ped)
                    local streetHash, roadHash = GetStreetNameAtCoord(table.unpack(coords))
                    local location = {
                        street = GetStreetNameFromHashKey(streetHash),
                        road = GetStreetNameFromHashKey(roadHash)
                    }
                    local weaponHash = GetSelectedPedWeapon(ped)
                    local weapon = Weapons[weaponHash].label
                    local vehicle = GetVehiclePedIsIn(ped, 0)
                    local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                    local gender

                    if Config.Framework == "esx" then
                        if PlayerData.sex == 1 then gender = "Female" else gender = "Male" end
                    else
                        if PlayerData.charinfo.gender == 1 then gender = "Female" else gender = "Male" end
                    end

                    ShootingDispatch(location, coords, gender, weapon, vehicleName, vehicle, {"police"})
                    WaitTimes.Shooting = Config.WaitTimes.Shooting
                end
            end
        end

        if Config.Enable.Speeding then
            if IsPedInAnyVehicle(ped, 0) then
                local vehicle = GetVehiclePedIsIn(ped, 0)

                Wait(100)

                if (GetEntitySpeed(vehicle) * 3.6) >= 120 and WaitTimes.Speeding == 0 then
                    for k, jobs in pairs(Config.WhitelistedJobs) do
                        if jobs == PlayerJob then
                            return
                        end
                    end

                    SendDispatch("Vehicle speeding!", "10-11", 227, {"police"})
                    WaitTimes.Speeding = Config.WaitTimes.Speeding
                end
            end
        end

        Wait(sleep)
    end
end)

AddEventHandler('gameEventTriggered', function(event, data)
    if event == "CEventNetworkEntityDamage" then
        local victim, attacker, victimDied, weapon = data[1], data[2], data[4], data[7]
        if not IsEntityAPed(victim) then return end
        if victimDied and NetworkGetPlayerIndexFromPed(victim) == PlayerId() and IsEntityDead(PlayerPedId()) then
            if not isDead then
                Wait(3000)
                
                for _, jobs in pairs(Config.WhitelistedJobs) do
                    if PlayerJob == jobs and PlayerJob ~= "ambulance" then
                        SendDispatch("Officer Down!", "10-11", 61, {"police", "ambulance"})
                        return
                    else
                        SendDispatch("Civilian Down!", "10-11", 61, {"police", "ambulance"})
                        return
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("aty_dispatch:client:shootingDispatch", function(title, code, location, coords, gender, weapon, vehicleName, vehicle)
    local distance = GetDistanceBetweenCoords(coords, GetEntityCoords(PlayerPedId()), false)
    local paint, primaryId, secondaryId, primary, secondary

    if vehicle ~= 0 then
        plate = GetVehicleNumberPlateText(vehicle)
        primaryId, secondaryId = GetVehicleColours(vehicle)
        primary = Colours[tostring(primaryId)]
        secondary = Colours[tostring(secondaryId)]
    end
    
    if vehicleName == "CARNOTFOUND" then
        vehicleName = nil
        plate = nil
    end

    table.insert(blips, {createBlip(coords.x, coords.y, coords.z, 110, 1, title, 1.0), Config.BlipRemoveTime})

    latestDispatch = coords

    SendNUIMessage({
        action = "dispatch",
        title = title,
        code = code,
        location = location,
        distance = distance,
        gender = gender,
        vehicle = vehicleName,
        plate = plate,
        primary = primary,
        secondary = secondary,
        weapon = weapon
    })
end)

RegisterNetEvent("aty_dispatch:client:customDispatch", function(title, code, location, coords, gender, vehicleName, vehicle, weapon, blipSprite)
    local distance = GetDistanceBetweenCoords(coords, GetEntityCoords(PlayerPedId()), false)
    local paint, primaryId, secondaryId, primary, secondary

    if vehicle ~= 0 then
        plate = GetVehicleNumberPlateText(vehicle)
        primaryId, secondaryId = GetVehicleColours(vehicle)
        primary = Colours[tostring(primaryId)]
        secondary = Colours[tostring(secondaryId)]
    end
    
    if vehicleName == "CARNOTFOUND" then
        vehicleName = nil
        plate = nil
    end

    table.insert(blips, {createBlip(coords.x, coords.y, coords.z, blipSprite, 1, title, 1.0), Config.BlipRemoveTime})

    latestDispatch = coords

    SendNUIMessage({
        action = "dispatch",
        title = title,
        code = code,
        location = location,
        distance = distance,
        gender = gender,
        vehicle = vehicleName,
        plate = plate,
        primary = primary,
        secondary = secondary,
        weapon = weapon
    })
end)

RegisterNUICallback("close", function()
    SetNuiFocus(0, 0)
end)

RegisterCommand('respondDispatch', function()
	if latestDispatch then 
		SetWaypointOff() 
		SetNewWaypoint(latestDispatch.x, latestDispatch.y)
        Config.Notification("Waypoint", "Waypoint Set.", "success", 5000)
        latestDispatch = nil
	end
end)

RegisterKeyMapping('respondDispatch', 'Respond To Latest Dispatch', 'keyboard', Config.SetWaypoingKey)