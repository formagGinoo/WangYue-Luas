Behavior62001 = BaseClass("Behavior62001",EntityBehaviorBase)
--资源预加载
function Behavior62001.GetGenerates()
	local generates = {}
	return generates
end

function Behavior62001.GetMagics()
	local generates = {62001011,1000053,1000052,1000051,1000062,1000063,62001012}
	return generates
end



function Behavior62001:Init()
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

	self.assingTarget = 0
	self.noTarget = 0
	--缓存技能按钮
	self.curSkillId = 0
	self.curAssTarget = 0
	self.curBtnState = 0
	
	--暗杀相关
	self.assTarget = 0	--暗杀目标
	self.targetAssLimit = 0	--目标被暗杀限制
	self.assingTarget = 0	--暗杀中目标锁定
	self.setPartnerBtn = 0 --按钮设置状态
	self.assNewTarget = 0	--暗杀目标缓存
	self.AllTargetList = {}	--可暗杀目标列表
	self.assTargetState = 0
	self.assEndState = 0	--是否处于暗杀结束流程
	self.assEndFrame = 90	--暗杀结束的时间
	self.assProtectFrame = 0	--暗杀保护计时
	
	--暗杀成长
	self.assDistance = 15 --最终暗杀距离
	self.baseAssDistance = 13--基础距离
	self.growAssDistance = 0.5 --每级增加的系数
	self.highAssDis = 20
	self.jumpAssDis = 10
end



