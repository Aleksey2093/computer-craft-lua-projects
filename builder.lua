print("miner v5")
print("first slot chect")
print("second slot torch")

local drina_forward = 0
local drina_turn = 0

local drina_forward_last = 0
local drina_turn_max = 0

local pos_x = 0 -- север + юг -
local pos_y = 0 -- восток + запад -
local pos_z = 0 -- вверх + вниз -

local isNeedSetFakel = -1

local goEnd = 0

local isTurnLeft = true

local up = 0
local forward = 1
local down = 2


print("set dlina - ")
drina_forward = read()
drina_forward = tostring(drina_forward)
drina_forward = tonumber(drina_forward)

print("set shirina - ")
drina_turn = read()
drina_turn = tostring(drina_turn)
drina_turn = tonumber(drina_turn)

while true do
    print("turn left or right - ")
    isTurnLeft = read()
    if (isTurnLeft == "left") then
        isTurnLeft = true
        break
    end
    if (isTurnLeft == "right") then
        isTurnLeft = false
        break
    end
    print("Incorrect input - ", isTurnLeft)
end



-- 1 - север
-- 2 - восток
-- 3 - юг
-- 4 - запад
local turtle_eye = 1

-- проверка в какую сторону смотрим
local function isTurtleEye(inputValue)
    if inputValue == turtle_eye then
        return true
    else
        return false
    end
end

-- черепашка смотрит на север
local function isTurtleEye1()
    return isTurtleEye(1)
end

-- черепашка смотрит на восток
local function isTurtleEye2()
    return isTurtleEye(2)
end

-- черепашка смотрит на юг
local function isTurtleEye3()
    return isTurtleEye(3)
end
-- черепашка смотрит на запад
local function isTurtleEye4()
    return isTurtleEye(4)
end

-- проверка нужно ли перезаправить черепашку
local function checkRefuel()
    while turtle.getFuelLevel() < 100 do
        for i = 3, 16 do
            turtle.select(i)
            while turtle.getItemCount(i) > 0 and turtle.refuel(turtle.getItemCount(i)) do
                print("Refuel complete")
            end
        end
        if turtle.getFuelLevel() < 100 then
            print("Fuel is low ", turtle.getFuelLevel())
            os.sleep(5);
        end
    end
end

--использовать вместо функции вперед, чтобы считались координаты позиции черепашки
local function goForward2()
    print("pos - ", pos_x," ",pos_y," ",pos_z)
    if turtle.detect() then
        turtle.dig() -- уничтожаем блок перед черепашкой, чтобы можно было пройти вперед
    end
    if turtle.forward() == true then -- проверяем смогла ли черепашка пройти вперед?
        if isTurtleEye1() == true then
            pos_x = pos_x + 1 -- идем на север
        elseif isTurtleEye2() == true then
            pos_y = pos_y + 1 -- идем на восток
        elseif isTurtleEye3() == true then
            pos_x = pos_x - 1 -- идем на юг
        elseif isTurtleEye4() == true then
            pos_y = pos_y - 1 -- идем на запад
        end
        goEnd = goEnd - 1 -- вычитаем количество проделанных шагов
        return true
    else
        return false
    end
end


--использовать вместо функции вперед, чтобы считались координаты позиции черепашки
local function goUp()
    print("pos - ", pos_x," ",pos_y," ",pos_z)
    if turtle.detectUp() then
        turtle.digUp() -- уничтожаем блок перед черепашкой, чтобы можно было пройти вперед
    end
    if turtle.up() == true then -- проверяем смогла ли черепашка пройти вперед?
        pos_z = pos_z + 1
        return true
    else
        return false
    end
end

--использовать вместо функции вперед, чтобы считались координаты позиции черепашки
local function goUp()
    print("pos - ", pos_x," ",pos_y," ",pos_z)
    if turtle.detectDown() then
        turtle.digDown() -- уничтожаем блок перед черепашкой, чтобы можно было пройти вперед
    end
    if turtle.down() == true then -- проверяем смогла ли черепашка пройти вперед?
        pos_z = pos_z + 1
        return true
    else
        return false
    end
end

--использовать вместо функции налево, чтобы считались координаты позиции черепашки
local function turnLeft2()
    turtle_eye = turtle_eye - 1
    if turtle_eye < 1 then
        turtle_eye = 4
    end
    turtle.turnLeft()
end

--использовать вместо функции направо, чтобы считались координаты позиции черепашки
local function turnRight2()
    turtle_eye = turtle_eye + 1
    if turtle_eye > 4 then
        turtle_eye = 1
    end
    turtle.turnRight()
end

local function selectBuildSlot()
    while true do
        for i=1,16 do
            if (turtle.getItemCount(i) > 1) then
                turtle.select(i)
                return true
            end
        end
        print("need build material. Sleep 30 seconds.")
        os.sleep(30)
    end
    return false
end

local function buildUpIter()
    selectBuildSlot()
    while turtle.placeDown() == false do
        turtle.digDown()
        os.sleep(1)
    end
end

local function buildUp()
    
end

print("start build")