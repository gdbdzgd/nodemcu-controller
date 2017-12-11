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
disp:setFont(u8g2.font_liquid)
disp:setFontRefHeightExtendedText()
disp:setDefaultForegroundColor()
disp:setFontPosTop()

