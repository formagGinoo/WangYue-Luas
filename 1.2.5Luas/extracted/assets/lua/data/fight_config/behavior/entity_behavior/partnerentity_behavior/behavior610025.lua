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
	self.role = 0
	self.mission = 0
	self.time = 0
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

	self.noTarget = 0
	--缓存技能按钮
	self.curSkillId = 0

	--钻地状态定义
	self.hideState = 0

	--技能id记录
	self.worldSkill = 610025011	--脱战技能
	self.fightSkill = 610025002	--战中技能

	self.hideFrame = 0
	self.hideSkillCd = 1200
	self.hideTime = 999999

	self.hideAtkDistance = 0
	self.checkFrame = 0
	self.downState = 0
	self.cameraTran = false
	self.cameraFrame = 0
end



function Behavior610025:Update()

	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetEntityOwner(self.me)
	--获取实体参数
	self:GetTarget()
	self.myPos = BehaviorFunctions.GetPositionP(self.me)
	self.rolePos = BehaviorFunctions.GetPositionP(self.role)
	self.fightState = 0
	self.distance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.role,false)
	BehaviorFunctions.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
	

	self.fightSkillPos = BehaviorFunctions.GetPositionOffsetBySelf(self.role,2,280)	--战中技能释放位置
	self.worldSkillPos = BehaviorFunctions.GetPositionOffsetBySelf(self.role,0,0)	--战前技能释放位置
	self.MyFrontPos = BehaviorFunctions.GetPositionOffsetBySelf(self.role,10,0) --角色前方的位置

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
	if self.hideState == 0 and self.curSkillId ~= self.worldSkill then
		self.curSkillId = self.worldSkill
		--BehaviorFunctions.RelevanceEntitySkill(self.me, self.me, FightEnum.KeyEvent.NormalSkill, self.curSkillId)
		BehaviorFunctions.ChangePartnerSkill(self.role, self.curSkillId)
	elseif self.hideState == 1 and self.curSkillId ~= 610025014 then
		self.curSkillId = 610025014
		
		BehaviorFunctions.SetFightUISkillBtnId(self.me,FightEnum.KeyEvent.Partner,self.curSkillId)
		BehaviorFunctions.ChangeFightBtn(self.role, self.me)
		--BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , true)
		--BehaviorFunctions.RelevancewEntitySkill(self.me, self.me, FightEnum.KeyEvent.NormalSkill, self.curSkillId)
	end

	--根据高度开关按钮
	if self.hideState == 0 then
		local hight,layer=BehaviorFunctions.CheckPosHeight(self.rolePos)
		if BehaviorFunctions.CheckEntityHeight(self.role) == 0 and layer ~= FightEnum.Layer.Water then
			BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
		else
			BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , true)
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
		BehaviorFunctions.DoSetPosition(self.role,self.myPos.x,self.myPos.y,self.myPos.z)
	end


	--按下仲魔按钮
	if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Partner) and BehaviorFunctions.GetCtrlEntity() == self.role then

		if BehaviorFunctions.CheckBtnUseSkill(self.me,self.curSkillId) then
			BehaviorFunctions.DoMagic(self.me,self.me,600000011,1)
			if self.hideState == 0 and BehaviorFunctions.CheckEntityHeight(self.role) == 0 then

				--再次释放提前结束钻地
			elseif self.hideState == 1 then
				BehaviorFunctions.AddEntitySign(self.role,600000,-1,false)	--标记仲魔在场
				BehaviorFunctions.DoSetPosition(self.role,self.myPos.x,self.myPos.y,self.myPos.z)
				BehaviorFunctions.BreakSkill(self.me)
				--BehaviorFunctions.CastSkillBySelfPosition(self.me,610025012)
				if self.noTarget == 0 then
					BehaviorFunctions.CastSkillByTarget(self.me,610025014,self.battleTarget)
				elseif self.noTarget == 1 then
					BehaviorFunctions.CastSkillBySelfPosition(self.me,610025014)
				end
				--self.hideState = 0
				BehaviorFunctions.RemoveBuff(self.me,600000017)--移除斜坡状态
				BehaviorFunctions.SetJoyMoveEnable(self.me, true)
				
				--BehaviorFunctions.SetFightMainNodeVisible(1,"R",false)	--起来期间隐藏钻地按钮
				BehaviorFunctions.DisableAllSkillButton(self.me,true)
				BehaviorFunctions.CastSkillCost(self.me,self.worldSkill)
			end
		elseif BehaviorFunctions.CheckBtnUseSkill(self.me,self.curSkillId) == false and self.hideState == 1 then
			BehaviorFunctions.ShowTip(80000003)
		end
	end

	--仲魔冲刺逻辑
	if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Dodge) and BehaviorFunctions.GetCtrlEntity() == self.role then
		if BehaviorFunctions.CheckBtnUseSkill(self.me,610025003) then
			BehaviorFunctions.CastSkillBySelfPosition(self.me,610025003)
			BehaviorFunctions.CastSkillCost(self.me,610025003)
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
			if BehaviorFunctions.DoCollideCheckAtPosition(self.myPos.x, self.myPos.y + 2.5, self.myPos.z, 3, 3, 0.001, {self.me,self.role}) == true then
				BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , true)
				BehaviorFunctions.SetCameraVerticalRange(7,7)
				BehaviorFunctions.SetBodyDamping(2,2,2)
				BehaviorFunctions.SetCameraFollow(self.me,"BurrowCamera")
				self.downState = 1
			else
				BehaviorFunctions.SetCameraVerticalRange(-180,180)
				BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
				BehaviorFunctions.SetCameraColliderDamping(5)
				BehaviorFunctions.SetCameraFollow(self.me)
				self.cameraTran = true
				self.downState = 0
			end
			self.checkFrame = self.time + 5
		end
	elseif self.hideState == 0 then
		BehaviorFunctions.RemoveBuff(self.me,610025010)
		BehaviorFunctions.RemoveBuff(self.me,610025011)
	end
	
	--镜头过度设置
	if self.cameraTran == true then
		BehaviorFunctions.SetCameraColliderDamping(0)
		BehaviorFunctions.SetBodyDamping(1,1,1)
		self.cameraFrame = self.time + 3*30
	end
	
	if self.cameraFrame < self.time then
		self.cameraTran = false
		BehaviorFunctions.SetCameraColliderDamping(5)
	end
