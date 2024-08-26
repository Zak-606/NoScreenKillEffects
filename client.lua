local isWarningShown = false
local isPlayerFrozen = false

-- Function to show/hide warning UI
local function ShowWarningUI(show)
    SendNUIMessage({
        type = "showWarning",
        display = show
    })
    isWarningShown = show
end

-- Function to freeze/unfreeze the player
local function FreezePlayer(freeze)
    local playerId = PlayerId()
    SetPlayerControl(playerId, not freeze, false)
    
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, freeze)
    SetEntityInvincible(playerPed, freeze)
    
    if freeze then
        -- Allow essential controls
        for _, control in ipairs({1, 2, 24, 199, 200, 245}) do
            EnableControlAction(0, control, true)
        end
    end
    isPlayerFrozen = freeze
end

-- Command to check Screen Kill Effects status
RegisterCommand('checkkilleffects', function()
    local effectsState = GetProfileSetting(226)
    local message = effectsState == 0 and 
        "Screen Kill Effects are currently disabled. You're good to go!" or
        "Screen Kill Effects are still enabled. Please disable them in the game settings."
    local color = effectsState == 0 and {0, 255, 0} or {255, 0, 0}
    
    TriggerEvent('chat:addMessage', {
        color = color,
        multiline = true,
        args = {"SYSTEM", " " .. message}
    })
end, false)

Citizen.CreateThread(function()
    ShowWarningUI(false) -- Initialize UI state
    Citizen.Wait(1000) -- Wait a short time to ensure everything is loaded
    
    local disabledControls = {30, 31, 32, 33, 34, 35, 36, 44, 20}
    
    while true do
        Citizen.Wait(0) -- Run every frame
        
        local effectsState = GetProfileSetting(226)
        
        if effectsState == 1 then -- Screen kill effects enabled (1 is ON, 0 is OFF)
            if not isWarningShown then
                ShowWarningUI(true)
                FreezePlayer(true)
                print("Warning UI shown and player frozen")
            end
            
            -- Disable movement controls
            for _, control in ipairs(disabledControls) do
                DisableControlAction(0, control, true)
            end
        elseif isWarningShown then -- Screen kill effects disabled and warning is shown
            ShowWarningUI(false)
            FreezePlayer(false)
            print("Warning UI hidden and player unfrozen")
        end
    end
end)