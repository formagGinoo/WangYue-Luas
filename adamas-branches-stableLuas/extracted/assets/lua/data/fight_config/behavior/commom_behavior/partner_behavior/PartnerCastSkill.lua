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
	self.targetPos = {}
	self.curPos = {}
	self.dodgeAtkTarget = 0

	self.PartnerAllParm.normalAttackCount = 5	--普攻段数默认5段

	self.chain = 0
	
	self.curConnect = 0
	--连携相机参数

	self.cameraRatio =
	{
		Long = 0.005,
		Mid = 0.02,
		Short = 0.04,

	}

	--影响连携相机权重计算的参数
	self.cameraDistance =
	{
		Max = 1, --最大距离
		Min = 0,	--最小距离
		Short = 0,
		Mid = 6,
		Long = 12,
	}

	self.myCameraWeight = 0	--相机权重系数
	self.cameraMode = 0
	
	self.QTEFrame = 0
	
	self.PVexecute = 0
	self.connectCamera = false
	
	self.curHenshinSkill = 0	--缓存变身技能ID

end



function PartnerCastSkill:Update()


	self.PartnerAllParm:Update()
	--获取战斗目标
	self:GetTarget()

	--检查技能释放距离，如果达到目标要求则精准位移释放
	self:CheckTargetDistance()

	
	self.roleCamera = BehaviorFunctions.GetEntityValue(self.PartnerAllParm.role,"CameraType")	--获取角色底层相机类型
	
	self.ctrlRole = BehaviorFunctions.GetCtrlEntity()	--获取正在控制的角色
	self.diyueHand = BehaviorFunctions.GetEntityValue(self.PartnerAllParm.role,"diyueHand")	--获取缓存的缔约挂点

	BehaviorFunctions.SetEntityValue(self.me,"diyuePart",self.PartnerAllParm.diyuePart)	--开放缔约绑定位置给角色
	BehaviorFunctions.SetEntityValue(self.PartnerAllParm.role,"chain",self.chain)	--开放锁链给角色
	
	if not self.initBuff and self.PartnerAllParm.role ~= 1 then
		BehaviorFunctions.AddSkillEventActiveSign(self.PartnerAllParm.role,600000003)
		BehaviorFunctions.AddSkillEventActiveSign(self.PartnerAllParm.role,600000063)
		BehaviorFunctions.AddSkillEventActiveSign(self.PartnerAllParm.role,600000012)
		self.initBuff = true
	end
	
	--当前缓存的技能不需要角色表演动作时
	if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Partner) and BehaviorFunctions.GetCtrlEntity() == self.PartnerAllParm.role and self.PartnerAllParm.curRolePerform == 0 then
		--技能按钮可用且自己不在场
		if BehaviorFunctions.CheckBtnUseSkill(self.me,self.PartnerAllParm.curSkillList.id) then
			self:CastSkill1()
		end
	end

		
	--根据高度开关按钮
	if self.PartnerAllParm.highSkill == false then 
		if not BehaviorFunctions.HasEntitySign(self.me,600000001) and self.PartnerAllParm.role == self.PartnerAllParm.CtrlRole then
			if BehaviorFunctions.CheckEntityHeight(self.PartnerAllParm.role) == 0 then
				BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
			else
				BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , true)
			end
		end
	end


	--切换角色清除连携相机记录
	if BehaviorFunctions.GetCtrlEntity() ~= self.PartnerAllParm.role and BehaviorFunctions.HasEntitySign(self.PartnerAllParm.role,600000010) then
		BehaviorFunctions.RemoveFollowTarget(self.me,"CameraTarget")	--移除相机关注点
		BehaviorFunctions.RemoveEntitySign(self.PartnerAllParm.role,600000010)	--清除相机权重
		self.connectCamera = false
	end

	--佩从出场动态设置相机权重
	--如果佩从处于连携状态且不处于元素破防状态,应用动态相机
	if BehaviorFunctions.HasEntitySign(self.PartnerAllParm.role,600000010) and not BehaviorFunctions.HasEntitySign(self.PartnerAllParm.role,600000011) and self.connectCamera then
		if not BehaviorFunctions.HasEntitySign(1,10000002) then
			self:SetCameraTargetWeight(self.cameraMode)
			--self:SetCameraLookAtWeight(1)
			--BehaviorFunctions.SetFollowTargetWeight(self.me,"",0.25)
			BehaviorFunctions.SetFollowTargetWeight(self.me,"CameraTarget",self.myCameraWeight)	--设置镜头权重
			if self.PartnerAllParm.HasTarget then
				if self.PartnerAllParm.battleTarget and self.PartnerAllParm.battleTarget ~= 0 and BehaviorFunctions.CheckEntity(self.PartnerAllParm.battleTarget) then
					--BehaviorFunctions.SetLookAtTargetWeight(self.me,"CameraTarget",self.myLookAtWeight)	--设置镜头权重
				end
			end
		else
			BehaviorFunctions.RemoveFollowTarget(self.me,"CameraTarget")		--移除关注点
			self.connectCamera = false	--标记为已经移除了连携相机
		end
	elseif not BehaviorFunctions.HasEntitySign(self.PartnerAllParm.role,600000010) and self.connectCamera then
		--BehaviorFunctions.SetFollowTargetWeight(self.me,"HitCase",0)	--设置镜头权重
		BehaviorFunctions.RemoveFollowTarget(self.me,"CameraTarget")		--移除关注点
		self.connectCamera = false	--标记为已经移除了连携相机
	end
		
	--如果在切镜连携且怪物进入眩晕
	if BehaviorFunctions.HasEntitySign(self.PartnerAllParm.role,600000011) and BehaviorFunctions.HasEntitySign(1,10000002) then
		BehaviorFunctions.RemoveFollowTarget(self.me,"CameraTarget")		--移除关注点
	end
	
	--PV用，神荼下砸必破防
	if self.PVexecute == 1 then
		BehaviorFunctions.AddSkillEventActiveSign(self.me,6000999)
	else
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,6000999)
	end
	
	--离场
	if BehaviorFunctions.HasEntitySign(self.me,600000020) then
		BehaviorFunctions.AddEntitySign(self.me,600002,-1,false)
		BehaviorFunctions.BreakSkill(self.me)
		self:EndCreatePartnerSkill()
		BehaviorFunctions.RemoveEntitySign(self.me,600000020)
		--	BehaviorFunctions.CastSkillCost(self.me,self.PartnerAllParm.curSkillList.id)	--消耗技能资源
	end
	
end

--按按钮释放主动技能合集
function PartnerCastSkill:CastSkill1()

	--获得技能目标
	local skillTarget,createPos = self:GetSkillTarget(self.PartnerAllParm.curSkillList.targetType,self.PartnerAllParm.curSkillList.createPos)

	--检查当前技能的创建类型，1变身，2召唤出场，3在场攻击
	if self.PartnerAllParm.curSkillList.showType == 1 then
		self:StartHenshin(self.PartnerAllParm.curSkillList.id,self.PartnerAllParm.curSkillList.Camera)
	elseif self.PartnerAllParm.curSkillList.showType == 2 or self.PartnerAllParm.curSkillList.showType == 3 then
		BehaviorFunctions.RemoveEntitySign(self.me,600002)	--移除正在退场的标记
		--BehaviorFunctions.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")

		--释放召唤技能
		--self:StartCreatePartnerSkill(self.PartnerAllParm.curSkillList.id,skillTarget,self.PartnerAllParm.curSkillList.distance,self.PartnerAllParm.curSkillList.angle)
		self:StartActiveSkill(self.PartnerAllParm.curSkillList.id,skillTarget,createPos,self.PartnerAllParm.curSkillList.distance,self.PartnerAllParm.curSkillList.angle,self.PartnerAllParm.curSkillList.stableShow,self.PartnerAllParm.curSkillList.Camera,self.PartnerAllParm.curSkillList.isTimeScale,self.PartnerAllParm.curSkillList.rolePerform)
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