function Behavior62001:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetEntityOwner(self.me)
	self.myEntityId = 62001
	self.roleState = BehaviorFunctions.GetEntityState(self.role)
	self.rolePos = BehaviorFunctions.GetPositionP(self.role)
	--判断仲魔的角色是否处于前台
	if self.role == BehaviorFunctions.GetCtrlEntity() then
		BehaviorFunctions.AddEntitySign(self.role,62001003,-1,false)
	
		--仲魔等级成长
		self:PartnerGrow()
		
		--获取战斗目标
		self:GetTarget()
	
		self.fightSkillPos = BehaviorFunctions.GetPositionOffsetBySelf(self.role,3,300)	--战中技能释放位置
		self.worldSkillPos = BehaviorFunctions.GetPositionOffsetBySelf(self.role,0,0)	--战前技能释放位置
		self.MyFrontPos = BehaviorFunctions.GetPositionOffsetBySelf(self.role,10,0) --角色前方的位置
		self.partnerFrontPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,10,0) --仲魔前方的位置
		
		BehaviorFunctions.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
		
		--如果不处于暗杀过程中，执行暗杀搜索
		if not BehaviorFunctions.HasEntitySign(self.role,62001001) then
			self:AssassinTarget()
		end
		
		--仲魔暗杀临时传距离
		BehaviorFunctions.SetEntityValue(self.role,"assDistance",self.assDistance)
		BehaviorFunctions.SetEntityValue(self.role,"highAssDis",self.highAssDis)
		BehaviorFunctions.SetEntityValue(self.role,"jumpAssDis",self.jumpAssDis)
		
		--更新仲魔按钮状态
		if BehaviorFunctions.CheckPlayerInFight() and self.curSkillId ~= 62001017 then
			self.curSkillId = 62001017
			BehaviorFunctions.ChangePartnerSkill(self.role, 62001017)
			BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
		elseif not BehaviorFunctions.CheckPlayerInFight() and BehaviorFunctions.CheckEntityHeight(self.me) == 0 and self.curSkillId ~= 62001001 then
			self.curSkillId = 62001001
			BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
			BehaviorFunctions.ChangePartnerSkill(self.role, 62001001)
		elseif not BehaviorFunctions.CheckPlayerInFight() and BehaviorFunctions.CheckEntityHeight(self.me) > 0 and self.curSkillId ~= 62001007 then
			self.curSkillId = 62001007
			BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
			BehaviorFunctions.ChangePartnerSkill(self.role, 62001007)
		end
	
	
	
		--仲魔连携技能
		
		if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Partner) and BehaviorFunctions.GetCtrlEntity() == self.role then
			if BehaviorFunctions.CheckBtnUseSkill(self.me,FightEnum.KeyEvent.Partner) then
				BehaviorFunctions.AddEntitySign(self.role,600000,-1,false)	--标记仲魔在场
				BehaviorFunctions.DoMagic(self.me,self.me,62001001,1)
				if BehaviorFunctions.CheckPlayerInFight() then
					
				elseif not BehaviorFunctions.CheckPlayerInFight() and not BehaviorFunctions.HasEntitySign(self.role,62001001) then
					BehaviorFunctions.AddEntitySign(self.role,62001001,-1,false)	--标记为正在暗杀
					self.assingTarget = self.assTarget	--确定暗杀目标
					--BehaviorFunctions.RemoveBuff(self.assingTarget,1000046)--移除暗杀锁定
					BehaviorFunctions.StopFightUIEffect("22105", "main")
					if BehaviorFunctions.CheckEntityHeight(self.role) > 0 then
						self.curHighPos = BehaviorFunctions.GetPositionP(self.role)
						BehaviorFunctions.DoMagic(self.role,self.role,1000066)
						BehaviorFunctions.AddBuff(self.me,self.me,1000066)--浮空buff
						
						--self:HighAssassin()
						if self.roleState == FightEnum.EntityState.Jump then
							--BehaviorFunctions.SetFightPanelVisible("0")
							BehaviorFunctions.SetFightPanelVisible("00010000")--隐藏角色UI
							BehaviorFunctions.SetJoyStickVisibleByAlpha(2, false, false)
							BehaviorFunctions.DoMagic(self.role,self.role,1000051)--播放仲魔变身出现特效
							BehaviorFunctions.AddDelayCallByTime(0.1,self,self.HighAssassin)
						elseif self.roleState == FightEnum.EntityState.Glide then
							--BehaviorFunctions.SetFightPanelVisible("0")
							BehaviorFunctions.SetFightPanelVisible("00010000")--隐藏角色UI
							BehaviorFunctions.SetJoyStickVisibleByAlpha(2, false, false)
							BehaviorFunctions.DoMagic(self.role,self.role,1000051)--播放仲魔变身出现特效
							BehaviorFunctions.AddDelayCallByTime(0.2,self,self.GlideAssassin)
						end
					end
					--BehaviorFunctions.CastSkillCost(self.me,62001008)
				end
			elseif not BehaviorFunctions.CheckPlayerInFight() then
				BehaviorFunctions.ShowTip(80000000)
			end
		end
	--不处于前台时清掉暗杀标记
	else
		if BehaviorFunctions.CheckEntity(self.assTarget) then
			--BehaviorFunctions.RemoveBuff(self.assTarget,1000046)
			BehaviorFunctions.StopFightUIEffect("22105", "main")
			BehaviorFunctions.HideAssassinLifeBarTip(self.role, self.assTarget)
		end
		BehaviorFunctions.RemoveEntitySign(self.role,62001003)
	end
	
	
	--暗杀保底
	if self.assProtectFrame < self.time and self.assEndState == 1 then
		BehaviorFunctions.BreakSkill(self.me)
		BehaviorFunctions.CastSkillBySelfPosition(self.me,62001006)
		self:PartnerExit()	--退场
		BehaviorFunctions.RemoveEntitySign(self.role,62001001)--移除处于刺杀状态
		if self.assingTarget then
			BehaviorFunctions.SetEntityLifeBarDelayDeathHide(self.assingTarget, false)
		end
		self.assEndState = 0
	end
end

