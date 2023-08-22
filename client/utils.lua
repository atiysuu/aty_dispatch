function ShootingDispatch(location, coords, gender, weapon, vehicleName, vehicle, jobs)
    if vehicle ~= 0 then
        TriggerServerEvent("aty_dispatch:server:shootingDispatch", "Drive By In Progress", "10-60", location, coords, gender, weapon, vehicleName, vehicle, jobs)
    else
        TriggerServerEvent("aty_dispatch:server:shootingDispatch", "Shooting In Progress", "10-11", location, coords, gender, weapon, vehicleName, vehicle, jobs)
    end
end

function SendDispatch(title, code, blipSprite, jobs)
    local title = title or "Placeholder"
    local code = code or "10-11"
    local blipSprite = blipSprite or 1
    local ped = PlayerPedId()

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

    TriggerServerEvent("aty_dispatch:server:customDispatch", title, code, location, coords, gender, vehicleName, vehicle, weapon, blipSprite, jobs)
end

RegisterNetEvent("aty_dispatch:SendDispatch", function(title, code, blipSprite, jobs)
    local title = title or "Placeholder"
    local code = code or "10-11"
    local blipSprite = blipSprite or 1
    local ped = PlayerPedId()

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

    TriggerServerEvent("aty_dispatch:server:customDispatch", title, code, location, coords, gender, vehicleName, vehicle, weapon, blipSprite, jobs)
end)

function createBlip(x, y, z, sprite, color, text, size)
    local size = size or 1.0
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 6)
    SetBlipScale(blip, size)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)

    return blip
end

function IsWeaponBlackListed(ped)
	for i, weapon in pairs(Config.BlackListedWeapons) do
		local weaponHash = GetHashKey(Config.BlackListedWeapons[i])

		if GetSelectedPedWeapon(ped) == weaponHash then
			return true 
		end
	end

    Wait(10)

	return false
end


function IsWeaponHasSuppressor(ped) 
    for _, hash in pairs(Config.Suppressors) do
        print(HasPedGotWeaponComponent(ped, GetSelectedPedWeapon(ped), hash))
        if HasPedGotWeaponComponent(ped, GetSelectedPedWeapon(ped), hash) then
            return true
        end
    end

    Wait(10)

    return false
end