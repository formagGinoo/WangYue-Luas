LevelBehavior405020101 = BaseClass("LevelBehavior405020101",LevelBehaviorBase)
--普通任务刷怪关

function LevelBehavior405020101:__init(fight)
    self.fight = fight
end

function LevelBehavior405020101.GetGenerates()
    local generates = {790012000,2041114,203040701,2041111,2041115,
    }
    return generates
end

function LevelBehavior405020101.GetMagics()
	local generates = {1000101,1000103,1000104}
	return generates
end

function LevelBehavior405020101:Init()
	self.role = 1
	self.missionState = 0
	-- self.logicName = 'Logic_Level405020101'
	self.monster ={
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
	}
	self.pos = 0
	self.pos2 = 0
	self.monsterentityid = 790012000
	self.gold = 2041114			--金币实体ID
	self.goldTab = {}
	self.newGold = nil
	self.Tips = 102670103
	self.goldNumber = 0
	self.goldNumberSum = 20
	self.goldCreate = 0
	self.goldlimit = 6
	self.Obstacle = 2041111 		--障碍物
	self.Gameing = true				--定义关卡是否还进行
	self.GameStop = false			--关卡终止
	self.Obstacle1 = nil			--踏板1
	self.Obstacle2 = nil			--踏板2
	self.ecoId = 2003001200001		--生态实体
	self.eco = nil
	self.ecorewardId = 3003001080005		--生态奖励实体
	self.ecoreward = nil


	self.combatBuff = 1000101
	self.jumpBuff = 1000103
	self.FXjumpBuff = 1000104
	self.FXJumpArea = 2041115

	self.missionUnloadDis = 75             --卸载距离
    self.playerPos = nil
    self.missionDistance = 0
    self.missionStartPos = nil

	self.rolejump = false

    self.currentWave = 1          --当前波次
	self.currentWaveNum = 0       --当前波次怪物总数
	self.deathCount = 0           --死亡计数
	self.currentWaveLookAtPos = nil       --当前波次关卡相机朝向
	self.levelShouldFinish = false
	self.alreadyAttackDialog = false
end

function LevelBehavior405020101:Update()
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

	if self.missionState == 0 then
		-- if self.eco ~= nil then
		-- 	BehaviorFunctions.InteractEntityHit(self.eco,false)
		-- end
		-- BehaviorFunctions.ShowBlackCurtain(true,0.25,false)
		-- BehaviorFunctions.AddDelayCallByTime(0.75,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.25,false)
		--BehaviorFunctions.AddDelayCallByTime(0.35,self,self.missionState,8)

		self.Obstacle1 = BehaviorFunctions.CreateEntityByPosition(self.Obstacle, nil, "pos4", self.logicName, self.levelId, nil, nil)
		self.Obstacle2 = BehaviorFunctions.CreateEntityByPosition(self.Obstacle, nil, "pos5", self.logicName, self.levelId, nil, nil)
		self.missionState = 1
	end

    if self.missionState == 1 then
		-- BehaviorFunctions.InMapTransport(self.pos.x,self.pos.y,self.pos.z)
		BehaviorFunctions.ShowCommonTitle(4,'挑战开始',true)
		BehaviorFunctions.ShowTip(self.Tips)
		BehaviorFunctions.ChangeSubTipsDesc(2, self.Tips,self.goldNumber,self.goldNumberSum)

		BehaviorFunctions.CreateEntity(self.FXJumpArea,nil,self.pos2.x,self.pos2.y,self.pos2.z,nil,nil,nil,self.levelId)			--创建跳跃特效

		self.monster[1] = BehaviorFunctions.CreateEntity(self.monsterentityid,nil,self.pos.x+ 8,self.pos.y,self.pos.z+5,nil,nil,nil,self.levelId)
		BehaviorFunctions.DoLookAtTargetImmediately(self.monster[1], self.role)
		BehaviorFunctions.SetEntityValue(self.monster[1],"haveWarn",false)   --关闭警戒

		self.monster[2] = BehaviorFunctions.CreateEntity(self.monsterentityid,nil,self.pos.x+10,self.pos.y,self.pos.z,nil,nil,nil,self.levelId)
		BehaviorFunctions.DoLookAtTargetImmediately(self.monster[2], self.role)
		BehaviorFunctions.SetEntityValue(self.monster[2],"haveWarn",false)   --关闭警戒

		self.monster[3] = BehaviorFunctions.CreateEntity(self.monsterentityid,nil,self.pos.x+8,self.pos.y,self.pos.z- 5,nil,nil,nil,self.levelId)
		BehaviorFunctions.DoLookAtTargetImmediately(self.monster[3], self.role)
		BehaviorFunctions.SetEntityValue(self.monster[3],"haveWarn",false)   --关闭警戒

		do
			local levelCam = BehaviorFunctions.CreateEntity(22007)
			BehaviorFunctions.CameraEntityFollowTarget(levelCam,self.role,"CameraTarget")
			BehaviorFunctions.CameraEntityLockTarget(levelCam,self.monster[1])
			BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.monster[1])
			BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,levelCam)
		end

        self.missionState = 2
	end

    if self.missionState == 2 then
		if BehaviorFunctions.CheckEntityInArea(self.role,'JumpArea','Logic_Level405020101') then
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
    end
