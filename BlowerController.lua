local utils = require("Utils")
local io = require("FileManager")

function M.GetRedstoneLevel()
   return io.loadValue("BlowerRedstoneLevel")
end

function M.SetRedstoneLevel(gasProvider, setValue)
    local result = io.saveValue("BlowerRedstoneLevel", setValue)
    if result then
        local _,redstoneLevel = M.GetRedstoneLevel()
        redstone.setAnalogOutput(peripheral.getName(gasProvider), tonumber(redstoneLevel))
        return result
    end
end

function M.GetVolumeTargetValue(gasProvider)
    return gasProvder.getTargetAmount()
end

function M.SetVolumeTargetValue(gasProvider, setValue)
    return gasProvider.setTargetAmount(setValue)
end

return M