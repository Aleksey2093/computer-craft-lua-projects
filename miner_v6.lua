print("miner v6")
print("first slot chest")
print("second slot torch")

local drina_forward = 0
local drina_turn = 0
local level_up = 0

local drina_forward_last = 0
local drina_turn_max = 0

local pos_x = 0 -- север + юг -
local pos_y = 0 -- восток + запад -
local pos_z = 0 -- вверх + вниз -

local turtle_eye = 1

-- сервер
local north = 1
-- восток
local east = 2
-- юг
local south = 3
-- запад
local west = 4

local global_pos_x = 0
local global_pos_y = 0
local global_pos_z = 0
local global_turtle_eye = -1

local isNeedSetFakel = -1

local goEnd = 0

local isTurnLeft = true

local up = 0
local forward = 1
local down = 2

local chanelIdSend = 63321

local modem = peripheral.find('modem')

if modem then
    print("I can use wifi modem for send information to ", chanelIdSend)
else
    print("I can use wifi but i need to connect to network by use modem")
end

local function parseNumberInt(inputValue)
    local s = tostring(inputValue)
    return tonumber(s)
end

print("set dlina:")
drina_forward = read()
drina_forward = parseNumberInt(drina_forward)
if drina_forward < 0 then
    drina_forward = 0
end

print("set shirina:")
drina_turn = read()
drina_turn = parseNumberInt(drina_turn)

print("level up:")
level_up = read()
level_up = parseNumberInt(level_up)

isTurnLeft = drina_turn < 0

while true do
    print("Need set torch (true or false)?")
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

local function mathNeedTorch()
    local result = 0

    local t1 = drina_forward / 8
    t1 = math.floor(t1)

    local t2 = 0

    for i = 1, drina_turn do
        if i % 8 == 0 then
            t2 = t2 + 1
        end
    end

    local t3 = t1 * t2

    local i = 0
    while i <= math.abs(level_up) do
        result = result + t3
        i = i + 1
    end
end

if (isNeedSetFakel) then
    mathNeedTorch()
end


local isNeedDropTrash = -1

while true do
    print("Need drop trash cobblestone, dirt and other (true or false)?")
    isNeedDropTrash = read()
    if (isNeedDropTrash == "true") then
        isNeedDropTrash = true
        break
    end
    if (isNeedDropTrash == "false") then
        isNeedDropTrash = false
        break
    end
    print("Incorrect input - ", isNeedDropTrash)
end

local function inputCoords()
    print('Input global_pos_x:')
    global_pos_x = read()
    global_pos_x = parseNumberInt(global_pos_x)

    print('Input global_pos_y:')
    global_pos_y = read()
    global_pos_y = parseNumberInt(global_pos_y)

    print('Input global_pos_z:')
    global_pos_z = read()
    global_pos_z = parseNumberInt(global_pos_z)

    local global_pos_z_max = global_pos_z + 0
    local i = 0
    while i <= math.abs(level_up) do
        global_pos_z_max = global_pos_z_max + 4
        i = i + 1
    end

    print("max level: ", level_up, "global_pos_z ", global_pos_z, "global_pos_z_max: ", global_pos_z_max)

    while true do
        print("eye global north = 1, east = 2, south = 3, west = 4")
        global_turtle_eye = read()
        global_turtle_eye = parseNumberInt(global_turtle_eye)
        if global_turtle_eye >= 1 then
            if global_turtle_eye <= 4 then
                break
            end
        end
    end
end

inputCoords()

local function getLocalPosition()
    local tmp = {}
    tmp['x'] = pos_x
    tmp['y'] = pos_y
    tmp['z'] = pos_z
    return tmp
end

local function getGlobalPosition()
    local tmp = {}
    tmp['x'] = global_pos_x
    tmp['y'] = global_pos_y
    tmp['z'] = global_pos_z
    return tmp
end

local function getPosition()
    local tmp = {}
    tmp['local'] = getLocalPosition()
    tmp['global'] = getGlobalPosition()
    return tmp
end

