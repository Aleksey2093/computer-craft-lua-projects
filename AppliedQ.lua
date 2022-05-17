local function toChestCertus()
    print('locking chest')
    while true do
        local s, i = turtle.inspect()
        if (s == true) then
            if (i.name == 'minecraft:chest') then
                break
            end
        end
        turtle.turnLeft()
    end
end

while true do
    toChestCertus()
    while turtle.getItemCount(1) < 2 do

        turtle.suck(10)

        if turtle.getItemCount(1) > 0 then
            for i = 3,16 do
                turtle.select(1)
                if turtle.getItemCount(i) > 0 and turtle.compareTo(i) then
                    turtle.select(i)
                    turtle.transferTo(1)
                end
            end
        end

    end
    toChestCertus()
    turtle.turnLeft()
    turtle.turnLeft()

    for i = 2,16 do
        turtle.select(1)
        if turtle.getItemCount(i) > 0 and turtle.compareTo(i) == false then
            turtle.select(i)
            while turtle.dropUp(turtle.getItemCount(i)) == false do
                os.sleep(5)
                print("chest up is full")
            end
        end
    end

    turtle.suck()
    turtle.select(1)
    turtle.drop()

    os.sleep(5)

end