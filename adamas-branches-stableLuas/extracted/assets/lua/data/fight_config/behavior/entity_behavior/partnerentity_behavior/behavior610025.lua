Behavior610025 = BaseClass("Behavior610025",EntityBehaviorBase)
--资源预加载
function Behavior610025.GetGenerates()
	local generates = {}
	return generates
end

function Behavior610025.GetMagics()
	local generates = {62001011}
	return generates
end



function Behavior610025:Init()
	self.me = self.instanceId	--记录自身
	--接入通用AI
	self.PartnerAllParm = BehaviorFunctions.CreateBehavior("PartnerAllParm",self)
	self.PartnerCastSkill = BehaviorFunctions.CreateBehavior("PartnerCastSkill",self)
	self.PartnerAllParm.autoRemove = false	--不自动退场
	self.PartnerAllParm.autoChangeBtn = true
	--self.PartnerAllParm.hasFightSkill = true
	self.ctrlRole = BehaviorFunctions.GetCtrlEntity()
	
	self.role = 0
	self.mission = 0
	self.time = 0
	self.LockTarget = 0
	self.LockTargetPoint = 0
	self.LockTargetPart = 0
	self.Role1 = BehaviorFunctions.GetQTEEntity(1)
	self.Role2 = BehaviorFunctions.GetQTEEntity(2)
	self.Role3 = BehaviorFunctions.GetQTEEntity(3)

	--记录战斗目标相关
	self.AttackTarget = 0
	self.AttackTargetPoint = 0
	self.AttackTargetPart = 0
	self.LockAltnTarget = 0
	self.LockAltnTargetPoint = 0
	self.LockAltnTargetPart = 0
	self.AttackAltnTarget = 0
	self.AttackAltnTargetPoint = 0
	self.AttackAltnTargetPart = 0

	self.noTarget = 0
	--缓存技能按钮
	self.curSkillId = 0

	--钻地状态定义
	self.hideState = 0	--石龙状态管理：0不在钻地状态下，1在钻地状态下

	--技能id记录
	self.worldSkill = 610025005	--脱战技能
	self.fightSkill = 610025002	--战中技能
	self.abilityId = 0

	self.hideFrame = 0
	self.hideSkillCd = 1200
	self.hideTime = 999999

	self.hideAtkDistance = 0
	self.checkFrame = 0
	self.downState = 0
	self.cameraTran = false
	self.cameraFrame = 0
	self.hideMusic = false	--默认不播放钻地音乐
	
	self.PartnerAllParm.skillList = {
		--主动技能列表
		{
			id = 610025004,
			showType = 1,	--1变身型，2召唤型
			frame = 84,	--技能持续时间，时间结束自动进入退场流程
			skillType = 3, --1战前释放，2战中释放，3不需要战前战中切换
			distance =	2,	--召唤技能释放距离
			angle = 280,  --召唤技能释放角度
			targetType = 2,	--目标点：1以角色为中心，2以敌人为中心；变身：1为不选择目标，2为选择目标
			createPos = 1, --创建点：1以角色为中心，2以敌人为中心
			rushRange = 10,	--召唤冲刺技能极限范围，需要在技能帧事件中位移事件配置技能标记
			rolePerform = 1,	--0不使用角色出场动作，,1使用前召唤，2使用后召唤
			stableShow = 0,	--是否需要在指定位置稳定创建，0不需要，1需要
			Camera = 1,		--是否使用3D动态镜头，召唤：1为使用水平投影，2为3D动态，一般使用水平投影；变身：0为使用操作相机，1为不处理
		}
	}

	
end



