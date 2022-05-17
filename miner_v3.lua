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
    print("Need set torch (true or false) ? - ")
    isNeedSetFakel = read()
    if (isNeedSetFakel == "true") then
        isNeedSetFakel = true
        break
    end
    if (isNeedSetFakel == "false") then
        isNeedSetFakel = false
        break
    end
    print("Incorrect input - ", isNeedSetFakel)
end


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
    if turtle.getFuelLevel() < 1000 then
        for i = 3, 16 do
            turtle.select(i)
            while turtle.getItemCount(i) > 0 and turtle.refuel(turtle.getItemCount(i)) do
                print("Refuel complete")
            end
        end
    end
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
    print("pos - ", pos_x, " ", pos_y, " ", pos_z)
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
        checkRefuel()
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

-- выбираем слот с сундуком
local function selectChest()
    turtle.select(1) -- выбираем сундук
    while turtle.getItemCount(1) < 1 do
        print("Sleep 5 seconds need chest to first slop of inventory")
        os.sleep(5)
    end
end

local function isChest(whereChest)
    if whereChest == up then
        local s, info = turtle.inspectUp()
        return s and info.name == "minecraft:chest"
    end
    if whereChest == down then
        local s, info = turtle.inspectDown()
        return s and info.name == "minecraft:chest"
    end
    if whereChest == forward then
        local s, info = turtle.inspect()
        return s and info.name == "minecraft:chest"
    end
    os.exit(1, true)
end

local function isEnderChest(whereChest)
    if whereChest == up then
        local s, info = turtle.inspectUp()
        return s and info.name == "enderstorage:ender_storage"
    end
    if whereChest == down then
        local s, info = turtle.inspectDown()
        return s and info.name == "enderstorage:ender_storage"
    end
    if whereChest == forward then
        local s, info = turtle.inspect()
        return s and info.name == "enderstorage:ender_storage"
    end
    os.exit(1, true)
end

-- выбираем слот с факелом
local function selectTorch()
    turtle.select(2) -- выбираем факел
    while turtle.getItemCount(2) <= 1 do
        print("Sleep 5 seconds need torch to second slop of inventory")
        os.sleep(5)
    end
end

-- проверяем наличие сундука
local function isTorch(whereTorch)
    selectTorch()
    if whereTorch == up then
        return turtle.compareUp()
    end
    if whereTorch == down then
        return turtle.compareDown()
    end
    if whereTorch == forward then
        return turtle.compare()
    end
    os.exit(1, true)
end

-- позиция последнего установленного сундука
local last_chest_pos_x = 0
local last_chest_pos_y = 0
local last_chest_pos_z = 0
local function workSetChest()
    local n = 0
    for i = 3, 16 do
        if turtle.getItemCount(i) > 0 then
            if turtle.getItemDetail(i).name == 'minecraft:cobblestone' then
                turtle.select(i)
                turtle.dropUp(turtle.getItemCount(i))
            elseif turtle.getItemDetail(i).name == 'minecraft:dirt' then
                turtle.select(i)
                turtle.dropUp(turtle.getItemCount(i))
            elseif turtle.getItemDetail(i).name == 'minecraft:stone' then
                turtle.select(i)
                turtle.dropUp(turtle.getItemCount(i))
            elseif turtle.getItemDetail(i).name == 'minecraft:granite' then
                turtle.select(i)
                turtle.dropUp(turtle.getItemCount(i))
            elseif turtle.getItemDetail(i).name == 'minecraft:andesite' then
                turtle.select(i)
                turtle.dropUp(turtle.getItemCount(i))
            elseif turtle.getItemDetail(i).name == 'minecraft:gravel' then
                turtle.select(i)
                turtle.dropUp(turtle.getItemCount(i))
            end
        end
        if turtle.getItemCount(i) < 1 then
            n = n + 1
            if n > 5 then
                break
            end
        end
    end
    if n > 3 then
        -- inventory not full
    else
        selectChest()
        while turtle.placeDown() == false and isEnderChest(down) == false do
            print("Can't place chest to down side.")
            selectChest()
        end
        while isEnderChest(down) == false do
            print("Can't place chest to down side.")
        end
        for i = 3, 16 do
            turtle.select(i)
            while turtle.getItemCount(i) > 0 and turtle.dropDown(turtle.getItemCount(i)) == false do
                print("Can't drop item from ", i, " slot to chest to down side. Start sleep 5 seconds.")
                os.sleep(5)
            end
        end
        turtle.select(1)
        turtle.digDown()
        while turtle.getItemCount(1) < 1 or turtle.getItemDetail(1).name ~= 'enderstorage:ender_storage' do
            print("Need ender chest to first slot. Start sleep 5 seconds.")
            os.sleep(5)
        end
        last_chest_pos_x = pos_x
        last_chest_pos_y = pos_y
        last_chest_pos_z = pos_z
    end
