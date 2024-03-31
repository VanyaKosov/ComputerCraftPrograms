--
--
-- START OF PROGRAM
--
--

if not fs.exists("xyz.txt")
then
    return
end

local file = fs.open("xyz.txt", "r")
if file == nil
then
    error("The file is nil")
end
local x = tonumber(file.readLine())
local y = tonumber(file.readLine())
local z = tonumber(file.readLine())
local nx = tonumber(file.readLine())
local ny = tonumber(file.readLine())
local nz = tonumber(file.readLine())
local forward = tonumber(file.readLine())
local left = tonumber(file.readLine())
local contactComputerID = tonumber(file.readLine())

file.close()