end

function LevelBehavior405020101:Hit(attackInstanceId,hitInstanceId,hitType,camp, bulletInstanceId)
    if attackInstanceId == self.role and BehaviorFunctions.CheckSkillType(self.role, FightEnum.SkillType.DropAttackLand) then
        -- 假设 self.monster 是一个包含所有怪物的表  
        for _, monster in ipairs(self.monster) do
            if hitInstanceId == monster then
                local monsterPos = BehaviorFunctions.GetPositionP(monster)
                -- 创建新的金币实体
                if self.goldCreate <= self.goldlimit then
                    self.newGold = BehaviorFunctions.CreateEntity(self.gold, nil, monsterPos.x, monsterPos.y + 1, monsterPos.z, nil, nil, nil, self.levelId)
                    -- 将新金币添加到 goldTab 表中  
                    table.insert(self.goldTab, self.newGold)
                    self.goldCreate = self.goldCreate + 1
                end
            end
        end
    end
end

function LevelBehavior405020101:CastSkill(instanceId,skillId,SkillConfigSign,skillType)
	if instanceId == self.role then
		if self.Gameing == true then
			do
				if SkillConfigSign == 170 then
					BehaviorFunctions.AddBuff(self.role,self.role,self.combatBuff)
					BehaviorFunctions.RemoveBuff(self.role,self.jumpBuff)
					BehaviorFunctions.RemoveBuff(self.role,self.FXjumpBuff)
				elseif SkillConfigSign == 171 then
					BehaviorFunctions.AddBuff(self.role,self.role,self.combatBuff)
					BehaviorFunctions.RemoveBuff(self.role,self.jumpBuff)
					BehaviorFunctions.RemoveBuff(self.role,self.FXjumpBuff)
				elseif SkillConfigSign == 172 then
					BehaviorFunctions.AddBuff(self.role,self.role,self.combatBuff)
					BehaviorFunctions.RemoveBuff(self.role,self.jumpBuff)
					BehaviorFunctions.RemoveBuff(self.role,self.FXjumpBuff)
				end
			end
		end
	end
end

function LevelBehavior405020101:BreakSkill(instanceId,skillId,SkillConfigSign,skillType)
	if instanceId == self.role then
		if SkillConfigSign == 170 then
			BehaviorFunctions.RemoveBuff(self.role,self.combatBuff)
		elseif SkillConfigSign == 171 then
			BehaviorFunctions.RemoveBuff(self.role,self.combatBuff)
		elseif SkillConfigSign == 172 then
			BehaviorFunctions.RemoveBuff(self.role,self.combatBuff)
		end
	end
end

