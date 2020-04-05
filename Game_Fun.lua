SyncF={}


--创建同步变量对象
function SyncF:Create(o,player)
 o = o or {}
 setmetatable(o,self)
 self.__index = self
 o.Time_Real = Game.SyncValue:Create ("Time_Real"..tostring(player.index))
 o.State = Game.SyncValue:Create ("State"..tostring(player.index))
 o.numsb = Game.SyncValue:Create ("numsb"..tostring(player.index))
 return o
end
--初始化同步变量
function SyncF:Initialize()
 self.Time_Real.value = 0                --实时时间
 self.State.value = 1                   --"1Ready"2"going"3"Pause"
 self.numsb.value = ""
end
function SyncF:editState()
	self.State.value = 5
end
--记录处理(按时间)
function Record_Rank(player)
    --2人以上才排序
    if numrecord <2 then return end
	--取个人最快时间
	    for i=1 ,numrecord-1,1 do
		    if Record[i].player == player then
			    if Record[i].Time > Record[numrecord].Time then
			        local s = Record[i]
					Record[i] = Record[numrecord]
					Record[numrecord] = s
				end
				    numrecord = numrecord -1
				break
		    end
		end
	--排序
    for i=1,numrecord-1,1 do
		for k=1,numrecord-i,1 do
	        if  Record[k].Time > Record[k+1].Time then
		      local c = Record[k]
		      Record[k] = Record[k+1]
		      Record[k+1] = c
			end
		end
    end
end
--格式转换 返回时间文本(4节)
function transform_1(n)
     local hours = math.floor(n/3600)
	 local minutes = math.floor(n/60) - hours*60
	 local seconds = math.floor(n) - (hours*3600 + minutes*60)
	 local _,a = math.modf(n)
	 local milliseconds = math.floor(a*100)
	 return string.format("%02d",hours)..'.'..string.format("%02d",minutes)
	 ..'.'..string.format("%02d",seconds)..'.'..string.format("%02d",milliseconds)
end
--格式转换 返回时间文本(2节)
function transform_2(n)
     local minutes = math.floor(n/60)
	 local seconds = math.floor(n - (minutes*60))
	 return string.format("%02d",minutes)..'.'..string.format("%02d",seconds)
end

function Update_Record(player)
    local n = numrecord
	if numrecord > 10 then n=10 end

	print("============================")
	print("||----     排行榜     ----||")
	print("============================")
    for i=1,n,1 do
	    if Record[i].player ~= nil then
	        print("#"..i.."  "..Record[i].player.name)
	        print("  <<"..transform_1(Record[i].Time)..">>   存:"..Record[i].numStorage.."读:"..Record[i].numBack)
		end
    end
	print("============================")
end


----玩家地速获取并处理
function Speed(player)
    local v
    v = math.sqrt(player.velocity.x*player.velocity.x+player.velocity.y*player.velocity.y)
	if  (v *10)% 10>= 5 then
	   v = v + 1
	end
	return math.floor(v)
end
-----------
--范围回点函数
function Extent(x1,y1,z1,x2,y2,z2,x3,y3,z3,player)
    if
	 player.position["x"] <= math.max(x1,x2) and player.position["x"] >= math.min(x1,x2) and
	 player.position["y"] <= math.max(y1,y2) and player.position["y"] >= math.min(y1,y2) and
	 player.position["z"] <= math.max(z1,z2) and player.position["z"] >= math.min(z1,z2)
    then
     player.position = {x=x3,y=y3,z=z3}
	 player.velocity = {x=0,y=0,z=0}
    end
end

--暂停函数
function Pause(player,signal)
    if signal == S_Pause then
	    if  Sync[player.index].State.value == 2 then
		   player.user["time_pause"] = Game.GetTime()
		   player.user["position_pause"].x = player.position.x
		   player.user["position_pause"].y = player.position.y
		   player.user["position_pause"].z = player.position.z
		   Sync[player.index].State.value = 3
	    elseif Sync[player.index].State.value == 3 then
		   player.user["time_start"] = player.user["time_start"] + Game.GetTime() - player.user["time_pause"]
		   if player.user["position_pause"].x == nil then            --没有存点-无效
		       return
	       end
		   player.position = {x = player.user["position_pause"].x,
		   y = player.user["position_pause"].y,
		   z = player.user["position_pause"].z}
		   player.velocity={x=0,y=0,z=0}
		   Sync[player.index].State.value = 2
	    end
    end