function Behavior610025:Update()
	--接入佩从通用AI
	self.PartnerAllParm:Update()
	self.PartnerCastSkill:Update()
		
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetEntityOwner(self.me)
	self.ctrlRole = BehaviorFunctions.GetCtrlEntity()	--获取前台角色
	--获取实体参数
	self:GetTarget()
	self.myPos = BehaviorFunctions.GetPositionP(self.me)
	self.rolePos = BehaviorFunctions.GetPositionP(self.ctrlRole)
	self.fightState = 0
	self.distance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.ctrlRole,false)
	BehaviorFunctions.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
	self.Role1 = BehaviorFunctions.GetQTEEntity(1)
	self.Role2 = BehaviorFunctions.GetQTEEntity(2)
	self.Role3 = BehaviorFunctions.GetQTEEntity(3)
	local rushCd = 0

	self.fightSkillPos = BehaviorFunctions.GetPositionOffsetBySelf(self.ctrlRole,2,280)	--战中技能释放位置
	self.worldSkillPos = BehaviorFunctions.GetPositionOffsetBySelf(self.ctrlRole,0,0)	--战前技能释放位置
	self.MyFrontPos = BehaviorFunctions.GetPositionOffsetBySelf(self.ctrlRole,10,0) --角色前方的位置

	--获取目标距离
	if self.noTarget == 0 then
		self.hideAtkDistance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.battleTarget,false)
		--钻地冲击技能释放范围
		if self.hideAtkDistance < 5 then
			BehaviorFunctions.AddSkillEventActiveSign(self.me,610025999)
		else
			BehaviorFunctions.RemoveSkillEventActiveSign(self.me,610025999)
		end
	end


	--技能id传值
	BehaviorFunctions.SetEntityValue(self.me,"worldSkill",self.worldSkill)
	BehaviorFunctions.SetEntityValue(self.me,"fightSkill",self.fightSkill)
	BehaviorFunctions.SetEntityValue(self.me,"hideState",self.hideState)

	--更新仲魔按钮状态
	--if BehaviorFunctions.CheckPlayerInFight() then
		--if self.curSkillId ~= 610025004 then
			--self.curSkillId = 610025004
			--BehaviorFunctions.ChangePartnerSkill(self.role, self.curSkillId)
		--end
	--else
		--if self.hideState == 0 and self.curSkillId ~= self.worldSkill then
			--self.curSkillId = self.worldSkill
			----BehaviorFunctions.RelevanceEntitySkill(self.me, self.me, FightEnum.KeyEvent.NormalSkill, self.curSkillId)
			--BehaviorFunctions.ChangePartnerSkill(self.role, self.curSkillId)
		--elseif self.hideState == 1 and self.curSkillId ~= 610025014 then
			--self.curSkillId = 610025014
			
			--BehaviorFunctions.SetFightUISkillBtnId(self.me,FightEnum.KeyEvent.Partner,self.curSkillId)
			--BehaviorFunctions.ChangeFightBtn(self.role, self.me)
			----BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , true)
			----BehaviorFunctions.RelevancewEntitySkill(self.me, self.me, FightEnum.KeyEvent.NormalSkill, self.curSkillId)
		--end
	--end
	
	if self.role == 1 then
		--根据高度开关按钮
		if self.hideState == 0 and not BehaviorFunctions.HasEntitySign(self.me,600000001) and not BehaviorFunctions.HasBuffKind(self.ctrlRole,5001) then
			local hight,layer=BehaviorFunctions.CheckPosHeight(self.rolePos)
			if BehaviorFunctions.CheckEntityHeight(self.ctrlRole) == 0 and layer ~= FightEnum.Layer.Water then
				BehaviorFunctions.DisableSkillButton(self.ctrlRole,FightEnum.KeyEvent.PartnerSkill , false)
				BehaviorFunctions.SetAbilityCanUse(self.abilityId, true)
			else
				BehaviorFunctions.DisableSkillButton(self.ctrlRole,FightEnum.KeyEvent.PartnerSkill , true)
				BehaviorFunctions.SetAbilityCanUse(self.abilityId, false)
			end
		end

	
		
		--时间超过，强制结束钻地
		if self.hideState == 1 and self.hideFrame < self.time then
			BehaviorFunctions.BreakSkill(self.me)
			BehaviorFunctions.CastSkillBySelfPosition(self.me,610025012)
			BehaviorFunctions.SetFightMainNodeVisible(1,"R",false)	--结束期间按钮隐藏
			self.hideState = 0
		end
	
		--钻地状态时，让角色位置始终处于自身上方
		if self.hideState == 1 then
			BehaviorFunctions.DoSetPosition(self.ctrlRole,self.myPos.x,self.myPos.y,self.myPos.z)
			--BehaviorFunctions.DoEntityAudioPlay(self.me,"ShilongMe2_Atk052",true)
			--进行一个音乐的判断
			if self.hideMusic == false then
				BehaviorFunctions.DoEntityAudioPlay(self.me,"ShilongMe4_Atk052",true)
				self.hideMusic = true
			end
			
			--如果其他佩从进入变身，则走中途离场变身流程
			if BehaviorFunctions.HasEntitySign(self.ctrlRole,600000021) then
				self:EndHenshin()
				self.hideState = 0
				BehaviorFunctions.RemoveBuff(self.me,610025012)
				BehaviorFunctions.RemoveEntitySign(self.ctrlRole,10000009)
				--BehaviorFunctions.RemoveBuff(self.me,600000032)	--结束视野收窄
				BehaviorFunctions.RemoveBuff(self.me,1000071)
			end
		else
			if self.hideMusic == true then
				BehaviorFunctions.DoEntityAudioStop(self.me,"ShilongMe4_Atk052",0.1,0.1)
				self.hideMusic = false
			end
		end
	
		
		if self.Role1 and BehaviorFunctions.HasBuffKind(self.Role1,40035001) then
			rushCd = BehaviorFunctions.GetEntityValue(self.Role1,"rushCd")
		elseif self.Role2 and BehaviorFunctions.HasBuffKind(self.Role2,40035001) then
			rushCd = BehaviorFunctions.GetEntityValue(self.Role2,"rushCd")
		elseif self.Role3 and BehaviorFunctions.HasBuffKind(self.Role3,40035001) then
			rushCd = BehaviorFunctions.GetEntityValue(self.Role3,"rushCd")
		else
			rushCd = 0
		end
	
	
		--钻地冲刺逻辑
		if self.Role1 and BehaviorFunctions.HasBuffKind(self.Role1,40035001) 
			or self.Role2 and BehaviorFunctions.HasBuffKind(self.Role2,40035001)
			or self.Role3 and BehaviorFunctions.HasBuffKind(self.Role3,40035001) then
			if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Dodge) and self.hideState == 1 then
				if BehaviorFunctions.CheckBtnUseSkill(self.me,610025003,true) then
					BehaviorFunctions.CastSkillBySelfPosition(self.me,610025003)
					BehaviorFunctions.CastSkillCost(self.me,610025003,true)
					if rushCd and rushCd ~= 0 then
						BehaviorFunctions.SetBtnSkillCDTime(self.me,FightEnum.KeyEvent.Dodge,rushCd)
					end
				end
			end
		end
		
		--进地播放常驻特效
		if self.hideState == 1 and BehaviorFunctions.GetSkillSign(self.me,610025010) then
			BehaviorFunctions.SetBodyDamping(1,1,1)
			--周围三米有人检测
			self.TargetList = BehaviorFunctions.SearchEntities(self.me,2.9,0,359,2,1,nil,nil,1,1,2,false,false,0,0,false,false,false)
			if next(self.TargetList) then
				BehaviorFunctions.RemoveBuff(self.me,610025010)
				BehaviorFunctions.DoMagic(self.me,self.me,610025011,1)
			else
				if BehaviorFunctions.GetBuffCount(self.me, 610025010) == 0 then
					BehaviorFunctions.RemoveBuff(self.me,610025011)
					BehaviorFunctions.DoMagic(self.me,self.me,610025010,1)
				end
			end
			
	
			
		
			
			--钻地检测上方是否有障碍
			if self.checkFrame < self.time then
				--if BehaviorFunctions.CheckEntityCollideAtPosition(1001, self.myPos.x, self.myPos.y, self.myPos.z,{self.me,self.role},self.role) == false then
				if BehaviorFunctions.DoCollideCheckAtPosition(self.myPos.x, self.myPos.y + 3, self.myPos.z, 3, 3, 0.001, {self.me,self.ctrlRole}) == true then
					BehaviorFunctions.DisableSkillButton(self.ctrlRole,FightEnum.KeyEvent.PartnerSkill , true)
					BehaviorFunctions.SetAbilityCanUse(self.abilityId, false)
					BehaviorFunctions.SetCameraVerticalRange(7,7)	--设置相机转角限制
					BehaviorFunctions.SetBodyDamping(2,2,2)		--设置相机过渡时间
					BehaviorFunctions.RemoveAllFollowTarget()
					BehaviorFunctions.AddFollowTarget(self.me,"BurrowCamera")
					self.downState = 1
				else
					BehaviorFunctions.SetCameraVerticalRange(-180,180)
					BehaviorFunctions.RemoveAllFollowTarget()
					BehaviorFunctions.AddFollowTarget(self.me,"CameraTarget")
					BehaviorFunctions.DisableSkillButton(self.ctrlRole,FightEnum.KeyEvent.PartnerSkill , false)
					BehaviorFunctions.SetAbilityCanUse(self.abilityId, true)
					BehaviorFunctions.SetCameraColliderDamping(5)
					BehaviorFunctions.SetCameraFollow(self.me)
					self.cameraTran = true
					self.downState = 0
					BehaviorFunctions.SetBodyDamping(1,1,1)
					self.cameraFrame = self.time + 3*30
					BehaviorFunctions.SetCameraColliderDamping(0)
				end
				self.checkFrame = self.time + 5
			end
		elseif self.hideState == 0 then
			BehaviorFunctions.RemoveBuff(self.me,610025010)
			BehaviorFunctions.RemoveBuff(self.me,610025011)
		end
		
		
		if self.cameraFrame < self.time and self.cameraTran == true then
			self.cameraTran = false
			BehaviorFunctions.SetCameraColliderDamping(5)
		end
	end
