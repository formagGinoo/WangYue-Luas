LevelBehavior30004 = BaseClass("LevelBehavior30004",LevelBehaviorBase)
--屠龙
function LevelBehavior30004:__init(fight)
	self.fight = fight
end


function LevelBehavior30004.GetGenerates()
	local generates = {92002}
	return generates
end


function LevelBehavior30004:Init()
	self.role = 1
	self.missionState = 0
end

function LevelBehavior30004:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.missionState == 0  then
		BehaviorFunctions.ShowTip(3001008)
		local pos2 = BehaviorFunctions.GetTerrainPositionP("bossS1",10020001)
		self.guide = BehaviorFunctions.CreateEntity(20002,nil,pos2.x,pos2.y,pos2.z)
		self.missionState = 10
	end
	if self.missionState == 10 then
		local pos = BehaviorFunctions.GetTerrainPositionP("boss1",10020001)
		local pos2 = BehaviorFunctions.GetTerrainPositionP("bossS1",10020001)
		local rolePos = BehaviorFunctions.GetPositionP(self.role)
		if BehaviorFunctions.GetDistanceFromPos(pos2,rolePos)< 3 then
			self.monster = BehaviorFunctions.CreateEntity(92002,nil,pos.x,pos.y,pos.z)
			BehaviorFunctions.ActiveSceneObj("airwall",true,10020001)
			self.missionState = 20
		end
	end
end

--死亡事件
function LevelBehavior30004:Death(instanceId)
	if instanceId == self.monster then
		--BehaviorFunctions.SendGmExec("task_finish", {"200100107"})
		BehaviorFunctions.ShowTip(3001004)
		BehaviorFunctions.ActiveSceneObj("airwall",false,10020001)
		BehaviorFunctions.RemoveEntity(self.guide)
		BehaviorFunctions.RemoveLevel(30004)
	end
	if instanceId == self.role then
		BehaviorFunctions.ShowTip(3001003)
		BehaviorFunctions.ActiveSceneObj("airwall",false,10020001)
		BehaviorFunctions.RemoveEntity(self.guide)
		BehaviorFunctions.RemoveLevel(30004)
	end
end


function LevelBehavior30004:__delete()

end
