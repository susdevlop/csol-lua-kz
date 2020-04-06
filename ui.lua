--界面创建
UI_Timer:Create()
UI_Win:Create()
UI_Fill:Create()
UI_Timer:Hide()
UI_Win:Hide()
UI_Fill:Hide()


----------------------------
Sync = SyncF:Create(nil)
---------------

--初始化
S_Update  = 969               --每帧信号
S_Pause = 737                 --暂停信号
S_Space = 887
S_Shift = 732
S_0 = 211
----
top = {}                              --排行榜表
---
Time_Win = UI.SyncValue:Create ("Time_Win") --公用同步值
---
time_9 = 0
time_0 = 0
time_5 = 0
time_6 = 0
time_7 = 0


--管理员
Identity = UI.SyncValue:Create ("p"..tostring(UI.PlayerIndex (index)))
stopA = UI.SyncValue:Create ("stopA")
stoponoff = false

S_id =  8821
S_f1 =  8822
S_f2 =  8823
S_stopA  =  1000000
-- S_coin =  1001000
S_fly =  1001000
S_give = 1002000
S_take = 1003000
S_to = 1004000
S_get = 1005000
S_kill = 1006000
S_rp  = 1007000
--管理员





----
----
--文字信号
function UI.Event:OnChat(msg)
	--模型更改
	Send_model(msg)
	--帮助菜单
	if string.find(msg, "help") and #msg == #"help" then
       Menu_Hlep.Show()
	end
	--管理员操作
	if Identity.value == "admin" then
		AdminOrder(msg)
	end
end
--按键信号
function UI.Event:OnInput(inputs)
	if inputs[UI.KEY.W] == true then
		up:show()
		up:print()
	end
	if inputs[UI.KEY.S] == true then
		down:show()
		down:print()
	end
	if inputs[UI.KEY.A] == true then
		left:show()
		left:print()
	end
	if inputs[UI.KEY.D] == true then
		right:show()
		right:print()
	end
--9键暂停
    -- if inputs[UI.KEY.NUM9] == true then
	--     if UI.GetTime()-time_9 >0.05 then
	--         UI.Signal(S_Pause)
	-- 	end
	-- 	time_9 = UI.GetTime()
	-- end
--0键回起点
    if inputs[UI.KEY.NUM0] == true then
	    if UI.GetTime()-time_0 >0.05 then
	        UI.Signal(S_0)
		end
		time_0 = UI.GetTime()
	end
--5存点
    if inputs[UI.KEY.NUM5] == true  then
		if UI.GetTime()-time_5 >= 0.05 then
	        UI.Signal(5)
	    end
		time_5 = UI.GetTime()
    end
--6回当前点
    if inputs[UI.KEY.NUM6] == true  then
		if UI.GetTime()-time_6 >= 0.05 then
	        UI.Signal(6)
	    end
		time_6 = UI.GetTime()
    end
--7回上一点
    if inputs[UI.KEY.NUM7] == true  then
		if UI.GetTime()-time_7 >= 0.05 then
	        UI.Signal(7)
	    end
		time_7 = UI.GetTime()
    end
--空格飞天
    if inputs[UI.KEY.SPACE] == true and Sync.State.value == 3  then
        UI.Signal(S_Space)
    end
--shift滑翔
    if inputs[UI.KEY.SHIFT] == true and Sync.State.value == 3  then
        UI.Signal(S_Shift)
	end
-- 作者通道的空格飞天和滑翔
	if inputs[UI.KEY.SPACE] == true and Sync.State.value == 5  then
        UI.Signal(S_Space)
    end
    if inputs[UI.KEY.SHIFT] == true and Sync.State.value == 5  then
        UI.Signal(S_Shift)
    end
end




-------------------------------------------------------------------------------

---------------------------------------------
--同步事件
function Sync.Time_Real:OnSync()
	UI_Timer:Update()
end
function Time_Win:OnSync()
	UI_Win:Update()
end
function Sync.State:OnSync()
    if Sync.State.value == 3 then
        UI_Fill:Show()
    else
        UI_Fill:Hide()
    end
	if Sync.State.value == 2 then
	    UI_Timer:Show()
	end
end
function Sync.numsb:OnSync()
	print(Sync.numsb.value)
