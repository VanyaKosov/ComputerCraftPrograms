-- To start, specify:
--      the amount of blocks to dig FORWARD,
--      the amount of blocks to dig LEFT,
--      and computer number to communicate with in an emergency
-- A chest must be placed behind the turtle
-- Main tool (diamond pickaxe) must be in left hand
-- Alternative tool (diamond axe) must be in right hand
-- Fuel (oak planks, coal, or coal blocks) in slot 16
-- Wireless modem in slot 16

local forward, left, contactComputerId = ...

local pickaxeName = "minecraft:diamond_pickaxe"
local axeName = "minecraft:diamond_axe"
local modemName = "computercraft:wireless_modem_normal"

local liquids = {
    ["minecraft:water"] = true,
    ["minecraft:lava"] = true,
    ["tconstruct:molten_ender_fluid"] = true
}

local function checkArgs()
    if (forward == nil or left == nil)
    then
        error("Must provide dimentions")
    end

    if left % 2 ~= 0
    then
        error("Second argument must be even.")
    end

    if contactComputerId == nil
    then
        error("Must provide computer contact id")
    end
end

local function checkStartingState()
    turtle.select(1)
    local item = turtle.getItemDetail()
    if (item == nil or item.name ~= modemName)
    then
        error("Wireless modem required in the first slot")
    end

    turtle.equipRight()
    item = turtle.getItemDetail()
    turtle.equipRight()
    if (item == nil or item.name ~= axeName)
    then
        error("Diamond axe required in right hand")
    end
    print("Checked axe")

    turtle.equipLeft()
    item = turtle.getItemDetail()
    turtle.equipLeft()
    if (item == nil or item.name ~= pickaxeName)
    then
        error("Diamond pickaxe required in left hand")
    end
    print("Checked pickaxe")

    item = turtle.getItemDetail(16)
    if item ~= nil and
        (item.name == "minecraft:coal_block" or
            item.name == "minecraft:coal" or
            item.name == "minecraft:oak_planks")
    then
        print("Checked fuel")
    else
        error("Need fuel (coal blocks, coal, or oak planks)")
    end

    turtle.turnLeft()
    turtle.turnLeft()
    local success, data = turtle.inspect()
    turtle.turnLeft()
    turtle.turnLeft()
    if success == false
    then
        error("No chest found")
    end
    if data.tags["forge:chests"] == true
    then
        print("Checked chest")
    else
        error("No chest found")
    end
end

local function refuel()
    if (turtle.getFuelLevel() < 100)
    then
        turtle.select(16)
        turtle.refuel()
        turtle.select(1)
    end
end

local function dig(inspectFunc, digFunc)
    local success, data = inspectFunc()
    while success == true
    do
        if liquids[data.name] ~= nil
        then
            break
        end

        if data.name == "forbidden_arcanus:stella_arcanum"
        then
            turtle.equipRight()
            rednet.open("right")
            rednet.send(tonumber(contactComputerId), "Explosive ore found. Digging processes terminated")
            turtle.equipRight()

            error("!Danger! Explosive ore found !Danger!")
        end

        if data.tags["forge:ores"] == true
        then
            digFunc("left")
        else
            digFunc("right")
        end

        success, data = inspectFunc()
    end
end

local function digForward()
    dig(turtle.inspect, turtle.dig)
end

local function digDown()
    dig(turtle.inspectDown, turtle.digDown)
end

local function digUp()
    dig(turtle.inspectUp, turtle.digUp)
end

local function dropOffItems(distance)
    turtle.turnLeft()
    for i = 1, distance - 1, 1
    do
        turtle.forward()
    end
    turtle.turnRight()
    for i = 2, 15, 1
    do
        turtle.select(i)
        turtle.drop()
    end
    turtle.select(1)
    turtle.turnRight()
    for i = 1, distance - 1, 1
    do
        turtle.forward()
    end
end

local function saveStartingInfo()
    turtle.equipRight()
    local x, y, z = gps.locate()
    turtle.equipRight()
    local file = fs.open("xyz.txt", "w")
    file.write(x)
    file.write("\n")
    file.write(y)
    file.write("\n")
    file.write(z)
    file.write("\n")

    digForward()
    turtle.forward()
    turtle.equipRight()
    local nx, ny, nz = gps.locate()
    turtle.equipRight()
    turtle.back()
    file.write(nx)
    file.write("\n")
    file.write(ny)
    file.write("\n")
    file.write(nz)
    file.write("\n")

    file.write(forward)
    file.write("\n")
    file.write(left)
    file.write("\n")
    file.write(contactComputerId)
    file.write("\n")

    file.close()
end

--
--
-- START OF PROGRAM
--
--

checkArgs()
checkStartingState()

saveStartingInfo()

for i = 1, left, 1
do
    -- Dig forward
    for j = 1, forward, 1
    do
        refuel()
        digForward()
        turtle.forward()
        digUp()
        digDown()
    end

    -- Turn around (left or right)
    if i % 2 ~= 0
    then
        turtle.turnLeft()
        digForward()
        turtle.forward()
        digUp()
        digDown()

        turtle.turnLeft()
    else
        dropOffItems(i)

        digForward()
        turtle.forward()
        digUp()
        digDown()

        turtle.turnRight()
    end
end

fs.delete("xyz.txt")