--开始释放主动技能，选择预设
function PartnerCastSkill:StartActiveSkill(skillId,targetInstance,createPos,createDistance,createAngle,stableShow,changeCamera,isTimeScale,rolePerform)
	--是否使用预设的聚气表现
	if isTimeScale == 1 then
		BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000009)	--聚气
		BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000010)	--聚气后6帧，触发4帧顿帧
		--释放技能
		self:CastConnectSkill(skillId,targetInstance,createPos,createDistance,createAngle,stableShow,12,changeCamera)
	else
		--释放技能
		self:CastConnectSkill(skillId,targetInstance,createPos,createDistance,createAngle,stableShow,0,changeCamera)
	end
	
	if rolePerform == 0 then
		BehaviorFunctions.AddPostProcessByTemplateId(self.PartnerAllParm.role, 600000010, FightEnum.PostProcessType.FullScreen)	--调用场景变色
	end
end

--释放变身技能:技能ID，延迟帧数，是否自动选中目标
function PartnerCastSkill:StartHenshin(skillId,cameraType,delayFrame,selectTarget)
	if not delayFrame then
		delayFrame = 4
	end
	
	if not selectTarget then
		selectTarget = true
	end
	
	if not cameraType then
		cameraType = 0
	end	
	BehaviorFunctions.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")	--打断佩从离场流程
	BehaviorFunctions.AddEntitySign(self.PartnerAllParm.CtrlRole,600000012,-1,false)
	--BehaviorFunctions.SetFightPanelVisible("0")--隐藏角色UI
	--BehaviorFunctions.SetFightPanelVisible("00010000")--隐藏角色UI
	--BehaviorFunctions.SetJoyStickVisibleByAlpha(2, false, false)	--设置摇杆透明
	--BehaviorFunctions.DisableAllSkillButton(self.PartnerAllParm.role,true)	--禁用按钮
	BehaviorFunctions.AddEntitySign(self.me,600000001,-1,false)		--阻断按钮状态设置
	BehaviorFunctions.DisableAllSkillButton(self.PartnerAllParm.role,true)	--禁用按钮
	BehaviorFunctions.DisableAllSkillButton(self.me,true)	--禁用按钮
	BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , true)
	--BehaviorFunctions.DisableSkillButton(self.me, FightEnum.KeyEvent.Partner, true)
	--BehaviorFunctions.DisableSkillButton(self.me, FightEnum.KeyEvent.Dodge, true)
	BehaviorFunctions.SetJoyMoveEnable(self.PartnerAllParm.role,false,2, true)	--设置摇杆不可用
	BehaviorFunctions.DoMagic(self.me,self.me,600000016)	--浮空buff
	
	if selectTarget == true then
		local targetPoint = self:GetTargetPart()
		
		if self.PartnerAllParm.HasTarget == false then
			BehaviorFunctions.CastSkillBySelfPosition(self.me,skillId)	--原地释放变身技能
		else
			BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.targetPos.x,self.targetPos.y,self.targetPos.z)--设置朝向
			if targetPoint and targetPoint ~= "" then
				BehaviorFunctions.CastSkillByTarget(self.me,skillId,self.PartnerAllParm.battleTarget,nil,targetPoint)	--自动索敌
			else
				BehaviorFunctions.CastSkillByTarget(self.me,skillId,self.PartnerAllParm.battleTarget)
			end
		end
	else
		BehaviorFunctions.CastSkillBySelfPosition(self.me,skillId)	--原地释放变身技能
	end
	
	BehaviorFunctions.DoSetPosition(self.me,self.PartnerAllParm.rolePos.x,self.PartnerAllParm.rolePos.y,self.PartnerAllParm.rolePos.z)--设置坐标
	BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.PartnerAllParm.roleFrontPos.x,self.PartnerAllParm.roleFrontPos.y,self.PartnerAllParm.roleFrontPos.z)--设置朝向
	BehaviorFunctions.ShowPartner(self.PartnerAllParm.role, true)--显示仲魔
	BehaviorFunctions.RemoveAllFollowTarget()	--移除所有跟随点
	BehaviorFunctions.AddFollowTarget(self.me,"CameraTarget")	--添加跟随的目标
	BehaviorFunctions.DoMagic(self.me,self.me,1000053)--播放仲魔变身出现特效
	BehaviorFunctions.AddDelayCallByFrame(delayFrame,self,self.DelayHenshin)--模型隐藏
	BehaviorFunctions.SetCoreUIEnable(self.PartnerAllParm.role, false)--隐藏核心能量条
	--BehaviorFunctions.SetCameraDistance(BehaviorFunctions.GetCameraState(),8,0.132)
	
	self.curHenshinSkill = skillId	--缓存变身技能

	BehaviorFunctions.AddEntitySign(self.PartnerAllParm.role,600000021,-1,false)	--标记变身技能中，不做动态相机切换
	--变身默认不使用角色相机逻辑
	if cameraType == 0 then
		BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Operating,true)		--使用操作相机并且锁定相机
		
	end
end

--变身延迟执行
function PartnerCastSkill:DelayHenshin()
	BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,1000048)	--模型隐藏
	BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,1000051)	--播放仲魔变身出现特效
end


--仲魔变身结束
function PartnerCastSkill:EndHenshin()
	BehaviorFunctions.DisableAllSkillButton(self.PartnerAllParm.role,false)	--结束禁用按钮
	BehaviorFunctions.DisableAllSkillButton(self.me,true)	--禁用按钮
	BehaviorFunctions.AddDelayCallByTime(1,self,self.DelayEndHenshin)	--延迟一秒隐藏佩从
	--BehaviorFunctions.CallCommonBehaviorFunc(self.me, "DoPartnerLeave")		--进入仲魔退场流程
	--BehaviorFunctions.ShowPartner(self.PartnerAllParm.role, false)	--隐藏仲魔
	BehaviorFunctions.SetJoyMoveEnable(self.PartnerAllParm.role,true,2,false)	--设置摇杆不可用
	BehaviorFunctions.DoMagic(self.me,self.me,1000052)	--播放仲魔特效
	BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,1000054)	--播放角色特效
	BehaviorFunctions.DoSetEntityState(self.PartnerAllParm.role,FightEnum.EntityState.Idle)	--设置角色为待机
	--BehaviorFunctions.SetFightPanelVisible("-1")--移除UI隐藏
	--BehaviorFunctions.SetJoyStickVisibleByAlpha(2, true, true)	--设置摇杆显示
	BehaviorFunctions.DoSetPosition(self.PartnerAllParm.role,self.PartnerAllParm.myPos.x,self.PartnerAllParm.myPos.y,self.PartnerAllParm.myPos.z)--设置坐标
	BehaviorFunctions.DoLookAtPositionImmediately(self.PartnerAllParm.role,self.PartnerAllParm.myFrontPos.x,self.PartnerAllParm.myFrontPos.y,self.PartnerAllParm.myFrontPos.z)--设置朝向
