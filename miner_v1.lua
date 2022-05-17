local am
local lef = 3
local dlina = 0 --kol dvij vpered(x)
local kol = 0 --kol-vo povorotov (y)
local fak = 0 --fakel kazdue 5 yachek
local fakin = 0 --ukazatel na 5 ryad
local q = 11 --ukazatel na ustanovky fakel
print("sunduk - one slot, fakely - last stop")
print("vvdedite dlinu")
dlina = read()
print("vvdetite kol-vo povorotov")
kol = read()
print("kuda povat? left or right")
while lef == 3 do
    am = read()
    if am == "left" then lef = 0 break else
        if am == "right" then left = 1 break else
            print("error")
        end
    end
end

print("stavit fakel? yes or no ")
while q == 11 do
    am = read()
    if am == "yes" then q = 5 break else
        if am == "no" then q = 10 break else
            print("error")
        end
    end
end

function fakel()
    turtle.digDown()
    turtle.select(16)
    turtle.placeDown()
    print("esst")
end

function sunduk()
    turtle.select(1)
    if turtle.getItemCount(1) < 2 then
        print("polojite v 1-y slot sunduki")
        print("zatem nazmite enter")
        read()
    end
    if not turtle.compareDown(1) then
        turtle.digDown()
        turtle.placeDown()
    end
    for i = 2, 15 do
        turtle.select(i)
        turtle.dropDown()
    end
end

function run()
    fak = 5
    for i = 1, dlina do
        turtle.select(1)
        if turtle.getItemCount(15) > 0 then
            sunduk()
        end --
        turtle.select(1)
        turtle.digUp()
        if not turtle.compareDown() then turtle.digDown() end
        while turtle.detect() do
            turtle.dig()
        end
        if fak == 7 then
            if fakin == 1 then fakel() end
            fak = 0
        else fak = fak + 1 end
        while not turtle.forward() do end
        --print("fak=",fak)
    end
end

function povorot()
    if lef == 0 then turtle.turnLeft()
        while turtle.detectUp() do turtle.digUp() end
        turtle.digDown()
        while turtle.detect() do turtle.dig() end
        while not turtle.forward() do end
        turtle.turnLeft()
        lef = 1
    else
        turtle.turnRight()
        while turtle.detectUp() do turtle.digUp() end
        turtle.digDown()
        while turtle.detect() do turtle.dig() end
        while not turtle.forward() do turtle.forward() end
        turtle.turnRight()
        lef = 0
    end
end

for i = 1, kol do
    if q == 5 then fakin = 1
    q = 0
    else q = q + 1 end
    run()
    povorot()
    fakin = 0
    if turtle.getItemCount(16) < 2 then break end
end
turtle.digDown()
fakel()
