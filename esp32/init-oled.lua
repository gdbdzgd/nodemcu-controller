-- writen by gdzhang for init oled
Temp="00.0"
STemp="00.0"
Humidity="00.0"
time="获取中.."
date="获取中.."
tm=nil
open=0
temp_set=0
week_day={"日","一","二","三","四","五","六"}
ud_timer = tmr.create()
sntp_timer = tmr.create()
function init_i2c_display()
--    SDA and SCL can be assigned freely to available GPIOs
    local id  = 0
    local sda = 21 --16
    local scl = 22 --17
    local sla = 0x3c
    local sla1 = 0x3d
    i2c.setup(id, sda, scl, i2c.SLOW)
    disp = u8g2.sh1106_i2c_128x64_noname(id, sla)
    disp1 = u8g2.sh1106_i2c_128x64_noname(id, sla1)
end
function u8g2_prepare()
    --disp:setFont(u8g2.font_6x10_tf)
    disp:setFont(u8g2.font_wqy12_t_gb2312b)
    disp:setFontRefHeightExtendedText()
    disp:setDrawColor(1)
    disp:setFontPosTop()
    disp:setFontDirection(0)
    disp1:setFont(u8g2.font_wqy12_t_gb2312b)
    disp1:setFontRefHeightExtendedText()
    disp1:setDisplayRotation(u8g2.R2)
    disp1:setDrawColor(1)
    disp1:setFontPosTop()
    disp1:setFontDirection(0)
end
function draw()
    disp:clearBuffer()
    disp:setFont(u8g2.font_wqy12_t_gb2312b)
    disp:setFontPosTop()
    disp:drawUTF8(0, 9, "室温:")
    disp:drawUTF8(0, 38, "设定:")
    disp:drawUTF8(110,9, "℃")
    disp:drawUTF8(110,38, "℃")
    disp:drawUTF8(0, 51, "测试测试测试℃")
    disp:setFont(u8g2.font_freedoomr25_tn)
    disp:setFontPosTop()
    disp:drawStr(35,0,Temp)
    disp:drawStr(35,25,STemp)
    disp:sendBuffer()
    disp1:clearBuffer()
-- disp1:drawUTF8(0,0,"测试")
--   disp1:sendBuffer()
    disp1:setFont(u8g2.font_wqy12_t_gb2312b)
    disp1:setFontPosTop()
    disp1:drawUTF8(0, 0, date)
    disp1:drawUTF8(0, 51, "湿度:")
    disp1:drawUTF8(85, 51, "%")
    disp1:setFont(u8g2.font_freedoomr25_tn)
    disp1:setFontPosTop()
    disp1:drawUTF8(10, 13, time)
    disp1:drawUTF8(35, 39, Humidity)
    disp1:sendBuffer()
end
function init_wifi()
 wf = require("esp32_wifi")
wf.on("connection", function(info)
  print("Got wifi. IP:", info.ip, "Netmask:", info.netmask, "GW:", info.gw)
end)
wf.on("disconnection", function()
  print("Disconnected from Wifi. Should get auto-reconnect.")
end)
wf.init()
            
end
sntp_timer:register(10000,tmr.ALARM_AUTO,function()
  local dh22_pin = 0
  local status, temp, humi, temp_dec, humi_dec = dht.read2x(dh22_pin)
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
init_wifi()
print("i2c init display")
ud_timer:start()
init_i2c_display()
print("i2c prepare u8g2")
u8g2_prepare()
ud_timer:start()
sntp_timer:start()
sntp.sync(nil)
-- draw()