--	BehaviorFunctions.SetMainTarget(self.PartnerAllParm.role)--设置相机目标为角色
	BehaviorFunctions.RemoveBuff(self.PartnerAllParm.role,1000048)--移除模型隐藏
	--BehaviorFunctions.RemoveBuff(self.PartnerAllParm.role,1000055)
	BehaviorFunctions.SetCoreUIEnable(self.PartnerAllParm.role, true)--显示核心能量条
	BehaviorFunctions.CastSkillCost(self.me,self.curHenshinSkill)--技能资源扣除
	if self.PartnerAllParm.role == self.PartnerAllParm.CtrlRole then
		BehaviorFunctions.RemoveAllFollowTarget()
		BehaviorFunctions.AddFollowTarget(self.PartnerAllParm.role,"CameraTarget")
	else
		BehaviorFunctions.RemoveAllFollowTarget()
		BehaviorFunctions.AddFollowTarget(self.PartnerAllParm.CtrlRole,"CameraTarget")
	end
	--移除佩从变身中的标记
	BehaviorFunctions.RemoveEntitySign(self.PartnerAllParm.role,600000021)
	if self.PartnerAllParm.role == self.PartnerAllParm.CtrlRole then
		self:ReturnCamera(0.2,0.5)
	end

--	BehaviorFunctions.SetCameraDistance(BehaviorFunctions.GetCameraState(),5,0.5)
end



--获取战斗目标（技能类型）
function PartnerCastSkill:GetSkillTarget(targetType,createType)
	local skillTarget = 0
	local createPos = 0
	--检查释放技能的目标，1角色，2目标
	if targetType == 1 then
		skillTarget = self.PartnerAllParm.role
	elseif targetType == 2 then
		if self.PartnerAllParm.HasTarget == true then
			skillTarget = self.PartnerAllParm.battleTarget
			--如果目标不存在，将释放点设置为角色
		else
			skillTarget = self.PartnerAllParm.role
		end
		--什么都没填，默认以角色
	else
		skillTarget = self.PartnerAllParm.role
	end

	--检查佩从创建的参考点，1角色2战斗目标
	if createType == 1 then
		createPos = self.PartnerAllParm.role
	elseif createType == 2 then
		if self.PartnerAllParm.HasTarget == true then
			createPos = self.PartnerAllParm.battleTarget
			--如果目标不存在，将释放点设置为角色
		else
			createPos = self.PartnerAllParm.role
		end
		--什么都没填，默认取目标
	else
		createPos = skillTarget
	end
	return skillTarget,createPos
end

--获取战斗目标部位
function PartnerCastSkill:GetTargetPart()
	local targetPoint
	if self.PartnerAllParm.HasTarget then
		if self.LockTarget and BehaviorFunctions.CheckEntity(self.LockTarget) then
			local x,y,z = BehaviorFunctions.GetEntityTransformPos(self.LockTarget, self.LockTargetPoint)
			self.targetPos = Vec3.New(x, y, z)
			targetPoint = self.LockTargetPoint
		elseif self.AttackTarget and BehaviorFunctions.CheckEntity(self.AttackTarget) then
			local x,y,z = BehaviorFunctions.GetEntityTransformPos(self.AttackTarget, self.AttackTargetPoint)
			self.targetPos = Vec3.New(x, y, z)
			targetPoint = self.AttackTargetPoint
		else
			self.targetPos = BehaviorFunctions.GetPositionP(self.PartnerAllParm.battleTarget)
			targetPoint = ""
		end
	end
	return targetPoint
end


function PartnerCastSkill:AddSkillSign(instanceId,sign)
	if instanceId == self.PartnerAllParm.role or instanceId == self.me then
		--角色主动使用佩从技能窗口（放在召唤动作里）
		if sign == 600000002 then
			local inFight
			if BehaviorFunctions.CheckPlayerInFight() then
				inFight = 2
			else
				inFight = 1
			end
			
			if inFight == self.PartnerAllParm.curSkillList.skillType or self.PartnerAllParm.curSkillList.skillType == 3 then
				if self.PartnerAllParm.useOwnSkill == false then
					self:CastSkill1()
				end
			end
		end

		--角色佩从连携技能窗口
		if sign == 600000010 then
			--技能
			if BehaviorFunctions.GetSkillConfigSign(self.PartnerAllParm.role) == 10 then
				self:StartConnect(2)
				--print(self.PartnerAllParm.skillFrame)
				--核心
			elseif	BehaviorFunctions.GetSkillConfigSign(self.PartnerAllParm.role) == 40 then
				self:StartConnect(3)
				--普攻最后一段
			elseif BehaviorFunctions.GetSkill(self.PartnerAllParm.role) == self.PartnerAllParm.roleEntityId * 1000 + self.PartnerAllParm.normalAttackCount then
				self:StartConnect(1)
			elseif 	BehaviorFunctions.GetSkillConfigSign(self.PartnerAllParm.role) == 170 or BehaviorFunctions.GetSkillConfigSign(self.PartnerAllParm.role) == 172 then
				--下落攻击
				self:StartConnect(5)
			end
		end

		--通用召唤技能离场窗口检测
		if sign == 600000020 then
			if self.curSkillType == 0 then
				self:EndCreatePartnerSkill()
			end
			BehaviorFunctions.SetBodyDamping(2,1,0.5)
			BehaviorFunctions.RemoveFollowTarget(self.me,"CameraTarget")	--移除相机关注点
			BehaviorFunctions.RemoveEntitySign(self.PartnerAllParm.role,600000010)	--清除相机权重
			BehaviorFunctions.AddDelayCallByTime(0.5,BehaviorFunctions,BehaviorFunctions.SetBodyDamping,0.5,0.5,0.5)
			self.connectCamera = false
		end
		
		--通用佩从变身结束窗口
		if sign == 600000021 then
			self:EndHenshin()
		end
		
		--场景变色调用
		if sign == 600000019 then		
			BehaviorFunctions.AddPostProcessByTemplateId(self.PartnerAllParm.role, 600000010, FightEnum.PostProcessType.FullScreen)	--调用场景变色
		end
	end
end