function Behavior62001:AddSkillSign(instanceId,sign)
	if instanceId == self.me or instanceId == self.role then
		if sign == 600000006 then
			BehaviorFunctions.DoMagic(self.me,self.me,600000004,1)
			BehaviorFunctions.DoMagic(self.me,self.me,600000006,1)		--播放退场特效
			BehaviorFunctions.CallCommonBehaviorFunc(self.me, "DoPartnerLeave")		--进入仲魔退场流程
			--BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.RemoveEntitySign,self.role,600000)--移除仲魔在场标记
		end
	
		if sign == 62001001 then
			self:DoAssassinSkill()
		end
	
		--被暗杀标记
		if sign == 62001101 then
			BehaviorFunctions.AddEntitySign(self.assingTarget,62001101,150,false)
		end
	
		--if sign == 62001003 then
			--if BehaviorFunctions.GetDistanceFromTarget(instanceId,self.battleTarget,false) < 0.5 then
				--BehaviorFunctions.CastSkillByTarget(self.me,62001003,self.battleTarget)
			--end
		--end
	
		--暗杀地面接触
		if sign == 62001011 then
			BehaviorFunctions.CastSkillByTarget(self.me,62001009,self.assingTarget)
			BehaviorFunctions.RemoveEntitySign(self.role,62001001)
		end
	
		--播放后受击
		if sign == 62001062 then
			BehaviorFunctions.RemoveBuff(self.assingTarget,900000057)
			--BehaviorFunctions.DoLookAtPositionImmediately(self.assingTarget,self.partnerFrontPos.x,self.partnerFrontPos.y,self.partnerFrontPos.z,true)
			BehaviorFunctions.AddEntitySign(self.assingTarget,62001062,150,false)
		end
		
		--暗杀时没踹前静止怪物行为
		if sign == 62001020 or sign == 62001009 then
			BehaviorFunctions.DoMagic(self.me,self.assingTarget,900000057,1)
		end
		----暗杀空中接触
		--if sign == 62001007 then
			--BehaviorFunctions.CastSkillByTarget(self.me,62001004,self.assingTarget)
		--end
		--设置相机
		--if sign == 62001997 then
			--BehaviorFunctions.SetMainTarget(self.me)--设置相机目标
		--end
		
		--连携技能
		if sign == 600000002 and BehaviorFunctions.CheckPlayerInFight() then
			local curPos = self:CheckCurPosHeight(BehaviorFunctions.GetPositionOffsetBySelf(self.role,3,300))
			--local curPosCheck = self:CheckCurPosHeight(curPos)
			local curShowPos = {}

			--如果有这个点位，检测他是否合法
			if curPos then
				if BehaviorFunctions.CheckEntityCollideAtPosition(62001,curPos.x,curPos.y,curPos.z, {self.me,self.role},self.me) then
					curShowPos = curPos
				else
					curShowPos = self:CheckCreatePos()
				end
			else
				curShowPos = self:CheckCreatePos()
			end
			
			if curShowPos then
				BehaviorFunctions.DoMagic(self.me,self.me,1000055)
				if self.noTarget == 0 and BehaviorFunctions.CheckEntityHeight(self.role) == 0 then
					BehaviorFunctions.DoSetPosition(self.me,curShowPos.x,curShowPos.y,curShowPos.z)
					BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.MyFrontPos.x,self.MyFrontPos.y,self.MyFrontPos.z,true)
					BehaviorFunctions.ShowPartner(self.role, true)
					BehaviorFunctions.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
					BehaviorFunctions.DoMagic(self.me,self.me,600000005,1)	--播放仲魔出场特效
					BehaviorFunctions.CastSkillByTarget(self.me,62001017,self.battleTarget)
					BehaviorFunctions.CastSkillCost(self.me,62001017)
				elseif self.noTarget == 1 and BehaviorFunctions.CheckEntityHeight(self.role) == 0 then
					BehaviorFunctions.DoSetPosition(self.me,curShowPos.x,curShowPos.y,curShowPos.z)
					BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.MyFrontPos.x,self.MyFrontPos.y,self.MyFrontPos.z,true)
					BehaviorFunctions.ShowPartner(self.role, true)
					BehaviorFunctions.SetUseParentTimeScale(self.me, false)--不使用创建者时间缩放
					BehaviorFunctions.DoMagic(self.me,self.me,600000005,1)	--播放仲魔出场特效
					BehaviorFunctions.CastSkillBySelfPosition(self.me,62001017)
					BehaviorFunctions.CastSkillCost(self.me,62001017)
				end
			else
				BehaviorFunctions.ShowTip(80000001)
			end
		end
		
		--暗杀开始
		if sign == 62001009 or sign == 62001007 or sign == 62001013 then
			BehaviorFunctions.RemoveBuff(self.me,1000066)
			BehaviorFunctions.DoMagic(self.me,self.me,1000066)
			BehaviorFunctions.DoLookAtPositionImmediately(self.assingTarget,self.partnerFrontPos.x,self.partnerFrontPos.y,self.partnerFrontPos.z,true)
	
			BehaviorFunctions.CastSkillByTarget(self.me,62001011,self.assingTarget)
			BehaviorFunctions.SetEntityLifeBarDelayDeathHide(self.assingTarget, true)
		end
	
		--播放下落循环
		if sign == 62001999 then
			BehaviorFunctions.BreakSkill(self.me)
			BehaviorFunctions.CastSkillBySelfPosition(self.me,62001005)
			BehaviorFunctions.RemoveBuff(self.me,600000014)	--移除允许穿墙
			self.assEndState = 1
			self.assProtectFrame = self.time + self.assEndFrame
		end
	
		--暗杀噶头
		if sign == 62001003 or sign == 62001002 or sign == 62001010 then
			BehaviorFunctions.RemoveBuff(self.assingTarget,900000054)
			--延迟移除怪物顿帧
		end
	
		--暗杀攻击帧镜头模糊
		if sign == 62001002 then
		----BehaviorFunctions.DoMagic(self.me,self.assingTarget,1000050)
			--BehaviorFunctions.DoMagic(self.me,self.me,1000061)
			BehaviorFunctions.DoShowPosVague(self.me, 0.5, 10, 100000022, 0.85, 1, 40, 0.5,0.5, 0,30)--镜头模糊
		end
		
		--仲魔变身
		if sign == 10600001 and instanceId == self.role then
			BehaviorFunctions.DoSetPosition(self.me,self.worldSkillPos.x,self.worldSkillPos.y,self.worldSkillPos.z)--设置坐标
			BehaviorFunctions.SetMainTarget(self.me)--设置相机目标
			BehaviorFunctions.DoMagic(self.me,self.me,600000002)
			BehaviorFunctions.SetFightPanelVisible("00010000")--隐藏角色UI
			BehaviorFunctions.SetJoyStickVisibleByAlpha(2, false, false)
			BehaviorFunctions.AddDelayCallByTime(0.297,self,self.Henshin)
		end
		
		--暗杀怪物时停
		
		
	end
