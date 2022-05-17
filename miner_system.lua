local chanelIdSend = 63321

local dataDir = "data/miner_system"
local dataFile = dataDir .. '/' .. 'miner_system.data'

local modem = peripheral.find("modem")
local monitor = peripheral.find("monitor")
local speaker = peripheral.find("speaker")
if modem then
    -- модем на месте все окей
else
    print("I need modem to connect wifi")
end
modem.open(chanelIdSend)
print("I listen to channel", chanelIdSend)


local turtleData = {}
local buttonsTop = {}
local buttonsTopSelect = false

local lastInfoLineN = 4

local function monitorWriteInfo()
    if monitor then

    else
        return
    end

    if buttonsTopSelect then

    else
        return
    end

    monitor.setBackgroundColor(colors.black)

    for i=4,lastInfoLineN do
        monitor.setCursorPos(2,i)
        monitor.setBackgroundColor(colors.black)
        monitor.clearLine()
    end

    local data = turtleData[buttonsTopSelect]
    if data then

    else
        return
    end

    local i = 4
    if data['time'] then
        monitor.setCursorPos(2,i)
        i = i + 1
        monitor.write('time: ')
        monitor.write(data['time'])
    end

    if data['time'] then
        monitor.setCursorPos(2,i)
        i = i + 1
        monitor.write('id: ')
        monitor.write(data['id'])
    end

    if data['label'] then
        monitor.setCursorPos(2,i)
        i = i + 1
        monitor.write('label: ')
        monitor.write(data['label'])
    end

    if data['position'] then
        if data['position']['local'] then
            monitor.setCursorPos(2,i)
            i = i + 1
            monitor.write('position local: ')
            monitor.write(data['position']['local']['x'])
            monitor.write(', ')
            monitor.write(data['position']['local']['y'])
            monitor.write(', ')
            monitor.write(data['position']['local']['z'])
        end
        if data['position']['global'] then
            monitor.setCursorPos(2,i)
            i = i + 1
            monitor.write('position global: ')
            monitor.write(data['position']['global']['x'])
            monitor.write(', ')
            monitor.write(data['position']['global']['y'])
            monitor.write(', ')
            monitor.write(data['position']['global']['z'])
        end
    end

    if data['message'] then
        monitor.setCursorPos(2,i)
        i = i + 1
        monitor.write('last message: ')
        monitor.write(data['message'])
    end

    if data['alarm'] then
        monitor.setCursorPos(2,i)
        i = i + 1
        monitor.write('alarm: ')
        monitor.setBackgroundColor(colors.red)
        monitor.write(data['alarm'])
        monitor.setBackgroundColor(colors.black)
    end

    --print('log dropData: ' .. tostring(data['dropData']))
    if data['dropData'] then
        local w, h = monitor.getSize()
        h = h - 1
        monitor.setCursorPos(2,i)
        i = i + 1
        monitor.write('dropData: ')
        for k,v in pairs(data['dropData']) do
            monitor.setCursorPos(4,i)
            i = i + 1
            monitor.write(v['itemName'])
            monitor.write(' - ')
            monitor.write(v['count'])
            if i == h then
                monitor.write(' ...')
                break
            end
        end
    end

    lastInfoLineN = i - 1
end

local function buttonTopRecreate()

    if monitor then

    else
        return
    end

    monitor.setCursorPos(1,2)
    monitor.setBackgroundColor(colors.black)
    monitor.clearLine()

    local i = 1

    for k,v in pairs(turtleData) do

        if buttonsTopSelect == false then
            buttonsTopSelect = k
        end

        monitor.setBackgroundColor(colors.black)

        monitor.write(' ')
        i = i + 1

        if buttonsTopSelect == k then
            monitor.setBackgroundColor(colors.green)
        else
            monitor.setBackgroundColor(colors.blue)
            if v['alarm'] then
                monitor.setBackgroundColor(colors.red)
            end
        end

        local labelText = tostring(v['label']) .. '(' .. tostring(v['id']) .. ')'


        if v['alarm'] then
            labelText = labelText .. '*'
        end

        monitor.write(labelText)

        monitor.setBackgroundColor(colors.black)

        local n = string.len(labelText)

        local i1 = i
        i = i + n
        local i2 = i

        buttonsTop[k] = { i1, i2 }

    end

end

local function writeLogData2(file, data, prefix)
    if type(data) == 'table' then
        for k,v in pairs(data) do
            if string.len(prefix) > 0 then
                writeLogData2(file, v, prefix .. ',' .. k)
            else
                writeLogData2(file, v, k)
            end
        end
    else
        data = tostring(data)
        file.writeLine(prefix .. '=' .. data)
    end
end

local function writeLogData()
    if fs.exists(dataFile) then
        fs.delete(dataFile)
    end
    if fs.exists(dataDir) == false then
        fs.makeDir(dataDir)
    end
    local file = fs.open(dataFile,'w')
    writeLogData2(file, turtleData, 'turtleData')
    file.close()
end

