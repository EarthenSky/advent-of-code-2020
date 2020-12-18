local bigint = require("lib/bigint") -- https://github.com/empyreuma/bigint.lua
local util = require("util")

-- day 10
-- Assumption: all numbers are positive

-- returns data as a list of numbers
function loadData() 
    local file = io.open("day10.input", "r")
    local content = file:read("*all")
    file:close()

    local list = util.split(content, "\n")
    list = util.map(list, function(item) return tonumber(item) end) -- convert all items in list to numbers
    return list
end

-- if no bad indexes are found, returns last in signalNumbers
function getNumberOfJoltDifferences(adapterNumbers, joltDifferences)
    table.sort(adapterNumbers) -- should be able to make O(3*n) using like 3 adjacent buckets or something

    output = {}

    for k in pairs(joltDifferences) do
        output[k] = 0
    end

    local last = 0 -- starts at 0 jolts
    for i, v in ipairs(adapterNumbers) do
        local diff = v - last

        -- true if the diff be reported (possible speed up by moving this condbr to after the loop)
        if joltDifferences[diff] ~= nil then
            output[diff] = output[diff] + 1 
        end 
        last = v
    end

    -- this covers the last case where the device's jolts are 3 greater than the last adapter
    if output[3] ~= nil then
        output[3] = output[3] + 1
    else 
        output[3] = 1
    end

    return output
end

-- if no bad indexes are found, returns last in signalNumbers
-- ignores the last case where devices jolts are 3 greater (b/c it has no effect)
function getJoltDiffList(adapterNumbers)
    table.sort(adapterNumbers) -- should be able to make O(3*n) using like 3 adjacent buckets or something

    local last = 0 -- starts at 0 jolts
    for i, v in ipairs(adapterNumbers) do
        local diff = v - last
        output[i] = diff
        last = v
    end

    return output
end

-- TODO: I actually don't understand why this function works, but it does. This function was made completely by my
-- intuition, which is very dangerous. -> Try to understand this & make code nicer later.

-- this function behaves recursively (could do some permutations math to speed it up probably)
adapterPermutations = {}
function numValidAdapterPermutations(startPoint, diffList)
    if adapterPermutations[startPoint] == nil then 
        local permutations = bigint.new(0)
        local last, last_last = nil, nil

        local i = startPoint

        -- do this before any fancy recursion
        if i < #diffList then
            permutations = bigint.add(permutations, numValidAdapterPermutations(i+1, diffList))
        end

        -- continue looping until 11 and 111 cases are checked
        while i <= #diffList do
            local v = diffList[i]

            if v == 3 then
                break
            end

            -- NOTE: If I changed the value of this one to 2, it would be double counting.
            if last_last ~= nil and last ~= nil and last_last == 1 and last == 1 and v == 1 then
                permutations = bigint.add(permutations:clone(), numValidAdapterPermutations(i+1, diffList))
            elseif last_last == nil and last ~= nil and last == 1 and v == 1 then
                permutations = bigint.add(permutations:clone(), numValidAdapterPermutations(i+1, diffList))
            elseif last_last == nil and last ~= nil and (last == 1 and v == 2) or (last == 2 and v == 1) then
                permutations = bigint.add(permutations:clone(), numValidAdapterPermutations(i+1, diffList))
            end

            if (last_last == 1 and last == 1) or (last == 1 and v == 2) or (last == 2 and v == 1) or (last == 2 and v == 2) then
                break
            end

            last_last = last
            last = v

            i = i + 1
        end

        -- this covers the base-case
        if bigint.compare(permutations, bigint.new(0), "==") then permutations = bigint.new(1) end

        adapterPermutations[startPoint] = permutations:clone()
        return permutations
    else 
        return adapterPermutations[startPoint]
    end
end

util.startTimer()

-- part 1

local adapterNumbers = loadData()
local joltDiffs = getNumberOfJoltDifferences( adapterNumbers, {[1]=true, [3]=true} )
print("1-Jolt: " .. joltDiffs[1] .. ", 3-Jolt: " .. joltDiffs[3])
print("1-Jolt * 3-Jolt: " .. (joltDiffs[1] * joltDiffs[3]))

-- part 2

local joltDiffList = getJoltDiffList(adapterNumbers)
local numPermutations = numValidAdapterPermutations(1, joltDiffList)

--util.printTable(util.map(adapterPermutations, function(item) return tostring(bigint.unserialize(item, "string")) end))

print("number of valid adapter permutations: " .. tostring(bigint.unserialize(numPermutations, "string")))

util.endTimerAndPrint()