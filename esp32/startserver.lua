-- ChiliPeppr - Test your web server
dofile("init-oled.lua")
ws = require("esp32_webserver")
ws.start()
function fuelOn()
  print("turning on fuel")
  -- toggle a GPIO port
end
function fuelOff()
  print("turning off fuel")
  -- toggle a GPIO port
end
ws.registerCallbackOn(fuelOn)
ws.registerCallbackOff(fuelOff)