local function isNumber(str)
    str = tostring(str)
    if string.len(str) == 0 then
        return false
    end
    for i=1, string.len(str) do
        local ch = str.sub(str,i,i)
        if ch == '1' then
        elseif ch == '2' then
        elseif ch == '3' then
        elseif ch == '4' then
        elseif ch == '5' then
        elseif ch == '6' then
        elseif ch == '7' then
        elseif ch == '8' then
        elseif ch == '9' then
        elseif ch == '0' then
        else
            return false
        end
    end
    return true
end

local function isBoolean(str)
    if str == 'true' then
        return true
    end
    if str == 'false' then
        return true
    end
    return false
end

local function toBoolean(str)
    if str == 'true' then
        return true
    end
    if str == 'false' then
        return false
    end
end

local function readLogData()
    if fs.exists(dataFile) == false then
        return
    end
    local file = fs.open(dataFile,'r')
    while true do
        local line = file.readLine()
        if line then
            if string.len(line) > 0 then
                local v = string.find(line, '=')
                if v then
                    v = string.sub(line, v + 1)
                end
                local i = string.find(line,'=')
                line = string.sub(line, 1, i - 1)
                print(line)
                i = string.find(line,',')
                local field = string.sub(line, 1, i - 1)
                line = string.sub(line, i + 1)
                if field == 'turtleData' then
                    local t2 = turtleData
                    while true do
                        i = string.find(line,',')
                        if i then
                            field = string.sub(line, 1, i - 1)
                            if isNumber(field) then
                                field = tonumber(field)
                            end
                            line = string.sub(line, i + 1)
                            if t2[field] then

                            else
                                t2[field] = {}
                            end
                            t2 = t2[field]
                        else
                            field = line
                            if isNumber(field) then
                                field = tonumber(field)
                            end
                            if isNumber(v) then
                                v = tonumber(v)
                            end
                            if isBoolean(v) then
                                v = toBoolean(v)
                            end
                            t2[field] = v
                            break
                        end
                    end
                end
            end
        else
            break
        end
    end
    file.close()
end

readLogData()

local function modemEvent(event)
    --local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")

    -- local modemSide = event[2]
    -- local senderChannel = event[3]
    -- local replyChannel = event[4]
    local message = event[5]
    local senderDistance = event[6]

    senderDistance = senderDistance - (senderDistance % 1)

    local time_str = textutils.formatTime(os.time(), false)

    local formatMessage = time_str .. ': '

    local first = true
    for k, v in pairs(message) do
        if first then
            first = false
        else
            formatMessage = formatMessage .. ', '
        end
        formatMessage = formatMessage .. k .. ': ' .. tostring(v)
    end
    print(formatMessage)

    message['time'] = time_str
    message['time_ms'] = os.clock()

    if turtleData[message['id']] then

        local oldData = turtleData[message['id']]

        if message['type'] == 'movement' then
            if oldData['message'] and math.abs(os.clock() - oldData['time_ms']) < 30 then
                message['message'] = oldData['message']
            end
        end
        if message['dropData'] then
            -- есть данные
        else
            if oldData['dropData'] then
                message['dropData'] = oldData['dropData']
            end
        end

        turtleData[message['id']] = message
    else
        turtleData[message['id']] = message
    end

    buttonTopRecreate()

    if buttonsTopSelect == message['id'] then
        monitorWriteInfo()
    end

    if speaker and message['alarm'] then
        speaker.playNote("hat")
    end

    writeLogData()
end

local function monitorClickButton(pos_x, pos_y)
    for k,v in pairs(buttonsTop) do
        if pos_x > v[1] and pos_x < v[2] then
            if buttonsTopSelect == k then
                break
            end
            buttonsTopSelect = k
            buttonTopRecreate()
            monitorWriteInfo()
            break
        end
    end
end

local function monitorClick(event)
    local pos_x = event[3]
    local pos_y = event[4]

    if pos_y == 2 then
        monitorClickButton(pos_x, pos_y)
    end
end

if monitor then
    monitor.setBackgroundColor(colors.black)
    monitor.clear()
    monitor.setTextScale(0.5)
end

local timerCurrentTimeInfo = false
local timerReMonitorInfoWrite = false
if monitor then
    timerCurrentTimeInfo = os.startTimer(1)
    timerReMonitorInfoWrite = os.startTimer(10)
end

local function timerEventWait(event)
    if timerCurrentTimeInfo == event[2] then
        if monitor then
            local w, h = monitor.getSize()
            monitor.setCursorPos(2, h - 1)
            monitor.clearLine()
            monitor.write('current time: ')
            monitor.write(textutils.formatTime(os.time(), false))
        end
        timerCurrentTimeInfo = os.startTimer(1)
    elseif timerReMonitorInfoWrite == event[2] then
        buttonTopRecreate()
        monitorWriteInfo()
        timerReMonitorInfoWrite = os.startTimer(10)
    end
end

local function iter()
    local e = { os.pullEvent() }
    if e[1] == 'modem_message' then
        modemEvent(e)
    elseif e[1] == 'monitor_touch' then
        monitorClick(e)
    elseif e[1] == 'timer' then
        timerEventWait(e)
    end
end

buttonTopRecreate()
monitorWriteInfo()

while true do
    iter()
end