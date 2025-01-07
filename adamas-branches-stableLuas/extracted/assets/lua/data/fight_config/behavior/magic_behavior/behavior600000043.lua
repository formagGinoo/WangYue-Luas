Behavior600000043 = BaseClass("Behavior600000043",EntityBehaviorBase)
function Behavior600000043.GetGenerates()


end

function Behavior600000043.GetMagics()

end

function Behavior600000043:Init()
	self.me = self.instanceId		--记录自己
	self.executeTarget = 0	--缓存处决目标
	self.executeHp	= 10000	--处决血量阈值
	self.distanceLimit = 20	--处决范围限制
	self.curExecuteBullet = 0	--缓存处决子弹
	self.curHitFlyBullet = 0	--缓存击飞子弹
	self.chain = 0
end

function Behavior600000043:Update()
	self.role = BehaviorFunctions.GetEntityOwner(self.me)	--记录角色
	self.ctrlRole = BehaviorFunctions.GetCtrlEntity()--	记录当前前台角色
	self.partner = BehaviorFunctions.GetPartnerInstanceId(self.role)
	self.callPos = BehaviorFunctions.GetPositionOffsetBySelf(self.ctrlRole,2.1,270)
	self.callLocate = BehaviorFunctions.GetPositionOffsetBySelf(self.ctrlRole,5,0)	--召唤坐标朝向
	self.distance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.ctrlRole,false)
	self.myPos = BehaviorFunctions.GetPositionP(self.me)
	self.roleState = BehaviorFunctions.GetEntityState(self.ctrlRole)
	
	self.rolePos = BehaviorFunctions.GetPositionP(self.ctrlRole)

	self.Yspeed = BehaviorFunctions.GetEntitySpeedY(self.ctrlRole)
	self.diyuePart = BehaviorFunctions.GetEntityValue(self.ctrlRole,"diyuePart")
	--self.chain = BehaviorFunctions.GetEntityValue(self.role,"chain")
	--BehaviorFunctions.SetEntityValue(self.role,"chain",self.chain)	--开放锁链给角色
	self.chainSave = false	--默认继承锁链
end

--开始空中处决
function Behavior600000043:StartExecute()
	--移除锁链
	--if self.chain and self.chain ~= 0 then
		--if BehaviorFunctions.CheckEntity(self.chain) then
			--BehaviorFunctions.RemoveEntity(self.chain)
		--end
	--end
	--BehaviorFunctions.RemoveEntitySign(1,10000002)	--移除QTE标记
	BehaviorFunctions.StopAllCameraOffset()
	--BehaviorFunctions.RemoveBuff(self.ctrlRole,1000011)
	BehaviorFunctions.RemoveEntitySign(1,600000043)
	BehaviorFunctions.BreakSkill(self.me)	--打断当前正在释放的技能
	BehaviorFunctions.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")	--打断佩从离场流程
	BehaviorFunctions.AddEntitySign(self.ctrlRole,62001015,-1,false)		--标记为正在执行处决
	BehaviorFunctions.DoSetPosition(self.me,self.rolePos.x,self.rolePos.y,self.rolePos.z)	--设置召唤位置
	BehaviorFunctions.DoMagic(self.me,self.me,1000055,1)	--初始buff
	BehaviorFunctions.SetEntityCollisionPriority(self.ctrlRole, 11)
	BehaviorFunctions.DoMagic(self.me,self.me,600000014,1)	--初始buff
	--self.callLocate.x = self.callLocate.x - 2.1
	BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.callLocate.x,self.callLocate.y,self.callLocate.z,true)
	--BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.executeTarget,"",false)	--朝向目标
	self.chain = BehaviorFunctions.CreateEntity(600000011,nil,self.callPos.x,self.callPos.y,self.callPos.z)--创建缔约特效
	BehaviorFunctions.ClientEffectRelation(self.chain, self.ctrlRole, "Bip001 R Hand", self.me, "Bip001 R Hand", 0)--设置缔约特效
	--BehaviorFunctions.SetEntityValue(self.role,"chain",self.chain)	--开放锁链给角色
	BehaviorFunctions.DoMagic(self.me,self.ctrlRole,600000047,1)	--角色缔约开始特效
	BehaviorFunctions.AddBuff(self.me,self.ctrlRole,600000050,1)--角色缔约状态
	--BehaviorFunctions.DoMagic(self.me,self.role,600000050,1)
	BehaviorFunctions.DoMagic(self.me,self.me,600000049,1)	--怪物缔约状态
	--BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.executeTarget,"",false)	--朝向目标
	local pos = BehaviorFunctions.GetPositionP(self.me)
	BehaviorFunctions.RemoveBuff(self.ctrlRole,1000010)	--克制条满顿帧
	BehaviorFunctions.RemoveBuff(self.ctrlRole,1000029)
	BehaviorFunctions.ShowPartner(self.role,true)	--召唤佩从
	BehaviorFunctions.CastSkillByTarget(self.ctrlRole,1001105,self.executeTarget)	--角色释放处决技能
	--BehaviorFunctions.CastSkillByTarget(self.me,62001015,self.executeTarget)	--离歌释放处决技能
	BehaviorFunctions.DoMagic(self.me,self.me,600000042,1)	--timeline
	BehaviorFunctions.SetJoyMoveEnable(self.ctrlRole, false)	--设置摇杆可用
	BehaviorFunctions.SetFightMainNodeVisible(1,"PanelParent",false,1)--隐藏所有战斗UI
