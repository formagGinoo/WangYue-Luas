Behavior6000006 = BaseClass("Behavior6000006",EntityBehaviorBase)

local BF = BehaviorFunctions

function Behavior6000006.GetGenerates()
end

function Behavior6000006.GetMagics()
end

function Behavior6000006:Init()
	self.me = self.instanceId --记录自己
	self.Probability = 10000 --此buff的触发几率
	self.cd = 3--frames
	self.nextFrame = 0
	self.protectFrame = 0	--保护表演时间
	self.inShow = 0		--仲魔是否正在保护表演
	self.hitedFrame = 0		--角色受击表演时间
end

function Behavior6000006:Update()
	self.time = BF.GetFightFrame()	--记录时间
	self.partner = BF.GetPartnerInstanceId(self.me)	--记录仲魔

	self.partnerPos = BehaviorFunctions.GetPositionOffsetBySelf(self.partner,0,0)	--角色位置
	self.partnerFrontPos = BehaviorFunctions.GetPositionOffsetBySelf(self.partner,10,0) --角色前方的位置

	self.myPos = BehaviorFunctions.GetPositionP(self.me)	--仲魔位置
	self.myFrontPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,10,0)	--仲魔前方的位置

	--仲魔保护表演逻辑
	if self.protectFrame < self.time and BF.CheckPartnerShow(self.me) and self.inShow == 1 then
		self.inShow = 2
		BF.DoSetPosition(self.me,self.partnerPos.x,self.partnerPos.y,self.partnerPos.z)--设置坐标
		BF.DoLookAtPositionImmediately(self.me,self.partnerFrontPos.x,self.partnerFrontPos.y,self.partnerFrontPos.z)--设置朝向
		BF.ShowPartner(self.me,false)			--隐藏仲魔
		BF.RemoveBuff(self.me,600000001)		--移除角色模型隐藏
		BF.AddBuff(self.me,self.me,6000009)		--播放特效
		BF.PlayAnimation(self.me,"RightSlightHit",17)		--从第17帧开始播放受击动作
		self.hitedFrame = self.time + 10
	end

	if self.hitedFrame < self.time and self.inShow == 2 then
		self.inShow = false		--状态设置为结束表演
		BF.DisableAllSkillButton(self.me,false)	--恢复按钮
		BF.SetJoyMoveEnable(self.me, true)	--恢复摇杆
	end
end


--致命伤判断与触发逻辑
function Behavior6000006:BeforeDie(instanceId)
	if instanceId == self.me and BF.Probability(self.Probability) and BF.GetFightFrame() > self.nextFrame then
		self.nextFrame = BF.GetFightFrame() + self.cd
		--成功触发buff

		--治疗15%血量
		BF.DoMagic(self.me,self.me,6000007,1)
		
		--在此处写仲魔表现逻辑
		self:ShowPartnerProtect()


		--刚复活后暂时无敌
		BF.AddBuff(self.me,self.me,6000008,1)
	end
end

--测试表现逻辑
--function Behavior6000006:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType)
--if hitInstanceId == self.me then
--self:ShowPartnerProtect()
--end
--end

--仲魔显示逻辑
function Behavior6000006:ShowPartnerProtect()
	BF.DoMagic(self.me,self.me,600000001)	--隐藏角色模型
	BF.DoSetPosition(self.partner,self.myPos.x,self.myPos.y,self.myPos.z)--设置坐标
	BF.DoLookAtPositionImmediately(self.partner,self.myFrontPos.x,self.myFrontPos.y,self.myFrontPos.z)--设置朝向
	BF.ShowPartner(self.me,true)	--显示仲魔
	BF.DoMagic(self.partner,self.partner,1000055)	--移除仲魔碰撞
	BF.DoMagic(self.partner,self.partner,6000010)	--仲魔特效
	BF.PlayAnimation(self.partner,"RightSlightHit")		--播放受击动作
	self.protectFrame = self.time + 16		--播放动作计时
	self.inShow = 1		--设置状态为正在表演
	BF.DoSetEntityState(self.me,FightEnum.EntityState.Idle)
	BF.DisableAllSkillButton(self.me,true)	--禁用按钮
	BF.CancelJoystick()	--取消摇杆输入
	BF.SetJoyMoveEnable(self.me, false)	--禁用摇杆
end