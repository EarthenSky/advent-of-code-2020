local util = require("util")

-- day 14

-- returns data as a list of numbers
function loadData() 
    local file = io.open("day14.input", "r")
    local content = file:read("*all")
    file:close()

    local lines = util.split(content, "\n")
    return util.map(lines, function(item) return {ch=item:sub(1, 1), num=item:sub(2, -1)} end)
end

-- ########################################################################## --

util.startTimer()

-- part 1

local instructionList = loadData()


print ("part1: manhattan distance from start = ")

-- part 2


print ("part2: manhattan distance from start = ")

util.endTimerAndPrint()