end

--处决结束
function Behavior600000043:ExecuteEnd()
	BehaviorFunctions.SetJoyMoveEnable(self.ctrlRole, true)	--设置摇杆可用
	BehaviorFunctions.SetFightMainNodeVisible(1,"PanelParent",true,1)--隐藏所有战斗UI
	BehaviorFunctions.SetEntityCollisionPriority(self.ctrlRole,10)
	--移除锁链
	if self.chain and self.chain ~= 0 then
		if BehaviorFunctions.CheckEntity(self.chain) then
			BehaviorFunctions.RemoveEntity(self.chain)
		end
	end
	BehaviorFunctions.DoMagic(self.me,self.me,600000006,1)		--播放退场特效
	BehaviorFunctions.DoMagic(self.me,self.me,600000004,1)		--播放退场氛围特效
	BehaviorFunctions.DoMagic(self.me,self.ctrlRole,600000048,1)	--播放缔约结束特效
	BehaviorFunctions.RemoveBuff(self.ctrlRole,600000050)	--移除角色被缔约特效
	BehaviorFunctions.RemoveBuff(self.me,600000049)	--移除自己被缔约特效
	BehaviorFunctions.CallCommonBehaviorFunc(self.me, "DoPartnerLeave")		--进入仲魔退场流程
end

--五行就绪装填 / QTE破防回调
function Behavior600000043:EnterElementStateReady(atkInstanceId, instanceId, element)
	if BehaviorFunctions.GetEntityTemplateId(self.ctrlRole) == 1001 and not BehaviorFunctions.HasEntitySign(instanceId,92003019) then
		local targetTag = BehaviorFunctions.GetNpcType(instanceId)
		--如果不是boss和精英
		if targetTag ~= 3 and targetTag ~= 4 then
			--如果可以被处决
			if BehaviorFunctions.GetEntityAttrValueRatio(instanceId,1001) <= self.executeHp then
				--如果在处决范围内
				if BehaviorFunctions.GetDistanceFromTarget(self.ctrlRole,instanceId) < self.distanceLimit then
					--标记为正在判断处决
					BehaviorFunctions.AddEntitySign(1,600000043,-1,false)
					--缓存被处决目标
					self.executeTarget = instanceId
					--BehaviorFunctions.AddEntitySign(self.role,600000043,60,false) --添加延时
					BehaviorFunctions.AddDelayCallByTime(1,self,self.DelayCreateQTE)
				end
			end
		end
	end
end



--QTE结果检测
function Behavior600000043:ExitQTE(qteType, returnValue, qteId)
	if qteId == self.executeQte and BehaviorFunctions.CheckEntity(self.executeTarget) then
		BehaviorFunctions.RemoveEntitySign(1,10000002)
		BehaviorFunctions.RemoveBuff(self.executeTarget,600000060)
		BehaviorFunctions.RemoveBuff(self.executeTarget,600000061)
		if returnValue == true then
		--开始处决
		self:StartExecute()
		else
			self.executeTarget = nil  
		end
	end
