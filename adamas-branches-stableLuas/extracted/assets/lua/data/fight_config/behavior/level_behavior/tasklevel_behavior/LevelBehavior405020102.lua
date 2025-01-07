LevelBehavior405020102 = BaseClass("LevelBehavior405020102",LevelBehaviorBase)
--普通任务刷怪关

function LevelBehavior405020102:__init(fight)
    self.fight = fight
end

function LevelBehavior405020102.GetGenerates()
    local generates = {790012000,790013000,2041114,2041111,2041112,2041113,203040701,2041115,
	2041101,			--空实体
	22001,				--相机
    }
    return generates
end

function LevelBehavior405020102.GetMagics()
	local generates = {900000001}
	return generates
end

function LevelBehavior405020102:Init()
	self.role = 1
	self.missionState = 0
	self.monster ={
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
	}
	self.pos = 0
	self.pos2 = 0
	self.monsterentityid1 = 790012000
	self.monsterentityid2 = 790013000
	self.gold = 2041114			--金币实体ID
	self.goldTab = {}
	self.newGold = nil
	self.Tips = 102670104
	self.ShowCommonTitleCheck = false

	self.goldNumber = 0
	self.goldNumberSum = 20
	self.goldCreate = 0
	self.goldlimit = 8
	-- self.Obstacle1 = 2041111 		--障碍物
	-- self.Obstacle2 = 2041112 		--障碍物
	-- self.Obstacle3 = 2041113 		--障碍物
	-- self.ecoId = 2003001111001		--生态实体
	-- self.eco = nil
	self.ecorewardId = 3003001030001		--生态奖励实体
	self.ecoreward = nil

	self.MonBuff = 1000102
	self.combatBuff = 1000101
	self.jumpBuff = 1000103
	self.FXjumpBuff = 1000104
	self.FXJumpArea = 2041115

	self.Gameing = true				--定义关卡是否还进行
	self.GameStop = false			--关卡终止

	--教学内容
	self.teachTipsID = 20036
	self.teachCheck = false
	self.teachInsterId = nil

	-- self.Obstacle = {
	-- 	[1] = nil,
	-- 	[2] = nil,
	-- 	[3] = nil,
	-- 	[4] = nil,
	-- }

	self.missionUnloadDis = 50             --卸载距离
    self.playerPos = nil
    self.missionDistance = 0
    self.missionStartPos = nil

	self.countAdd = 5
	self.count ={
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
	}

    self.currentWave = 1          --当前波次
	self.currentWaveNum = 0       --当前波次怪物总数
	self.deathCount = 0           --死亡计数
	self.currentWaveLookAtPos = nil       --当前波次关卡相机朝向

	--关卡倒计时
	self.updateframe = 0
	self.timeLimit = 60
	self.startFrame = nil
	self.timeLimitFrames = 0
	self.timeCheck = false
	self.timeAddCheck = false
	self.Add = 45
	self.timeAdd = nil

	--End关卡计时
	self.updateframeEnd = 0
	self.timeAddCheckEnd = false
	self.timeAddEnd = nil

	--延时调用
	self.delayCallList = {}
	--当前延时数量
	self.currentdelayCallNum = 0

	--关卡相机
	self.empty = nil
	self.levelCam = nil
	self.camNilEntityID = 2041101
	self.camID = nil

	--区域占用
	self.ShowMapAreaCheck = false

end

