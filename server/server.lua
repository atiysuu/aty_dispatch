Framework = Config.Framework == "esx" and exports['es_extended']:getSharedObject() or exports['qb-core']:GetCoreObject()

RegisterNetEvent("aty_dispatch:server:shootingDispatch", function(title, code, location, coords, gender, weapon, vehicleName, vehicle, jobs)
    if Config.Framework == "qb" then
        local xPlayers = Framework.Functions.GetPlayers()
        for i = 1, #xPlayers do
            local src = xPlayers[i]
            local xPlayer = Framework.Functions.GetPlayer(src)
            if Config.UseGPS then
                for _, job in pairs(jobs) do
                    local item = xPlayer.Functions.GetItemByName(Config.GPSItem) and xPlayer.Functions.GetItemByName(Config.GPSItem).amount or 0
                    if xPlayer.PlayerData.job.name == job and item > 0 then
                        TriggerClientEvent("aty_dispatch:client:shootingDispatch", src, title, code, location, coords, gender, weapon, vehicleName, vehicle)
                    elseif not item then
                        Config.Notification(src, "GPS", "You don't have a gps on you.", "error", 5000)
                    end
                end
            else
                for _, job in pairs(jobs) do
                    if xPlayer.PlayerData.job.name == job then
                        TriggerClientEvent("aty_dispatch:client:shootingDispatch", src, title, code, location, coords, gender, weapon, vehicleName, vehicle)
                    end
                end
            end
        end
    else
        local xPlayers = Framework.GetExtendedPlayers('job', jobs)
        for i = 1, #xPlayers do
            local xPlayer = xPlayers[i]
            if Config.UseGPS then
                local item = xPlayer.getInventoryItem(Config.GPSItem) and xPlayer.getInventoryItem(Config.GPSItem).count or 0
                if item > 0 then
                    TriggerClientEvent("aty_dispatch:client:shootingDispatch", xPlayer.source, title, code, location, coords, gender, weapon, vehicleName, vehicle)
                elseif not item then
                    Config.Notification(xPlayer.source, "GPS", "You don't have a gps on you.", "error", 5000)
                end
            else
                TriggerClientEvent("aty_dispatch:client:shootingDispatch", xPlayer.source, title, code, location, coords, gender, weapon, vehicleName, vehicle)
            end
        end
    end
end)

RegisterNetEvent("aty_dispatch:server:customDispatch", function(title, code, location, coords, gender, vehicleName, vehicle, weapon, blipSprite, jobs)
    local players = GetPlayers()
    if Config.Framework == "qb" then
        local xPlayers = Framework.Functions.GetPlayers()
        for i = 1, #xPlayers do
            local src = xPlayers[i]
            local xPlayer = Framework.Functions.GetPlayer(src)
            if Config.UseGPS then
                for _, job in pairs(jobs) do
                    local item = xPlayer.Functions.GetItemByName(Config.GPSItem) and xPlayer.Functions.GetItemByName(Config.GPSItem).amount or 0
                    if xPlayer.PlayerData.job.name == job and item > 0 then
                        TriggerClientEvent("aty_dispatch:client:customDispatch", src, title, code, location, coords, gender, vehicleName, vehicle, weapon, blipSprite)
                    elseif not item then
                        Config.Notification(xPlayer.source, "GPS", "You don't have a gps on you.", "error", 5000)
                    end
                end
            else
                for _, job in pairs(jobs) do
                    if xPlayer.PlayerData.job.name == job then
                        TriggerClientEvent("aty_dispatch:client:customDispatch", src, title, code, location, coords, gender, vehicleName, vehicle, weapon, blipSprite)
                    end
                end
            end
        end
    else
        local xPlayers = Framework.GetExtendedPlayers('job', jobs)
        for i = 1, #xPlayers do
            local xPlayer = xPlayers[i]
            if Config.UseGPS then
                local item = xPlayer.getInventoryItem(Config.GPSItem) and xPlayer.getInventoryItem(Config.GPSItem).count or 0
                if item > 0 then
                    TriggerClientEvent("aty_dispatch:client:customDispatch", xPlayer.source, title, code, location, coords, gender, vehicleName, vehicle, weapon, blipSprite)
                elseif not item then
                    Config.Notification(xPlayer.source, "GPS", "You don't have a gps on you.", "error", 5000)
                end
            else
                TriggerClientEvent("aty_dispatch:client:customDispatch", xPlayer.source, title, code, location, coords, gender, vehicleName, vehicle, weapon, blipSprite)
            end
        end
    end
end)