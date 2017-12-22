if ( tm["hour"] >= 0 and tm ["hour"] <= 6 ) or ( tm["hour"] >= 20 and tm ["hour"] <= 24 ) then
    disp:setContrast(0)
else
    disp:setContrast(128)
end

date=string.format("%04d年%02d月%02d日",tm["year"], tm["mon"], tm["day"])
time=string.format("%02d点%02d分%02d秒周%2d",tm["wday"],tm["hour"], tm["min"], tm["sec"])

-- DHT 22
--[[
-- pin = 2
-- status, temp, humi, temp_dec, humi_dec = dht.read(pin)
-- if status == dht.OK then
--    Humidity = string.format("%0.1f"..humi)
--    Temp = string.format("%0.1f"..temp)
--print("DHT Temperature:"..temp..";".."Humidity:"..humi)
-- elseif status == dht.ERROR_CHECKSUM then
--     print( "DHT Checksum error." )
-- elseif status == dht.ERROR_TIMEOUT then
--    print( "DHT timed out." )
--end
--]]
