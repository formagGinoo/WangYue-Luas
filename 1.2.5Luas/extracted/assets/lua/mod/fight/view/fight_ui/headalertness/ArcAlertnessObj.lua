ArcAlertnessObj = BaseClass("ArcAlertnessObj", PoolBaseClass)

local VisibleType = {
    None = 1,
    ForceShow = 2,
    ForceHide = 3,
}

local Prefab = "Prefabs/UI/Fight/HeadAlertness/ArcAlertness.prefab"

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

    self.clientTransformTransform = self.clientEntity.clientTransformComponent.transform

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
    self.offset = Vec3.New(0.1, 0.5, 0)

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

    self:LogicUpdate()
    self:UpdateTransform()
end

function ArcAlertnessObj:UpdateScale()

end

--Update中使用的变量
function ArcAlertnessObj:CalcLifeBarPosition(camRotation, entityPosition, entityRotation)
    local barPosition = entityRotation * self.offset
    if self.locationTransform then
        barPosition:Add(self.locationTransform.position)
    end
    return barPosition
end

function ArcAlertnessObj:UpdateTransform()
    local entityPosition = UtilsBase.GetLuaPosition(self.clientTransformTransform)
    local entityRotation = UtilsBase.GetLuaRotation(self.clientTransformTransform)
    local camRotation = UtilsBase.GetLuaRotation(self.clientFight.cameraManager.mainCamera.transform)

    local barPosition = self:CalcLifeBarPosition(camRotation, entityPosition, entityRotation)
    self:UpdateScale(barPosition)

    UnityUtils.SetPosition(self.transform, entityPosition.x, barPosition.y, entityPosition.z)
    UnityUtils.SetRotation(self.transform, camRotation.x, camRotation.y, camRotation.z, camRotation.w)
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
    if percent < 0.75 then
        self.YellowFiller:SetActive(true)
        self.RedFiller:SetActive(false)
    else
        self.YellowFiller:SetActive(false)
        self.RedFiller:SetActive(true)
    end

    UnityUtils.SetLocalEulerAngles(self.Light_rect, 0, 0, 38 - 76 * percent)

    self.Mask_img.fillAmount = 0.21 + percent * 0.58
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