end

--技能连击检测
function Behavior610025:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	if attackInstanceId == self.me and BehaviorFunctions.GetEntityTemplateId(instanceId) == 610025002001 then
		BehaviorFunctions.AddSkillEventActiveSign(self.role,1001999)
		BehaviorFunctions.AddBuff(self.me,self.role,610025005,1)	--让角色受到我的顿帧影响
	end
end

--被打出地面
function Behavior610025:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType)
	if hitInstanceId == self.role then
		if self.hideState == 1 and self.downState == 0 then
			BehaviorFunctions.CastSkillBySelfPosition(self.me,610025001)
			BehaviorFunctions.DoMagic(self.role,self.role,600000003)
			--BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , true)
			BehaviorFunctions.DisableAllSkillButton(self.me,true)
			BehaviorFunctions.RemoveBuff(self.me,600000017)--移除斜坡状态
			BehaviorFunctions.RemoveEntitySign(self.role,10000009)
			BehaviorFunctions.DoMagic(self.me,self.role,1000048,1)
			self.hideState = 0
		end
	end
end



function Behavior610025:AddSkillSign(instanceId,sign)
	if instanceId == self.me or instanceId == self.role then
		--钻地结束回调
		if sign == 610025012 then
			self:EndHenshin()
		end
	
		--仲魔主动退场回调
		if sign == 610025002 then
			BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.ShowPartner,self.role, false)
			BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
			BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.RemoveEntitySign,self.role,600000)--移除仲魔在场标记
		end
	
		--仲魔变身
		if sign == 10600001 and instanceId == self.role then
			BehaviorFunctions.AddDelayCallByTime(0.1,self,self.Henshin)
			self:HideButton()	--隐藏按钮
		end
	
		--释放按钮
		if sign == 610025011 then
			BehaviorFunctions.DoMagic(self.me,self.me,1000071)
		end
	
		--出地过程
		if sign == 610025013 then
			self.hideState = 0
			BehaviorFunctions.RemoveBuff(self.me,1000071)
			--BehaviorFunctions.RemoveBuff(self.me,610025010)
			--BehaviorFunctions.RemoveBuff(self.me,610025011)
		--	BehaviorFunctions.DisableAllSkillButton(self.me,true)
			--BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , true)
			BehaviorFunctions.RemoveBuff(self.me,610025012)
			BehaviorFunctions.RemoveEntitySign(self.role,10000009)
		end
	
		--入土出土禁用按钮
		if sign == 610025777 then
			BehaviorFunctions.DisableAllSkillButton(self.me,true)
		end
		
		--入土
		if sign == 610025010 then
			BehaviorFunctions.RemoveBuff(self.me,1000055)--去掉移除碰撞
			BehaviorFunctions.DoMagic(self.me,self.me,600000017,1)--添加斜坡旋转buff
			BehaviorFunctions.DisableAllSkillButton(self.me,false)
		end
	
		--被打起身
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
	BehaviorFunctions.SetFightMainNodeVisible(1,"J",false)	--普攻
	BehaviorFunctions.SetFightMainNodeVisible(1,"O",false)	--跳跃
	--BehaviorFunctions.SetFightMainNodeVisible(1,"K",false)	--疾跑
	--BehaviorFunctions.SetFightMainNodeVisible(1,"R",false)	--仲魔
	BehaviorFunctions.SetFightMainNodeVisible(1,"Core",false)	--核心被动条
	BehaviorFunctions.SetFightMainNodeVisible(1,"PowerGroup",false,1)--隐藏能量条

