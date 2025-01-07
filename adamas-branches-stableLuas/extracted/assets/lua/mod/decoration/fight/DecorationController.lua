---@class DecorationController
DecorationController = BaseClass("DecorationController")

local BF = BehaviorFunctions
local AllowBuildEffect = 200001005
local SelectedEffect = 200001004
local ControlState = {
    Idle = 1,
    Create = 2,
    Wait = 3,
    Move = 4,
    Joint = 5,
}
local LimitHeight = 0.5
local LimitDifference =0.5
local LimitMinDistance = 10--获取到碰撞z轴的值
local LimitMaxDistance = 16
local epsilon = 22.5  -- 定义一个误差容限
local limitMaxX = 68  -- 边界范围
local limitMinX = 20

local limitMaxZ = -29 
local limitMinZ = -73
local Rounding = function(a)
    if math.abs(a) < epsilon then
        return 0
    end
    local _a = (a / 45) % 1
    if _a > 0.5 or (_a < 0 and _a > -0.5) then
        return math.ceil(a / 45) * 45
    else
        return math.floor(a / 45) * 45
    end
end

function DecorationController:__init()
    self.previewDistanceOffset = 0
    self.previewHeight = 1.5
    self.previewDistance = LimitMinDistance
    self.previewHeightOffset = 0
    self.previewDistanceOffset = 0
    self.curControlEntity = nil
    self.curEntityTransform = nil
    self.curEntityConfig = nil
    self.curType = nil --记录当前的状态类型（1，建造，2，编辑）
    --旋转
    self.curEntityRot_x = 0
    self.curEntityRot_y = 0
    self.curEntityRot_z = 0
    --
    self.firstcount = 0
    self.tempVector3 = Vec3.New()
    self.camera = nil
    self.isRotate = false
end

--加载装修物件
function DecorationController:LoadDecorationEntity(id,type)
    if not self.buildCamera then
        self.buildCamera = CameraManager.Instance:GetCamera(FightEnum.CameraState.Building)
    end
    self.curType = type
    self:InitPreviewBindPoint()
    self:LoadEntityAssets(id)
    self.rotateRecord = { x = 0, y = 0 }
end

function DecorationController:InitLoadEntityAssets()
   
    Fight.Instance.entityManager.partnerDisplayManager:InitDiaplyPartner()
end
--加载模型资源
function DecorationController:LoadEntityAssets(entityId,data,count)
    self.firstcount  = self.firstcount + 1
    if entityId==0 then
        return
    end
    Fight.Instance.clientFight.assetsNodeManager:LoadEntity(entityId, function()
        self:LoadEntityAssetsEnd(entityId)
        if count then
            if  count>=0 then
                self:OnBuild(data,count)
                if self.firstcount == count then
                    Fight.Instance.entityManager.partnerDisplayManager:InitDiaplyPartner()
                    self.firstcount = 0
                end
            elseif  count<0 then
                self:OnBuild(data,count)
            end
        end
    end)
end
--加载后
function DecorationController:LoadEntityAssetsEnd(entityId)
    if not self.buildCamera then
        self.buildCamera = CameraManager.Instance:GetCamera(FightEnum.CameraState.Building)
    end
    local instanceId = BF.CreateEntity(entityId, nil, 0, 0, 0)
    local entity = Fight.Instance.entityManager:GetEntity(instanceId)
    entity.clientTransformComponent:SetLuaControlEntityMove(false)
    BehaviorFunctions.DoMagic(1, entity.instanceId, SelectedEffect)
    local curInstanceId = BF.GetCtrlEntity()
    local selfEntity = BF.GetEntity(curInstanceId)
    local position
    local euler
    if selfEntity then
        position = selfEntity.transformComponent.position+selfEntity.clientTransformComponent.transform.forward*3
        euler = selfEntity.clientTransformComponent.transform.rotation.eulerAngles
    else
        position = entity.transformComponent.position
        euler = entity.clientTransformComponent.transform.rotation.eulerAngles
    end
    --取消实体碰撞
    local obj = entity.clientTransformComponent.gameObject
    mod.DecorationCtrl:SetMeshColliders(obj,false)
    UnityUtils.SetLocalPosition(entity.clientTransformComponent.transform, position.x, position.y, position.z)
    UnityUtils.SetLocalEulerAngles(entity.clientTransformComponent.transform, 0, euler.y, 0)
    self.curControlEntity = entity
    self.curEntityTransform = entity.clientTransformComponent.transform
    --TODO处理初始化放置距离
    local scale = entity.clientTransformComponent.collisionComponent.colliderData.z
    local radius =  entity.clientTransformComponent.collisionComponent.colliderData.radius+2
    LimitMinDistance = scale or radius
    LimitMinDistance = LimitMinDistance -2
    if LimitMinDistance<2 then
        LimitMinDistance = 2
    end
    self.previewDistance = LimitMinDistance
