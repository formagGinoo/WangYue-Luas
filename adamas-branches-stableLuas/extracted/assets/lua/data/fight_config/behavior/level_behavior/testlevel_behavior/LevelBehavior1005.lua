LevelBehavior1005 = BaseClass("LevelBehavior1005",LevelBehaviorBase)


--fight初始化
function LevelBehavior1005:__init(fight)
	self.fight = fight	
end

--预加载
function LevelBehavior1005.GetGenerates()
	local generates = {9001}
	return generates
end

--初始化
function LevelBehavior1005:Init()
	self.role = 1
	self.Missionstate = 0
end

function LevelBehavior1005:Update()
	if not self.entites and self.Missionstate == 0 then 
		self.entites = {}   --初始化self.entites表
		local pb1 = BehaviorFunctions.GetTerrainPositionP("role")
		-- BehaviorFunctions.DoSetPosition(self.role,pb1.x,pb1.y,pb1.z)    --角色位置
		BehaviorFunctions.SetPlayerBorn(pb1.x,pb1.y,pb1.z)
		BehaviorFunctions.InitCameraAngle(180)
		local mb1 = BehaviorFunctions.GetTerrainPositionP("mb101")
		self.monster = BehaviorFunctions.CreateEntity(9001)
		BehaviorFunctions.DoSetPosition(self.monster,mb1.x,mb1.y,mb1.z)
		self.Missionstate = 1
	end

 if self.Missionstate == 1 then	
		if self.monster  then
			BehaviorFunctions.RemoveBehavior(self.monster)
		end
	end
end

--死亡事件
function LevelBehavior1005:Death(instanceId)
	if instanceId == self.monster then
		self.monster = nil
	end
end

function LevelBehavior1005:__delete()

end

