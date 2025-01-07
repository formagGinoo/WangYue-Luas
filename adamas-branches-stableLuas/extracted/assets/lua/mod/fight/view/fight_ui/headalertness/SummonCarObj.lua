SummonCarObj = BaseClass("SummonCarObj", PoolBaseClass)

local VisibleType = {
    None = 1,
    ForceShow = 2,
    ForceHide = 3,
}

local Prefab = "Prefabs/UI/Fight/HeadAlertness/CarSummon.prefab"

function SummonCarObj:Init(entity, parent, offset, attachPoint)
    self.clientFight = Fight.Instance.clientFight
    self.entity = entity
    self.clientEntity = self.entity.clientEntity
    self.camera = CameraManager.Instance.mainCameraComponent
    self.forceVisibleType = 0
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

function SummonCarObj:LateInit()
end

function SummonCarObj:__delete()
    self:OnObjCache()

    if not UtilsBase.IsNull(self.gameObject) then
        GameObject.Destroy(self.gameObject)
    end
    self.clientEntity = nil
    self.entity = nil
    self.gameObject = nil
end

function SummonCarObj:Cache()
    self.clientFight.assetsPool:Cache(Prefab, self.gameObject)
    self:OnObjCache()
end

function SummonCarObj:__cache()
    self.clientEntity = nil
    self.entity = nil
    self.gameObject = nil
end

function SummonCarObj:SetObjActive(obj, active)
    if not obj then
        return
    end

    if obj.activeSelf ~= active then
        obj:SetActive(active)
    end
end

function SummonCarObj:GetObjActive(obj)
    if not obj then
        return
    end

    return obj.activeSelf
end

local DefaultScale = 0.008
function SummonCarObj:InitUI(parent)
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
end

function SummonCarObj:Update()
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

function SummonCarObj:UpdateScale()

end

function SummonCarObj:UpdateTransform()
    local entityPosition = UtilsBase.GetLuaPosition(self.clientTransformTransform)
    local entityRotation = UtilsBase.GetLuaRotation(self.clientTransformTransform)
    local camRotation = UtilsBase.GetLuaRotation(self.clientFight.cameraManager.mainCamera.transform)

    UnityUtils.SetPosition(self.transform, entityPosition.x + self.offset.x, entityPosition.y + self.offset.y , entityPosition.z + self.offset.z)
    UnityUtils.SetRotation(self.transform, camRotation.x, camRotation.y, camRotation.z, camRotation.w)
end

function SummonCarObj:PopUITmpObject(name)
    local objectInfo = {}

    objectInfo.object = GameObject.Instantiate(self[name])
    objectInfo.objectTransform = objectInfo.object.transform
    return objectInfo, true
end

--重载
function SummonCarObj:InitData()

end

function SummonCarObj:LogicUpdate()

end

function SummonCarObj:Show(isShow)
    if self.forceVisibleType ==  VisibleType.ForceHide then
        self:SetObjActive(self.gameObject, false)
    else
        self:SetObjActive(self.gameObject, isShow)
    end
    self.isShow = isShow
end

function SummonCarObj:CheckIsShow()
    return self.isShow or false
end

function SummonCarObj:OnObjCache()
end