station_cfg={}
station_cfg.ssid="LEDE"
station_cfg.pwd="rockyrocky"
station_cfg.save=true
wifi.setmode(wifi.STATION)
wifi.sta.config(station_cfg)
-- wifi.sta.connect()
tmr.alarm(1, 1000, 1, function()
  drawn = false
  if wifi.sta.getip() == nil then
    if not drawn then
      disp:firstPage()
      repeat
        drawWatch()	
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
    disp:firstPage()
    repeat
      drawTime(string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))
    until disp:nextPage() == false
  end
end)
