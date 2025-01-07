LevelBehavior500502001 = BaseClass("LevelBehavior500502001",LevelBehaviorBase)
--中据点含月灵
function LevelBehavior500502001.GetGenerates()
	local generates = {2010604,720305031,720305032,2030504,791004000,790007000,790008000,790012000,790013000,790014000,791012000}
	return generates
end


function LevelBehavior500502001:Init()
	self.missionState = 0
	self.tipsState = 0
	self.interactState = 0
	self.isCount = false

	self.time = nil
	self.frame = nil
	self.role = nil
	
	self.tipsId1 = 500501001
	self.tipsId2 = 500501002
	
	self.disEmptyRoof = 0
	self.guideEmptyRoof = 0
	self.guidePointerRoof = 0
	
	self.monsterList1 =
	{
		{id = 790007000 ,posName = "Monster1" ,wave = 1 ,engage = false},
		{id = 790014000 ,posName = "Monster2" ,wave = 1 ,engage = false},
		--{id = 790007000 ,posName = "Monster3" ,wave = 1 ,engage = false},
		--{id = 790012000 ,posName = "Monster4" ,wave = 1 ,engage = false},
		{id = 790012000 ,posName = "Monster5" ,wave = 1 ,engage = false},
		{id = 790013000 ,posName = "Monster6" ,wave = 1 ,engage = false},
	}

	self.monsterList2 =
	{
		{id = 790008000 ,posName = "Monster7" ,wave = 1 ,engage = false},
		{id = 790013000 ,posName = "Monster8" ,wave = 1 ,engage = false},
		{id = 791004000 ,posName = "Monster9" ,wave = 1 ,engage = false},
		{id = 790013000 ,posName = "Monster10" ,wave = 1 ,engage = false},
	}
	
	--self.monsterList =
	--{
		--{id = 790014000 ,posName = "Monster1" ,wave = 1 ,engage = false},
		--{id = 790014000 ,posName = "Monster2" ,wave = 1 ,engage = false},
		--{id = 790007000 ,posName = "Monster3" ,wave = 1 ,engage = false},
		--{id = 790012000 ,posName = "Monster4" ,wave = 1 ,engage = false},
		--{id = 790012000 ,posName = "Monster5" ,wave = 1 ,engage = false},
		--{id = 790013000 ,posName = "Monster6" ,wave = 1 ,engage = false},
		--{id = 791004000 ,posName = "Monster7" ,wave = 1 ,engage = false},
		--{id = 790013000 ,posName = "Monster8" ,wave = 1 ,engage = false},
		--{id = 791004000 ,posName = "Monster9" ,wave = 1 ,engage = false},
		--{id = 790013000 ,posName = "Monster10" ,wave = 1 ,engage = false},
	--}
	
	self.FxShieldEcoId = 3003001020003
	self.FxPrisonLinelockId = 0
	self.FxShieldId = 0
	
	self.LevelCommon = BehaviorFunctions.CreateBehavior("LevelCommonFunction",self)
	self.LevelCommon.levelId = self.levelId
	self.LevelCommon.monsterLevelBias =
	{
		[FightEnum.EntityNpcTag.Monster] = 0,
		[FightEnum.EntityNpcTag.Elite] = 0,
		[FightEnum.EntityNpcTag.Boss] = 0,
	} 
end