end


--获取战斗技能目标
function Behavior62001:GetTarget()

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
		BehaviorFunctions.AddSkillEventActiveSign(self.me,62001008)
	elseif BehaviorFunctions.CheckEntity(self.AttackTarget) then
		self.battleTarget = self.AttackTarget
		self.noTarget = 0
		BehaviorFunctions.AddSkillEventActiveSign(self.me,62001008)
	elseif BehaviorFunctions.CheckEntity(self.AttackAltnTarget) then
		self.battleTarget = self.AttackAltnTarget
		self.noTarget = 0
		BehaviorFunctions.AddSkillEventActiveSign(self.me,62001008)
	else
		self.noTarget = 1
		BehaviorFunctions.AddSkillEventActiveSign(self.me,62001108)
		BehaviorFunctions.RemoveSkillEventActiveSign(self.me,62001008)

	end

end

--暗杀技能
function Behavior62001:DoAssassinSkill()

	--播放QTE
	self.Assassin1QTE = BehaviorFunctions.DoShowAssassinQTE(self.me, 2.5, 0.8, 2)
	--添加顿帧
	BehaviorFunctions.DoMagic(self.me,self.me,1000047)
end


--落地回调
function Behavior62001:OnLand(instanceId)
	if instanceId == self.me and BehaviorFunctions.GetSkill(self.me) == 62001005 then

		BehaviorFunctions.BreakSkill(self.me)
		BehaviorFunctions.CastSkillBySelfPosition(self.me,62001006)
		self:PartnerExit()	--退场
		BehaviorFunctions.RemoveEntitySign(self.role,62001001)--移除处于刺杀状态
		if self.assingTarget then
			BehaviorFunctions.SetEntityLifeBarDelayDeathHide(self.assingTarget, false)
		end
		self.assEndState = 0
	end
