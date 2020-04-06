if Switch_Timer == 1 then
    button1 = Game.EntityBlock.Create({x=button1[1], y=button1[2], z=button1[3]})    --开始按钮坐标
	button2 = Game.EntityBlock.Create({x=button2[1], y=button2[2], z=button2[3]})   --结束按钮坐标
	button3 = Game.EntityBlock.Create({x=button3[1], y=button3[2], z=button3[3]})    --作者通道开启飞天滑翔按钮坐标
    button4 = Game.EntityBlock.Create({x=button4[1], y=button4[2], z=button4[3]})    --作者通道结束飞天滑翔按钮坐标
end

Time_Win = Game.SyncValue:Create ("Time_Win") --公用同步值
TimeCount = Game.SyncValue:Create("TimeCount")
--初始化
Game.Rule.enemyfire	= false
Game.Rule.friendlyfire = false
-----
----
Sync = {}
----
numrecord = 0                 --记录数
Record = {}                 --服务器记录 --Time/player/numStorage/numBack
-----
S_Update  = 969               --每帧信号
S_Pause = 737            --暂停信号
S_Space = 887
S_Shift = 732
S_0 = 211



---管理员名单
administrator = {"bbb","aaa","管理员3"}
---黑名单
blacklist = {"1","2","3"}
--将管理员名字填入上表，可无限添加
-----------
S_id =  8821
S_f1 =  8822
S_f2 =  8823
S_stopA  =  1000000
S_coin =  1001000
S_fly =  1001000
S_give = 1002000
S_take = 1003000
S_to = 1004000
S_get = 1005000
S_kill = 1006000
S_rp  = 1007000
---
Identity = {}
players = {}
for i = 1, 32 do
	players[i] = nil
end
---
stopA = Game.SyncValue:Create ("stopA")


----------------------------------------------
--信号接收
function Game.Rule:OnPlayerSignal(player, signal)
	--每帧信号判定
	if signal == S_Update then
		--锁血
		if Switch_Lcokhealth == 1 then
			if player.health < 1000 then
				player.health = 9999
			end
		end
		--同步动态时间
		if Switch_Timer == 1 then
			if Sync[player.index].State.value == 2 and Game.GetTime() - player.user["time_dy"] >=1 then
				Sync[player.index].Time_Real.value = Game.GetTime() - player.user["time_start"]
				player.user["time_dy"] = Game.GetTime()
			end
		end
		--地速更新
		if Switch_Speed == 1 then
			player.maxarmor = 0
			player.armor = Speed(player)
			player.armor =0
		end
		--范围回点
		if Switch_Extent == 1 then
			Con_Extent(player)
		end
	end
	--暂停信号判定
	--  if Switch_Pause == 1 then
	--        Pause(player,signal)
	--  end
	--存读点
	if Switch_StorePoint == 1 then
		StorePoint(player,signal)
	end
--返回起点信号判定
	if Switch_Back == 1 then
		if signal == S_0 then
			player.position = Back
			player.velocity = {x=-8,y=76,z=0}
		end
	end
--Space飞天
   if signal == S_Space then
       player.velocity={z=400}
   end
--Shift滑翔
   if signal == S_Shift then
       player.velocity={z=-50}
   end
--模型更改
 if Switch_Model == 1 then
	PlayerModel(player,signal)
 end
	AdminSignal(player,signal)
end

--开始按钮
if Switch_Timer == 1 then
	function button1:OnUse(player)
		Game.SetTrigger ('beginTimer', true)
		print("it work1")
		TimeCount.value = 0
		Sync[player.index].State.value = 2
		player.user["time_start"] = Game.GetTime()
		player.user.N_Storage = 0                                         --存点数
		player.user.numStorage = 0
		player.user.numBack    = 0                                         --读点数
		Sync[player.index].numsb.value = "存点:"..string.format("%d",player.user.numStorage).."  读点:"..string.format("%d",player.user.numBack)
	end
	--结束按钮
	function button2:OnUse(player)
		Game.SetTrigger ('GameSuccess', true)
		if Sync[player.index].State.value == 2 then               --going状态
			print("it work2")
			numrecord = numrecord + 1
			Record[numrecord] = {}
			Record[numrecord].Time = Game.GetTime() -player.user["time_start"]
			Record[numrecord].player = player
			Record[numrecord].numStorage = player.user.numStorage
			Record[numrecord].numBack = player.user.numBack
			print("||恭喜通关成功！||")
			print("||"..player.name..">>||")
			print("||耗时 "..transform_1(Record[numrecord].Time).."||存"..player.user.numStorage.."读:"..player.user.numBack)
			Time_Win.value = Record[numrecord].Time
			Record_Rank(player)
			Update_Record(player)
			Sync[player.index].State.value = 3
		end
	end
	function button3:OnUse(player)
		Sync[player.index].State.value = 5
	end
	function button4:OnUse(player)
		if Sync[player.index].State.value == 5 then
			Sync[player.index].State.value = 1
		end
	end
