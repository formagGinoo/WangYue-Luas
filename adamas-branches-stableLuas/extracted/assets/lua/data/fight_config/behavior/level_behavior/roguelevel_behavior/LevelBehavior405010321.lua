LevelBehavior405010321 = BaseClass("LevelBehavior405010321",LevelBehaviorBase)
--出租陷阱
function LevelBehavior405010321:__init(fight)
	self.fight = fight
end


function LevelBehavior405010321.GetGenerates()
	local generates = {2040802,2040803,900040,900050,900070,8011001}
	return generates
end


function LevelBehavior405010321:Init()
	self.role = 0
	self.initState = 0
	self.missionState = 0
	self.createState = 0
	self.tipState = 0
	
	self.car = 0
	self.carCur = 0 --上车后存车的实体
	self.pos = 0
	self.npc = 0
	self.monster1 = 0
	self.monster2 = 0
	self.position = 0
	self.guideEntity = 0
	self.getOffCarGuideEntity = 0
	
	self.monsterNum = 0
	self.monLev = 5
	
	self.monsterList =
	{
		[1] = {bornPos = "R3Mon2",entityId = 900070},
		[2] = {bornPos = "R3Mon3",entityId = 900040},
		[3] = {bornPos = "R3Mon4",entityId = 900050},
	}
	
	------追踪标--- -----------------------------------------------------------------------------------------------------
	self.guide = nil
	self.guideEntity = nil
	self.guideDistance = 70
	self.guidePos = nil
	self.GuideTypeEnum = {
		Police = FightEnum.GuideType.Rogue_Police,
		Challenge = FightEnum.GuideType.Rogue_Challenge,
		Riddle = FightEnum.GuideType.Rogue_Riddle,
	}
	----------------
	
	self.dialogList =
	{
		[1] = {id = 602060101},
		[2] = {id = 602060201},
		[3] = {id = 602060301},
		[4] = {id = 602060401},
	}
	
end

