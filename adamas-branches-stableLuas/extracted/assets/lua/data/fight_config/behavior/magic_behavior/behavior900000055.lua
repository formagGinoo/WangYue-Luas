Behavior900000055 = BaseClass("Behavior900000055",EntityBehaviorBase)
function Behavior900000055.GetGenerates()


end

function Behavior900000055.GetMagics()

end

function Behavior900000055:Init()
	self.me = self.instanceId		--记录自己
end

function Behavior900000055:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()--记录角色
	self.partner = BehaviorFunctions.GetPartnerInstanceId(self.role)
	--获取角色暗杀距离
	self.assDistance = BehaviorFunctions.GetEntityValue(self.role,"assDistance")
	--获取开放被暗杀动作
	self.beAssassin = BehaviorFunctions.GetEntityValue(self.me,"beAssassin")
	--获取角色暗杀目标
	self.assTarget = BehaviorFunctions.GetEntityValue(self.role,"assTarget")
	self.partner = BehaviorFunctions.GetPartnerInstanceId(self.role)
	self.distance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.role,false)
	self.myPos = BehaviorFunctions.GetPositionP(self.me)
	self.roleState = BehaviorFunctions.GetEntityState(self.role)
	
	self.backHited = BehaviorFunctions.GetEntityValue(self.me,"backHited")
	
	self.rolePos = BehaviorFunctions.GetPositionP(self.role)

	self.Yspeed = BehaviorFunctions.GetEntitySpeedY(self.role)
	
	if self.partner then
		self.partnerFrontPos = BehaviorFunctions.GetPositionOffsetBySelf(self.partner,10,0) --仲魔前方的位置
	end
	
	--判断双方高低差
	self.heightDis = math.abs(self.myPos.y - self.rolePos.y)
	--获取高空暗杀距离
	self.highAssDis = BehaviorFunctions.GetEntityValue(self.role,"highAssDis")
	self.jumpAssDis = BehaviorFunctions.GetEntityValue(self.role,"jumpAssDis")
	self.jumpState = BehaviorFunctions.GetEntityJumpState(self.role)

	--目标丢失时重置自身状态
	if self.assTarget == 0 then
		--BehaviorFunctions.RemoveBuff(self.me,1000046)
		BehaviorFunctions.StopFightUIEffect("22105", "main")
		BehaviorFunctions.HideAssassinLifeBarTip(self.role, self.me)
	end
	

	--距离和角度满足时标记自己可以被暗杀
	if not BehaviorFunctions.GetEntityValue(self.me,"MonsterExitFight") then
		if not BehaviorFunctions.CheckPlayerInFight() and BehaviorFunctions.HasEntitySign(self.role,62001003) and not BehaviorFunctions.HasEntitySign(self.role,62001001) then
			--地面暗杀
			if BehaviorFunctions.CheckEntityHeight(self.role) == 0 then
				--如果满足暗杀距离且基本在同一水平线上
				if self.distance < self.assDistance and self.heightDis <= 4 then
					if BehaviorFunctions.CompEntityLessAngle(self.me,self.role,70) then
						BehaviorFunctions.RemoveBuff(self.me,900000053)
						BehaviorFunctions.HideAssassinLifeBarTip(self.role, self.me)
						--BehaviorFunctions.RemoveBuff(self.me,1000046)
						--BehaviorFunctions.StopFightUIEffect("22105", "main")
					else
						BehaviorFunctions.AddBuff(self.me,self.me,900000053)
					end
				else
					BehaviorFunctions.RemoveBuff(self.me,900000053)
					BehaviorFunctions.HideAssassinLifeBarTip(self.role, self.me)
					--BehaviorFunctions.RemoveBuff(self.me,1000046)
					--BehaviorFunctions.StopFightUIEffect("22105", "main")
				end
				--滑翔
			elseif BehaviorFunctions.CheckEntityHeight(self.role) > 3 and self.roleState == FightEnum.EntityState.Glide and self.heightDis <= self.highAssDis then
					BehaviorFunctions.AddBuff(self.me,self.me,900000053)
				--假如在背后，处于下落状态
			elseif self.roleState == FightEnum.EntityState.Jump and self.Yspeed < 0 and not BehaviorFunctions.CompEntityLessAngle(self.me,self.role,70) and BehaviorFunctions.CheckEntityHeight(self.role) > 2 and BehaviorFunctions.CheckEntityHeight(self.role) < self.jumpAssDis then
					BehaviorFunctions.AddBuff(self.me,self.me,900000053)
			else
				--如果都不满足移除自己可被暗杀的标记
				BehaviorFunctions.RemoveBuff(self.me,900000053)
				BehaviorFunctions.HideAssassinLifeBarTip(self.role, self.me)
				--BehaviorFunctions.RemoveBuff(self.me,1000046)
				--BehaviorFunctions.StopFightUIEffect("22105", "main")
			end
	
	
		else
			--角色进战移除可暗杀标记
			--BehaviorFunctions.RemoveBuff(self.me,1000046)
			--BehaviorFunctions.StopFightUIEffect("22105", "main")
			BehaviorFunctions.HideAssassinLifeBarTip(self.role, self.me)
			BehaviorFunctions.RemoveBuff(self.me,900000053)
		end
	else
		BehaviorFunctions.HideAssassinLifeBarTip(self.role, self.me)
		BehaviorFunctions.RemoveBuff(self.me,900000053)
	end	


	--临时被暗杀动作检测
	if BehaviorFunctions.HasEntitySign(self.me,62001101) then
		BehaviorFunctions.CastSkillBySelfPosition(self.me,self.beAssassin)
		BehaviorFunctions.RemoveEntitySign(self.me,62001101)
	end
	
	--播放后受击动作
	if BehaviorFunctions.HasEntitySign(self.me,62001062) then
		if self.partnerFrontPos then
			BehaviorFunctions.CastSkillByPosition(self.me,self.backHited,self.partnerFrontPos)
			BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.partnerFrontPos.x,self.partnerFrontPos.y,self.partnerFrontPos.z,true)
		else
			BehaviorFunctions.CastSkillBySelfPosition(self.me,self.backHited)
		end
		BehaviorFunctions.RemoveEntitySign(self.me,62001062)
	end
	
	
	--end
end


--function Behavior900000055:ChangeBackground(instanceId)
--if instanceId == self.role and BehaviorFunctions.HasEntitySign(self.role,62001003) then
--BehaviorFunctions.RemoveBuff(self.me,1000046)
--BehaviorFunctions.HideAssassinLifeBarTip(self.role, self.me)
--BehaviorFunctions.RemoveBuff(self.me,900000053)
--end
--end

--function Behavior900000055:AddSkillSign(instanceId,sign)
	--if instanceId == self.partner then
		--if sign == 62001062 then
			
		--end
	--end
--end