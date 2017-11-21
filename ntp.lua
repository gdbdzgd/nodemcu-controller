return({
	lastsync=0,
	ustamp=0,
	tz=1,
	udptimer=2,
	udptimeout=1000,
	ntpserver="194.109.22.18",
	sk=nil,
	sync=function(self,callback)
                sntp.sync(nil, nil, nil, 1)
	end,
	show_time=function(self)
                tm = rtctime.epoch2cal(rtctime.get()+28800)
                -- print(string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))
                return(string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))
	end,
	run=function(self,t,uinterval,sinterval,server)
	--	if server then self.ntpserver = server end
		self.lastsync = sinterval * 2 * -1	-- force sync on first run
		tmr.alarm(t,uinterval * 1000,1,function()
			self.ustamp = self.ustamp + uinterval
			self:set_time()
			if self.lastsync + sinterval < self.ustamp then
				self:sync()
			end
		end)
	end
})
