Behavior62002 = BaseClass("Behavior62002",EntityBehaviorBase)
--资源预加载
function Behavior62002.GetGenerates()
	local generates = {}
	return generates
end

function Behavior62002.GetMagics()
	local generates = {}
	return generates
end

function Behavior62002:Init()
	self.me = self.instanceId	--记录自身
	self.role = nil
	
	--召唤状态枚举
	self.summonStateEnum =
	{
		NotSummon = 1,
		Summoned = 2,
		CannotSummon = 3,
		Exiting = 4
	}

	--当前召唤状态
	self.currentSummonState = self.summonStateEnum.NotSummon

	--配从行为枚举
	self.behaviorStateEnum =
	{
		Idle = 1,
		Moving = 2,
		UseingSkill = 3,
		Die = 4,
	}

	--当前行为状态
	self.currentBehaviorState = self.behaviorStateEnum.Idle
	
	--目标相关判断
	self.battleTarget = nil
	self.hasBattleTarget = false
	
	self.roleLockInf = 
	{
		--当前锁定目标
		LockTarget = nil,
		LockTargetPoint = nil,
		LockTargetPart = nil,
		
		--当前战斗目标
		AttackTarget = nil,
		AttackTargetPoint = nil,
		AttackTargetPart = nil ,
		
		--备用锁定目标
		LockAltnTarget = nil,
		LockAltnTargetPoint = nil ,
		LockAltnTargetPart = nil ,		
		
		--备用战斗目标
		AttackAltnTarget = nil,
		AttackAltnTargetPoint = nil,
		AttackAltnTargetPart = nil,
	}
	
	self.summonStartTime = nil --召唤开始时间
	self.summonEnd = nil --召唤结束时间
	self.summonLimit = false --召唤限制是否开启
	
	self.roleFrontPos = nil --角色前方位置
	
-------------------配置-------------------------------------------------------
	self.summonTime = 30 --召唤时间（秒）
	self.partnerSummonSkill = 62002001 --佩从召唤技能
	self.partnerExitSkill = 62002002 -- 配从退场技能
	self.exitFrame = 30
	self.currentPartnerBtn = self.partnerSummonSkill --当前仲魔按钮技能
	self.summonDistance = 8 --最佳召唤距离
	self.summonAngle = 0 --最佳召唤角度
	self.summonRangeLimit = 20--最大召唤范围
	
	self.summonChecFrame = 15 --召唤按钮检查间隔
end

function Behavior62002:LateInit()
	--获取佩从对应角色
	self.role = BehaviorFunctions.GetEntityOwner(self.me)
	--获取自身实体ID
	self.myEntityId = BehaviorFunctions.GetEntityTemplateId(self.me)
end

function Behavior62002:Update()
	--返回角色前方位置
	self.roleFrontPos = BehaviorFunctions.GetPositionOffsetBySelf(self.role,20,0)
	--召唤状态机
	self:SummonFSM()
	--获取战斗目标
	self:GetRoleBattleTarget()
	--技能使用逻辑
	self:SkillLogic()
	
	if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Interaction) then

	end
end

--技能窗口标识
function Behavior62002:AddSkillSign(instanceId,sign)
	if instanceId == self.role then
		--角色主动使用佩从技能窗口
		if sign == 600000002 then
			self:SummonPartner()
		end		
	end
end

--召唤佩从
function Behavior62002:SummonPartner()
	--检查是否有召唤限制
	if not self.summonLimit then
		self.currentSummonState = self.summonStateEnum.Summoned
		local pos = self:ReturnTeleportPosition(self.role,self.summonDistance,self.summonAngle,self.summonAngle,0.5,false)
		BehaviorFunctions.DoSetPosition(self.me,pos.x,pos.y,pos.z)
		--BehaviorFunctions.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")	--打断佩从离场流程
		BehaviorFunctions.ShowPartner(self.role, true)	--显示佩从
		BehaviorFunctions.SetFightUISkillBtnId(self.me,FightEnum.KeyEvent.Partner,self.partnerExitSkill)--切换仲魔技能ID为退场技能
		self:SwitchControl(self.me)--切换操控模式
		--如果当前有战斗目标
		if self.hasBattleTarget then
			BehaviorFunctions.CastSkillByTarget(self.me,self.partnerSummonSkill,self.battleTarget)
			--BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.battleTarget)--面向敌人
			BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.roleFrontPos.x,self.roleFrontPos.y,self.roleFrontPos.z,true)	--设置朝向
		--如果当前没有战斗目标
		elseif not self.hasBattleTarget then
			BehaviorFunctions.CastSkillBySelfPosition(self.me,self.partnerSummonSkill)
			BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.roleFrontPos.x,self.roleFrontPos.y,self.roleFrontPos.z,true)	--设置朝向
		end
	end
