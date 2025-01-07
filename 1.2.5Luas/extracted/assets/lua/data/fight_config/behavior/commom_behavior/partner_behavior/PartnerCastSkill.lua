PartnerCastSkill = BaseClass("PartnerCastSkill",EntityBehaviorBase)

--资源预加载
function PartnerCastSkill.GetGenerates()
	local generates = {}
	return generates
end

function PartnerCastSkill.GetMagics()
	local generates = {}
	return generates
end



function PartnerCastSkill:Init()
	self.PartnerAllBehavior = self.ParentBehavior
	self.PartnerAllParm = self.MainBehavior.PartnerAllParm --获取母树
	self.me = self.instanceId	--记录自身
	self.mission = 0
	--技能目标相关
	self.LockTarget = 0
	self.LockTargetPoint = 0
	self.LockTargetPart = 0

	self.AttackTarget = 0
	self.AttackTargetPoint = 0
	self.AttackTargetPart = 0

	self.LockAltnTarget = 0
	self.LockAltnTargetPoint = 0
	self.LockAltnTargetPart = 0

	self.AttackAltnTarget = 0
	self.AttackAltnTargetPoint = 0
	self.AttackAltnTargetPart = 0
	
	self.createTarget = 0
	
	self.standbyPos = {}
end



function PartnerCastSkill:Update()
	

	self.PartnerAllParm:Update()
	--获取战斗目标
	self:GetTarget()
	
	--检查技能释放距离，如果达到目标要求则精准位移释放
	self:CheckTargetDistance()
	
	

	--检测按钮是否被按下
	--if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Partner) and BehaviorFunctions.GetCtrlEntity() == self.PartnerAllParm.role then
		----技能按钮可用且自己不在场
		--if BehaviorFunctions.CheckBtnUseSkill(self.me,self.PartnerAllParm.curSkillList.id) and not BehaviorFunctions.HasEntitySign(self.PartnerAllParm.role,self.me)then

		--end
	--end
	
	
	--如果技能时间结束且仲魔在场，默认进入结束流程
	if self.PartnerAllParm.autoRemove == true then
		if self.PartnerAllParm.skillFrame < self.PartnerAllParm.time and BehaviorFunctions.CheckPartnerShow(self.PartnerAllParm.role) == true and not BehaviorFunctions.HasEntitySign(self.me,600002) then
			BehaviorFunctions.AddEntitySign(self.me,600002,-1,false)	--标记为正在退场
			if self.PartnerAllParm.curSkillList.showType == 1 then
				self:EndHenshin()
			elseif self.PartnerAllParm.curSkillList.showType == 2 then
				self:EndCreatePartnerSkill()
			end
		end
	end
	
	--根据高度开关按钮
	if self.PartnerAllParm.highSkill == false then
		if BehaviorFunctions.CheckEntityHeight(self.PartnerAllParm.role) == 0 then
			BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
		else
			BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , true)
		end
	end
end	


--获取战斗技能目标
function PartnerCastSkill:GetTarget()
	
	self.LockTarget = BehaviorFunctions.GetEntityValue(self.PartnerAllParm.role,"LockTarget")
	self.LockTargetPoint = BehaviorFunctions.GetEntityValue(self.PartnerAllParm.role,"LockTargetPoint")
	self.LockTargetPart = BehaviorFunctions.GetEntityValue(self.PartnerAllParm.role,"LockTargetPart")

	self.AttackTarget = BehaviorFunctions.GetEntityValue(self.PartnerAllParm.role,"AttackTarget")
	self.AttackTargetPoint = BehaviorFunctions.GetEntityValue(self.PartnerAllParm.role,"AttackTargetPoint")
	self.AttackTargetPart = BehaviorFunctions.GetEntityValue(self.PartnerAllParm.role,"AttackTargetPart")

	self.LockAltnTarget = BehaviorFunctions.GetEntityValue(self.PartnerAllParm.role,"LockAltnTarget")
	self.LockAltnTargetPoint = BehaviorFunctions.GetEntityValue(self.PartnerAllParm.role,"LockAltnTargetPoint")
	self.LockAltnTargetPart = BehaviorFunctions.GetEntityValue(self.PartnerAllParm.role,"LockAltnTargetPart")

	self.AttackAltnTarget = BehaviorFunctions.GetEntityValue(self.PartnerAllParm.role,"AttackAltnTarget")
	self.AttackAltnTargetPoint = BehaviorFunctions.GetEntityValue(self.PartnerAllParm.role,"AttackAltnTargetPoint")
	self.AttackAltnTargetPart = BehaviorFunctions.GetEntityValue(self.PartnerAllParm.role,"AttackAltnTargetPart")
	
	if BehaviorFunctions.CheckEntity(self.LockTarget) then
		self.PartnerAllParm.battleTarget = self.LockTarget
		self.PartnerAllParm.HasTarget = true
	elseif BehaviorFunctions.CheckEntity(self.AttackTarget) then
		self.PartnerAllParm.battleTarget = self.AttackTarget
		self.PartnerAllParm.HasTarget = true
	elseif BehaviorFunctions.CheckEntity(self.AttackAltnTarget) then
		self.PartnerAllParm.battleTarget = self.AttackAltnTarget
		self.PartnerAllParm.HasTarget = true
	else
		self.PartnerAllParm.battleTarget = nil
		self.PartnerAllParm.HasTarget = false
	end