end
-------------------每帧事件
function UI.Event:OnUpdate (time)
 	UI.Signal(S_Update)
	up:hide()
	down:hide()
	left:hide()
	right:hide()
 --公示时间
    if Time_Win_Show ~= nil then
       if UI.GetTime() - Time_Win_Show > 5 then
         UI_Win:Hide()
       end
    end
end
--复活事件
function UI.Event:OnSpawn ()
	UI_Win:Hide()
end




--同步事件
function stopA:OnSync()
	if stopA.value == UI.PlayerIndex (index) then
        if stoponoff == false then
	        UI.StopPlayerControl (true)
		    stoponoff = true
	    else
	        UI.StopPlayerControl (false)
		    stoponoff = false
		end
    end
end

--复活事件
function UI.Event:OnSpawn ()
    stoponoff = false
end


function admin_help()
   print("============================")
   print("||----    管理员命令    ----||")
   print("============================")
   print("1. 输入#id   查看玩家id")
   print("2. 输入#stop id 禁止移动")
   print("3. 输入#kill id 处死玩家")
   print("4. 输入#rp   id 复活玩家")
   print("5. 输入#to   id 传送")
   print("6. 输入#get  id 拉回")
   print("7. 输入#give id 发放武器")
   print("8. 输入#take id 没收武器")
   print("9. 输入#f1      开/关友伤")
   print("10.输入#f2      开/关敌伤")
   print("11.输入#fly开/关飞天滑翔")
   print ("==========================")
end



function AdminOrder(msg)
--获取管理员菜单
	if string.find(msg, "#_help") and #msg == #"#_help" then
	    admin_help()
	end
--获取全房玩家index
	if string.find(msg, "#id") and #msg == #"#id" then
	    UI.Signal(S_id)
	end
--开启友伤
	if string.find(msg, "#f1") and #msg == #"#f1" then
	    UI.Signal(S_f1)
	end
--开启敌伤
	if string.find(msg, "#f2") and #msg == #"#f2" then
	    UI.Signal(S_f2)
	end
--令一名玩家不能攻击移动
	if string.find(msg, "#stop ") then
	    if type(tonumber(string.sub(msg,6,-1))) == "number" then
	        UI.Signal(S_stopA+tonumber(string.sub(msg,6,-1)))
		end
	end
--发放金币
	-- if string.find(msg, "#coin ") then
	--     if type(tonumber(string.sub(msg,7,-1))) == "number" then
	--         UI.Signal(S_coin+tonumber(string.sub(msg,7,-1)))
	-- 	end
	-- end
	--管理员开启飞天滑翔
	if string.find(msg, "#fly") then
		UI.Signal(S_fly)
	end
--给予一名玩家武器
	if string.find(msg, "#give ") then
	    if type(tonumber(string.sub(msg,7,-1))) == "number" then
	        UI.Signal(S_give+tonumber(string.sub(msg,7,-1)))
		end
	end
--没收一名玩家武器
	if string.find(msg, "#take ") then
	    if type(tonumber(string.sub(msg,7,-1))) == "number" then
	        UI.Signal(S_take+tonumber(string.sub(msg,7,-1)))
		end
	end
--传送至一名玩家头顶
	if string.find(msg, "#to ") then
	    if type(tonumber(string.sub(msg,5,-1))) == "number" then
	        UI.Signal(S_to+tonumber(string.sub(msg,5,-1)))
		end
	end
--拉回一名玩家
	if string.find(msg, "#get ") then
	    if type(tonumber(string.sub(msg,6,-1))) == "number" then
	        UI.Signal(S_get+tonumber(string.sub(msg,6,-1)))
		end
	end
--处死一名玩家
	if string.find(msg, "#kill ") then
	    if type(tonumber(string.sub(msg,7,-1))) == "number" then
	        UI.Signal(S_kill+tonumber(string.sub(msg,7,-1)))
		end
	end
--复活一名玩家
	if string.find(msg, "#rp ") then
	    if type(tonumber(string.sub(msg,5,-1))) == "number" then
	        UI.Signal(S_rp+tonumber(string.sub(msg,5,-1)))
		end
	end
end




-- lua 实现的print一个表
function print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end