-- Alternative tool in slot 1
-- Fuel (oak planks, coal, or coal blocks) in slot 16

local function checkTools()
    turtle.select(1)
    local item = turtle.getItemDetail()
    if item ~= nil and item.name == "minecraft:diamond_axe"
    then
        print("Checked axe")
    else
        error("Need diamond axe")
    end

    turtle.equipRight(1)
    item = turtle.getItemDetail()
    if item ~= nil and item.name == "minecraft:diamond_pickaxe"
    then
        print("Checked pickaxe")
    else
        error("Need diamond pickaxe")
    end

    turtle.equipRight(1)

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
end

local function refuel()
    if (turtle.getFuelLevel() < 100)
    then
        turtle.select(16)
        turtle.refuel()
        turtle.select(1)
    end
end

-- START OF PROGRAM

local length = 5

checkTools()

for i = 0, length, 1
do
    refuel()

    local success, data = turtle.inspect()
    if success == true
    then
        if data.tags["forge:ores"] == true
        then
            turtle.dig()
        else
            turtle.equipRight(1)
            turtle.dig()
            turtle.equipRight(1)
        end
    end

    turtle.forward()

    -- turtle.digUp()

    -- turtle.digDown()
end
