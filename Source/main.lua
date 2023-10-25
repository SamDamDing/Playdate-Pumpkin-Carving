-- Import necessary libraries
import "CoreLibs/graphics"
import "CoreLibs/sprites"
--import "tools"
import "tool_handling"
local all_tools = import "tools"

local gfx = playdate.graphics
currentTool = all_tools["saw"]
-- Initialize sprites and other variables

local pumpkinImage = gfx.image.new('pumpkin')
local pumpkin = gfx.sprite:new()
pumpkin:setImage(pumpkinImage)
pumpkin:moveTo(200, 120)
pumpkin:addSprite()

print(all_tools)
print(currentTool)
print(all_tools[currentTool])
print(currentTool.name)

local carvingTool = gfx.sprite:new()
carvingTool:setImage(gfx.image.new(currentTool.icon))
print(currentTool.sprite)
carvingTool:moveTo(200, 120)
carvingTool:addSprite()

local previewBufferImage = gfx.image.new('previewBuffer')
local previewBuffer = gfx.sprite:new()
previewBuffer:setImage(previewBufferImage)
previewBuffer:moveTo(200, 120)
previewBuffer:addSprite()

local carving = false
local angle = 0
local activeColor = true
local needsRedraw = true
local currentToolLength = 1

local dashOffset = 1
local DASH_LENGTH = 3
local GAP_LENGTH = 2
local ANTS_SPEED = .5  -- Adjust for faster/slower marching ants

-- Input Handlers
function playdate.AButtonDown()
    -- If holding A and pressing dpad left or right, we curve the tool's carving path.
    -- If holding A and pressing dpad up or down, we adjust the length of the tool's carve path.
    carving = true
end

function playdate.AButtonUp()
    carving = false
    clearToolPreview()  -- Clear the preview when the A button is released
end

function playdate.BButtonDown()
    -- Holding B and pressing dpad left or right will cycle through a tool wheel.
    -- Holding B and pressing dpad up or down will adjust the width of the tool.
    activeColor = not activeColor
end

function playdate.cranked(change, _)
    carveWithCrank(change)
end

local offScreenBuffer = gfx.image.new(400, 240)

function drawToolPreview()
    -- Clear the previewBufferImage
    gfx.lockFocus(previewBufferImage)
    gfx.clear(gfx.kColorClear)
    
    local startX, startY = carvingTool.x, carvingTool.y
    local endX, endY = previewLength(carvingTool)
    
    local dx = endX - startX
    local dy = endY - startY
    
    local lineLength = math.sqrt(dx^2 + dy^2)
    local unitX = dx / lineLength
    local unitY = dy / lineLength
    
    local currentPosition = 0
    dashOffset = (dashOffset + ANTS_SPEED) % (DASH_LENGTH + GAP_LENGTH)
    
    -- Adjust starting position by dashOffset
    currentPosition = currentPosition - dashOffset
    
    gfx.setColor(gfx.kColorBlack)
    
    while currentPosition + DASH_LENGTH < lineLength do
        local dashStartX = startX + unitX * currentPosition
        local dashStartY = startY + unitY * currentPosition
        
        local dashEndX = dashStartX + unitX * DASH_LENGTH
        local dashEndY = dashStartY + unitY * DASH_LENGTH
        
        gfx.drawLine(dashStartX, dashStartY + 5, dashEndX, dashEndY +5 )
        
        -- Move to the start of the next gap
        currentPosition = currentPosition + DASH_LENGTH + GAP_LENGTH
    end

    gfx.unlockFocus()
    gfx.sprite.update()
end

function clearToolPreview()
    gfx.lockFocus(previewBufferImage)
    gfx.clear(gfx.kColorClear)
    gfx.unlockFocus()
    gfx.sprite.update()
end

function playdate.update()
    -- D-pad movement
    
    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        if carving then
            --curveToolLeft(1)
        else
            rotateToolLeft(carvingTool)
        end
    end
    if playdate.buttonIsPressed(playdate.kButtonRight) then
        if carving then
            --curveToolRight(1)
        else
            rotateToolRight(carvingTool)
        end
    end
    if playdate.buttonIsPressed(playdate.kButtonUp) then
        if carving then
            increaseToolLength(currentTool)
            --drawToolPreview()
        else
            moveToolForward(carvingTool)
        end
    end
    if playdate.buttonIsPressed(playdate.kButtonDown) then
        if carving then
            decreaseToolLength(currentTool)
            --drawToolPreview()
        else
            moveToolBackward(carvingTool)
        end
    end

    if carving then
        -- carvePath()
        drawToolPreview()
        needsRedraw = true
    end

    if needsRedraw then
        --dashOffset = (dashOffset + ANTS_SPEED) % (DASH_LENGTH + GAP_LENGTH)
        gfx.sprite.update()
        offScreenBuffer:draw(0, 0)
        needsRedraw = false
    end
    dashOffset = (dashOffset + ANTS_SPEED) % (DASH_LENGTH + GAP_LENGTH)

    gfx.sprite.update()
end

playdate.inputHandlers.push({
    AButtonDown = playdate.AButtonDown,
    AButtonUp = playdate.AButtonUp,
    BButtonDown = playdate.BButtonDown,
    cranked = playdate.cranked
})
