ClimbRunMachine = BaseClass("ClimbRunMachine",MachineBase)

function ClimbRunMachine:__init()

end

function ClimbRunMachine:Init(fight,entity,climbFSM)
    self.fight = fight
    self.entity = entity
    self.climbFSM = climbFSM

    self.isClimbRun = false
	EventMgr.Instance:AddListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
	EventMgr.Instance:AddListener(EventName.PlayerPropertyChange, self:ToFunc("PlayerPropertyChange"))
end

function ClimbRunMachine:LateInit()
    if self.entity.clientEntity and self.entity.clientEntity.clientAnimatorComponent then
        self.animator = self.entity.clientEntity.clientAnimatorComponent.animator
    end

    self.climbComponent = self.entity.climbComponent
end

function ClimbRunMachine:OnEnter()
    -- self.speed = BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.ClimbRunSpeed)
    self:CalcSpeed()
    local moveVector = self.fight.operationManager:GetMoveEvent()
    if not moveVector then                                        
        self.climbFSM:SwitchState(FightEnum.EntityClimbState.ClimbRunEnd)   -- 同时按下反方向按键进入攀跑停
        return
    end
    
    moveVector = moveVector.normalized
    self.moveVectorX = moveVector.x or 0
    self.moveVectorY = moveVector.y or 0
    
    if self.moveVectorY < 0 then                                        -- 手柄操作Y轴输入为负时，当作输入为0
        self.moveVectorY = 0
        if moveVector.x == 0 then
            self.moveVectorX = 0                                        
        else
            self.moveVectorX = self.moveVectorX > 0 and 1 or -1         -- 要强制设为-1或者1，不然动作融合会向上
        end
    end

    if self.moveVectorX == 0 and self.moveVectorY == 0 then     -- 只按下S和攀跑按键时，切换跑停逻辑
        self.climbFSM:SwitchState(FightEnum.EntityClimbState.ClimbRunEnd)
        return
    end

    -- 如果X轴输入变换了象限，切换至跑停
    local lastMoveVector = self.climbComponent:GetLastClimbRunVector()
    if lastMoveVector.x < 0 and self.moveVectorX > 0 or lastMoveVector.x > 0 and self.moveVectorX < 0 then
        self.climbFSM:SwitchState(FightEnum.EntityClimbState.ClimbRunEnd)
        return
    end

    if self.animator then
        self.animator:SetFloat("moveVectorX", self.moveVectorX)
        self.animator:SetFloat("moveVectorY", self.moveVectorY)
    end

    if self.moveVectorX ~= 0 then
        self.climbComponent:DoMoveRight(self.moveVectorX * self.speed * FightUtil.deltaTimeSecond)
    end

    if self.moveVectorY > 0 then
        self.climbComponent:DoMoveUp(self.moveVectorY * self.speed * FightUtil.deltaTimeSecond)
    end

    self.climbComponent:UpdateLastClimbRunVector(self.moveVectorX, self.moveVectorY)

    self.climbComponent:SetForceCheckDirection(self.moveVectorX, self.moveVectorY, 0)

    if self.entity.animatorComponent then
        self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbRun)
        --print("ClimbRun")
    end
end

