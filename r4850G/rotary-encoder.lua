EA=12
EB=13
EN=14
count=1
gpio.config({
  gpio= {EA, EB,EN},
  dir=gpio.IN ,
  pull= gpio.PULL_UP
})

gpio.trig(EA,gpio.INTR_UP_DOWN,function (pin,level)
    if level == 0 then 
        pos=sm[0].postion
        sm[pos].action(sm,UP)
        count=count+1
    end
end)
gpio.trig(EB,gpio.INTR_UP_DOWN,function (pin,level)     
    if level == 0 then 
        pos=sm[0].postion
        sm[pos].action(sm,DOWN)
        count=count-1
    end
end)

gpio.trig(EN,gpio.INTR_UP_DOWN,function (pin,level)
    if level == 256 then 
        pos=sm[0].postion
        sm[pos].action(sm,IN)
        count=count+1
    end
end)
mytimer = tmr.create()
ocount=-1
mytimer:register(40, tmr.ALARM_AUTO, function() 
    if ocount ~= count then
        ocount=count
        draw()
    end
end)
mytimer:start()