function LevelBehavior405010321:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	--获取设置当前驾驶车实体，npc上车前任意车辆都行，上车后存carCur
	if BehaviorFunctions.GetDrivingEntity(self.role) then
		self.car = BehaviorFunctions.GetDrivingEntity(self.role)
	end

	--关卡追踪标
	if self.initState < 2 then
		local pos = BehaviorFunctions.GetTerrainPositionP("R3Start",10020005,"RogueDrive")
		self:RogueGuidePointer(pos,self.guideDistance,self.GuideTypeEnum.Police)
	end
	
	--初始创
	if self.initState == 0 then
		local pos = BehaviorFunctions.GetTerrainPositionP("R3Mon1",10020005,"RogueDrive")
		local lookPos = BehaviorFunctions.GetTerrainPositionP("R3Start",10020005,"RogueDrive")
		self.npc = BehaviorFunctions.CreateEntity(8011001,nil,pos.x,pos.y,pos.z,lookPos.x,lookPos.y,lookPos.z,self.levelId)
		BehaviorFunctions.ShowTip(40000004) --开车前往上车点
		BehaviorFunctions.ShowCommonTitle(7,"已发现城市威胁",true)
		self.initState = 1
	end
	
	if self.initState == 1 then
		if BehaviorFunctions.CheckEntityDrive(self.role) == true then
			local pos1 = BehaviorFunctions.GetTerrainPositionP("R3Start",10020005,"RogueDrive")
			local pos2 = BehaviorFunctions.GetPositionP(self.car)
			local dis = BehaviorFunctions.GetDistanceFromPos(pos1,pos2)
			if dis < 2 then
				BehaviorFunctions.StartStoryDialog(self.dialogList[1].id)
				BehaviorFunctions.CarBrake(self.car,true)
				self.initState = 2
			end
		end
	end

	--上车点对话播完后,模拟上车
	if self.missionState == 1 then
		BehaviorFunctions.DoLookAtTargetImmediately(self.npc,self.car)
		if BehaviorFunctions.GetEntityState(self.npc) ~= FightEnum.EntityState.Move then
			BehaviorFunctions.DoSetEntityState(self.npc,FightEnum.EntityState.Move)
		end
		local distance = BehaviorFunctions.GetDistanceFromTarget(self.npc,self.car)
		if distance < 3 then
			self.carCur = self.car --存上车后的车实体
			BehaviorFunctions.CarBrake(self.carCur,false)
			BehaviorFunctions.ShowTip(40000005) --载乘客到达目的地
			local guidepos = BehaviorFunctions.GetTerrainPositionP("R3EndPos1",10020005,"RogueDrive")
			self.guideEntity = BehaviorFunctions.CreateEntity(2001,nil,guidepos.x,guidepos.y,guidepos.z,nil,nil,nil,self.levelId)
			self.guidePointer = BehaviorFunctions.AddEntityGuidePointer(self.guideEntity,self.GuideTypeEnum.Police,0,false)
			BehaviorFunctions.RemoveEntity(self.npc)
			BehaviorFunctions.RemoveEntityGuidePointer(self.guide) --移除上车点追踪
			BehaviorFunctions.StartStoryDialog(self.dialogList[2].id)
			self.missionState = 2
		end
	end
	
	--过程、据点刷怪
	if self.missionState == 2 then
		--下车后追踪+tips指引回到车辆
		if BehaviorFunctions.CheckEntityDrive(self.role) == true then
			if self.tipState == 1 then
				--移除载具追踪
				if self.getOffCarGuideEntity and self.getOffCarGuidePointer then
					BehaviorFunctions.RemoveEntity(self.getOffCarGuideEntity)
					BehaviorFunctions.RemoveEntityGuidePointer(self.getOffCarGuidePointer)
				end
				--创建目的地追踪
				self.guidePointer = BehaviorFunctions.AddEntityGuidePointer(self.guideEntity,self.GuideTypeEnum.Police,0,false)
				self.tipState = 0
			end

		elseif BehaviorFunctions.CheckEntityDrive(self.role) == false then
			if self.tipState == 0 then
				local guidepos = BehaviorFunctions.GetPositionP(self.carCur)
				self.getOffCarGuideEntity = BehaviorFunctions.CreateEntity(2001,nil,guidepos.x,guidepos.y,guidepos.z,nil,nil,nil,self.levelId)
				self.getOffCarGuidePointer = BehaviorFunctions.AddEntityGuidePointer(self.getOffCarGuideEntity,self.GuideTypeEnum.Police,0,false)
				BehaviorFunctions.ShowTip(40000009)--返回车辆以继续
				--移除目的地追踪
				BehaviorFunctions.RemoveEntityGuidePointer(self.guidePointer)
				self.tipState = 1
			end
		end
		
		--创怪
		local distance = BehaviorFunctions.GetDistanceFromTarget(self.carCur,self.guideEntity)
		if distance < 50 then
			if self.createState == 0 then
				self:CreateMonster(self.monsterList)
				self.monsterNum = #self.monsterList
				self.createState = 1
			end
			--到达目的地
			if distance < 2 then
				self.missionState = 3
			end
		end	
	end
	
	if self.missionState == 3 then
		BehaviorFunctions.StartStoryDialog(self.dialogList[3].id)
		BehaviorFunctions.RemoveEntityGuidePointer(self.guidePointer)
		BehaviorFunctions.CarBrake(self.carCur,true)
		BehaviorFunctions.GetOffCar(self.carCur)
		local getOffCarMonPos = BehaviorFunctions.GetTerrainPositionP("R3Mon5",10020005,"RogueDrive")
		self.monster2 = BehaviorFunctions.CreateEntity(900070,nil,getOffCarMonPos.x,getOffCarMonPos.y,getOffCarMonPos.z,nil,nil,nil,self.levelId,self.monLev)
		self.monsterNum = self.monsterNum + 1
		BehaviorFunctions.SetEntityValue(self.monster2,"haveWarn",false)
		BehaviorFunctions.DoLookAtTargetImmediately(self.monster2,self.role)
		for k,v in pairs(self.monsterList) do
			BehaviorFunctions.SetEntityValue(v.instanceId,"haveWarn",false)
			BehaviorFunctions.DoLookAtTargetImmediately(v.instanceId,self.role)
		end
		BehaviorFunctions.ShowTip(40000003) --击败所有敌人
		BehaviorFunctions.ChangeSubTipsDesc(1,40000003,self.monsterNum)
		self.missionState = 4
	end
	
	if self.missionState == 4 then
		if self.monsterNum == 0 then
			--rogue结束
			BehaviorFunctions.ShowBlackCurtain(true,1)
			BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1)
			BehaviorFunctions.AddDelayCallByFrame(90,self,self.EndRogue)
			self.missionState = 11
		end
	end
