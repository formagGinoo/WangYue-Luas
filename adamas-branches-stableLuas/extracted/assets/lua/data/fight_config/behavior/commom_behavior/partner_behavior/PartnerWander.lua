PartnerWander = BaseClass("PartnerWander",EntityBehaviorBase)

function PartnerWander:Init()
    self.runDistance = 4 --跑步距离
    --self.walkDistance = 3 --走路距离
    self.walkBackDistance = 2 --走路距离
    self.walkTime = 2 --走路时间
    self.walkLRTime = 2 --左右走路时间
    self.walkBackTime = 2 --后走路时间
    self.angle = 60 --转身角度
    self.PartnerAllBehavior = self.ParentBehavior
    self.PartnerAllParm = self.MainBehavior.PartnerAllParm
    self.me = self.instanceId
    self.curWalkTime = 0--随机走CD
    self.changeCD = 1  --状态切换CD
    self.changeFrame = 0
end


function PartnerWander:Update()
    --定义主人：若创建者在前台，那他就是主人；若创建者不在前台，则当前操控角色是主人
	if BehaviorFunctions.CheckEntityForeground(BehaviorFunctions.GetEntityOwner(self.me)) then
		self.role = BehaviorFunctions.GetEntityOwner(self.me)
	else
		self.role = BehaviorFunctions.GetCtrlEntity()
	end

	if not BehaviorFunctions.CheckPartnerShow(BehaviorFunctions.GetEntityOwner(self.me)) then
		return
	end
    if not self:CanWander() then
		self.wanderState = 0
		BehaviorFunctions.SetEntityValue(self.me,"wander",false)
        return
    end
    BehaviorFunctions.SetEntityValue(self.me,"wander",true)
    local dis = BehaviorFunctions.GetDistanceFromTarget(self.me, self.PartnerAllParm.ResidentTarget)
    local angle = BehaviorFunctions.GetEntityAngle(self.me, self.PartnerAllParm.ResidentTarget)

    if dis > self.runDistance then
        if self:CanChange() then
            self:ChangeToRun()
        end
		if not BehaviorFunctions.CheckEntityState(self.me,FightEnum.EntityState.Idle) then
        	BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.PartnerAllParm.ResidentTarget,true,0,180,-2)
		end
    elseif dis > self.walkBackDistance then
        if self:CanChange() then
            self:ChangeToRandomWalk()
        end
		if not BehaviorFunctions.CheckEntityState(self.me,FightEnum.EntityState.Idle) then
        	BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.PartnerAllParm.ResidentTarget,true,0,180,-2)
		end
    elseif dis < self.walkBackDistance then
        --if self:CanChange() then
            self:ChangeToWalkBack()
        --end
    end
end

function PartnerWander:ChangeToRun()
    if BehaviorFunctions.GetSubMoveState(self.me) ~= FightEnum.EntityMoveSubState.Run then
        local frame = BehaviorFunctions.GetFightFrame()
        self.changeFrame = frame + self.changeCD * 30
        BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Run)
    end
end

function PartnerWander:ChangeToRandomWalk()
    local frame = BehaviorFunctions.GetFightFrame()
    --self.changeFrame = frame + self.changeCD * 30
    local num = BehaviorFunctions.Random(1,100)
    if self.PartnerAllParm.ResidentSkillCDMark == false and num > 66 then
        BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
        self.changeFrame = frame + self.walkTime * 30
    elseif num > 33 then
        BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkRight)
        self.changeFrame = frame + self.walkLRTime * 30
    else
        BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkLeft)
        self.changeFrame = frame + self.walkLRTime * 30
    end
end

function PartnerWander:ChangeToWalkBack()
	if BehaviorFunctions.GetSubMoveState(self.me) ~= FightEnum.EntityMoveSubState.WalkBack then
	    local frame = BehaviorFunctions.GetFightFrame()
	    self.changeFrame = frame + self.changeCD * 30
	    BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkBack)
	end
end

function PartnerWander:CanChange()
    local frame = BehaviorFunctions.GetFightFrame()
    return frame > self.changeFrame 
end

function PartnerWander:CanWander()
    if self.PartnerAllParm.ResidentTarget and self.PartnerAllParm.ResidentTarget > 0 then
        local dis = BehaviorFunctions.GetDistanceFromTarget(self.me, self.PartnerAllParm.ResidentTarget)
        return BehaviorFunctions.CheckEntity(self.PartnerAllParm.ResidentTarget)
        and self.PartnerAllParm.role > 0
        and BehaviorFunctions.CheckEntity(self.PartnerAllParm.role)
        and BehaviorFunctions.CanCtrl(self.me)
        and not BehaviorFunctions.CheckEntityState(self.me,FightEnum.EntityState.Skill)
        and BehaviorFunctions.CheckPlayerInFight()
        and dis < self.PartnerAllParm.ResidentTargetRange
    end
    
end