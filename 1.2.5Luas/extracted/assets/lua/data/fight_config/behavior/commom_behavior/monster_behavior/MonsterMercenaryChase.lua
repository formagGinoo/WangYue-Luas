MonsterMercenaryChase = BaseClass("MonsterMercenaryChase",EntityBehaviorBase)
--佣兵追击状态

function MonsterMercenaryChase:Init()
	self.MonsterCommonBehavior = self.ParentBehavior
	self.MonsterCommonParam = self.MainBehavior.MonsterCommonParam
	--逻辑变量
	self.inChase = false
	self.inFightRange = false
	self.inPathFinding = false
	self.pathFindingArrive = false
	self.targetInForbiddenArea = false
	self.forbiddenDisappear = false
	self.bornPosition = nil
end

function MonsterMercenaryChase:Update()
	self.MonsterCommonParam.inMercenaryChase = BehaviorFunctions.IsMercenaryChase(self.MonsterCommonParam.me)
	if self.bornPosition == nil then
		local posx, posy, posz = BehaviorFunctions.GetPosition(self.MonsterCommonParam.me)
		self.bornPosition = Vec3.New(posx, posy, posz)
	end	
	if self.MonsterCommonParam.battleTargetDistance <= 15 then
		self.inFightRange = true
	else
		self.inFightRange = false
	end
	
	if self.MonsterCommonParam.inMercenaryChase == true and self.inChase == false and not self.targetInForbiddenArea then
		self.MonsterCommonParam.inPeace = false
		self.MonsterCommonParam.haveWarn = false
		self.MonsterCommonParam.inFight = false
		self.MonsterCommonParam.canExitFight = false
		self.inChase = true
	elseif self.MonsterCommonParam.inMercenaryChase == true and self.targetInForbiddenArea and not self.forbiddenDisappear then
		self.forbiddenDisappear = true
		self:MercenaryReborn()
	end
		
	--追击状态
	if 	self.inChase == true and self.MonsterCommonParam.inFight == false then
		if self.inFightRange == false and BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
			--在距离外设置寻路
			if self:PathFindingBegin() and self.inPathFinding == false and self.MonsterCommonParam.inFight == false then
				--寻路开始
				self.inPathFinding = true
				if BehaviorFunctions.GetEntityState(self.MonsterCommonParam.me) ~= FightEnum.EntityState.Move then
					BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Move)
					BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.Run)
				end
			end
		else
			--在距离内停止寻路，进入战斗
			if (self.inPathFinding and self.pathFindingArrive) or self.inFightRange == true then
				if BehaviorFunctions.GetEntityState(self.MonsterCommonParam.me) == FightEnum.EntityState.Move then
					BehaviorFunctions.StopMove(self.MonsterCommonParam.me)
					BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Idle)
				end
				--停止寻路
				BehaviorFunctions.ClearPathFinding(self.MonsterCommonParam.me)
				self.pathFindingArrive = nil
				--进入战斗
				self.MonsterCommonParam.inFight = true
				--索敌
				BehaviorFunctions.AddFightTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
			end		
		end
	end
end


function MonsterMercenaryChase:PathFindingBegin()
	local result = BehaviorFunctions.SetPathFollowEntity(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
	if result == true then
		return true
	else
		return false
	end
end

function MonsterMercenaryChase:PathFindingEnd(instanceId,result)
	if instanceId == self.MonsterCommonParam.me and result == true	then
		--抵达目标地点
		BehaviorFunctions.ClearPathFinding(self.MonsterCommonParam.me)
		self.pathFindingArrive = true
		self.inPathFinding = false
	elseif instanceId == self.MonsterCommonParam.me and result == false then
		--寻路异常
		BehaviorFunctions.ClearPathFinding(self.MonsterCommonParam.me)
		self.inPathFinding = false
	end
end

function MonsterMercenaryChase:MercenaryReborn()
	--停止逻辑
	BehaviorFunctions.StopMove(self.MonsterCommonParam.me)
	BehaviorFunctions.CancelLookAt(self.MonsterCommonParam.me)
	BehaviorFunctions.DoMagic(self.MonsterCommonParam.me,self.MonsterCommonParam.me,900000021)
	BehaviorFunctions.RemoveFightTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
	if  BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,900000007) then
		BehaviorFunctions.RemoveBuff(self.MonsterCommonParam.me,900000007)
	end
	self.MonsterCommonParam.actKey=true
	if self.MonsterCommonParam.pathFindKey == false then
		BehaviorFunctions.ClearPathFinding(self.MonsterCommonParam.me)
		self.MonsterCommonParam.pathFindKey = true
	end
	--逻辑变量初始化
	self.forbiddenDisappear = false
	self.inChase = false
	self.inFightRange = false
	self.inPathFinding = false
	self.pathFindingArrive = false
	self.targetInForbiddenArea = false
	self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
	self.MonsterCommonParam.inFight = false
	self.MonsterCommonParam.inPeace = true
	self.MonsterCommonParam.warnState = self.MonsterCommonParam.warnStateEnum.Default
	self.MonsterCommonParam.exitFightState = self.MonsterCommonParam.ExitFightStateEnum.Default
	BehaviorFunctions.DoMagic(1,self.MonsterCommonParam.me,900000012)
end


function MonsterMercenaryChase:MercenaryHuntAreaState(isIn)
 	if isIn == true then
		self.targetInForbiddenArea = true
	else
		self.targetInForbiddenArea = false	
		if BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,900000012) then
			BehaviorFunctions.RemoveBuff(self.MonsterCommonParam.me,900000012)
		end
	end
end