LevelBehavior30008 = BaseClass("LevelBehavior30008",LevelBehaviorBase)
--动态创建关卡1
function LevelBehavior30008:__init(fight)
	self.fight = fight
end


function LevelBehavior30008.GetGenerates()
	local generates = {910024}
	return generates
end


function LevelBehavior30008:Init()
	self.role = 1
	self.missionState = 0
end

function LevelBehavior30008:Update()
	self.frame = BehaviorFunctions.GetFightFrame()
	if  self.missionState == 0 then
		BehaviorFunctions.SetPlayerBorn(423,97,420)
		--BehaviorFunctions.DoMagic(self.role,self.role,200000002)
		--self.monster = BehaviorFunctions.CreateEntity(92001,nil,623,97,435)
		self.monster2 = BehaviorFunctions.CreateEntity(910024,nil,423,97,435)
		--BehaviorFunctions.EntityCombination(self.monster2,self.monster,true)
		--BehaviorFunctions.DoLookAtTargetImmediately(self.monster2,self.role)
		
		----为中立怪添加Boss血条标签
		--BehaviorFunctions.AddEntitySign(1,10000020,-1,false)
		
		--BehaviorFunctions.SetCameraDistance(7)
		self.missionState = 5
	end

end

function LevelBehavior30008:Death(instanceId,isFormationRevive)
	if isFormationRevive then
		
	elseif instanceId == self.monster then
		----怪物死后，移除Boss血条标签
		--BehaviorFunctions.RemoveEntitySign(1,10000020)
		self.winState = 1
	end
	--if instanceId == self.monster2 then
		--BehaviorFunctions.RemoveEntity(self.monster)
	--end
end

function LevelBehavior30008:__delete()

end
