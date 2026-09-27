M = {}

-- Save a value to a text file
function M.saveValue(filename, value)
    local file = io.open(filename, "w")
    if not file then
        return false, "Could not open file for writing"
    end

    file:write(tostring(value))
    file:close()

    return true
end

-- Retrieve a value from a text file
function M.loadValue(filename)
    local file = io.open(filename, "r")
    if not file then
        return false, "Could not open file for reading"
    end

    local value = file:read("*a")
    file:close()

    return true, value
end

return M