end

--配从退场
function Behavior62002:ExitPartner()
	self.currentSummonState = self.summonStateEnum.NotSummon
	BehaviorFunctions.AddEntitySign(self.me,620020001,self.exitFrame,false)--标记为处于退场状态
	BehaviorFunctions.RemoveEntitySign(self.me,620020012)--移除相机参数
	BehaviorFunctions.CastSkillBySelfPosition(self.me,self.partnerExitSkill) -- 释放退场技能
	BehaviorFunctions.CastSkillCost(self.me,self.partnerExitSkill)
	BehaviorFunctions.DoMagic(self.me,self.me,600000006,1)		--播放退场特效
	BehaviorFunctions.CallCommonBehaviorFunc(self.me,"DoPartnerLeave")		--进入仲魔退场流程
	self:SwitchControl(self.role)--切换操控模式
	BehaviorFunctions.ChangePartnerSkill(self.role,self.partnerSummonSkill)
end

--技能逻辑
function Behavior62002:SkillLogic()
	if BehaviorFunctions.GetCtrlEntity() == self.role and BehaviorFunctions.CheckPartnerShow(self.role) == true then
		if BehaviorFunctions.CanCastSkill(self.me) then			
			BehaviorFunctions.DisableAllSkillButton(self.me,false)
			--攻击键逻辑
			if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Attack) then
				if BehaviorFunctions.CheckBtnUseSkill(self.me,62002101) then
					BehaviorFunctions.CastSkillBySelfPosition(self.me,62002101)
					BehaviorFunctions.CastSkillCost(self.me,62002101)
				end
			end
			--技能键逻辑
			if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.NormalSkill) then
				if BehaviorFunctions.CheckBtnUseSkill(self.me,62002102) then
					BehaviorFunctions.CastSkillBySelfPosition(self.me,92002034)
					BehaviorFunctions.CastSkillCost(self.me,62002102)
				end
			end
			--仲魔按键逻辑
			if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Partner) then
				--如果处于召唤状态下，使用仲魔按钮会退出仲魔模式
				if self.currentSummonState == self.summonStateEnum.Summoned then
					self:ExitPartner()
				end
			end
		else
			BehaviorFunctions.DisableAllSkillButton(self.me,true)
		end
	end
end

--检查是否当前环境有召唤限制
function Behavior62002:HasSummonLimit()
	local result = self:ReturnTeleportPosition(self.role,self.summonDistance,self.summonAngle,self.summonAngle,0.5,false)
	if result then
		return false
	else
		return true
	end
end

