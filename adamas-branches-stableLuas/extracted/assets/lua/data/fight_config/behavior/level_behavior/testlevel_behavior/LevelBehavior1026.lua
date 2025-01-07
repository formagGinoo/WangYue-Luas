LevelBehavior1026 = BaseClass("LevelBehavior1026",LevelBehaviorBase)
--战斗单怪测试关
function LevelBehavior1026:__init(fight)
	self.fight = fight
end


function LevelBehavior1026.GetGenerates()
	local generates = {9001}
	return generates
end


function LevelBehavior1026:Init()
	self.role = 1
	self.missionState = 0
	--创建关卡通用行为树
	self.LevelBehavior = BehaviorFunctions.CreateBehavior("LevelBehavior",self)
end

function LevelBehavior1026:Update()
	self.frame = BehaviorFunctions.GetFightFrame()
	if  self.missionState == 0 then
		self.entites = {}   --初始化self.entites表
		local mb101 = BehaviorFunctions.GetTerrainPositionP("mb101")
		local pb1 = BehaviorFunctions.GetTerrainPositionP("role")
		self.LevelBehavior:PlayerBorn("role","mb101")
		BehaviorFunctions.ShowSkillGuide(100303,1)
		self.missionState = 5
	end
	if self.missionState == 5 and BehaviorFunctions.GetSkillGuideState() == FightEnum.SkillGuideState.Failed then
		BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.ResetSkillGuide)
	end
end

function LevelBehavior1026:Death(instanceId)
	if instanceId == self.Monster then
		local pb1 = BehaviorFunctions.GetTerrainPositionP("role")
		local mb101 = BehaviorFunctions.GetTerrainPositionP("mb101")
		self.Monster = BehaviorFunctions.CreateEntity(9001,nil,mb101.x,mb101.y,mb101.z,pb1.x,nil,pb1.z)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.Monster)
	end
end

function LevelBehavior1026:__delete()

end