local util = require("util")

-- day 12
-- Assumption: all degrees are in the form 90*n for n an integer.

-- returns data as a list of numbers
function loadData() 
    local file = io.open("day12.input", "r")
    local content = file:read("*all")
    file:close()

    local lines = util.split(content, "\n")
    return util.map(lines, function(item) return {ch=item:sub(1, 1), num=item:sub(2, -1)} end)
end

-- returns the end position of the boat
function simulateBoat(instructionList)
    local position = {x=0, y=0}
    local direction = 1 -- 1, 2, 3, 4 -- E, S, W, N
    for i, v in ipairs(instructionList) do
        if v.ch == "N" then
            position.y = position.y + v.num
        elseif v.ch == "E" then
            position.x = position.x + v.num
        elseif v.ch == "S" then
            position.y = position.y - v.num
        elseif v.ch == "W" then
            position.x = position.x - v.num 
        elseif v.ch == "L" then -- change direction -- NOTE: turns can be more than 90 degrees
            direction = direction - v.num / 90
            if direction < 1 then
                direction = direction % 4
                if direction == 0 then direction = 4 end
            end
        elseif v.ch == "R" then
            direction = direction + v.num / 90
            if direction > 4 then
                direction = direction % 4
                if direction == 0 then direction = 4 end
            end
        elseif v.ch == "F" then -- move in current direction
            if direction == 4 then
                position.y = position.y + v.num
            elseif direction == 1 then
                position.x = position.x + v.num
            elseif direction == 2 then
                position.y = position.y - v.num
            elseif direction == 3 then
                position.x = position.x - v.num
            end
        end
    end
    return position
end


-- returns the end position of the boat
-- TODO: do with waypoint
function simulateBoatWithWaypoint(instructionList)
    function rotateBoat(waypointPosition, direction) 
        local tmpY = waypointPosition.y
        local tmpX = waypointPosition.x
        if direction == 4 then
            -- do nothing
        elseif direction == 1 then
            waypointPosition.x = tmpY
            waypointPosition.y = -tmpX
        elseif direction == 2 then
            waypointPosition.x = -tmpX
            waypointPosition.y = -tmpY
        elseif direction == 3 then -- rotate left
            waypointPosition.x = -tmpY
            waypointPosition.y = tmpX
        end
        return waypointPosition
    end
    
    local boatPosition = {x=0, y=0}
    local waypointPosition = {x=10, y=1}

    for i, v in ipairs(instructionList) do
        if v.ch == "N" then
            waypointPosition.y = waypointPosition.y + v.num
        elseif v.ch == "E" then
            waypointPosition.x = waypointPosition.x + v.num
        elseif v.ch == "S" then
            waypointPosition.y = waypointPosition.y - v.num
        elseif v.ch == "W" then
            waypointPosition.x = waypointPosition.x - v.num 
        elseif v.ch == "L" then -- change direction -- NOTE: turns can be more than 90 degrees
            local direction = -v.num / 90
            direction = direction % 4
            if direction == 0 then direction = 4 end

            rotateBoat(waypointPosition, direction)
        elseif v.ch == "R" then
            local direction = v.num / 90
            direction = direction % 4
            if direction == 0 then direction = 4 end

            rotateBoat(waypointPosition, direction)
        elseif v.ch == "F" then -- move boat by waypoint
            boatPosition.x = boatPosition.x + waypointPosition.x * v.num
            boatPosition.y = boatPosition.y + waypointPosition.y * v.num
        end

    end

    return boatPosition
end

-- ########################################################################## --

util.startTimer()

-- part 1

local instructionList = loadData()
--table.foreach(instructionList, function(k, v) print ("------") return util.printTable(v) end)
local position = simulateBoat(instructionList)

print ("part1: manhattan distance from start = " .. math.abs(position.x) + math.abs(position.y))

-- part 2

local position2 = simulateBoatWithWaypoint(instructionList)

print ("part2: manhattan distance from start = " .. math.abs(position2.x) + math.abs(position2.y))

util.endTimerAndPrint()