end

function DecorationController:OnBuild(data,count)
    local entity = self.curControlEntity
    if not entity then
        return
    end
    if not mod.DecorationCtrl:IsSaveDecoration(data.id) then
        mod.DecorationCtrl:OnSaveEntity(data,self.curControlEntity)
    end
    mod.DecorationCtrl:BIndEntityAndDecorationInfo(data)
    if count then
        local pos,rot = mod.DecorationCtrl:AnalyPosInfo(data.pos_info)
        UnityUtils.SetPosition(self.curEntityTransform, pos[1],  pos[2], pos[3])
        UnityUtils.SetEulerAngles(self.curEntityTransform, rot[1], rot[2], rot[3])
        if count>0 then
            Fight.Instance.entityManager.partnerDisplayManager:AddDecorationEntity(data.id,self.curControlEntity,data.template_id)
        end
    else
        local pos = self.curEntityTransform.transform.position
        UnityUtils.SetPosition(self.curEntityTransform, pos.x,  pos.y-0.5, pos.z)
    end
    local obj = entity.clientTransformComponent.gameObject
    mod.DecorationCtrl:SetMeshColliders(obj,true)
    BehaviorFunctions.RemoveBuff(entity.instanceId, SelectedEffect)
    self:RemovePreviewBindPoint()
    self.curControlEntity = nil
    self.curEntityTransform = nil
    mod.DecorationCtrl:ClearCurDecorationInfo()
end

--销毁
function DecorationController:OnQuitControl(uniqueId,entity,type)
    if not entity then
        entity = self.curControlEntity
    else
        mod.DecorationCtrl:CancelBindEntityInfo(entity.instanceId)
    end
    if not self.curControlEntity and not entity then
        return
    end
    self:RemovePreviewBindPoint()
    mod.AssetPurchaseCtrl:RemoveDecorationEntity(uniqueId)
    BF.RemoveEntity(entity.instanceId)
    self.controlCount = 0
    self.state = ControlState.Idle
    self.buildCamera:SetCameraDistance(5)
    self.previewDistanceOffset = 0
    self.curControlEntity = nil
    self.curEntityTransform = nil
    if type and type ==DecorationConfig.QuitPanelType.open then
        --打开界面
    else
        Fight.Instance.clientFight.decorationManager:CloseDecorationControlPanel()
    end
end

function DecorationController:OnCancelControl()
    self:RemovePreviewBindPoint()
    BF.RemoveEntity(self.curControlEntity.instanceId)
    self.state = ControlState.Idle
    self.buildCamera:SetCameraDistance(5)
    self.curControlEntity = nil
    self.curEntityTransform = nil
end

--直接抓取实体
function DecorationController:GetDecoration(entity)
    if not self.buildCamera then
        self.buildCamera = CameraManager.Instance:GetCamera(FightEnum.CameraState.Building)
    end
    local obj = entity.clientTransformComponent.gameObject
    mod.DecorationCtrl:SetMeshColliders(obj,false)
    BehaviorFunctions.DoMagic(1, entity.instanceId, SelectedEffect)
    self.state = ControlState.Wait
    self.curControlEntity = entity
    self.curEntityTransform = entity.clientTransformComponent.transform
    entity.clientTransformComponent:SetLuaControlEntityMove(false)
    self:InitPreviewBindPoint()

    local curInstanceId = BF.GetCtrlEntity()
    local roelEntity = BF.GetEntity(curInstanceId)
    local dis = Vector3.Distance(entity.transformComponent.position, roelEntity.transformComponent.position)
    local length = entity.clientTransformComponent.collisionComponent.colliderData.z
    local radius =  entity.clientTransformComponent.collisionComponent.colliderData.radius+2
    local distance = length or radius
    if distance>dis then
       self.previewDistance = distance
       LimitMinDistance = dis-2
    else
       self.previewDistance = dis
       LimitMinDistance = distance-2
    end
    if LimitMinDistance<3 then
       LimitMinDistance = 3
    end
    self.buildCamera:EnterBuildModel()
    self.rotateRecord = { x = 0, y = 0 }
end

function DecorationController:Update()
    if not self.curControlEntity then
        return
    end
    self:TempUpdatePos()
end

