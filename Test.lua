local utils = require("utils")

args = {"test"}

args = utils.split("", " ")

for _, value in ipairs(args) do
    print(_ .. " " .. value)
end

if args[1] == "" then
    print("empty")
end

if args[1] == nil then
    print("nil")
end