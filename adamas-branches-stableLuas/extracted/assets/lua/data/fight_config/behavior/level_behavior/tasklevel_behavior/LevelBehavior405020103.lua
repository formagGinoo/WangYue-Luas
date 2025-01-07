LevelBehavior405020103 = BaseClass("LevelBehavior405020103",LevelBehaviorBase)
--普通任务刷怪关

function LevelBehavior405020103:__init(fight)
    self.fight = fight
end

function LevelBehavior405020103.GetGenerates()
    local generates = {790012000,790013000,2041114,2041111,2041112,2041113,203040701,2041115,791004000,790010200,
    }
    return generates
end

function LevelBehavior405020103.GetMagics()
	local generates = {900000001}
	return generates
end

function LevelBehavior405020103:Init()
	self.role = 1
	self.missionState = 0
	self.monster ={
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
		[5] = 0,
	}
	self.pos = 0
	self.pos2 = 0
	self.monsterentityid1 = 790010200
	self.monsterentityid2 = 790012000
	self.gold = 2041114			--金币实体ID
	self.goldTab = {}
	self.newGold = nil
	self.Tips = 102670105
	self.goldNumber = 0
	self.goldNumberSum = 30
	self.goldCreate = 0
	self.goldlimit = 10
	self.Obstacle = 2041111 		--障碍物
	self.Obstacle1 = nil			--踏板1
	self.ecoId = 2003001200003		--生态实体
	self.eco = nil
	self.ecorewardId = 3003001080007		--生态奖励实体
	self.ecoreward = nil

	self.jumpBuff = 1000103
	self.FXjumpBuff = 1000104
	self.FXJumpArea = 2041115

	self.Gameing = true				--定义关卡是否还进行
	self.GameStop = false			--关卡终止

	--关卡倒计时
	self.time = 0
	self.timeLimit = 60
	self.startFrame = nil
	self.timeLimitFrames = 0

	self.missionUnloadDis = 100             --卸载距离
    self.playerPos = nil
    self.missionDistance = 0
    self.missionStartPos = nil

	self.count ={
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
		[5] = 0,
	}

    self.currentWave = 1          --当前波次
	self.currentWaveNum = 0       --当前波次怪物总数
	self.deathCount = 0           --死亡计数
	self.currentWaveLookAtPos = nil       --当前波次关卡相机朝向
end

