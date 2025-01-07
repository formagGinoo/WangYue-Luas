LevelBehavior30007 = BaseClass("LevelBehavior30007",LevelBehaviorBase)
--动态创建关卡1
function LevelBehavior30007:__init(fight)
	self.fight = fight
end


function LevelBehavior30007.GetGenerates()
	local generates = {900040,900030,900050,900010} 
	return generates
end


function LevelBehavior30007:Init()
	self.role = 1
	self.missionState = 0
end

function LevelBehavior30007:Update()
	self.frame = BehaviorFunctions.GetFightFrame()
	if  self.missionState == 0 then
		--BehaviorFunctions.SetPlayerBorn(425,100,435)
		BehaviorFunctions.SetPlayerBorn(400,97.9,440)
		--BehaviorFunctions.DoMagic(self.role,self.role,200000002)
		--self.monster = BehaviorFunctions.CreateEntity(900030,nil,623,97,435)
		--self.monster2 = BehaviorFunctions.CreateEntity(900030,nil,423,97,421)
		--self.monster2 = BehaviorFunctions.CreateEntity(900040,nil,400,100,440)
		self.monster3 = BehaviorFunctions.CreateEntity(900050,nil,415,97.9,415)
		BehaviorFunctions.SetEntityValue(self.monster3,"peaceState",1)
		--self.monster4 = BehaviorFunctions.CreateEntity(900030,nil,430,100,460)
		--self.monster2 = BehaviorFunctions.CreateEntity(92002,nil,423,97,435)
		--BehaviorFunctions.EntityCombination(self.monster2,self.monster,true)
		--BehaviorFunctions.DoLookAtTargetImmediately(self.monster2,self.role)
		
		----为中立怪添加Boss血条标签
		--BehaviorFunctions.AddEntitySign(1,10000020,-1,false)
		
		--BehaviorFunctions.SetCameraDistance(7)
		self.missionState = 5
	end

end

function LevelBehavior31004:Death(instanceId,isFormationRevive)
	if isFormationRevive then
		
	elseif instanceId == self.monster then
		----怪物死后，移除Boss血条标签
		--BehaviorFunctions.RemoveEntitySign(1,10000020)
		self.winState = 1
	end
end

function LevelBehavior30007:__delete()

end
