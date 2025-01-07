LevelBehavior103090111 = BaseClass("LevelBehavior103090111",LevelBehaviorBase)
--拼接教学

function LevelBehavior103090111:__init(fight)
	self.fight = fight
end

function LevelBehavior103090111.GetGenerates()
	local generates = {2080102}
	return generates
end

function LevelBehavior103090111:Init()
	self.missionState = 0

end


function LevelBehavior103090111:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.missionState == 0  then
		--创建实体
		self.banzi1 = self:CreateActor(2080102,"banzi1")
		self.banzi2 = self:CreateActor(2080102,"tishi")
		self.banzi3 = self:CreateActor(2080102,"banzi2")
		self.dongxi = self:CreateActor(2001,"dongxi")
		--搬运buff
		BehaviorFunctions.DoMagic(1,self.banzi1,200001150)
		BehaviorFunctions.DoMagic(1,self.banzi2,200001150)
		--创建教学
		MsgBoxManager.Instance:ShowTips(TI18N("此处应有拼接图文教学"), 4)
		--隐藏提示
		--BehaviorFunctions.ActiveSceneObj("FxHideSafe",false)
		self.missionState = 1
	elseif self.missionState == 1 then
		local distance = BehaviorFunctions.GetDistanceFromTarget(self.dongxi,self.role)
		if distance <= 3 then
			self.enter = true
		else
			self.enter = false
		end
		--交互列表
		if self.enter then
			if self.isTrigger then
				return
			end
			self.isTrigger = self.dongxi
			if not self.isTrigger then
				return
			end
			self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.dongxi,WorldEnum.InteractType.Unlock,nil,"拿取",1)
		else
			if self.isTrigger  then
				self.isTrigger = false
				BehaviorFunctions.WorldInteractRemove(self.dongxi,self.interactUniqueId)
			end
		end
	end
end

function LevelBehavior103090111:__delete()

end

function LevelBehavior103090111:CreateActor(entityId,bornPos)
	local instanceId = BehaviorFunctions.CreateEntityByPosition(entityId,nil,bornPos,nil,self.levelId,self.levelId)
	return instanceId
end

function LevelBehavior103090111:WorldInteractClick(uniqueId)
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		if self.missionState == 1 then
			BehaviorFunctions.WorldInteractRemove(self.dongxi,self.interactUniqueId)
			BehaviorFunctions.ActiveSceneObj("dongxi",false,self.levelId)
			BehaviorFunctions.FinishLevel(self.levelId)
			self.missionState = 2
		end
	end
end