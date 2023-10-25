--local currentTool = "default"  -- Placeholder
local toolWidth = 5  -- Placeholder
local toolCurvature = 0  -- Placeholder
--local currentToolLength = 1  -- Placeholder
-- local toolRotation = 0  -- Placeholder
local currentToolSlot = 0
local MOVE_DISTANCE = 1  -- This determines how much the tool moves with each button press. Adjust as needed.

-- Assuming you have global or module-level variables for the tool's position and rotation
local toolX, toolY = 0, 0  -- Initialize with the tool's starting position
--local toolRotation = 0  -- Initialize with the tool's starting rotation (in radians)

-- Distance the tool moves for each degree of crank rotation
local movementPerDegree = 5
--local all_tools = import "tools"

-- Tool Selection
function selectNextTool()
    currentToolIndex = currentToolIndex + 1
    if currentToolIndex > #tools then  -- If we're past the end, wrap around
        currentToolIndex = 1
    end
    currentTool = tools[currentToolIndex]
    -- Optionally: Update the UI or any other necessary game state
end

function selectPreviousTool()
    currentToolIndex = currentToolIndex - 1
    if currentToolIndex < 1 then  -- If we're before the start, wrap around
        currentToolIndex = #tools
    end
    currentTool = tools[currentToolIndex]
    -- Optionally: Update the UI or any other necessary game state
end


-- Adjusting Tool Width
function increaseToolWidth()
    local maxWidth = currentTool.maxWidth
    if toolWidth < maxWidth then
        toolWidth = toolWidth + 1
    end
    -- Optionally: Update the UI or any other necessary game state
end

function decreaseToolWidth()
    local minWidth = currentTool.minWidth
    if toolWidth > minWidth then
        toolWidth = toolWidth - 1
    end
    -- Optionally: Update the UI or any other necessary game state
end

-- Adjusting Tool Curvature
function increaseToolCurvature()
    toolCurvature = toolCurvature + 1  -- Adjust as needed
end

function decreaseToolCurvature()
    toolCurvature = toolCurvature - 1  -- Adjust as needed
end

-- Adjusting Tool Length
function increaseToolLength(currentTool)
    if currentTool.length + 1 <= currentTool.maxLength then
        currentTool.length = currentTool.length + 1
    end
end

function decreaseToolLength(currentTool)
    if currentTool.length - 1 >= currentTool.minLength then
        currentTool.length = currentTool.length - 1
    end
end

function previewLength(carvingTool)
    local currentAngle = currentAngle or 0
    local x, y = carvingTool:getPosition()
    
    local dx = currentTool.length * math.cos(math.rad(currentAngle))
    local dy = currentTool.length * math.sin(math.rad(currentAngle))
    
    local endX = x + dx
    local endY = y + dy
    
    return endX, endY
end


-- Rotating the Tool Path
function rotateToolLeft(carvingTool)
    currentAngle = currentAngle or 0
    currentAngle = currentAngle - 1  -- Adjust as needed
    carvingTool:setRotation(currentAngle)
end

function rotateToolRight(carvingTool)
    currentAngle = currentAngle or 0
    currentAngle = currentAngle + 1  -- Adjust as needed
    carvingTool:setRotation(currentAngle)
end

-- Moving the Tool Along its Path
function moveToolForward(carvingTool)
    local currentAngle = currentAngle or 0
    local dx = MOVE_DISTANCE * math.cos(math.rad(currentAngle))
    local dy = MOVE_DISTANCE * math.sin(math.rad(currentAngle))
    carvingTool:moveBy(dx, dy)
end

function moveToolBackward(carvingTool)
    local currentAngle = currentAngle or 0
    local dx = -MOVE_DISTANCE * math.cos(math.rad(currentAngle))
    local dy = -MOVE_DISTANCE * math.sin(math.rad(currentAngle))
    carvingTool:moveBy(dx, dy)
end

-- Carving with the Crank
function carveWithCrank(degreesTurned)
    local distanceToMove = degreesTurned * movementPerDegree
    moveToolForward(distanceToMove)
    -- Add any additional logic needed to represent the carving effect on the pumpkin
end

-- Input Handlers
function playdate.BButtonDown()
    -- Detect dpad directions and adjust tool properties
end

function playdate.AButtonDown()
    -- Detect dpad directions and adjust tool properties
end

function playdate.cranked(change, _)
    carveWithCrank()
end

-- Register custom input handlers
playdate.inputHandlers.push({
    BButtonDown = playdate.BButtonDown,
    AButtonDown = playdate.AButtonDown,
    cranked = playdate.cranked
})