end



--释放变身技能
function PartnerCastSkill:StartHenshin(skillId)
	
	--BehaviorFunctions.SetFightPanelVisible("0")--隐藏角色UI
	BehaviorFunctions.SetFightPanelVisible("00010000")--隐藏角色UI
	BehaviorFunctions.SetJoyStickVisibleByAlpha(2, false, false)
	BehaviorFunctions.DoSetPosition(self.me,self.PartnerAllParm.rolePos.x,self.PartnerAllParm.rolePos.y,self.PartnerAllParm.rolePos.z)--设置坐标
	BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.PartnerAllParm.roleFrontPos.x,self.PartnerAllParm.roleFrontPos.y,self.PartnerAllParm.roleFrontPos.z)--设置朝向
	BehaviorFunctions.ShowPartner(self.PartnerAllParm.role, true)--显示仲魔
	BehaviorFunctions.SetMainTarget(self.me)--设置相机目标为仲魔
	BehaviorFunctions.DoMagic(self.me,self.me,1000053)--播放仲魔变身出现特效
	BehaviorFunctions.AddDelayCallByFrame(6,BehaviorFunctions,BehaviorFunctions.DoMagic,self.PartnerAllParm.role,self.PartnerAllParm.role,1000048)--模型隐藏
	if self.PartnerAllParm.HasTarget == false then
		BehaviorFunctions.CastSkillBySelfPosition(self.me,skillId)	--原地释放变身技能
	else
		BehaviorFunctions.CastSkillByTarget(self.me,skillId,self.PartnerAllParm.battleTarget)
	end
	BehaviorFunctions.CastSkillCost(self.me,skillId)--技能资源扣除
	BehaviorFunctions.SetCoreUIEnable(self.PartnerAllParm.role, false)--隐藏核心能量条
	
end

--仲魔变身结束
function PartnerCastSkill:EndHenshin()
	
	BehaviorFunctions.CallCommonBehaviorFunc(self.me, "DoPartnerLeave")		--进入仲魔退场流程
	--BehaviorFunctions.ShowPartner(self.PartnerAllParm.role, false)	--隐藏仲魔
	BehaviorFunctions.DoMagic(self.me,self.me,1000052)	--播放仲魔特效
	BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,1000054)	--播放角色特效
	BehaviorFunctions.SetFightPanelVisible("-1")--移除UI隐藏
	BehaviorFunctions.SetJoyStickVisibleByAlpha(2, true, true)
	BehaviorFunctions.DoSetPosition(self.PartnerAllParm.role,self.PartnerAllParm.myPos.x,self.PartnerAllParm.myPos.y,self.PartnerAllParm.myPos.z)--设置坐标
	BehaviorFunctions.DoLookAtPositionImmediately(self.PartnerAllParm.role,self.PartnerAllParm.myFrontPos.x,self.PartnerAllParm.myFrontPos.y,self.PartnerAllParm.myFrontPos.z)--设置朝向
	BehaviorFunctions.SetMainTarget(self.PartnerAllParm.role)--设置相机目标为角色
	BehaviorFunctions.RemoveBuff(self.PartnerAllParm.role,1000048)--移除模型隐藏
	BehaviorFunctions.RemoveBuff(self.PartnerAllParm.role,1000065)--移除无敌状态
	BehaviorFunctions.SetCoreUIEnable(self.PartnerAllParm.role, true)--显示核心能量条
	