end

--技能连击检测
function Behavior610025:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	if attackInstanceId == self.me and BehaviorFunctions.GetEntityTemplateId(instanceId) == 610025002001 then
		BehaviorFunctions.AddSkillEventActiveSign(self.ctrlRole,1001999)
		BehaviorFunctions.AddBuff(self.me,self.role,610025005,1)	--让角色受到我的顿帧影响
	end
	
	if attackInstanceId == self.me and BehaviorFunctions.GetEntityTemplateId(instanceId) == 610025004003 then
		BehaviorFunctions.AddBuff(self.me,self.role,610025007,1)	--让角色受到我的顿帧影响
		BehaviorFunctions.AddBuff(self.me,self.me,610025007,1)
		BehaviorFunctions.AddBuff(self.me,hitInstanceId,610025008,1)
		BehaviorFunctions.SetEntityValue(1,"curConnectTarget",hitInstanceId)
		if BehaviorFunctions.HasEntitySign(self.me,61002501) then
			BehaviorFunctions.DoMagic(self.me,hitInstanceId,610025018)
		end
	end
end

--被打出地面
function Behavior610025:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType)
	if hitInstanceId == self.ctrlRole then
		if self.hideState == 1 and self.downState == 0 then
			BehaviorFunctions.CastSkillBySelfPosition(self.me,610025001)
			BehaviorFunctions.DoMagic(self.ctrlRole,self.ctrlRole,600000003)
			--BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , true)
			BehaviorFunctions.DisableAllSkillButton(self.ctrlRole,true)
			BehaviorFunctions.SetAbilityCanUse(self.abilityId, false)
			BehaviorFunctions.RemoveBuff(self.me,600000017)--移除斜坡状态
			BehaviorFunctions.RemoveEntitySign(self.ctrlRole,10000009)
			BehaviorFunctions.RemoveEntitySign(self.ctrlRole,610025)
			BehaviorFunctions.RemoveEntitySign(self.me,610025)
			BehaviorFunctions.DoMagic(self.me,self.ctrlRole,1000048,1)
			--BehaviorFunctions.RemoveBuff(self.me,600000032)	--结束视野收窄
			--BehaviorFunctions.RemoveBuff(self.me,600000041)	--移除霸体
			self.hideState = 0
		end
	end
