-- writen by gdzhang for init oled
function init_i2c_display()
    SDA and SCL can be assigned freely to available GPIOs
    local id  = i2c.HW0
    local sda = 5 --16
    local scl = 4 --17
    local sla = 0x3c
    -- local sla1 = 0x3d
    i2c.setup(id, sda, scl, i2c.FAST)
    disp = u8g2.sh1106_i2c_128x64_noname(id, sla)
    -- disp1 = u8g2.sh1106_i2c_128x64_noname(id, sla1)
end


function u8g2_prepare()

    disp:setFont(u8g2.font_6x10_tf)
    disp:setFontRefHeightExtendedText()
    disp:setDrawColor(1)
    disp:setFontPosTop()
    disp:setFontDirection(0)
    -- disp1:setFont(u8g2.font_6x10_tf)
    -- disp1:setFontRefHeightExtendedText()
    -- disp1:setDisplayRotation(u8g2.R2)
    -- disp1:setDrawColor(1)
    -- disp1:setFontPosTop()
    -- disp1:setFontDirection(0)
end

print("i2c init display")
init_i2c_display()
print("i2c prepare u8g2")
u8g2_prepare()

function draw()
    disp:clearBuffer()
    disp:setFont(u8g2.font_wqy16_t_gb2312)
    disp:setFontPosTop()
    disp:drawUTF8(0, 10, "温度:")
    disp:drawUTF8(0, 42, "湿度:")
    disp:drawUTF8(112, 10, "℃")
    disp:drawUTF8(112, 42, "%")
    disp:setFont(u8g2.font_freedoomr25_tn)
    disp:setFontPosTop()
    disp:drawStr(40,0,Temp)
    disp:drawStr(40,32,Humidity)
    disp:sendBuffer()
    -- disp1:setFont(u8g2.font_wqy16_t_gb2312)
    -- disp1:setFontPosTop()
    -- disp1:drawUTF8(0, 10, "湿度:")
    -- disp1:drawUTF8(112, 10, "%")
    -- disp1:setFont(u8g2.font_freedoomr25_tn)
    -- disp1:setFontPosTop()
    -- disp1:drawStr(40,0,Humidity)
    -- disp1:sendBuffer()
end