function DecorationController:TempUpdatePos()

    local curInstanceId = BF.GetCtrlEntity()
    local entity = BF.GetEntity(curInstanceId)
    local position = entity.transformComponent.position
    local euler = entity.clientTransformComponent.transform.rotation.eulerAngles

    if not self.RotationObj_Y_T or not self.RotationObj_X_T then
        return
    end
    UnityUtils.SetPosition(self.RotationObj_Y_T, position.x, position.y, position.z)
    UnityUtils.SetEulerAngles(self.RotationObj_Y_T, 0, euler.y, 0)

    local screenMoveY = Fight.Instance.clientFight.inputManager.screenMoveY or 0
    self.axis_y_offset = screenMoveY / 50
    self.previewHeight = self.previewHeight + self.axis_y_offset
    UnityUtils.SetLocalPosition(self.RotationObj_X_T, 0, self.previewHeight, self.previewDistance)

    local worldPos = self.RotationObj_X_T.position
    UnityUtils.SetPosition(self.curEntityTransform, worldPos.x, position.y+0.5, worldPos.z)
    
    if self.eulerLerpPercent < 1 then
        self.eulerLerpPercent = self.eulerLerpPercent + 0.1
        local q = Quaternion.Lerp(self.StartQuat, self.targetQuat, self.eulerLerpPercent)
        local lerpEuler = q.eulerAngles

        self.curCanRotate = true
        if lerpEuler.x > 180 then
            lerpEuler.x = lerpEuler.x - 360
        end
        if lerpEuler.y > 180 then
            lerpEuler.y = lerpEuler.y - 360
        end
        if lerpEuler.z > 180 then
            lerpEuler.z = lerpEuler.z - 360
        end
        UnityUtils.SetLocalEulerAngles(self.RotationObj_X_T, lerpEuler.x, lerpEuler.y, lerpEuler.z)
    end
    --self:IsEdge()
    local worldRot =  self.RotationObj_X_T.rotation.eulerAngles
    if worldRot and self.isRotate then
        UnityUtils.SetEulerAngles(self.curEntityTransform, worldRot.x, worldRot.y, worldRot.z)
    end
end

--检测是否可以进行放置
function DecorationController:CheckIsCanPut(ignoreList)
    local result1 =  self:IsCollision(ignoreList)
    local result2 =  self:CheckEdgeRang()
    if result1 and result2 then
        return true
    end
    return false
end

function DecorationController:IsCollision(ignoreList)
    local entityId = self.curControlEntity.entityId
    local instanceId = self.curControlEntity.instanceId
    local position = self.curControlEntity.transformComponent.position
    local size = 0.9
    --TODO临时处理月能采集仪
    if entityId == 2090102 then
        size = 0.3
    end
    self.tempVector3:SetA(position)
    local layer= FightEnum.LayerBit.EntityCollision | FightEnum.LayerBit.Terrain | FightEnum.LayerBit.Wall | FightEnum.LayerBit.Water |FightEnum.LayerBit.NoClimbing |FightEnum.LayerBit.Default
    if not BF.CheckEntityCollideAtPosition(entityId,self.tempVector3.x, self.tempVector3.y+0.2, self.tempVector3.z,ignoreList,instanceId,false,layer,size) then
        MsgBoxManager.Instance:ShowTips(TI18N("当前位置无法放置"))
        return false
    end
    return true
end

--要获取到当前平面的最大最小高度
function DecorationController:IsPlane()
    --高低差<0.5
    local max = 0
    local min = 0
    local difference = max-min
    if difference>LimitDifference then
        MsgBoxManager.Instance:ShowTips(TI18N("当前平面无法放置"))
        return false
    end
    return true
end

function DecorationController:IsEdge(ignoreList)
    local entityId = self.curControlEntity.entityId
    local instanceId = self.curControlEntity.instanceId
    local size = 0.9
    --TODO临时特殊处理月能采集仪
    if entityId == 2090102 then
        size = 0.3
    end
    self.tempVector3:SetA(self.curControlEntity.transformComponent.position)
    local layer= FightEnum.LayerBit.NoClimbing
    local pos = BF.GetOppositePosCollideAtPosition(entityId,self.tempVector3.x, self.tempVector3.y, self.tempVector3.z,ignoreList,instanceId,false,layer,size)
    if pos then
        if pos.x>0 then
            self:SetPreviewPointDistanceOffset(-0.2)
        end
    end
end