end



function Behavior610025:AddSkillSign(instanceId,sign)
	--仲魔变身
	if sign == 600000002 and instanceId == self.ctrlRole and self.role == 1 then
		--BehaviorFunctions.AddDelayCallByTime(0.1,self,self.Henshin)
		--self:HideButton()	--隐藏按钮
	end
	

	
	if instanceId == self.me or instanceId == self.role then
		--如果佩从离场了，重置允许滑动屏幕
		if sign == 600000021 then
			BehaviorFunctions.SetInputKeyDisable(FightEnum.KeyEvent.ScreenMove,false)
		end
		
		--钻地结束回调
		if sign == 610025012 then
			self:EndHenshin()
		end
	
		--仲魔主动退场回调
		if sign == 610025002 then
			BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.ShowPartnerByAbilityWheel,self.me, false)
			BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
			BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.RemoveEntitySign,self.ctrlRole,600000)--移除仲魔在场标记
		end
	
		--释放按钮
		if sign == 610025011 then
			BehaviorFunctions.DoMagic(self.me,self.me,1000071)
		end
	
		--石龙出土时设置状态
		if sign == 610025013 then
			self.hideState = 0
			BehaviorFunctions.RemoveBuff(self.me,1000071)
			--BehaviorFunctions.RemoveBuff(self.me,610025010)
			--BehaviorFunctions.RemoveBuff(self.me,610025011)
		--	BehaviorFunctions.DisableAllSkillButton(self.me,true)
			--BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , true)
			BehaviorFunctions.RemoveBuff(self.me,610025012)
			BehaviorFunctions.RemoveEntitySign(self.ctrlRole,10000009)
			--BehaviorFunctions.RemoveBuff(self.me,600000032)
			BehaviorFunctions.SetBodyDamping(0.5,0.5,0.5)	--重置缓动参数
		end
	
		--入土出土禁用按钮
		if sign == 610025777 then
			BehaviorFunctions.DisableAllSkillButton(self.ctrlRole,true)
			BehaviorFunctions.SetAbilityCanUse(self.abilityId, false)
			--BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , true)
		end
		
		--检测到石龙钻进地里，设置进入钻地状态
		if sign == 610025010 then
			BehaviorFunctions.RemoveBuff(self.me,1000055)--去掉移除碰撞
			BehaviorFunctions.DoMagic(self.me,self.me,600000017,1)--添加斜坡旋转buff
			BehaviorFunctions.DisableAllSkillButton(self.ctrlRole,false)
			BehaviorFunctions.SetAbilityCanUse(self.abilityId, true)
		end
	
		--被打起身时结束变身
		if sign == 6000010 then
			self:EndHenshin()
			BehaviorFunctions.RemoveBuff(self.me,1000071)
			--BehaviorFunctions.RemoveBuff(self.me,610025010)
			--BehaviorFunctions.RemoveBuff(self.me,610025011)
		end
		
		--钻地衔接潜水
		if sign == 610025099 then
			BehaviorFunctions.CastSkillBySelfPosition(self.me,610025013)
			if BehaviorFunctions.GetBuffCount(self.me,610025012) == 0 then
				BehaviorFunctions.AddBuff(self.me,self.me,610025012,1)
				
			end
		end
		
	end
end

function Behavior610025:HideButton()
	BehaviorFunctions.SetFightMainNodeVisible(1,"I",false)	--技能
	BehaviorFunctions.SetFightMainNodeVisible(1,"L",false)	--大招
	BehaviorFunctions.SetFightMainNodeVisible(1,"J",false)	--普攻
	BehaviorFunctions.SetFightMainNodeVisible(1,"O",false)	--跳跃
	--BehaviorFunctions.SetFightMainNodeVisible(1,"K",false)	--疾跑
	--有这个buff的时候，打开佩从按钮
	if (self.Role1 and not BehaviorFunctions.HasBuffKind(self.Role1,40020001))
		and (self.Role2 and not BehaviorFunctions.HasBuffKind(self.Role2,40020001))
		and (self.Role3 and not BehaviorFunctions.HasBuffKind(self.Role3,40020001)) then
		if (self.Role1 and not BehaviorFunctions.HasEntitySign(self.Role1,62001))
			or (self.Role2 and not BehaviorFunctions.HasEntitySign(self.Role2,62001))
			or (self.Role3 and not BehaviorFunctions.HasEntitySign(self.Role3,62001)) then
			BehaviorFunctions.SetFightMainNodeVisible(1,"R",false)	--仲魔
			BehaviorFunctions.AddEntitySign(self.ctrlRole,600000003,-1,false)	--禁用暗杀
		end
	end
	BehaviorFunctions.SetFightMainNodeVisible(1,"F",false)	--瞄准
	BehaviorFunctions.SetFightMainNodeVisible(1,"Core",false)	--核心被动条
	BehaviorFunctions.SetFightMainNodeVisible(1,"PowerGroup",false,1)--隐藏能量条

end

