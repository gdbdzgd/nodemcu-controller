-- wirte by gdzhang@gmail.com
local mytimer = tmr.create()
Temp="0"
total=0
Temp_array = {}
array_l=4
-- for i = 0,array_l do
--     Temp_array[i] = 0
-- end
tmp_pos = 0
Humidity="XX"
dofile("init-oled.lua")
-- oo calling

mytimer:register(1000, tmr.ALARM_AUTO, function ()
    status, temp, humi, temp_dec, humi_dec = dht.read2x(23)
    if status == dht.OK then
        Humidity = string.format("%0.1f",math.floor(humi))
        Temp_array[tmp_pos] = temp
        tmp_pos = tmp_pos +1
        total=0
        for i = 0,array_l do
            -- print("Temp_array["..i.."]:"..Temp_array[i])
            total = total + Temp_array[i] 
        end
        Temp=string.format("%0.1f",(total/(array_l+1)))
        print("total:"..total)
        print("array_l:"..(array_l+1))
        if tmp_pos == (array_l+1) then
            tmp_pos = 0
        end
        --print("DHT Temperature:"..temp..";".."Humidity:"..humi)
    elseif status == dht.ERROR_CHECKSUM then
        print( "DHT Checksum error." )
    elseif status == dht.ERROR_TIMEOUT then
        print( "DHT timed out." )
    end
    --    print(date)
    --    print(time)
    print(Temp)
    print(Humidity)
    draw()
end)

mytimer:start()








