MonsterAlertnessObj = BaseClass("MonsterAlertnessObj", PoolBaseClass)

local VisibleType = {
    None = 1,
    ForceShow = 2,
    ForceHide = 3,
}

local Prefab = "Prefabs/UI/Fight/HeadAlertness/MonsterQuestionAlertness.prefab"

function MonsterAlertnessObj:__init()

end

function MonsterAlertnessObj:Init(entity, parent, curAlertnessValue, maxAlertnessValue, offset, attachPoint)
    self.clientFight = Fight.Instance.clientFight
    self.entity = entity
    self.clientEntity = self.entity.clientEntity
    self.camera = CameraManager.Instance.mainCameraComponent
    self.forceVisibleType = 0
    self.curAlertnessValue = curAlertnessValue
    self.maxAlertnessValue = maxAlertnessValue
    self.offset = offset
    if not offset then
        self.offset = Vec3.New(0, 0.7, 0)
    end
    self:InitUI(parent)
    if attachPoint then
        self.clientTransformTransform = self.clientEntity.clientTransformComponent:GetTransform(attachPoint)
    else
        self.clientTransformTransform = self.clientEntity.clientTransformComponent:GetTransform("MarkCase")
    end
    self:InitData()

end

function MonsterAlertnessObj:LateInit()
end

function MonsterAlertnessObj:__delete()
    self:OnObjCache()

    if not UtilsBase.IsNull(self.gameObject) then
        GameObject.Destroy(self.gameObject)
    end
    self.clientEntity = nil
    self.entity = nil
    self.gameObject = nil
end

function MonsterAlertnessObj:Cache()
    self.clientFight.assetsPool:Cache(Prefab, self.gameObject)
    self:OnObjCache()
end

function MonsterAlertnessObj:__cache()
    self.clientEntity = nil
    self.entity = nil
    self.gameObject = nil
end

function MonsterAlertnessObj:SetObjActive(obj, active)
    if not obj then
        return
    end

    if obj.activeSelf ~= active then
        obj:SetActive(active)
    end
end

function MonsterAlertnessObj:GetObjActive(obj)
    if not obj then
        return
    end

    return obj.activeSelf
end

local DefaultScale = 0.008
function MonsterAlertnessObj:InitUI(parent)
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

    self:SetCurAlertnessValue(self.curAlertnessValue)
end

function MonsterAlertnessObj:Update()
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

function MonsterAlertnessObj:UpdateScale()

end

--Update中使用的变量
function MonsterAlertnessObj:CalcLifeBarPosition(camRotation, entityPosition, entityRotation)
    local barPosition = entityRotation * self.offset
    if self.locationTransform then
        barPosition:Add(self.locationTransform.position)
    end
    return barPosition
end

function MonsterAlertnessObj:UpdateTransform()
    local entityPosition = UtilsBase.GetLuaPosition(self.clientTransformTransform)
    local entityRotation = UtilsBase.GetLuaRotation(self.clientTransformTransform)
    local camRotation = UtilsBase.GetLuaRotation(self.clientFight.cameraManager.mainCamera.transform)

    -- local barPosition = self:CalcLifeBarPosition(camRotation, entityPosition, entityRotation)
    -- self:UpdateScale(barPosition)

    UnityUtils.SetPosition(self.transform, entityPosition.x + self.offset.x, entityPosition.y + self.offset.y , entityPosition.z + self.offset.z)
    UnityUtils.SetRotation(self.transform, camRotation.x, camRotation.y, camRotation.z, camRotation.w)
end

function MonsterAlertnessObj:SetLifeBarForceVisibleType(visibleType)
    self.forceVisibleType = visibleType
    if self.forceVisibleType == VisibleType.ForceHide then
        self:SetObjActive(self.gameObject, false)
    end
end

function MonsterAlertnessObj:SetCurAlertnessValue(curAlertnessValue)
    self.curAlertnessValue = curAlertnessValue
    local percent = self.curAlertnessValue / self.maxAlertnessValue
    self.percent_img.fillAmount = percent
end

function MonsterAlertnessObj:PopUITmpObject(name)
    local objectInfo = {}

    objectInfo.object = GameObject.Instantiate(self[name])
    objectInfo.objectTransform = objectInfo.object.transform
    return objectInfo, true
end

--重载
function MonsterAlertnessObj:InitData()

end

function MonsterAlertnessObj:LogicUpdate()

end

function MonsterAlertnessObj:Show(isShow)
    if self.forceVisibleType ==  VisibleType.ForceHide then
        self:SetObjActive(self.gameObject, false)
    else
        self:SetObjActive(self.gameObject, isShow)
    end
end

function MonsterAlertnessObj:isShow()
    return self:GetObjActive(self.gameObject)
end

function MonsterAlertnessObj:OnObjCache()
end