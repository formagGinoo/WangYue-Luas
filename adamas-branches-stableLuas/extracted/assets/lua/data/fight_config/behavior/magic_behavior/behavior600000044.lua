Behavior600000044 = BaseClass("Behavior600000044",EntityBehaviorBase)
function Behavior600000044.GetGenerates()


end

function Behavior600000044.GetMagics()

end

function Behavior600000044:Init()
	self.me = self.instanceId		--记录自己
	self.executeTarget = 0	--缓存处决目标
	self.executeHp	= 10000	--处决血量阈值
	self.distanceLimit = 20	--处决范围限制
	self.curExecuteBullet = 0	--缓存处决子弹
	self.curHitFlyBullet = 0	--缓存击飞子弹
	self.canPerform = false		--能否释放连携表演
	self.curTarget = 0	--缓存连携目标
end

function Behavior600000044:Update()
	self.role = BehaviorFunctions.GetEntityOwner(self.me)	--记录角色
	self.ctrlRole = BehaviorFunctions.GetCtrlEntity()--	记录当前前台角色
	self.partner = BehaviorFunctions.GetPartnerInstanceId(self.role)
	self.callPos = BehaviorFunctions.GetPositionOffsetBySelf(self.ctrlRole,2.1,270)
	self.callLocate = BehaviorFunctions.GetPositionOffsetBySelf(self.ctrlRole,5,0)	--召唤坐标朝向
	self.distance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.ctrlRole,false)
	self.myPos = BehaviorFunctions.GetPositionP(self.me)
	self.roleState = BehaviorFunctions.GetEntityState(self.ctrlRole)	--获取角色状态

	self.rolePos = BehaviorFunctions.GetPositionP(self.ctrlRole)	--获取角色位置

	self.Yspeed = BehaviorFunctions.GetEntitySpeedY(self.ctrlRole)	--获取Y轴速度
end

--开始连携表演
function Behavior600000044:StartPerform()
	BehaviorFunctions.StopAllCameraOffset()	--停止所有的相机偏移
	BehaviorFunctions.BreakSkill(self.me)	--打断当前正在释放的技能
	BehaviorFunctions.CallCommonBehaviorFunc(self.me, "StopPartnerLeave")	--打断佩从离场流程
	BehaviorFunctions.AddEntitySign(self.ctrlRole,62001015,-1,false)		--标记为正在执行处决
	
	
	
	
	--BehaviorFunctions.DoSetPosition(self.me,self.rolePos.x,self.rolePos.y,self.rolePos.z)	--设置召唤位置
	BehaviorFunctions.DoMagic(self.me,self.me,1000055,1)	--初始buff
	BehaviorFunctions.SetEntityCollisionPriority(self.ctrlRole, 11)	--设置碰撞层级
	BehaviorFunctions.DoMagic(self.me,self.me,600000014,1)	--初始buff
	--BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.callLocate.x,self.callLocate.y,self.callLocate.z,true)
	BehaviorFunctions.ShowPartner(self.role,true)	--召唤佩从
	BehaviorFunctions.CastSkillByTarget(self.me,62004005,self.curTarget)
	BehaviorFunctions.DoMagic(self.me,self.me,600000016)	--浮空
	BehaviorFunctions.DoMagic(self.curTarget,self.me,600000064)	--播放timeline
	BehaviorFunctions.SetTimelineTrackCameraLookAtState(true)
	local rotate,pos = BehaviorFunctions.GetTimelinePos(self.curTarget, 600000064, 1, "Animation Track")	--获取召唤位置
	----
	BehaviorFunctions.DoSetPosition(self.me,pos["Animation Track"].x,pos["Animation Track"].y,pos["Animation Track"].z)	--设置召唤位置
	--BehaviorFunctions.DoLookAtPositionImmediately(self.me,rotate["Animation Track"].x,rotate["Animation Track"].y,rotate["Animation Track"].z,true)	--设置看向
	BehaviorFunctions.SetJoyMoveEnable(self.ctrlRole, false)	--设置摇杆可用
	--BehaviorFunctions.SetFightMainNodeVisible(1,"PanelParent",false,1)--隐藏所有战斗UI
--	BehaviorFunctions.AddDelayCallByFrame(2,self,self.SetMyPos)	--延迟设置位置
end

