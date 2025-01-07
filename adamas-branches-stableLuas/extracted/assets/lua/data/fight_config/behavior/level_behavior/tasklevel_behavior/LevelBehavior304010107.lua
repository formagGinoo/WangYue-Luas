LevelBehavior304010107 = BaseClass("LevelBehavior304010107",LevelBehaviorBase)
--创怪打怪恶来三只

function LevelBehavior304010107:__init(fight)
	self.fight = fight
end

function LevelBehavior304010107.GetGenerates()
	local generates = {790007000}
	return generates
end

function LevelBehavior304010107:Init()
	self.missionState = 0
	self.role = nil
	self.currentWave = 1          --当前波次
	self.currentWaveNum = 0       --当前波次怪物总数
	self.deathCount = 0           --死亡计数
	self.currentWaveLookAtPos = nil       --当前波次关卡相机朝向点
	self.palyerCombatArea = false           --玩家是否在战斗区域
    self.combatWall = false                 --空气墙

	--开放参数
	--self.logicName = "Main02_1"          --如果用的worldLogic就填，不填默认是LevelLogic
	--self.mapId = 10020005                  --如果是用的worldLogic才有用
	self.wave = 1                          --总波次
	self.isWarn = true                    --是否开启警戒
	self.transPos = nil                   --设置玩家位置
	self.imageTipId = nil                 --图文教学
	self.imagTips = false				--是否开启图文教学
	self.dialogId = {
		202110401,202110501  
	}
	--怪物列表
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	
	self.monentityId = 790007000
	
	self.monsterList = {
		--第一波
		[1] = {Id = nil , state = self.monsterStateEnum.Default ,posName = "emeny101" ,wave = 1 ,lev = 1 ,isDead = false ,entityId = self.monentityId},  --1打手
		[2] = {Id = nil , state = self.monsterStateEnum.Default ,posName = "emeny102" ,wave = 1 ,lev = 1 ,isDead = false ,entityId = self.monentityId},  --1打手
		
		--[1] =  {entityId = 900070, posName = "emeny101", instanceId = nil, lev = 2, wave = 1, isDead = false},
		--[2] =  {entityId = 900070, posName = "emeny102", instanceId = nil, lev = 2, wave = 1, isDead = false},
		
		--第二波
		--{entityId = 900070, posName = "emeny02", instanceId = nil, lev = 2, wave = 2, isDead = false},
	}
	--插入旁白
	self.attackDialogId = nil             --开打旁白，不配默认没有
	self.isWaveDialog = false             --是否有波次旁白，即刷该波怪的时候播旁白
	self.waveDialogList = {
		{wave = 2, dialogId = nil},
	}
end

