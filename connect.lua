-- wifi.sta.connect()
tmr.alarm(1, 1000, 1, function()
  drawn = false
  if wifi.sta.getip() == nil then
    if not drawn then
      disp:firstPage()
      repeat
        disp:drawStr(0, 11, "connecting")
      until disp:nextPage() == false
      drawn = true
    end
  else
    -- tmr.stop(1)
    tm = rtctime.epoch2cal(rtctime.get()+28800)
    -- brightness
    if ( tm["hour"] >= 0 and tm ["hour"] <= 6 ) or ( tm["hour"] >= 20 and tm ["hour"] <= 24 ) then
            disp:setContrast(0)
    else
            disp:setContrast(128)
    end

    time=string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"])

    -- DHT 22
    -- pin = 2
    -- status, temp, humi, temp_dec, humi_dec = dht.read(pin)
    -- if status == dht.OK then
    --         draw(nil,0,10,
    --             string.format("Temp:%d.%03d ℃ ;Humidity:%d.%03d%\r\n", math.floor(temp), temp_dec, math.floor(humi), humi_dec)
    --             )
    --         -- print("DHT Temperature:"..temp..";".."Humidity:"..humi)
    -- elseif status == dht.ERROR_CHECKSUM then
    --         print( "DHT Checksum error." )
    -- elseif status == dht.ERROR_TIMEOUT then
    --         print( "DHT timed out." )
    -- end
    draw()
            

  end
end)
