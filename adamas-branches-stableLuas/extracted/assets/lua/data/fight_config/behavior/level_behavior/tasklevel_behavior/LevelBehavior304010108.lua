LevelBehavior304010108 = BaseClass("LevelBehavior304010108",LevelBehaviorBase)
--创怪打怪恶来三只

function LevelBehavior304010108:__init(fight)
	self.fight = fight
end

function LevelBehavior304010108.GetGenerates()
	local generates = {790007000}
	return generates
end

function LevelBehavior304010108:Init()
	self.missionState = 0
	self.role = nil
	self.currentWave = 1          --当前波次
	self.currentWaveNum = 0       --当前波次怪物总数
	self.deathCount = 0           --死亡计数
	self.currentWaveLookAtPos = nil       --当前波次关卡相机朝向点
	self.palyerCombatArea = false           --玩家是否在战斗区域
    self.combatWall = false                 --空气墙

	self.lasttime = 28	--倒计时时间
	self.lasttimestate = false	--倒计时状态
	self.timeStart = 0 -- 初始化时间点
	self.dialogId = {
		202110601, 202110801
	}
	self.dialogstage = 0			--对话阶段
	self.cameraMon = 22007			--创建镜头ID
	
	--开放参数
	--self.logicName = "Main02_1"          --如果用的worldLogic就填，不填默认是LevelLogic
	--self.mapId = 10020005                  --如果是用的worldLogic才有用
	self.guidecamera = false				--指引镜头
	self.wave = 2                          --总波次
	self.isWarn = true                    --是否开启警戒
	--self.transPos = nil                   --设置玩家位置
	self.imageTipId = nil                 --图文教学
	--怪物列表
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	self.monentityId = 790007000
	
	--怪物信息
	self.monsterList = {
		--第一波
		[1] = {Id = nil , state = self.monsterStateEnum.Default ,posName = "emeny201" ,wave = 1 ,lev = 1 ,isDead = false ,entityId = self.monentityId},  --1猎手
		[2] = {Id = nil , state = self.monsterStateEnum.Default ,posName = "emeny202" ,wave = 1 ,lev = 1 ,isDead = false ,entityId = self.monentityId},  --1猎手
		[3] = {Id = nil , state = self.monsterStateEnum.Default ,posName = "emeny203" ,wave = 1 ,lev = 1 ,isDead = false ,entityId = self.monentityId},  --1猎手
		
		--第2波
		[4] = {Id = nil , state = self.monsterStateEnum.Default ,posName = "emeny301" ,wave = 2 ,lev = 1 ,isDead = false ,entityId = self.monentityId},  --1猎手
		[5] = {Id = nil , state = self.monsterStateEnum.Default ,posName = "emeny302" ,wave = 2 ,lev = 1 ,isDead = false ,entityId = self.monentityId},  --1猎手
		[6] = {Id = nil , state = self.monsterStateEnum.Default ,posName = "emeny303" ,wave = 2 ,lev = 1 ,isDead = false ,entityId = self.monentityId},  --1猎手
	}
	
	--插入旁白
	self.attackDialogId = nil             --开打旁白，不配默认没有
	self.isWaveDialog = false             --是否有波次旁白，即刷该波怪的时候播旁白
	self.waveDialogList = {
		{wave = 2, dialogId = nil},
	}
end

function LevelBehavior304010108:Update()
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

	if self.lasttimestate == false and self.palyerCombatArea == true then
		self.lasttime = 28
		self.timeStart = BehaviorFunctions.GetFightFrame() / 30
		self.lasttimestate = true
	end

	if self.missionState == 0  and self.palyerCombatArea == true then
		self.realtime = BehaviorFunctions.GetFightFrame() / 30 -- 更新世界时间
		local timePassed = self.realtime - self.timeStart -- 计算已过时间

		--倒计时器相关内容
		if self.missionState == 0 and self.lasttime > 0 then	--and self.time - self.starttime
			local newLastTime = 28 - math.floor(timePassed) -- 计算新的剩余时间
			-- 当 newLastTime 小于等于 self.lasttime 时，意味着至少过了一秒钟W
			if newLastTime < self.lasttime then

				self.lasttime = newLastTime
				if self.lasttime < 26 then
					if self.lasttime % 5 == 0 then
						BehaviorFunctions.ShowTip(3001005,self.lasttime)--更新提示
					end
				end
				-- 检查是否达到特定时间点并执行相应命令
				if self.lasttime == 25 and self.dialogstage == 0 then
					BehaviorFunctions.StartStoryDialog(self.dialogId[1]) -- 播放202110701
					self.dialogstage = 1
				elseif self.lasttime == 1 and self.dialogstage == 1 then
					BehaviorFunctions.StartStoryDialog(self.dialogId[2]) -- 播放202110801
					self.dialogstage = 2
				elseif self.lasttime == 0 then
					self.missionState = 1 -- 结束任务
					-- 可以在这里执行任何结束任务时需要的操作
				end
			end
		end
	elseif self.missionState == 1  then		--and self.lasttime <= 0
		self:CreateMonster(self.currentWave)
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
				self:LevelFinish()
			end
		end
		--后续波次刷怪
	elseif self.missionState == self.currentWave and self.missionState ~= 1 then
		self:CreateMonster(self.currentWave)
	end
end

function LevelBehavior304010108:__delete()

end

-------------------------函数--------------------------------

--创怪函数
function LevelBehavior304010108:CreateMonster(wave)
	for i, v in pairs(self.monsterList) do
		--创该波的怪
		local pos = nil
		local rot = nil
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
function LevelBehavior304010108:SetLevelCamera()
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

--关卡结束函数
function LevelBehavior304010108:LevelFinish()
	if self.combatWall == true then
		BehaviorFunctions.ActiveSceneObj("combatwall",false,self.levelId)		--移除空气墙
		self.combatWall = false
	end
	BehaviorFunctions.FinishLevel(self.levelId)
	self.missionState = 999--结束关卡
end

---------------------回调----------------------------------

--死亡回调
function LevelBehavior304010108:Death(instanceId,isFormationRevive)
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
			end
		end
	end
end