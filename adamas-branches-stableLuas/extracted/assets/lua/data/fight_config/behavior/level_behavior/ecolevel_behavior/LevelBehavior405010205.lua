LevelBehavior405010205 = BaseClass("LevelBehavior405010205",LevelBehaviorBase)


function LevelBehavior405010205.GetGenerates()
	local generates = {2030407,2030408,22002}
	return generates
end

function LevelBehavior405010205:__init(fight)
	self.fight = fight
end


function LevelBehavior405010205:Init()
	self.logicId = "OpenWorldParkour03"
	self.bornPos = "born"
	self.role = nil
	self.currentWave = 0 --当前波次
	self.missionState = 0
	self.goldCount = 0  --拾取的道具数量
	self.posAmount = 65   --金币总数
	self.posEntityList = {}  --金币实体列表
	self.checkWhite = 2030408
	self.camera = false
	self.pointNum = 0
	self.goldNum = 0
	self.creatFrame = 0
	
	-------------------通用关卡函数引用----------------------
	self.LevelCommon = BehaviorFunctions.CreateBehavior("LevelCommonFunction",self)
	self.LevelCommon.levelId = self.levelId
	self.start = false
	
end

function LevelBehavior405010205:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	self.LevelCommon:Update()
	if self.missionState == 0 then
		self.LevelCommon:SetAsChallengeLevel("挑战开始")
		--开启关卡
		self.LevelCommon:LevelStart()

		--创建引导点checkPos1
		local checkPos1 = BehaviorFunctions.GetTerrainPositionP("checkP1",self.levelId)
		local checkPosRot1 = BehaviorFunctions.GetTerrainRotationP("checkP1",self.levelId)
		self.checkEntity1 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos1.x, checkPos1.y, checkPos1.z,checkPosRot1.x,checkPosRot1.y,checkPosRot1.z,self.levelId)
		--checkPos2
		local checkPos2 = BehaviorFunctions.GetTerrainPositionP("checkP2",self.levelId)
		local checkPosRot2 = BehaviorFunctions.GetTerrainRotationP("checkP2",self.levelId)
		self.checkEntity2 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos2.x, checkPos2.y, checkPos2.z,checkPosRot2.x,checkPosRot2.y,checkPosRot2.z,self.levelId)
		--checkPos3
		local checkPos3 = BehaviorFunctions.GetTerrainPositionP("checkP3",self.levelId)
		local checkPosRot3 = BehaviorFunctions.GetTerrainRotationP("checkP3",self.levelId)
		self.checkEntity3 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos3.x, checkPos3.y, checkPos3.z,checkPosRot3.x,checkPosRot3.y,checkPosRot3.z,self.levelId)
		--checkPos4
		local checkPos4 = BehaviorFunctions.GetTerrainPositionP("checkP4",self.levelId)
		local checkPosRot4 = BehaviorFunctions.GetTerrainRotationP("checkP4",self.levelId)
		self.checkEntity4 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos4.x, checkPos4.y, checkPos4.z,checkPosRot4.x,checkPosRot4.y,checkPosRot4.z,self.levelId)
		--checkPos5
		local checkPos5 = BehaviorFunctions.GetTerrainPositionP("checkP5",self.levelId)
		local checkPosRot5 = BehaviorFunctions.GetTerrainRotationP("checkP5",self.levelId)
		self.checkEntity5 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos5.x, checkPos5.y, checkPos5.z,checkPosRot5.x,checkPosRot5.y,checkPosRot5.z,self.levelId)
		--checkPos6
		local checkPos6 = BehaviorFunctions.GetTerrainPositionP("checkP6",self.levelId)
		local checkPosRot6 = BehaviorFunctions.GetTerrainRotationP("checkP6",self.levelId)
		self.checkEntity6 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos6.x, checkPos6.y, checkPos6.z,checkPosRot6.x,checkPosRot6.y,checkPosRot6.z,self.levelId)
		--checkPos7
		local checkPos7 = BehaviorFunctions.GetTerrainPositionP("checkP7",self.levelId)
		local checkPosRot7 = BehaviorFunctions.GetTerrainRotationP("checkP7",self.levelId)
		self.checkEntity7 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos7.x, checkPos7.y, checkPos7.z,checkPosRot7.x,checkPosRot7.y,checkPosRot7.z,self.levelId)
		--checkPos6
		local checkPos8 = BehaviorFunctions.GetTerrainPositionP("checkP8",self.levelId)
		local checkPosRot8 = BehaviorFunctions.GetTerrainRotationP("checkP8",self.levelId)
		self.checkEntity8 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos8.x, checkPos8.y, checkPos8.z,checkPosRot8.x,checkPosRot8.y,checkPosRot8.z,self.levelId)
		--checkPos9
		local checkPos9 = BehaviorFunctions.GetTerrainPositionP("checkP9",self.levelId)
		local checkPosRot9 = BehaviorFunctions.GetTerrainRotationP("checkP9",self.levelId)
		self.checkEntity9 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos9.x, checkPos9.y, checkPos9.z,checkPosRot9.x,checkPosRot9.y,checkPosRot9.z,self.levelId)
		--checkPos10
		local checkPos10 = BehaviorFunctions.GetTerrainPositionP("checkP10",self.levelId)
		local checkPosRot10 = BehaviorFunctions.GetTerrainRotationP("checkP10",self.levelId)
		self.checkEntity10 = BehaviorFunctions.CreateEntity(self.checkWhite, nil, checkPos10.x, checkPos10.y, checkPos10.z,checkPosRot10.x,checkPosRot10.y,checkPosRot10.z,self.levelId)
		
		--创建可交互的金币
		for i = 1, self.posAmount do
			local posName = "Collect"..i
			local pos = BehaviorFunctions.GetTerrainPositionP(posName,self.levelId)
			if pos~= nil then
				local instanceId = BehaviorFunctions.CreateEntityByPosition(2030407,nil,posName,nil,self.levelId,self.levelId)
				table.insert(self.posEntityList,instanceId)
			end
		end
		BehaviorFunctions.ActiveSceneObj("Obstacle",true,self.levelId)

		self.tips = BehaviorFunctions.AddLevelTips(405010205,self.levelId)
		--设置tips参数为0
		BehaviorFunctions.ChangeLevelSubTips(self.tips,1,self.pointNum)
		BehaviorFunctions.ChangeLevelSubTips(self.tips,2,self.goldNum)
		
		--开场倒计时
		BehaviorFunctions.ShowCountDownPanel(3,self.levelId)

		--摄像头调用
		if self.camera == false then
			self.LevelCommon:LevelCameraLookAtPos(22002,40,nil,"Collect2",0.5,0.5)
			self.camera = true
		end
		self.missionState = 0.1
	end
	
	if self.missionState == 11 then
		self.creatFrame = self.time
		self.missionState = 12
	end

	--完成条件
	if self.missionState == 12 and self.time - self.creatFrame > 30 and self.goldNum >= 50 then
		----创建宝箱
		--BehaviorFunctions.ChangeEcoEntityCreateState(2005001119005, true)
		self.missionState = 13
	end
	
	
	if self.start == true then
		
		if self.missionState == 1 then
			self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity1,FightEnum.GuideType.Map_ChallengePaoku,0,false)
			self.missionState = 0.2
		end
	
		--获取自定义胜利条件是否满足
		local result1 = self:CustomSuccessCondition1()

		--将上述条件作为胜利条件
		self.LevelCommon:LevelSuccessCondition(result1)


		--失败条件：超出时间限制
		local result3 = self.LevelCommon:FailCondition_TimeLimit(90)
		--将上述条件作为失败条件
		self.LevelCommon:LevelFailCondition(result3)
	end

