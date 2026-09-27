-- message_interface.lua

--specifically for the demo

local utils = require("Utils")
local blowerController = require("BlowerController")

local modem = peripheral.find("modem")
local gasProvider = peripheral.find("gas_provider")

if os.getComputerLabel() ~= "ide" then
    rednet.open(peripheral.getName(modem))
end

local running = true

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
            
            if args[1] == "print" then
                print(args[2])
            elseif args[1] == "setBlowerTarget" then
                blowerController.SetVolumeTargetValue(gasProvider, args[2])
            elseif args[1] == "getBlowerTarget" then
                print(blowerController.GetVolumeTargetValue(gasProvider))
            elseif args[1] == "setRedstoneLevel" then
                blowerController.SetRedstoneLevel(gasProvider, args[2])
            elseif args[1] == "getRedstoneLevel" then
                print(blowerController.GetRedstoneLevel())
            else 
                print("Unrecognized Command")
            end
        end
    end
end

print("Rednet interface started.")
print("Computer ID: " .. os.getComputerID())
print("Type 'exit' to quit.")
print()

parallel.waitForAny(
    rednetListener,
    commandLine
)

if os.getComputerLabel() ~= "ide" then
    rednet.close(MODEM_SIDE)
end