function LevelBehavior405020102:Update()
    self.role = BehaviorFunctions.GetCtrlEntity()
    self.updateframe = BehaviorFunctions.GetFightFrame()
	self.updateframeEnd = BehaviorFunctions.GetFightFrame()
	-- self.eco = BehaviorFunctions.GetEcoEntityByEcoId(self.ecoId)
	self.ecoreward = BehaviorFunctions.GetEcoEntityByEcoId(self.ecorewardId)

	self.pos = BehaviorFunctions.GetTerrainPositionP("Player",self.levelId)
	self.pos2 = BehaviorFunctions.GetTerrainPositionP("TreasureBox",self.levelId)
	self.pos3 = BehaviorFunctions.GetTerrainPositionP("pos5",self.levelId)

	--距离太远卸载关卡
	if self.playerPos == nil then
		self.playerPos = BehaviorFunctions.GetPositionP(self.role)										--获取玩家的坐标
	end
    self.missionStartPos = BehaviorFunctions.GetTerrainPositionP("Player",self.levelId,self.logicName)
	self.missionDistance = BehaviorFunctions.GetDistanceFromPos(self.playerPos,self.missionStartPos)		--获取玩家和肉鸽的距离

	--如果距离超出则卸载距离
	if self.missionDistance >= self.missionUnloadDis then
		self.Gameing = false
		-- self:MonsterDeath()
		BehaviorFunctions.HideTip(self.Tips)
		if self.goldNumber < self.goldNumberSum then
			BehaviorFunctions.ShowCommonTitle(8,'挑战失败',false)
		end
		self:LevelFinish()
		BehaviorFunctions.RemoveLevel(self.levelId)
		self.missionState = 999
	end

	--关卡胜利
	if self.goldNumber >= self.goldNumberSum then
		if self.GameStop == false then
			self.Gameing = false
			if 	self.ShowCommonTitleCheck == true then
				self:MonsterDeath()
				BehaviorFunctions.HideTip(self.Tips)
				BehaviorFunctions.ShowCommonTitle(5,'挑战胜利',true)
				self.ShowCommonTitleCheck = false
			end
			--关卡胜利延时
			if self.timeAddCheckEnd == false then
				self.timeAddEnd =  self.updateframeEnd	-- + self.AddEnd
				self.timeAddCheckEnd = true
			end
			if self.updateframeEnd >= (self.timeAddEnd + 60) and self.updateframeEnd < (self.timeAddEnd + 65) then
				if self.missionState ~= 999 then
					self:LevelFinish()

					-- if self.ecoreward ~= nil then		--发放奖励
					-- 	BehaviorFunctions.InteractEntityHit(self.ecoreward,true)
					-- end

					BehaviorFunctions.FinishLevel(self.levelId)		--自动发放奖励
					self.missionState = 999
					self.GameStop = true
				end
			elseif self.updateframeEnd >= (self.timeAddEnd + 90) and self.updateframeEnd < (self.timeAddEnd + 95) then
			end
		end
	end

	if self.missionState == 0 then
		-- BehaviorFunctions.CreateEntityByPosition(self.FXJumpArea, nil, "Player", self.logicName, self.levelId, self.levelId, nil)

		--教学
		-- if BehaviorFunctions.CheckTeachIsFinish(self.teachTipsID) == false then
			if self.teachCheck == false then
				BehaviorFunctions.ShowGuideImageTips(self.teachTipsID)
				-- self.teachInsterId = BehaviorFunctions.AddLevelTips(405020102,self.levelId)
				-- BehaviorFunctions.ShowLevelInstruction(405020102)
				-- BehaviorFunctions.AddDelayCallByTime(1.5,BehaviorFunctions,BehaviorFunctions.ShowGuideImageTips,self.teachTipsID)
				self.teachCheck = true
			end
		-- end

		--延时
		if self.timeAddCheck == false then
			self.timeAdd =  self.updateframe	-- + self.Add
			self.timeAddCheck = true
		end
		if self.updateframe >= self.timeAdd and self.updateframe < (self.timeAdd + 1) then
			self:DisablePlayerInput(true,true)

			-- BehaviorFunctions.SetJoyMoveEnable(self.role,false)
			-- for i,v in ipairs(FightEnum.KeyEvent) do
			-- 	BehaviorFunctions.ForbidKey(i,false)
			-- end

			--开场倒计时
			BehaviorFunctions.ShowCountDownPanel(3, self.levelId)

		-- elseif self.updateframe >= (self.timeAdd + 30) and self.updateframe < (self.timeAdd + 40) then
		-- 	BehaviorFunctions.ShowTip(10010010)
		-- elseif self.updateframe >= (self.timeAdd + 60) and self.updateframe < (self.timeAdd + 70) then
		-- 	BehaviorFunctions.ShowTip(10010011)
		elseif self.updateframe >= (self.timeAdd + 120) and self.updateframe < (self.timeAdd + 125) then
			if self.ShowCommonTitleCheck == false then
				BehaviorFunctions.ShowCommonTitle(10,'下落攻击挑战开始',true)
				do	--刷怪
					self.monster[1] = BehaviorFunctions.CreateEntityByPosition(self.monsterentityid2, nil, "pos1", self.logicName, self.levelId,self.levelId)
					BehaviorFunctions.DoLookAtTargetImmediately(self.monster[1], self.role)
	
					self.monster[2] = BehaviorFunctions.CreateEntityByPosition(self.monsterentityid1, nil, "pos2", self.logicName, self.levelId,self.levelId)
					BehaviorFunctions.DoLookAtTargetImmediately(self.monster[2], self.role)
	
					self.monster[3] = BehaviorFunctions.CreateEntityByPosition(self.monsterentityid1, nil, "pos3", self.logicName, self.levelId,self.levelId)
					BehaviorFunctions.DoLookAtTargetImmediately(self.monster[3], self.role)
	
					self.monster[4] = BehaviorFunctions.CreateEntityByPosition(self.monsterentityid2, nil, "pos4", self.logicName, self.levelId,self.levelId)
					BehaviorFunctions.DoLookAtTargetImmediately(self.monster[4], self.role)
				end
				self.ShowCommonTitleCheck = true
			end
			self:DisablePlayerInput(false,false)

		-- 	-- BehaviorFunctions.SetJoyMoveEnable(self.role,true)
		-- 	-- for i,v in ipairs(FightEnum.KeyEvent) do
		-- 	-- 	BehaviorFunctions.ForbidKey(i,true)
		-- 	-- end
		-- 	BehaviorFunctions.ShowTip(10010012)

		elseif self.updateframe >= (self.timeAdd + 180) and self.updateframe < (self.timeAdd + 185) then
			self.missionState = 1
			-- BehaviorFunctions.ShowTip(1028)
		-- elseif self.updateframe >= (self.timeAdd + 145) and self.updateframe < (self.timeAdd + 150) then

		end

		-- self:AddLevelDelayCallByFrame(3,BehaviorFunctions,BehaviorFunctions.ShowTip,10010010)
		-- self:AddLevelDelayCallByFrame(5,BehaviorFunctions,BehaviorFunctions.ShowTip,10010011)
		-- self:AddLevelDelayCallByFrame(7,BehaviorFunctions,BehaviorFunctions.ShowTip,10010012)

    elseif self.missionState == 1 then
		-- BehaviorFunctions.InMapTransport(self.pos.x,self.pos.y,self.pos.z)
		self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowTip,self.Tips)
		self:AddLevelDelayCallByFrame(31,BehaviorFunctions,BehaviorFunctions.ChangeSubTipsDesc,2, self.Tips,self.goldNumber,self.goldNumberSum)
		-- BehaviorFunctions.ShowTip(self.Tips)
		-- BehaviorFunctions.ChangeSubTipsDesc(1, self.Tips,self.goldNumber,self.goldNumberSum)
		BehaviorFunctions.SetEntityValue(self.monster[1],"haveWarn",false)   --关闭警戒
		BehaviorFunctions.SetEntityValue(self.monster[2],"haveWarn",false)   --关闭警戒
		BehaviorFunctions.SetEntityValue(self.monster[3],"haveWarn",false)   --关闭警戒
		BehaviorFunctions.SetEntityValue(self.monster[4],"haveWarn",false)   --关闭警戒
        self.missionState = 2
    elseif  self.missionState == 2 then

		if BehaviorFunctions.CheckEntityInArea(self.role,'JumpArea','Logic_Level405020102') then
			if self.Gameing == true then
				--怪物和区域占用
				self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowLevelEnemy,self.levelId, true)
				if self.ShowMapAreaCheck == false then
					self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowMapArea,self.levelId, true)
					print("区域占用")
					self.ShowMapAreaCheck = true
				end

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
			else
				BehaviorFunctions.RemoveBuff(self.role,self.jumpBuff)
				BehaviorFunctions.RemoveBuff(self.role,self.FXjumpBuff)
			end
		else
			BehaviorFunctions.RemoveBuff(self.role,self.jumpBuff)
			BehaviorFunctions.RemoveBuff(self.role,self.FXjumpBuff)
		end

		--金币移动
		do
			if self.Gameing == true then
				if self.goldTab[1] ~= nil then
					BehaviorFunctions.DoPreciseMoveToPositionBySpeed(self.goldTab[1], self.playerPos.x, self.playerPos.y+0.5, self.playerPos.z, 5)
				end
				if self.goldTab[2] ~= nil then
					BehaviorFunctions.DoPreciseMoveToPositionBySpeed(self.goldTab[2], self.playerPos.x, self.playerPos.y+0.5, self.playerPos.z, 5)
				end
				if self.goldTab[3] ~= nil then
					BehaviorFunctions.DoPreciseMoveToPositionBySpeed(self.goldTab[3], self.playerPos.x, self.playerPos.y+0.5, self.playerPos.z, 5)
				end
				if self.goldTab[4] ~= nil then
					BehaviorFunctions.DoPreciseMoveToPositionBySpeed(self.goldTab[4], self.playerPos.x, self.playerPos.y+0.5, self.playerPos.z, 5)
				end
			end
		end
    end