function LevelBehavior405020103:Update()
    self.role = BehaviorFunctions.GetCtrlEntity()
    self.time = BehaviorFunctions.GetFightFrame()
	self.eco = BehaviorFunctions.GetEcoEntityByEcoId(self.ecoId)
	self.ecoreward = BehaviorFunctions.GetEcoEntityByEcoId(self.ecorewardId)

	self.pos = BehaviorFunctions.GetTerrainPositionP("Player",self.levelId)
	self.pos2 = BehaviorFunctions.GetTerrainPositionP("TreasureBox",self.levelId)

	--距离太远卸载关卡
	if self.playerPos == nil then
		self.playerPos = BehaviorFunctions.GetPositionP(self.role)										--获取玩家的坐标
	end
    self.missionStartPos = BehaviorFunctions.GetTerrainPositionP("Player",self.levelId,self.logicName)
	self.missionDistance = BehaviorFunctions.GetDistanceFromPos(self.playerPos,self.missionStartPos)		--获取玩家和肉鸽的距离

	--关卡胜利
	if self.goldNumber >= self.goldNumberSum then
		if self.GameStop == false then
			self.Gameing = false
			if self.ecoreward ~= nil then
				BehaviorFunctions.InteractEntityHit(self.ecoreward,true)
			end
			self:MonsterDeath()
			BehaviorFunctions.HideTip(self.Tips)
			BehaviorFunctions.ShowCommonTitle(5,'挑战胜利',true)
			self:LevelFinish()
			self.missionState = 999
			self.GameStop = true
		end
	end

	--关卡倒计时
	-- self:Timer(self.timeLimit)
	if math.floor(self:Timer(self.timeLimit)) == self:Timer(self.timeLimit) then
		BehaviorFunctions.ChangeSubTipsDesc(1, self.Tips,self:Timer(self.timeLimit))
	end

	if self.missionState == 0 then
		-- BehaviorFunctions.ShowBlackCurtain(true,0.25,false)
		-- BehaviorFunctions.AddDelayCallByTime(0.75,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.25,false)
		self.Obstacle1 = BehaviorFunctions.CreateEntityByPosition(self.Obstacle, nil, "pos2", self.logicName, self.levelId, nil, nil)

		BehaviorFunctions.CreateEntityByPosition(self.FXJumpArea, nil, "TreasureBox", self.logicName, self.levelId, nil, nil)
		self.missionState = 1
	end

    if self.missionState == 1 then
		-- BehaviorFunctions.InMapTransport(self.pos.x,self.pos.y,self.pos.z)
		BehaviorFunctions.ShowCommonTitle(4,'挑战开始',true)
		BehaviorFunctions.ShowTip(self.Tips)
		BehaviorFunctions.ChangeSubTipsDesc(2, self.Tips,self.goldNumber,self.goldNumberSum)

		self.monster[1] = BehaviorFunctions.CreateEntity(self.monsterentityid2,nil,self.pos.x-7,self.pos.y,self.pos.z+1,nil,nil,nil,self.levelId)
		BehaviorFunctions.DoLookAtTargetImmediately(self.monster[1], self.role)
		BehaviorFunctions.SetEntityValue(self.monster[1],"haveWarn",false)   --关闭警戒

		self.monster[2] = BehaviorFunctions.CreateEntity(self.monsterentityid1,nil,self.pos.x-7,self.pos.y,self.pos.z+5,nil,nil,nil,self.levelId)
		BehaviorFunctions.DoLookAtTargetImmediately(self.monster[2], self.role)
		BehaviorFunctions.SetEntityValue(self.monster[2],"haveWarn",false)   --关闭警戒

		self.monster[3] = BehaviorFunctions.CreateEntity(self.monsterentityid1,nil,self.pos.x- 4,self.pos.y,self.pos.z+7,nil,nil,nil,self.levelId)
		BehaviorFunctions.DoLookAtTargetImmediately(self.monster[3], self.role)
		BehaviorFunctions.SetEntityValue(self.monster[3],"haveWarn",false)   --关闭警戒

		self.monster[4] = BehaviorFunctions.CreateEntity(self.monsterentityid2,nil,self.pos.x,self.pos.y,self.pos.z+7,nil,nil,nil,self.levelId)
		BehaviorFunctions.DoLookAtTargetImmediately(self.monster[4], self.role)
		BehaviorFunctions.SetEntityValue(self.monster[4],"haveWarn",false)   --关闭警戒

		self.monster[5] = BehaviorFunctions.CreateEntity(self.monsterentityid2,nil,self.pos.x+3.5,self.pos.y,self.pos.z+6.5,nil,nil,nil,self.levelId)
		BehaviorFunctions.DoLookAtTargetImmediately(self.monster[5], self.role)
		BehaviorFunctions.SetEntityValue(self.monster[5],"haveWarn",false)   --关闭警戒

		do
			local levelCam = BehaviorFunctions.CreateEntity(22007)
			BehaviorFunctions.CameraEntityFollowTarget(levelCam,self.role,"CameraTarget")
			BehaviorFunctions.CameraEntityLockTarget(levelCam,self.monster[3])
			BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.monster[3])
			BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,levelCam)
		end

        self.missionState = 2
	end

    if self.missionState == 2 then

		if BehaviorFunctions.CheckEntityInArea(self.role,'JumpArea','Logic_Level405020103') then
			if self.Gameing == true then
				if BehaviorFunctions.GetBuffCount(self.role,self.jumpBuff) < 1 then
					if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Jump) then
						BehaviorFunctions.AddBuff(self.role,self.role,self.jumpBuff)
					end
					BehaviorFunctions.AddBuff(self.role,self.role,self.FXjumpBuff)
				else
					-- if BehaviorFunctions.CheckSkillType(self.role, FightEnum.EntityHitState.None) then
						BehaviorFunctions.RemoveBuff(self.role,self.jumpBuff)
					-- end
				end
			end
		else
			BehaviorFunctions.RemoveBuff(self.role,self.jumpBuff)
			BehaviorFunctions.RemoveBuff(self.role,self.FXjumpBuff)
		end

		--金币移动
		do
			if self.goldTab[1] ~= nil then
				BehaviorFunctions.DoPreciseMoveToPositionBySpeed(self.goldTab[1], self.playerPos.x, self.playerPos.y+0.5, self.playerPos.z, 8)
			end
			if self.goldTab[2] ~= nil then
				BehaviorFunctions.DoPreciseMoveToPositionBySpeed(self.goldTab[2], self.playerPos.x, self.playerPos.y+0.5, self.playerPos.z, 8)
			end
			if self.goldTab[3] ~= nil then
				BehaviorFunctions.DoPreciseMoveToPositionBySpeed(self.goldTab[3], self.playerPos.x, self.playerPos.y+0.5, self.playerPos.z, 8)
			end
			if self.goldTab[4] ~= nil then
				BehaviorFunctions.DoPreciseMoveToPositionBySpeed(self.goldTab[4], self.playerPos.x, self.playerPos.y+0.5, self.playerPos.z, 8)
			end
			if self.goldTab[5] ~= nil then
				BehaviorFunctions.DoPreciseMoveToPositionBySpeed(self.goldTab[5], self.playerPos.x, self.playerPos.y+0.5, self.playerPos.z, 8)
			end
			if self.newGold ~= nil then
				-- BehaviorFunctions.DoPreciseMoveToPositionBySpeed(self.newGold, self.playerPos.x, self.playerPos.y+0.5, self.playerPos.z, 8)
			end
		end
		
		--如果距离超出则卸载距离
		if self.missionDistance >= self.missionUnloadDis then
			self.Gameing = false
			-- self:MonsterDeath()
			BehaviorFunctions.HideTip(self.Tips)
			if self.goldNumber < self.goldNumberSum then
				BehaviorFunctions.ShowCommonTitle(4,'挑战失败',true)
			end
			self:LevelFinish()
			self.missionState = 999
		end

		--超时，关卡失败
		if self:Timer(self.timeLimit) <= 0 then
			self.Gameing = false
			self:MonsterDeath()
			BehaviorFunctions.HideTip(self.Tips)
			BehaviorFunctions.ShowCommonTitle(4,'挑战失败',true)
			self.missionState = 999
		end
    end
