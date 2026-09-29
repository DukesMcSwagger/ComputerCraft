local M = {}

function M.split(str, sep)
    local result = {}

    if str == "" or str == nil then
        table.insert(result, "")
        return result
    end

    for part in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(result, part)
    end

    return result
end

function M.ternary(condition, ifTrue, ifFalse)
    if condition then
        return ifTrue
    else
        return ifFalse
    end
end

return M