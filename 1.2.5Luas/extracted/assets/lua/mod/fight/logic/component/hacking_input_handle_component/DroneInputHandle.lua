---@class DroneInputHandle
DroneInputHandle = BaseClass("DroneInputHandle", BaseInputHandle)

local CollideCheckLayer = FightEnum.LayerBit.Defalut | FightEnum.LayerBit.Entity | FightEnum.LayerBit.EntityCollision | FightEnum.LayerBit.Terrain | FightEnum.LayerBit.Wall | FightEnum.LayerBit.Water
local BuildData = Config.DataBuild.Find

function DroneInputHandle:__init()
    self.tempOffset = Vec3.New()
    self.tempDir = Vec3.New()
    self.flyCheckBox = Vec3.New()
end

---@param fight Fight
---@param entity Entity
function DroneInputHandle:Init(fight, entity, config)
    self.fight = fight
    self.entity = entity
    self.config = config
    self.curDriveId = nil
    self.buttonInput = { x = 0, y = 0 }
    --临时读配置
    for k, v in pairs(BuildData) do
        if self.entity.entityId == v.instance_id then
            self.flyCheckBox:Set(v.size.x, v.size.y, v.size.z)
        end
    end
end

function DroneInputHandle:Hacking()
    self.curDriveId = BehaviorFunctions.GetCtrlEntity()
    self.driver = BehaviorFunctions.GetEntity(self.curDriveId)
    self.driver.stateComponent:SetHackState(FightEnum.HackState.Hacking)
    self:onDrive(self.curDriveId)
end

function DroneInputHandle:StopHacking()
    self:OnStopDrive()
    self.driver.stateComponent:SetHackState(FightEnum.HackState.Waiting)
    self.driver = nil
    self.curDriveId = nil
end

---驾驶
---@param instanceId number 驾驶者实体id
function DroneInputHandle:onDrive(instanceId)
    ---设置玩家位置  + 偏移
    ---设置玩家动作
    ---激活无人机虚拟相机
    BehaviorFunctions.SetCameraState(FightEnum.CameraState.Drone)
    BehaviorFunctions.SetMainTarget(self.entity.instanceId)
    ---打开操作UI
    InputManager.Instance:SwitchActionMap("Drone")
    if self.maxYPos == nil then
        self.maxYPos = self.entity.transformComponent.position.y + self.config.MaxHeight
    end
end

function DroneInputHandle:OnStopDrive()
    InputManager.Instance:SwitchActionMap("Player")
    BehaviorFunctions.SetCameraState(FightEnum.CameraState.Operating)
    BehaviorFunctions.SetMainTarget(self.curDriveId)
end

function DroneInputHandle:ClickUp(down)
    self.buttonInput.y = down and 1 or 0
end

function DroneInputHandle:ClickDown(down)
    self.buttonInput.y = down and -1 or 0
end

function DroneInputHandle:ClickLeft(down)
    self.buttonInput.x = down and -1 or 0
end

function DroneInputHandle:ClickRight(down)
    self.buttonInput.x = down and 1 or 0
end

local zeroInput = { x = 0, y = 0 }
function DroneInputHandle:Update()
    local offsetX, offsetZ
    if not self.entity.moveComponent then
        return
    end
    if self.driver and InputManager.Instance.actionMapName == "Drone" then
        local moveInput = InputManager.Instance.otherMapInputCache.Drone_Move or zeroInput
        local flyInput = InputManager.Instance.otherMapInputCache.Drone_Fly or zeroInput
        if flyInput.x == 0 and flyInput.y == 0 then
            flyInput = self.buttonInput
            if flyInput.x == 0 and flyInput.y == 0 then
                flyInput = {x = FightMainUIView.bgInput.x, y = 0}
            end
        end
        if flyInput.x ~= 0 then
            flyInput.x = flyInput.x > 0 and 1 or -1
        end
        if flyInput.y ~= 0 then
            flyInput.y = flyInput.y > 0 and 1 or -1
        end

        self.tempOffset:Set(moveInput.x * 0.2, flyInput.y * 0.2, moveInput.y * 0.2)
        local move = self.entity.transformComponent.rotation * self.tempOffset
        move.y = flyInput.y * 0.2

        local length = move:Magnitude()

        self.tempDir:SetA(move)
        self.tempDir:SetNormalize()

        ---检测新的位置是否会发生碰撞
        local boxPos = TableUtils.CopyTable(self.entity.transformComponent.position)
        boxPos.y = boxPos.y + self.flyCheckBox.y
        local count, result = CustomUnityUtils.BoxCastNonAllocEntity(boxPos, self.entity.transformComponent.rotation, self.flyCheckBox,
                self.tempDir, length, CollideCheckLayer)

        --当驾驶者跟随目标为自己时 除去驾驶者
        if self.driver.moveComponent.followTarget == self.entity.instanceId and self.entity.transformComponent.position.y < self.driver.transformComponent.position.y then
            for i = 0, count - 1 do
                local collider = result[i].collider
                local name = tonumber(collider.gameObject.name)
                if name == self.curDriveId then
                    count = count - 1
                end
            end
        end

        if count > 1 then
            return
        end
        ---避免侧向移动时下降
        self.entity.moveComponent:SetPositionOffset(move.x, 0, move.z)

        --高度限制
        if self.entity.transformComponent.position.y < self.maxYPos or flyInput.y < 0 then
            self.entity.moveComponent:SetPositionOffset(0, flyInput.y * 0.2, 0)
        end

        ---计算倾斜
        local eulerAngles = self.entity.transformComponent.rotation:ToEulerAngles()
        local eulerX = eulerAngles.x < 90 and eulerAngles.x or eulerAngles.x - 360
        local eulerZ = eulerAngles.z < 90 and eulerAngles.z or eulerAngles.z - 360
        offsetX, offsetZ = moveInput.y, -moveInput.x

        ---自动回正
        if offsetX == 0 then
            if eulerX > 0 then
                offsetX = eulerX < 1 and -eulerX or -1
            elseif eulerX < 0 then
                offsetX = eulerX > -1 and -eulerX or 1
            end
        end

        if offsetZ == 0 then
            if eulerZ > 0 then
                offsetZ = eulerZ < 1 and -eulerZ or -1
            elseif eulerZ < 0 then
                offsetZ = eulerZ > -1 and -eulerZ or 1
            end
        end

        if (eulerZ > 3 and offsetZ > 0) or (eulerZ < -3 and offsetZ < 0) then
            offsetZ = 0
        end
        if (eulerX > 3 and offsetX > 0) or (eulerX < -3 and offsetX < 0) then
            offsetX = 0
        end
        self.entity.rotateComponent:DoRotate(offsetX * 0.5, flyInput.x * 2, offsetZ * 0.5)
    end
end

function DroneInputHandle:OnCache()
    self.fight.objectPool:Cache(DroneInputHandle, self)
end

function DroneInputHandle:__cache()
    self.fight = nil
    self.entity = nil
    self.config = nil
    self.curDriveId = nil
    self.driver = nil
    self.buttonInput = nil
    self.maxYPos = nil

    self.tempOffset:Set()
    self.tempDir:Set()
    self.flyCheckBox:Set()
end

function DroneInputHandle:__delete()

end