function Behavior610025:ShowButton()
	BehaviorFunctions.SetFightMainNodeVisible(1,"I",true)	--技能
	BehaviorFunctions.SetFightMainNodeVisible(1,"J",true)	--普攻
	BehaviorFunctions.SetFightMainNodeVisible(1,"O",true)	--跳跃
	BehaviorFunctions.SetFightMainNodeVisible(1,"K",true)	--疾跑
	BehaviorFunctions.SetFightMainNodeVisible(1,"R",true)	--仲魔
	BehaviorFunctions.SetFightMainNodeVisible(1,"F",true)	--瞄准
	BehaviorFunctions.SetFightMainNodeVisible(1,"L",true)	--大招
	BehaviorFunctions.SetFightMainNodeVisible(1,"Core",true)	--核心被动条
	BehaviorFunctions.SetFightMainNodeVisible(1,"PowerGroup",true,1)--隐藏能量条
	BehaviorFunctions.RemoveEntitySign(self.ctrlRole,600000003,-1,false)	--禁用暗杀
end

--获取战斗技能目标
function Behavior610025:GetTarget()

	self.LockTarget = BehaviorFunctions.GetEntityValue(self.ctrlRole,"LockTarget")
	self.LockTargetPoint = BehaviorFunctions.GetEntityValue(self.ctrlRole,"LockTargetPoint")
	self.LockTargetPart = BehaviorFunctions.GetEntityValue(self.ctrlRole,"LockTargetPart")

	self.AttackTarget = BehaviorFunctions.GetEntityValue(self.ctrlRole,"AttackTarget")
	self.AttackTargetPoint = BehaviorFunctions.GetEntityValue(self.ctrlRole,"AttackTargetPoint")
	self.AttackTargetPart = BehaviorFunctions.GetEntityValue(self.ctrlRole,"AttackTargetPart")

	self.LockAltnTarget = BehaviorFunctions.GetEntityValue(self.ctrlRole,"LockAltnTarget")
	self.LockAltnTargetPoint = BehaviorFunctions.GetEntityValue(self.ctrlRole,"LockAltnTargetPoint")
	self.LockAltnTargetPart = BehaviorFunctions.GetEntityValue(self.ctrlRole,"LockAltnTargetPart")

	self.AttackAltnTarget = BehaviorFunctions.GetEntityValue(self.ctrlRole,"AttackAltnTarget")
	self.AttackAltnTargetPoint = BehaviorFunctions.GetEntityValue(self.ctrlRole,"AttackAltnTargetPoint")
	self.AttackAltnTargetPart = BehaviorFunctions.GetEntityValue(self.ctrlRole,"AttackAltnTargetPart")

	if BehaviorFunctions.CheckEntity(self.LockTarget) then
		self.battleTarget = self.LockTarget
		self.noTarget = 0
		BehaviorFunctions.AddSkillEventActiveSign(self.me,self.fightSkill)
	elseif BehaviorFunctions.CheckEntity(self.AttackTarget) then
		self.battleTarget = self.AttackTarget
		self.noTarget = 0
		BehaviorFunctions.AddSkillEventActiveSign(self.me,self.fightSkill)
	elseif BehaviorFunctions.CheckEntity(self.AttackAltnTarget) then
		self.battleTarget = self.AttackAltnTarget
		self.noTarget = 0
		BehaviorFunctions.AddSkillEventActiveSign(self.me,self.fightSkill)
	else
		self.noTarget = 1
		BehaviorFunctions.AddSkillEventActiveSign(self.me,62001108)
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,self.fightSkill)
	end


end


--变身
function Behavior610025:Henshin()
	--释放钻地
	BehaviorFunctions.AddEntitySign(self.ctrlRole,600000012,-1,false)	--标记为处于变身状态
	BehaviorFunctions.AddEntitySign(self.ctrlRole,600000,-1,false)	--标记仲魔在场
	BehaviorFunctions.AddEntitySign(self.me,600000001,-1,false)		--阻断按钮状态设置
	BehaviorFunctions.SetJoyMoveEnable(self.ctrlRole, false)
	BehaviorFunctions.DoMagic(self.me,self.ctrlRole,1000048)	--隐藏模型
	--BehaviorFunctions.SetMainTarget(self.me)
	--BehaviorFunctions.AddBuff(self.role,self.role,1000048)

	--BehaviorFunctions.ChangeFightBtn(self.role,self.me)
	
	--BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.SetFightMainNodeVisible,1,"R",true)	--仲魔
	BehaviorFunctions.SetCoreUIEnable(self.ctrlRole, false)--屏蔽核心能量条
	self.hideState = 1	--钻地状态设置
	--BehaviorFunctions.DoMagic(self.me,self.me,600000032,1)	--设置钻地视野收窄
	self.hideFrame = self.time + self.hideTime --设置钻地时间
	BehaviorFunctions.SetAbilityWheelIcon(610025014)	--设置轮盘按钮图标
	--添加潜行标记
	BehaviorFunctions.AddEntitySign(self.ctrlRole,10000009,-1,false)--屏蔽角色按键输入
	BehaviorFunctions.AddEntitySign(self.me,610025,-1,false)
	BehaviorFunctions.AddEntitySign(self.ctrlRole,610025,-1,false)
	BehaviorFunctions.DoSetPosition(self.me,self.worldSkillPos.x,self.worldSkillPos.y,self.worldSkillPos.z)--设置坐标
	BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.MyFrontPos.x,self.MyFrontPos.y,self.MyFrontPos.z)--设置朝向
	BehaviorFunctions.ShowPartnerByAbilityWheel(self.me,true)	--轮盘发起召唤佩从
	BehaviorFunctions.CastSkillBySelfPosition(self.me,610025005)	--释放钻地技能
	BehaviorFunctions.ChangeCollideHeight(self.me,0.4)
	BehaviorFunctions.DoMagic(self.me,self.me,1000055)--移除碰撞
	--BehaviorFunctions.SetMainTarget(self.me)
	BehaviorFunctions.DoMagic(self.me,self.me,1000053)
	--BehaviorFunctions.CastSkillCost(self.me,610025005)		--技能消耗，废弃
	BehaviorFunctions.SetExtraMoveCheckDistance(self.me, 1.7, 1.5)		--设置边缘检查距离
	BehaviorFunctions.ChangeCollideRadius(self.me,0.2)
	--BehaviorFunctions.DoMagic(self.me,self.me,600000041,1)	--霸体
	BehaviorFunctions.DoMagic(self.me,self.me,610025016)	--添加钻地初始buff
	BehaviorFunctions.DoMagic(self.ctrlRole,self.ctrlRole,610025016)	--添加钻地初始buff
	BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Operating,true)
	BehaviorFunctions.RemoveAllFollowTarget()
	BehaviorFunctions.AddFollowTarget(self.me,"CameraTarget")	--添加关注点
	BehaviorFunctions.RemoveAllLookAtTarget()
	BehaviorFunctions.AddLookAtTarget(self.me,"CameraTarget")