--释放召唤技能（技能id,技能目标为哪个实体,以哪个实体为创建的参照系，距离这个实体的位置，这个实体的角度)
function PartnerCastSkill:StartCreatePartnerSkill(skillId,targetInstance,createPos,createDistance,createAngle,stableShow)

	local curShowPos = {}
	local curPos = {}

	if stableShow == 0 then
		--BehaviorFunctions.SetBodyDamping()	--恢复相机过渡时间

		--local curPosCheck = self:CheckCurPosHeight(curPos)
		--如果有这个点位，检测他是否合法，如果不合法则开始随机取点
		
		--如果创建佩从的参考点不是角色，获取该参考点的坐标
		if createPos ~= self.PartnerAllParm.role then
			if self.LockTarget == targetInstance then
				if self.LockTarget and BehaviorFunctions.CheckEntity(self.LockTarget) then
					local x,y,z = BehaviorFunctions.GetEntityTransformPos(self.LockTarget, self.LockTargetPoint)
					curPos = Vec3.New(x, y, z)
				elseif self.AttackTarget and BehaviorFunctions.CheckEntity(self.AttackTarget) then
					local x,y,z = BehaviorFunctions.GetEntityTransformPos(self.AttackTarget, self.AttackTargetPoint)
					curPos = Vec3.New(x, y, z)
				else
					curPos = BehaviorFunctions.GetPositionP(createPos)
				end
			else	
				curPos = BehaviorFunctions.GetPositionP(createPos)
			end
			self.curPos = self:CheckCurPosHeight(BehaviorFunctions.GetPositionOffsetP(curPos,self.PartnerAllParm.rolePos,createDistance,createAngle))
		else	
			
			self.curPos = self:CheckCurPosHeight(BehaviorFunctions.GetPositionOffsetBySelf(createPos,createDistance,createAngle))
		end
			
		if self.curPos then
			if BehaviorFunctions.CheckEntityCollideAtPosition(self.PartnerAllParm.myEntityId,self.curPos.x,self.curPos.y + 0.2,self.curPos.z, {self.me,self.PartnerAllParm.role,createPos},self.me,true) then
				curShowPos = self.curPos
			else
				curShowPos = self:CheckCreatePos(createPos,createDistance)
			end
		else
			curShowPos = self:CheckCreatePos(createPos,createDistance)
		end
	else
		curShowPos = BehaviorFunctions.GetPositionOffsetBySelf(createPos,createDistance,createAngle)
	end


	if curShowPos then
		if stableShow == 1 then
			BehaviorFunctions.DoMagic(self.me,self.me,600000016)	--如果需要固定创建，帮加上浮空buff
		end
		self.curSkillType = self.PartnerAllParm.partnerType
		BehaviorFunctions.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")	--打断佩从离场流程
		BehaviorFunctions.BreakSkill(self.me)	--打断当前正在释放的技能
		BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000008,1)--震屏
		BehaviorFunctions.AddEntitySign(self.PartnerAllParm.role,self.me,-1,false)	--标记为仲魔在场
		--	BehaviorFunctions.AddEntitySign(self.me,600003,-1,false)	--标记为主动技能在场状态

		--技能开始移除缔约线
		--if self.chain and self.chain ~= 0 then
			--if BehaviorFunctions.CheckEntity(self.chain) then
				--BehaviorFunctions.RemoveEntity(self.chain)
			--end
		--end
		
		--有目标时，对目标释放技能
		if self.PartnerAllParm.HasTarget == true 
			--and BehaviorFunctions.CheckEntityHeight(self.PartnerAllParm.role) == 0 
			then
			
			local targetPoint = self:GetTargetPart()
			
			BehaviorFunctions.DoSetPosition(self.me,curShowPos.x,curShowPos.y,curShowPos.z)	--设置召唤位置
			--local targetPos = BehaviorFunctions.GetPositionP(self.PartnerAllParm.battleTarget)
			if targetInstance == self.PartnerAllParm.role then
				BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.PartnerAllParm.roleFrontPos.x,self.PartnerAllParm.roleFrontPos.y,self.PartnerAllParm.roleFrontPos.z,true)	--设置朝向
			else
				BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.targetPos.x,self.targetPos.y,self.targetPos.z,true)	--设置朝向
			end
			BehaviorFunctions.ShowPartner(self.PartnerAllParm.role, true)	--显示仲魔
			BehaviorFunctions.SetEntityValue(self.me,"partnerShow",true)
			self.chain = BehaviorFunctions.CreateEntity(600000011,nil,curShowPos.x,curShowPos.y,curShowPos.z)--创建缔约特效
			BehaviorFunctions.ClientEffectRelation(self.chain, self.PartnerAllParm.role, self.diyueHand, self.me, self.PartnerAllParm.diyuePart, 0)--设置缔约特效
			--BehaviorFunctions.SetEntityValue(self.PartnerAllParm.role,"chain",self.chain)	--缓存锁链ID
			--判断左右手播放不同特效
			if not self.PartnerAllParm.curRolePerform or self.PartnerAllParm.curRolePerform == 1 then
				BehaviorFunctions.DoMagic(self.me,self.PartnerAllParm.role,600000047,1)	--角色缔约开始特效
				BehaviorFunctions.AddBuff(self.me,self.PartnerAllParm.role,600000050,1)--角色缔约状态
			else
				BehaviorFunctions.DoMagic(self.me,self.PartnerAllParm.role,600000067,1)	--角色缔约开始特效
				BehaviorFunctions.AddBuff(self.me,self.PartnerAllParm.role,600000070,1)--角色缔约状态
			end
			--BehaviorFunctions.DoMagic(self.me,self.role,600000050,1)	
			BehaviorFunctions.DoMagic(self.me,self.me,600000049,1)	--怪物缔约状态
			BehaviorFunctions.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
			BehaviorFunctions.DoMagic(self.me,self.me,1000055,1)	--仲魔召唤技能无敌buff
			BehaviorFunctions.DoMagic(self.me,self.me,1000066,1)	--仲魔召唤浮空buff
			--如果出来的这个怪物是连携技能，则加霸体
			if self.PartnerAllParm.partnerType == 0 then
				BehaviorFunctions.DoMagic(self.me,self.me,600000041,1)	--霸体
			end
			BehaviorFunctions.DoMagic(self.me,self.me,600000005,1)	--播放仲魔出场特效
			BehaviorFunctions.AddDelayCallByFrame(2,BehaviorFunctions,BehaviorFunctions.DoMagic,self.me,self.me,600000046,1)	--播放佩从出场气浪特效

			if targetPoint and targetPoint ~= "" then
				BehaviorFunctions.CastSkillByTarget(self.me,skillId,self.PartnerAllParm.battleTarget,nil,targetPoint)	--释放技能
			else
				BehaviorFunctions.CastSkillByTarget(self.me,skillId,self.PartnerAllParm.battleTarget)
			end
			self.curConnect = skillId
			--如果传进来的技能是主动技能
			if skillId == self.PartnerAllParm.curSkillList.id then
				BehaviorFunctions.CastSkillCost(self.me,self.PartnerAllParm.curSkillList.id)	--消耗技能资源
			end
			
			--获取连携缓存目标
			--if skillId == 62003621 then
				self.curSkillTarget = self.PartnerAllParm.battleTarget
			--end
			
			--找不到目标时，原地释放技能
		elseif self.PartnerAllParm.HasTarget == false 
			--and BehaviorFunctions.CheckEntityHeight(self.PartnerAllParm.role) == 0 
			then
			BehaviorFunctions.DoSetPosition(self.me,curShowPos.x,curShowPos.y,curShowPos.z)	--设置召唤位置
			BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.PartnerAllParm.roleFrontPos.x,self.PartnerAllParm.roleFrontPos.y,self.PartnerAllParm.roleFrontPos.z,true)	--设置朝向
			BehaviorFunctions.ShowPartner(self.PartnerAllParm.role, true)	--显示仲魔
			BehaviorFunctions.SetEntityValue(self.me,"partnerShow",true)
			self.chain = BehaviorFunctions.CreateEntity(600000011,nil,curShowPos.x,curShowPos.y,curShowPos.z)--创建缔约特效
			BehaviorFunctions.ClientEffectRelation(self.chain, self.PartnerAllParm.role, self.diyueHand, self.me, self.PartnerAllParm.diyuePart, 0)--设置缔约特效
			BehaviorFunctions.SetEntityValue(self.PartnerAllParm.role,"chain",self.chain)--缓存缔约ID
			BehaviorFunctions.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
			BehaviorFunctions.DoMagic(self.me,self.me,1000055,1)	--仲魔召唤技能无敌buff
			BehaviorFunctions.DoMagic(self.me,self.me,1000066,1)	--浮空buff
			BehaviorFunctions.DoMagic(self.me,self.me,600000005,1)	--播放仲魔出场特效
			BehaviorFunctions.AddDelayCallByFrame(2,BehaviorFunctions,BehaviorFunctions.DoMagic,self.me,self.me,600000046,1)	--播放佩从出场气浪特效
			--判断左右手播放不同特效
			if not self.PartnerAllParm.curRolePerform or self.PartnerAllParm.curRolePerform == 1 then
				BehaviorFunctions.DoMagic(self.me,self.PartnerAllParm.role,600000047,1)	--角色缔约开始特效
				BehaviorFunctions.AddBuff(self.me,self.PartnerAllParm.role,600000050,1)--角色缔约状态
			else
				BehaviorFunctions.DoMagic(self.me,self.PartnerAllParm.role,600000067,1)	--角色缔约开始特效
				BehaviorFunctions.AddBuff(self.me,self.PartnerAllParm.role,600000070,1)--角色缔约状态
			end
			BehaviorFunctions.DoMagic(self.me,self.me,600000049,1)	--怪物缔约状态
			BehaviorFunctions.CastSkillBySelfPosition(self.me,skillId)	--原地释放技能
			self.curConnect = skillId
			--如果传进来的技能是主动技能
			if skillId == self.PartnerAllParm.curSkillList.id then
				BehaviorFunctions.CastSkillCost(self.me,self.PartnerAllParm.curSkillList.id)	--消耗技能资源
			end
		end
	else
		--不符合释放条件，弹出提示
		BehaviorFunctions.ShowTip(80000001)
	end
