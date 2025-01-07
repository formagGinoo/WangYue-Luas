LevelBehavior30005 = BaseClass("LevelBehavior30005",LevelBehaviorBase)
--动态创建关卡1
function LevelBehavior30005:__init(fight)
	self.fight = fight
end


function LevelBehavior30005.GetGenerates()
	local generates = {920011,92002,910024}
	return generates
end


function LevelBehavior30005:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.missionState = 0
end

function LevelBehavior30005:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.frame = BehaviorFunctions.GetFightFrame()
	if  self.missionState == 0 then
		BehaviorFunctions.SetPlayerBorn(423,97,420)
		BehaviorFunctions.DoMagic(self.role,self.role,200000002)
		self.monster = BehaviorFunctions.CreateEntity(920011,nil,623,97,435)
		self.monster2 = BehaviorFunctions.CreateEntity(92002,nil,423,97,435)
		--多部位怪物搜索相关标记：10000022
		if not BehaviorFunctions.HasEntitySign(self.monster2,10000022) then
			BehaviorFunctions.AddEntitySign(self.monster2,10000022,-1)
		end
		BehaviorFunctions.EntityCombination(self.monster2,self.monster,true)
		BehaviorFunctions.DoLookAtTargetImmediately(self.monster2,self.role)
		
		----为中立怪添加Boss血条标签
		--BehaviorFunctions.AddEntitySign(1,10000020,-1,false)
		
		--BehaviorFunctions.SetCameraDistance(7)
		
		--添加BossUI
		BehaviorFunctions.SetEntityValue(1,"LevelUiTarget",self.monster2)
		--添加boss血条
		if not BehaviorFunctions.HasEntitySign(1,10000020) then
			BehaviorFunctions.AddEntitySign(1,10000020,-1)
		end
		
		--贝露贝特不传入boss血条
		if not BehaviorFunctions.HasEntitySign(self.monster,10000031) then
			BehaviorFunctions.AddEntitySign(self.monster,10000031,-1)
		end
		
		self.missionState = 5
	end
	
	if self.missionState == 5 then
		
	end
end

function LevelBehavior30005:Death(instanceId,isFormationRevive)
	if isFormationRevive then
		
	elseif instanceId == self.monster then
		----怪物死后，移除Boss血条标签
		--BehaviorFunctions.RemoveEntitySign(1,10000020)
		self.winState = 1
	end
	if instanceId == self.monster2 then
		BehaviorFunctions.RemoveEntity(self.monster)
	end
end

function LevelBehavior30005:__delete()

end
