max_row=7
function up_down_in(op)
    print(1)
end

menu={}

meta={
text="   主菜单",
action=nil,
len=0,
postion=8,
}

val={
text="输出电压",
action=up_down_in,
submenu=cur_v_set,
m_type=sub_menu
}
cur={
text="输出电流",
action=up_down_in,
submenu=cur_a_set,
m_type=sub_menu
}
deval={
text="初始电压",
updown=up_down_in,
submenu=default_v_set,
m_type=submenu
}
decur={
text="初始电流",
action=up_down_in,
submenu=default_a_set,
m_type=submenu
}
t1={
text="测试菜单1",
action=up_down_in,
submenu=default_a_set,
m_type=submenu
}
t2={
text="测试菜单2",
action=up_down_in,
submenu=default_a_set,
m_type=submenu
}
t3={
text="测试菜单3",
action=up_down_in,
submenu=default_a_set,
m_type=submenu
}
t4={
text="测试菜单4",
action=up_down_in,
submenu=default_a_set,
m_type=submenu
}
t5={
text="测试菜单5",
action=up_down_in,
submenu=default_a_set,
m_type=submenu
}
back={
text="返回",
action=dogoback,
m_type=goback
}


menu[0]=meta
menu[1]=val
menu[2]=cur
menu[3]=deval
menu[4]=decur
menu[5]=t1
menu[6]=t2
menu[7]=t3
menu[8]=t4
menu[9]=t5
menu[10]=back

showmenu=menu
showstart=1
showend=#showmenu
showmenu_len=#showmenu
-- print(showmenu[0].postion)
if max_row < #showmenu then
    showstart=showmenu[0].postion-math.modf(max_row/2)
    showend=showmenu[0].postion+math.modf(max_row/2)
end
print("start:"..showstart.."end:"..showend)
print(showmenu[0].text)
for i=showstart,showend do
    if i < 0 then 
        print(showmenu_len+(i).."."..showmenu[showmenu_len+i].text)
    elseif i > showmenu_len then
        print(i - showmenu_len .."."..showmenu[i-showmenu_len].text)
    else
        print(i.."."..showmenu[i].text)
    end
end

