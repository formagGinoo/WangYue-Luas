ArcAlertnessObj = BaseClass("ArcAlertnessObj", PoolBaseClass)

local VisibleType = {
    None = 1,
    ForceShow = 2,
    ForceHide = 3,
}

local Prefab = "Prefabs/UI/Fight/HeadAlertness/FxMonsterWarning.prefab"

function ArcAlertnessObj:__init()

end

function ArcAlertnessObj:Init(entity, parent, curAlertnessValue, maxAlertnessValue)
    self.clientFight = Fight.Instance.clientFight
    self.entity = entity
    self.clientEntity = self.entity.clientEntity
    self.camera = CameraManager.Instance.mainCameraComponent
    self.forceVisibleType = 0
    self.curAlertnessValue = curAlertnessValue
    self.maxAlertnessValue = maxAlertnessValue

    self:InitUI(parent)
    self:InitData()
end

function ArcAlertnessObj:LateInit()
end

function ArcAlertnessObj:__delete()
    self:OnObjCache()

    if not UtilsBase.IsNull(self.gameObject) then
        GameObject.Destroy(self.gameObject)
    end
    self.clientEntity = nil
    self.entity = nil
    self.gameObject = nil
end

function ArcAlertnessObj:Cache()
    self.clientFight.assetsPool:Cache(Prefab, self.gameObject)
    self:OnObjCache()
end

function ArcAlertnessObj:__cache()
    self.clientEntity = nil
    self.entity = nil
    self.gameObject = nil
end

function ArcAlertnessObj:SetObjActive(obj, active)
    if not obj then
        return
    end

    if obj.activeSelf ~= active then
        obj:SetActive(active)
    end
end

function ArcAlertnessObj:GetObjActive(obj)
    if not obj then
        return
    end

    return obj.activeSelf
end

local DefaultScale = 0.008
function ArcAlertnessObj:InitUI(parent)
    self.gameObject = self.clientFight.assetsPool:Get(Prefab)
    self.transform = self.gameObject.transform
    self.transform:SetParent(parent)
    UnityUtils.SetLocalScale(self.transform, DefaultScale, DefaultScale, DefaultScale)
    UtilsUI.GetContainerObject(self.transform, self)
    self:SetObjActive(self.gameObject, true)
    self.canvas = self.gameObject:GetComponent(Canvas)
    if self.canvas then
        self.canvas.overrideSorting = true
    end
    self.locationTransform = self.clientEntity.clientTransformComponent:GetTransform("MarkCase")
    self.offset = Vec3.New(0.1, 1, 0)

    self:SetCurAlertnessValue(self.curAlertnessValue)
end

function ArcAlertnessObj:Update()
    if not self.clientEntity then
        return
    end
    local forceHide = self.forceVisibleType == VisibleType.ForceHide

    if forceHide or (self.entity.stateComponent and self.entity.stateComponent:IsState(FightEnum.EntityState.Death)) then
        self:SetObjActive(self.gameObject, false)
        return
    end

    -- UnityUtils.BeginSample("ArcAlertnessObj:Update")
    self:LogicUpdate()

    -- UnityUtils.BeginSample("UpdateTransform")
    self:UpdateTransform()
    -- UnityUtils.EndSample()

    --UnityUtils.EndSample()
end

function ArcAlertnessObj:UpdateScale()

end

--Update中使用的变量
function ArcAlertnessObj:CalcLifeBarPosition(camRotation, entityPosition, entityRotation)
    -- UnityUtils.BeginSample("part4")
    local barPosition = entityRotation * self.offset
    if self.locationTransform then
        barPosition:Add(self.locationTransform.position)
    end
    -- UnityUtils.EndSample()
    return barPosition
end

function ArcAlertnessObj:UpdateTransform()
    -------------------------------------------------------
    --一般1、6，耗时比较多且稳定。特殊情况3、4耗时会爆
    -- UnityUtils.BeginSample("part1")
    local entityPosition = UtilsBase.GetLuaPosition(self.clientEntity.clientTransformComponent.transform)
    local entityRotation = UtilsBase.GetLuaRotation(self.clientEntity.clientTransformComponent.transform)
    local camRotation = UtilsBase.GetLuaRotation(self.clientFight.cameraManager.mainCamera.transform)
    -- UnityUtils.EndSample()

    local barPosition = self:CalcLifeBarPosition(camRotation, entityPosition, entityRotation)
    self:UpdateScale(barPosition)
    -- UnityUtils.BeginSample("part5")

    -- UnityUtils.EndSample()
    -- UnityUtils.BeginSample("part6")
    UnityUtils.SetPosition(self.gameObject.transform, entityPosition.x, barPosition.y, entityPosition.z)
    UnityUtils.SetRotation(self.gameObject.transform, camRotation.x, camRotation.y, camRotation.z, camRotation.w)
    -- UnityUtils.EndSample()
end

function ArcAlertnessObj:SetLifeBarForceVisibleType(visibleType)
    self.forceVisibleType = visibleType
    if self.forceVisibleType == VisibleType.ForceHide then
        self:SetObjActive(self.gameObject, false)
    end
end

function ArcAlertnessObj:SetCurAlertnessValue(curAlertnessValue)
    self.curAlertnessValue = curAlertnessValue
    local percent = self.curAlertnessValue / self.maxAlertnessValue
    self.percent_img.fillAmount = percent
end

function ArcAlertnessObj:PopUITmpObject(name)
    local objectInfo = {}

    objectInfo.object = GameObject.Instantiate(self[name])
    objectInfo.objectTransform = objectInfo.object.transform
    return objectInfo, true
end

--重载
function ArcAlertnessObj:InitData()

end

function ArcAlertnessObj:LogicUpdate()

end

function ArcAlertnessObj:Show(isShow)
    if self.forceVisibleType ==  VisibleType.ForceHide then
        self:SetObjActive(self.gameObject, false)
    else
        self:SetObjActive(self.gameObject, isShow)
    end
end

function ArcAlertnessObj:isShow()
    return self:GetObjActive(self.gameObject)
end

function ArcAlertnessObj:OnObjCache()
end