local function getMessageBasicData()
    local message = {}
    message['id'] = os.getComputerID()
    message['label'] = os.getComputerLabel()
    message['fuelLevel'] = turtle.getFuelLevel()
    message['torchCount'] = turtle.getItemCount(2)
    message['position'] = getPosition()
    return message
end

-- отправка текстового сообщения с информацией
local function sendInfoMessage(text_message, alarm)
    if modem then
        local message = getMessageBasicData()
        if message then
            message['message'] = text_message
            message['type'] = 'info'
        end
        if alarm then
            message['alarm'] = alarm
            message['type'] = 'alarm'
        end
        modem.transmit(chanelIdSend,os.getComputerID(), message)
    end
end

local function sendPositionChange()
    if modem then
        local message = getMessageBasicData()

        message['type'] = 'movement'
        modem.transmit(chanelIdSend,os.getComputerID(), message)
    end
end

local function sendInfoDropMessage(data)
    if modem then
        local message = getMessageBasicData()

        message['dropData'] = data

        message['type'] = 'dropData'
        modem.transmit(chanelIdSend,os.getComputerID(), message)
    end
end

-- проверка нужно ли перезаправить черепашку
local function checkRefuel()
    if turtle.getFuelLevel() < 1000 then
        for i = 3, 16 do
            turtle.select(i)
            if turtle.getItemCount(i) > 0 and turtle.refuel(turtle.getItemCount(i)) then
                print("Refuel complete")
            end
        end
    end
    while turtle.getFuelLevel() < 100 do
        for i = 3, 16 do
            turtle.select(i)
            if turtle.getItemCount(i) > 0 and turtle.refuel(turtle.getItemCount(i)) then
                print("Refuel complete")
            end
        end
        if turtle.getFuelLevel() < 100 then
            local alarm = "Fuel is low " .. turtle.getFuelLevel()
            print(alarm)
            sendInfoMessage(false, alarm)
            os.sleep(5);
        end
    end
end


local goCount = 0

--использовать вместо функции вперед, чтобы считались координаты позиции черепашки
local function goForward2()
    print("pos - ", pos_x, " ", pos_y, " ", pos_z)
    if turtle.detect() then
        turtle.dig() -- уничтожаем блок перед черепашкой, чтобы можно было пройти вперед
    end
    if turtle.forward() == true then -- проверяем смогла ли черепашка пройти вперед?
        if turtle_eye == north then
            pos_x = pos_x + 1 -- идем на север
        elseif turtle_eye == east then
            pos_y = pos_y + 1 -- идем на восток
        elseif turtle_eye == south then
            pos_x = pos_x - 1 -- идем на юг
        elseif turtle_eye == west then
            pos_y = pos_y - 1 -- идем на запад
        end

        if global_turtle_eye == north then
            global_pos_x = global_pos_x + 1
        elseif global_turtle_eye == east then
            global_pos_y = global_pos_y + 1
        elseif global_turtle_eye == south then
            global_pos_x = global_pos_x - 1
        elseif global_turtle_eye == west then
            global_pos_y = global_pos_y - 1
        end

        goCount = goCount + 1
        if (goCount >= 10) then
            checkRefuel()
            goCount = 0
        end

        goEnd = goEnd - 1 -- вычитаем количество проделанных шагов
        sendPositionChange()
        return true
    else
        checkRefuel()
        return false
    end
end

-- опуститься на блок вниз
local function goDown2()
    print("pos - ", pos_x, " ", pos_y, " ", pos_z)
    if turtle.detectDown() then
        turtle.digDown()
    end
    if turtle.down() then
        pos_z = pos_z - 1
        global_pos_z = global_pos_z - 1
        sendPositionChange()
        return true
    else
        checkRefuel()
        return false
    end
end

-- подняться на блок выше
local function goUp2()
    print("pos - ", pos_x, " ", pos_y, " ", pos_z)
    if turtle.detectUp() then
        turtle.digUp()
    end
    if turtle.up() then
        pos_z = pos_z + 1
        global_pos_z = global_pos_z + 1
        sendPositionChange()
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
    global_turtle_eye = global_turtle_eye - 1
    if global_turtle_eye < 1 then
        global_turtle_eye = 4
    end
    turtle.turnLeft()
end