end

--结束变身
function Behavior610025:EndHenshin()
	--BehaviorFunctions.AddDelayCallByTime(0.2,BehaviorFunctions,BehaviorFunctions.SetMainTarget,self.role)
	--如果佩从不在变身状态下
	if not BehaviorFunctions.HasEntitySign(self.ctrlRole,600000021) then
		BehaviorFunctions.RemoveAllFollowTarget()
		BehaviorFunctions.AddFollowTarget(self.ctrlRole,"CameraTarget")
		BehaviorFunctions.RemoveAllLookAtTarget()
		BehaviorFunctions.AddLookAtTarget(self.ctrlRole,"CameraTarget")
		BehaviorFunctions.SetMainTarget(self.ctrlRole)
		BehaviorFunctions.RemoveBuff(self.ctrlRole,1000048)
		BehaviorFunctions.DoSetPosition(self.ctrlRole,self.myPos.x,self.myPos.y+0.2,self.myPos.z)
		BehaviorFunctions.SetCoreUIEnable(self.ctrlRole, true)--显示核心能量条
		BehaviorFunctions.DoMagic(self.ctrlRole,self.ctrlRole,1000054)
		BehaviorFunctions.SetBodyDamping(0.5,0.5,0.5)	--重置缓动参数
		BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Operating,false)
	end
	BehaviorFunctions.RemoveEntitySign(self.ctrlRole,600000012)
	BehaviorFunctions.RemoveBuff(self.ctrlRole,610025016)	--移除钻地初始buff
	BehaviorFunctions.RemoveEntitySign(self.ctrlRole,610025)--移除潜地标记
	BehaviorFunctions.SetJoyMoveEnable(self.ctrlRole, true)--恢复控制
	BehaviorFunctions.AddDelayCallByTime(1.1,self,self.HenshinLeave)
	--self:HenshinLeave()
	BehaviorFunctions.DoMagic(self.me,self.me,1000052)
	BehaviorFunctions.DoMagic(self.me,self.me,1000055)--移除碰撞
	BehaviorFunctions.RemoveEntitySign(self.me,610025)--移除潜地标记
	BehaviorFunctions.ChangeCollideHeight(self.me,2)	--改变碰撞高度
	--BehaviorFunctions.ChangeFightBtn(self.role,self.role)
	BehaviorFunctions.ChangeCollideRadius(self.me,0.5)	--改变碰撞半径
	--BehaviorFunctions.RemoveBuff(self.me,600000041)	--移除霸体
	self:ShowButton()
	BehaviorFunctions.RemoveBuff(self.me,610025016) 	--移除钻地初始buff

--	self:ReturnCamera(0.2,0.5)	--重置相机状态和位置

	BehaviorFunctions.RemoveEntitySign(self.me,600000001)		--阻断按钮状态设置
	if self.abilityId and self.abilityId ~= 0 then
		BehaviorFunctions.ApplyAbilityWheelCoolTime(self.abilityId)
		BehaviorFunctions.SetAbilityWheelIcon(610025005)	--设置轮盘按钮图标
	end
end

function Behavior610025:CastSkill(instanceId,skillId,skillType)
	if instanceId == self.me then
		if skillId == 610025004 then
			BehaviorFunctions.DoMagic(self.me,self.me,1000055)	--施加初始buff
			BehaviorFunctions.SetInputKeyDisable(FightEnum.KeyEvent.ScreenMove,true)	--屏蔽视角调整
		end
	end
end

