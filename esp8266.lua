-- writen by gdzhang for init oled
Temp="00.0"
STemp="00.0"
Humidity="00.0"
time="获取中.."
date="获取中.."
tm=nil
week_day={"日","一","二","三","四","五","六"}

ud_timer = tmr.create()

sntp_timer = tmr.create()

function init_i2c_display()
--    SDA and SCL can be assigned freely to available GPIOs
    local id  = 0
    local sda = 3 --16
    local scl = 4 --17
    local sla = 0x3c
    local sla1 = 0x3d
    i2c.setup(id, sda, scl, i2c.SLOW)
    disp = u8g2.sh1106_i2c_128x64_noname(id, sla)
    disp1 = u8g2.sh1106_i2c_128x64_noname(id, sla1)
end
function u8g2_prepare()
    --disp:setFont(u8g2.font_6x10_tf)
    disp:setFont(u8g2.font_wqy13_t_gb2312b)
    disp:setFontRefHeightExtendedText()
    disp:setDrawColor(1)
    disp:setFontPosTop()
    disp:setFontDirection(0)
    disp1:setFont(u8g2.font_wqy13_t_gb2312b)
    disp1:setFontRefHeightExtendedText()
    disp1:setDisplayRotation(u8g2.R2)
    disp1:setDrawColor(1)
    disp1:setFontPosTop()
    disp1:setFontDirection(0)
end
function draw()
    disp:clearBuffer()
    disp:setFont(u8g2.font_wqy13_t_gb2312b)
    disp:setFontPosTop()
    disp:drawUTF8(0, 9, "室温:")
    disp:drawUTF8(0, 38, "设定:")
    disp:drawUTF8(110,9, "℃")
    disp:drawUTF8(110,38, "℃")
    disp:drawUTF8(0, 51, "测试测试测试℃")
    disp:setFont(u8g2.font_freedoomr25_mn)
    disp:setFontPosTop()
    disp:drawStr(35,0,Temp)
    disp:drawStr(35,25,STemp)
    disp:sendBuffer()
    disp1:clearBuffer()
-- disp1:drawUTF8(0,0,"测试")
--   disp1:sendBuffer()
    disp1:setFont(u8g2.font_wqy13_t_gb2312b)
    disp1:setFontPosTop()
    disp1:drawUTF8(0, 0, date)
    disp1:drawUTF8(0, 51, "湿度:")
    disp1:setFont(u8g2.font_freedoomr25_mn)
    disp1:setFontPosTop()
    disp1:drawUTF8(10, 13, time)
    disp1:drawUTF8(35, 39, Humidity)

    disp1:sendBuffer()
end
function init_wifi()
 print("init wifi connection")
 station_cfg={}
 station_cfg.ssid="linxdots"
 station_cfg.pwd="dotswifi"
 station_cfg.save=true
 wifi.setmode(wifi.STATION)
 wifi.sta.config(station_cfg)
 if wifi.sta.getip() == nil then
   print("wifi connect faild.")
 else
   print("wifi ip:"..wifi.sta.getip())
 end
end

sntp_timer:register(10000,tmr.ALARM_AUTO,function()
  if tm["year"] <= 2016 then
    sntp.sync("0.pool.ntp.org",
      function(sec, usec, server,info)
        print('sync ok',sec,usec,server)        -- run_sntp_flag=0
      end,
      function()
        print('sntp sync faild, will try next 10s')
      end,
      1)
  end
  local dh22_pin = 1
  local status, temp, humi, temp_dec, humi_dec = dht.read(dh22_pin)
  if status == dht.OK then
    Humidity = string.format("%0.1f",math.floor(humi))
    Temp = string.format("%0.1f",math.floor(temp))
  elseif status == dht.ERROR_CHECKSUM then
        Humidity="DHT Checksum error"
  elseif status == dht.ERROR_TIMEOUT then
        Temp="DHT timed out"
  end

end
)

ud_timer:register(1000, tmr.ALARM_AUTO, function()

    tm = rtctime.epoch2cal(rtctime.get()+28800)

    if ( tm["hour"] >= 0 and tm ["hour"] <= 6 ) or ( tm["hour"] >= 20 and tm ["hour"] <= 24 ) then
      disp:setContrast(0)
    else
      disp:setContrast(128)
    end
    local wd=tm['wday']
    if tm["year"] > 2016 then
      date=string.format("%02d年%02d月%02d日周"..week_day[wd], tm['year'], tm['mon'],tm['day'])
     
      if tm['sec']%2 == 0 then
        time=string.format("%02d:%02d",tm['hour'], tm['min'])
      else
        time=string.format("%02d %02d",tm['hour'],tm['min'])
      end
    end
    --print("in timer")
    draw()
  end)
node.setcpufreq(node.CPU160MHZ)
init_wifi()
print("i2c init display")
ud_timer:start()
init_i2c_display()
print("i2c prepare u8g2")
u8g2_prepare()
ud_timer:start()
sntp_timer:start()
-- draw()