end

function Behavior62001:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType)
	if attackInstanceId == self.me and BehaviorFunctions.GetEntityTemplateId(instanceId) == 62001008001 then
		BehaviorFunctions.AddSkillEventActiveSign(self.role,1001999)
		BehaviorFunctions.AddBuff(self.me,self.role,62001003,1)	--让角色受到我的顿帧影响
	end

	if attackInstanceId == self.me and BehaviorFunctions.GetEntityTemplateId(instanceId) == 62001009001 and hitInstanceId == self.assingTarget then
		BehaviorFunctions.PlayIKShake(hitInstanceId, 6200101, 1)
	end
	if attackInstanceId == self.me and BehaviorFunctions.GetEntityTemplateId(instanceId) == 62001004001 and hitInstanceId == self.assingTarget then
		BehaviorFunctions.PlayIKShake(hitInstanceId, 6200101, 1)
		--BehaviorFunctions.DoMagic(1,1,1000063)
	end
end


--结束暗杀QTE
function Behavior62001:EndAssassinQTE(qteId,result)
	if qteId == self.Assassin1QTE then
		--移除顿帧
		BehaviorFunctions.RemoveBuff(self.me,1000062)
		BehaviorFunctions.RemoveBuff(self.me,1000066)--移除浮空buff
		BehaviorFunctions.RemoveBuff(self.me,1000047)--移除顿帧
		--根据结果释放,0失败，2完美，1普通
		if result == 0 then
			BehaviorFunctions.CastSkillByTarget(self.me,62001010,self.assingTarget)
		elseif result == 2 then
			BehaviorFunctions.CastSkillByTarget(self.me,62001002,self.assingTarget)
			--BehaviorFunctions.CastSkillByTarget(self.me,62001009,self.assingTarget)
			BehaviorFunctions.DoShowPosVague(self.me, 0.15, 20, 100000005, 0.85, 1, 40, 0.5,0.35, 0,30)--镜头模糊
		elseif result == 1 then
			BehaviorFunctions.CastSkillByTarget(self.me,62001003,self.assingTarget)
			--BehaviorFunctions.CastSkillByTarget(self.me,62001004,self.assingTarget)
		end
	end
end

--变身
function Behavior62001:Henshin()
	--BehaviorFunctions.SetFightPanelVisible("0")--隐藏UI
	BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.MyFrontPos.x,self.MyFrontPos.y,self.MyFrontPos.z)--设置朝向
	BehaviorFunctions.ShowPartner(self.role, true)--显示仲魔
	BehaviorFunctions.DoMagic(self.me,self.me,600000003)--震屏
	BehaviorFunctions.DoMagic(self.me,self.me,1000053)--播放仲魔变身出现特效
	BehaviorFunctions.DoMagic(self.me,self.me,1000055)
	BehaviorFunctions.DoMagic(self.me,self.me,600000014)	--允许穿墙
	BehaviorFunctions.CastSkillByTarget(self.me,62001001,self.assTarget)--释放暗杀开始技能
	BehaviorFunctions.CastSkillCost(self.me,62001001)--按钮资源扣除
end

