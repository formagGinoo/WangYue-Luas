CommonTireBehavior = BaseClass("CommonTireBehavior", BehaviorBase)

local BF = BehaviorFunctions
local Vec3 = Vec3
local Quat = Quat
local zeroInput = { x = 0, y = 0 }
local consoleId = 2080103
function CommonTireBehavior:Init()
end

---@param fight Fight
---@param entity Entity
function CommonTireBehavior:InitConfig(fight, entity, targetVelocity, force, wheelAngle, wheelForce, wheelDistance, differentialVelocity, differentialForce)
    self.fight = fight
    self.entity = entity
    self.isActive = false
    self.targetVelocity = targetVelocity   --目标旋转角速度
    self.force = force   --旋转施加的力
    self.wheelAngle = wheelAngle   --转向时最大偏转角度
    self.wheelForce = wheelForce   --偏转力
    self.wheelDistance = wheelDistance   --最大偏转角度所需距离
    self.differentialVelocity = differentialVelocity   --差速转弯角速度修正
    self.differentialForce = differentialForce   --差速转弯力矩修正

    --当前跟随的操纵杆
    self.curFollowConsole = nil
    self.extraVelocity = 0

    EventMgr.Instance:AddListener(EventName.BuildControlEntity, self:ToFunc("OnBuildControlEntity"))
    self:GetJointComponent()

    self.JointBuildSetting = self.entity.clientTransformComponent.gameObject:GetComponent(JointBuildSetting)
    local body = self.entity.partComponent:GetPart("body")
    for _, collider in pairs(body.colliderList) do
        if collider.collisionType == FightEnum.CollisionType.CylinderMesh and collider.colliderCmp then
            self.JointBuildSetting:SetColliderMaterial(collider.colliderCmp)
        end
    end
end

function CommonTireBehavior:GetJointComponent()
    --轮胎刚体
    local tire = self.entity.clientTransformComponent:GetTransform("Tire")
    self.tireRigidbody = tire:GetComponent(Rigidbody)

    --旋转电机
    local Motor = self.entity.clientTransformComponent:GetTransform("Tire")
    self.motorHingeJoint = Motor:GetComponent(HingeJoint)

    --转向电机
    local steering = self.entity.clientTransformComponent:GetTransform("Motor")
    self.steeringHingeJoint = steering:GetComponent(HingeJoint)
end

function CommonTireBehavior:CalculateDirectionVector()
    --自己的坐标减去连接体的中心点，就是方向向量
    --检查有没有操纵杆，有的话，计算自己在左还是在右
    local centerPos = self.entity.jointComponent:GetJointCenterPoint()
    local selfPos = self.entity.transformComponent.position
    self.self_Vector = (selfPos - centerPos):SetNormalize()

    local forward = self.curFollowConsole.clientTransformComponent.transform.forward
    self.dotProduct = Vec3.Dot(self.self_Vector, forward) > 0 and 1 or -1
    self.crossProduct = Vec3.Cross(self.self_Vector, forward).z > 0 and 1 or -1
end

function CommonTireBehavior:Update()
    --当存在操纵杆时，根据操纵杆的输入，来进行转向和差速处理
    if self.entity.triggerComponent and self.entity.jointComponent and self.entity.jointComponent.jointCtrl then
        local consoleInstanceId = self.entity.jointComponent.jointCtrl:CheckEntityByEntityId(consoleId)
        if consoleInstanceId then
            self.entity.triggerComponent.enabled = false
        else
            self.entity.triggerComponent.enabled = true
        end
    end
    if not self.isActive then
        return
    end
    if self.curFollowConsole then
        local input = self:GetInput()
        --点积判断在几何中心的前后，调整转动方向
        --叉积判断在几何中心的左右，调整转速
        self:SetTireTurn(-input.x,  self.dotProduct,  self.crossProduct)
        self:SetTireMove(-input.y,  self.crossProduct)
    end
end

function CommonTireBehavior:SetTireTurn(input_X, dotProduct, crossProduct)
    if self.last_input_X == input_X then
        return
    end
    self.last_input_X = input_X

    local spring = self.steeringHingeJoint.spring
    spring.spring = self.wheelForce
    spring.damper = 50

    local extraAngle = (input_X * crossProduct) > 0 and 5 or 0
    spring.targetPosition = (self.wheelAngle + extraAngle) * input_X * - dotProduct

    self.steeringHingeJoint.spring = spring

    --改变两侧轮胎转速
    self.extraVelocity = crossProduct * input_X * self.differentialVelocity
end

function CommonTireBehavior:SetTireMove(input_Y)
    local motor = self.motorHingeJoint.motor
    motor.force = self.force
    motor.targetVelocity = (self.targetVelocity + self.extraVelocity) * input_Y
    self.motorHingeJoint.motor = motor
end

function CommonTireBehavior:OnActiveJointEntity(instanceId, isActive)
    if instanceId == self.entity.instanceId then
        self.isActive = isActive
        if self.isActive then
            local consoleInstanceId = self.entity.jointComponent.jointCtrl:CheckEntityByEntityId(consoleId)
            if consoleInstanceId then
                self.curFollowConsole = BF.GetEntity(consoleInstanceId)
                self:CalculateDirectionVector()
                self:SetTurnAxis()
            end
            self:SetTireMove(-1)
        else
            self:SetTireMove(0)
        end
    end
end

--建造控制时，关闭轮胎的刚体的重力
function CommonTireBehavior:OnBuildControlEntity(instanceId, isControl)
    if instanceId ~= self.entity.instanceId then
        return
    end
    self.tireRigidbody.useGravity = not isControl
end


function CommonTireBehavior:SetTurnAxis()
    if not self.curFollowConsole then
        return
    end
    local q = Quat.CreateByUnityQuat(Quaternion.Inverse(self.entity.clientTransformComponent:GetTransform("Steering").rotation))
    local r = q:MulVec3(Vec3.up)
    self.steeringHingeJoint.axis = Vector3(r.x, r.y, r.z)
end

function CommonTireBehavior:GetInput()
    local moveInput = self.fight.operationManager:GetKeyInput(FightEnum.KeyEvent.Drone_Move) or zeroInput
    return moveInput
end

function CommonTireBehavior:OnCache()
    EventMgr.Instance:RemoveListener(EventName.BuildControlEntity, self:ToFunc("OnBuildControlEntity"))
end