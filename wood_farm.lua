
print("chest slot 1")
print("wood slot 2")
print("seed slot 3")

local function isChest()

    turtle.select(1) -- выбираем сундук
    while turtle.getItemCount(1) <= 1 do
        print("Sleep 30 seconds need chest to first slot of inventory")
        os.sleep(30)
    end

    return turtle.compare()
end

local function isWood()

    turtle.select(2) -- выбираем сундук
    while turtle.getItemCount(2) <= 1 do
        print("Sleep 30 seconds need wood to seconds slot of inventory")
        os.sleep(30)
    end

    return turtle.compare()
end

local function isWood2()

    turtle.select(3) -- выбираем сундук
    while turtle.getItemCount(3) <= 1 do
        print("Sleep 30 seconds need wood to seconds slot of inventory")
        os.sleep(30)
    end

    return turtle.compare()
end

-- проверка нужно ли перезаправить черепашку
local function checkRefuel()
    while turtle.getFuelLevel() < 100 do
        for i = 4, 16 do
            turtle.select(i)
            while turtle.getItemCount(i) > 0 and turtle.refuel(turtle.getItemCount(i)) do
                print("Refuel complete ",turtle.getFuelLevel())
            end
        end
        if turtle.getFuelLevel() < 100 then
            print("Fuel is low ", turtle.getFuelLevel())
            os.sleep(30);
        end
    end
end

while isChest() == false do
    turtle.turnLeft()
end
turtle.turnRight()
turtle.turnRight()

local function woodStart()
    if isWood()  == false then
        return false
    end
    turtle.dig()
    while turtle.forward() == false do
        turtle.dig()
        turtle.attack()
        print("Can't forward. Sleep 10 seconds")
        os.sleep(10)
    end
    local upCount = 0
    while turtle.detectUp() do
        turtle.digUp()
        for i = 1, 4 do
            turtle.dig()
            turtle.turnLeft()
        end
        while turtle.up() == false do
            turtle.digUp()
            turtle.attackUp()
            print("Can't up. Sleep 10 seconds")
            os.sleep(10)
        end
        upCount = upCount + 1
    end

    for i = 1, 4 do
        turtle.dig()
        turtle.turnLeft()
    end

    for i=1, upCount do
        while turtle.down() == false do
            turtle.downUp()
            turtle.attackDown()
            print("Can't down. Sleep 10 seconds")
            os.sleep(10)
        end
    end

    turtle.turnLeft()
    turtle.turnLeft()
    while turtle.forward() == false do
        turtle.dig()
        turtle.attack()
        print("Can't forward. Sleep 10 seconds")
        os.sleep(10)
    end
    turtle.turnLeft()
    turtle.turnLeft()

    while isChest() == false do
        turtle.turnLeft()
    end
    for i=4, 16 do
        turtle.select(i)
        while turtle.getItemCount(i) > 0 and turtle.drop(turtle.getItemCount(i)) == false do
            print("Can't drop. Sleep 10 seconds")
            os.sleep(10)
        end
    end
    turtle.turnRight()
    turtle.turnRight()

    return true
end

while true do

    isChest()
    isWood()
    isWood2()

    checkRefuel()

    if turtle.detect() then
        woodStart()
    else
        turtle.suck()

        while turtle.forward() == false do
            turtle.dig()
            turtle.attack()
            print("Can't forward. Sleep 10 seconds")
            os.sleep(10)
        end

        turtle.turnLeft()
        turtle.turnLeft()

        turtle.suck()
        turtle.suckUp()
        for i = 1, 4 do
            turtle.suck()
            turtle.suckUp()
            turtle.turnLeft()
        end

        while turtle.forward() == false do
            turtle.dig()
            turtle.attack()
            print("Can't forward. Sleep 10 seconds")
            os.sleep(10)
        end

        turtle.turnLeft()
        turtle.turnLeft()

        turtle.select(3)
        if turtle.place() == true then
            print("seed small wood")
        end
    end

    turtle.turnLeft()
    turtle.suck()
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.suck()
    turtle.turnLeft()

    print("wait 30 seconds")
    os.sleep(30)
end