--空中暗杀
function Behavior62001:HighAssassin()
	--BehaviorFunctions.DoSetPosition(self.role,self.curHighPos.x,self.curHighPos.y,self.curHighPos.z)--设置坐标
	--BehaviorFunctions.SetFightPanelVisible("0")
	BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.assingTarget,false,360,360,-2,false)--设置朝向
	BehaviorFunctions.DoSetPosition(self.me,self.curHighPos.x,self.curHighPos.y,self.curHighPos.z)--设置坐标
	BehaviorFunctions.DoMagic(self.role,self.role,1000055)--无敌
	BehaviorFunctions.DoMagic(self.me,self.me,600000014)	--允许穿墙
	BehaviorFunctions.ShowPartner(self.role, true)	--显示
	BehaviorFunctions.DoMagic(self.me,self.me,1000053)--播放仲魔变身出现特效

	BehaviorFunctions.AddDelayCallByFrame(6,BehaviorFunctions,BehaviorFunctions.DoMagic,self.role,self.role,1000048)
	BehaviorFunctions.SetMainTarget(self.me)
	BehaviorFunctions.CastSkillByTarget(self.me,62001007,self.assTarget)--播放技能
	BehaviorFunctions.CastSkillCost(self.me,62001007)
	--BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.DoMagic,self.role,self.role,1000048)
end

--滑翔暗杀
function Behavior62001:GlideAssassin()
	--BehaviorFunctions.DoSetPosition(self.role,self.curHighPos.x,self.curHighPos.y,self.curHighPos.z)--设置坐标
	BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.assingTarget,false,360,360,-2,false)--设置朝向
	BehaviorFunctions.DoSetPosition(self.me,self.curHighPos.x,self.curHighPos.y,self.curHighPos.z)--设置坐标
	BehaviorFunctions.DoMagic(self.role,self.role,1000055)--无敌
	BehaviorFunctions.DoMagic(self.me,self.me,600000014)	--允许穿墙
	BehaviorFunctions.ShowPartner(self.role, true)	--显示
	BehaviorFunctions.DoMagic(self.me,self.me,1000053)--播放仲魔变身出现特效
	BehaviorFunctions.AddDelayCallByFrame(6,BehaviorFunctions,BehaviorFunctions.DoMagic,self.role,self.role,1000048)
	BehaviorFunctions.SetMainTarget(self.me)
	BehaviorFunctions.CastSkillByTarget(self.me,62001013,self.assTarget)--播放技能
	BehaviorFunctions.CastSkillCost(self.me,62001013)
	--BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.DoMagic,self.role,self.role,1000048)
end

--仲魔退场
function Behavior62001:PartnerExit()
	BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.ShowPartner,self.role, false)
	BehaviorFunctions.DoMagic(self.me,self.me,1000052)
	BehaviorFunctions.DoMagic(self.role,self.role,1000054)
	BehaviorFunctions.SetFightPanelVisible("-1")--移除UI隐藏
	BehaviorFunctions.SetJoyStickVisibleByAlpha(2, true, true) --摇杆状态
	--设置位置
	self.myPos = BehaviorFunctions.GetPositionP(self.me)
	BehaviorFunctions.DoSetEntityState(self.role,FightEnum.EntityState.Idle)
	BehaviorFunctions.DoSetPosition(self.role,self.myPos.x,self.myPos.y,self.myPos.z)
	BehaviorFunctions.SetMainTarget(self.role)
	BehaviorFunctions.RemoveBuff(self.role,1000048)
	BehaviorFunctions.RemoveBuff(self.me,1000055)
	BehaviorFunctions.RemoveBuff(self.role,1000055)
	
	BehaviorFunctions.SetCoreUIEnable(self.role, true)--显示核心能量条
	BehaviorFunctions.RemoveEntitySign(self.role,600000)--移除仲魔在场标记
end

