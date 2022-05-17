print("input count slots where exists result items")
local n = read()

while true do
    for i=1, n do
        while turtle.getItemCount(1) < 1 do
            print("need item to first slot")
            os.sleep(30)
        end
    end
    while (turtle.suck() == true) do
        print("suck() called")
    end
    for i=n + 1, 16 do
        if turtle.getItemCount(i) > 0 then
            local find = false
            for j=1, n do
                turtle.select(j)
                if turtle.compareTo(i) then
                    find = true
                    break
                end
            end
            if find == false then
                turtle.select(i)
                turtle.drop(turtle.getItemCount(i))
                print("drop() called")
            end
        end
    end
    print("sleep 30 seconds")
    os.sleep(30)
end