end

--教学结束
function  LevelBehavior405020102:LevelInstructionComplete(tipId)
	if tipId == 405020102 then
		--镜头转向
		do
			-- self:LevelLookAtPos("TreasureBox",22007)
			local levelCam = BehaviorFunctions.CreateEntity(22007)
			self.camID = BehaviorFunctions.CreateEntityByPosition(self.camNilEntityID, nil, "TreasureBox", self.logicName, self.levelId, self.levelId, nil)
			BehaviorFunctions.CameraEntityFollowTarget(levelCam,self.role,"CameraTarget")
			BehaviorFunctions.CameraEntityLockTarget(levelCam,self.camID)
			BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.camID)
			self:AddLevelDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,levelCam)
			-- BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,levelCam)
		end
	end
end
function BehaviorBase:OnGuideImageTips(tipsId,isOpen)
	if tipsId == self.teachTipsID and isOpen == true then
		--镜头转向
		do
			-- self:LevelLookAtPos("TreasureBox",22007)
			local levelCam = BehaviorFunctions.CreateEntity(22007)
			self.camID = BehaviorFunctions.CreateEntityByPosition(self.camNilEntityID, nil, "TreasureBox", self.logicName, self.levelId, self.levelId, nil)
			BehaviorFunctions.CameraEntityFollowTarget(levelCam,self.role,"CameraTarget")
			BehaviorFunctions.CameraEntityLockTarget(levelCam,self.camID)
			BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.camID)
			self:AddLevelDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,levelCam)
			-- BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,levelCam)
		end
	end
