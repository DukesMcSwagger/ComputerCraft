local modem = peripheral.find("modem")

rednet.open(peripheral.getName(modem))

while true do
    write("> ")
    local input = read()

    if input == "exit" or input == "quit" then
        running = false
        redstone.setOutput(peripheral.getName(gasProvider), false)
        print("Shutting down...")
        return

    elseif input == "clear" then
        term.clear()
        term.setCursorPos(1, 1)

    elseif input == "id" then
        print("Computer ID: " .. os.getComputerID())

    elseif input ~= "" then
        redstone.send(3, "setTargetHeight " .. tostring(input))
    end
end