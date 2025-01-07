MonsterExitFight = BaseClass("MonsterExitFight",EntityBehaviorBase)

function MonsterExitFight:Init()
	self.MonsterCommonBehavior = self.ParentBehavior
	self.MonsterCommonParam = self.MainBehavior.MonsterCommonParam
	self.exitFrame = 0
	self.tauntKey = nil
	self.pathEnd = true
	self.pathFinding = false
end

function MonsterExitFight:Update()
	if self.MonsterCommonParam.canExitFight == true  and BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then

		
		self.bornDistance = BehaviorFunctions.GetDistanceFromPos(self.MonsterCommonParam.myPos,self.MonsterCommonParam.bornPosition)

		if (self.bornDistance >= self.MonsterCommonParam.ExitFightRange 
			or (self.MonsterCommonParam.targetMaxRange > 0 and self.MonsterCommonParam.battleTargetDistance >= self.MonsterCommonParam.targetMaxRange)) 
			and self.MonsterCommonParam.inFight == true then  
			if self.MonsterCommonParam.exitFightState ~= self.MonsterCommonParam.ExitFightStateEnum.Exiting then
				self.MonsterCommonParam.exitFightState = self.MonsterCommonParam.ExitFightStateEnum.Exiting
				self.exitFrame = self.MonsterCommonParam.myFrame
				BehaviorFunctions.RemoveFightTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
				if self.MonsterCommonParam.pathFindKey == false then
					BehaviorFunctions.ClearPathFinding(self.MonsterCommonParam.me)
					self.MonsterCommonParam.pathFindKey = true
				end
			end
			if not BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,900000007) then
				BehaviorFunctions.DoMagic(1,self.MonsterCommonParam.me,900000007)
			end
		end
		--脱战巡回
		if self.MonsterCommonParam.exitFightState == self.MonsterCommonParam.ExitFightStateEnum.Exiting then
			--脱战
			self.MonsterCommonParam.inFight = false
			--传值
			BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"MonsterExitFight",true)
			BehaviorFunctions.RemoveFightTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
			--返回出生点
			--BehaviorFunctions.DoLookAtPositionImmediately(self.MonsterCommonParam.me,self.MonsterCommonParam.bornPosition.x,nil,self.MonsterCommonParam.bornPosition.z)
			BehaviorFunctions.CancelLookAt(self.MonsterCommonParam.me)

			if BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"congshigongmove") and BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"congshigongmove")==true and self.MonsterCommonParam.inPeace == false then
				self:DontRunReborn()
			elseif BehaviorFunctions.SetPathFollowPos(self.MonsterCommonParam.me,self.MonsterCommonParam.bornPosition)==true then
				if self.bornDistance >= 0.1 then
					--设置一次移动状态
					if BehaviorFunctions.GetSubMoveState(self.MonsterCommonParam.me) ~= FightEnum.EntityMoveSubState.Run  then
						BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.Run)
					end
					--设置一次寻路状态
					if self.MonsterCommonParam.pathFindKey == true then
						BehaviorFunctions.SetPathFollowPos(self.MonsterCommonParam.me,self.MonsterCommonParam.bornPosition)
						self.MonsterCommonParam.pathFindKey = false
					end
					
				
				elseif self.bornDistance < 0.1  then
					if self.MonsterCommonParam.pathFindKey == false then
						BehaviorFunctions.ClearPathFinding(self.MonsterCommonParam.me)
					end
					self:Reborn()
					
				end
			else
				if self.bornDistance>5 then
					BehaviorFunctions.DoLookAtPositionByLerp(self.MonsterCommonParam.me,self.MonsterCommonParam.bornPosition.x,nil,self.MonsterCommonParam.bornPosition.z,true,0,360,-2)
					
					if BehaviorFunctions.GetSubMoveState(self.MonsterCommonParam.me) ~= FightEnum.EntityMoveSubState.Run then
						BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.Run)
					end
				elseif self.bornDistance >= 0.1 and self.bornDistance<=5 then
					BehaviorFunctions.DoLookAtPositionImmediately(self.MonsterCommonParam.me,self.MonsterCommonParam.bornPosition.x,nil,self.MonsterCommonParam.bornPosition.z)
					if BehaviorFunctions.GetSubMoveState(self.MonsterCommonParam.me) ~= FightEnum.EntityMoveSubState.Run then
						BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.Run)
					end  
					--到达目标点，按规则切换下个目标点
				elseif self.bornDistance < 0.1 and self.MonsterCommonParam.inPeace == false then
					self:Reborn()
				end
			end
		end

		--超时强制退出
		if self.exitFrame >0 and self.MonsterCommonParam.exitFightState == self.MonsterCommonParam.ExitFightStateEnum.Exiting and self.MonsterCommonParam.inPeace == false then
			if self.MonsterCommonParam.myFrame - self.exitFrame >= self.MonsterCommonParam.exitFightLimitTime *30 then
				self:Reborn()
				self.exitFrame = 0
			end
		end
		--超距离重生
		if self.bornDistance >= self.MonsterCommonParam.RebornRange and self.MonsterCommonParam.inPeace == false then
			self:Reborn()
		end
	end
	if self.MonsterCommonParam.inPeace == true and self.MonsterCommonParam.addLifeBar== false then
		BehaviorFunctions.SetEntityLifeBarVisibleType(self.MonsterCommonParam.me,1)
		self.MonsterCommonParam.addLifeBar= true
	end