--受击前
function Behavior610025:Hit(attackInstanceId,hitInstanceId,hitType,camp)
	--受击QTE回调
	if attackInstanceId == self.me then
		if BehaviorFunctions.GetHitType(hitInstanceId) == FightEnum.EntityHitState.HitFlyUp or BehaviorFunctions.GetHitType(hitInstanceId) == FightEnum.EntityHitState.HitFlyFall then
			if BehaviorFunctions.GetSkill(self.me) == 610025004 then
				BehaviorFunctions.AddEntitySign(1,600000002,90)	--标记为佩从触发了佩从连携QTE，持续3秒
				BehaviorFunctions.SetEntityValue(1,"curConnectTarget",hitInstanceId)
				--if not self.PartnerAllParm.curQTETarget or self.PartnerAllParm == 0 then
					--self.PartnerAllParm.curQTETarget = hitInstanceId	--缓存为当前QTE的目标
				--end
			end
		end
	end
end

function Behavior610025:HenshinLeave()
	if self.me and self.abilityId and self.ctrlRole then
		BehaviorFunctions.ShowPartnerByAbilityWheel(self.me,false)
		BehaviorFunctions.DisableAllSkillButton(self.ctrlRole,false)
		BehaviorFunctions.SetAbilityCanUse(self.abilityId, true)
		BehaviorFunctions.RemoveEntitySign(self.ctrlRole,600000)--移除仲魔在场标记
		BehaviorFunctions.SetCanOpenFightAbilityWheel(true)
	end
end

--挂载回声特效
--function Behavior610025:showNPCEffect()
	
	----筛选10米内的NPC
	--self.npcShowList = BehaviorFunctions.SearchEntities(self.me,10,0,359,2,1,nil,nil,1,1,2,false,false,0,0,false,false,false)
	--if next(self.npcShowList) then
		--for i,v in pairs(self.npcShowList) do
			--BehaviorFunctions.DoMagic(self.me,self.npcShowList[i][1],600000033,1)
		--end
	--end
--end


--传送时强制恢复状态
--function Behavior610025:OnTransport()
	--BehaviorFunctions.RemoveBuff(self.role,1000048)
	--BehaviorFunctions.SetMainTarget(self.role)
	--BehaviorFunctions.ShowPartner(self.role,false)
	--BehaviorFunctions.DisableAllSkillButton(self.me,false)
	--BehaviorFunctions.RemoveEntitySign(self.role,600000)
	--BehaviorFunctions.DoMagic(self.me,self.me,1000055)--移除碰撞
	--BehaviorFunctions.SetJoyMoveEnable(self.role, true)--恢复控制
	--BehaviorFunctions.RemoveEntitySign(self.role,610025)--移除潜地标记
	--BehaviorFunctions.RemoveEntitySign(self.me,610025)--移除潜地标记
	--BehaviorFunctions.SetCoreUIEnable(self.role, true)--显示核心能量条
	--BehaviorFunctions.ChangeCollideHeight(self.me,2.8)
	--self.hideState = 0
	--self:ShowButton()
	--BehaviorFunctions.RemoveBuff(self.me,1000071)
	--BehaviorFunctions.ChangeCollideRadius(self.me,1.7)
--end

--function Behavior610025:BeforeTransport()
	--BehaviorFunctions.RemoveBuff(self.role,1000048)
	--BehaviorFunctions.SetMainTarget(self.role)
	--BehaviorFunctions.ShowPartner(self.role,false)
	--BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
	--BehaviorFunctions.RemoveEntitySign(self.role,600000)
	--BehaviorFunctions.DoMagic(self.me,self.me,1000055)--移除碰撞
	--BehaviorFunctions.SetJoyMoveEnable(self.role, true)--恢复控制
	--BehaviorFunctions.RemoveEntitySign(self.role,610025)--移除潜地标记
	--BehaviorFunctions.RemoveEntitySign(self.me,610025)--移除潜地标记
	--BehaviorFunctions.SetCoreUIEnable(self.role, true)--显示核心能量条
	--BehaviorFunctions.ChangeCollideHeight(self.me,2.8)
	--BehaviorFunctions.RemoveBuff(self.me,1000071)
	--self.hideState = 0
	--self:ShowButton()
--end

function Behavior610025:ExtraEnterTrigger(triggerInstanceId,triggerEntityId,InstanceId)
	if triggerInstanceId == self.me then
		local npctag = BehaviorFunctions.GetNpcType(InstanceId)
			--判断是否有buff组件
		if BehaviorFunctions.CheckEntityHasComponents(InstanceId, FightEnum.ComponentType.Buff) == true then
			if self.hideState == 1 then
				--判断阵营添加不同颜色的回声特效
				if npctag == 0 or npctag == 1 or npctag == 6 then
					BehaviorFunctions.DoMagic(self.me,InstanceId,600000033)
				elseif npctag == 2 or npctag == 3 or npctag == 4 then
					BehaviorFunctions.DoMagic(self.me,InstanceId,600000034)
				end
			else	
				if BehaviorFunctions.HasBuffKind(InstanceId,600000033) then
					BehaviorFunctions.RemoveBuff(InstanceId,600000033)
					BehaviorFunctions.RemoveBuff(InstanceId,600000034)
				end
			end
		end
	end
end