--暗杀目标搜索
function Behavior62001:AssassinTarget()
	--如果携带了暗杀仲魔且不在战斗中
	if not BehaviorFunctions.CheckPlayerInFight() then
		--搜索目标
		if self.roleState == FightEnum.EntityState.Glide then
			self.AllTargetList = BehaviorFunctions.SearchEntities(self.role,self.highAssDis,315,45,2,1,900000053,1004,0,0,2,false,true,0.2,0.8,false,false,true)
		elseif self.roleState == FightEnum.EntityState.Jump then
			self.AllTargetList = BehaviorFunctions.SearchEntities(self.role,self.jumpAssDis,315,45,2,1,900000053,1004,0,0,2,false,true,0.2,0.8,false,false,true)
		else
			self.AllTargetList = BehaviorFunctions.SearchEntities(self.role,self.assDistance,315,45,2,1,900000053,1004,0,0,2,false,true,0.2,0.8,false,false,true)
		end
		self.setPartnerBtn = 1	--脱战重置按钮设置状态
		if next(self.AllTargetList) then
			--存在实体
			if BehaviorFunctions.CheckEntity(self.AllTargetList[1][1]) then
				self.assNewTarget = self.AllTargetList[1][1]
				--让暗杀目标始终更新
				if self.assNewTarget == self.assTarget then
					--BehaviorFunctions.AddBuff(self.role,self.assTarget,1000046)
					BehaviorFunctions.PlayFightUIEffect("22105", "main", nil, self.assTarget)
				else
					if BehaviorFunctions.CheckEntity(self.assTarget) then
						--BehaviorFunctions.RemoveBuff(self.assTarget,1000046)
						BehaviorFunctions.HideAssassinLifeBarTip(self.role, self.assTarget)
						BehaviorFunctions.StopFightUIEffect("22105", "main")
					end
					self.assTarget = self.assNewTarget
				end
				--存在时打开暗杀按钮并进行预计算
				BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
				BehaviorFunctions.ShowAssassinLifeBarTip(self.role, self.assTarget, 0, 1000049,1000050)

			end
		else
			--不存在时禁用暗杀按钮
			BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , true)
			BehaviorFunctions.StopFightUIEffect("22105", "main")
			self.assTarget = 0
		end
	else
		if self.assTarget ~= 0 then
			BehaviorFunctions.HideAssassinLifeBarTip(self.role, self.assTarget)
			--BehaviorFunctions.RemoveBuff(self.assTarget,1000046)
			BehaviorFunctions.StopFightUIEffect("22105", "main")
			self.assTarget = 0
		end

		--进入战斗打开仲魔按钮
		if self.setPartnerBtn == 0 then
			BehaviorFunctions.DisableSkillButton(self.me,FightEnum.KeyEvent.Partner , false)
			self.setPartnerBtn = 1
		end
	end
end


--获取仲魔养成等级
function Behavior62001:PartnerGrow()
	
	local skillLevel = 0
	local assDisGrow = 0
	local assDistance = 0
	
	--检查技能等级
	for i = 1,99 do
		if BehaviorFunctions.HasEntitySign(self.role,6200100800 + i) then
			skillLevel = i
		end
	end
	
	--增加暗杀距离
	if skillLevel == 1 then
		assDisGrow = 0
	elseif skillLevel > 1 then
		assDisGrow = self.growAssDistance * skillLevel	
	end
	
	--最终暗杀距离=基础暗杀距离+成长距离
	self.assDistance = self.baseAssDistance + assDisGrow
	
	--缓存更新
	--if self.assDistance ~= assDistance then
		--self.assDistance = assDistance
	--end
end

--获得随机坐标
function Behavior62001:GetRandomPos(radius)
	for i = 60,360,60 do

		local positionP = BehaviorFunctions.GetPositionOffsetBySelf(self.role,radius,i)

		--检测障碍：
		if BehaviorFunctions.CheckEntityCollideAtPosition(self.myEntityId, positionP.x, positionP.y, positionP.z, {self.me},self.me) then
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

--检查点位高度
function Behavior62001:CheckCurPosHeight(curPos)
	curPos.y = curPos.y + 0.2
	local y,layer = BehaviorFunctions.CheckPosHeight(curPos)
	if y and y > 0 and y <= 1 then
		local finalPos = Vec3.New()
		finalPos:Set(curPos.x,curPos.y - y,curPos.z)
		return finalPos
	else
		return nil
	end
end


