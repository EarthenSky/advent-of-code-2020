local util = require("util");

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

-- part 1

local signalNumbers = loadData()
local number = getFirstXMASInvalidNumber(signalNumbers)

print("first XMAS invalid number is " .. number)