----释放召唤技能（技能id,以哪个实体为参照系，距离这个实体的位置，这个实体的角度)
--function Behavior62002:StartCreatePartnerSkill(skillId,targetInstance,createDistance,createAngle)
	--BehaviorFunctions.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")	--打断佩从离场流程
	--local curPos = self:CheckCurPosHeight(BehaviorFunctions.GetPositionOffsetBySelf(targetInstance,createDistance,createAngle))
	----local curPosCheck = self:CheckCurPosHeight(curPos)
	--local curShowPos = {}

	----如果有这个点位，检测他是否合法，如果不合法则开始随机取点
	--if curPos then
		--if BehaviorFunctions.CheckEntityCollideAtPosition(self.PartnerAllParm.myEntityId,curPos.x,curPos.y,curPos.z, {self.me,self.PartnerAllParm.role},self.me) then
			--curShowPos = curPos
		--else
			--curShowPos = self:CheckCreatePos(targetInstance,createDistance)
		--end
	--else
		--curShowPos = self:CheckCreatePos(targetInstance,createDistance)
	--end


	--if curShowPos then
		----释放技能开始时移除溶解buff
		--if BehaviorFunctions.GetBuffCount(self.me,600000006) ~= 0 then
			--BehaviorFunctions.RemoveBuff(self.me,600000006)
		--end
		--BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000008,1)--震屏
		--BehaviorFunctions.AddEntitySign(self.PartnerAllParm.role,self.me,-1,false)	--标记为佩从在场
		----有目标时
		--if self.PartnerAllParm.HasTarget == true and BehaviorFunctions.CheckEntityHeight(self.PartnerAllParm.role) == 0 then
			--BehaviorFunctions.DoSetPosition(self.me,curShowPos.x,curShowPos.y,curShowPos.z)	--设置召唤位置
			--BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.PartnerAllParm.roleFrontPos.x,self.PartnerAllParm.roleFrontPos.y,self.PartnerAllParm.roleFrontPos.z,true)	--设置朝向
			--BehaviorFunctions.ShowPartner(self.PartnerAllParm.role, true)	--显示佩从
			--BehaviorFunctions.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
			--BehaviorFunctions.DoMagic(self.me,self.me,1000055,1)	--佩从召唤技能无敌buff
			--BehaviorFunctions.DoMagic(self.me,self.me,600000005,1)	--播放佩从出场特效
			--BehaviorFunctions.CastSkillByTarget(self.me,skillId,self.PartnerAllParm.battleTarget)	--释放技能
			----如果传进来的技能是主动技能
			--if skillId == self.PartnerAllParm.curSkillList.id then
				--BehaviorFunctions.CastSkillCost(self.me,self.PartnerAllParm.curSkillList.id)	--消耗技能资源
			--end
			----找不到目标时
		--elseif self.PartnerAllParm.HasTarget == false and BehaviorFunctions.CheckEntityHeight(self.PartnerAllParm.role) == 0 then
			--BehaviorFunctions.DoSetPosition(self.me,curShowPos.x,curShowPos.y,curShowPos.z)	--设置召唤位置
			--BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.PartnerAllParm.roleFrontPos.x,self.PartnerAllParm.roleFrontPos.y,self.PartnerAllParm.roleFrontPos.z,true)	--设置朝向
			--BehaviorFunctions.ShowPartner(self.PartnerAllParm.role, true)	--显示佩从
			--BehaviorFunctions.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
			--BehaviorFunctions.DoMagic(self.me,self.me,1000055,1)	--佩从召唤技能无敌buff
			--BehaviorFunctions.DoMagic(self.me,self.me,600000005,1)	--播放佩从出场特效
			--BehaviorFunctions.CastSkillBySelfPosition(self.me,skillId)	--原地释放技能
			----如果传进来的技能是主动技能
			--if skillId == self.PartnerAllParm.curSkillList.id then
				--BehaviorFunctions.CastSkillCost(self.me,self.PartnerAllParm.curSkillList.id)	--消耗技能资源
			--end
		--end
	--else
		--BehaviorFunctions.ShowTip(80000001)
	--end
--end

--行为状态机
function Behavior62002:BehaviorFSM()
	local state = BehaviorFunctions.GetEntityState(self.me)
	if state == FightEnum.EntityState.Idle then
		self.currentBehaviorState = self.behaviorStateEnum.Idle
	end
end

--召唤状态机
function Behavior62002:SummonFSM()
	local summonState = BehaviorFunctions.CheckPartnerShow(self.role)
	self.currentPartnerBtn = BehaviorFunctions.GetFightUISkillBtnId(self.me,FightEnum.KeyEvent.Partner)
	local currentRole = BehaviorFunctions.GetCtrlEntity()
	local isExiting = BehaviorFunctions.HasEntitySign(self.me,620020001)
	
	--状态切换判断
	if summonState == true then
		if isExiting then
			--离场状态
			self.currentSummonState = self.summonStateEnum.Exit
		else
			--召唤状态
			self.currentSummonState = self.summonStateEnum.Summoned
		end
	--如果还未召唤
	else
		--检查是否可以召唤
		self.summonLimit = self:HasSummonLimit()
		--根据是否有召唤限制来判断当前状态
		if self.summonLimit then
			self.currentSummonState = self.summonStateEnum.CannotSummon
		else
			self.currentSummonState = self.summonStateEnum.NotSummon
		end
	end
	
	--状态下每帧判断
	--处于召唤状态下的每帧判断
	if self.currentSummonState == self.summonStateEnum.Summoned then 
		if self.currentPartnerBtn ~= self.partnerExitSkill then
			BehaviorFunctions.SetFightUISkillBtnId(self.me,FightEnum.KeyEvent.Partner,self.partnerExitSkill)--切换仲魔技能ID为退场技能
		end
		if currentRole ~= self.role then
			self:ExitPartner()
		end
		
	--处于不可召唤状态的每帧判断
	elseif self.currentSummonState == self.summonStateEnum.CannotSummon then
		BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner,true)--不允许点击仲魔按钮
		if self.currentPartnerBtn ~= self.partnerSummonSkill then
			BehaviorFunctions.SetFightUISkillBtnId(self.me,FightEnum.KeyEvent.Partner,self.partnerSummonSkill)--切换仲魔技能ID为召唤技能
		end
		
	--处于未召唤状态的每帧判断
	elseif self.currentSummonState == self.summonStateEnum.NotSummon then
		BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner,false)--允许点击仲魔按钮	
		if self.currentPartnerBtn ~= self.partnerSummonSkill then
			BehaviorFunctions.SetFightUISkillBtnId(self.me,FightEnum.KeyEvent.Partner,self.partnerSummonSkill)--切换仲魔技能ID为召唤技能
		end
		
	--处于离场状态的每帧判断
	elseif self.currentSummonState == self.summonStateEnum.Exiting then	
			
	end