end

function Behavior610025:ShowButton()
	BehaviorFunctions.SetFightMainNodeVisible(1,"I",true)	--技能
	BehaviorFunctions.SetFightMainNodeVisible(1,"J",true)	--普攻
	BehaviorFunctions.SetFightMainNodeVisible(1,"O",true)	--跳跃
	BehaviorFunctions.SetFightMainNodeVisible(1,"K",true)	--疾跑
	BehaviorFunctions.SetFightMainNodeVisible(1,"R",true)	--仲魔
	BehaviorFunctions.SetFightMainNodeVisible(1,"Core",true)	--核心被动条
	BehaviorFunctions.SetFightMainNodeVisible(1,"PowerGroup",true,1)--隐藏能量条
end

--获取战斗技能目标
function Behavior610025:GetTarget()

	self.LockTarget = BehaviorFunctions.GetEntityValue(self.role,"LockTarget")
	self.LockTargetPoint = BehaviorFunctions.GetEntityValue(self.role,"LockTargetPoint")
	self.LockTargetPart = BehaviorFunctions.GetEntityValue(self.role,"LockTargetPart")

	self.AttackTarget = BehaviorFunctions.GetEntityValue(self.role,"AttackTarget")
	self.AttackTargetPoint = BehaviorFunctions.GetEntityValue(self.role,"AttackTargetPoint")
	self.AttackTargetPart = BehaviorFunctions.GetEntityValue(self.role,"AttackTargetPart")

	self.LockAltnTarget = BehaviorFunctions.GetEntityValue(self.role,"LockAltnTarget")
	self.LockAltnTargetPoint = BehaviorFunctions.GetEntityValue(self.role,"LockAltnTargetPoint")
	self.LockAltnTargetPart = BehaviorFunctions.GetEntityValue(self.role,"LockAltnTargetPart")

	self.AttackAltnTarget = BehaviorFunctions.GetEntityValue(self.role,"AttackAltnTarget")
	self.AttackAltnTargetPoint = BehaviorFunctions.GetEntityValue(self.role,"AttackAltnTargetPoint")
	self.AttackAltnTargetPart = BehaviorFunctions.GetEntityValue(self.role,"AttackAltnTargetPart")

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
	BehaviorFunctions.AddEntitySign(self.role,600000,-1,false)	--标记仲魔在场
	BehaviorFunctions.SetJoyMoveEnable(self.role, false)
	--BehaviorFunctions.SetMainTarget(self.me)
	--BehaviorFunctions.AddBuff(self.role,self.role,1000048)

	--BehaviorFunctions.ChangeFightBtn(self.role,self.me)
	
	--BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.SetFightMainNodeVisible,1,"R",true)	--仲魔
	BehaviorFunctions.SetCoreUIEnable(self.role, false)--屏蔽核心能量条
	self.hideState = 1	--钻地状态设置
	self.hideFrame = self.time + self.hideTime --设置钻地时间

	--添加潜行标记
	BehaviorFunctions.AddEntitySign(self.role,10000009,-1,false)--屏蔽角色按键输入
	BehaviorFunctions.AddEntitySign(self.me,610025,-1,false)
	BehaviorFunctions.AddEntitySign(self.role,610025,-1,false)
	BehaviorFunctions.DoSetPosition(self.me,self.worldSkillPos.x,self.worldSkillPos.y,self.worldSkillPos.z)--设置坐标
	BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.MyFrontPos.x,self.MyFrontPos.y,self.MyFrontPos.z)--设置朝向
	BehaviorFunctions.ShowPartner(self.role, true)
	BehaviorFunctions.CastSkillBySelfPosition(self.me,610025005)
	BehaviorFunctions.ChangeCollideHeight(self.me,0.4)
	BehaviorFunctions.DoMagic(self.me,self.me,1000055)--移除碰撞
	BehaviorFunctions.SetMainTarget(self.me)
	BehaviorFunctions.DoMagic(self.me,self.me,1000053)
	BehaviorFunctions.CastSkillCost(self.me,610025005)
	BehaviorFunctions.SetExtraMoveCheckDistance(self.me, 1.7, 1.5)
	--BehaviorFunctions.ChangeCollideRadius(self.me,1.7)
