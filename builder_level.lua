local lastN = 0

local function selectBuildSlot()
    while lastN <= 1 do
        for i=1,16 do
            if (turtle.getItemCount(i) > 1) then
                turtle.select(i)
                lastN = turtle.getItemCount(i) - 1
                return lastN
            end
        end
        print("need build material. Sleep 30 seconds.")
        os.sleep(30)
    end
    return 0
end

while true do
    selectBuildSlot()
    if turtle.place() == true then
        lastN = lastN - 1
    end
    if turtle.back() == false then
        turtle.turnLeft()
    end
end