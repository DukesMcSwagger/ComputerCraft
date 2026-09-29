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
        redstone.setAnalogOutput(peripheral.getName(gasProvider), tonumber(redstoneLevel))
        return result
    else
        print("ERROR: Unable to read RedstoneLevel when attempting to set")
    end
end

function M.GetVolumeTargetValue(gasProvider)
    return gasProvider.getTargetAmount()
end

function M.SetVolumeTargetValue(gasProvider, setValue)
    if not (type(setValue) == "number") then
        print("Attempted to set Volume to NaN, TargetAmount unchanged.")
    end
    return gasProvider.setTargetAmount(setValue)
end

return M