end

function Behavior62002:SwitchControl(switchInstance)
	--如果切换对象是自己
	if switchInstance == self.me then
		BehaviorFunctions.AddEntitySign(self.role,10000009,-1,false)--屏蔽角色按键输入
		BehaviorFunctions.SetJoyMoveEnable(self.role, false)
		BehaviorFunctions.SetJoyMoveEnable(self.me, true)
		BehaviorFunctions.SetRotateSpeed(self.me,150)
		BehaviorFunctions.ChangeFightBtn(self.role,self.me)--替换龙按钮
		--BehaviorFunctions.SetFightPanelVisible("00010000")--隐藏角色UI
	--如果切换对象是角色
	elseif switchInstance == self.role then
		BehaviorFunctions.RemoveEntitySign(self.role,10000009)--恢复角色按键输入
		BehaviorFunctions.SetJoyMoveEnable(self.role, true)
		BehaviorFunctions.SetJoyMoveEnable(self.me, true)
		BehaviorFunctions.ChangeFightBtn(self.role,self.role)--替换玩家按钮
	end
end

--获取战斗技能目标
function Behavior62002:GetRoleBattleTarget()

	--当前锁定目标
	self.roleLockInf.LockTarget = BehaviorFunctions.GetEntityValue(self.role,"LockTarget")
	self.roleLockInf.LockTargetPoint = BehaviorFunctions.GetEntityValue(self.role,"LockTargetPoint")
	self.roleLockInf.LockTargetPart = BehaviorFunctions.GetEntityValue(self.role,"LockTargetPart")

	--当前战斗目标
	self.roleLockInf.AttackTarget = BehaviorFunctions.GetEntityValue(self.role,"AttackTarget")
	self.roleLockInf.AttackTargetPoint = BehaviorFunctions.GetEntityValue(self.role,"AttackTargetPoint")
	self.roleLockInf.AttackTargetPart = BehaviorFunctions.GetEntityValue(self.role,"AttackTargetPart")

	--备用锁定目标
	self.roleLockInf.LockAltnTarget = BehaviorFunctions.GetEntityValue(self.role,"LockAltnTarget")
	self.roleLockInf.LockAltnTargetPoint = BehaviorFunctions.GetEntityValue(self.role,"LockAltnTargetPoint")
	self.roleLockInf.LockAltnTargetPart = BehaviorFunctions.GetEntityValue(self.role,"LockAltnTargetPart")

	--备用战斗目标
	self.roleLockInf.AttackAltnTarget = BehaviorFunctions.GetEntityValue(self.role,"AttackAltnTarget")
	self.roleLockInf.AttackAltnTargetPoint = BehaviorFunctions.GetEntityValue(self.role,"AttackAltnTargetPoint")
	self.roleLockInf.AttackAltnTargetPart = BehaviorFunctions.GetEntityValue(self.role,"AttackAltnTargetPart")
	
	--目标优先级：
	if BehaviorFunctions.CheckEntity(self.roleLockInf.LockTarget) then
		self.battleTarget = self.roleLockInf.LockTarget
		self.hasBattleTarget = true
	elseif BehaviorFunctions.CheckEntity(self.roleLockInf.AttackTarget) then
		self.battleTarget = self.roleLockInf.AttackTarget
		self.hasBattleTarget = true
	elseif BehaviorFunctions.CheckEntity(self.roleLockInf.LockAltnTarget) then
		self.battleTarget = self.roleLockInf.LockAltnTarget
		self.hasBattleTarget = true
	else
		self.battleTarget = nil
		self.hasBattleTarget = false
	end
end

