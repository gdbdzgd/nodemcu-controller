print(wifi.sta.getip())
--nil
station_cfg={}
station_cfg.ssid="LEDE"
station_cfg.pwd="rockyrocky"
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
pin=0
gpio.mode(0,gpio.OUTPUT)
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
      gpio.write(pin,gpio.HIGH)
      print("open the Gas fireplaces")
      conn:send('on')
    elseif string.find(data, '^off') then
      gpio.write(pin,gpio.LOW)
      print("colse the Gas fireplaces")
      conn:send('off')
    elseif string.find(data, '^status') then
      stat=gpio.read(pin)
      print("status"..pin..":"..stat)
      if stat == 1 then
        conn:send('on')
      else
        conn:send('off')
      end
    else
      conn:close()
    end
  end)
  conn:on("sent",function(conn) conn:close() end)
end)

