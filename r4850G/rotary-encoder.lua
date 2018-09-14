EA=12
EB=13
EN=14

gpio.config({
  gpio= {EA, EB, EN},
  dir=gpio.IN ,
  pull= gpio.PULL_FLOATING
})
arr={}
brr={}
a_i=1
b_i=1

EBS=0
count=0

gpio.trig(EA,gpio.INTR_UP,function (pin,level)
    EAS=level
    if level ~= 256
    then
        return
    end
    if EBS == 256
    then
        count=count+1
        -- print(count)
    end
    
end)
gpio.trig(EB,gpio.INTR_UP_DOWN,function (pin,level)
    -- if gpio.read(EA) == EAS then return end
    EBS=level
    if level ~= 256
    then
        return
    end
    if EAS == 256
    then
        count=count-1
        -- print(count)
    end
    
end)
gpio.trig(EN,gpio.INTR_UP_DOWN,function (pin,level)
    print(pin,level)
end)
mytimer = tmr.create()
ocount=-1
menupostion=1
mytimer:register(40, tmr.ALARM_AUTO, function() 
if ocount ~= count 
then
    if count > ocount
    then
        menupostion=menupostion-1
        if menupostion == 0 then menupostion=5 end
    end
    if count < ocount
    then
        menupostion=menupostion+1
        if menupostion == 6 then menupostion=1 end
    end
    print(menupostion)
    ocount=count
    draw()
end
end)

mytimer:start()

