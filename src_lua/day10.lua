local util = require("util");

-- Assumption: all numbers are positive

-- returns data as list
function loadData() 
    local file = io.open("day10.input", "r")
    local content = file:read("*all")
    file:close()

    local list = util.split(content, "\n")
    list = util.map(list, function(item) return tonumber(item) end) -- convert all items in list to numbers
    return list
end

-- if no bad indexes are found, returns last in signalNumbers
function getFirstXMASInvalidNumber(signalNumbers)

end

util.startTimer()

-- part 1

local signalNumbers = loadData()
local number = getFirstXMASInvalidNumber(signalNumbers)
print("first XMAS invalid number is " .. number)

-- part 2



util.endTimerAndPrint()