function LevelBehavior304010107:Update()
	
	self.time = BehaviorFunctions.GetFightFrame()	--获取帧数
	self.role = BehaviorFunctions.GetCtrlEntity()	--获取玩家操控角色

	--检测玩家位置创建空气墙
	self.palyerCombatArea = BehaviorFunctions.CheckEntityInArea(self.role,"CombatArea","Logic_Level3040105")
	-- print("检测玩家所在区域")
	if self.palyerCombatArea == true and self.combatWall == false then
		-- print("玩家在区域内")
		BehaviorFunctions.ActiveSceneObj("combatwall",true,self.levelId)
		-- print("创建空气墙")
		self.combatWall = true
	end
	if self.palyerCombatArea == false then
		-- print("玩家不在区域内")
		BehaviorFunctions.ActiveSceneObj("combatwall",false,self.levelId)
		-- print("随时移除空气墙")
	end

	if self.missionState == 0 then
		--开场自定义功能
		--self:CustomLevelFunctions()
		
		--玩家初始点位设置
		local bornPos = BehaviorFunctions.GetTerrainPositionP("playerBorn",self.levelId)
		--local bornRos = BehaviorFunctions.GetTerrainPositionR(self.bornPos,self.levelId)
		BehaviorFunctions.SetPlayerBorn(bornPos.x,bornPos.y,bornPos.z)	--设置角色出生点

		BehaviorFunctions.StartStoryDialog(self.dialogId[1])
		
		----设置关卡相机，此处点位后方需要填的是关卡id
		--local fp1 = BehaviorFunctions.GetTerrainPositionP("emeny101",3040105,Logic_Level3040105)
		--self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
		--self.levelCam = BehaviorFunctions.CreateEntity(22001)
		--BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
		----看向目标
		--BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		--BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
		----隐藏相机
		----BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.SetEntityShowState,self.levelCam,false)

		----延时移除目标和镜头
		--BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
		--BehaviorFunctions.AddDelayCallByFrame(200,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
		
		self.missionState = 1
		--第一波刷怪
	elseif self.missionState == 1 then
		self:CreateMonster(self.currentWave)
		--print("第一波刷怪")
		self.missionState = 2
		--判断是否还有波次
	elseif self.missionState == self.currentWave + 1 then
		--当前波怪物全死时
		if self.currentWaveAllDie == true then
			--如果仍有后续波次
			if self.wave > self.currentWave then
				self.currentWave = self.currentWave + 1
				self.currentWaveAllDie = false
				--成功击杀所有怪
			elseif self.wave == self.currentWave then
				if not self.imagTips then
					BehaviorFunctions.ShowGuideImageTips(20027,closeCallback)
					self.imagTips = true
					--print("图文教学")
				end
			end
		end
		--后续波次刷怪
	elseif self.missionState == self.currentWave and self.missionState ~= 1 then
		self:CreateMonster(self.currentWave)
	end
end

function LevelBehavior304010107:__delete()

end

-------------------------函数--------------------------------

--开场自定义功能函数
--function LevelBehavior304010107:CustomLevelFunctions()
	--如果需要开场图文教学
	--if self.imageTipId then
		--BehaviorFunctions.ShowGuideImageTips(self.imageTipId)
	--end
	--如果需要同步玩家位置
	--if self.transPos then
		--local rolePos = BehaviorFunctions.GetTerrainPositionP(self.posName.rolePos, 10020005, "Prologue02")
		--BehaviorFunctions.InMapTransport(rolePos.x,rolePos.y,rolePos.z)
	--end
--end

--创怪函数
function LevelBehavior304010107:CreateMonster(wave)
	----如果有波次旁白
	--if self.isWaveDialog then
		--self:PlayWaveDialog(wave)
	--end
	
	for i, v in pairs(self.monsterList) do
		--创该波的怪
		local pos = nil
		local rot = nil
		
		--
		if v.wave == wave then						
			--获取怪物位置信息，写成通用逻辑
			if self.logicName then
				pos = BehaviorFunctions.GetTerrainPositionP(v.posName, self.mapId, self.logicName)
				rot = BehaviorFunctions.GetTerrainRotationP(v.posName, self.mapId, self.logicName)
			else
				pos = BehaviorFunctions.GetTerrainPositionP(v.posName, self.levelId)
				rot = BehaviorFunctions.GetTerrainRotationP(v.posName, self.levelId)
			end
			
			--创建怪物，从self.monsterList中获取信息
			v.instanceId = BehaviorFunctions.CreateEntity(v.entityId, nil, pos.x, pos.y, pos.z, nil, nil, nil, self.levelId, v.lev)
			BehaviorFunctions.SetEntityEuler(v.instanceId,rot.x,rot.y,rot.z)
			self.currentWaveNum = self.currentWaveNum + 1	--根据怪物列表的信息，记录创建怪物的数量
			--看向玩家
			BehaviorFunctions.DoLookAtTargetImmediately(v.instanceId, self.role)
			--如果要关闭警戒
			if not self.isWarn then
				BehaviorFunctions.SetEntityValue(v.instanceId,"haveWarn",false)   --关闭警戒
			end
		end		
		--设置该波的看向点
		if not self.currentWaveLookAtPos then
			self.currentWaveLookAtPos = pos
		end
	end
	self.missionState = self.missionState + 1
	self:SetLevelCamera()
end

--设置关卡相机函数
function LevelBehavior304010107:SetLevelCamera()
	self.empty = BehaviorFunctions.CreateEntity(2001, nil, self.currentWaveLookAtPos.x, self.currentWaveLookAtPos.y + 1, self.currentWaveLookAtPos.z)
	self.levelCam = BehaviorFunctions.CreateEntity(22001)
	BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
	--看向目标
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
	--延时移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
	BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
end

----波次旁白播放函数
--function LevelBehavior304010107:PlayWaveDialog(wave)
	--for i, v in pairs(self.waveDialogList) do
		----如果是需要播旁白的波次
		--if v.wave == wave then
			--BehaviorFunctions.StartStoryDialog(v.dialogId)
		--end
	--end
--end

--图文教学被关闭
function LevelBehavior304010107:OnGuideImageTips(tipsId,isOpen)
	if tipsId == 20027 and isOpen == false then
		self:LevelFinish()
		--print("关闭图文教学")
	end
end

--关卡结束函数
function LevelBehavior304010107:LevelFinish()

	if self.combatWall == true then
		BehaviorFunctions.ActiveSceneObj("combatwall",false,self.levelId)		--移除空气墙
		self.combatWall = false
	end

	BehaviorFunctions.FinishLevel(self.levelId)
	self.missionState = 999--结束关卡
	--print("关卡结束")
end

---------------------回调----------------------------------

--死亡回调
function LevelBehavior304010107:Death(instanceId,isFormationRevive)
	for i, v in pairs(self.monsterList) do
		if instanceId == v.instanceId and v.isDead == false then
			self.deathCount = self.deathCount + 1
			v.isDead = true
			if self.deathCount == self.currentWaveNum then
				--该波怪物全死
				self.currentWaveAllDie = true
				--参数复原
				self.currentWaveNum = 0
				self.currentWaveLookAtPos = nil
				self.deathCount = 0
				BehaviorFunctions.StartStoryDialog(self.dialogId[2])	
				--print("怪物死亡")
			end
		end
	end
end

----受击回调
--function LevelBehavior304010107:Hit(attackInstanceId,hitInstanceId,hitType)
	--if attackInstanceId == self.role or hitInstanceId == self.role then
		----如果有开打旁白
		--if self.attackDialogId then
			--BehaviorFunctions.StartStoryDialog(self.dialogId)
		--end
	--end
--end