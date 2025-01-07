LevelBehavior102570101 = BaseClass("LevelBehavior102570101",LevelBehaviorBase)
--载具接人玩法

function LevelBehavior102570101.GetGenerates()
	local generates = {2040802,8010012,900040,900050}
	return generates
end


function LevelBehavior102570101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskState = 0
	self.section = 0
	
	self.role = nil
	self.car = nil
	self.spawnCar =nil
	self.npc = nil
	self.carEntity = 2040802
	
	self.guidePointList = {
		[1] = {id = nil, posName = "carPos1", UnLoadDistance = 5},
		[2] = {id = nil, posName = "guidePos1", UnLoadDistance = 5},
		[3] = {id = nil, posName = "guidePos2", UnLoadDistance = 5},
		}
	
	self.storyDialogId = {
		102391101,
		102391501,
		102391201,
		102392201,
		102392301,
		}
	
	self.storyDialogList = {
		[1] = {storyId = 102391101, used = false},
		[2] = {storyId = 102391501, used = false},
		[3] = {storyId = 102391201, used = false},
		[4] = {storyId = 102392201, used = false},
		[5] = {storyId = 102392301, used = false},
		}
	
	
	self.deathCount = 0
	self.enemyCount = 0
	
	self.GuideTypeEnum = {
		Police = FightEnum.GuideType.Rogue_Police,
		Challenge = FightEnum.GuideType.Rogue_Challenge,
		Riddle = FightEnum.GuideType.Rogue_Riddle,
	}
	
	
end


