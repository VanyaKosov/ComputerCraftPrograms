-- To start, specify the amount of blocks to dig FORWARD, and to the SIDE
-- A chest must be placed behind the turtle
-- Main tool (diamond pickaxe) must be in left hand
-- Alternative tool (diamond axe) must be in right hand
-- Fuel (oak planks, coal, or coal blocks) in slot 16

local forward, side = ...

local pickaxeName = "minecraft:diamond_pickaxe"
local axeName = "minecraft:diamond_axe"

local liquids = {
    ["minecraft:water"] = true,
    ["minecraft:lava"] = true,
    ["tconstruct:molten_ender_fluid"] = true
}

local function checkArgs()
    if (forward == nil or side == nil)
    then
        error("Must provide dimentions")
    end

    if side % 2 ~= 0
    then
        error("Second argument must be even.")
    end
end

local function checkStartingState()
    turtle.select(1)
    local item = turtle.getItemDetail()
    if (item ~= nil)
    then
        error("First inventory slot should be empty")
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
    for i = 1, 15, 1
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

--
--
-- START OF PROGRAM
--
--

checkArgs()
checkStartingState()

for i = 1, side, 1
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