end

function Behavior610025:EndHenshin()
	BehaviorFunctions.RemoveBuff(self.role,1000048)
	BehaviorFunctions.AddDelayCallByTime(0.2,BehaviorFunctions,BehaviorFunctions.SetMainTarget,self.role)
	BehaviorFunctions.DoSetPosition(self.role,self.myPos.x,self.myPos.y+0.2,self.myPos.z)
	BehaviorFunctions.AddDelayCallByTime(1.1,BehaviorFunctions,BehaviorFunctions.ShowPartner,self.role,false)
	BehaviorFunctions.AddDelayCallByTime(1.1,BehaviorFunctions,BehaviorFunctions.DisableAllSkillButton,self.me,false)
	BehaviorFunctions.AddDelayCallByTime(1.1,BehaviorFunctions,BehaviorFunctions.RemoveEntitySign,self.role,600000)--移除仲魔在场标记
	BehaviorFunctions.DoMagic(self.me,self.me,1000052)
	BehaviorFunctions.DoMagic(self.role,self.role,1000054)
	BehaviorFunctions.DoMagic(self.me,self.me,1000055)--移除碰撞
	BehaviorFunctions.SetJoyMoveEnable(self.role, true)--恢复控制
	BehaviorFunctions.RemoveEntitySign(self.role,610025)--移除潜地标记
	BehaviorFunctions.RemoveEntitySign(self.me,610025)--移除潜地标记
	BehaviorFunctions.SetCoreUIEnable(self.role, true)--显示核心能量条
	BehaviorFunctions.ChangeCollideHeight(self.me,2.8)
	--BehaviorFunctions.ChangeFightBtn(self.role,self.role)
	--BehaviorFunctions.ChangeCollideRadius(self.me,0.5)
	self:ShowButton()
end

--传送时强制恢复状态
function Behavior610025:OnTransport()
	BehaviorFunctions.RemoveBuff(self.role,1000048)
	BehaviorFunctions.SetMainTarget(self.role)
	BehaviorFunctions.ShowPartner(self.role,false)
	BehaviorFunctions.DisableAllSkillButton(self.me,false)
	BehaviorFunctions.RemoveEntitySign(self.role,600000)
	BehaviorFunctions.DoMagic(self.me,self.me,1000055)--移除碰撞
	BehaviorFunctions.SetJoyMoveEnable(self.role, true)--恢复控制
	BehaviorFunctions.RemoveEntitySign(self.role,610025)--移除潜地标记
	BehaviorFunctions.RemoveEntitySign(self.me,610025)--移除潜地标记
	BehaviorFunctions.SetCoreUIEnable(self.role, true)--显示核心能量条
	BehaviorFunctions.ChangeCollideHeight(self.me,2.8)
	self.hideState = 0
	self:ShowButton()
	BehaviorFunctions.RemoveBuff(self.me,1000071)
	--BehaviorFunctions.ChangeCollideRadius(self.me,1.7)
end

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