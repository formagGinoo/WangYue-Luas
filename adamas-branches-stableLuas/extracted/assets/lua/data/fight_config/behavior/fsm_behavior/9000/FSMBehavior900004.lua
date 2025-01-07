FSMBehavior900004 = BaseClass("FSMBehavior900004",FSMBehaviorBase)
--怪物脱战中状态


function FSMBehavior900004.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior900004:Init()
	self.exitFrame = 0
	self.tauntKey = nil
	self.pathFinding = false
	self.rebornDone = false
end

function FSMBehavior900004:Update()
	if self.exitFrame == 0 then
		self.exitFrame = self.MainBehavior.myFrame
	end
	if BehaviorFunctions.GetEntityValue(self.MainBehavior.me,"congshigongmove") and BehaviorFunctions.GetEntityValue(self.MainBehavior.me,"congshigongmove")==true then
		self:DontRunReborn()
		if self.rebornDone == true then
			return true
		end
	elseif BehaviorFunctions.SetPathFollowPos(self.MainBehavior.me,self.MainBehavior.bornPosition)==true then
		if self.MainBehavior.bornDistance >= 0.1 then
			--设置一次移动状态
			if BehaviorFunctions.GetSubMoveState(self.MainBehavior.me) ~= FightEnum.EntityMoveSubState.Run  then
				BehaviorFunctions.DoSetMoveType(self.MainBehavior.me,FightEnum.EntityMoveSubState.Run)
			end
			--设置一次寻路状态
			if self.MainBehavior.pathFindKey == true then
				BehaviorFunctions.SetPathFollowPos(self.MainBehavior.me,self.MainBehavior.bornPosition)
				self.MainBehavior.pathFindKey = false
			end
		elseif self.MainBehavior.bornDistance < 0.1  then
			if self.MainBehavior.pathFindKey == false then
				BehaviorFunctions.ClearPathFinding(self.MainBehavior.me)
			end
			if self:Reborn() then
				return true
			end
		end
	else
		if self.MainBehavior.bornDistance>5 then
			BehaviorFunctions.DoLookAtPositionByLerp(self.MainBehavior.me,self.MainBehavior.bornPosition.x,nil,self.MainBehavior.bornPosition.z,true,0,360,-2)

			if BehaviorFunctions.GetSubMoveState(self.MainBehavior.me) ~= FightEnum.EntityMoveSubState.Run then
				BehaviorFunctions.DoSetMoveType(self.MainBehavior.me,FightEnum.EntityMoveSubState.Run)
			end
		elseif self.MainBehavior.bornDistance >= 0.1 and self.MainBehavior.bornDistance<=5 then
			BehaviorFunctions.DoLookAtPositionImmediately(self.MainBehavior.me,self.MainBehavior.bornPosition.x,nil,self.MainBehavior.bornPosition.z)
			if BehaviorFunctions.GetSubMoveState(self.MainBehavior.me) ~= FightEnum.EntityMoveSubState.Run then
				BehaviorFunctions.DoSetMoveType(self.MainBehavior.me,FightEnum.EntityMoveSubState.Run)
			end
			--到达目标点，按规则切换下个目标点
		elseif self.MainBehavior.bornDistance < 0.1 then
			if self:Reborn() then
				return true
			end
		end
	end
	
	--超时强制退出
	if self.exitFrame >0 then
		if self.MainBehavior.myFrame - self.exitFrame >= self.MainBehavior.exitFightLimitTime *30 then
			if self:Reborn() then
				return true
			end
		end
	end
		
	--超距离重生
	if self.MainBehavior.bornDistance >= self.MainBehavior.RebornRange then
		if self:Reborn() then
			return true
		end
	end
	if self.MainBehavior.addLifeBar== false then
		BehaviorFunctions.SetEntityLifeBarVisibleType(self.MainBehavior.me,1)
		self.MainBehavior.addLifeBar= true
	end	

end