--использовать вместо функции направо, чтобы считались координаты позиции черепашки
local function turnRight2()
    turtle_eye = turtle_eye + 1
    if turtle_eye > 4 then
        turtle_eye = 1
    end
    global_turtle_eye = global_turtle_eye + 1
    if global_turtle_eye > 4 then
        global_turtle_eye = 1
    end
    turtle.turnRight()
end

-- развернуться полностью
local function turnBack()
    turnLeft2()
    turnLeft2()
end

-- выбираем слот с сундуком
local function selectChest()
    turtle.select(1) -- выбираем сундук
    while turtle.getItemCount(1) < 1 do
        print("Sleep 5 seconds need chest to first slop of inventory")
        sendInfoMessage(false,"Sleep 5 seconds need chest to first slop of inventory")
        os.sleep(5)
    end
end

local function useEnderChest()
    while turtle.getItemCount(1) < 1 do
        print("Sleep 5 seconds need chest to first slop of inventory")
        sendInfoMessage(false,"Sleep 5 seconds need chest to first slop of inventory")
        os.sleep(5)
    end
    local name = turtle.getItemDetail(1).name
    if name == "enderstorage:ender_storage" then
        return true
    end
    if name == 'minecraft:chest' then
        return false
    end
    sendInfoMessage(false,"first slot is " .. name .. " not chest or enderstorage")
    os.exit(1)
end

-- это сундук?
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

-- это эндер сундук?
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
        sendInfoMessage(false,"Sleep 5 seconds need torch to second slop of inventory")
        os.sleep(5)
    end
end

-- проверяем наличие факела
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

-- выкинуть мусор из указанного слота
local function dropTrashFromSlot(i)
    if isNeedDropTrash == true then
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
    end
end

-- позиция последнего установленного сундука
local last_chest_pos_x = 0
local last_chest_pos_y = 0
local last_chest_pos_z = 0
local function workSetChest()
    local existTorchDown = isTorch(down)
    local n = 0
    for i = 3, 16 do
        dropTrashFromSlot(i)
        if turtle.getItemCount(i) < 1 then
            n = n + 1
            if n > 5 then
                break
            end
        end
    end
    if n > 3 then
        return -- inventory not full
    end
    selectChest()
    while turtle.placeDown() == false and isEnderChest(down) == false do
        turtle.digDown()
        print("Can't place chest to down side.")
        sendInfoMessage(false,"Can't place chest to down side.")
        selectChest()
        os.sleep(5)
    end
    while isEnderChest(down) == false do
        print("Can't place chest to down side.")
        sendInfoMessage(false,"Can't place chest to down side.")
        os.sleep(5)
    end
    local dataDrop = {}
    for i = 3, 16 do
        while turtle.getItemCount(i) > 0 do
            turtle.select(i)
            local nLocal = turtle.getItemCount(i)
            local itemName = turtle.getItemDetail(i).name
            while turtle.getItemCount(i) > 0 and turtle.dropDown(turtle.getItemCount(i)) == false do
                local alarm = "Can't drop item from " .. i .. " slot to chest to down side. Start sleep 5 seconds."
                print(alarm)
                sendInfoMessage(false,alarm)
                os.sleep(5)
            end
            if dataDrop[itemName] then
                dataDrop[itemName]['count'] =  dataDrop[itemName]['count'] + nLocal
            else
                dataDrop[itemName] = {}
                dataDrop[itemName]['itemName'] = itemName
                dataDrop[itemName]['count'] = nLocal
            end
        end
    end
    sendInfoDropMessage(dataDrop)
    turtle.select(1)
    turtle.digDown()
    while turtle.getItemCount(1) < 1 or turtle.getItemDetail(1).name ~= 'enderstorage:ender_storage' do
        print("Need ender chest to first slot. Start sleep 5 seconds.")
        sendInfoMessage(false, "Need ender chest to first slot. Start sleep 5 seconds.")
        os.sleep(5)
    end
    last_chest_pos_x = pos_x
    last_chest_pos_y = pos_y
    last_chest_pos_z = pos_z
end

