sda = 3
scl = 4
-- ssd1306
sla = 0x3c
-- sh1106
sla = 0x3c

i2c.setup(0, sda, scl, i2c.SLOW)
disp = u8g.sh1106_128x64_i2c(sla)

disp:setFont(u8g.font_6x10)
disp:setFontRefHeightExtendedText()
disp:setDefaultForegroundColor()
disp:setFontPosTop()