end

function LevelBehavior405020102:Hit(attackInstanceId,hitInstanceId,hitType,camp, bulletInstanceId)
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
                    self.newGold = BehaviorFunctions.CreateEntity(self.gold, nil, monsterPos.x, monsterPos.y + 0.5, monsterPos.z, nil, nil, nil, self.levelId)
                    table.insert(self.goldTab, self.newGold)
                    self.goldCreate = self.goldCreate + 1
                end
                -- 检查计数器是否达到设定的值
                local countReached = self:increment(index, self.countAdd) == self.countAdd
                -- 如果计数器达到设定值，则添加增益效果
                if countReached then
                    BehaviorFunctions.AddBuff(monster, monster, self.MonBuff)
                    self:reverCount(index)
                end
            end
        end
    end
end

function LevelBehavior405020102:CastSkill(instanceId,skillId,SkillConfigSign,skillType)
	if instanceId == self.role then
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
		do
		-- 	if SkillConfigSign == 170 then
		-- 		BehaviorFunctions.AddBuff(self.role,self.role,self.combatBuff)
		-- 	elseif SkillConfigSign == 171 then
		-- 		BehaviorFunctions.AddBuff(self.role,self.role,self.combatBuff)
		-- 	elseif SkillConfigSign == 172 then
		-- 		BehaviorFunctions.AddBuff(self.role,self.role,self.combatBuff)
		-- 	end
		end
	end
end

function LevelBehavior405020102:BreakSkill(instanceId,skillId,SkillConfigSign,skillType)
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

function LevelBehavior405020102:FinishSkill(instanceId,skillId,SkillConfigSign,skillType)
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

function LevelBehavior405020102:__delete()
end

-------------------------函数-------------------------
--关卡结束函数
function LevelBehavior405020102:LevelFinish()
	BehaviorFunctions.RemoveEntity(self.FXJumpArea)
	self:RemoveAllLevelDelayCall()
end

--怪物全部死亡
function LevelBehavior405020102:MonsterDeath()
	if self.monster[1] ~= nil then
		BehaviorFunctions.SetEntityAttr(self.monster[1],1001,0)
		self.monster[1] = nil
	end
	if self.monster[2] ~= nil then
		BehaviorFunctions.SetEntityAttr(self.monster[2],1001,0)
		self.monster[2] = nil
	end
	if self.monster[3] ~= nil then
		BehaviorFunctions.SetEntityAttr(self.monster[3],1001,0)
		self.monster[3] = nil
	end
	if self.monster[4] ~= nil then
		BehaviorFunctions.SetEntityAttr(self.monster[4],1001,0)
		self.monster[4] = nil
	end
	if self.goldTab[1] ~= nil then
		BehaviorFunctions.RemoveEntity(self.goldTab[1])
		self.goldTab[1] = nil
	end
	if self.goldTab[2] ~= nil then
		BehaviorFunctions.RemoveEntity(self.goldTab[2])
		self.goldTab[2] = nil
	end
	if self.goldTab[3] ~= nil then
		BehaviorFunctions.RemoveEntity(self.goldTab[3])
		self.goldTab[3] = nil
	end
	if self.goldTab[4] ~= nil then
		BehaviorFunctions.RemoveEntity(self.goldTab[4])
		self.goldTab[4] = nil
	end
	if self.newGold ~= nil then
		BehaviorFunctions.RemoveEntity(self.newGold)
		self.newGold = nil
	end
	for i,delaycallId in ipairs(self.goldTab) do
		if delaycallId ~= nil then
			BehaviorFunctions.RemoveEntity(delaycallId)
		end
	end
	-- if self.FXjumpBuff ~= nil then
	BehaviorFunctions.RemoveBuff(self.role,self.jumpBuff)
	BehaviorFunctions.RemoveBuff(self.role,self.FXjumpBuff)
	-- end
