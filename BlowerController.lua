local utils = require("Utils")
local io = require("FileManager")

function M.GetRedstoneLevel()
   return io.loadValue("BlowerRedstoneLevel")
end

function M.SetRedstoneLevel(gasProvider, setValue)
    if setValue < 0 then
        return 0
    end
    if setValue > 15 then
        return 15
    end
    local result = io.saveValue("BlowerRedstoneLevel", setValue)
    if result then
        local _,redstoneLevel = M.GetRedstoneLevel()
        redstone.setAnalogOutput(peripheral.getName(gasProvider), math.floor(tonumber(redstoneLevel) + 0.5))
        return result
    end
end

function M.GetVolumeTargetValue(gasProvider)
    return gasProvider.getTargetAmount()
end

function M.SetVolumeTargetValue(gasProvider, setValue)
    return gasProvider.setTargetAmount(setValue)
end

return M