function FSMBehavior900004:Reborn()
	BehaviorFunctions.SetEntityValue(self.MainBehavior.me,"MonsterExitFight",false)
	BehaviorFunctions.DoSetPositionP(self.MainBehavior.me,self.MainBehavior.bornPosition)
	BehaviorFunctions.StopMove(self.MainBehavior.me)
	BehaviorFunctions.CancelLookAt(self.MainBehavior.me)
	BehaviorFunctions.DoMagic(1,self.MainBehavior.me,900000021)
	BehaviorFunctions.RemoveFightTarget(self.MainBehavior.me,self.MainBehavior.battleTarget)
	--回满血
	if  BehaviorFunctions.HasBuffKind(self.MainBehavior.me,900000007) then
		BehaviorFunctions.RemoveBuff(self.MainBehavior.me,900000007)
	end
	--恢复元素积累判断
	BehaviorFunctions.EnableEntityElementStateRuning(self.MainBehavior.me, FightEnum.ElementState.Accumulation,true,-1)
	--清除元素积累
	BehaviorFunctions.SetEntityElementStateAccumulation(self.MainBehavior.me,self.MainBehavior.me,-1,0)
	self.MainBehavior.actKey=true

	if self.MainBehavior.pathFindKey == false then
		BehaviorFunctions.ClearPathFinding(self.MainBehavior.me)
		self.MainBehavior.pathFindKey = true
	end
	self.rebornDone = true
	return BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me)
end


function FSMBehavior900004:DontRunReborn()
	BehaviorFunctions.SetEntityValue(self.MainBehavior.me,"MonsterExitFight",false)
	BehaviorFunctions.StopMove(self.MainBehavior.me)
	BehaviorFunctions.CancelLookAt(self.MainBehavior.me)
	BehaviorFunctions.DoMagic(1,self.MainBehavior.me,900000021)
	BehaviorFunctions.RemoveFightTarget(self.MainBehavior.me,self.MainBehavior.battleTarget)
	if  BehaviorFunctions.HasBuffKind(self.MainBehavior.me,900000007) then
		BehaviorFunctions.RemoveBuff(self.MainBehavior.me,900000007)
	end
	self.MainBehavior.actKey=true
	self.rebornDone = true
	return BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me)
end


--强制脱战
function FSMBehavior900004:LeaveFighting(instanceId)
	if instanceId == self.MainBehavior.me then
		if self:Reborn() then
			return true
		end
	end
end


function FSMBehavior900004:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId == self.MainBehavior.me then
		BehaviorFunctions.RemoveFightTarget(self.MainBehavior.me,self.MainBehavior.battleTarget)
	end
	if dieInstanceId ==self.MainBehavior.battleTarget then
		if self.MainBehavior.tauntSkillId then
			self.tauntKey=true
		else
			self.tauntKey=false
		end
		self.tauntFrame = self.MainBehavior.myFrame  --只要有角色死就开始计时
	end

end


function FSMBehavior900004:PathFindingEnd(instanceId,result)
	if instanceId == self.MainBehavior.me then
		if result == true then
			self:StopPathFind()
		else
			--因为异常结束
			self.MainBehavior.pathFindKey = true
			local state = BehaviorFunctions.GetEntityState(self.MainBehavior.battleTarget)
			if BehaviorFunctions.GetEntityState(self.MainBehavior.battleTarget) ~= FightEnum.EntityState.Fall
				and BehaviorFunctions.GetEntityState(self.MainBehavior.battleTarget) ~= FightEnum.EntityState.Jump then
				self:StopPathFind()
			end
			--当角色在跳的时候，寻路到角色脚下的点
			if BehaviorFunctions.SetPathFollowEntity(self.MainBehavior.me,self.MainBehavior.battleTarget)==false
				and (BehaviorFunctions.GetEntityState(self.MainBehavior.battleTarget) == FightEnum.EntityState.Fall
					or BehaviorFunctions.GetEntityState(self.MainBehavior.battleTarget) == FightEnum.EntityState.Jump) then
				local pos =BehaviorFunctions.GetPositionP(self.MainBehavior.battleTarget)
				local h,layer=BehaviorFunctions.CheckPosHeight(pos)
				local pos2 = {["x"]=pos.x,["y"]=pos.y-h,["z"]=pos.z}
				BehaviorFunctions.SetPathFollowPos(self.MainBehavior.battleTarget,pos2)
			end
		end
	end
end

function FSMBehavior900004:StopPathFind()
	BehaviorFunctions.DoSetEntityState(self.MainBehavior.me,FightEnum.EntityState.Idle)
	BehaviorFunctions.ClearPathFinding(self.MainBehavior.me)
	self.MainBehavior.pathFindKey = true
end