-- добыча ресурсов со всех сторон от черепашки
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
local last_torch_pos_x = pos_x + 100
local last_torch_pos_y = pos_y + 100
local last_torch_pos_z = pos_z + 0
local first_torch = false
-- проверка необходимости поставить факел
local function workSetTorch2()
    --if first_torch and last_torch_pos_z ~= pos_z then
        -- факелы ставим только если предположительно под нами есть пол, а на высоте выше первого уровня на котором мы работали пола нет
      --  return
    --end
    if first_torch and math.abs(last_torch_pos_x - pos_x) < 8 then
        -- факелы будем ставить только на расстоянии 8 ячеек
        return
    end
    if first_torch and (math.abs(last_torch_pos_y - pos_y) % 8) ~= 0 then
        -- факелы ставим только ряду кратном 8, чтобы было расстояние между факелами в рамках рядов
        return
    end
    while turtle.getItemCount(2) <= 1 do
        print("Sleep 5 seconds need torch to second slop of inventory")
        sendInfoMessage(false,"Sleep 5 seconds need torch to second slop of inventory")
        os.sleep(5)
    end
    if isTorch(down) == false then
        turtle.select(2) -- выбираем факел
        if turtle.placeDown() == true then
            sendInfoMessage("Torch place down",false)
            print("Torch place down")
        end
    end
    last_torch_pos_x = pos_x
    last_torch_pos_y = pos_y
    last_torch_pos_z = pos_z
    first_torch = true
end

local function workSetTorch()
    if isNeedSetFakel == true then
        workSetTorch2()
    end
end

local function goTo(target_x, target_y, target_z)
    if pos_x > target_x then
        while turtle_eye ~= south do
            turnLeft2()
        end
    end
    if pos_x < target_x then
        while turtle_eye ~= north do
            turnLeft2()
        end
    end
    while pos_x ~= target_x do
        if goForward2() then
            mineFarm()
        else
            print("Can't go forward. start sleep 5 seconds")
            sendInfoMessage(false,"Can't go forward. start sleep 5 seconds")
            os.sleep(5);
        end
    end

    if pos_y > target_y then
        while turtle_eye ~= west do
            turnLeft2()
        end
    end
    if pos_y < target_y then
        while turtle_eye ~= east do
            turnLeft2()
        end
    end
    while pos_y ~= target_y do
        if goForward2() then
            mineFarm()
        else
            print("Can't go forward. start sleep 5 seconds")
            sendInfoMessage(false,"Can't go forward. start sleep 5 seconds")
            os.sleep(5);
        end
    end

    while pos_z > target_z do
        if goDown2() == false then
            print("Can't go down. start sleep 5 seconds")
            sendInfoMessage(false,"Can't go down. start sleep 5 seconds")
            os.sleep(5);
        end
    end

    while pos_z < target_z do
        if goUp2() == false then
            print("Can't go up. start sleep 5 seconds")
            sendInfoMessage(false,"Can't go up. start sleep 5 seconds")
            os.sleep(5);
        end
    end
end

local function runLevel()
    goEnd = drina_forward * math.abs(drina_turn)
    isTurnLeft = drina_turn < 0
    while goEnd > 0 do
        drina_forward_last = drina_forward
        mineFarm()
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
                    sendInfoMessage(false,"Can't go forward. start sleep 5 seconds")
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
                sendInfoMessage(false,"Can't go forward. start sleep 5 seconds")
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
    goTo(0, 0, pos_z)
    while turtle_eye ~= north do
        turnLeft2()
    end
end

local function run()
    print("start mine")
    local level_now = 0
    while level_now <= math.abs(level_up) do
        runLevel()
        workSetChest()
        if level_up > 0 then
            for i = 1, 4 do
                goUp2()
            end

        end
        if level_up < 0 then
            for i = 1, 4 do
                goDown2()
            end
        end

        last_torch_pos_x = pos_x + 100
        last_torch_pos_y = pos_y + 100
        last_torch_pos_z = pos_z + 0
        first_torch = false

        level_now = level_now + 1
    end
    goTo(0, 0, 0)
    while turtle_eye ~= north do
        turnLeft2()
    end
    while true do
        sendInfoMessage("Done",false)
        print('Done')
        os.sleep(10)
    end
end


run()