function ClimbRunMachine:Update()
	--LogError("ClimbRun Update: "..self.fight.fightFrame)
    -- 离开攀爬按键
    if self.fight.operationManager:CheckKeyDown(FightEnum.KeyEvent.LeaveClimb) then
        self.entity.stateComponent:SetState(FightEnum.EntityState.Jump, true)
        return
    end

    local moveVector = self.fight.operationManager:GetMoveEvent()
    if not moveVector then
        self.climbFSM:SwitchState(FightEnum.EntityClimbState.ClimbRunEnd)       -- 同时按下反方向按键进入攀跑停
        return
    end

    -- 手柄操作Y轴输入为负时，应该横向奔跑（y轴输入为-1在外部判断）
    moveVector = moveVector.normalized
    self.moveVectorX = moveVector.x or 0
    self.moveVectorY = moveVector.y or 0

    -- 按下攀跳时打断攀跑
    if self.fight.operationManager:CheckJump() then
        if self.moveVectorY < 0 then
            local val = math.abs(self.moveVectorX) / math.abs(self.moveVectorY)
            if math.abs(val) < 1.732 then			-- Y轴负方向正负60°区间内才可退出, tan60
                self.entity.rotateComponent:DoRotate(0, 180, 0)
                self.entity.clientTransformComponent:Async()
                self.entity.stateComponent:SetState(FightEnum.EntityState.Jump, false, true)
                return
            end
        else
            self.climbFSM:SwitchState(FightEnum.EntityClimbState.ClimbJump)	-- 多向攀跳
            return
        end
    end

    if self.moveVectorY < 0 then
        self.moveVectorY = 0
        if moveVector.x == 0 then
            self.moveVectorX = 0                                        -- 要强制设置，不然不会进入下面跑停切换判断
        else
            self.moveVectorX = self.moveVectorX > 0 and 1 or -1         -- 要强制设为-1或者1，不然动作融合会向上
        end
    end

    -- 只按下S和攀跑按键时，切换跑停逻辑
    if self.moveVectorX == 0 and self.moveVectorY == 0 then
        self.climbFSM:SwitchState(FightEnum.EntityClimbState.ClimbRunEnd)
        return
    end

    -- 如果X轴输入变换了象限，切换至跑停
    local lastMoveVector = self.climbComponent:GetLastClimbRunVector()
    if lastMoveVector.x < 0 and self.moveVectorX > 0 or lastMoveVector.x > 0 and self.moveVectorX < 0 then
        self.climbFSM:SwitchState(FightEnum.EntityClimbState.ClimbRunEnd)
        return
    end

    if self.animator then
        self.animator:SetFloat("moveVectorX", self.moveVectorX)
        self.animator:SetFloat("moveVectorY", self.moveVectorY)
    end

    if self.moveVectorX ~= 0 then
        self.climbComponent:DoMoveRight(self.moveVectorX * self.speed * FightUtil.deltaTimeSecond)
    end

    if self.moveVectorY > 0 then
        self.climbComponent:DoMoveUp(self.moveVectorY * self.speed * FightUtil.deltaTimeSecond)
    end

    self.climbComponent:UpdateLastClimbRunVector(self.moveVectorX, self.moveVectorY)

    self.climbComponent:SetForceCheckDirection(self.moveVectorX, self.moveVectorY, 0)
end

function ClimbRunMachine:EntityAttrChange(attrType, entity, oldValue, newValue)
	if not self.isClimbRun or self.entity.instanceId ~= entity.instanceId or attrType ~= EntityAttrsConfig.AttrType.ClimbRunSpeedPercent then
		return
	end

	self:CalcSpeed()
end

function ClimbRunMachine:PlayerPropertyChange(attrType, resultValue, oldValue)
	local ctrlId = Fight.Instance.playerManager:GetPlayer():GetCtrlEntity()
	if not self.isClimbRun or self.entity.instanceId ~= ctrlId or attrType ~= FightEnum.PlayerAttr.ClimbRunSpeedPercent then
		return
	end

	self:CalcSpeed()
end

function ClimbRunMachine:CalcSpeed()
	local player = Fight.Instance.playerManager:GetPlayer()
	local eClimbRunSpeedPercent = self.entity.attrComponent and self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.ClimbRunSpeedPercent) or 0
	self.climbRunSpeedPercent = eClimbRunSpeedPercent + 1
	self.speed = player.fightPlayer:GetBaseAttrValue(FightEnum.PlayerAttr.ClimbRunSpeed) * self.climbRunSpeedPercent
	self.entity.animatorComponent:SetAnimatorSpeed(self.climbRunSpeedPercent)
end

function ClimbRunMachine:OnLeave()
    self.isClimbRun = false
	self.entity.animatorComponent:SetAnimatorSpeed(1)
end

function ClimbRunMachine:CanChangeRole()
    return true
end

function ClimbRunMachine:OnCache()
    EventMgr.Instance:RemoveListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
	EventMgr.Instance:RemoveListener(EventName.PlayerPropertyChange, self:ToFunc("PlayerPropertyChange"))
	self.fight.objectPool:Cache(ClimbRunMachine,self)
end

function ClimbRunMachine:__cache()

end

function ClimbRunMachine:__delete()

end