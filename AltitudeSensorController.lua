local utils = require("Utils")
local io = require("FileManager")

local M = {}

function M.GetHeight(altitudeSensor)
    return altitudeSensor.getHeight()
end

function M.GetTargetHeight()
   local _, value = io.loadValue("TargetHeight")
   return value
end

function M.SetTargetHeight(setValue)
    local fileName = "TargetHeight"
    if io.saveValue(fileName, setValue) then
        print(fileName .. " created")
    end
end

return M