end

local function mineFarm()
    if turtle.detectUp() then
        if isChest(up) then
            while turtle.suckUp() do
                workSetChest()
            end
            turtle.digUp()
        elseif isTorch(up) then
            -- сверху находится факел не будем его ломать
        else
            turtle.digUp()
        end
    end
    if turtle.detectDown() then
        if isChest(down) then
            while turtle.suckDown() do

            end
            turtle.digDown()
        elseif isTorch(down) then
            -- внизу находится факел не будем его ломать
        else
            turtle.digDown()
        end
    end
    while turtle.detect() do
        if isChest(forward) then
            print("Find chest")
            while turtle.suck() do
                workSetChest()
            end
        end
        turtle.dig()
    end
end

-- позиция последнего установленного факела
local last_torch_pos_x = 100
local last_torch_pos_y = 100
local last_torch_pos_z = 100
-- проверка необходимости поставить факел
local function workSetTorch2()
    -- todo: check тут нужно дописать так как не учитываются что это разные линии, а нужно
    -- чтобы факелы ставились именно на расстоянии друг от друга как вариант конечно
    -- добавить массив для учета всех предыдущих позиций, но это уже какой-то ппц мне каждется будет
    -- local nx = math.abs(last_torch_pos_x - pos_x)
    -- local nz = math.abs(last_torch_pos_z - pos_z)
    -- local nres = nx + ny + nz
    if math.abs(last_torch_pos_x - pos_x) >= 8 then
        if math.abs(last_torch_pos_y - pos_y) % 4 == 0 then
            while turtle.getItemCount(2) <= 1 do
                print("Sleep 5 seconds need torch to second slop of inventory")
                os.sleep(5)
            end
            if isTorch(down) == false then
                turtle.select(2) -- выбираем факел
                if turtle.placeDown() == true then
                    print("Torch place down")
                end
            end
            last_torch_pos_x = pos_x
            last_torch_pos_y = pos_y
            last_torch_pos_z = pos_z
        end
    end
end

local function workSetTorch()
    if isNeedSetFakel then
        workSetTorch2()
    end
end

local function goTo(target_x, target_y, target_z)
    if pos_x > target_x then
        while isTurtleEye3() == false do
            turnLeft2()
        end
    end
    if pos_x < target_x then
        while isTurtleEye1() == false do
            turnLeft2()
        end
    end
    while pos_x ~= target_x do
        if goForward2() then
            mineFarm()
        else
            print("Can't go forward. start sleep 5 seconds")
            os.sleep(5);
        end
    end

    if pos_y > target_y then
        while isTurtleEye4() == false do
            turnLeft2()
        end
    end
    if pos_y < target_y then
        while isTurtleEye2() == false do
            turnLeft2()
        end
    end
    while pos_y ~= target_y do
        if goForward2() then
            mineFarm()
        else
            print("Can't go forward. start sleep 5 seconds")
            os.sleep(5);
        end
    end
end

local function run()
    print("start mine")
    goEnd = drina_forward * drina_turn
    while goEnd > 0 do
        drina_forward_last = drina_forward
        -- копаем по стандартной траектории
        while drina_forward_last > 0 do
            if goForward2() then
                mineFarm()
                workSetChest()
                workSetTorch()
                drina_forward_last = drina_forward_last - 1
            else
                local su, ifon = turtle.inspect()
                local sleepNeed = true
                if su then
                    if ifon.name == 'minecraft:gravel' then
                        sleepNeed = false
                    end
                end
                if sleepNeed then
                    print("Can't go forward. start sleep 5 seconds")
                    os.sleep(5);
                end
            end
            print("drina_forward_last", drina_forward_last)
        end
        -- поворачиваем в сторону
        if isTurnLeft then
            turnLeft2()
        else
            turnRight2()
        end
        -- проходим в соседий ряд
        while true do
            if goForward2() then
                mineFarm()
                workSetChest()
                workSetTorch()
                break
            else
                print("Can't go forward. start sleep 5 seconds")
                os.sleep(5);
            end
        end
        if isTurnLeft then
            turnLeft2()
        else
            turnRight2()
        end
        if isTurnLeft then
            isTurnLeft = false
        else
            isTurnLeft = true
        end
    end
    goTo(0, 0, 0)
    while isTurtleEye1() == false do
        turnLeft2()
    end
end

run()
