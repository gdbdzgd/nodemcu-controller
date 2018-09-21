EA=12
EB=13
EN=14

gpio.config({
  gpio= {EA, EB,EN},
  dir=gpio.IN ,
  pull= gpio.PULL_UP
})



EBS=0
count=0

aousec=0
bup_ousec=0
bdown_ousec=0
interval=500
gpio.trig(EA,gpio.INTR_UP_DOWN,function (pin,level)
    sec,cusec=rtctime.get() 
    -- print("ping:"..pin..":"..level)
    if level ~= 0 then return end
    if math.abs(cusec - aousec) < interval then return end
    EAS=level 
    if EBS == 256 then count=count+1 
     print(count)
    end
    if EBS == 0 then count=count-1 
     print(count)
    end
end)
gpio.trig(EB,gpio.INTR_UP_DOWN,function (pin,level)     
    sec,cusec=rtctime.get()
    -- print("ping:"..pin..":"..level)
    if level == 0 then 
        if math.abs(cusec - bup_ousec) < interval then return end
        bup_ousec = cusec
    end
    if level == 256 then
        if math.abs(cusec - bdown_ousec) < interval then return end
        bdown_ousec = cusec
    end
    EBS=level    
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
    --print(menupostion)
    ocount=count
    draw()
end
end)

mytimer:start()