end


--判断处决子弹碰撞目标
function Behavior600000043:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	--如果当前正在执行处决
	if hitInstanceId == self.executeTarget and BehaviorFunctions.HasEntitySign(self.ctrlRole,62001015) then
		if instanceId == self.curHitFlyBullet then
			BehaviorFunctions.RemoveBuff(self.executeTarget,1000041)
			--把目标的位置设置到空中
			BehaviorFunctions.DoPreciseMove(self.executeTarget, self.ctrlRole, -0.2, 1.6, 2.4, 4)
			BehaviorFunctions.AddDelayCallByFrame(12,self,self.HitFlyTimeScale)	--击飞后给顿帧
		end
	end
	
	
end


--帧事件实体
function Behavior600000043:KeyFrameAddEntity(instanceId,entityId)
	--创建的子弹是处决子弹
	if entityId == 1001015002 then
		--设置处决子弹仅对处决目标生效
		BehaviorFunctions.SetAttackCheckList(instanceId, {self.executeTarget})
		self.curExecuteBullet = instanceId
	end
	
	--击飞子弹
	if entityId == 1001015001 then
		--设置处决子弹仅对处决目标生效
		BehaviorFunctions.SetAttackCheckList(instanceId, {self.executeTarget})
		self.curHitFlyBullet = instanceId
	end
end


function Behavior600000043:AddSkillSign(instanceId,sign)
	if instanceId == self.me or instanceId == self.ctrlRole then
		--结束处决窗口
		if sign == 600000043 then
			BehaviorFunctions.RemoveEntitySign(self.me,62001015)	--移除处决标记
			self:ExecuteEnd()
		end
	end
end

--击飞到空中顿帧
function Behavior600000043:HitFlyTimeScale()
	--如果被暗杀目标存在
	if self.executeTarget then
		--0.1时间缩放
		BehaviorFunctions.DoMagic(self.me,self.executeTarget,600000045,1)
	end
end


--切人缓存锁链
function Behavior600000043:OnSwitchPlayerCtrl(oldInstanceId, instanceId)
		--BehaviorFunctions.SetEntityValue(self.PartnerAllParm.role,"chain",self.chain)	--切人时缓存锁链
		--BehaviorFunctions.AddEntitySign(self.role,"chain",-1,false)

	--继承连携用
	if self.chainSave then
		if self.chain and self.chain ~= 0 and self.me then
			if BehaviorFunctions.CheckEntity(self.chain) then
				BehaviorFunctions.DoMagic(instanceId,instanceId,600000050,1)	--给角色上缔约状态
				BehaviorFunctions.ClientEffectRelation(self.chain, instanceId, "Bip001 R Hand", self.me, self.diyuePart, 0)--设置缔约特效继承
			end
		end
	else
		if self.chain and self.chain ~= 0 then
			if BehaviorFunctions.CheckEntity(self.chain) then
				BehaviorFunctions.RemoveEntity(self.chain)
			end
		end
	end
end


--延迟创建QTE
function Behavior600000043:DelayCreateQTE()
	if BehaviorFunctions.CheckEntity(self.executeTarget) then
		BehaviorFunctions.DoMagic(1,self.executeTarget,600000060)	--全局怪物时停
		BehaviorFunctions.DoMagic(1,self.executeTarget,600000061)	--自己免疫时停
		--创建一个处决QTE
		self.executeQte = BehaviorFunctions.DoShowClickQTE(self.ctrlRole, "","", true, false, 4,-250, 170, 2, 1)
	end
end
--function Behavior600000043:ChangeBackground(instanceId)
--if instanceId == self.role and BehaviorFunctions.HasEntitySign(self.role,62001003) then
--BehaviorFunctions.RemoveBuff(self.me,1000046)
--BehaviorFunctions.HideAssassinLifeBarTip(self.role, self.me)
--BehaviorFunctions.RemoveBuff(self.me,900000053)
--end
--end

--function Behavior600000043:AddSkillSign(instanceId,sign)
	--if instanceId == self.partner then
		--if sign == 62001062 then
			
		--end
	--end
--end