end


--召唤技能退场
function PartnerCastSkill:EndCreatePartnerSkill()
	BehaviorFunctions.SetCtrlState(self.me, false)	--设置为不可控制
	BehaviorFunctions.DoMagic(self.me,self.me,600000006,1)		--播放退场特效
	BehaviorFunctions.DoMagic(self.me,self.me,600000004,1)		--播放退场氛围特效
	BehaviorFunctions.CallCommonBehaviorFunc(self.me, "DoPartnerLeave")		--进入仲魔退场流程
	--BehaviorFunctions.SetBodyDamping(1.5,1.5,1.5)	--设置相机过渡时间
	BehaviorFunctions.RemoveFollowTarget(self.me,"CameraTarget")	--移除相机关注点
	--BehaviorFunctions.RemoveLookAtTarget(self.me,"CameraTarget")
	BehaviorFunctions.SetGroupPositionMode(1)	--设置回3D相机
	BehaviorFunctions.RemoveEntitySign(self.PartnerAllParm.role,600000010)	--移除连携状态
	BehaviorFunctions.RemoveEntitySign(self.PartnerAllParm.role,600000011)	--移除切镜连携状态
	BehaviorFunctions.RemoveBuff(self.me,600000049)	--移除自己被缔约特效
	BehaviorFunctions.RemoveBuff(self.me,600000041)	--移除霸体
	--移除锁链
	if self.chain and self.chain ~= 0 then
		if BehaviorFunctions.CheckEntity(self.chain) then
			BehaviorFunctions.RemoveEntity(self.chain)
		end
	end
	BehaviorFunctions.RemoveBuff(self.PartnerAllParm.role,600000063)
end

--计算技能召唤位置
function PartnerCastSkill:CheckCreatePos(skillTarget,targetDistance)

	local createPos = {}
	local standbyPos = {}
	--备胎点位
	standbyPos[1] = BehaviorFunctions.GetPositionOffsetBySelf(skillTarget,targetDistance,270)
	standbyPos[2] = BehaviorFunctions.GetPositionOffsetBySelf(skillTarget,targetDistance,300)
	standbyPos[3] = BehaviorFunctions.GetPositionOffsetBySelf(skillTarget,targetDistance,60)
	standbyPos[4] = BehaviorFunctions.GetPositionOffsetBySelf(skillTarget,targetDistance,90)

	local curPosList = {}

	--找到位置列表里可以用于召唤的最佳点位
	for i = 1,4 do
		standbyPos[i].y = standbyPos[i].y + 0.2
		local height,layer = BehaviorFunctions.CheckPosHeight(standbyPos[i])
		if height and height == 0 and layer and layer ~= FightEnum.Layer.Water and layer ~= FightEnum.Layer.Marsh then
			if BehaviorFunctions.CheckEntityCollideAtPosition(self.PartnerAllParm.myEntityId, standbyPos[i].x, standbyPos[i].y, standbyPos[i].z, {},self.me,true) then
				table.insert(curPosList,standbyPos[i])
			end
		end
	end

	--如果没有这种很合适的点位，开始遍历
	if not next(curPosList) then
		createPos = self:GetRandomPos(targetDistance)
		if createPos then
			return createPos
		else
			--获取地面随机的位置
			createPos = self:GetRandomLandPos(targetDistance)
			if createPos then
				return createPos
			else
			----获取一个随机位置
				createPos = self:RandomPos(targetDistance)
				if createPos then
					return createPos
				else
					return nil
				end
				return nil
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
		positionP.y = positionP.y + 0.2
		--检测障碍：
		if BehaviorFunctions.CheckEntityCollideAtPosition(self.PartnerAllParm.myEntityId, positionP.x, positionP.y, positionP.z, {self.me},self.me,true) then
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

--随机获得地面坐标
function PartnerCastSkill:GetRandomLandPos(radius)

	--PV特判
	--if BehaviorFunctions.GetEntityTemplateId(self.me) == 62003 then
		--for i = 150,360,30 do

			--local positionP = BehaviorFunctions.GetPositionOffsetBySelf(self.PartnerAllParm.role,radius,i)
			--positionP.y = positionP.y + 0.2
			----检测障碍：
			--if BehaviorFunctions.CheckEntityCollideAtPosition(self.PartnerAllParm.myEntityId, positionP.x, positionP.y, positionP.z, {},self.me,true) then
				--local y,layer = BehaviorFunctions.CheckPosHeight(positionP)
	
				----对传进来的点位进行位置修正，保证在地面
				--if y and y >= 0 then
					--local finalPos = Vec3.New()
					--finalPos:Set(positionP.x,positionP.y - y,positionP.z)
					--return finalPos
				--end
			--end
		--end
	--else
		
	for i = 60,360,60 do

		local positionP = BehaviorFunctions.GetPositionOffsetBySelf(self.PartnerAllParm.role,radius,i)
		positionP.y = positionP.y + 0.2
		--检测该点位为合法创建点位,且两点之间没有障碍
		if BehaviorFunctions.CheckEntityCollideAtPosition(self.PartnerAllParm.myEntityId, positionP.x, positionP.y, positionP.z, {},self.me,true) then
			local y,layer = BehaviorFunctions.CheckPosHeight(positionP)

			--对传进来的点位进行位置修正，保证在地面
			if y and y >= 0 then
				local finalPos = Vec3.New()
				finalPos:Set(positionP.x,positionP.y - y,positionP.z)
				return finalPos
			end
		end
	end
		
	--end
	return nil
end

--随机取点
function PartnerCastSkill:RandomPos(radius)
	for i = 90,720,30 do
		local positionP = BehaviorFunctions.GetPositionOffsetBySelf(self.PartnerAllParm.role,radius,i)
		positionP.y = positionP.y + 0.2
		--检查自己和目标点没有阻挡
		if not BehaviorFunctions.CheckObstaclesBetweenPos(self.PartnerAllParm.rolePos,positionP,false) then
			local y,layer = BehaviorFunctions.CheckPosHeight(positionP)
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
		BehaviorFunctions.BreakSkill(self.me)
		BehaviorFunctions.RemoveEntitySign(self.me,600002)		--移除离场状态标记
		--BehaviorFunctions.SetBodyDamping()	--恢复相机过渡时间
		--BehaviorFunctions.RemoveEntitySign(self.PartnerAllParm.role,600000)	--结束仲魔在场状态
		--	BehaviorFunctions.RemoveEntitySign(self.me,600003)	--移除在场标记
		--BehaviorFunctions.RemoveEntitySign(self.PartnerAllParm.role,self.me)	--结束自己在场状态
		BehaviorFunctions.RemoveBuff(self.me,1000055)	--移除无敌buff
		BehaviorFunctions.RemoveBuff(self.me,1000066)	--移除浮空
		if not self.PartnerAllParm.curRolePerform or self.PartnerAllParm.curRolePerform == 1 then
			BehaviorFunctions.DoMagic(self.PartnerAllParm.CtrlRole,self.PartnerAllParm.CtrlRole,600000048,1)	--角色缔约结束特效
			BehaviorFunctions.RemoveBuff(self.PartnerAllParm.CtrlRole,600000050)	--移除角色缔约状态
		else
			BehaviorFunctions.DoMagic(self.PartnerAllParm.CtrlRole,self.PartnerAllParm.CtrlRole,600000068,1)	--角色缔约结束特效
			BehaviorFunctions.RemoveBuff(self.PartnerAllParm.CtrlRole,600000070)	--移除角色缔约状态
		end
		BehaviorFunctions.RemoveBuff(self.me,600000016)	--移除浮空buff
		BehaviorFunctions.SetCtrlState(self.me, true)	--设置为可以控制
	end
