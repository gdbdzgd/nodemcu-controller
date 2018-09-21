require("menu")
require("rotary-encoder")

function init_i2c_display()
    --    SDA and SCL can be assigned freely to available GPIOs
    local id  = i2c.HW0
    local sda = 17 --16
    local scl = 16 --17
    local sla = 0x3c
    i2c.setup(id, sda, scl, i2c.FAST)
    disp = u8g2.sh1106_i2c_128x64_noname(id, sla)
end
function u8g2_prepare()
    --disp:setFont(u8g2.font_6x10_tf)
    disp:setFont(u8g2.font_wqy12_t_gb2312b)
    disp:setFontRefHeightExtendedText()
    disp:setFontMode(0)
    disp:setDrawColor(1)
    disp:setFontPosTop()
    disp:setFontDirection(0)
end

offset=14
function draw()
    disp:clearBuffer()
    disp:setFont(u8g2.font_wqy12_t_gb2312b)
    disp:setDisplayRotation(u8g2.R3);
    disp:setFontPosTop()

    showstart=1
    sm_len=#sm
    if DEBUG then 
        print("sm[0].text"..sm[0].text)
        print("postion:"..sm[0].postion)
        print("start:  "..showstart)
        print("end:    "..sm_len)
    end
    if max_row < #sm then
        page=math.ceil(sm[0].postion/max_row)
        showstart=(page*max_row)
    end
    if DEBUG then 
        print("postion:"..sm[0].postion)
        print("showstart:  "..showstart)
        print("showend:    "..sm_len)
        print("page:    "..page)
    end
    print(sm[0].text)
    disp:drawUTF8(1, 1+offset, sm[0].text)
    offset=offset+14
    ioff=showstart
    for i=1,max_row do
        index=i+(page-1)*max_row
        if index > sm_len then break end
        if index == sm[0].postion then 
            disp.drawBox(disp,0,1+offset,64,14);
            disp:setFontMode(0)
            disp:setDrawColor(0)
            --print("●")
        end

        disp:drawUTF8(1, 1+offset, index .."."..sm[index].text)
        if index == sm[0].postion then
            print("●"..index.."."..sm[index].text)
        else
            print(index.."."..sm[index].text)
        end
        disp:setFontMode(0)
        disp:setDrawColor(1)
        offset=offset+14
    end
    offset=0

    disp:setFontPosTop()
    -- disp:drawStr(35,0,Temp)
    -- disp:drawStr(35,25,STemp)
    disp:sendBuffer()
end
gpio.write(18, 1)
gpio.write(18, 0)

osec,ousec=rtctime.get()
sec,usec=rtctime.get()
while math.abs(usec-ousec)< 200000 do

    sec,usec=rtctime.get()
end
gpio.write(18, 1)
init_i2c_display()