function DecorationController:CheckEdgeRang()
    local posx = self.curControlEntity.transformComponent.position.x
    local posz = self.curControlEntity.transformComponent.position.z
    if posx>limitMaxX
    or posx<limitMinX
    or posz>limitMaxZ
    or posz<limitMinZ then
        MsgBoxManager.Instance:ShowTipsImmediate(TI18N("超出边界无法放置"))
        return false
    end
    return true
end

--旋转
function DecorationController:RotatePreviewPoint(rotate, x, y)
    if not self.curControlEntity or not self.RotationObj_X then
        return
    end
    --每次旋转时，记录本地空间下的旋转起始和结束，然后对这个进行插值，然后将插值的变化量变换到世界坐标系，
    self.rotateRecord.x = self.rotateRecord.x + x
    self.rotateRecord.y = self.rotateRecord.y + y
    if self.RotationObj_X_T then
        self.eulerLerpPercent = 0
        self.lastRotate = rotate
        self.targetQuat = rotate * self.targetQuat
        if (x ~= 0 and (self.rotateRecord.x % 2) == 0) or (y ~= 0 and (self.rotateRecord.y % 2) == 0) then
            self.targetQuat = Quaternion.Euler(Rounding(self.targetQuat.eulerAngles.x), Rounding(self.targetQuat.eulerAngles.y), Rounding(self.targetQuat.eulerAngles.z))
        end
        self.StartQuat = self.RotationObj_X_T.localRotation
    end
end

function DecorationController:SetPreviewPointDistanceOffset(value)
    self.previewDistanceOffset = value
    self.previewDistance =self.previewDistance+self.previewDistanceOffset
    if self.previewDistance<LimitMinDistance then
        self.previewDistance =LimitMinDistance
    end
    if self.previewDistance>LimitMaxDistance then
        self.previewDistance =LimitMaxDistance
    end
    if LimitMinDistance < 3 then
        LimitMinDistance = 3
    end
end

function DecorationController:SetPreviewPointHeightOffset(value)
    self.previewHeightOffset = value
    self.previewHeight = self.previewHeight+self.previewHeightOffset
end

function DecorationController:SetDistanceValue()
end
--设置公转自转点位
function DecorationController:InitPreviewBindPoint()
    if not self.RotationObj_Y and not self.RotationObj_X then
        local curInstanceId = BF.GetCtrlEntity()
        local entity = BF.GetEntity(curInstanceId)

        self.RotationObj_Y = GameObject("RotationObj_Y")
        self.RotationObj_Y_T = self.RotationObj_Y.transform

        local position = entity.transformComponent.position
        local euler = entity.clientTransformComponent.transform.rotation.eulerAngles
        UnityUtils.SetPosition(self.RotationObj_Y_T, position.x, position.y, position.z)
        UnityUtils.SetEulerAngles(self.RotationObj_Y_T, 0, euler.y, 0)

        self.RotationObj_X = GameObject("RotationObj_X")
        self.RotationObj_X_T = self.RotationObj_X.transform
        self.RotationObj_X_T:SetParent(self.RotationObj_Y_T)
        UnityUtils.SetLocalPosition(self.RotationObj_X_T, 0, self.previewHeight, self.previewDistance)
        UnityUtils.SetLocalEulerAngles(self.RotationObj_X_T, 0, 0, 0)
        self:SetCameraExtraTarget(self.RotationObj_X_T)
        self.targetQuat = Quaternion.identity
        self.StartQuat = Quaternion.identity

        self.eulerLerpPercent = 0
        self.curCanRotate = true
    end
end

function DecorationController:SetPreViewBindPointPos(pos,rot)
    UnityUtils.SetLocalPosition(self.RotationObj_X_T, pos.x, pos.y, pos.z)
    UnityUtils.SetLocalEulerAngles(self.RotationObj_X_T, 0, rot.y, 0)

end

function DecorationController:RemovePreviewBindPoint()
    if self.RotationObj_Y and self.RotationObj_X then
        self:SetCameraExtraTarget()
        GameObject.Destroy(self.RotationObj_Y)
        GameObject.Destroy(self.RotationObj_X)
        self.RotationObj_Y = nil
        self.RotationObj_Y_T = nil
        self.RotationObj_X = nil
        self.RotationObj_X_T = nil
    end
    self.previewDistance = LimitMinDistance
    self.previewHeight = 1
    self.previewDistanceOffset = 0
    self.previewHeightOffset = 0
end

function DecorationController:SetRotateOff(value)
    self.isRotate = value
end

function DecorationController:SetCameraExtraTarget(target)
    if not target then
        self.buildCamera:RemoveExtraTarget()
    end
    self.buildCamera:SetExtraTarget(target)
end


function DecorationController:__delete()

end