--连携表演结束
function Behavior600000044:EndPerform()
	BehaviorFunctions.SetJoyMoveEnable(self.ctrlRole, true)	--设置摇杆可用
	BehaviorFunctions.SetFightMainNodeVisible(1,"PanelParent",true,1)--隐藏所有战斗UI
	BehaviorFunctions.SetEntityCollisionPriority(self.ctrlRole,10)
	BehaviorFunctions.DoMagic(self.me,self.me,600000006,1)		--播放退场特效
	BehaviorFunctions.DoMagic(self.me,self.me,600000004,1)		--播放退场氛围特效
	BehaviorFunctions.DoMagic(self.me,self.me,600000016)	--浮空
	BehaviorFunctions.CallCommonBehaviorFunc(self.me, "DoPartnerLeave")		--进入仲魔退场流程
end

--五行就绪装填 / QTE破防回调
--function Behavior600000044:EnterElementStateReady(atkInstanceId, instanceId, element)
	--if BehaviorFunctions.GetEntityTemplateId(self.ctrlRole) == 1001 and not BehaviorFunctions.HasEntitySign(instanceId,92003019) then
		--local targetTag = BehaviorFunctions.GetNpcType(instanceId)
		----如果不是boss和精英
		--if targetTag ~= 3 and targetTag ~= 4 then
			----如果可以被处决
			--if BehaviorFunctions.GetEntityAttrValueRatio(instanceId,1001) <= self.executeHp then
				----如果在处决范围内
				--if BehaviorFunctions.GetDistanceFromTarget(self.ctrlRole,instanceId) < self.distanceLimit then
					----标记为正在判断处决
					--BehaviorFunctions.AddEntitySign(1,600000044,-1,false)
					----缓存被处决目标
					--self.executeTarget = instanceId
					----BehaviorFunctions.AddEntitySign(self.role,600000044,60,false) --添加延时
					--BehaviorFunctions.AddDelayCallByTime(1,self,self.DelayCreateQTE)
				--end
			--end
		--end
	--end
--end





--判断处决子弹碰撞目标
function Behavior600000044:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	if BehaviorFunctions.GetEntityTemplateId(instanceId) == 62004603001 then
		self.curTarget = hitInstanceId
		self.canPerform = true
		--把目标的位置设置到空中
		--BehaviorFunctions.DoPreciseMove(self.curTarget, self.ctrlRole, 0, 20,0 , 1,1)
		BehaviorFunctions.AddDelayCallByFrame(5,self,self.HitFlyTimeScale)	--击飞后给顿帧
	end
	
	if BehaviorFunctions.GetEntityTemplateId(instanceId) == 62004603004 then
		BehaviorFunctions.RemoveBuff(hitInstanceId,600000051)
	end
end


function Behavior600000044:AddSkillSign(instanceId,sign)
	if instanceId == self.me or instanceId == self.ctrlRole then
		--结束表演
		if sign == 62004005 then
			self:EndPerform()
		end
		
		--进入连携窗口
		if sign == 62004006 then
			if self.canPerform then
				BehaviorFunctions.AddDelayCallByFrame(2,self,self.StartPerform)
				self.canPerform = false
				self:HitFlyTimeScale()
				--BehaviorFunctions.AddDelayCallByFrame(12,self,self.HitFlyTimeScale)	--击飞后给顿帧
			end
		end
	end
end

--击飞到空中顿帧
function Behavior600000044:HitFlyTimeScale()
	--如果被暗杀目标存在
	if self.curTarget then
		--0.1时间缩放
		--BehaviorFunctions.DoMagic(self.me,self.curTarget,600000045,1)
		BehaviorFunctions.DoPreciseMove(self.curTarget, self.ctrlRole, 0, 9.8,3 , 1,1)
	end
end

--function Behavior600000044:SetMyPos()
	--local rotate,pos = BehaviorFunctions.GetTimelinePos(self.me, 600000064, 6, "Animation Track")	--获取召唤位置
	----BehaviorFunctions.GetPositionP(self.me)
	--BehaviorFunctions.DoPreciseMoveToPosition(self.me, pos["Animation Track"].x,pos["Animation Track"].y,pos["Animation Track"].z, 5)
--end