function LevelBehavior405020101:FinishSkill(instanceId,skillId,SkillConfigSign,skillType)
	if instanceId == self.role then
		if SkillConfigSign == 170 then
			BehaviorFunctions.RemoveBuff(self.role,self.combatBuff)
		elseif SkillConfigSign == 171 then
			BehaviorFunctions.RemoveBuff(self.role,self.combatBuff)
		elseif SkillConfigSign == 172 then
			BehaviorFunctions.RemoveBuff(self.role,self.combatBuff)
		end
	end
end

function LevelBehavior405020101:__delete()
end

-------------------------函数-------------------------
--关卡结束函数
function LevelBehavior405020101:LevelFinish()
	BehaviorFunctions.RemoveEntity(self.Obstacle1)
	BehaviorFunctions.RemoveEntity(self.Obstacle2)
	BehaviorFunctions.RemoveEntity(self.FXJumpArea)
    BehaviorFunctions.RemoveLevel(self.levelId)
end

--怪物全部死亡
function LevelBehavior405020101:MonsterDeath()
	if self.monster[1] ~= nil then
		BehaviorFunctions.SetEntityAttr(self.monster[1],1001,0)
	end
	if self.monster[2] ~= nil then
		BehaviorFunctions.SetEntityAttr(self.monster[2],1001,0)
	end
	if self.monster[3] ~= nil then
		BehaviorFunctions.SetEntityAttr(self.monster[3],1001,0)
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
	if self.newGold ~= nil then
		BehaviorFunctions.RemoveEntity(self.newGold)
	end
	-- if self.FXjumpBuff ~= nil then
	BehaviorFunctions.RemoveBuff(self.role,self.jumpBuff)
	BehaviorFunctions.RemoveBuff(self.role,self.FXjumpBuff)
	BehaviorFunctions.RemoveBuff(self.role,self.combatBuff)
	-- end
end

function LevelBehavior405020101:HitTtigger()
	
end
-------------------------回调-------------------------

--死亡动画播完
function LevelBehavior405020101:DeathEnter(instanceId)
	if self.Gameing == true then
        for _, monster in ipairs(self.monster) do
            if instanceId == monster then
                local monsterPos = BehaviorFunctions.GetPositionP(monster)
                -- 创建新的金币实体
				if self.goldCreate <= self.goldlimit then
					self.newGold = BehaviorFunctions.CreateEntity(self.gold, nil, monsterPos.x, monsterPos.y + 1, monsterPos.z, nil, nil, nil, self.levelId)
					-- 将新金币添加到 goldTab 表中  
					table.insert(self.goldTab, self.newGold)
					self.goldCreate = self.goldCreate + 1
				end
			end
        end
	end
end

--死亡事件
function LevelBehavior405020101:RemoveEntity(instanceId)
	if self.Gameing == true then

		if instanceId == self.monster[1] then
			self.monster[1] = BehaviorFunctions.CreateEntity(self.monsterentityid,nil,self.pos.x+ 10,self.pos.y,self.pos.z,nil,nil,nil,self.levelId)
			BehaviorFunctions.DoLookAtTargetImmediately(self.monster[1], self.role)
			BehaviorFunctions.SetEntityValue(self.monster[1],"haveWarn",false)   --关闭警戒
		end
		if instanceId == self.monster[2] then
			self.monster[2] = BehaviorFunctions.CreateEntity(self.monsterentityid,nil,self.pos.x,self.pos.y,self.pos.z+ 10,nil,nil,nil,self.levelId)
			BehaviorFunctions.DoLookAtTargetImmediately(self.monster[2], self.role)
			BehaviorFunctions.SetEntityValue(self.monster[2],"haveWarn",false)   --关闭警戒
		end
		if instanceId == self.monster[3] then
			self.monster[3] = BehaviorFunctions.CreateEntity(self.monsterentityid,nil,self.pos.x- 10,self.pos.y,self.pos.z,nil,nil,nil,self.levelId)
			BehaviorFunctions.DoLookAtTargetImmediately(self.monster[3], self.role)
			BehaviorFunctions.SetEntityValue(self.monster[3],"haveWarn",false)   --关闭警戒
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