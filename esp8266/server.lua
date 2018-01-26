  -- use touch_pin 1 as the input pulse width counter
  local touch_pin, pulse1, du, now, trig = 1, 0, 0, tmr.now, gpio.trig
  relay_pin=6
  touch_pin=5
  gpio.mode(touch_pin,gpio.INT)
  gpio.mode(relay_pin,gpio.OUTPUT)

  local function touch_pin1cb(level, pulse2)
    print( level, pulse2 - pulse1 )
    pulse1 = pulse2
    trig(touch_pin, level == gpio.HIGH  and  "up")
    print("relay_pin:"..touch_pin..":"..relay_pin..":"..gpio.read(relay_pin))
    if (gpio.read(relay_pin) == gpio.LOW) then 
        
        gpio.write(relay_pin,gpio.HIGH)
    elseif  (gpio.read(relay_pin) == gpio.HIGH) then
        gpio.write(relay_pin,gpio.LOW)

    end
  end
  trig(touch_pin, "high", touch_pin1cb)


print(wifi.sta.getip())
--nil
station_cfg={}
station_cfg.ssid="linxdots"
station_cfg.pwd="dotswifi"
wifi.setmode(wifi.STATION)
wifi.sta.config(station_cfg)
print(wifi.sta.getip())
--192.168.18.110
print('\nAll About Circuits main.lua\n')
tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() == nil then
      print("Connecting to AP...\n")
   else
      ip, nm, gw=wifi.sta.getip()
      print("IP Info: \nIP Address: ",ip)
      print("Netmask: ",nm)
      print("Gateway Addr: ",gw,'\n')
      tmr.stop(0)
   end
end)

-- gpio.write(0,gpio.HIGH)
-- tmr.delay(1000000)
-- gpio.write(0,gpio.LOW)
-- tmr.delay(1000000)
-- Connect 
-- Start a simple http server
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
  conn:on("receive",function(conn,data)
    print(data)
    if string.find(data, '^on') then
      gpio.write(relay_pin,gpio.HIGH)
      print("open the Gas fireplaces")
      conn:send("on\n")
    elseif string.find(data, '^off') then
      gpio.write(relay_pin,gpio.LOW)
      print("colse the Gas fireplaces")
      conn:send("off\n")
    elseif string.find(data, '^status') then
      stat=gpio.read(relay_pin)
      print("status"..relay_pin..":"..stat)
      if stat == 1 then
        conn:send("on\n")
      else
        conn:send("off\n")
      end
    else
      conn:close()
    end
  end)
  conn:on("sent",function(conn) conn:close() end)
end)
