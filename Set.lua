------开关 1开0关
Switch_Lcokhealth = 1               --锁血
Switch_StorePoint = 1               --存点
-- Switch_Pause = 1                    --暂停
Switch_Back  = 1                    --0回起点
Switch_Timer = 1                    --计时器
Switch_Speed = 1                    --地速显示
Switch_Extent = 1                  --范围回点
Switch_Knife = 1                    --开局起小刀
Switch_Model = 1                    --模型更改
------按钮设置
button1={-21,73,6}                     --起点按钮坐标
button2={-54,63,67}                     --终点按钮坐标
button3={-26,75,-4}
button4={-27,75,-4}
------起点坐标
Back = {x=-8,y=76,z=0}                --起点坐标设置
------范围回点
function Con_Extent(player)        --范围回点添加
 -- Extent(x1,y1,z1,x2,y2,z2,x3,y3,z3,player)
	Extent(-24,74,2,-28,76,2,-22,75,5,player)

	Extent(-30,72,0,-26,64,0,-29,74,5,player)
	Extent(-26,63,-1,-30,58,-1,-29,74,5,player)
	Extent(-30,57,-2,-26,53,-2,-29,74,5,player)
	Extent(-68,56,-28,-68,57,-28,-68,55,11,player)

	Extent(-77,88,-24,-77,89,-24,-75,89,-22,player)
	Extent(-79,88,-24,-79,89,-24,-75,89,-22,player)
	Extent(-81,88,-24,-81,89,-24,-75,89,-22,player)
	Extent(-83,88,-25,-83,89,-25,-75,89,-22,player)
	Extent(-85,90,-24,-90,107,-24,-88,88,-22,player)
	Extent(-28,110,-24,-83,98,-24,-82,112,-22,player)
	Extent(-80,91,-24,-75,95,-24,-83,92,-22,player)
	Extent(-69,84,-20,-65,83,-20,-69,85,-19,player)
	Extent(-44,56,0,-32,60,0,-47,59,2,player)
	Extent(-32,60,0,-51,74,0,-47,59,2,player)
	Extent(-50,76,0,-48,78,0,-48,76,20,player)

	Extent(-45,76,0,-34,83,0,-47,77,2,player)
	Extent(-37,84,0,-45,92,0,-47,77,2,player)

	Extent(-51,81,11,-39,79,11,-52,81,17,player)
	Extent(-43,81,6,-47,79,6,-41,80,7,player)

	-- Extent(-53,86,0,-55,70,0,-53,83,11,player)
	-- Extent(-56,77,0,-64,71,0,-53,83,11,player)
	Extent(-67,79,12,-57,85,12,-67,80,17,player)
	-- Extent(-0,0,0,-0,0,0,0,0,0,player)
	-- Extent(-0,0,0,-0,0,0,0,0,0,player)
end
--[[
      范围回点使用方法
	   Extent(x1,y1,z1,x2,y2,z2,x3,y3,z3,player)
	   其中
	   -(x1,y1,z1)---立方体范围的一个顶点坐标
	   -(x2,y2,z2)---立方体范围与上一顶点对顶的顶点坐标
	   -(x3,y3.z3)---人物进入该区域后返回的点的坐标
	   -player---不用更改
	   使用时请把 Switch_Extent 设置为 1
--]]
