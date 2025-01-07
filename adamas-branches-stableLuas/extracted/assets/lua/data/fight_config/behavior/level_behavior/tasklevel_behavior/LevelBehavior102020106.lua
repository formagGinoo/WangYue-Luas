LevelBehavior102020106 = BaseClass("LevelBehavior102020106",LevelBehaviorBase)
--教瞄准、切人，丑附一只，第二波丑附+近战从士2只（丑附暂时用箴石之劣）

function LevelBehavior102020106:__init(fight)
	self.fight = fight
end

function LevelBehavior102020106.GetGenerates()
	local generates = {791004001, 790008000, 790012000, 790013000, 2030206, 8012003}
	return generates
end

function LevelBehavior102020106:Init()
	self.TaskFightLevel = BehaviorFunctions.CreateBehavior("TaskFightLevel",self)
	self.TaskFightLevel.levelId = self.levelId
	--开放参数
	self.TaskFightLevel.logicName = "Main02_1"          --如果用的worldLogic就填，不填默认是LevelLogic
	self.TaskFightLevel.mapId = 10020005         --如果是用的worldLogic才有用
	self.TaskFightLevel.wave = 2                 --总波次
	self.TaskFightLevel.isWarn = true            --是否开启警戒
	self.TaskFightLevel.transPos = "Park"           --设置玩家位置
	self.TaskFightLevel.imageTipId = nil         --图文教学
	self.TaskFightLevel.monsterLevelBias = {     --怪物世界等级偏移
		[FightEnum.EntityNpcTag.Monster] = -2,
		[FightEnum.EntityNpcTag.Elite] = -2,
		[FightEnum.EntityNpcTag.Boss] = 0,
	}

	--怪物列表
	self.TaskFightLevel.monsterList = {
		----第一波
		{entityId = 791004001, posName = "Park01", instanceId = nil, lev = 0, wave = 1, isDead = false},
		{entityId = 790012000, posName = "Park02", instanceId = nil, lev = 0, wave = 1, isDead = false},
		{entityId = 791004001, posName = "Park03", instanceId = nil, lev = 0, wave = 1, isDead = false},
		{entityId = 790012000, posName = "Park04", instanceId = nil, lev = 0, wave = 1, isDead = false},
		{entityId = 790008000, posName = "Park05", instanceId = nil, lev = 0, wave = 1, isDead = false},
		
		
		--第二波
		{entityId = 790008000, posName = "Park04", instanceId = nil, lev = 0, wave = 2, isDead = false},
		{entityId = 791004001, posName = "Park05", instanceId = nil, lev = 0, wave = 2, isDead = false},
		{entityId = 790012000, posName = "Park02", instanceId = nil, lev = 0, wave = 2, isDead = false},
		
		--第一波
		--{entityId = 900040, posName = "Born", instanceId = nil, lev = 2, wave = 1, isDead = false},
		--第二波
		--{entityId = 900040, posName = "Born", instanceId = nil, lev = 2, wave = 2, isDead = false},
		--{entityId = 910040, posName = "Park02", instanceId = nil, lev = 2, wave = 2, isDead = false},
	}

	--插入旁白
	self.TaskFightLevel.attackDialogId = nil             --开打旁白，不配默认没有
	self.TaskFightLevel.isWaveDialog = true             --是否有波次旁白，即刷该波怪的时候播旁白
	self.TaskFightLevel.waveDialogList = {
		{wave = 2, dialogId = 102340301},
	}
	
	--教学相关
	self.teachState = 0
	self.guideId1 = 2206  --切人
	self.guideId2 = 2048  --进入瞄准教学
	self.guideId2 = 2049  --按下攻击键
	self.inputAimMode = false
	self.inputAttack = false
end

function LevelBehavior102020106:Update()
	self.TaskFightLevel:Update()
	self:ShootTeach()
end

function LevelBehavior102020106:__delete()

end

function LevelBehavior102020106:ShootTeach()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.roleId = BehaviorFunctions.GetEntityTemplateId(self.role)   --角色id
	--先换成刻刻
	if self.teachState == 0 then
		if self.roleId ~= 1002 then
			--提示切换为刻刻
			BehaviorFunctions.PlayGuide(2206)    --切人
			self.teachState = 1
		else
			self.teachState = 1
		end
	--换成刻刻之后
	elseif self.teachState == 1 then
		if self.roleId == 1002 then
			BehaviorFunctions.FinishGuide(2206, 1)
			BehaviorFunctions.PlayGuide(2048)    --瞄准
			self.teachState = 2
		end		
	elseif self.teachState == 2 and self.inputAimMode then
		--创建炸药桶并看向它。
		local pos = BehaviorFunctions.GetTerrainPositionP("ParkZhayaotong", 10020005, "Main02_1")
		self.zhayaotong = BehaviorFunctions.CreateEntity(2030218, nil, pos.x, pos.y, pos.z, nil, nil, nil, self.levelId)
		BehaviorFunctions.ShowTip(100000003,"尝试射击引爆炸药桶来解决强敌吧")
		BehaviorFunctions.AddDelayCallByTime(6,BehaviorFunctions,BehaviorFunctions.HideTip,100000003)
		--self.empty = BehaviorFunctions.CreateEntity(2001, nil, pos.x, pos.y, pos.z)
		--self.levelCam = BehaviorFunctions.CreateEntity(22001)
		--BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
		----看向目标
		--BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		--BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
		----延时移除目标和镜头
		--BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
		--BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
		self.teachState = 3
	elseif self.teachState == 3 then
		local AimTarget = BehaviorFunctions.GetAimTargetInstanceId(self.role)
		if AimTarget == self.zhayaotong then
			BehaviorFunctions.FinishGuide(2048, 1)
			BehaviorFunctions.PlayGuide(2049)   --射击
			self.teachState = 4
		end	
	elseif self.teachState == 4 then
		if self.TaskFightLevel.currentWave == 2 then
			--创建炸药桶并看向它。
			local pos = BehaviorFunctions.GetTerrainPositionP("ParkZhayaotong", 10020005, "Main02_1")
			self.zhayaotong2 = BehaviorFunctions.CreateEntity(2030218, nil, pos.x, pos.y, pos.z, nil, nil, nil, self.levelId)
			BehaviorFunctions.ShowTip(100000003,"新的敌人已经出现")
			BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.HideTip,100000003)
			BehaviorFunctions.AddDelayCallByTime(3.5,BehaviorFunctions,BehaviorFunctions.ShowTip,100000003,"活用刚才学到的方法，和年年一起战胜强敌")
			BehaviorFunctions.AddDelayCallByTime(11,BehaviorFunctions,BehaviorFunctions.HideTip,100000003)
			
			--self.empty = BehaviorFunctions.CreateEntity(2001, nil, pos.x, pos.y, pos.z)
			--self.levelCam = BehaviorFunctions.CreateEntity(22001)
			--BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
			----看向目标
			--BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
			--BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
			----延时移除目标和镜头
			--BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
			--BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
			self.teachState = 5
		end
	end
end

function LevelBehavior102020106:KeyInput(key, status)
	if self.teachState == 2 then
		if key == FightEnum.KeyEvent.AimMode and status == FightEnum.KeyInputStatus.Down then
			self.inputAimMode = true
		end
	end
	--if self.teachState == 3 then
		--if key == FightEnum.KeyEvent.Attack and status == FightEnum.KeyInputStatus.Down then
			--self.inputAttack = true
		--end
	--end
end

function LevelBehavior102020106:Death(instanceId,isFormationRevive)
	
end