function Behavior610025:ExtraExitTrigger(triggerInstanceId,triggerEntityId,InstanceId)
	if triggerInstanceId == self.me then
		if BehaviorFunctions.CheckEntity(InstanceId) then
			local npctag = BehaviorFunctions.GetNpcType(InstanceId)
			--if npctag and npctag ~= 5 and npctag ~= 8 then
				if BehaviorFunctions.CheckEntityHasComponents(InstanceId, FightEnum.ComponentType.Buff) == true then
					if BehaviorFunctions.HasBuffKind(InstanceId,600000033) then
						BehaviorFunctions.RemoveBuff(InstanceId,600000033)
						BehaviorFunctions.RemoveBuff(InstanceId,600000034)
					end
				end
			--end
		end
	end
end

--重置相机位置：回正时间，保底结束时间
function Behavior610025:ReturnCamera(returnTime,finishTime)
	BehaviorFunctions.SetCameraStateForce(1,false)	--设置回操作相机
	BehaviorFunctions.CameraPosReduction(returnTime,false,finishTime)	--重置相机位置
	BehaviorFunctions.RemoveAllLookAtTarget()
	BehaviorFunctions.AddLookAtTarget(self.ctrlRole,"CameraTarget")
end

--轮盘按钮回调
function Behavior610025:AbilityWheelFreePartnerSkill(instanceId,abilityId,skillId,isQuickOutbound)
	if instanceId == self.me then
		if BehaviorFunctions.CheckAbilityCanUse(abilityId) then
			if BehaviorFunctions.CheckBtnUseSkill(self.ctrlRole,FightEnum.KeyEvent.PartnerSkill,true) then
				if skillId == 610025005 then
					self.abilityId = abilityId
					if self.hideState == 0 then
						BehaviorFunctions.DoMagic(self.me,self.ctrlRole,1000051)	--添加出场特效
						BehaviorFunctions.DoMagic(self.me,self.me,600000011,1)	--添加遁地初始buff
						BehaviorFunctions.AddDelayCallByTime(0.1,self,self.Henshin)	--变身
						--BehaviorFunctions.CloseFightAbilityWheel()	--关闭轮盘
						self:HideButton()	--隐藏按钮	
						BehaviorFunctions.SetCanOpenFightAbilityWheel(false)	--禁止打开轮盘
					--出地
					elseif self.hideState == 1 then
						--if BehaviorFunctions.CheckBtnUseSkill(self.me,skillId) then
							--再次释放提前结束钻地
						BehaviorFunctions.AddEntitySign(self.ctrlRole,600000,-1,false)	--标记仲魔在场
						BehaviorFunctions.DoSetPosition(self.ctrlRole,self.myPos.x,self.myPos.y,self.myPos.z)
						BehaviorFunctions.BreakSkill(self.me)
						--BehaviorFunctions.CastSkillBySelfPosition(self.me,610025012)
						if self.noTarget == 0 then
							BehaviorFunctions.CastSkillByTarget(self.me,610025014,self.battleTarget)
						elseif self.noTarget == 1 then
							BehaviorFunctions.CastSkillBySelfPosition(self.me,610025014)
						end
						BehaviorFunctions.RemoveBuff(self.me,600000017)--移除斜坡状态
						BehaviorFunctions.SetJoyMoveEnable(self.me, true)
	
						--BehaviorFunctions.SetFightMainNodeVisible(1,"R",false)	--起来期间隐藏钻地按钮
						BehaviorFunctions.DisableAllSkillButton(self.ctrlRole,true)
						BehaviorFunctions.SetAbilityCanUse(self.abilityId, false)
					elseif BehaviorFunctions.CheckBtnUseSkill(self.me,skillId) == false and self.hideState == 1 then
						BehaviorFunctions.ShowTip(80000003)
						--end
					end
				end
			end
		else
			--如果是长按
			if isQuickOutbound then
				--BehaviorFunctions.CloseFightAbilityWheel()	--关闭轮盘
			end
			BehaviorFunctions.ShowTip(80000004)
		end
	end
end

--被冰冻时做状态处理
function Behavior610025:AddBuff(entityInstanceId,buffInstanceId,buffId)
	if entityInstanceId == self.me and self.role == 1 then
		if self.hideState == 1 then
			if BehaviorFunctions.CheckBuffKind(entityInstanceId,buffInstanceId,5001) then
				BehaviorFunctions.RemoveBuff(self.me,buffId)
				BehaviorFunctions.RemoveBuff(self.ctrlRole,buffId)
			end
		end
	end
end

--传送时强制恢复状态
function Behavior610025:OnTransport()
	if self.hideState == 1 then
		self:EndHenshin()
		self.hideState = 0
		BehaviorFunctions.RemoveBuff(self.me,610025012)
		BehaviorFunctions.RemoveEntitySign(self.ctrlRole,10000009)
		--BehaviorFunctions.RemoveBuff(self.me,600000032)	--结束视野收窄
		BehaviorFunctions.RemoveBuff(self.me,1000071)
	end
end

--传送时强制恢复状态
function Behavior610025:BeforeTransport()
	if self.hideState == 1 then
		self:EndHenshin()
		self.hideState = 0
		BehaviorFunctions.RemoveBuff(self.me,610025012)
		BehaviorFunctions.RemoveEntitySign(self.ctrlRole,10000009)
		--BehaviorFunctions.RemoveBuff(self.me,600000032)	--结束视野收窄
		BehaviorFunctions.RemoveBuff(self.me,1000071)
	end
end