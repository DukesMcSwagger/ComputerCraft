local utils = require("Utils")
local io = require("FileManager")

--test

function M.GetRedstoneLevel()
   return io.loadValue("BlowerRedstoneLevel")
end

function M.SetRedstoneLevel(gasProvider, setValue)
    result = io.saveValue("BlowerRedstoneLevel", setValue)
    if result then
        redstone.setAnalogOutput(peripheral.getName(gasProvider), M.GetRedstoneLevel())
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