end

-- 辅助函数，用于递增计数器并检查是否达到设定值
function LevelBehavior405020102:increment(index, countAdd)
    self.count[index] = self.count[index] or 0
    self.count[index] = self.count[index] + countAdd
    return self.count[index]
end

-- 辅助函数，用于重置计数器
function LevelBehavior405020102:reverCount(index)
    self.count[index] = 0
end

-------------------------回调-------------------------

--死亡动画播完
function LevelBehavior405020102:DeathEnter(instanceId)
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
function LevelBehavior405020102:RemoveEntity(instanceId)
	if self.Gameing == true then
		if instanceId == self.monster[1] then
			self.monster[1] = BehaviorFunctions.CreateEntityByPosition(self.monsterentityid2, nil, "pos1", self.logicName, self.levelId,self.levelId)
			-- BehaviorFunctions.DoLookAtTargetImmediately(self.monster[1], self.role)
			BehaviorFunctions.SetEntityValue(self.monster[1],"haveWarn",false)   --关闭警戒
		end
		if instanceId == self.monster[2] then
			self.monster[2] = BehaviorFunctions.CreateEntityByPosition(self.monsterentityid1, nil, "pos2", self.logicName, self.levelId,self.levelId)
			-- BehaviorFunctions.DoLookAtTargetImmediately(self.monster[2], self.role)
			BehaviorFunctions.SetEntityValue(self.monster[2],"haveWarn",false)   --关闭警戒
		end
		if instanceId == self.monster[3] then
			self.monster[3] = BehaviorFunctions.CreateEntityByPosition(self.monsterentityid1, nil, "pos3", self.logicName, self.levelId,self.levelId)
			-- BehaviorFunctions.DoLookAtTargetImmediately(self.monster[3], self.role)
			BehaviorFunctions.SetEntityValue(self.monster[3],"haveWarn",false)   --关闭警戒
		end
		if instanceId == self.monster[4] then
			self.monster[4] = BehaviorFunctions.CreateEntityByPosition(self.monsterentityid2, nil, "pos4", self.logicName, self.levelId,self.levelId)
			-- BehaviorFunctions.DoLookAtTargetImmediately(self.monster[4], self.role)
			BehaviorFunctions.SetEntityValue(self.monster[4],"haveWarn",false)   --关闭警戒
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

--关卡延时调用帧数（卸载时自动移除剩余的DelayCall）
function LevelBehavior405020102:AddLevelDelayCallByFrame(frame,obj,callback,...)
	local delayId = BehaviorFunctions.AddDelayCallByFrame(frame,obj,callback,...)
	self.currentdelayCallNum = self.currentdelayCallNum + 1
	table.insert(self.delayCallList,self.currentdelayCallNum,delayId)
	return delayId
end
--移除所有关卡延时调用
function LevelBehavior405020102:RemoveAllLevelDelayCall()
	for i,delaycallId in ipairs(self.delayCallList) do
		BehaviorFunctions.RemoveDelayCall(delaycallId)
	end
end

function LevelBehavior405020102:DisablePlayerInput(isOpen,closeUI)
	--取消摇杆移动
	BehaviorFunctions.CancelJoystick()
	if isOpen then
		----禁用摇杆输入
		--BehaviorFunctions.SetJoyMoveEnable(self.role,false)
		--关闭按键输入
		for i,v in ipairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(i,true)
		end
	else
		BehaviorFunctions.SetJoyMoveEnable(self.role,true)
		for i,v in ipairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(i,false)
		end
	end
	if closeUI then
		--屏蔽战斗主UI
		BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",false)
	else
		--显示战斗主UI
		BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",true)
	end
end
