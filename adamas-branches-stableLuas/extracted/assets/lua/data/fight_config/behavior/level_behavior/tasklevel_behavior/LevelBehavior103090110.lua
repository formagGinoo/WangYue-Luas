LevelBehavior103090110 = BaseClass("LevelBehavior103090110",LevelBehaviorBase)
--搬运教学

function LevelBehavior103090110:__init(fight)
    self.fight = fight
end

function LevelBehavior103090110.GetGenerates()
    local generates = {2080102}
    return generates
end

function LevelBehavior103090110:Init()
	self.missionState = 0
	self.banziList = {}
	
end

function LevelBehavior103090110:Update()
	if self.missionState == 0  then
		--创建实体
		--板子
		for i = 1, 3 do
			local posName = "banzi"..i
			local instanceId = self:CreateActor(2080102,posName)
			table.insert(self.banziList,instanceId)
		end
		--光圈
		self.tishi = self:CreateActor(2001,"tishi")
		BehaviorFunctions.ActiveSceneObj("FxHideSafe",true, self.levelId)
		--搬运buff
		BehaviorFunctions.DoMagic(1,self.banzi1,200001150)
		BehaviorFunctions.DoMagic(1,self.banzi2,200001150)
		--关卡提示
		BehaviorFunctions.ShowTip(100000001,"将任意铁板搬进光圈并放下")	
		self.missionState = 1
	elseif self.missionState == 1 then
		for i = 1,3 do
			local distance = BehaviorFunctions.GetDistanceFromTarget(self.tishi,self.banziList[i])
			if distance < 2 and not BehaviorFunctions.CheckEntityOnBuildControl(self.banziList[i]) then
				MsgBoxManager.Instance:ShowTips(TI18N("搬运成功"), 2)
				BehaviorFunctions.HideTip(100000001)
				BehaviorFunctions.FinishLevel(self.levelId)
				break
				self.missionState = 2
			end
		end
	end
end

function LevelBehavior103090110:__delete()

end

function LevelBehavior103090110:CreateActor(entityId,bornPos)
	local instanceId = BehaviorFunctions.CreateEntityByPosition(entityId,nil,bornPos,nil,self.levelId,self.levelId)
	return instanceId
end