end

function LevelBehavior405020103:Hit(attackInstanceId,hitInstanceId,hitType,camp, bulletInstanceId)
    -- 检查攻击实例是否为当前角色，并且技能类型为DropAttackLand
    if attackInstanceId == self.role and BehaviorFunctions.CheckSkillType(self.role, FightEnum.SkillType.DropAttackLand) then
        -- 遍历self.monster表中的所有怪物
        for index, monster in ipairs(self.monster) do
            -- 如果被击中的实例是当前怪物
            if hitInstanceId == monster then
                local monsterPos = BehaviorFunctions.GetPositionP(monster)
                -- 检查是否可以创建金币
                if self.goldCreate <= self.goldlimit then
                    -- 创建新的金币实体并添加到goldTab表中
                    self.newGold = BehaviorFunctions.CreateEntity(self.gold, nil, monsterPos.x, monsterPos.y + 1, monsterPos.z, nil, nil, nil, self.levelId)
                    table.insert(self.goldTab, self.newGold)
                    self.goldCreate = self.goldCreate + 1
                end
            end
        end
    end
end

function LevelBehavior405020103:CastSkill(instanceId,skillId,SkillConfigSign,skillType)
	if instanceId == self.role then
		do
			if SkillConfigSign == 170 then
				BehaviorFunctions.RemoveBuff(self.role,self.jumpBuff)
				BehaviorFunctions.RemoveBuff(self.role,self.FXjumpBuff)
			elseif SkillConfigSign == 171 then
				BehaviorFunctions.RemoveBuff(self.role,self.jumpBuff)
				BehaviorFunctions.RemoveBuff(self.role,self.FXjumpBuff)
			elseif SkillConfigSign == 172 then
				BehaviorFunctions.RemoveBuff(self.role,self.jumpBuff)
				BehaviorFunctions.RemoveBuff(self.role,self.FXjumpBuff)
			end
		end
	end
