sda = 4
scl = 5
-- sla = 0x3d sh1106
-- ssd1306
sla = 0x3c

id  = i2c.HW0

-- initialize i2c, set pin1 as sda, set pin2 as scl
i2c.setup(id, sda, scl, i2c.SLOW)
-- i2c.setup(0, sda, scl, i2c.SLOW)
-- disp = u8g.ssd1306_128x64_i2c(sla)

disp = u8g2.ssd1306_i2c_128x64_noname(id, sla)
--disp:setFont(u8g.font_orgv01n)
-- disp:setFont(u8g.font_freedoomr25n)
-- disp:setFont(u8g2.font_liquid)
disp:setFont(u8g2.font_unifont_t_chinese3)
disp:setFontRefHeightExtendedText()
disp:setDefaultForegroundColor()
disp:setFontPosTop()



date="date"
time="time syncing..."
Temp=""
total=0
Temp_array = {}
array_l=20
-- init array
for i = 0,array_l do
       Temp_array[i] = 0
end
tmp_pos = 0
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

    date=string.format("day  : %04d/%02d/%02d",tm["year"], tm["mon"], tm["day"])
    time=string.format("time: %02d:%02d:%02d",tm["hour"], tm["min"], tm["sec"])

    -- DHT 22
     pin = 2
     status, temp, humi, temp_dec, humi_dec = dht.read(pin)
     if status == dht.OK then
             Humidity = string.format("Humidity:"..humi)
             Temp_array[tmp_pos] = temp
             tmp_pos = tmp_pos +1
             total=0
             for i = 0,array_l do
                     -- print("Temp_array["..i.."]:"..Temp_array[i])
                     total = total + Temp_array[i]
             end

             Temp=string.format("temp   :%0.2f",(total/(array_l+1)))
             --print("total:"..total)
             --print("array_l:"..(array_l+1))
             if tmp_pos == (array_l+1) then
                     tmp_pos = 0
             end


    --print("DHT Temperature:"..temp..";".."Humidity:"..humi)
     elseif status == dht.ERROR_CHECKSUM then
             print( "DHT Checksum error." )
     elseif status == dht.ERROR_TIMEOUT then
             print( "DHT timed out." )
     end
    print(date)
    print(time)
    print(Temp)
    print(Humidity)
    draw()
  end
end)
