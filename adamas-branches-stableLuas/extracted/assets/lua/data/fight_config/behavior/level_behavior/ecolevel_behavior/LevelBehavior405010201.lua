LevelBehavior405010201 = BaseClass("LevelBehavior405010201",LevelBehaviorBase)


function LevelBehavior405010201.GetGenerates()
	local generates = {2030407,2030408,22002}
	return generates
end

function LevelBehavior405010201:__init(fight)
	self.fight = fight
end


function LevelBehavior405010201:Init()
	self.logicId = "OpenWorldParkour01"
	self.bornPos = "born"
	self.role = nil
	self.currentWave = 0 --当前波次
	self.missionState = 0
	self.goldCount = 0  --拾取的道具数量
	self.posAmount = 55   --金币总数
	self.posEntityList = {}  --金币实体列表
	self.checkWhite = 2030408
	self.pointNum = 0
	self.goldNum = 0
	self.camera = false
	self.creatFrame = 0
	
	-------------------通用关卡函数引用----------------------
	self.LevelCommon = BehaviorFunctions.CreateBehavior("LevelCommonFunction",self)
	self.LevelCommon.levelId = self.levelId
	
end


function LevelBehavior405010201:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	--通用行为预设
	self.LevelCommon:Update()

	if self.missionState == 0 then

		self.LevelCommon:SetAsChallengeLevel("限时到达终点")
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
		
		--创建可交互的金币
		for i = 1, self.posAmount do
			local posName = "Collect"..i
			local pos = BehaviorFunctions.GetTerrainPositionP(posName,self.levelId)
			if pos~= nil then
				local instanceId = BehaviorFunctions.CreateEntityByPosition(2030407,nil,posName,nil,self.levelId,self.levelId)
				table.insert(self.posEntityList,instanceId)	
			end
		end
		--创建引导点
		BehaviorFunctions.ActiveSceneObj("Obstacle",true,self.levelId)
		self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity1,FightEnum.GuideType.Transport,0,false)
		BehaviorFunctions.ShowTip(405010201)
		
		--设置tips参数为0
		BehaviorFunctions.ChangeSubTipsDesc(1, 405010201,self.pointNum)
		BehaviorFunctions.ChangeSubTipsDesc(2, 405010201,self.goldNum)
		self.missionState = 1
		--摄像头调用
		if self.camera == false then
			self.LevelCommon:LevelCameraLookAtPos(22002,40,nil,"Collect3",0.5,0.5)
			self.camera = true
		end
		
	end
	if self.missionState == 7 then
		self.creatFrame = self.time
		self.missionState = 8
	end
	
	if self.missionState == 8 and self.time - self.creatFrame > 30 then
		--创建宝箱
		BehaviorFunctions.ChangeEcoEntityCreateState(2005001119001, true)
		self.missionState = 9
	end
	
	--获取自定义胜利条件是否满足
	local result1 = self:CustomSuccessCondition1()
	--将上述条件作为胜利条件
	self.LevelCommon:LevelSuccessCondition(result1)

	
	--失败条件：超出时间限制
	local result2 = self.LevelCommon:FailCondition_TimeLimit(60)
	--将上述条件作为失败条件
	self.LevelCommon:LevelFailCondition(result2)
		
	
end


function LevelBehavior405010201:RemoveEntity(instanceId)
    for i, v in pairs(self.posEntityList)  do
	   if instanceId == v then
	      self.goldCount = self.goldCount + 1
		  self.goldNum	= self.goldNum + 1
		  BehaviorFunctions.ChangeSubTipsDesc(2, 405010201,self.goldNum)
	   end
	end				
end


--进入区域，并激活下一个区域
function LevelBehavior405010201:EnterArea(triggerInstanceId, areaName, logicName)

	if triggerInstanceId == self.role  and areaName == "Area01" and self.missionState == 1 then
		BehaviorFunctions.RemoveEntity(self.checkEntity1)
		self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity2,FightEnum.GuideType.Transport,0,false)
		self.pointNum = self.pointNum + 1
		BehaviorFunctions.ChangeSubTipsDesc(1, 405010201,self.pointNum)
		self.missionState = 2
	end	
	if triggerInstanceId == self.role  and areaName == "Area02" and self.missionState == 2 then
		BehaviorFunctions.RemoveEntity(self.checkEntity2)
		self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity3,FightEnum.GuideType.Transport,0,false)
		self.pointNum = self.pointNum + 1
		BehaviorFunctions.ChangeSubTipsDesc(1, 405010201,self.pointNum)
		self.missionState = 3
	end	
	if triggerInstanceId == self.role  and areaName == "Area03" and self.missionState == 3 then
		BehaviorFunctions.RemoveEntity(self.checkEntity3)
		self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity4,FightEnum.GuideType.Transport,0,false)
		self.pointNum = self.pointNum + 1
		BehaviorFunctions.ChangeSubTipsDesc(1, 405010201,self.pointNum)
		self.missionState = 4
	end
	if triggerInstanceId == self.role  and areaName == "Area04" and self.missionState == 4 then
		BehaviorFunctions.RemoveEntity(self.checkEntity4)
		self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity5,FightEnum.GuideType.Transport,0,false)
		self.pointNum = self.pointNum + 1
		BehaviorFunctions.ChangeSubTipsDesc(1, 405010201,self.pointNum)
		self.missionState = 5
	end
	if triggerInstanceId == self.role  and areaName == "Area05" and self.missionState == 5 then
		BehaviorFunctions.RemoveEntity(self.checkEntity5)
		self.checkPointer = BehaviorFunctions.AddEntityGuidePointer(self.checkEntity6,FightEnum.GuideType.Transport,0,false)
		self.pointNum = self.pointNum + 1
		BehaviorFunctions.ChangeSubTipsDesc(1, 405010201,self.pointNum)
		self.missionState = 6
	end
	if triggerInstanceId == self.role  and areaName == "Area06" and self.missionState == 6 then
		self.pointNum = self.pointNum + 1
		BehaviorFunctions.ChangeSubTipsDesc(1, 405010201,self.pointNum)
		BehaviorFunctions.RemoveEntity(self.checkEntity6)
		self.missionState = 7
	end		
end

--自定义胜利条件
function LevelBehavior405010201:CustomSuccessCondition1()
	if self.missionState == 9 then
		return true
	elseif self.missionState < 9 then
		return false			
	end
end


function LevelBehavior405010201:Remove()

end


