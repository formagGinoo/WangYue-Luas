LevelBehavior404010513 = BaseClass("LevelBehavior404010513",LevelBehaviorBase)
--烽火挑战

function LevelBehavior404010513.GetGenerates()
	local generates = {
		900040,900041,900042,900030,900050,900051, --小怪
		910040, --精英
		2041001,--信号塔
		2030206 --道具
		}
	return generates
end


function LevelBehavior404010513:__init(fight)
----敌人参数------------------------------------------------------------------------------------------------------------------------------------------
	self.enemyCount = 0 --生成敌人的总数量
	self.deathCount = 0 --死亡敌人的数量
	
	--怪物状态判断
	self.monsterStateEnum =
	{
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	
	--判断信号塔是否可以使用的状态机
	self.towerState = {
		Open = 0,
		Close = 1
	}
	
	--信号塔点位信息
	self.posList =
	{
		[1] = {posName = "Pos1", state = self.towerState.Open, deathCount = 0, totalNum = 0, towerId = nil, allEnemyIdList = {}, canInteract = false, guide = nil},
		[2] = {posName = "Pos2", state = self.towerState.Open, deathCount = 0, totalNum = 0, towerId = nil, allEnemyIdList = {}, canInteract = false, guide = nil},
		[3] = {posName = "Pos3", state = self.towerState.Open, deathCount = 0, totalNum = 0, towerId = nil, allEnemyIdList = {}, canInteract = false, guide = nil}
	}
	
	--怪物list
	self.enemyList = {
		--Pos1敌人和道具选择
		[1] = {towerPos = "Pos1", state = self.monsterStateEnum.Default, monsterId = 900040, posName = "_EnemyBorn1", Id = nil, tage = "Enemy"},
		[2] = {towerPos = "Pos1", state = self.monsterStateEnum.Default, monsterId = 900041, posName = "_EnemyBorn2", Id = nil, tage = "Enemy"},
		[3] = {towerPos = "Pos1", state = self.monsterStateEnum.Default, monsterId = 900050, posName = "_EnemyBorn3", Id = nil, tage = "Enemy"},
		[4] = {towerPos = "Pos1", state = self.monsterStateEnum.Default, monsterId = 2030206, posName = "_ItemBorn1", Id = nil, tage = "Item"},
		--Pos2敌人和道具选择
		
		[5] = {towerPos = "Pos2", state = self.monsterStateEnum.Default, monsterId = 900040, posName = "_EnemyBorn1", Id = nil, tage = "Enemy"},
		[6] = {towerPos = "Pos2", state = self.monsterStateEnum.Default, monsterId = 900040, posName = "_EnemyBorn2", Id = nil, tage = "Enemy"},
		[7] = {towerPos = "Pos2", state = self.monsterStateEnum.Default, monsterId = 900050, posName = "_EnemyBorn3", Id = nil, tage = "Enemy"},
		[8] = {towerPos = "Pos2", state = self.monsterStateEnum.Default, monsterId = 2030206, posName = "_ItemBorn1", Id = nil, tage = "Item"},
		[9] = {towerPos = "Pos2", state = self.monsterStateEnum.Default, monsterId = 2030206, posName = "_ItemBorn2", Id = nil, tage = "Item"},
		[10] = {towerPos = "Pos2", state = self.monsterStateEnum.Default, monsterId = 2030206, posName = "_ItemBorn3", Id = nil, tage = "Item"},
		
		--Pos3敌人和道具选择
		[11] = {towerPos = "Pos3", state = self.monsterStateEnum.Default, monsterId = 900050, posName = "_EnemyBorn1", Id = nil, tage = "Enemy"},
		[12] = {towerPos = "Pos3", state = self.monsterStateEnum.Default, monsterId = 910040, posName = "_EnemyBorn2", Id = nil, tage = "Enemy"},
		}
	
----关卡参数------------------------------------------------------------------------------------------------------------------------------------------
	self.me = self.levelId
	self.missionFinished = false
	self.missionState = nil
	self.missionStarted = false
	self.isInViewZone = false
	self.canActiveZone = false
	self.towerCount = 0
	self.towerCloseCount = 0
	self.info = nil
	
	--区域卸载判定
	self.leaveArea = false
	self.isLeaving = false
	self.eventUnloadframe = nil
	self.eventUnloadIntervalTime = 8
	
	--倒计时卸载关卡判定
	self.canCountDown = false
	self.isCountingDown = false
	self.countDownFrame = nil
	self.missionTotalTime = 300
	
	self.towerList = {
		[1] = {state = self.towerState.Open, towerId = 2041001, posName = "_SignalTower1", Id = nil, tage = "tower", spawned = false},
		[2] = {state = self.towerState.Open, towerId = 2041001, posName = "_SignalTower2", Id = nil, tage = "tower", spawned = false},
		[3] = {state = self.towerState.Open, towerId = 2041001, posName = "_SignalTower3", Id = nil, tage = "tower", spawned = false}
	}
	
	--相机参数
	self.Camera1 = nil
	self.CameraTarget = nil
	
----肉鸽关卡开启参数--------------------------------------------------------------------------------------------------------------------------------
	self.missionStartDis = 10 ---挑战开始距离
	self.missionStartPos = nil --挑战开始位置
	self.missionCreate = false --检查关卡是否加载
	self.missionDistance = nil --操作角色与挑战关卡的距离
	self.eventId = nil ----------rogue事件ID
	self.missionUnloadDis = 60 --肉鸽玩法未开始的卸载距离
	self.unloaded = false
	
	------追踪标--- -----------------------------------------------------------------------------------------------------
	self.guide = nil
	self.guideEntity = nil
	self.guideDistance = 50
	self.guidePos = nil
	
	self.GuideTypeEnum = {
		Police = FightEnum.GuideType.Rogue_Police,
		Challenge = FightEnum.GuideType.Rogue_Challenge,
		Riddle = FightEnum.GuideType.Rogue_Riddle,
	}
	
	--获取关卡对应点位所需参数
	self.rogueData = nil --------rogue事件数据集
	self.roguePosName = nil -----rogue生成点位名称
	
end


function LevelBehavior404010513:Init()
	self.missionState = 0
	self.missionCreate = false
	--LogError("MissionInit")
	
	--肉鸽事件信息获取
	self.eventId = self.rogueEventId
	self.rogueData = BehaviorFunctions.GetRoguelikePointInfo(self.rogueEventId)
	self.roguePosName = self.rogueData.position
end


function LevelBehavior404010513:Update()
	self.time = BehaviorFunctions.GetFightFrame()/30
	self.frame = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.missionCreate == false then
		self.role = BehaviorFunctions.GetCtrlEntity()
		self.rogueData = BehaviorFunctions.GetRoguelikePointInfo(self.rogueEventId)
		self.missionStartPos = BehaviorFunctions.GetTerrainPositionP(self.rogueData.position,self.rogueData.positionId,self.rogueData.logicName)

		if self.missionStartPos == nil then
			self.missionStartPos = BehaviorFunctions.GetPositionP(self.role)
		end

		local playerPos = BehaviorFunctions.GetPositionP(self.role)
		self.missionDistance = BehaviorFunctions.GetDistanceFromPos(playerPos,self.missionStartPos)
		--LogError("Distance to Start: "..self.missionDistance)

		if self.missionDistance <= self.missionStartDis then
			self.missionCreate = true
		end
		
		--关卡追踪标
		if self.guidePos then
			local pos = BehaviorFunctions.GetTerrainPositionP(self.guidePos.position,self.guidePos.positionId,self.guidePos.logicName)
			self:RogueGuidePointer(pos,self.guideDistance,self.GuideTypeEnum.Police)
		else
			if self.rogueEventId then
				self.guidePos = BehaviorFunctions.GetRoguelikePointInfo(self.rogueEventId)
			end
		end
		
		--如果距离超出则卸载距离
		if self.missionDistance >= self.missionUnloadDis and self.unloaded == false then
			--LogError("unload")
			BehaviorFunctions.SetRoguelikeEventCompleteState(self.eventId,false)
			self.unloaded = true
		end
	end
	
	--如果玩家进入到事件范围内，开始关卡
	if self.missionFinished == false and self.missionCreate == true then
		self.time = BehaviorFunctions.GetFightFrame()/30
		self.frame = BehaviorFunctions.GetFightFrame()
		self.role = BehaviorFunctions.GetCtrlEntity()
		
		if self.missionStarted == false then
			BehaviorFunctions.ShowCommonTitle(8,"发现城市威胁",true)
			self.missionStarted = true
		end
		
		--引导上楼
		if self.missionState == 0 then
			BehaviorFunctions.ShowTip(302060507)
			
			BehaviorFunctions.RemoveEntity(self.guideEntity)
			self.guide = nil
			
			local viewPointPos = BehaviorFunctions.GetTerrainPositionP("viewPoint",self.levelId)
			self:RogueGuidePointer(viewPointPos,self.guideDistance,self.GuideTypeEnum.Police)
			
			self.canActiveZone = true
			self.missionState = 1
		end
		
		--判断玩家是否进入到眺望点
		if self.missionState == 1 and self.isInViewZone == true then
			BehaviorFunctions.RemoveEntity(self.guideEntity)
			self.guide = nil
			
			self:enemySpawn(self.enemyList,self.posList)
			self:TowerSpawn(self.towerList,self.posList)
			--self:TowerGuidePointer()
			
			BehaviorFunctions.ShowTip(302060508)
			BehaviorFunctions.ShowTip(302060509)
			BehaviorFunctions.ChangeSubTipsDesc(3,302060508,0,self.towerCount)
			
			self.canCountDown = true
			
			--相机控制
			--使用越肩镜头引导玩家看向所有目标点
			local Camera1Born = BehaviorFunctions.GetTerrainPositionP("CameraTarget",self.levelId)
			self.Camera1 = BehaviorFunctions.CreateEntity(22002,nil,Camera1Born.x,Camera1Born.y,Camera1Born.z)
			self.CameraTarget = BehaviorFunctions.CreateEntity(2001,nil,Camera1Born.x,Camera1Born.y,Camera1Born.z) -- 空实体
			BehaviorFunctions.CameraEntityFollowTarget(self.Camera1,self.role)--让关卡相机跟随玩家

			BehaviorFunctions.CameraEntityLockTarget(self.Camera1,self.CameraTarget)--让关卡相机看向NPC
			BehaviorFunctions.DoLookAtTargetImmediately(self.Camera1,self.CameraTarget)

			--延迟移除关卡的相机
			BehaviorFunctions.AddDelayCallByFrame(150,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.Camera1)--时间结束后移除关卡相机
					
			self.missionState = 2
		end
		
		--常态判断所有信号塔是否被触发
		if self.missionState == 2 then
			self:CheckTowerState()
			--self:TowerGuidePointer()
		end
		
		--卸载区域判定
		if self.leaveArea == true then
			if self.isLeaving == false then
				self.eventUnloadframe = self.frame + self.eventUnloadIntervalTime * 30
				self.isLeaving = true
			end
			
			if self.isLeaving == true and self.eventUnloadframe < self.frame then
				self.missionState = 5
				self.missionFinished = true
			end
		end
		
		--事件倒计时，倒计时结束事件失败
		if self.canCountDown == true then
			if self.isCountingDown == false then
				self.countDownFrame = self.frame + self.missionTotalTime * 30
				self.isCountingDown = true
			end
			
			if self.isCountingDown == true and self.frame > self.countDownFrame then
				self.missionFinished = true
				self.missionState = 5
			else
				local remainTime = (self.countDownFrame - self.frame) / 30
				local realVal = math.floor(remainTime)
				local remainTimeText = realVal.."秒"
				BehaviorFunctions.ChangeSubTipsDesc(4,302060508,remainTimeText)
				
				--倒计时提示
				local ratio = remainTime / self.missionTotalTime
				if ratio <= 0.5 then
					self:TowerGuidePointer()
				end
			end
		end
		
	else
		--胜利事件
		if self.missionState == 4 then
			BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
			BehaviorFunctions.HideTip(302060507)
			BehaviorFunctions.HideTip(302060508)
			BehaviorFunctions.SetRoguelikeEventCompleteState(self.eventId,true)
			self.missionState = 999 --由于与后端有关，只告诉服务端一次就好
		end
		
		--失败事件
		if self.missionState == 5 then
			BehaviorFunctions.HideTip(302060507)
			BehaviorFunctions.HideTip(302060508)
			BehaviorFunctions.SetRoguelikeEventCompleteState(self.eventId,false)
			self.missionState = 999 --由于与后端有关，只告诉服务端一次就好
		end
	end
	
end

--生成敌人
function LevelBehavior404010513:enemySpawn(enemyList,PosList)
	for x,y in ipairs(PosList) do
		
		local PosName = y.posName
		
		for i,v in ipairs(enemyList) do
			
			--判定敌人生成位置是否对应信号塔位置
			if y.posName == v.towerPos then
				local BornPosName = v.posName
				local FinalBornPos = PosName..BornPosName
				local Location = BehaviorFunctions.GetTerrainPositionP(FinalBornPos,self.levelId)
				
				if Location ~= nil then
					v.Id = BehaviorFunctions.CreateEntity(v.monsterId,nil,Location.x,Location.y,Location.z,nil,nil,nil,self.levelId)
					v.state = self.monsterStateEnum.Live
					BehaviorFunctions.DoLookAtTargetImmediately(v.Id,self.role)
					
					if v.tage == "Enemy" then
						y.totalNum = y.totalNum + 1
						table.insert(y.allEnemyIdList,v.Id)
					end
				end
			end
		end
	end
end

--生成信号塔
function LevelBehavior404010513:TowerSpawn(towerList,PosList)
	for x,y in ipairs(PosList) do

		local PosName = y.posName
		
		for i,v in ipairs(towerList) do
			if x == i then
				--LogError("HasPos")
				local BornPosName = v.posName
				local FinalBornPos = PosName..BornPosName
				if BehaviorFunctions.GetTerrainPositionP(FinalBornPos,self.levelId) ~= nil then
					local Location = BehaviorFunctions.GetTerrainPositionP(FinalBornPos,self.levelId)
					v.Id = BehaviorFunctions.CreateEntity(v.towerId,nil,Location.x,Location.y,Location.z,nil,nil,nil,self.levelId)
					v.state = self.towerState.Open
					
					y.towerId = v.Id
					--传递信息给
					BehaviorFunctions.SetEntityValue(v.Id,"canInteract",false)
					
					v.spawned = true
					self.towerCount = self.towerCount + 1
				end
			end
		end
	end
end


function LevelBehavior404010513:EnterArea(triggerInstanceId, areaName, logicName)
	if areaName == "startArea" and triggerInstanceId == self.role and self.isInViewZone == false and self.canActiveZone == true then
		self.missionState = 1
		self.isInViewZone = true
	end
	
	if areaName == "eventZone" and triggerInstanceId == self.role then
		self.leaveArea = false
		self.isLeaving = false
	end
	
end


function LevelBehavior404010513:ExitArea(triggerInstanceId, areaName, logicName)
	if areaName == "eventZone" and triggerInstanceId == self.role then
		self.leaveArea = true
	end
end


function LevelBehavior404010513:Die(attackInstanceId,dieInstanceId)
	for i,v in ipairs(self.posList) do
		for x,y in ipairs(v.allEnemyIdList) do
			if dieInstanceId == y then
				v.deathCount = v.deathCount + 1
			end
		end
	end
end


function LevelBehavior404010513:CheckTowerState()
	for i,v in ipairs(self.posList) do
		if v.deathCount == v.totalNum then
			v.canInteract = true
			BehaviorFunctions.SetEntityValue(v.towerId,"canInteract",true)
			--LogError(v.posName.."Win")
		end
	end
end

--检查哪些塔完成了
function LevelBehavior404010513:WorldInteractClick(uniqueId,instanceId)
	for i,v in ipairs(self.posList) do

		if instanceId == v.towerId and v.canInteract ~= true then
			BehaviorFunctions.ShowTip(302060513)
			return
		end


		if instanceId == v.towerId and v.canInteract == true then
			v.state = self.towerState.Close
			--LogError("v.towerId"..v.towerId.."Closed")
			self.towerCloseCount = self.towerCloseCount + 1
			BehaviorFunctions.ChangeSubTipsDesc(3,302060508,self.towerCloseCount,self.towerCount)
			if self.towerCloseCount == self.towerCount then
				self.missionState = 4
				self.missionFinished = true
			end

			local remain = self.towerCount - self.towerCloseCount

			if remain > 0 then
				BehaviorFunctions.ShowTip(302060512,remain)
			end

			--还剩一个塔的时候提供提示
			local remainTowerCount = self.towerCount - self.towerCloseCount

			if remainTowerCount <= 1 then
				self:TowerGuidePointer()
			end
		end
	end
end

--全队死亡判定失败
function LevelBehavior404010513:Death(instanceId,isFormationRevive)
	if isFormationRevive then
		self.missionFinished = true
		self.missionState = 5
	end
end

--任务前置肉鸽追踪指标
function LevelBehavior404010513:RogueGuidePointer(guidePos,guideDistance,guideType)
	local playerPos = BehaviorFunctions.GetPositionP(self.role)
	local distance = BehaviorFunctions.GetDistanceFromPos(playerPos,guidePos)
	if distance <= guideDistance then
		if not self.guide then
			self.guideEntity = BehaviorFunctions.CreateEntity(2001,nil,guidePos.x,guidePos.y,guidePos.z,nil,nil,nil,self.levelId)
			self.guide =BehaviorFunctions.AddEntityGuidePointer(self.guideEntity,guideType,0,false)
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

--肉鸽追踪（给信号塔添加标记）
function LevelBehavior404010513:TowerGuidePointer()
	for i,v in ipairs(self.posList) do
		--如果信号塔已经被关闭则不添加标记
		if v.guide == nil and v.state ~= self.towerState.Close then
			local pos = BehaviorFunctions.GetPositionP(v.towerId)
			local target = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
			BehaviorFunctions.AddEntityGuidePointer(target,self.GuideTypeEnum.Police,0,false)
			v.guide = target
		end
		
		--检测信号塔标记是否可以被移除
		if v.guide and v.state == self.towerState.Close then
			BehaviorFunctions.RemoveEntity(v.guide)
		end
	end	
end