end
--存读点函数
function StorePoint(player,signal)
 --存点信号判定
	-- if signal == 5 and Sync[player.index].State.value ~= 3 then
	if signal == 5 then
	 if  not(player.position["x"] == player.user["StoragePointx"][player.user.N_Storage] and   --禁止在同一点存点
	     player.position["y"] == player.user["StoragePointy"][player.user.N_Storage] and
	     player.position["z"] == player.user["StoragePointz"][player.user.N_Storage])
	 then
	     player.user.N_Storage =  player.user.N_Storage + 1
	     player.user["StoragePointx"][player.user.N_Storage] = player.position["x"]
         player.user["StoragePointy"][player.user.N_Storage] = player.position["y"]
		 player.user["StoragePointz"][player.user.N_Storage] = player.position["z"]
		 player.user.numStorage = player.user.numStorage + 1
		 Sync[player.index].numsb.value = "存点:"..string.format("%d",player.user.numStorage).."  读点:"..string.format("%d",player.user.numBack)

	 end
    end
 --回当前点信号判定
	if signal == 6 then
	-- if signal == 6 and Sync[player.index].State.value ~= 3 then
	    if  not(player.position["x"] == player.user["StoragePointx"][player.user.N_Storage] and   --禁止在同一点回点
	        player.position["y"] == player.user["StoragePointy"][player.user.N_Storage] and
	        player.position["z"] == player.user["StoragePointz"][player.user.N_Storage]) and player.user.N_Storage>0
	    then
            player.velocity = {x=0,y=0,z=0}
	        player.position ={
            x = player.user["StoragePointx"][player.user.N_Storage],
	        y = player.user["StoragePointy"][player.user.N_Storage],
	        z = player.user["StoragePointz"][player.user.N_Storage]
	        }
		    player.user.numBack =  player.user.numBack + 1
			Sync[player.index].numsb.value = "存点:"..string.format("%d",player.user.numStorage).."  读点:"..string.format("%d",player.user.numBack)
		end
    end
 --回上一点信号判定
    if signal == 7 and Sync[player.index].State.value ~= 3 then
	 if player.user.N_Storage > 1  then
		 player.user.N_Storage = player.user.N_Storage - 1
		 player.velocity = {x=0,y=0,z=0}
	     player.position ={
         x = player.user["StoragePointx"][player.user.N_Storage],
	     y = player.user["StoragePointy"][player.user.N_Storage],
	     z = player.user["StoragePointz"][player.user.N_Storage]
		 }
		 player.user.numBack =  player.user.numBack + 1
		 Sync[player.index].numsb.value = "存点:"..string.format("%d",player.user.numStorage).."  读点:"..string.format("%d",player.user.numBack)
	 end
    end
end

function changeState()
	Sync[Game.Player.index]:editState()
end
--模型更改
function PlayerModel(player,signal)
 if signal == 4000 then
		player.model = 0
	end
--  if signal == 4001 then
-- 		player.model = 11
-- 	end
--  if signal == 4002 then
-- 		player.model = 12
-- 	end
--  if signal == 4003 then
-- 		player.model = 13
-- 	end
--  if signal == 4004 then
-- 		player.model = 14
-- 	end
--  if signal == 4005 then
-- 		player.model = 15
-- 	end
--  if signal == 4006 then
-- 		player.model = 16
-- 	end
--  if signal == 4007 then
-- 		player.model = 17
-- 	end
--  if signal == 4008 then
-- 		player.model = 18
-- 	end
--  if signal == 4009 then
-- 		player.model = 19
-- 	end
--  if signal == 4010 then
-- 		player.model = 20
-- 	end
--  if signal == 4011 then
-- 		player.model = 21
-- 	end
--  if signal == 4012 then
-- 		player.model = 22
-- 	end
--  if signal == 4013 then
-- 		player.model = 23
-- 	end
--  if signal == 4014 then
-- 		player.model = 24
-- 	end
--  if signal == 4015 then
-- 		player.model = 25
-- 	end
--  if signal == 4016 then
-- 		player.model = 27
-- 	end
--  if signal == 4017 then
-- 		player.model = 28
-- 	end
--  if signal == 4018 then
-- 		player.model = 30
-- 	end
--  if signal == 4019 then
-- 		player.model = 31
-- 	end
--  if signal == 4020 then
-- 		player.model = 32
-- 	end
--  if signal == 4021 then
-- 		player.model = 33
-- 	end
--  if signal == 4022 then
-- 		player.model = 34
-- 	end
--  if signal == 4023 then
-- 		player.model = 35
-- 	end
--  if signal == 4024 then
-- 		player.model = 36
-- 	end
--  if signal == 4025 then
-- 		player.model = 37
-- 	end
--  if signal == 4026 then
-- 		player.model = 38
-- 	end
--  if signal == 4027 then
-- 		player.model = 39
-- 	end
--  if signal == 4028 then
-- 		player.model = 40
-- 	end
--  if signal == 4029 then
-- 		player.model = 41
-- 	end
--  if signal == 4030 then
-- 		player.model = 42
-- 	end
--  if signal == 4031 then
-- 		player.model = 44
-- 	end
--  if signal == 4032 then
-- 		player.model = 45s
-- 	end
--输入GOCT/COTR转换阵营信号
	if signal == 4033 then
		player.team = Game.TEAM.CT
	end
	if signal == 4034 then
		player.team = Game.TEAM.TR
	end
	if signal == 4035 then
		Game.SetTrigger ('watch', true)
		player:Kill()
	end
	if signal == 4036 then
		player:Respawn ()
	end
end