function LevelBehavior102570101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.section == 0 then
		
		--玩家任何车辆都会成为接送载具
		if BehaviorFunctions.GetDrivingEntity(self.role) == self.spawnCar then
			self.car = BehaviorFunctions.GetDrivingEntity(self.role)
		end
		
		--初始化
		if self.taskState == 0 then

			local pos = BehaviorFunctions.GetTerrainPositionP("carPos1",self.levelId)
			local rot = BehaviorFunctions.GetTerrainRotationP("carPos1",self.levelId)
			self.spawnCar = BehaviorFunctions.CreateEntity(self.carEntity,nil,pos.x,pos.y,pos.z,nil,nil,nil)
			BehaviorFunctions.SetEntityEuler(self.spawnCar,rot.x,rot.y,rot.z)
			
			local carGuidePos = Vector3(pos.x,pos.y + 0.8,pos.z)
			--self:AddGuidePointer(self.guidePointList,carGuidePos,1)
			BehaviorFunctions.SetTaskGuidePosition(self.taskId, carGuidePos, nil, nil, false, true, 5)
			
			local pos1 = BehaviorFunctions.GetTerrainPositionP("npcPos1",self.levelId)
			local rot1 = BehaviorFunctions.GetTerrainRotationP("npcPos1",self.levelId)
			self.npc = BehaviorFunctions.CreateEntity(8010012,nil,pos1.x,pos1.y,pos1.z,nil,nil,nil)
			BehaviorFunctions.SetEntityEuler(self.npc,rot1.x,rot1.y,rot1.z)
			
			BehaviorFunctions.ShowTip(102560101)
			
			self.taskState = 1
		end
		

		if self.taskState == 1 then
			
			local dis = BehaviorFunctions.GetDistanceFromTarget(self.role,self.spawnCar)
			if dis <=25 then
				self:PlayStoryDialog(4)
			end
			
			if self.car then
				self.section = 1
				
				self:PlayStoryDialog(5)
				
				self:UnloadGuidePointer()
				
				BehaviorFunctions.SetDisableGetOffCar(self.car,true)
			
				local guidePos1 = BehaviorFunctions.GetTerrainPositionP("guidePos1",self.levelId)
				--self:AddGuidePointer(self.guidePointList,guidePos1,1)
				BehaviorFunctions.SetTaskGuidePosition(self.taskId, guidePos1, nil, nil, true, true, 5)
				
				BehaviorFunctions.ShowTip(102560102)
				self.taskState = 2
			end
		end
	end
	
	--玩家已经上车 任务流程开始
	if self.section == 1 then
		
		--抵达第一个点位
		if self.taskState == 2 and self.car then
			local rolePos = BehaviorFunctions.GetPositionP(self.role)
			local guidePos1 = BehaviorFunctions.GetTerrainPositionP("guidePos1",self.levelId)
			local dis = BehaviorFunctions.GetDistanceFromPos(rolePos,guidePos1)
			
			if dis < 15 then
				BehaviorFunctions.StartStoryDialog(self.storyDialogId[1])
				
				BehaviorFunctions.ShowTip(102560103)
				
				self.taskState = 3
			end		
		end
		
		--接收商人
		if self.taskState == 3 and self.car then
			BehaviorFunctions.DoLookAtTargetImmediately(self.npc,self.car)
			if BehaviorFunctions.GetEntityState(self.npc) ~= FightEnum.EntityState.Move then
				BehaviorFunctions.DoSetEntityState(self.npc,FightEnum.EntityState.Move)
			end
			local disBetweenNPC = BehaviorFunctions.GetDistanceFromTarget(self.npc,self.car)

			if disBetweenNPC < 3 then
				BehaviorFunctions.CarBrake(self.car,false)
				BehaviorFunctions.RemoveEntity(self.npc)
				
				local guidePos2 = BehaviorFunctions.GetTerrainPositionP("guidePos2",self.levelId)
				--self:UnloadGuidePointer()
				--self:AddGuidePointer(self.guidePointList,guidePos2,2)
				BehaviorFunctions.SetTaskGuidePosition(self.taskId, guidePos2, nil, nil, true, true, 5)
				self.taskState = 4
			end
		end
		
		--途中对话
		if self.taskState == 4 and self.car then
			local rolePos = BehaviorFunctions.GetPositionP(self.role)
			local guidePos2 = BehaviorFunctions.GetTerrainPositionP("guidePos2",self.levelId)
			local dis = BehaviorFunctions.GetDistanceFromPos(rolePos,guidePos2)
			
			if dis < 190 then
				BehaviorFunctions.StartStoryDialog(self.storyDialogId[2])
				self.taskState = 5
			end
		end
		
		--到达战斗区
		if self.taskState == 5 and self.car then
			local rolePos = BehaviorFunctions.GetPositionP(self.role)
			local guidePos2 = BehaviorFunctions.GetTerrainPositionP("guidePos2",self.levelId)
			local dis = BehaviorFunctions.GetDistanceFromPos(rolePos,guidePos2)

			if dis < 20 then
				
				BehaviorFunctions.HideTip(102560103)
				
				BehaviorFunctions.StartStoryDialog(self.storyDialogId[3])
				BehaviorFunctions.SetDisableGetOffCar(self.car,false)
				
				--self:UnloadGuidePointer()
				
				self.section = 2
				self.taskState = 6
			end
		end
	end
	
	--关卡结束
	if self.section == 2 then
		if self.taskState == 6 then
			BehaviorFunctions.FinishLevel(self.levelId)
			self.taskState = 999
		end
	end
end


function LevelBehavior102570101:AddGuidePointer(guideList,position,index)
	for i,v in ipairs(guideList) do
		if i == index and v.id == nil then
			v.id = BehaviorFunctions.CreateEntity(2001,nil,position.x,position.y,position.z)
			BehaviorFunctions.AddEntityGuidePointer(v.id,4,1,false)
		end
		
		--移除其他图标
		if i ~= index and v.id ~= nil then
			v.id = nil
		end
	end
end


function LevelBehavior102570101:UnloadGuidePointer()
	for i,v in ipairs(self.guidePointList) do 
		if v.id ~= nil then
			BehaviorFunctions.RemoveEntity(v.id)
		end
	end
end


function LevelBehavior102570101:PlayStoryDialog(index)
	for i,v in ipairs(self.storyDialogList) do
		if i == index and v.used == false then
			BehaviorFunctions.StartStoryDialog(v.storyId)
			v.used = true
			break
		end
	end
end