end

--冲刺技能释放距离检查
function PartnerCastSkill:CheckTargetDistance()
	--技能响应的最大距离，有目标时开始检测，满足时标记，不满足时移除
	if self.PartnerAllParm.curSkillList.rushRange then
		if self.PartnerAllParm.HasTarget == true then
			self.targetDistance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.PartnerAllParm.battleTarget,false)
			--技能释放范围检查，如果满足则增加标记，允许精准位移
			if self.targetDistance < self.PartnerAllParm.curSkillList.rushRange then
				BehaviorFunctions.AddSkillEventActiveSign(self.me,600001)
			else
				BehaviorFunctions.RemoveSkillEventActiveSign(self.me,600001)
			end
			--没有目标不使用精准位移
		else
			BehaviorFunctions.RemoveSkillEventActiveSign(self.me,600001)
		end
	end
end

--关闭屏幕特效
function PartnerCastSkill:DelayEndEffect(instanceId)
	if instanceId then
		BehaviorFunctions.RemoveBuff(self.PartnerAllParm.role,600000035)
	end
end



--开始连携召唤技能:延迟时间，技能ID，技能参照者，距离，角度
function PartnerCastSkill:CastConnectSkill(skillId,targetInstance,createPos,distance,angle,stableShow,delayTime,changeCamera)
	if targetInstance then
		BehaviorFunctions.AddDelayCallByFrame(delayTime,self,self.DelayCallPartner,skillId,targetInstance,createPos,distance,angle,stableShow,changeCamera)	--顿帧后4帧，召唤佩从
	end
end

--延迟召唤佩从
function PartnerCastSkill:DelayCallPartner(skillId,targetInstance,createPos,distance,angle,stableShow,changeCamera)
	if targetInstance then
		BehaviorFunctions.RemoveEntitySign(self.me,600002)	--移除正在离场标记
		--	BehaviorFunctions.OpenPartnerFightBanner(self.me)	--播放横幅
		--释放佩从召唤技能
		self:StartCreatePartnerSkill(skillId,targetInstance,createPos,distance,angle,stableShow)
		if changeCamera == 0 then
			
		elseif changeCamera == 1 or changeCamera == nil then
			BehaviorFunctions.SetGroupPositionMode(2)	--设置相机模式为水平投影
			self.cameraMode = 1--相机动态参数记录
			
			--BehaviorFunctions.SetCorrectCameraState(FightEnum.CameraState.Fight, true)--开启回正
			BehaviorFunctions.AddFollowTarget(self.me,"CameraTarget")	--新增相机关注点
			if self.PartnerAllParm.HasTarget then
				if not BehaviorFunctions.HasEntitySign(1,10000007) then
					--BehaviorFunctions.SetCamerIgnoreData(FightEnum.CameraState.Fight,true,0.3)	--忽略Y轴，慎用
					--BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Fight,false)	--强制设置为战斗相机
				end
				--BehaviorFunctions.AddLookAtTarget(self.PartnerAllParm.battleTarget,"HitCase")	--新增相机关注点
				--BehaviorFunctions.AddLookAtTarget(self.me,"CameraTarget")	--新增相机关注点
			end
		elseif changeCamera == 2 then
			BehaviorFunctions.SetGroupPositionMode(1)	--立体
			self.cameraMode = 2	--相机动态参数记录
			
			BehaviorFunctions.AddFollowTarget(self.me,"CameraTarget")	--新增相机关注点
			if self.PartnerAllParm.HasTarget then
				if not BehaviorFunctions.HasEntitySign(1,10000007) then
					--BehaviorFunctions.SetCamerIgnoreData(FightEnum.CameraState.Fight,true,0.3)--忽略Y轴，慎用
					--BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Fight,false)	--强制设置为战斗相机
				end
				--BehaviorFunctions.AddLookAtTarget(self.PartnerAllParm.battleTarget,"HitCase")	--新增相机关注点
				--BehaviorFunctions.AddLookAtTarget(self.me,"CameraTarget")	
			end
		elseif changeCamera == 3 then	--设置连携下砸相机	
			BehaviorFunctions.SetGroupPositionMode(2)	--设置相机模式为水平投影
			--BehaviorFunctions.AddFollowTarget(self.me,"")	--新增相机关注点
			--PV用临时代码
			self:SetConnectCamera()
			--BehaviorFunctions.AddDelayCallByFrame(2,self,self.SetConnectCamera)	--连携下砸相机
		end
		if changeCamera ~= 3 then
			BehaviorFunctions.AddEntitySign(self.PartnerAllParm.role,600000010,-1,false)	--正在连携状态
			self.connectCamera = true
		else
			BehaviorFunctions.AddEntitySign(self.PartnerAllParm.role,600000011,-1,false)	--正在切镜连携状态
		end
	end
end

--开始连携
--连携类型：1普攻，2技能，3核心，4闪避,5下落
function PartnerCastSkill:StartConnect(skillType)
	--不填默认不使用连携
	if skillType then
		local skillId,sign = self:curConnectSkill(skillType)
		if (sign and BehaviorFunctions.HasEntitySign(self.me,sign)) or not sign then
		--如果是闪避
			if skillType == 4 then
				--获取这次要释放的佩从技能id
				if skillId then
					BehaviorFunctions.AddPostProcessByTemplateId(self.PartnerAllParm.role, 600000010, FightEnum.PostProcessType.FullScreen)	--调用场景变色
					BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000009)	--聚气
					local skillTarget,createPos = self:GetSkillTarget(self.curConnectSkillList.targetType,self.curConnectSkillList.createPos)	--获取召唤佩从目标
					BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000039)	--聚气后8帧，触发4帧顿帧
					self:CastConnectSkill(self.curConnectSkillList.id,self.dodgeAtkTarget,self.dodgeAtkTarget,self.curConnectSkillList.distance,self.curConnectSkillList.angle,self.curConnectSkillList.stableShow,8,self.curConnectSkillList.Camera)
					--计时退出
					--if self.curConnectSkillList.frame > 0 then
						--self.PartnerAllParm.skillFrame = self.PartnerAllParm.time + self.curConnectSkillList.frame
					--end
				end
			--下砸连携特判
			elseif skillType == 5 then 
				if self:curConnectSkill(skillType) then
					BehaviorFunctions.AddPostProcessByTemplateId(self.PartnerAllParm.role, 600000010, FightEnum.PostProcessType.FullScreen)	--调用场景变色
					BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000009)	--聚气
					local skillTarget,createPos = self:GetSkillTarget(self.curConnectSkillList.targetType,self.curConnectSkillList.createPos)	--获取召唤佩从目标
					BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000053)	--聚气后6帧，触发15帧顿帧
					self:CastConnectSkill(self.curConnectSkillList.id,skillTarget,createPos,self.curConnectSkillList.distance,self.curConnectSkillList.angle,self.curConnectSkillList.stableShow,8,self.curConnectSkillList.Camera)
				end
			else  --如果不是闪避
				if self:curConnectSkill(skillType) then
					BehaviorFunctions.AddPostProcessByTemplateId(self.PartnerAllParm.role, 600000010, FightEnum.PostProcessType.FullScreen)	--调用场景变色
					BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000009)	--聚气
					local skillTarget,createPos = self:GetSkillTarget(self.curConnectSkillList.targetType,self.curConnectSkillList.createPos)	--获取召唤佩从目标
					--修改--
					if BehaviorFunctions.GetEntityTemplateId(self.me) ~= 600080 and BehaviorFunctions.GetEntityTemplateId(self.me) ~= 62004 and BehaviorFunctions.GetEntityTemplateId(self.me) ~= 62001 and BehaviorFunctions.GetEntityTemplateId(self.me) ~= 600060 then
						BehaviorFunctions.DoMagic(self.PartnerAllParm.role,self.PartnerAllParm.role,600000010)	--聚气后4帧，触发4帧顿帧
						self:CastConnectSkill(self.curConnectSkillList.id,skillTarget,createPos,self.curConnectSkillList.distance,self.curConnectSkillList.angle,self.curConnectSkillList.stableShow,8,self.curConnectSkillList.Camera)
					else
						self:CastConnectSkill(self.curConnectSkillList.id,skillTarget,createPos,self.curConnectSkillList.distance,self.curConnectSkillList.angle,self.curConnectSkillList.stableShow,0,self.curConnectSkillList.Camera)
					end
					--计时退出
					--if self.curConnectSkillList.frame > 0 then
						--self.PartnerAllParm.skillFrame = self.PartnerAllParm.time + self.curConnectSkillList.frame
					--end
					--print(self.PartnerAllParm.skillFrame)
				end
			end
		end
	end
