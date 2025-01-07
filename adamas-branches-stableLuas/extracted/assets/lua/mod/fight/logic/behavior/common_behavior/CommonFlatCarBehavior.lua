CommonFlatCarBehavior = BaseClass("CommonFlatCarBehavior", BehaviorBase)
local BF = BehaviorFunctions
local zeroInput = { x = 0, y = 0 }
local function SetSpringParam(wheel, angle)
    local spring = wheel.spring
    spring.spring = 4000
    spring.damper = 50
    spring.targetPosition = angle
    wheel.spring = spring
end

function CommonFlatCarBehavior:Init()
end

---@param fight Fight
---@param entity Entity
function CommonFlatCarBehavior:InitConfig(fight, entity, targetVelocity, force, turnAngle)
    self.fight = fight
    self.entity = entity
    self.isActive = false
    self.targetVelocity = targetVelocity or 300   --目标旋转角速度
    self.force = force or 1000  --旋转施加的力
    self.turnAngle = turnAngle or 20  --旋转角度
    self.leftExtraVelocity = 0
    self.rightExtraVelocity = 0

    self.leftFrontSteering = self.entity.clientTransformComponent:GetTransform("LeftFrontSteering"):GetComponent(HingeJoint)
    self.rightFrontSteering = self.entity.clientTransformComponent:GetTransform("RightFrontSteering"):GetComponent(HingeJoint)
    self.leftRearSteering = self.entity.clientTransformComponent:GetTransform("LeftRearSteering"):GetComponent(HingeJoint)
    self.rightRearSteering = self.entity.clientTransformComponent:GetTransform("RightRearSteering"):GetComponent(HingeJoint)

    self.leftFrontWheel = self.entity.clientTransformComponent:GetTransform("LeftFrontWheel"):GetComponent(HingeJoint)
    self.rightFrontWheel = self.entity.clientTransformComponent:GetTransform("RightFrontWheel"):GetComponent(HingeJoint)
    self.leftRearWheel = self.entity.clientTransformComponent:GetTransform("LeftRearWheel"):GetComponent(HingeJoint)
    self.rightRearWheel = self.entity.clientTransformComponent:GetTransform("RightRearWheel"):GetComponent(HingeJoint)

    self.BigTireUtilCmp = self.entity.clientTransformComponent.gameObject:GetComponent(BigTireUtil)
    local body = self.entity.partComponent:GetPart("body")
    for _, collider in pairs(body.colliderList) do
        if collider.collisionType == FightEnum.CollisionType.CylinderMesh and collider.colliderCmp then
            self.BigTireUtilCmp:SetColliderMaterial(collider.colliderCmp)
        end
    end
end

function CommonFlatCarBehavior:Update()
    if self.isActive then
        --获取按键输入，按输入方向
        local input = self:GetInput()
        self:SetFlatCarMove(input.y)
        self:SetFlatCarTurn(input.x)
    end
end

function CommonFlatCarBehavior:OnActiveJointEntity(instanceId, isActive)
    if instanceId == self.entity.instanceId then
        self.isActive = isActive
        if not self.isActive then
            self:SetFlatCarMove(0)
        end
    end
end

function CommonFlatCarBehavior:OnConsoleActive(console_instanceId, isActive)
    if not self.JointComponent:CheckEntityHasJoint(console_instanceId) then
        return
    end

    self.isActive = isActive
    if not self.isActive then
        self:SetFlatCarMove(0)
    end
end

function CommonFlatCarBehavior:SetFlatCarMove(input_Y)
    if self.last_input_Y == input_Y and not self.onTurnChangeFrame then
        return
    end
    self.onTurnChangeFrame = false
    self.last_input_Y = input_Y

    local leftMotor = self.leftFrontWheel.motor
    leftMotor.force = input_Y == 0 and 0 or self.force
    leftMotor.targetVelocity = (self.targetVelocity + self.leftExtraVelocity) * input_Y
    self.leftFrontWheel.motor = leftMotor
    self.leftRearWheel.motor = leftMotor

    local rightMotor = self.leftFrontWheel.motor
    rightMotor.force = input_Y == 0 and 0 or self.force
    rightMotor.targetVelocity = (self.targetVelocity + self.rightExtraVelocity) * input_Y
    self.rightFrontWheel.motor = rightMotor
    self.rightRearWheel.motor = rightMotor
end

function CommonFlatCarBehavior:SetFlatCarTurn(input_X)
    if self.last_input_X == input_X then
        return
    end
    self.last_input_X = input_X

    --改变轮胎朝向
    local angle = self.turnAngle * input_X
    local AngleDiff = 5 * input_X --阿克曼角
    SetSpringParam(self.leftFrontSteering, angle + AngleDiff)
    SetSpringParam(self.rightFrontSteering, angle)
    SetSpringParam(self.leftRearSteering, -angle - AngleDiff)
    SetSpringParam(self.rightRearSteering, -angle)

    --改变两侧轮胎转速
    self.leftExtraVelocity = input_X * 10
    self.rightExtraVelocity = -input_X * 10
    self.onTurnChangeFrame = true
end

function CommonFlatCarBehavior:GetInput()
    local moveInput = Fight.Instance.operationManager:GetKeyInput(FightEnum.KeyEvent.Drone_Move) or zeroInput
    return moveInput
end