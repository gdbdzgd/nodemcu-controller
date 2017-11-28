sda = 3
scl = 4
-- sla = 0x3d sh1106
-- ssd1306
sla = 0x3c

i2c.setup(0, sda, scl, i2c.SLOW)
disp = u8g.ssd1306_128x64_i2c(sla)

--disp:setFont(u8g.font_orgv01n)
-- disp:setFont(u8g.font_freedoomr25n)
disp:setFont(u8g.font_liquid)
disp:setFontRefHeightExtendedText()
disp:setDefaultForegroundColor()
disp:setFontPosTop()