end

function LevelBehavior405020103:__delete()
end

-------------------------函数-------------------------
--关卡结束函数
function LevelBehavior405020103:LevelFinish()
	BehaviorFunctions.RemoveEntity(self.Obstacle1)
	BehaviorFunctions.RemoveEntity(self.FXJumpArea)
    BehaviorFunctions.RemoveLevel(self.levelId)
end

--怪物全部死亡
function LevelBehavior405020103:MonsterDeath()
	if self.monster[1] ~= nil then
		BehaviorFunctions.SetEntityAttr(self.monster[1],1001,0)
	end
	if self.monster[2] ~= nil then
		BehaviorFunctions.SetEntityAttr(self.monster[2],1001,0)
	end
	if self.monster[3] ~= nil then
		BehaviorFunctions.SetEntityAttr(self.monster[3],1001,0)
	end
	if self.monster[4] ~= nil then
		BehaviorFunctions.SetEntityAttr(self.monster[4],1001,0)
	end
	if self.monster[5] ~= nil then
		BehaviorFunctions.SetEntityAttr(self.monster[5],1001,0)
	end
	if self.goldTab[1] ~= nil then
		BehaviorFunctions.RemoveEntity(self.goldTab[1])
	end
	if self.goldTab[2] ~= nil then
		BehaviorFunctions.RemoveEntity(self.goldTab[2])
	end
	if self.goldTab[3] ~= nil then
		BehaviorFunctions.RemoveEntity(self.goldTab[3])
	end
	if self.goldTab[4] ~= nil then
		BehaviorFunctions.RemoveEntity(self.goldTab[4])
	end
	if self.goldTab[5] ~= nil then
		BehaviorFunctions.RemoveEntity(self.goldTab[5])
	end
	if self.newGold ~= nil then
		BehaviorFunctions.RemoveEntity(self.newGold)
	end
	-- if self.FXjumpBuff ~= nil then
	BehaviorFunctions.RemoveBuff(self.role,self.jumpBuff)
	BehaviorFunctions.RemoveBuff(self.role,self.FXjumpBuff)
-- end
end

function LevelBehavior405020103:Timer(timeLimit)
    -- 如果倒计时还没有开始，先开始倒计时  
    if not self.startFrame then  
        -- 将秒数转换为帧数，因为1秒等于30帧  
        self.timeLimitFrames = timeLimit * 30  
        -- 获取当前的帧数  
        self.startFrame = BehaviorFunctions.GetFightFrame()  
    end  
    -- 计算从倒计时开始到现在过去了多少帧  
    local currentFrame = BehaviorFunctions.GetFightFrame()  
    local elapsedFrames = currentFrame - self.startFrame  
    -- 计算剩余帧数  
    local remainingFrames = self.timeLimitFrames - elapsedFrames  
    -- 如果剩余帧数为负数，则将其设置为0（即倒计时结束）  
    remainingFrames = math.max(0, remainingFrames)  
    -- 把剩余帧数转换回秒数，得到剩余时间（秒）  
    local remainingTime = math.ceil(remainingFrames / 30)
    -- 返回剩余时间  
    return remainingTime
