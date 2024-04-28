-- variables
q7Window = nil
openWindowButton = nil
jumpButton = nil
updateButtonEvent = nil

-- const
X_PADDING = 10
Y_PADDING = 40
BUTTON_SPEED = 10
UPDATE_INTERVAL_MS = 100

function init()
    -- create the button to open our window
    openWindowButton = modules.client_topmenu.addRightGameToggleButton('openWindowButton', tr('Question 7'), '/images/topbuttons/hotkeys', toggle)
    openWindowButton:show()
    openWindowButton:setOn(false)

    -- create our window, with the UI defined in question7.otui
    q7Window = g_ui.displayUI('question7', modules.game_interface.getRightPanel())
    q7Window:hide()

    -- create the required button
    jumpButton = g_ui.createWidget('JumpButton', q7Window)
    jumpButton:setText('Jump!')
    jumpButton.onClick = function() resetButtonPos() end

end

function terminate()   
    -- destroy the references we created
    jumpButton:destroy()
    q7Window:destroy()
    openWindowButton:destroy()
end

-- toggle our window on and off, using the openWindowButton state as control
function toggle()
    if openWindowButton:isOn() then
        closeWindow()
    else
        openWindow()
    end
end

-- open our window and create a cycle event to update our button
function openWindow()
    openWindowButton:setOn(true)
    q7Window:show()
    q7Window:raise()
    q7Window:focus()
    updateButtonEvent = cycleEvent(moveButton, UPDATE_INTERVAL_MS)
end

-- close our window and remove the event we have created
function closeWindow()
    openWindowButton:setOn(false)
    q7Window:hide()
    removeEvent(updateButtonEvent)
end

function resetButtonPos()
    -- reset position to the righ hand side of the window
    jumpButton:setX(q7Window:getX() + q7Window:getWidth() - (jumpButton:getWidth() + X_PADDING))
    
    -- with a random Y
    local minY = q7Window:getY() + Y_PADDING
    local maxY = q7Window:getY() + q7Window:getHeight() - (jumpButton:getHeight() + Y_PADDING)
    jumpButton:setY(math.random(minY, maxY))
end

function moveButton()
    -- update button position
    jumpButton:setX(jumpButton:getX() - BUTTON_SPEED)
    -- if we reach the left hand side of the window, reset position
    if jumpButton:getX() < (q7Window:getX() + X_PADDING) then
        resetButtonPos()
    end
end