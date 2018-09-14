
function doupdown(op)
    if op == 0
    then
        cp=cp-1
        curmenu=curmenu[cp]
    end
    if op == 255
    then
        cp=cp+1
        curmenu=curmenu[cp]
    end
    
end

menu={}

val={
text="输出电压",
updown=doupdown,
submenu=gosubmenu,
}
cur={
text="输出电流",
updown=doupdown,
submenu=gosubmenu,
}
deval={
text="初始电压",
updown=doupdown,
submenu=gosubmenu,
}
decur={
text="初始电流",
updown=doupdown,
submenu=gosubmenu,
}
back={
text="返回",
updown=doupdown,
goback=dogoback
}

menu[1]=val
menu[2]=cur
menu[3]=deval
menu[4]=decur
menu[5]=back

for i=1,#menu do
   print(i..menu[i].text)
end

