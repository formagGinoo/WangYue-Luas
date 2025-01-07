LevelBehavior1009 =  BaseClass("LevelBehavior1009",LevelBehaviorBase)
--fight初始化
function LevelBehavior1009:__init(fight)
	self.fight = fight
end

--预加载
function LevelBehavior1009.GetGenerates()
	local generates = {9001}
	return generates
end

--参数初始化
function LevelBehavior1009:Init()
	self.role = 1           --当前角色
	self.Missionstate = 0   --关卡流程
	self.Monsters = {
		Count = 0
	}
	self.wave = 0           --波数计数
	self.wavelimit = 4      --波数上限
	self.time = 0		    --世界时间
	self.timestart = 0      --记录时间
end

--帧事件
function LevelBehavior1009:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	--初始化，角色出生点
	if  self.Missionstate == 0 then
		self.entites = {}   --初始化self.entites表
		BehaviorFunctions.DoSetPosition(self.role,334,40,170)   --角色位置
		self.timestart =BehaviorFunctions.GetFightFrame()
		--Log("击杀3波小怪结束关卡")
		self.Missionstate = 5
	end
	if self.Missionstate == 5 and self.time - self.timestart >= 90 then
		BehaviorFunctions.ShowTip(1001)
		self.timestart =BehaviorFunctions.GetFightFrame()
		self.Missionstate =10
	end
	--召怪
	if self.Missionstate == 10 and self.time - self.timestart >= 150 then
	  if self.wave < self.wavelimit then			
		local Monster1 = BehaviorFunctions.CreateEntity(9001)      --召怪,返回怪物id
		self.Monsters[Monster1] = Monster1
		self.Monsters.Count = self.Monsters.Count + 1
		local Monster2 = BehaviorFunctions.CreateEntity(9001)
		self.Monsters[Monster2] = Monster2
		self.Monsters.Count = self.Monsters.Count + 1
		local Monster3 = BehaviorFunctions.CreateEntity(9001)
		self.Monsters[Monster3] = Monster3
		self.Monsters.Count = self.Monsters.Count + 1
		self.wave = self.wave + 1                                 --波数计数
			if self.wave == 1 then
				BehaviorFunctions.DoSetPosition(Monster1,332,40,179)
				BehaviorFunctions.DoSetPosition(Monster2,334,40,179)
				BehaviorFunctions.DoSetPosition(Monster3,336,40,179)
			elseif self.wave == 2 then
				BehaviorFunctions.DoSetPosition(Monster1,325,40,246)
				BehaviorFunctions.DoSetPosition(Monster2,327,40,246)
				BehaviorFunctions.DoSetPosition(Monster3,329,40,246)
			elseif self.wave == 3 then
				BehaviorFunctions.DoSetPosition(Monster1,293,40,317)
				BehaviorFunctions.DoSetPosition(Monster2,291,40,317)
				BehaviorFunctions.DoSetPosition(Monster3,295,40,317)
			elseif self.wave == 4 then
				BehaviorFunctions.DoSetPosition(Monster1,250,40,335)
				BehaviorFunctions.DoSetPosition(Monster2,247,40,335)
				BehaviorFunctions.DoSetPosition(Monster3,253,40,335)
			end
			BehaviorFunctions.DoLookAtTargetImmediately(Monster1,self.role)
			BehaviorFunctions.DoLookAtTargetImmediately(Monster2,self.role)
			BehaviorFunctions.DoLookAtTargetImmediately(Monster3,self.role)
			self.Missionstate = 20
	  elseif self.wave == self.wavelimit and self.npc > 0 then
		self.distance = BehaviorFunctions.GetDistanceFromTarget(self.role,self.npc) 
		    if self.distance <= 5 then
				self.Missionstate = 999
				--Log("关卡结束")
				BehaviorFunctions.ShowTip(1005)
			end
		
	  end
	end
	--清怪检测
	if self.Missionstate == 20 and self.Monsters.Count == 0 then   
	    self.timestart =BehaviorFunctions.GetFightFrame()
		if self.wave == 1 then
			--Log("前进击杀第2波小怪")
			BehaviorFunctions.SetWallEnable("AW1",false)
			BehaviorFunctions.ShowTip(1002)	
		elseif self.wave == 2 then
			--Log("前进击杀第3波小怪")
			BehaviorFunctions.SetWallEnable("AW2",false)
			BehaviorFunctions.ShowTip(1003)		
		elseif self.wave == 3 then
			--Log("前进击杀第4波小怪")
			BehaviorFunctions.SetWallEnable("AW3",false)
			BehaviorFunctions.ShowTip(1004)
		end
		self.Missionstate = 30
    end
    if self.Missionstate == 30 and self.time - self.timestart >= 150 then	    
		self.Missionstate = 10
	end
end
--死亡事件
function LevelBehavior1009:Death(instanceId)
	if self.Monsters[instanceId] then
		self.Monsters[instanceId] = nil
		self.Monsters.Count = self.Monsters.Count - 1
		--Log(self.Monsters.Count)
		if self.Monsters.Count == 0 and self.wave == 4 then
        self.npc = BehaviorFunctions.CreateEntity(9001)
		BehaviorFunctions.DoSetPosition(self.npc,235,0,288)
		BehaviorFunctions.RemoveBehavior(self.npc)	
			BehaviorFunctions.SetWallEnable("AW4",false)	
			--Log("找到发射台入口")
			BehaviorFunctions.ShowTip(1006)
		end
	end
end
--封装功能
--[[function LevelBehavior1009:Step2()

end]]

function LevelBehavior1009:__delete()

end