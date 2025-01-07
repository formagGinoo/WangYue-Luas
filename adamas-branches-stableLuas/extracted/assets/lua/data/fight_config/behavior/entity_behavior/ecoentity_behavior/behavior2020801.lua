Behavior2020801 = BaseClass("Behavior2020801",EntityBehaviorBase)

--关卡交互实体
function Behavior2020801.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2020801:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.me = self.instanceId	
	self.myLevelId = nil
	self.myStateEnum = 
	{
		Default = 1,
		ChallengeStart = 2,
		Challenging =3,
		ChallengeLose = 4,
		ChallengeWin = 5,
		ChallengeEnd = 6,
	}
	self.myState = self.myStateEnum.Default
	
	--获取额外参数
	self.extraParam = nil
end

function Behavior2020801:LateInit()
	self.ecoId = BehaviorFunctions.GetEntityEcoId(self.me)
	self.myLevelId = BehaviorFunctions.GetEcoEntityBindLevel(self.ecoId)
end

function Behavior2020801:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.myState == self.myStateEnum.ChallengeStart then
		BehaviorFunctions.AddLevel(self.myLevelId,nil,true)
		BehaviorFunctions.SetEntityWorldInteractState(self.me,false)
		self.myState = self.myStateEnum.Challenging
		
	elseif self.myState == self.myStateEnum.ChallengeLose then
		BehaviorFunctions.SetEntityWorldInteractState(self.me,true)
		self.myState = self.myStateEnum.Default
		
	elseif self.myState == self.myStateEnum.ChallengeWin then
		BehaviorFunctions.InteractEntityHit(self.me)
		self.myState = self.myStateEnum.ChallengeEnd
		
	elseif self.myState == self.myStateEnum.ChallengeEnd then

	end
end

function Behavior2020801:RemoveLevel(levelId)
	if levelId == self.myLevelId then
		self.myState = self.myStateEnum.ChallengeLose
	end
end

function Behavior2020801:FinishLevel(levelId)
	if levelId == self.myLevelId then
		self.myState = self.myStateEnum.ChallengeWin
	end
end

function Behavior2020801:WorldInteractClick(uniqueId,instancId)
	if instancId == self.me then
		if self.myState == self.myStateEnum.Default then
			local occupyResult = BehaviorFunctions.ChecklevelOccupy(self.myLevelId)
			if not occupyResult then
				self.myState = self.myStateEnum.ChallengeStart
			else
				BehaviorFunctions.AddLevel(self.myLevelId,nil,true)
			end
		end
	end
end

function Behavior2020801:CreateLevelOccupancyFail(levelId)
	LogError(levelId)
end

