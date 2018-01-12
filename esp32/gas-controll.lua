serverip="192.168.11.254"
serverip="172.16.3.108"
function set_gas_on()
srv = net.createConnection(net.TCP, 0)
srv:on("receive", function(sck, c) print(c) end)
srv:on("connection", function(sck, c)
sck:send("on")
end)
srv:connect(80,serverip)
end
function set_gas_off()
srv = net.createConnection(net.TCP, 0)
srv:on("receive", function(sck, c) print(c) end)
srv:on("connection", function(sck, c)
sck:send("off")
end)
srv:connect(80,serverip)
end
function get_gas_status()
srv = net.createConnection(net.TCP, 0)
srv:on("receive", function(sck, c) print(c) end)
srv:on("connection", function(sck, c)
sck:send("status")
end)
srv:connect(80,serverip)
end
