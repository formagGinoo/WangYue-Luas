LevelBehavior30003 = BaseClass("LevelBehavior30003",LevelBehaviorBase)
--教学3
function LevelBehavior30003:__init(fight)
	self.fight = fight
end


function LevelBehavior30003.GetGenerates()
	local generates = {910024}
	return generates
end


function LevelBehavior30003:Init()
	self.role = 1
	self.missionState = 0
end

function LevelBehavior30003:Update()
	if  self.missionState == 0 then
		local pos = BehaviorFunctions.GetTerrainPositionP("teach3monster",10020001)
		self.monster =BehaviorFunctions.CreateEntity(910024,nil,pos.x,pos.y,pos.z)
		BehaviorFunctions.ShowTip(3001006) --消灭怪物
		self.missionState = 10
	end

	if self.missionState == 30 then
		BehaviorFunctions.ShowTip(3001004)
		BehaviorFunctions.SendGmExec("task_finish", {"200100106"})
		self.missionState = 999
		BehaviorFunctions.RemoveLevel(30003)
	end
end
function LevelBehavior30003:RemoveEntity(instanceId)
	if instanceId == self.monster then
		self.missionState = 30
	end

end

function LevelBehavior30003:__delete()

end
