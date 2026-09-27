local files = {
    { id = "nVUpg7Rh", name = "GasBlowerController.lua" },
    { id = "YZzvANeR", name = "BlowerController.lua" },
    { id = "5aXxyuZH", name = "FileManager.lua" },
    { id = "ZeWA8zju", name = "Utils.lua" },
}

for _, file in ipairs(files) do
    print("Downloading " .. file.name .. "...")
    
    local url = "https://pastebin.com/raw/" .. file.id
    local response = http.get(url)

    if response then
        local contents = response.readAll()
        response.close()

        local handle = fs.open(file.name, "w")
        handle.write(contents)
        handle.close()

        print("Downloaded " .. file.name)
    else
        print("FAILED: " .. file.name)
    end
end

print("Done!")