end

function MonsterExitFight:Reborn()
	BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"MonsterExitFight",false)
	BehaviorFunctions.DoSetPositionP(self.MonsterCommonParam.me,self.MonsterCommonParam.bornPosition)
	BehaviorFunctions.StopMove(self.MonsterCommonParam.me)
	BehaviorFunctions.CancelLookAt(self.MonsterCommonParam.me)
	BehaviorFunctions.DoMagic(self.MonsterCommonParam.me,self.MonsterCommonParam.me,900000021)
	self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
	self.MonsterCommonParam.inFight = false
	self.MonsterCommonParam.inPeace = true
	self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Default
	self.MonsterCommonParam.exitFightState = self.MonsterCommonParam.ExitFightStateEnum.Default
	BehaviorFunctions.RemoveFightTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
	if  BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,900000007) then
		BehaviorFunctions.RemoveBuff(self.MonsterCommonParam.me,900000007)
	end
	self.MonsterCommonParam.actKey=true
	--if self.pathFinding == true then
		--self.pathEnd = true
	--end
	if self.MonsterCommonParam.pathFindKey == false then
		BehaviorFunctions.ClearPathFinding(self.MonsterCommonParam.me)
		self.MonsterCommonParam.pathFindKey = true
	end
	
end


function MonsterExitFight:DontRunReborn()
	BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"MonsterExitFight",false)
	BehaviorFunctions.StopMove(self.MonsterCommonParam.me)
	BehaviorFunctions.CancelLookAt(self.MonsterCommonParam.me)
	BehaviorFunctions.DoMagic(self.MonsterCommonParam.me,self.MonsterCommonParam.me,900000021)
	self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
	self.MonsterCommonParam.inFight = false
	self.MonsterCommonParam.inPeace = true
	self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Default
	self.MonsterCommonParam.exitFightState = self.MonsterCommonParam.ExitFightStateEnum.Default
	BehaviorFunctions.RemoveFightTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
	if  BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,900000007) then
		BehaviorFunctions.RemoveBuff(self.MonsterCommonParam.me,900000007)
	end
	self.MonsterCommonParam.actKey=true
end

--强制脱战
function MonsterExitFight:LeaveFighting(instanceId)
	if instanceId == self.MonsterCommonParam.me then
		self:Reborn()
	end
end





function MonsterExitFight:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId == self.MonsterCommonParam.me and self.MonsterCommonParam.inFight then
		BehaviorFunctions.RemoveFightTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
	end
	if dieInstanceId ==self.MonsterCommonParam.battleTarget then
		if self.MonsterCommonParam.tauntSkillId then
			self.tauntKey=true
		else
			self.tauntKey=false
		end
		self.tauntFrame = self.MonsterCommonParam.myFrame  --只要有角色死就开始计时
	end
	
end




function MonsterExitFight:PathFindingEnd(instanceId,result)
	if instanceId == self.MonsterCommonParam.me then
		if result == true then
			self:StopPathFind()
		else
			--因为异常结束
			self.MonsterCommonParam.pathFindKey = true
			local state = BehaviorFunctions.GetEntityState(self.MonsterCommonParam.battleTarget)
			if BehaviorFunctions.GetEntityState(self.MonsterCommonParam.battleTarget) ~= FightEnum.EntityState.Fall
				and BehaviorFunctions.GetEntityState(self.MonsterCommonParam.battleTarget) ~= FightEnum.EntityState.Jump then
				self:StopPathFind()
			end
			--当角色在跳的时候，寻路到角色脚下的点
			if BehaviorFunctions.SetPathFollowEntity(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)==false
				and (BehaviorFunctions.GetEntityState(self.MonsterCommonParam.battleTarget) == FightEnum.EntityState.Fall
					or BehaviorFunctions.GetEntityState(self.MonsterCommonParam.battleTarget) == FightEnum.EntityState.Jump) then
				local pos =BehaviorFunctions.GetPositionP(self.MonsterCommonParam.battleTarget)
				local h,layer=BehaviorFunctions.CheckPosHeight(pos)
				local pos2 = {["x"]=pos.x,["y"]=pos.y-h,["z"]=pos.z}
				BehaviorFunctions.SetPathFollowPos(self.MonsterCommonParam.battleTarget,pos2)
			end
		end
	end
end

function MonsterExitFight:StopPathFind()
	BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Idle)
	BehaviorFunctions.ClearPathFinding(self.MonsterCommonParam.me)
	self.MonsterCommonParam.pathFindKey = true
end

	
