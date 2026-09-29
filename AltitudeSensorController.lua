local utils = require("Utils")
local io = require("FileManager")

local M = {}

function M.GetHeight(altitudeSensor)
    return altitudeSensor.getHeight()
end

function M.GetTargetHeight()
   io.loadValue("TargetHeight")
end

function M.SetTargetHeight(setValue)
    io.saveValue("TargetHeight", setValue)
end

return M