end

--释放主动技能合集
function PartnerCastSkill:CastSkill1()
	--检查当前技能的创建类型，1变身，2召唤
	if self.PartnerAllParm.curSkillList.showType == 1 then
		self:StartHenshin(self.PartnerAllParm.curSkillList.id)
	elseif self.PartnerAllParm.curSkillList.showType == 2 then
		BehaviorFunctions.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")
		self:StartCreatePartnerSkill(self.PartnerAllParm.curSkillList.id,self.PartnerAllParm.role,self.PartnerAllParm.createDistance,self.PartnerAllParm.createAngle)
	end
end

function PartnerCastSkill:AddSkillSign(instanceId,sign)
	if instanceId == self.PartnerAllParm.role then
		if sign == 600000002 then
			self:CastSkill1()
			--按下时开始计时
			if self.PartnerAllParm.curSkillList.frame > 0 then
				self.PartnerAllParm.skillFrame = self.PartnerAllParm.time + self.PartnerAllParm.curSkillList.frame
			end
		end
	end
end

--计算技能召唤位置
function PartnerCastSkill:CheckCreatePos()
	
	
	--local posTarget = self.me
	
	--local curShowPos = BehaviorFunctions.GetPositionOffsetBySelf(self.PartnerAllParm.role,createDistance,createAngle)
	local createPos = {}
	local standbyPos = {}
	--备胎点位
	standbyPos[1] = BehaviorFunctions.GetPositionOffsetBySelf(self.PartnerAllParm.role,2,270)
	standbyPos[2] = BehaviorFunctions.GetPositionOffsetBySelf(self.PartnerAllParm.role,2,300)
	standbyPos[3] = BehaviorFunctions.GetPositionOffsetBySelf(self.PartnerAllParm.role,2,60)
 	standbyPos[4] = BehaviorFunctions.GetPositionOffsetBySelf(self.PartnerAllParm.role,2,90)
	
	local curPosList = {}
	
	
	--找到位置列表里可以用于召唤的最佳点位
	for i = 1,4 do
		standbyPos[i].y = standbyPos[i].y + 0.2
		local height,layer = BehaviorFunctions.CheckPosHeight(standbyPos[i])
		if height and height == 0 and layer and layer ~= FightEnum.Layer.Water and layer ~= FightEnum.Layer.Marsh and layer ~= FightEnum.Layer.Lava and layer == FightEnum.Layer.Driftsand then
			if BehaviorFunctions.CheckEntityCollideAtPosition(self.PartnerAllParm.myEntityId, standbyPos[i].x, standbyPos[i].y, standbyPos[i].z, {self.me},self.me) then
				table.insert(curPosList,standbyPos[i])
			end
		end
	end
	
	--如果没有这种很合适的点位，开始遍历
	if not next(curPosList) then
		createPos = self:GetRandomPos(2.5)
		if createPos then
			return createPos
		else
			createPos = self:GetRandomLandPos(3)
			if createPos then
				return createPos
			else	
				createPos = self:RandomPos(2.5)
				if createPos then
					return createPos
				else
					return nil
				end 
			end
		end
	else
		return curPosList[1]
	end
	
	--for i = 1,4 do
		--standbyPos[i].y = standbyPos[i].y + 0.2
		--local y,layer = BehaviorFunctions.CheckPosHeight(standbyPos[i])
		--if y and y > 0 then
			--self.createSkillPos = Vec3.New()
			--self.createSkillPos:Set(curShowPos.x,curShowPos.y - y,curShowPos.z)
		--end
	--end
	return createPos
end

