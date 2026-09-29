-- message_interface.lua

local utils = require("Utils")
local blowerController = require("BlowerController")
local pid = require("Pid")
local altitudeSensorController = require("AltitudeSensorController")

local modem = peripheral.find("modem")
local gasProvider = peripheral.find("gas_provider")
local altitudeSensor = peripheral.find("altitiude_sensor")

local redstonePID = pid.new(2, 0.05, 0.5, {
    minOutput = 0,
    maxOutput = 15,

    integralMin = -100,
    integralMax = 100,

    dt = 1
})

local volumePID = pid.new(2, 0.05, 0.5, {
    minOutput = 0,
    maxOutput = 500,

    integralMin = -100,
    integralMax = 100,

    dt = 1
})

if os.getComputerLabel() ~= "ide" then
    rednet.open(peripheral.getName(modem))
end

local running = true
local autoHeightEnabled = false
local debug = false

local function debugPrint(message)
    if debug then
        print(message)
    end
end

local function resolveCommands(args)

    local _ = false
    local result = ""

    if args[1] == "print" then
        print(args[2])
    elseif args[1] == "setBlowerTarget" then
        blowerController.SetVolumeTargetValue(gasProvider, tonumber(args[2]))
    elseif args[1] == "getBlowerTarget" then
        result = blowerController.GetVolumeTargetValue(gasProvider)
    elseif args[1] == "setRedstoneLevel" then
        blowerController.SetRedstoneLevel(gasProvider, args[2])
    elseif args[1] == "getRedstoneLevel" then
        _, result = blowerController.GetRedstoneLevel()
    elseif args[1] == "setAutoHeight" then
        autoHeightEnabled = utils.ternary(args[2], true, false)
        print("Autoheight set to " .. autoHeightEnabled)
    elseif args[1] == "setTargetHeight" then
        altitudeSensorController.SetTargetHeight(args[2])
    elseif args[1] == "setDebug" then
        debug = utils.ternary(args[2], true, false)
    else 
        print("Unrecognized Command")
    end

    if args[3] == "return" then
        rednet.send(tonumber(args[4]), result)
    end
end

-- Displays incoming Rednet messages
local function rednetListener()
    while running do
        local sender, message, protocol = rednet.receive()

        if message then
            print()
            print(("<< Rednet from %s >>"):format(sender))
            print("Message: " .. tostring(message))

            if protocol then
                print("Protocol: " .. protocol)
            end

            write("> ")
        end

        resolveCommands(utils.split(message, " " ))
    end
end

-- Handles commands typed by the user
local function commandLine()
    while running do
        write("> ")
        local input = read()

        if input == "exit" or input == "quit" then
            running = false
            print("Shutting down...")
            return

        elseif input == "clear" then
            term.clear()
            term.setCursorPos(1, 1)

        elseif input == "id" then
            print("Computer ID: " .. os.getComputerID())

        elseif input ~= "" then
            args = utils.split(input, " ")
            resolveCommands(args)
        end
    end
end

local function autoHeight()
    while running do
        if autoHeightEnabled == true then
            local currentHeight = altitudeSensorController.GetHeight(altitudeSensor)
            local targetHeight = altitudeSensorController.GetTargetHeight()

            local output = redstonePID:update(currentHeight, targetHeight)

            debugPrint("AutoHeight PID Output: " .. output)

            blowerController.SetRedstoneLevel(gasProvider, output)
        else
            redstone.setOutput(peripheral.getName(gasProvider), false)
        end

        sleep(1)
    end
end

print("Rednet interface started.")
print("Computer ID: " .. os.getComputerID())
print("Type 'exit' to quit.")
print()

parallel.waitForAny(
    rednetListener,
    commandLine,
    autoHeight
)

if os.getComputerLabel() ~= "ide" then
    rednet.close(MODEM_SIDE)
end