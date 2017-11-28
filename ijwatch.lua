dofile("oled.lua") 

date="date"
time="time syncing..."
Temp="temp"
Humidity="XX"

tmr.alarm(0, 30000, 1, function()
  sntp.sync(nil,nil,nil,1)
end)

station_cfg={}
station_cfg.ssid="LEDE"
station_cfg.pwd="rockyrocky"
station_cfg.save=true
wifi.setmode(wifi.STATION)
wifi.sta.config(station_cfg)

function draw()
  disp:firstPage()
  repeat
--        disp:setFont(u8g.font_6x10)
        disp:drawStr(0, 0, date)
        disp:drawStr(0, 16, time)
        disp:drawStr(0, 32, Temp)
        disp:drawStr(0, 48, Humidity)
--        disp:drawStr(0, 48, wifi.sta.getip())

  until disp:nextPage() == false
end

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

    date=string.format("DAY : %04d/%02d/%02d",tm["year"], tm["mon"], tm["day"])
    time=string.format("TIME: %02d:%02d:%02d",tm["hour"], tm["min"], tm["sec"])

    -- DHT 22
     pin = 2
     status, temp, humi, temp_dec, humi_dec = dht.read(pin)
     if status == dht.OK then
             Temp=string.format("TEMP: %d.%02d",
                       math.floor(temp),
                       temp_dec
                       )
             Humidity=string.format("HUMI: %d.%02d",
                       math.floor(humi),
                       humi_dec
                       )
     -- print("DHT Temperature:"..temp..";".."Humidity:"..humi)
     elseif status == dht.ERROR_CHECKSUM then
             print( "DHT Checksum error." )
     elseif status == dht.ERROR_TIMEOUT then
             print( "DHT timed out." )
     end
    print(time)
    print(Temp)
    print(Humidity)
    draw()
  end
end)
