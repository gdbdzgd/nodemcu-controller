tm_dh22 = tmr.create()

dh22_pin=5
print("init dh22")
tm_dh22:register(1000, tmr.ALARM_AUTO, function ()
    local status, temp, humi, temp_dec, humi_dec = dht.read2x(dh22_pin)
    if status == dht.OK then
        Humidity = string.format("%0.1f",math.floor(humi))
        Temp = string.format("%0.1f",math.floor(temp))
        --Temp_array[tmp_pos] = temp
        tmp_pos = tmp_pos +1
        local total=0
        local t_total=0
        for i = 0,array_l do
            -- print("Temp_array["..i.."]:"..Temp_array[i])
            if Temp_array[i] ~= -255 then
                total = total + Temp_array[i]
            else
                t_total = t_total+1
            end
        end
        if t_total ~= 0 then
            Temp=string.format("%0.1f",(total/(array_l+1)))
        else
            Temp=string.format("%0.1f",(total/(array_l+1-t_total)))
        end
        -- print("total:"..total)
        -- print("array_l:"..(array_l+1))
        if tmp_pos == (array_l+1) then
            tmp_pos = 0
        end

        print("DHT Temperature:"..temp..";".."Humidity:"..humi)
    elseif status == dht.ERROR_CHECKSUM then
        print("DHT Checksum error.")
    elseif status == dht.ERROR_TIMEOUT then
        print("DHT timed out.")
    end
    print(date)
    print(time)
    Humidity="test"
    print("温度1："..Temp)
    print("湿度1："..Humidity)

end)

tm_dh22:start()


