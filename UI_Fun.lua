--获取分辨率
GameSize = UI.ScreenSize()


--创建同步变量
SyncF={}
function SyncF:Create(o)
 o = o or {}
 setmetatable(o,self)
 self.__index = self
 self.Time_Real = UI.SyncValue:Create ("Time_Real"..tostring(UI.PlayerIndex (index)))
 self.State = UI.SyncValue:Create ("State"..tostring(UI.PlayerIndex (index)))
 self.numsb = UI.SyncValue:Create ("numsb"..tostring(UI.PlayerIndex (index)))
 return o
end
--------------------------------------UI界面---------
---------创建UI界面
UI_Timer = {}          --计时器
UI_Win = {}            --胜利公示文本
UI_Fill = {}
UI_Speed = {}
--
-----------------------------------------计时器界面
--创建
function UI_Timer:Create()
self.Box = UI.Box.Create()
self.Text = UI.Text.Create()
self.Text:Set({text = transform_2(0),font = 'medium',align = 'center',
x = GameSize.width/2 - 150,y = 8,width = 300,height = 40,r = 248,g = 230,b = 255,a = 200})
self.Box:Set({x = GameSize.width/2 - 50,y = 0,
width = 100,height = 32,r = 160,g = 82,b = 45,a = 80})
end
--隐藏计时器
function UI_Timer:Hide()
self.Box:Hide()
self.Text:Hide()
self.onoff = false
end
--显示计时器
function UI_Timer:Show()
self.Box:Show()
self.Text:Show()
self.onoff = true
end
--计时器更新
function UI_Timer:Update()
   self.Text:Set({text = transform_2(Sync.Time_Real.value)})
end
-----------------------------------------------
--------------------------------公示文本
function UI_Win:Create()
self.Text = UI.Text.Create()
self.Text:Set({text = "",font = 'large',align = 'center',
x = GameSize.width/2 - 300,y = 100	,
width = 600,height = 50,r = 255,g = 215,b = 0,a = 150})
end
--隐藏公示
function UI_Win:Hide()
 self.Text:Hide()
 self.onoff = false
end
--显示公示
function UI_Win:Show()
 self.Text:Show()
 self.onoff = true
end
--公示更新
function UI_Win:Update()
    Time_Win_Show = UI.GetTime()
    self.Text:Set({text=transform_1(Time_Win.value)})
    self:Show()
end
------------------------------------
-----------------------------全屏填充
function UI_Fill:Create()
   self.Box = UI.Box.Create()
   self.Box:Set({x = 1,y = 1,
   width = GameSize.width,height = GameSize.height,r = 0,g = 0,b = 0,a = 0})
end
--隐藏全屏填充
function UI_Fill:Hide()
 self.Box:Hide()
 self.onoff = false
end
--显示全屏填充
function UI_Fill:Show()
 self.Box:Show()
 self.onoff = true
end
-------------------------------------------
---------------------------------
--显示帮助菜单
Menu_Hlep={} 
function Menu_Hlep.Show()             --注：控制台每句只能输出10个汉字
   print("============================")
   print("||----     帮 助     ----||")
   print("============================")
   print("1. 按<0> 回到起点")
   print("2. 按<5> 存点")
   print("3. 按<6> 回点")
   print("4. 按<7> 回前一点")
   print("5.发送GOCT/GOTR切换阵型")
   print(" 观战功能处于测试阶段")
   print(" 观战功能慎用,可能会导")
   print(" 无法复活 或 复活存点")
   print(" 丢失或武器丢失等问题")
   print("7.发送watch观战")
   print("8.发送respawn复活")
   print("控制台可查看排行榜")
   print("控制台可查看存读点数")
   print ("===========================")
end

----------------






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

--模型更改信号发送
function Send_model(msg)
   if string.find(msg, "初始人物") then
      UI.Signal(4000)
   end
   -- if string.find(msg, "男英雄") then
   --    UI.Signal(4001)
   -- end
   -- if string.find(msg, "女英雄") then
   --    UI.Signal(4002)
   -- end
   -- if string.find(msg, "次级普通僵尸") then
   --    UI.Signal(4003)
   -- end
   -- if string.find(msg, "次级暗影芭比") then
   --    UI.Signal(4004)
   -- end
   -- if string.find(msg, "次级憎恶屠夫") then
   --    UI.Signal(4005)
   -- end
   -- if string.find(msg, "次级迷雾鬼影") then
   --    UI.Signal(4006)
   -- end
   -- if string.find(msg, "次级巫蛊术尸") then
   --    UI.Signal(4007)
   -- end
   -- if string.find(msg, "次级恶魔之子") then
   --    UI.Signal(4008)
   -- end
   -- if string.find(msg, "次级恶魔猎手") then
   --    UI.Signal(4009)
   -- end
   -- if string.find(msg, "次级送葬者") then
   --    UI.Signal(4010)
   -- end
   -- if string.find(msg, "次级嗜血女妖") then
   --    UI.Signal(4011)
   -- end
   -- if string.find(msg, "次级追猎傀儡") then
   --    UI.Signal(4012)
   -- end
   -- if string.find(msg, "次级痛苦女王") then
   --    UI.Signal(4013)
   -- end
   -- if string.find(msg, "次级暴虐钢骨") then
   --    UI.Signal(4014)
   -- end
   -- if string.find(msg, "次级幻痛夜魔") then
   --    UI.Signal(4015)
   -- end
   -- if string.find(msg, "次级爆弹狂魔") then
   --    UI.Signal(4016)
   -- end
   -- if string.find(msg, "次级断翼恶灵") then
   --    UI.Signal(4017)
   -- end
   -- if string.find(msg, "母体普通僵尸") then
   --    UI.Signal(4018)
   -- end
   -- if string.find(msg, "母体暗影芭比") then
   --    UI.Signal(4019)
   -- end
   -- if string.find(msg, "母体憎恶屠夫") then
   --    UI.Signal(4020)
   -- end
   -- if string.find(msg, "母体迷雾鬼影") then
   --    UI.Signal(4021)
   -- end
   -- if string.find(msg, "母体巫蛊术尸") then
   --    UI.Signal(4022)
   -- end
   -- if string.find(msg, "母体恶魔之子") then
   --    UI.Signal(4023)
   -- end
   -- if string.find(msg, "母体恶魔猎手") then
   --    UI.Signal(4024)
   -- end
   -- if string.find(msg, "母体送葬者") then
   --    UI.Signal(4025)
   -- end
   -- if string.find(msg, "母体嗜血女妖") then
   --    UI.Signal(4026)
   -- end
   -- if string.find(msg, "母体追猎傀儡") then
   --    UI.Signal(4027)
   -- end
   -- if string.find(msg, "母体痛苦女王") then
   --    UI.Signal(4028)
   -- end
   -- if string.find(msg, "母体暴虐钢骨") then
   --    UI.Signal(4029)
   -- end
   -- if string.find(msg, "母体幻痛夜魔") then
   --    UI.Signal(4030)
   -- end
   -- if string.find(msg, "母体爆弹狂魔") then
   --    UI.Signal(4031)
   -- end
   -- if string.find(msg, "母体断翼恶灵") then
   --    UI.Signal(4032)
   -- end
   if string.find(msg, "GOCT") then
      UI.Signal(4033)
   end
   if string.find(msg, "GOTR") then
      UI.Signal(4034)
   end
   if string.find(msg, "watch") then
      UI.Signal(4035)
   end
   if string.find(msg, "respawn") then
      UI.Signal(4036)
   end
end