function LevelBehavior500502001:Update()
	self.time = BehaviorFunctions.GetFightFrame()/30
	self.frame = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.LevelCommon:Update() --执行关卡通用行为树的每帧运行
	
	if self.interactState == 0 then
		self.FxShieldId = BehaviorFunctions.GetEcoEntityByEcoId(self.FxShieldEcoId)
		if self.FxShieldId then
			BehaviorFunctions.SetEntityWorldInteractState(self.FxShieldId,false)
			self.interactState = 1
		end
	end
	
	if self.missionState == 0 then
		self.FxPrisonLinelockId = BehaviorFunctions.CreateEntityByPosition(2010604,nil,"PrisonLinelockPos",nil,500502001,self.levelId)
		
		--创建怪物
		self.monsterListInfo1 = self.LevelCommon:LevelCreateMonster(self.monsterList1)
		self.monsterListInfo2 = self.LevelCommon:LevelCreateMonster(self.monsterList2)
		self.xiaojiaoId = BehaviorFunctions.CreateEntityByPosition(791012000,nil,"YuelingPos",nil,500502001,self.levelId)
		BehaviorFunctions.RemoveBehavior(self.xiaojiaoId)  --让石龙不动
		if BehaviorFunctions.HasBuffKind(self.xiaojiaoId,900000045) == false then
			BehaviorFunctions.AddBuff(self.xiaojiaoId,self.xiaojiaoId,900000045)    --加霸体防止打断
		end
		if BehaviorFunctions.HasBuffKind(self.xiaojiaoId,900000007) == false then
			BehaviorFunctions.AddBuff(self.xiaojiaoId,self.xiaojiaoId,900000007)    --加无敌防止打死
		end
		BehaviorFunctions.DoMagic(1,self.xiaojiaoId,900000001) --免疫受击
		BehaviorFunctions.DoMagic(1,self.xiaojiaoId,900000013) --免疫锁定
		BehaviorFunctions.DoMagic(1,self.xiaojiaoId,900000020) --免疫受击朝向
		BehaviorFunctions.DoMagic(1,self.xiaojiaoId,900000022) --强制左倾
		BehaviorFunctions.DoMagic(1,self.xiaojiaoId,900000023) --免疫伤害
		BehaviorFunctions.DoMagic(1,self.xiaojiaoId,900000059) --免疫强制位移
		BehaviorFunctions.DoMagic(1,self.xiaojiaoId,900000070) --绝对免疫受击及免疫霸体受击位移
		
		self.monitorId1 = BehaviorFunctions.CreateEntityByPosition(2030504,nil,"Monitor1",nil,500502001,self.levelId)
		self.monitorId2 = BehaviorFunctions.CreateEntityByPosition(2030504,nil,"Monitor2",nil,500502001,self.levelId)
		self.trapId1 = BehaviorFunctions.CreateEntityByPosition(720305031,nil,"Trap1",nil,500502001,self.levelId)
		self.trapId2 = BehaviorFunctions.CreateEntityByPosition(720305032,nil,"Trap2",nil,500502001,self.levelId)
		self.disEmptyRoof = BehaviorFunctions.CreateEntityByPosition(2001,nil,"GuidePosRoof",nil,500502001,self.levelId)
		
		BehaviorFunctions.ShowMapArea(self.levelId,true)
		BehaviorFunctions.ShowLevelEnemy(self.levelId,true)
		self.missionState = 1
		
	elseif self.missionState == 1 then
		local x,y,z = BehaviorFunctions.GetPosition(self.monsterListInfo1.list[1].instanceId)  --PositionP返回的表是地址引用，会随怪物位置改变而变，改为position（x,y,z)后解决巡逻往返问题
		--local routePos1 = BehaviorFunctions.GetTerrainPositionP("Monster10Route1",self.levelId,"Stronghold_Level500502001")
		local routePos2 = BehaviorFunctions.GetTerrainPositionP("Monster1Route2",self.levelId)
		local patrolPosList = {Vec3.New(x,y,z),routePos2}
		BehaviorFunctions.SetEntityValue(self.monsterListInfo1.list[1].instanceId,"peaceState",1)  -- 1是巡逻
		BehaviorFunctions.SetEntityValue(self.monsterListInfo1.list[1].instanceId,"patrolPositionList",patrolPosList)
		BehaviorFunctions.SetEntityValue(self.monsterListInfo1.list[1].instanceId,"canReturn",true)
		
		local x,y,z = BehaviorFunctions.GetPosition(self.monsterListInfo1.list[2].instanceId)  
		--local routePos1 = BehaviorFunctions.GetTerrainPositionP("Monster10Route1",self.levelId,"Stronghold_Level500502001")
		local routePos2 = BehaviorFunctions.GetTerrainPositionP("Monster2Route2",self.levelId)
		local patrolPosList = {Vec3.New(x,y,z),routePos2}
		BehaviorFunctions.SetEntityValue(self.monsterListInfo1.list[2].instanceId,"peaceState",1)  -- 1是巡逻
		BehaviorFunctions.SetEntityValue(self.monsterListInfo1.list[2].instanceId,"patrolPositionList",patrolPosList)
		BehaviorFunctions.SetEntityValue(self.monsterListInfo1.list[2].instanceId,"canReturn",true)
		
		local x,y,z = BehaviorFunctions.GetPosition(self.monsterListInfo1.list[3].instanceId)  --5改的3
		--local routePos1 = BehaviorFunctions.GetTerrainPositionP("Monster10Route1",self.levelId,"Stronghold_Level500502001")
		local routePos2 = BehaviorFunctions.GetTerrainPositionP("Monster5Route2",self.levelId)
		local patrolPosList = {Vec3.New(x,y,z),routePos2}
		BehaviorFunctions.SetEntityValue(self.monsterListInfo1.list[3].instanceId,"peaceState",1)  -- 1是巡逻
		BehaviorFunctions.SetEntityValue(self.monsterListInfo1.list[3].instanceId,"patrolPositionList",patrolPosList)
		BehaviorFunctions.SetEntityValue(self.monsterListInfo1.list[3].instanceId,"canReturn",true)
		
		local x,y,z = BehaviorFunctions.GetPosition(self.monsterListInfo2.list[4].instanceId)  
		--local routePos1 = BehaviorFunctions.GetTerrainPositionP("Monster10Route1",self.levelId,"Stronghold_Level500502001")
		local routePos2 = BehaviorFunctions.GetTerrainPositionP("Monster10Route2",self.levelId)
		local patrolPosList = {Vec3.New(x,y,z),routePos2}
		BehaviorFunctions.SetEntityValue(self.monsterListInfo2.list[4].instanceId,"peaceState",1)  -- 1是巡逻
		BehaviorFunctions.SetEntityValue(self.monsterListInfo2.list[4].instanceId,"patrolPositionList",patrolPosList)
		BehaviorFunctions.SetEntityValue(self.monsterListInfo2.list[4].instanceId,"canReturn",true)
		
		self.missionState = 2
		
	elseif self.missionState == 2 then
		--胜利条件：该怪物组内怪物都死亡
		local result1 = self.LevelCommon:SuccessCondition_DefeatAllEnemy(self.monsterListInfo1)
		local result2 = self.LevelCommon:SuccessCondition_DefeatAllEnemy(self.monsterListInfo2)
		
		if result1 == true and result2 == false then
			local dis = BehaviorFunctions.GetDistanceFromTargetWithY(self.role,self.disEmptyRoof)
			if dis > 20 then
				if not BehaviorFunctions.CheckEntity(self.guideEmptyRoof) or not self.guidePointerRoof then
					self.guideEmptyRoof = BehaviorFunctions.CreateEntityByPosition(2001,nil,"GuidePosRoof",nil,500502001,self.levelId)
					self.guidePointerRoof = BehaviorFunctions.AddEntityGuidePointer(self.guideEmptyRoof,FightEnum.GuideType.Map_strongholdYue)
				end
				
			elseif dis < 15 then
				if self.guideEmptyRoof then
					BehaviorFunctions.RemoveEntityGuidePointer(self.guidePointerRoof)
					BehaviorFunctions.RemoveEntity(self.guideEmptyRoof)
				end
			end
		end
		
		if result1 == true and result2 == true then
			if self.guidePointerRoof then
				BehaviorFunctions.RemoveEntityGuidePointer(self.guidePointerRoof)
			end
			BehaviorFunctions.RemoveLevelTips(self.countTips)
			self.guideTips = BehaviorFunctions.AddLevelTips(self.tipsId2,self.levelId)
			self.guidePointer = BehaviorFunctions.AddEntityGuidePointer(self.xiaojiaoId,FightEnum.GuideType.Map_strongholdYue)
			BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.CityThreatenEnd,"已清除城市威胁",true)
			
			--展示月灵镜头
			local fp1 = BehaviorFunctions.GetTerrainPositionP("CameraPos",self.levelId)
			self.empty1 = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z,nil,nil,nil,self.levelId)
			local targetPos = BehaviorFunctions.GetTerrainPositionP("YuelingPos",self.levelId)
			self.empty2 = BehaviorFunctions.CreateEntity(2001,nil,targetPos.x,targetPos.y,targetPos.z,nil,nil,nil,self.levelId)
			
			BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty2)
			self.levelCam = BehaviorFunctions.CreateEntity(22005,nil,fp1.x,fp1.y,fp1.z,targetPos.x,targetPos.y,targetPos.z,self.levelId)
			BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.empty1)
			BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty2)

			
			--延迟移除目标和镜头
			BehaviorFunctions.AddDelayCallByFrame(80,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
			BehaviorFunctions.AddDelayCallByFrame(80,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty1)
			BehaviorFunctions.AddDelayCallByFrame(80,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty2)
			--移除囚禁特效
			BehaviorFunctions.AddDelayCallByFrame(30,self,self.Assignment,"missionState",4)
			BehaviorFunctions.AddDelayCallByFrame(80,self,self.Assignment,"missionState",6)
			
			--for i,v in pairs(FightEnum.KeyEvent) do
				--BehaviorFunctions.ForbidKey(v,true)
			--end
			BehaviorFunctions.SetFightPanelVisible("0")
			self.missionState = 3
			
		end
		
	elseif self.missionState == 4 then
		BehaviorFunctions.DoEntityAudioPlay(self.xiaojiaoId,"broken2",false)
		BehaviorFunctions.RemoveEntity(self.FxPrisonLinelockId)
		self.missionState = 5

	elseif self.missionState == 6 then
		--for i,v in pairs(FightEnum.KeyEvent) do
			--BehaviorFunctions.ForbidKey(v,false)
		--end
		BehaviorFunctions.SetFightPanelVisible("-1")
		BehaviorFunctions.SetEntityWorldInteractState(self.FxShieldId,true)
		self.missionState = 7
	end
	
	
	if self.tipsState == 0 then
		local pos1 = BehaviorFunctions.GetTerrainPositionP("MidPos1",10020005,"StrongholdEvent")
		local pos2 = BehaviorFunctions.GetPositionP(self.role)
		local dis = BehaviorFunctions.GetDistanceFromPos(pos1,pos2)
		if dis <= 40 then
			self.tipsState = 1
		end
	end

	if self.tipsState == 1 then
		BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.CityThreatenStart,"发现城市威胁！",nil)
		BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.ChallengeInfo,"肃清据点并解救月灵",nil)

		--开启剩余敌人数量显示
		--self.LevelCommon:ShowEnemyRemainTips(true)
		self.countTips = BehaviorFunctions.AddLevelTips(self.tipsId1,self.levelId)
		BehaviorFunctions.ChangeLevelSubTips(self.countTips,1,self.LevelCommon.totalDeadMonsterNum.."/"..self.LevelCommon.totalMonsterNum)
		self.tipsState = 2
	end