--返回范围内没有障碍的位置
function Behavior62002:ReturnTeleportPosition(target,distance,startAngel,endAngel,checkheight,checkCollision,returnFarthestPos)
	local posTable = {}
	local farthestPos = nil
	for angel = startAngel,endAngel,5 do
		local pos = BehaviorFunctions.GetPositionOffsetBySelf(target,distance,angel)
		local targetPos = BehaviorFunctions.GetPositionP(target)
		--点位克隆
		local posClone = TableUtils.CopyTable(pos)
		local targetposClone = TableUtils.CopyTable(targetPos)
		--如果有检查高度则检查
		if checkheight then
			posClone.y = posClone.y + checkheight
			targetposClone.y = targetposClone.y + checkheight
		end
		--获取与该点的距离
		local dis = BehaviorFunctions.GetDistanceBetweenObstaclesAndPos(targetposClone,posClone,false)
		--获取与该障碍的距离
		if farthestPos then
			--选取最远的距离
			local dis2 = BehaviorFunctions.GetDistanceBetweenObstaclesAndPos(targetposClone,farthestPos,false)
			if dis > dis2 then
				farthestPos = posClone
				farthestPos = BehaviorFunctions.GetPositionOffsetBySelf(target,dis,angel)
			end
		else
			farthestPos = BehaviorFunctions.GetPositionOffsetBySelf(target,dis,angel)
		end
		--检测障碍：
		if not BehaviorFunctions.CheckObstaclesBetweenPos(targetposClone,posClone,false) then
			if checkCollision then
				local collisionCheck = BehaviorFunctions.CheckEntityCollideAtPosition(self.myEntityId,posClone.x,posClone.y,posClone.z,{self.me,self.role},self.me)
				if collisionCheck then
					table.insert(posTable,pos)
				end
			else
				table.insert(posTable,pos)
			end
		end
	end
	--返回组中角度最中心的点
	local posNum = #posTable
	if #posTable ~= 0 then
		local middleNum = math.ceil(posNum/2)
		return posTable[middleNum]
	else
		if not returnFarthestPos then
			return nil
		else
			--返回最远的点
			return farthestPos
		end
	end	
end

function Behavior62002:SetPlayerForceLock(target,targetPoint,targetPart)
	local player = BehaviorFunctions.GetCtrlEntity()
	if target then
		BehaviorFunctions.SetEntityValue(player,"LockTarget",target) --锁定目标
		if targetPoint then
			BehaviorFunctions.SetEntityValue(player,"LockTargetPoint",targetPoint) --锁定点
		end
		if targetPart then
			BehaviorFunctions.SetEntityValue(player,"LockTargetPart",targetPart) --锁定部位
		end
	else
		BehaviorFunctions.SetEntityValue(player,"LockTarget",0) --不锁定目标
		BehaviorFunctions.SetEntityValue(player,"LockTargetPoint",0) --锁定点
		BehaviorFunctions.SetEntityValue(player,"LockTargetPart",0) --锁定部位
	end
	BehaviorFunctions.AddEntitySign(1,10000001,1)  --指定攻击/锁定目标标记，施加后，攻击、锁定、攻击备用、锁定备用都用指定目标
end

--设置仲魔操控镜头看向
function Behavior62002:SetPartnerControlCamLookAt(target,targetPoint)
	if target then
		if targetPoint then
			BehaviorFunctions.SetPartnerContrlCameraLockTarget(target,targetPoint)
		else
			BehaviorFunctions.SetPartnerContrlCameraLockTarget(target)
		end
	else
		BehaviorFunctions.SetPartnerContrlCameraLockTarget(nil)
	end
end

function Behavior62002:Die(attackIns,dieIns)
	if dieIns == self.role then
		if self.currentSummonState == self.summonStateEnum.Summoned then
			self:ExitPartner()
		end
	end
end

function Behavior62002:AddEntitySign(instanceId,sign)
	if instanceId == self.me then
		if sign == 620020011 then
			BehaviorFunctions.SetCameraParams(FightEnum.CameraState.PartnerContrlCamera,6200201,true)--修改为出场强锁参数
			self:SetPartnerControlCamLookAt(self.me,"TargetGroup1")
			BehaviorFunctions.SetPartnerContrlCameraVisible(true)
		elseif sign == 620020012 then
			BehaviorFunctions.SetCameraParams(FightEnum.CameraState.PartnerContrlCamera,6200202,true)--修改为通常强锁参数
		end
	end
end

function Behavior62002:RemoveEntitySign(instanceId,sign)
	if instanceId == self.me and sign == 620020012 then
		self:SetPartnerControlCamLookAt(nil)
		BehaviorFunctions.SetPartnerContrlCameraVisible(false)
	end
end