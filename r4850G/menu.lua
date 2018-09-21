max_row=8
DEBUG=true
UP=1
DOWN=2
IN=3
function up_down_in(sm,op)
    tmenu=sm
    if op == IN then
        sm=sm[sm[0].postion].submenu
        if DEBUG then
            print("sm[0].text"..sm[0].text)
        end
        return 
    end
    if DEBUG then
        print("postion_before:"..sm[0].postion)
    end
    if op == UP then 
        sm[0].postion=sm[0].postion+1
    elseif op == DOWN then
        sm[0].postion=sm[0].postion-1
    end

    if sm[0].postion < 1 then sm[0].postion = 1 end
    if sm[0].postion > #sm then sm[0].postion = #sm-1 end
    if DEBUG then
        print("postion_after:"..sm[0].postion)
    end
end
function goback(sm,op)
    
    up_down_in(sm,op)
    print("goback")
end


menu={}

meta={
text="  主菜单",
action=nil,
len=0,
postion=8
}
cur_v_set_meta={
text="输出电压V",
action=nil,
len=1,
postion=1
}
cur_v_set={
text="00.00"
}
cur_v={}
cur_v[0]=cur_v_set_meta
cur_v[1]=cur_v_set
val={
text="输出电压",
action=up_down_in,
submenu=cur_v,
m_type=sub_menu,
uplevel=menu
}
cur={
text="输出电流",
action=up_down_in,
submenu=cur_a_set,
m_type=sub_menu,
uplevel=menu
}
deval={
text="初始电压",
action=up_down_in,
submenu=default_v_set,
m_type=sub_menu,
uplevel=menu
}
decur={
text="初始电流",
action=up_down_in,
submenu=default_a_set,
m_type=sub_menu,
uplevel=menu
}
t1={
text="测试菜单1",
action=up_down_in,
submenu=default_a_set,
m_type=sub_menu,
uplevel=menu
}
t2={
text="测试菜单2",
action=up_down_in,
submenu=default_a_set,
m_type=sub_menu,
uplevel=menu
}
t3={
text="测试菜单3",
action=up_down_in,
submenu=default_a_set,
m_type=sub_menu,
uplevel=menu
}
t4={
text="测试菜单4",
action=up_down_in,
submenu=default_a_set,
m_type=sub_menu,
uplevel=menu
}
t5={
text="测试菜单5",
action=up_down_in,
submenu=default_a_set,
m_type=sub_menu,
uplevel=menu
}
back={
text="返回",
action=goback,
m_type=goback,
uplevel=menu
}


menu[0]=meta
menu[1]=val
val.uplevel=menu
menu[2]=cur
cur.uplevel=menu
menu[3]=deval
deval.uplevel=menu
menu[4]=decur
decur.uplevel=menu
menu[5]=t1
t1.uplevel=menu
menu[6]=t2
t2.uplevel=menu
menu[7]=t3
t3.uplevel=menu
menu[8]=t4
t4.uplevel=menu
menu[9]=t5
t5.uplevel=menu
menu[10]=back
back.uplevel=menu
sm=menu
