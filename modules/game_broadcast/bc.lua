-- configs



-- private variables
widget = nil
hideEvent = nil

function reg()
ProtocolGame.registerOpcode(71, onPacket)
end

function ureg()
ProtocolGame.unregisterOpcode(71)
end
-- public functions
function init()
connect(g_game, { onGameStart = reg,
onGameEnd = ureg})
g_ui.importStyle('bc.otui')
widget = g_ui.createWidget('broadcastWindow', modules.game_interface.getMapPanel())
widget:hide()
widget:setTextHorizontalAutoResize(true)
widget:setTextWrap(true)
--[[widget:setX((g_window.getWidth() - widget:getImageWidth()) / 2)
widget:addAnchor(AnchorLeft, 'gameMapPanel', AnchorLeft)
widget:addAnchor(AnchorTop, 'gameMapPanel', AnchorTop)
widget:addAnchor(AnchorRight, 'gameMapPanel', AnchorRight)]]

if g_game.isOnline() then
reg()
end
notify_init(showText)
end

function terminate()
disconnect(g_game, { onGameStart = reg,
onGameEnd = ureg})
if g_game.isOnline() then
ureg()
end

widget:destroy()
end

function hideWindow()
return widget and g_effects.fadeOut(widget)
end

function calculateVisibleTime(text)
return math.max(1000 + #text * 100, 4000)
end

function showText(s)
widget:setText(s)
if hideEvent then
hideEvent:cancel()
end
widget:resizeToText()
widget:setHeight(widget:getHeight() + 20)
widget:show()
g_effects.fadeIn(widget)
hideEvent = scheduleEvent(hideWindow, calculateVisibleTime(s))
return true
end


function onPacket(protocol, message)
showText(message:getString())
end
