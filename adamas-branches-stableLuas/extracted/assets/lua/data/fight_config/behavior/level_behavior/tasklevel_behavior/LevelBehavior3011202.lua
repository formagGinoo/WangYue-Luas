LevelBehavior3011202 = BaseClass("LevelBehavior3011202",LevelBehaviorBase)

function LevelBehavior3011202.GetGenerates()
	local generates = {900120,900070}
	return generates
end

function LevelBehavior3011202:__init(fight)
	self.fight = fight
end

function LevelBehavior3011202:Init()

	-------------------基础参数----------------------
	self.missionState = 0

	-------------------刷怪列表----------------------

	-------------------通用关卡函数引用----------------------
	self.LevelCommon = BehaviorFunctions.CreateBehavior("LevelCommonFunction",self)
	self.LevelCommon.levelId = self.levelId



	self.role = BehaviorFunctions.GetCtrlEntity()
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}

	self.dialogList =
	{
		[1] = {Id = 602110201,state = self.dialogStateEnum.NotPlaying}, --战斗前对话
	}
	
	self.camera = false

	self.playercheckP = 0
	self.target = nil
	self.targetPoint = "TP0402"
	self.maxRange = 5
	self.isClean = false
	self.time = nil
	self.startTime = nil
end

function LevelBehavior3011202:Update()
	self.LevelCommon:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	if self.missionState == 0 then
		--设置为普通关卡
		self.LevelCommon:SetAsTaskLevel("")

		--开启关卡
		self.LevelCommon:LevelStart()

		self.playercheckP = BehaviorFunctions.GetPositionP(self.role)
		
		self.dongxi = self:CreateActor(2001,"TP0402")

		self.missionState = 1

	elseif self.missionState == 4 then

		--获取自定义胜利条件是否满足
		local result1 = self:CustomSuccessCondition1()
		if result1 then
			LogError("1122211")
		end

		
		--将上述条件作为胜利条件
		self.LevelCommon:LevelSuccessCondition(result1)		
	end
	

	if self.missionState == 1 then
		
		local target = BehaviorFunctions.GetTerrainPositionP(self.targetPoint,self.levelId)
		local checkPRange = BehaviorFunctions.GetDistanceFromPos(target,self.playercheckP)	--获取与路标特效的距离
		if checkPRange < self.maxRange then
			--摄像头调用
			if self.camera == false then
				self.LevelCommon:LevelCameraLookAtPos(22002,40,nil,self.targetPoint,0.75,0.75)
				self.camera = true
			end
			--播放对话
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		end
	end
	
	if self.missionState == 2 then
		
		local distance = BehaviorFunctions.GetDistanceFromTarget(self.dongxi,self.role)
		if distance <= 10 then
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
			self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.dongxi,WorldEnum.InteractType.Unlock,nil,"拆掉引信",1)
		else
			if self.isTrigger  then
				self.isTrigger = false
				BehaviorFunctions.WorldInteractRemove(self.dongxi,self.interactUniqueId)			
			end
		end
	end
		
	
	if self.missionState == 3 and self.time - self.startTime >= 60 then
		
		self.missionState = 4	
	end
	
		
	----点击交互
	--function LevelBehavior3011202:WorldInteractClick(uniqueId,instanceId)
		--if uniqueId == self.button and self.missionState == 2 then
			--self.missionState = 3
		--end
	--end
	

	
end

function LevelBehavior3011202:WorldInteractClick(uniqueId)
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		if self.missionState == 2 then
			BehaviorFunctions.WorldInteractRemove(self.dongxi,self.interactUniqueId)
			--BehaviorFunctions.ActiveSceneObj("TP0402",false,self.levelId)
			--BehaviorFunctions.FinishLevel(self.levelId)
			self.missionState = 3
			BehaviorFunctions.AddLevelTips(3011202,self.levelId)
			self.startTime = BehaviorFunctions.GetFightFrame()
		end
	end
end

function LevelBehavior3011202:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if dialogId == self.dialogList[1].Id then
				if self.missionState < 2 and self.isClean == false then
					--self.button = BehaviorFunctions.WorldInteractActive(self.role,4,nil,"清理",1)
					self.isClean = true
					self.missionState = 2
				end
			end
			v.state = self.dialogStateEnum.PlayOver
		end
	end
end

function LevelBehavior3011202:CreateActor(entityId,bornPos)
	local instanceId = BehaviorFunctions.CreateEntityByPosition(entityId,nil,bornPos,nil,self.levelId,self.levelId)
	return instanceId
end


--自定义胜利条件
function LevelBehavior3011202:CustomSuccessCondition1()
	if self.missionState == 4 then
		return true	
		
	end
end