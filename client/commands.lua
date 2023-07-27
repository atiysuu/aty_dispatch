RegisterCommand("911", function()
    SendDispatch("Citizen needs help!", "10-11", 61, {"police", "ambulance"})
end)

RegisterCommand("help", function()
    SendDispatch("Citizen needs help!", "10-11", 61, {"police", "ambulance"})
end)

RegisterCommand("showDispatch", function()
    for k, jobs in pairs(Config.WhitelistedJobs) do
        if PlayerJob == jobs then
            SendNUIMessage({
                action = "showDispatch"
            })

            SetNuiFocus(1, 1)
            return
        end
    end
end)