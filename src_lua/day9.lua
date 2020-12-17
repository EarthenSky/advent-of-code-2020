local util = require("util");

-- day9
-- Assumption: all numbers are positive

-- returns data as list
function loadData() 
    local file = io.open("day9.input", "r")
    local content = file:read("*all")
    file:close()

    local list = util.split(content, "\n")
    list = util.map(list, function(item) return tonumber(item) end) -- convert all items in list to numbers
    return list
end

-- if no bad indexes are found, returns last in signalNumbers
function getFirstXMASInvalidNumber(signalNumbers)
    local start, size = 1, 25
    local isValid = true

    while isValid and start <= #signalNumbers do
        local pivot = start + size
        
        -- check if the pivot is valid according to XMAS
        local curPivotIsValid = false
        for i = start, start + size - 1 do
            local pivotSub = signalNumbers[pivot] - signalNumbers[i]

            if pivotSub >= 0 then  -- early exit for performance
                for j = i + 1, start + size - 1 do
                    if pivotSub == signalNumbers[j] then
                        curPivotIsValid = true
                        break
                    end
                end

                if curPivotIsValid == true then
                    break
                end
            end
        end

        -- loop exit condition
        if curPivotIsValid == false then
            isValid = false
        end

        start = start + 1
    end

    start = start - 1

    return signalNumbers[start + size]
end

function getContiguousNumbersWhichSumTo(signalNumbers, targetNumber)
    local i = 1
    while i <= #signalNumbers do
        local min, max = 2e52, -1
        local j = i
        local runningSum = 0

        while j <= #signalNumbers and runningSum <= targetNumber do
            if signalNumbers[j] > max then max = signalNumbers[j] end
            if signalNumbers[j] < min then min = signalNumbers[j] end

            runningSum = runningSum + signalNumbers[j]
            if runningSum == targetNumber then -- case: found valid number
                return min, max
            end
        
            j = j + 1
        end

        i = i + 1
    end

    return -1, -1 -- invalid exit condition
end

util.startTimer()

-- part 1

local signalNumbers = loadData()
local number = getFirstXMASInvalidNumber(signalNumbers)
print("first XMAS invalid number is " .. number)

-- part 2

local min, max = getContiguousNumbersWhichSumTo(signalNumbers, number)
print("encryption weakness points = min: " .. min .. ", max: " .. max)
print("added together: " .. (min + max))

util.endTimerAndPrint()