--释放召唤技能（以哪个实体为参照系，距离这个实体的位置，这个实体的角度)
function PartnerCastSkill:StartCreatePartnerSkill(skillId,targetInstance,createDistance,createAngle)
	local curPos = self:CheckCurPosHeight(BehaviorFunctions.GetPositionOffsetBySelf(targetInstance,createDistance,createAngle))
	--local curPosCheck = self:CheckCurPosHeight(curPos)
	local curShowPos = {}
	
	--如果有这个点位，检测他是否合法
	if curPos then
		if BehaviorFunctions.CheckEntityCollideAtPosition(self.PartnerAllParm.myEntityId,curPos.x,curPos.y,curPos.z, {self.me,self.PartnerAllParm.role},self.me) then
			curShowPos = curPos
		else
			curShowPos = self:CheckCreatePos()
		end
	else
		curShowPos = self:CheckCreatePos()
	end
	
	
	if curShowPos then
		--释放技能开始时移除溶解buff
		if BehaviorFunctions.GetBuffCount(self.me,600000006) ~= 0 then
			BehaviorFunctions.RemoveBuff(self.me,600000006)
		end
		
		BehaviorFunctions.AddEntitySign(self.PartnerAllParm.role,self.me,-1,false)	--标记为仲魔在场
		--有目标时
		if self.PartnerAllParm.HasTarget == true and BehaviorFunctions.CheckEntityHeight(self.PartnerAllParm.role) == 0 then
			BehaviorFunctions.DoSetPosition(self.me,curShowPos.x,curShowPos.y,curShowPos.z)	--设置召唤位置
			BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.PartnerAllParm.roleFrontPos.x,self.PartnerAllParm.roleFrontPos.y,self.PartnerAllParm.roleFrontPos.z,true)	--设置朝向
			BehaviorFunctions.ShowPartner(self.PartnerAllParm.role, true)	--显示仲魔
			BehaviorFunctions.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
			BehaviorFunctions.DoMagic(self.me,self.me,1000055,1)	--仲魔召唤技能无敌buff
			BehaviorFunctions.DoMagic(self.me,self.me,600000005,1)	--播放仲魔出场特效
			BehaviorFunctions.CastSkillByTarget(self.me,skillId,self.PartnerAllParm.battleTarget)	--释放技能
			--如果传进来的技能是主动技能
			if skillId == self.PartnerAllParm.curSkillList.id then
				BehaviorFunctions.CastSkillCost(self.me,self.PartnerAllParm.curSkillList.id)	--消耗技能资源
			end
		--找不到目标时
		elseif self.PartnerAllParm.HasTarget == false and BehaviorFunctions.CheckEntityHeight(self.PartnerAllParm.role) == 0 then
			BehaviorFunctions.DoSetPosition(self.me,curShowPos.x,curShowPos.y,curShowPos.z)	--设置召唤位置
			BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.PartnerAllParm.roleFrontPos.x,self.PartnerAllParm.roleFrontPos.y,self.PartnerAllParm.roleFrontPos.z,true)	--设置朝向
			BehaviorFunctions.ShowPartner(self.PartnerAllParm.role, true)	--显示仲魔
			BehaviorFunctions.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
			BehaviorFunctions.DoMagic(self.me,self.me,1000055,1)	--仲魔召唤技能无敌buff
			BehaviorFunctions.DoMagic(self.me,self.me,600000005,1)	--播放仲魔出场特效
			BehaviorFunctions.CastSkillBySelfPosition(self.me,skillId)	--原地释放技能
			--如果传进来的技能是主动技能
			if skillId == self.PartnerAllParm.curSkillList.id then
				BehaviorFunctions.CastSkillCost(self.me,self.PartnerAllParm.curSkillList.id)	--消耗技能资源
			end
		end
	else
		BehaviorFunctions.ShowTip(80000001)
	end
end

--召唤技能退场
function PartnerCastSkill:EndCreatePartnerSkill()
	BehaviorFunctions.DoMagic(self.me,self.me,600000006,1)		--播放退场特效
	BehaviorFunctions.DoMagic(self.me,self.me,600000004,1)		--播放退场氛围特效
	BehaviorFunctions.CallCommonBehaviorFunc(self.me, "DoPartnerLeave")		--进入仲魔退场流程
end


--检查点位高度
function PartnerCastSkill:CheckCurPosHeight(curPos)
	curPos.y = curPos.y + 0.2
	local y,layer = BehaviorFunctions.CheckPosHeight(curPos)
	if y and y > 0 and y <= 2 then
		local finalPos = Vec3.New()
		finalPos:Set(curPos.x,curPos.y - y,curPos.z)
		return finalPos
	else
		return nil
	end
end


