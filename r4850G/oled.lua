require("menu")
DEGREE=U8G2_R0

function init_i2c_display()
    --    SDA and SCL can be assigned freely to available GPIOs
    local id  = i2c.HW0
    local sda = 17 --16
    local scl = 16 --17
    local sla = 0x3c
    i2c.setup(id, sda, scl, i2c.FAST)
    disp = u8g2.sh1106_i2c_128x64_noname(id, sla)
end
function u8g2_prepare()
    --disp:setFont(u8g2.font_6x10_tf)
    disp:setFont(u8g2.font_wqy12_t_gb2312b)
    disp:setFontRefHeightExtendedText()
    disp:setFontMode(0)
    disp:setDrawColor(1)
    disp:setFontPosTop()
    disp:setFontDirection(0)
end
Temp=1
data=1
time=1
Humidity=1
STemp=1
date=0
offset=0
menupostion=1
function draw()
    disp:clearBuffer()
    disp:setFont(u8g2.font_wqy12_t_gb2312b)
    disp:setDisplayRotation(u8g2.R3);
    disp:setFontPosTop()
    --disp:drawUTF8(0, 51, "测试测试测试℃")
    for i=1,#menu do
         --disp.drawUTF8(0,0+offset,menu[i].text)
        if i == menupostion
        then
            
            disp.drawBox(disp,0,1+offset,64,14);
            disp:setFontMode(0)
            disp:setDrawColor(0)
            
        end
        
        disp:drawUTF8(1, 1+offset, i..menu[i].text)
        disp:setFontMode(0)
        disp:setDrawColor(1)
        offset=offset+14
    end
    offset=0

    disp:setFontPosTop()
    -- disp:drawStr(35,0,Temp)
    -- disp:drawStr(35,25,STemp)
    disp:sendBuffer()
end
gpio.write(18, 1)
gpio.write(18, 0)

osec,ousec=rtctime.get()
sec,usec=rtctime.get()
while math.abs(usec-ousec)< 200000 do

    sec,usec=rtctime.get()
end
gpio.write(18, 1)
init_i2c_display()
require("rotary-encoder")