local util = require("util")

-- day 11

-- returns data as a list of numbers
function loadData() 
    local file = io.open("day11.input", "r")
    local content = file:read("*all")
    file:close()

    local lines = util.split(content, "\n")

    -- grid is a 2d array
    local grid = {width = #lines[1]+1, height = #lines}
    for i, s in ipairs(lines) do
        local width = 1
        for ch in s:gmatch(".") do
            grid[(i-1) * grid.width + width] = ch
            width = width + 1
        end
        grid[(i-1) * grid.width + width] = 'E' -- edge padding so that edges can be detected
    end

    return grid
end

-- note: could probably simulate this a faster way
-- updates stateGridTable
function simulateUntilEquilibrium(stateGrid) 
    local iterationNum = 0

    local changeOccured = true
    while changeOccured do
        changeOccured = false

        local oldGrid = util.shallowcopy(stateGrid)
        for i=1,stateGrid.height * stateGrid.width do
            local adjacent = {
                i - 1 - stateGrid.width, i - stateGrid.width, i + 1 - stateGrid.width, 
                i - 1, i + 1, 
                i - 1 + stateGrid.width, i + stateGrid.width, i + 1 + stateGrid.width
            }

            local adjOccupiedSeats = 0
            for _, index in ipairs(adjacent) do
                if oldGrid[index] == '#' then -- if index is invalid, will result to nil
                    adjOccupiedSeats = adjOccupiedSeats + 1
                end
            end

            if oldGrid[i] == 'L' and adjOccupiedSeats == 0 then
                stateGrid[i] = '#'
                changeOccured = true
            elseif oldGrid[i] == '#' and adjOccupiedSeats >= 4 then
                stateGrid[i] = 'L'
                changeOccured = true
            end

        end
        
        iterationNum = iterationNum + 1
    end

    print("part1: loops = " .. iterationNum)
end

-- note: could probably simulate this a faster way
-- updates stateGridTable
function simulateUntilEquilibriumV2(stateGrid) 
    local iterationNum = 0

    local changeOccured = true
    while changeOccured do
        changeOccured = false

        local oldGrid = util.shallowcopy(stateGrid)
        for i=1,stateGrid.height * stateGrid.width do
            local adjacent = {
                -1 - stateGrid.width, -stateGrid.width, 1 - stateGrid.width, 
                -1, 1, 
                -1 + stateGrid.width, stateGrid.width, 1 + stateGrid.width
            }

            local adjOccupiedSeats = 0
            for _, direction in ipairs(adjacent) do
                local index = i + direction
                local gridval = oldGrid[index] -- this actually does speed it up a little
                while gridval ~= nil do -- if index is invalid, will result to nil
                    if gridval == '#' then
                        adjOccupiedSeats = adjOccupiedSeats + 1
                        break
                    elseif gridval == '.' then
                        index = index + direction -- propagate step
                        gridval = oldGrid[index]
                    else -- case: L or E
                        break
                    end
                end
            end

            if oldGrid[i] == 'L' and adjOccupiedSeats == 0 then
                stateGrid[i] = '#'
                changeOccured = true
            elseif oldGrid[i] == '#' and adjOccupiedSeats >= 5 then
                stateGrid[i] = 'L'
                changeOccured = true
            end
        end

        --print("part2: loop " .. iterationNum)
        iterationNum = iterationNum + 1
    end

    print("part2: loops = " .. iterationNum)
end

-- ########################################################################## --

util.startTimer()

-- part 1

local stateGrid = loadData()
simulateUntilEquilibrium(stateGrid)

local numOccupied = 0
for i=1,stateGrid.height * stateGrid.width do
    if stateGrid[i] == '#' then
        numOccupied = numOccupied + 1
    end
end

print ("part1: number of occupied seats = " .. numOccupied)

-- part 2

local stateGrid = loadData()
simulateUntilEquilibriumV2(stateGrid)

local numOccupied2 = 0
for i=1,stateGrid.height * stateGrid.width do
    if stateGrid[i] == '#' then
        numOccupied2 = numOccupied2 + 1
    end
end

print ("part2: number of occupied seats = " .. numOccupied2)

util.endTimerAndPrint()