end

--缓存连携技能
function PartnerCastSkill:curConnectSkill(skillType)
	--筛选当前要释放的连携技能缓存，并将连携技能插入列表
	self.curConnectSkillList = {}
	if next(self.PartnerAllParm.connectSkillList) then
		for index,skill in pairs(self.PartnerAllParm.connectSkillList) do
			if skill.connectType == skillType then
				self.curConnectSkillList = TableUtils.CopyTable(self.PartnerAllParm.connectSkillList[index])
				if not self.curConnectSkillList.createPos then
					self.curConnectSkillList.createPos = self.PartnerAllParm.role
				end
				return skill.id,skill.sign
			end
		end
	end
	return nil
end

--闪避判断
function PartnerCastSkill:Dodge(attackInstanceId,hitInstanceId,limit)
	if hitInstanceId == self.PartnerAllParm.role then
		if attackInstanceId then
			--闪避成功释放闪避连携
			self.dodgeAtkTarget = attackInstanceId
			self:StartConnect(4)
		end
	end
end

--function PartnerCastSkill:EnterElementStateReady(atkInstanceId, instanceId, element)
	----如果进入QTE的怪物有眩晕标记
	--if BehaviorFunctions.HasEntitySign(instanceId,600000011) then
		--if BehaviorFunctions.HasEntitySign(self.me,600000010) then
			--BehaviorFunctions.RemoveFollowTarget(self.me,"HitCase")	--移除相机关注点
			--BehaviorFunctions.SetGroupPositionMode(1)	--设置回3D相机
		--end
	--end
--end

--设置下砸连携相机
function PartnerCastSkill:SetConnectCamera()
	--BehaviorFunctions.AddDelayCallByFrame(10,self,self.SetConnectCamera)	--10帧后开始进入切相机流程
	--BehaviorFunctions.SetSoftZone(true)	--设置全屏为缓动区域
	--BehaviorFunctions.SetCameraState(1)	--移除锁定
	--BehaviorFunctions.SetMainTarget(self.me)--设置相机目标为神荼
	BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.ForceLocking,true)	--切换连携强锁
	if self.curSkillTarget and self.curSkillTarget ~= 0 and BehaviorFunctions.CheckEntity(self.curSkillTarget) then
		BehaviorFunctions.SetCameraParams(FightEnum.CameraState.ForceLocking,62003,false)	--设置强锁参数
	else
		BehaviorFunctions.SetCameraParams(FightEnum.CameraState.ForceLocking,62403,false)	--设置强锁参数
	end
	BehaviorFunctions.SetSoftZone(true)		--设置全屏缓动
	BehaviorFunctions.SetBodyDamping(0.3,0.3,0.3)	--设置相机过渡时间
	BehaviorFunctions.RemoveAllLookAtTarget()
	BehaviorFunctions.RemoveAllFollowTarget()
	BehaviorFunctions.SetVCCameraBlend("WeakLockingCamera","ForceLockingCamera",0)	--过渡时间设置
	BehaviorFunctions.SetVCCameraBlend("OperatingCamera","ForceLockingCamera",0.1)	--过渡时间设置
	BehaviorFunctions.AddLookAtTarget(self.PartnerAllParm.role,"CameraTarget")		--设置看向点为角色
	BehaviorFunctions.AddLookAtTarget(self.me,"HitCase")
	BehaviorFunctions.SetLookAtTargetWeight(self.PartnerAllParm.role,"CameraTarget",2)
	BehaviorFunctions.AddFollowTarget(self.me,"HitCase")	--设置相机目标为神荼
	BehaviorFunctions.SetCameraFollow(self.me,"HitCase")
end


function PartnerCastSkill:BreakSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.me then
		--移除锁链
		if self.chain and self.chain ~= 0 then
			if BehaviorFunctions.CheckEntity(self.chain) then
				BehaviorFunctions.RemoveEntity(self.chain)
			end
		end
	end
end

function PartnerCastSkill:FinishSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.me then
		--移除锁链
		if self.chain and self.chain ~= 0 then
			if BehaviorFunctions.CheckEntity(self.chain) then
				BehaviorFunctions.RemoveEntity(self.chain)
			end
		end
	end
end

--切人缓存锁链
function PartnerCastSkill:OnSwitchPlayerCtrl(oldInstanceId,instanceId)
	if self.PartnerAllParm.chainTrans == true then
		--if self.PartnerAllParm.chainSave then
			--继承连携用
			if self.chain and self.chain ~= 0 and self.me then
				--给新上场的角色继承
				if BehaviorFunctions.CheckEntity(self.chain) then
					if not self.PartnerAllParm.curRolePerform or self.PartnerAllParm.curRolePerform == 1 then
						BehaviorFunctions.RemoveBuff(oldInstanceId,600000050)
						BehaviorFunctions.DoMagic(instanceId,instanceId,600000050,1)	--给角色上缔约状态
					else
						BehaviorFunctions.DoMagic(instanceId,instanceId,600000070,1)	--给角色上缔约状态
						BehaviorFunctions.RemoveBuff(oldInstanceId,600000070)
					end
					BehaviorFunctions.ClientEffectRelation(self.chain, instanceId, self.diyueHand, self.me, self.PartnerAllParm.diyuePart, 0)--设置缔约特效继承
				end
			end
		--else
			--if self.chain and self.chain ~= 0 then
				--if BehaviorFunctions.CheckEntity(self.chain) then
					--BehaviorFunctions.RemoveEntity(self.chain)
				--end
			--end
		--end
	end
	
	--切人退出
	if oldInstanceId == self.PartnerAllParm.role and self.PartnerAllParm.partnerType ~= 0 and self.PartnerAllParm.partnerType ~= 1 and BehaviorFunctions.CheckPartnerShow(self.PartnerAllParm.role) then
		self:EndCreatePartnerSkill()
	end
end

