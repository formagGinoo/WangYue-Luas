LevelBehavior31002 = BaseClass("LevelBehavior31002",LevelBehaviorBase)
--贝露贝特副本
function LevelBehavior31002:__init(fight)
	self.fight = fight
end


function LevelBehavior31002.GetGenerates()
	local generates = {92001}
	return generates
end


function LevelBehavior31002:Init()
	self.role = 1
	self.missionState = 0
	self.LevelBeha = BehaviorFunctions.CreateBehavior("LevelBehavior",self)
	self.bgmState = 0
	self.guide = nil
	self.enter = nil
end

function LevelBehavior31002:ResetDuplicateInfo()
	self.role = 1
	self.missionState = 0
	self.LevelBeha = BehaviorFunctions.CreateBehavior("LevelBehavior",self)
	self.bgmState = 0
	self.guide = nil
	self.enter = nil
end

function LevelBehavior31002:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.missionState == 0  then
		local pos1 = BehaviorFunctions.GetTerrainPositionP("characterBorn",10021002)
		local pos2 = BehaviorFunctions.GetTerrainPositionP("enemyBorn",10021002)
		--BehaviorFunctions.DoSetPosition(self.role,pos1.x,pos1.y,pos1.z)
		BehaviorFunctions.InMapTransport(pos1.x,pos1.y,pos1.z)
		self.monster1 = BehaviorFunctions.CreateEntity(92001,nil,pos2.x,pos2.y,pos2.z)
		----为中立怪添加Boss血条标签
		--BehaviorFunctions.AddEntitySign(1,10000020,-1,false)
		
		self.missionState = 1
	end
	if self.missionState == 1 then
		if BehaviorFunctions.CheckEntity(self.monster1) then
			--添加BossUI
			BehaviorFunctions.SetEntityValue(1,"LevelUiTarget",self.monster1)
			--添加boss血条
			if not BehaviorFunctions.HasEntitySign(1,10000020) then
				BehaviorFunctions.AddEntitySign(1,10000020,-1)
			end
			--贝露贝特传入boss血条
			if not BehaviorFunctions.HasEntitySign(self.monster1,10000031) then
				BehaviorFunctions.AddEntitySign(self.monster1,10000031,-1)
			end
		end
	end
	if self.guide then
		local pos = BehaviorFunctions.GetDistanceFromTarget(self.role,self.guide)
		if pos <= 3 then
			self.enter = true
		else
			self.enter = false
		end
		--交互列表
		if self.enter then
			if self.isTrigger then
				return
			end
			self.isTrigger = self.guide
			if not self.isTrigger then
				return
			end
			self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.guide,WorldEnum.InteractType.Unlock,nil,"再次挑战",1)
		else
			if self.isTrigger  then
				self.isTrigger = false
				BehaviorFunctions.WorldInteractRemove(self.guide,self.interactUniqueId)
			end
		end
	end

end

function LevelBehavior31002:WorldInteractClick(uniqueId)
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		--BehaviorFunctions.RemoveEntity(self.guide)
		--self.guide = nil
		--BehaviorFunctions.WorldInteractRemove(self.guide,self.interactUniqueId)
		BehaviorFunctions.ResDuplicateResult(true)
		-- local pos = BehaviorFunctions.GetTerrainPositionP("enemyBorn",10021002)
		-- self.monster1 = BehaviorFunctions.CreateEntity(92001,nil,pos.x+3,pos.y,pos.z)
	end
end

--死亡事件
function LevelBehavior31002:Death(instanceId,isFormationRevive)
	if instanceId == self.monster1 then
		local pos = BehaviorFunctions.GetTerrainPositionP("enemyBorn",10021002)
		self.guide = BehaviorFunctions.CreateEntity(200000108,nil,pos.x,pos.y,pos.z)
	end
end


function LevelBehavior31002:__delete()
	-- BehaviorFunctions.WorldInteractRemove(self.guide,self.interactUniqueId)
end
