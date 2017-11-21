dofile("oled.lua") 
tmr.alarm(0, 30000, 1, function()
  sntp.sync(nil,nil,nil,1)
end)
tmr.delay(5000)
dofile("connect.lua")
function drawWatch()
--  disp:drawCircle(96, 31, 31)
  disp:drawStr(0, 0, "gdzhang controller")
end
function drawTime(tijd)
  disp:firstPage()
  repeat
    drawWatch()
    disp:setFont(u8g.font_6x10)
    disp:drawStr(0, 25, tijd)
    disp:drawStr(0, 54, wifi.sta.getip())
  until disp:nextPage() == false
end
disp:firstPage()
repeat
  drawWatch()
until disp:nextPage() == false