end
--玩家连接
function  Game.Rule:OnPlayerConnect (player)
	Game.SetTrigger ('beginGame', true)
	--玩家载入
	players[player.index] = player
	--身份确认
	for k,v in ipairs(administrator) do
		if string.find(v,player.name) and #v == #player.name then
			player.user.permission = "admin"
			break
		end
	end
	for k,v in ipairs(blacklist) do
		if string.find(v,player.name) and #v == #player.name then
			player.user.permission = "ban"
			break
		end
	end
	if player.user.permission==nil then
		player.user.permission="normal"
	end
	--同步值创建
	Identity[player.index] = Game.SyncValue:Create ("p"..tostring(player.index))
	Identity[player.index].value = player.user.permission

    if numrecord ~= 0 then
       Update_Record()
	end
	print("it work0")
	Sync[player.index] = SyncF:Create(nil,player)
	Sync[player.index]:Initialize()
	player.user["time_dy"] = 0                                        --动态计时同步间隔
	player.user["time_start"] = 0                                        --玩家开始时间
	player.user["num_record"] = 0                                        --玩家已载入记录数
	player.user["Time_Record"] = 0                                     --间隔同步时间
	player.user["time_pause"] = 0                                      --暂停时刻
	player.user["position_pause"] = {}                                  --暂停点
	player.user.StoragePointx = {}
	player.user.StoragePointy = {}
	player.user.StoragePointz = {}
	player.user.N_Storage = 0
	player.user.numStorage = 0                --存点数
	player.user.numBack = 0                --读点数
end


--玩家退出
function Game.Rule:OnPlayerDisconnect (player)
	Game.SetTrigger ('endGame', true)
	Sync[player.index]:Initialize()
	players[player.index] = nil
end
--持续事件
function Game.Rule:OnUpdate (time)
	-- 以下为判断每450秒播放一次广播
	if TimeCount.value == 0 then
		TimeCount.value = time
	end
	if TimeCount.value~=nil and time-TimeCount.value >= 450 then
		Game.SetTrigger ('forverSay', true)
		TimeCount.value = time
		print("it work3")
	end
end
--玩家复活
function Game.Rule:OnPlayerSpawn (player)
	if Switch_Knife == 1 then
      player.model = 13
      player.model = 0
	end
	if  player.user.permission=="ban" then
		player:Kill()
		player.user.alive=false
	end
	StorePoint(player,6)
end

function Game.Rule:PostFireWeapon (player,weapon,time)
	function Weaponaddclip ()
		weapon:AddClip1(1)
	end
	pcall(Weaponaddclip)
end
function Game.Rule:OnGetWeapon (player,weaponid,weapon) 
	if weapon==nil then return end
	weapon.infiniteclip=true
end

function GetIndex()
    for i,p in pairs(players) do
        if p ~= nil then
		    print(string.format("%-5s",p.index) .. p.name)
		end
	end
end

function AdminSignal(player,signal)
	--获取index
		if signal == S_id then
			GetIndex()
		end
	--禁止移动
		if signal > S_stopA and signal < S_coin then
			stopA.value = signal - S_stopA
		end
	--发放金币1000/飞
		if signal == S_fly then
			-- local p = Game.Player:Create (signal - S_coin)
			-- if p~= nil then
			-- 	if players[p.index] ~= nil then
			-- 	   p.coin = p.coin + 1000
			-- 	end
			-- end
			if Sync[player.index].State.value == 5 then
				Sync[player.index].State.value = 1
				print('已关闭飞天滑翔')
			else
				Sync[player.index].State.value = 5
				print('已开启飞天滑翔')
			end
		end
	--发放武器
		if signal > S_give and signal < S_take then
				local p = Game.Player:Create (signal - S_give)
				if p~= nil then
					if players[p.index] ~= nil then
					   p:ShowBuymenu ()
					end
				end
		end
	--没收武器
		if signal > S_take and signal < S_to then
			local p = Game.Player:Create (signal - S_take)
			if p~= nil then
				if players[p.index] ~= nil then
					p:RemoveWeapon ()
				end
			end
		end
	--传送至玩家头顶
		if signal > S_to and signal < S_get then
			local p = Game.Player:Create (signal - S_to)
			if p~= nil then
				if players[p.index] ~= nil then
					player.position = {x=p.position.x,y=p.position.y,z=p.position.z+3}
				end
			end
		end
	--拉回玩家
		if signal > S_get and signal < S_kill then
			local p = Game.Player:Create (signal - S_get)
			if p~= nil then
				if players[p.index] ~= nil then
					p.position = {x=player.position.x,y=player.position.y,z=player.position.z+3}
				end
			end
		end
	--开启友伤
		if signal == S_f1 then
			Game.Rule.friendlyfire = not(Game.Rule.friendlyfire)
			if Game.Rule.friendlyfire == true then
				print("管理员开启了友军伤害")
			else
				print("管理员关闭了友军伤害")
			end
		end
	--开启敌伤
		if signal == S_f2 then
			Game.Rule.enemyfire= not(Game.Rule.enemyfire)
			if Game.Rule.enemyfire == true then
				print("管理员开启了敌军伤害")
			else
				print("管理员关闭了敌军伤害")
			end
		end
	--处死玩家
		if signal > S_kill and signal < S_rp then
			local p = Game.Player:Create (signal - S_kill)
			if p~= nil then
				if players[p.index] ~= nil then
					p:Kill()
					player.user.alive=false
				end
			end
		end
	--复活玩家
		if signal > S_rp then
			local p = Game.Player:Create (signal - S_rp)
			if p~= nil then
				if players[p.index] ~= nil then
					p:Respawn ()
				end
			end
		end
	end
	