end

function LevelBehavior500502001:Death(instanceId, isFormationRevive)

end


function LevelBehavior500502001:WorldInteractClick(uniqueId, instanceId)
	if instanceId == self.FxShieldId then
		BehaviorFunctions.RemoveLevelTips(self.guideTips)
		BehaviorFunctions.FinishLevel(self.levelId)
	end
end

function LevelBehavior500502001:RemoveLevel(levelId)
	if levelId == self.levelId then
		if self.countTips then
			BehaviorFunctions.RemoveLevelTips(self.countTips)
		end
		if self.guideTips then
			BehaviorFunctions.RemoveLevelTips(self.guideTips)
		end
		BehaviorFunctions.ShowMapArea(self.levelId,false)
		BehaviorFunctions.ShowLevelEnemy(self.levelId,false)
	end
end

function LevelBehavior500502001:FinishLevel()
	
end

--赋值
function LevelBehavior500502001:Assignment(variable,value)
	self[variable] = value
end


--死亡回调
function LevelBehavior500502001:Death(instanceId,isFormationRevive)

	-----------------刷怪相关封装----------------
	if not isFormationRevive then
		if next(self.LevelCommon.monsterList) then
			local totalMonsterRemain = 0
			local totalMonster = 0
			--根据每个怪物组查找对应的死亡怪物ID
			for i1, v1 in ipairs(self.LevelCommon.monsterList) do
				totalMonster = totalMonster + #v1.list
				for i2,v2 in ipairs(v1.list) do
					if instanceId == v2.instanceId and v2.isDead == false then
						v2.isDead = true
						v1.deadMonsterNum = v1.deadMonsterNum + 1
						self.LevelCommon.totalDeadMonsterNum = self.LevelCommon.totalDeadMonsterNum + 1
					end
					if v2.isDead == true then
						totalMonsterRemain = totalMonsterRemain - 1
					end
				end
			end
			--敌人数量tips变更
			if self.countTips then
				BehaviorFunctions.ChangeLevelSubTips(self.countTips,1,self.LevelCommon.totalDeadMonsterNum.."/"..self.LevelCommon.totalMonsterNum)
			end
		end
	end
end