Behavior900000066 = BaseClass("Behavior900000066",EntityBehaviorBase)
function Behavior900000066.GetGenerates()


end

function Behavior900000066.GetMagics()

end

function Behavior900000066:Init()
	self.me = self.instanceId		--记录自己
	self.mission = 0
end

function Behavior900000066:Update()
	self.battleTarget = BehaviorFunctions.GetCtrlEntity()
	self.partner = BehaviorFunctions.GetPartnerInstanceId(self.battleTarget)
	self.time = BehaviorFunctions.GetFightFrame()	--记录时间
	
	if BehaviorFunctions.HasEntitySign(self.me,900000066) then	
		if self.mission == 0 then
			self.curTime = self.time	--记录时间
			self.buffFrame = 180
			if BehaviorFunctions.CheckEntityHeight(self.me) == 0 then
				BehaviorFunctions.EndHitState(self.me)
				BehaviorFunctions.BreakSkill(self.me)
			end
			self.mission = 1
		end
		
		if BehaviorFunctions.CanCtrl(self.me) then
			if BehaviorFunctions.GetBuffCount(self.me,600060004) == 0 then
				BehaviorFunctions.DoMagic(self.partner,self.me,600060004)	--添加顿帧
				BehaviorFunctions.SetBuffTimeByKind(self.me,600060004,self.buffFrame - self.time + self.curTime)		--设置buff剩余时间
			end
			if BehaviorFunctions.GetSubMoveState(self.me) ~= FightEnum.EntityMoveSubState.Run then
				BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Idle)
				BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.battleTarget,true,360,0,-1,false)
				BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Run)
			end
		end
		self.stunType = 1
		
	else	
		if BehaviorFunctions.GetBuffCount(self.me,600000065) == 0 then
			BehaviorFunctions.DoMagic(self.me,self.me,600000065)	--替换成眩晕
		end
		self.stunType = 2
	end
end


function Behavior900000066:Hit(attackInstanceId,hitInstanceId,hitType,camp)
	if hitInstanceId == self.me and self.stunType == 1 then
		if BehaviorFunctions.GetBuffCount(self.me,600060004) ~= 0 then
			BehaviorFunctions.RemoveBuff(self.me,600060004)	--移除顿帧
		end
	end
end