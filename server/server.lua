Framework = Config.Framework == "esx" and exports['es_extended']:getSharedObject() or exports['qb-core']:GetCoreObject()

RegisterNetEvent("aty_dispatch:server:shootingDispatch", function(title, code, location, coords, gender, weapon, vehicleName, vehicle, jobs)
    local players = GetPlayers()

    for i, player in ipairs(players) do
        local player = tonumber(player)
        if Config.Framework == "qb" then
            local xPlayer = Framework.Functions.GetPlayer(player)
            
            if Config.UseGPS then
                for _, job in pairs(jobs) do
                    local item = xPlayer.Functions.GetItemByName(Config.GPSItem) and xPlayer.Functions.GetItemByName(Config.GPSItem).amount or 0
                    if xPlayer.PlayerData.job.name == job and item > 0 then
                        TriggerClientEvent("aty_dispatch:client:shootingDispatch", player, title, code, location, coords, gender, weapon, vehicleName, vehicle)
                    end
                end
            else
                for _, job in pairs(jobs) do
                    if xPlayer.PlayerData.job.name == job then
                        TriggerClientEvent("aty_dispatch:client:shootingDispatch", player, title, code, location, coords, gender, weapon, vehicleName, vehicle)
                    end
                end
            end
        else
            local xPlayer = Framework.GetPlayerFromId(player)

            if Config.UseGPS then
                for _, job in pairs(jobs) do
                    local item = xPlayer.getInventoryItem(Config.GPSItem) and xPlayer.getInventoryItem(Config.GPSItem).count or 0
                    if xPlayer.job.name == job and item > 0 then
                        TriggerClientEvent("aty_dispatch:client:shootingDispatch", player, title, code, location, coords, gender, weapon, vehicleName, vehicle)
                    end
                end
            else
                for _, job in pairs(jobs) do
                    if xPlayer.job.name == job then
                        TriggerClientEvent("aty_dispatch:client:shootingDispatch", player, title, code, location, coords, gender, weapon, vehicleName, vehicle)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("aty_dispatch:server:customDispatch", function(title, code, location, coords, gender, vehicleName, vehicle, weapon, blipSprite, jobs)
    local players = GetPlayers()

    for i, player in ipairs(players) do
        local player = tonumber(player)
        if Config.Framework == "qb" then
            local xPlayer = Framework.Functions.GetPlayer(player)
            
            if Config.UseGPS then
                for _, job in pairs(jobs) do
                    local item = xPlayer.Functions.GetItemByName(Config.GPSItem) and xPlayer.Functions.GetItemByName(Config.GPSItem).amount or 0
                    if xPlayer.PlayerData.job.name == job and item > 0 then
                        TriggerClientEvent("aty_dispatch:client:customDispatch", player, title, code, location, coords, gender, vehicleName, vehicle, weapon, blipSprite)
                    end
                end
            else
                for _, job in pairs(jobs) do
                    if xPlayer.PlayerData.job.name == job then
                        TriggerClientEvent("aty_dispatch:client:customDispatch", player, title, code, location, coords, gender, vehicleName, vehicle, weapon, blipSprite)
                    end
                end
            end
        else
            local xPlayer = Framework.GetPlayerFromId(player)

            if Config.UseGPS then
                for _, job in pairs(jobs) do
                    local item = xPlayer.getInventoryItem(Config.GPSItem) and xPlayer.getInventoryItem(Config.GPSItem).count or 0
                    if xPlayer.job.name == job and item > 0 then
                        TriggerClientEvent("aty_dispatch:client:customDispatch", player, title, code, location, coords, gender, vehicleName, vehicle, weapon, blipSprite)
                    end
                end
            else
                for _, job in pairs(jobs) do
                    if xPlayer.job.name == job then
                        TriggerClientEvent("aty_dispatch:client:customDispatch", player, title, code, location, coords, gender, vehicleName, vehicle, weapon, blipSprite)
                    end
                end
            end
        end
    end
end)