end

----车
--function LevelBehavior405010321:ExtraEnterArea(triggerInstanceId, areaName, logicName)
	--if triggerInstanceId == self.car and areaName == "R3Enter" then 
		--if self.initState == 1 then
			--if BehaviorFunctions.CheckEntityDrive(self.role) == true then
				--BehaviorFunctions.StartStoryDialog(self.dialogList[1].id)
				--BehaviorFunctions.CarBrake(self.car,true)
				--self.initState = 2
			--end
		--end
	--end
--end

--角色
function LevelBehavior405010321:EnterArea(triggerInstanceId, areaName, logicName)
	if triggerInstanceId == self.role and areaName == "R3Enter" then
		if self.initState == 1 then
			if BehaviorFunctions.CheckEntityDrive(self.role) == false then
				BehaviorFunctions.ShowTip(40000010) --请开车前往
			end
		end
	end
end

--刷怪
function LevelBehavior405010321:CreateMonster(monsterList)
	local MonsterId = 0
	for a = 1,#monsterList,1 do
		if monsterList[a].lookatposName then
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].bornPos,10020005,"RogueDrive")
			local lookatposP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].lookatPos,10020005, "RogueDrive")
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].entityId,nil,posP.x,posP.y,posP.z,lookatposP.x,nil,lookatposP.z,self.levelId,self.monLev)
			--BehaviorFunctions.SetEntityValue(MonsterId,"haveWarn",true)
			monsterList[a].instanceId = MonsterId
		else
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].bornPos, 10020005, "RogueDrive")
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].entityId,nil,posP.x,posP.y,posP.z,nil,nil,nil,self.levelId,self.monLev)
			--BehaviorFunctions.SetEntityValue(MonsterId,"haveWarn",false)
			BehaviorFunctions.DoLookAtTargetImmediately(MonsterId,self.role)
			monsterList[a].instanceId = MonsterId
		end
	end
end

function LevelBehavior405010321:Death(instanceId, isFormationRevive)
	if instanceId == self.monster2 then
		self.monsterNum = self.monsterNum - 1
		BehaviorFunctions.ChangeSubTipsDesc(1,40000003,self.monsterNum)
	end
	
	for k,v in pairs(self.monsterList) do
		if v.instanceId == instanceId then
			self.monsterNum = self.monsterNum - 1
			BehaviorFunctions.ChangeSubTipsDesc(1,40000003,self.monsterNum)
		end
	end
end

function LevelBehavior405010321:EndRogue()
	BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
	BehaviorFunctions.HideTip()
	BehaviorFunctions.RemoveLevel(self.levelId)
	BehaviorFunctions.SetRoguelikeEventCompleteState(self.rogueEventId,true)
end

--肉鸽追踪
function LevelBehavior405010321:RogueGuidePointer(guidePos,guideDistance,guideType)
	local playerPos = BehaviorFunctions.GetPositionP(self.role)
	local distance = BehaviorFunctions.GetDistanceFromPos(playerPos,guidePos)
	if distance <= guideDistance then
		if not self.guide then
			self.guideEntity = BehaviorFunctions.CreateEntity(2001,nil,guidePos.x,guidePos.y,guidePos.z,nil,nil,nil,self.levelId)
			self.guide = BehaviorFunctions.AddEntityGuidePointer(self.guideEntity,guideType,0,false)
		end
	else
		--移除追踪标空实体
		if self.guideEntity and BehaviorFunctions.CheckEntity(self.guideEntity) then
			BehaviorFunctions.RemoveEntity(self.guideEntity)
			self.guideEntity = nil
		end
		--移除追踪标
		BehaviorFunctions.RemoveEntityGuidePointer(self.guide)
		self.guide = nil
	end
end

function LevelBehavior405010321:StoryEndEvent(dialogId)
	if dialogId == self.dialogList[1].id then
		self.missionState = 1
	end
end