--重置相机位置：回正时间，保底结束时间
function PartnerCastSkill:ReturnCamera(returnTime,finishTime)
	BehaviorFunctions.SetCameraStateForce(1,false)	--设置回操作相机
	BehaviorFunctions.CameraPosReduction(returnTime,false,finishTime)	--重置相机位置
	BehaviorFunctions.RemoveAllLookAtTarget()
	BehaviorFunctions.AddLookAtTarget(self.ctrlRole,"CameraTarget")
end

--设置相机组权重
--参数：施法参照点，1以自身，2以目标
function PartnerCastSkill:SetCameraTargetWeight(skillType)
	local rolePos = BehaviorFunctions.GetTransformScreenX(self.ctrlRole,"CameraTarget")	--获取角色在相机中的位置
	local myPos = BehaviorFunctions.GetTransformScreenX(self.me,"CameraTarget")	--获取自己在相机中的位置
	local distance = math.abs(myPos - rolePos)	--获取投影位置差
	--local distcaneT = math.abs(myPos - rolePos)	--获取投影位置差

	--限制距离参数
	if distance > self.cameraDistance.Max then
		distance = self.cameraDistance.Max
	elseif distance < self.cameraDistance.Min then
		distance = self.cameraDistance.Min
	end

	--权重计算公式
	self.myCameraWeight = (1/4) ^ (2*distance)
	--self.myLookAtWeight = (1/2) ^ (4*distance)

	--当角色距离距离佩从距离>12米，判定为远距离
	--if distance > self.cameraDistance.Long then
	--self.myCameraWeight = distance * self.cameraRatio.Long
	--elseif distance > self.cameraDistance.Mid then
	--self.myCameraWeight = distance * self.cameraRatio.Mid
	--elseif distance > self.cameraDistance.Short then
	--self.myCameraWeight = distance * self.cameraRatio.Short
	--end
end

function PartnerCastSkill:SetCameraLookAtWeight()
	if self.PartnerAllParm.battleTarget and self.PartnerAllParm.battleTarget ~= 0 and BehaviorFunctions.CheckEntity(self.PartnerAllParm.battleTarget) then
		local targetPos = BehaviorFunctions.GetTransformScreenX(self.PartnerAllParm.battleTarget,"CameraTarget")	--获取目标在相机中的位置
		local myPos = BehaviorFunctions.GetTransformScreenX(self.me,"CameraTarget")	--获取自己在相机中的位置
		local rolePos = BehaviorFunctions.GetTransformScreenX(self.ctrlRole,"CameraTarget")	--获取角色在相机中的位置
		local distance = math.abs(myPos - targetPos)	--获取投影位置差
		--local weight = math.abs(targetPos)
		--local myWeight = math.abs(myPos)
		
		--if weight > 0.5 then
			--weight = 0.5
		--end
		
		--if myWeight > 0.5 then
			--myWeight = 0.5
		--end
		--如果怪物出了角色的相机
		--if targetPos > 0.4 or targetPos < -0.4 then
			
		--else
			----weight = math.abs(myPos)
			--weight = 1
		--end
			
		
		
		--限制距离参数
		if distance > self.cameraDistance.Max then
			distance = self.cameraDistance.Max
		elseif distance < self.cameraDistance.Min then
			distance = self.cameraDistance.Min
		end
		--weight = (1/2) ^ distance * 10
		--weight越大，结果越小
		--self.myLookAtWeight = (1/2) ^ (distance*weight*10)
		self.myLookAtWeight = (1/2) ^ (5*distance)
		--self.myLookAtWeight = 1
		
		
	end
end

function PartnerCastSkill:DelayEndHenshin()
	if self.me then
		BehaviorFunctions.ShowPartner(self.PartnerAllParm.role,false)
		BehaviorFunctions.DisableSkillButton(self.me, FightEnum.KeyEvent.Partner, false)
		BehaviorFunctions.DisableSkillButton(self.me, FightEnum.KeyEvent.Dodge, false)
		BehaviorFunctions.RemoveEntitySign(self.me,600000001)		--阻断按钮状态设置
		--BehaviorFunctions.RemoveBuff(self.me,1000055)	--移除初始buff
		BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
		BehaviorFunctions.RemoveEntitySign(self.PartnerAllParm.CtrlRole,600000012,-1,false)
		BehaviorFunctions.DisableAllSkillButton(self.me,false)	--结束禁用按钮
	end
end

--前台角色释放召唤技能时，移除锁链
function PartnerCastSkill:CastSkill(instanceId,skillId,skillType)
	if skillType == 600 or skillType == 601 or skillType == 602 then
		if instanceId ~= self.PartnerAllParm.role and instanceId == self.PartnerAllParm.CtrlRole then
			--如果检测到前台有锁链
			if self.chain and self.chain ~= 0 then
				if BehaviorFunctions.CheckEntity(self.chain) then
					BehaviorFunctions.RemoveEntity(self.chain)
					--播放结束特效
					if not self.PartnerAllParm.curRolePerform or self.PartnerAllParm.curRolePerform == 1 then
						BehaviorFunctions.RemoveBuff(instanceId,600000050)
						BehaviorFunctions.DoMagic(self.PartnerAllParm.CtrlRole,self.PartnerAllParm.CtrlRole,600000048,1)	--角色缔约结束特效
					else
						BehaviorFunctions.RemoveBuff(instanceId,600000070)
						BehaviorFunctions.DoMagic(self.PartnerAllParm.CtrlRole,self.PartnerAllParm.CtrlRole,600000068,1)	--角色缔约结束特效
					end
				end
			end
		end
	end
end

function PartnerCastSkill:Death(instanceId,isFormationRevive)
	if instanceId == self.PartnerAllParm.CtrlRole then
		--移除锁链
		if self.chain and self.chain ~= 0 then
			if BehaviorFunctions.CheckEntity(self.chain) then
				BehaviorFunctions.RemoveEntity(self.chain)
			end
		end
	end
end

function PartnerCastSkill:RemoveEntity(instanceId)
	if instanceId == self.me then
		BehaviorFunctions.RemoveFollowTarget(self.me,"CameraTarget")	--移除相机关注点
		BehaviorFunctions.RemoveEntitySign(self.PartnerAllParm.role,600000010)	--清除相机权重
		self.connectCamera = false
	end
end

--function PartnerCastSkill:BlendFollowTarget(time)
	--if self.changeFollow == true then
		--if self.changeFollowTime > self.PartnerAllParm.time then
			--self.curWeight = self.curWeight - 1/time
			--BehaviorFunctions.SetFollowTargetWeight(self.PartnerAllParm.role,"CameraTarget",self.curWeight)
		--else	
			--self.changeFollow = false	--到时间关闭
			--BehaviorFunctions.RemoveFollowTarget(self.PartnerAllParm.role,"CameraTarget")
		--end
	--end
--end
----传送打断技能
--function PartnerCastSkill:OnTransport()
--BehaviorFunctions.BreakSkill(self.me)	--打断自身技能
--BehaviorFunctions.ShowPartner(self.PartnerAllParm.role, false)	--隐藏仲魔
--BehaviorFunctions.RemoveEntitySign(self.me,600002)	--移除退场标记
--BehaviorFunctions.RemoveEntitySign(self.PartnerAllParm.role,600000)	--结束仲魔在场状态
--BehaviorFunctions.RemoveEntitySign(self.PartnerAllParm.role,self.me)	--结束自己在场状态
--BehaviorFunctions.RemoveBuff(self.me,1000055)	--移除无敌buff
----移除溶解buff
--if BehaviorFunctions.GetBuffCount(self.me,600000006) ~= 0 then
--BehaviorFunctions.RemoveBuff(self.me,600000006)
--end
--end