--获得随机坐标
function PartnerCastSkill:GetRandomPos(radius)
	for i = 60,360,60 do

		local positionP = BehaviorFunctions.GetPositionOffsetBySelf(self.PartnerAllParm.role,radius,i)

		--检测障碍：
		if BehaviorFunctions.CheckEntityCollideAtPosition(self.PartnerAllParm.myEntityId, positionP.x, positionP.y, positionP.z, {self.me},self.me) then
			positionP.y = positionP.y + 0.2
			local y,layer = BehaviorFunctions.CheckPosHeight(positionP)
			--如果点位创建仲魔合法且高度为0的话则返回
			if y and y == 0 then

				return positionP
				--设置坐标：
			end
		end
	end
	return nil
end

--获得地面坐标
function PartnerCastSkill:GetRandomLandPos(radius)
	
	for i = 60,360,60 do

		local positionP = BehaviorFunctions.GetPositionOffsetBySelf(self.PartnerAllParm.role,radius,i)

		--检测障碍：
		if BehaviorFunctions.CheckEntityCollideAtPosition(self.PartnerAllParm.myEntityId, positionP.x, positionP.y, positionP.z, {}) then
			local y,layer = BehaviorFunctions.CheckPosHeight(positionP)
			positionP.y = positionP.y + 0.2
			--对传进来的点位进行位置修正，保证在地面
			if y and y >= 0 then
				local finalPos = Vec3.New()
				finalPos:Set(positionP.x,positionP.y - y,positionP.z)
				return finalPos
			end
		end
	end
	return nil
end

function PartnerCastSkill:RandomPos(radius)
	for i = 90,720,30 do
		local positionP = BehaviorFunctions.GetPositionOffsetBySelf(self.PartnerAllParm.role,radius,i)
		if not BehaviorFunctions.CheckObstaclesBetweenPos(self.PartnerAllParm.rolePos,positionP,false) then
			local y,layer = BehaviorFunctions.CheckPosHeight(positionP)
			positionP.y = positionP.y + 0.2
			--对传进来的点位进行位置修正，保证在地面
			if y and y >= 0 and y < 2 then
				local finalPos = Vec3.New()
				finalPos:Set(positionP.x,positionP.y - y,positionP.z)
				return finalPos
			end
		end
	end
	return nil
end

--仲魔离场回调
function PartnerCastSkill:PartnerHide(instanceId)
	if instanceId == self.me then
		BehaviorFunctions.RemoveEntitySign(self.me,600002)
		BehaviorFunctions.RemoveEntitySign(self.PartnerAllParm.role,600000)	--结束仲魔在场状态
		BehaviorFunctions.RemoveEntitySign(self.PartnerAllParm.role,self.me)	--结束自己在场状态
		BehaviorFunctions.RemoveBuff(self.me,1000055)	--移除无敌buff
	end
end

--技能释放距离检查
function PartnerCastSkill:CheckTargetDistance()
	--技能响应的最大距离，有目标时开始检测，满足时标记，不满足时移除
	if self.PartnerAllParm.HasTarget == true then
		self.targetDistance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.PartnerAllParm.battleTarget,false)
		--技能释放范围检查，如果满足则增加标记，允许精准位移
		if self.targetDistance < self.PartnerAllParm.curSkillList.distance then
			BehaviorFunctions.AddSkillEventActiveSign(self.me,600001)
		else
			BehaviorFunctions.RemoveSkillEventActiveSign(self.me,600001)
		end
	--没有目标不使用精准位移
	else
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,600001)
	end
end


--传送打断技能
function PartnerCastSkill:OnTransport()
	BehaviorFunctions.BreakSkill(self.me)	--打断自身技能
	BehaviorFunctions.ShowPartner(self.PartnerAllParm.role, false)	--隐藏仲魔
	BehaviorFunctions.RemoveEntitySign(self.me,600002)	--移除退场标记
	BehaviorFunctions.RemoveEntitySign(self.PartnerAllParm.role,600000)	--结束仲魔在场状态
	BehaviorFunctions.RemoveEntitySign(self.PartnerAllParm.role,self.me)	--结束自己在场状态
	BehaviorFunctions.RemoveBuff(self.me,1000055)	--移除无敌buff
	--移除溶解buff
	if BehaviorFunctions.GetBuffCount(self.me,600000006) ~= 0 then
		BehaviorFunctions.RemoveBuff(self.me,600000006)
	end
end