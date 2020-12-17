local Util = {}

function Util.split(s, delimiter)
    result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

-- does a shallow print
function Util.printTable(table)
    for k, v in pairs(table) do
        print(k, v)
    end
end

function Util.map(tbl, f)
    local t = {}
    for k,v in pairs(tbl) do
        t[k] = f(v)
    end
    return t
end

return Util