end

-------------------------回调-------------------------

--死亡动画播完
function LevelBehavior405020103:DeathEnter(instanceId)
	if self.Gameing == true then
        for _, monster in ipairs(self.monster) do
            if instanceId == monster then
                local monsterPos = BehaviorFunctions.GetPositionP(monster)
                -- 创建新的金币实体
				if self.goldCreate <= self.goldlimit then
					self.newGold = BehaviorFunctions.CreateEntity(self.gold, nil, monsterPos.x, monsterPos.y + 0.5, monsterPos.z, nil, nil, nil, self.levelId)
					-- 将新金币添加到 goldTab 表中  
					table.insert(self.goldTab, self.newGold)
					self.goldCreate = self.goldCreate + 1
				end
			end
        end
	end
end

--死亡事件
function LevelBehavior405020103:RemoveEntity(instanceId)
	if self.Gameing == true then
		if instanceId == self.monster[1] then
			self.monster[1] = BehaviorFunctions.CreateEntity(self.monsterentityid2,nil,self.pos.x+ 10,self.pos.y,self.pos.z,nil,nil,nil,self.levelId)
			BehaviorFunctions.DoLookAtTargetImmediately(self.monster[1], self.role)
			BehaviorFunctions.SetEntityValue(self.monster[1],"haveWarn",false)   --关闭警戒
		end
		if instanceId == self.monster[2] then
			self.monster[2] = BehaviorFunctions.CreateEntity(self.monsterentityid1,nil,self.pos.x+5,self.pos.y,self.pos.z+5,nil,nil,nil,self.levelId)
			BehaviorFunctions.DoLookAtTargetImmediately(self.monster[2], self.role)
			BehaviorFunctions.SetEntityValue(self.monster[2],"haveWarn",false)   --关闭警戒
		end
		if instanceId == self.monster[3] then
			self.monster[3] = BehaviorFunctions.CreateEntity(self.monsterentityid1,nil,self.pos.x- 10,self.pos.y,self.pos.z,nil,nil,nil,self.levelId)
			BehaviorFunctions.DoLookAtTargetImmediately(self.monster[3], self.role)
			BehaviorFunctions.SetEntityValue(self.monster[3],"haveWarn",false)   --关闭警戒
		end
		if instanceId == self.monster[4] then
			self.monster[4] = BehaviorFunctions.CreateEntity(self.monsterentityid2,nil,self.pos.x- 8,self.pos.y,self.pos.z+5,nil,nil,nil,self.levelId)
			BehaviorFunctions.DoLookAtTargetImmediately(self.monster[4], self.role)
			BehaviorFunctions.SetEntityValue(self.monster[4],"haveWarn",false)   --关闭警戒
		end
		if instanceId == self.monster[5] then
			self.monster[5] = BehaviorFunctions.CreateEntity(self.monsterentityid2,nil,self.pos.x,self.pos.y,self.pos.z+10,nil,nil,nil,self.levelId)
			BehaviorFunctions.DoLookAtTargetImmediately(self.monster[5], self.role)
			BehaviorFunctions.SetEntityValue(self.monster[5],"haveWarn",false)   --关闭警戒
		end

		--金币刷新
		if self.Gameing == true then
			-- 遍历 goldTab 查找需要处理的金币实体  
			for i, goldEntity in ipairs(self.goldTab) do
				if goldEntity == instanceId then
					-- 假设 goldNumber 是用于跟踪当前金币总数的变量  
					self.goldNumber = self.goldNumber + 1
					BehaviorFunctions.ChangeSubTipsDesc(2, self.Tips, self.goldNumber, self.goldNumberSum)
					table.remove(self.goldTab, i)
					-- 如果移除了金币，且goldCreate大于0，则递减goldCreate  
					if self.goldCreate > 0 then
						self.goldCreate = self.goldCreate - 1
					end
					break
				end
			end
		end
	end
end