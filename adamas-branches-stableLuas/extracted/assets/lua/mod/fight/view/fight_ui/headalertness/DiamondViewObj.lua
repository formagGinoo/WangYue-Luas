DiamondViewObj = BaseClass("DiamondViewObj", PoolBaseClass)

local VisibleType = {
    None = 1,
    ForceShow = 2,
    ForceHide = 3,
}

local Prefab = "Prefabs/UI/Fight/HeadAlertness/DiamondView.prefab"

function DiamondViewObj:__init()

end

function DiamondViewObj:Init(entity, parent, curViewValue, maxViewValue)
    self.clientFight = Fight.Instance.clientFight
    self.entity = entity
    self.clientEntity = self.entity.clientEntity
    self.camera = CameraManager.Instance.mainCameraComponent
    self.forceVisibleType = 0
    self.curViewValue = curViewValue
    self.maxViewValue = maxViewValue
    self.clientTransformTransform = self.clientEntity.clientTransformComponent.transform

    self:InitUI(parent)
    self:InitData()
end

function DiamondViewObj:LateInit()
end

function DiamondViewObj:__delete()
    self:OnObjCache()

    if not UtilsBase.IsNull(self.gameObject) then
        GameObject.Destroy(self.gameObject)
    end

    self.clientEntity = nil
    self.entity = nil
    self.gameObject = nil
end

function DiamondViewObj:Cache()
    self.clientFight.assetsPool:Cache(Prefab, self.gameObject)
    self:OnObjCache()
end

function DiamondViewObj:__cache()
    self.clientEntity = nil
    self.entity = nil
    self.gameObject = nil
end

function DiamondViewObj:SetObjActive(obj, active)
    if not obj then
        return
    end

    if obj.activeSelf ~= active then
        obj:SetActive(active)
    end
end

local DefaultScale = 0.008
function DiamondViewObj:InitUI(parent)
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

    self:SetCurViewValue(self.curViewValue)
end

function DiamondViewObj:Update()
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

function DiamondViewObj:UpdateScale()

end

--Update中使用的变量
function DiamondViewObj:CalcLifeBarPosition(camRotation, entityPosition, entityRotation)
    local barPosition = entityRotation * self.offset
    if self.locationTransform then
        barPosition:Add(self.locationTransform.position)
    end
    return barPosition
end

function DiamondViewObj:UpdateTransform()
    local entityPosition = UtilsBase.GetLuaPosition(self.clientTransformTransform)
    local entityRotation = UtilsBase.GetLuaRotation(self.clientTransformTransform)
    local camRotation = UtilsBase.GetLuaRotation(self.clientFight.cameraManager.mainCamera.transform)

    local barPosition = self:CalcLifeBarPosition(camRotation, entityPosition, entityRotation)
    self:UpdateScale(barPosition)

    UnityUtils.SetPosition(self.transform, entityPosition.x, barPosition.y, entityPosition.z)
    UnityUtils.SetRotation(self.transform, camRotation.x, camRotation.y, camRotation.z, camRotation.w)
end

function DiamondViewObj:SetLifeBarForceVisibleType(visibleType)
    self.forceVisibleType = visibleType
    if self.forceVisibleType == VisibleType.ForceHide then
        self:SetObjActive(self.gameObject, false)
    end
end

function DiamondViewObj:SetCurViewValue(curViewValue)
    self.curViewValue = curViewValue
    local percent = self.curViewValue / self.maxViewValue
    if percent < 0.75 then
        self.YellowBg:SetActive(true)
        self.YellowFrame:SetActive(true)
        self.RedBg:SetActive(false)
        self.RedFrame:SetActive(false)
    else
        self.YellowBg:SetActive(false)
        self.YellowFrame:SetActive(false)
        self.RedBg:SetActive(true)
        self.RedFrame:SetActive(true)
    end
    self.YellowFrame_img.fillAmount = percent
    self.RedFrame_img.fillAmount = percent
end

function DiamondViewObj:PopUITmpObject(name)
    local objectInfo = {}
    if self.uiTmpObjCache and self.uiTmpObjCache[name] then
        local objectInfo = self.uiTmpObjCache[name][1]
        if objectInfo then
            table.remove(self.uiTmpObjCache[name], 1)
            objectInfo.object:SetActive(true)

            return objectInfo
        end
    end

    objectInfo.object = GameObject.Instantiate(self[name])
    objectInfo.objectTransform = objectInfo.object.transform
    return objectInfo, true
end

--重载
function DiamondViewObj:InitData()

end

function DiamondViewObj:LogicUpdate()

end

function DiamondViewObj:Show(isShow)
    if self.forceVisibleType ==  VisibleType.ForceHide then
        self:SetObjActive(self.gameObject, false)
    else
        self:SetObjActive(self.gameObject, isShow)
    end
end

function DiamondViewObj:OnObjCache()
end