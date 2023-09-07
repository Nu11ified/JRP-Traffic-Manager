-- Define a variable to store the selected radius and time.
local selectedRadius = 10 -- Default radius
local selectedTime = 1 -- Default time (in minutes)

-- Create a NativeUI menu for the Traffic Manager.
local trafficManagerMenu = NativeUI.CreateMenu("Traffic Manager", "Delete AI Vehicles")
-- Create sliders for radius and time.
local radiusSlider = NativeUI.CreateSliderItem("Radius (meters)", 10, 1000, selectedRadius)
local timeSlider = NativeUI.CreateSliderItem("Time (minutes)", 1, 20, selectedTime)
-- Create menu items for confirmation and closing the menu.
local confirmButton = NativeUI.CreateItem("Confirm", "Confirm and delete AI vehicles")
local closeButton = NativeUI.CreateItem("Close Menu", "Close the Traffic Manager menu")

-- Add menu items and sliders to the Traffic Manager menu.
trafficManagerMenu:AddItem(radiusSlider)
trafficManagerMenu:AddItem(timeSlider)
trafficManagerMenu:AddItem(confirmButton)
trafficManagerMenu:AddItem(closeButton)

-- Event handler for slider changes.
radiusSlider.OnSliderChange = function(sender, item, index)
    selectedRadius = item:IndexToValue(index)
end

timeSlider.OnSliderChange = function(sender, item, index)
    selectedTime = item:IndexToValue(index)
end

-- Event handler for menu button presses.
trafficManagerMenu.OnItemSelect = function(sender, item, index)
    if item == confirmButton then
        TriggerServerEvent('trafficmanager:deleteAIVehicles', selectedRadius, selectedTime)
    elseif item == closeButton then
        trafficManagerMenu:CloseMenu()
    end
end

RegisterNetEvent('trafficmanager:openMenu')
AddEventHandler('trafficmanager:openMenu', function()
    trafficManagerMenu:Visible(true)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        trafficManagerMenu:ProcessMenus()
    end
end)