end

--自定义胜利条件
function LevelBehavior405010205:CustomSuccessCondition1()
	if self.missionState == 13  then
		return true
	elseif self.missionState < 13 then
		return false
	end
end


function LevelBehavior405010205:RemoveEntity(instanceId)
	for i, v in pairs(self.posEntityList)  do
		if instanceId == v then
			self.goldCount = self.goldCount + 1
			self.goldNum	= self.goldNum + 1
			--记录金币收集数量
			BehaviorFunctions.ChangeLevelSubTips(self.tips,2,self.goldNum)
		end
	end
end


--进入区域，并激活下一个区域
function LevelBehavior405010205:EnterArea(triggerInstanceId, areaName, logicName)

	if triggerInstanceId == self.role  and areaName == "Area01" and self.missionState == 0.2 then
		BehaviorFunctions.RemoveEntity(self.checkEntity1)
		self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity2,FightEnum.GuideType.Map_ChallengePaoku,0,false)
		self.pointNum = self.pointNum + 1
	
		BehaviorFunctions.ChangeLevelSubTips(self.tips,1,self.pointNum)
		self.missionState = 2
	end
	if triggerInstanceId == self.role  and areaName == "Area02" and self.missionState == 2 then
		BehaviorFunctions.RemoveEntity(self.checkEntity2)
		self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity3,FightEnum.GuideType.Map_ChallengePaoku,0,false)
		self.pointNum = self.pointNum + 1
		BehaviorFunctions.ChangeLevelSubTips(self.tips,1,self.pointNum)
		self.missionState = 3
	end
	if triggerInstanceId == self.role  and areaName == "Area03" and self.missionState == 3 then
		BehaviorFunctions.RemoveEntity(self.checkEntity3)
		self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity4,FightEnum.GuideType.Map_ChallengePaoku,0,false)
		self.pointNum = self.pointNum + 1
		BehaviorFunctions.ChangeLevelSubTips(self.tips,1,self.pointNum)
		self.missionState = 4
	end
	if triggerInstanceId == self.role  and areaName == "Area04" and self.missionState == 4 then
		BehaviorFunctions.RemoveEntity(self.checkEntity4)
		self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity5,FightEnum.GuideType.Map_ChallengePaoku,0,false)
		self.pointNum = self.pointNum + 1
		BehaviorFunctions.ChangeLevelSubTips(self.tips,1,self.pointNum)
		self.missionState = 5
	end
	if triggerInstanceId == self.role  and areaName == "Area05" and self.missionState == 5 then
		BehaviorFunctions.RemoveEntity(self.checkEntity5)
		self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity6,FightEnum.GuideType.Map_ChallengePaoku,0,false)
		self.pointNum = self.pointNum + 1
		BehaviorFunctions.ChangeLevelSubTips(self.tips,1,self.pointNum)
		self.missionState = 6
	end
	if triggerInstanceId == self.role  and areaName == "Area06" and self.missionState == 6 then
		BehaviorFunctions.RemoveEntity(self.checkEntity6)
		self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity7,FightEnum.GuideType.Map_ChallengePaoku,0,false)
		self.pointNum = self.pointNum + 1
		BehaviorFunctions.ChangeLevelSubTips(self.tips,1,self.pointNum)
		self.missionState = 7
	end
	if triggerInstanceId == self.role  and areaName == "Area07" and self.missionState == 7 then
		BehaviorFunctions.RemoveEntity(self.checkEntity7)
		self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity8,FightEnum.GuideType.Map_ChallengePaoku,0,false)
		self.pointNum = self.pointNum + 1
		BehaviorFunctions.ChangeLevelSubTips(self.tips,1,self.pointNum)
		self.missionState = 8
	end
	if triggerInstanceId == self.role  and areaName == "Area08" and self.missionState == 8 then
		BehaviorFunctions.RemoveEntity(self.checkEntity8)
		self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity9,FightEnum.GuideType.Map_ChallengePaoku,0,false)
		self.pointNum = self.pointNum + 1
		BehaviorFunctions.ChangeLevelSubTips(self.tips,1,self.pointNum)
		self.missionState = 9
	end
	if triggerInstanceId == self.role  and areaName == "Area09" and self.missionState == 9 then
		BehaviorFunctions.RemoveEntity(self.checkEntity9)
		self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity10,FightEnum.GuideType.Map_ChallengePaoku,0,false)
		self.pointNum = self.pointNum + 1
		BehaviorFunctions.ChangeLevelSubTips(self.tips,1,self.pointNum)
		self.missionState = 10
	end
	if triggerInstanceId == self.role  and areaName == "Area10" and self.missionState == 10 then
		BehaviorFunctions.RemoveEntity(self.checkEntity10)
		self.pointNum = self.pointNum + 1
		BehaviorFunctions.ChangeLevelSubTips(self.tips,1,self.pointNum)
		self.missionState = 11
	end

end

function LevelBehavior405010205:OnCountDownFinishEvent(levelId)
	if levelId == self.levelId then
		self.missionState = 1
		self.start = true
	end
end


function LevelBehavior405010205:Remove()

end