--获得地面坐标
function Behavior62001:GetRandomLandPos(radius)

	for i = 60,360,60 do

		local positionP = BehaviorFunctions.GetPositionOffsetBySelf(self.role,radius,i)

		--检测障碍：
		if BehaviorFunctions.CheckEntityCollideAtPosition(self.myEntityId, positionP.x, positionP.y, positionP.z, {self.me},self.me) then
			local y,layer = BehaviorFunctions.CheckPosHeight(positionP)
			positionP.y = positionP.y + 0.2
			--对传进来的点位进行位置修正，保证在地面
			if y and y > 0 then
				local finalPos = Vec3.New()
				finalPos:Set(positionP.x,positionP.y - y,positionP.z)
				return finalPos
			end
		end
	end
	return nil
end

--计算技能召唤位置
function Behavior62001:CheckCreatePos()


	--local posTarget = self.me

	--local curShowPos = BehaviorFunctions.GetPositionOffsetBySelf(self.role,createDistance,createAngle)
	local createPos = {}
	local standbyPos = {}
	--备胎点位
	standbyPos[1] = BehaviorFunctions.GetPositionOffsetBySelf(self.role,2,270)
	standbyPos[2] = BehaviorFunctions.GetPositionOffsetBySelf(self.role,2,300)
	standbyPos[3] = BehaviorFunctions.GetPositionOffsetBySelf(self.role,2,60)
	standbyPos[4] = BehaviorFunctions.GetPositionOffsetBySelf(self.role,2,90)

	local curPosList = {}


	--找到位置列表里可以用于召唤的最佳点位
	for i = 1,4 do
		standbyPos[i].y = standbyPos[i].y + 0.2
		local height,layer = BehaviorFunctions.CheckPosHeight(standbyPos[i])
		if height and height == 0 and layer and layer ~= FightEnum.Layer.Water and layer ~= FightEnum.Layer.Marsh and layer ~= FightEnum.Layer.Lava and layer == FightEnum.Layer.Driftsand then
			if BehaviorFunctions.CheckEntityCollideAtPosition(self.myEntityId, standbyPos[i].x, standbyPos[i].y, standbyPos[i].z, {self.me},self.me) then
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

--随机获取位置保底
function Behavior62001:RandomPos(radius)
	for i = 90,720,30 do
		local positionP = BehaviorFunctions.GetPositionOffsetBySelf(self.role,radius,i)
		if not BehaviorFunctions.CheckObstaclesBetweenPos(self.rolePos,positionP,false) then
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

--离场重置
function Behavior62001:OnTransport()
	BehaviorFunctions.BreakSkill(self.me)	--打断自身技能
	BehaviorFunctions.ShowPartner(self.role, false)	--隐藏仲魔
	BehaviorFunctions.RemoveEntitySign(self.me,600002)	--移除退场标记
	BehaviorFunctions.RemoveEntitySign(self.role,600000)	--结束仲魔在场状态
	BehaviorFunctions.RemoveEntitySign(self.role,self.me)	--结束自己在场状态
	BehaviorFunctions.RemoveBuff(self.me,1000055)	--移除无敌buff
	--移除溶解buff
	if BehaviorFunctions.GetBuffCount(self.me,600000006) ~= 0 then
		BehaviorFunctions.RemoveBuff(self.me,600000006)
	end
end




--仲魔离场回调
function Behavior62001:PartnerHide(instanceId)
	if instanceId == self.me then
		BehaviorFunctions.RemoveEntitySign(self.me,600002)
		BehaviorFunctions.RemoveEntitySign(self.role,600000)	--结束仲魔在场状态
		BehaviorFunctions.RemoveEntitySign(self.role,self.me)	--结束自己在场状态
		BehaviorFunctions.RemoveBuff(self.me,1000055)	--移除无敌buff
		BehaviorFunctions.ShowPartner(self.role,false)
	end
end

--移除时候清空暗杀标记
function Behavior62001:BeforePartnerReplaced(roleInstanceId, partnerInstanceId)
	if partnerInstanceId == self.me then
		--携带了暗杀类型的仲魔
		BehaviorFunctions.RemoveEntitySign(self.role,62001003)
	end
end

