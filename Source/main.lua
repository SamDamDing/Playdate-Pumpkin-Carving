-- Import necessary libraries
import "CoreLibs/graphics"
import "CoreLibs/sprites"

local gfx = playdate.graphics

-- Initialize sprites and other variables
local pumpkinImage = gfx.image.new('pumpkin')
local pumpkin = gfx.sprite:new()
pumpkin:setImage(pumpkinImage)
pumpkin:moveTo(200, 120)
pumpkin:addSprite()

local carvingTool = gfx.sprite:new()
carvingTool:setImage(gfx.image.new('reticle'))
carvingTool:moveTo(200,120)
carvingTool:addSprite()

local carving = false
local angle = 0
local activeColor = true
local needsRedraw = true -- Flag to check if we need to redraw

-- Input Handlers
function playdate.AButtonDown()
    carving = true
end

function playdate.AButtonUp()
    carving = false
end

function playdate.BButtonDown()
    activeColor = not activeColor
end

function playdate.cranked(change, _)
    angle += change
end

local offScreenBuffer = gfx.image.new(400, 240)

-- Main update loop
function playdate.update()
    local hasMoved = false -- Flag to check if the carving tool has moved

    -- D-pad movement
    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        carvingTool:moveBy(-1, 0)
        hasMoved = true
    end
    if playdate.buttonIsPressed(playdate.kButtonRight) then
        carvingTool:moveBy(1, 0)
        hasMoved = true
    end
    if playdate.buttonIsPressed(playdate.kButtonUp) then
        carvingTool:moveBy(0, -1)
        hasMoved = true
    end
    if playdate.buttonIsPressed(playdate.kButtonDown) then
        carvingTool:moveBy(0, 1)
        hasMoved = true
    end

    if carving then
        local tipX, tipY = carvingTool:getPosition()
        gfx.lockFocus(pumpkinImage)
        --print(pumpkin:getImage():sample(tipX, tipY))
        gfx.setColor(activeColor and gfx.kColorBlack or gfx.kColorClear)
        if pumpkin:getImage():sample(tipX, tipY) == 1 then
            gfx.drawPixel(tipX - 1, tipY - 1)
        end
        gfx.unlockFocus()
        needsRedraw = true
    end
    gfx.sprite.update()
--[[     if hasMoved or needsRedraw then
        gfx.sprite.update()
        --offScreenBuffer:draw(0, 0)
        needsRedraw = false
    end ]]
end

-- Register custom input handlers
playdate.inputHandlers.push({
    AButtonDown = playdate.AButtonDown,
    AButtonUp = playdate.AButtonUp,
    BButtonDown = playdate.BButtonDown,
    cranked = playdate.cranked
})
