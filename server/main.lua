local activeTrafficManagerData = {}

-- Register a command to activate the traffic manager.
RegisterCommand('trafficmanager', function(source, args)
    local player = source
    local permission = IsPlayerAceAllowed(player, 'traffic.manager')
    if permission then
        TriggerClientEvent('trafficmanager:openMenu', player)
    else
        TriggerClientEvent('chatMessage', player, 'SYSTEM', {255, 0, 0}, 'You do not have permission to use Traffic Manager.')
    end
end, false)

-- Function to delete AI vehicles within a specified radius.
function DeleteAIVehiclesInRadius(radius)
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
    local vehicles = GetGamePool('CVehicle')
    for _, vehicle in ipairs(vehicles) do
        local vehCoords = GetEntityCoords(vehicle)
        local distance = #(vector3(x, y, z) - vehCoords)
        if distance <= radius and not IsEntityPlayer(vehicle) then
            -- Delete the AI vehicle.
            SetEntityAsMissionEntity(vehicle, true, true)
            DeleteVehicle(vehicle)
        end
    end
end

-- Event handler for the client's menu confirmation.
RegisterServerEvent('trafficmanager:deleteAIVehicles')
AddEventHandler('trafficmanager:deleteAIVehicles', function(radius, time)
    local player = source
    local data = {
        player = player,
        radius = radius,
        time = time
    }
    -- Store the active traffic manager data.
    activeTrafficManagerData[player] = data
    Citizen.CreateThread(function()
        Citizen.Wait(time * 60 * 1000) 
        if activeTrafficManagerData[player] then
            DeleteAIVehiclesInRadius(radius)
            activeTrafficManagerData[player] = nil
        end
    end)
end)
