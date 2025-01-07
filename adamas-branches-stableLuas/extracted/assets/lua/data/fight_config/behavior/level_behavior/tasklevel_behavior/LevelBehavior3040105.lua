LevelBehavior3040105 = BaseClass("LevelBehavior3040105",LevelBehaviorBase)
--创怪打怪恶来三只

function LevelBehavior3040105:__init(fight)
	self.fight = fight
end

function LevelBehavior3040105.GetGenerates()
	local generates = {900070}
	return generates
end

function LevelBehavior3040105:Init()
	self.missionState = 0
	self.role = nil
	self.currentWave = 1          --当前波次
	self.currentWaveNum = 0       --当前波次怪物总数
	self.deathCount = 0           --死亡计数
	self.currentWaveLookAtPos = nil       --当前波次关卡相机朝向点

	--开放参数
	--self.logicName = "Main02_1"          --如果用的worldLogic就填，不填默认是LevelLogic
	--self.mapId = 10020005                  --如果是用的worldLogic才有用
	self.wave = 1                          --总波次
	self.isWarn = true                    --是否开启警戒
	self.transPos = nil                   --设置玩家位置
	self.imageTipId = nil                 --图文教学
	--怪物列表
	self.monsterList = {
		--第一波
		{entityId = 900070, posName = "emeny01", instanceId = nil, lev = 2, wave = 1, isDead = false},
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

function LevelBehavior3040105:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		--开场自定义功能
		self:CustomLevelFunctions()
		self.missionState = 1
		--第一波刷怪
	elseif self.missionState == 1 then
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

function LevelBehavior3040105:__delete()

end

-------------------------函数--------------------------------

--开场自定义功能函数
function LevelBehavior3040105:CustomLevelFunctions()
	--如果需要开场图文教学
	if self.imageTipId then
		BehaviorFunctions.ShowGuideImageTips(self.imageTipId)
	end
	--如果需要同步玩家位置
	if self.transPos then
		local rolePos = BehaviorFunctions.GetTerrainPositionP(self.posName.rolePos, 10020005, "Prologue02")
		BehaviorFunctions.InMapTransport(rolePos.x,rolePos.y,rolePos.z)
	end
end

--创怪函数
function LevelBehavior3040105:CreateMonster(wave)
	--如果有波次旁白
	if self.isWaveDialog then
		self:PlayWaveDialog(wave)
	end
	for i, v in pairs(self.monsterList) do
		--创该波的怪
		local pos = nil
		local rot = nil
		if v.wave == wave then
			if self.logicName then
				pos = BehaviorFunctions.GetTerrainPositionP(v.posName, self.mapId, self.logicName)
				rot = BehaviorFunctions.GetTerrainRotationP(v.posName, self.mapId, self.logicName)
			else
				pos = BehaviorFunctions.GetTerrainPositionP(v.posName, self.levelId)
				rot = BehaviorFunctions.GetTerrainRotationP(v.posName, self.levelId)
			end
			v.instanceId = BehaviorFunctions.CreateEntity(v.entityId, nil, pos.x, pos.y, pos.z, nil, nil, nil, self.levelId, v.lev)
			BehaviorFunctions.SetEntityEuler(v.instanceId,rot.x,rot.y,rot.z)
			self.currentWaveNum = self.currentWaveNum + 1
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
function LevelBehavior3040105:SetLevelCamera()
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

--波次旁白播放函数
function LevelBehavior3040105:PlayWaveDialog(wave)
	for i, v in pairs(self.waveDialogList) do
		--如果是需要播旁白的波次
		if v.wave == wave then
			BehaviorFunctions.StartStoryDialog(v.dialogId)
		end
	end
end

--关卡结束函数
function LevelBehavior3040105:LevelFinish()
	BehaviorFunctions.FinishLevel(self.levelId)
	print("关卡结束")
end

---------------------回调----------------------------------

--死亡回调
function LevelBehavior3040105:Death(instanceId,isFormationRevive)
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
				
				
				print("怪物死亡")
			end
		end
	end
end

--受击回调
function LevelBehavior3040105:Hit(attackInstanceId,hitInstanceId,hitType)
	if attackInstanceId == self.role or hitInstanceId == self.role then
		--如果有开打旁白
		if self.attackDialogId then
			BehaviorFunctions.StartStoryDialog(self.dialogId)
		end
	end
end

