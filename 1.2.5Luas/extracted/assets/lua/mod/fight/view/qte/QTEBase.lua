---@class QTEBase
QTEBase = BaseClass("QTEBase", BaseView)
---@class QTEBaseParams
---@field instanceId
---@field prefab
---@field icon
---@field anchorType
---@field posX
---@field posY
---@field duration

function QTEBase:__init()

end

function QTEBase:Reset(qteId, setting)
    ---@type QTEBaseParams
    self.setting = setting
    self.qteId = qteId
    self.remainingTime = self.setting.duration
    self.onHide = false
    self.isPause = false
    self.effectCache = self.effectCache or {}

    self:__Reset()
end

-------------------------------------- 这里开始根据需要重写 -------------------------------------------------------
function QTEBase:__Reset()
end

function QTEBase:onShow()
    --self.Button_btn.onClick:AddListener(self:ToFunc("OnClick_QTE"))
end

function QTEBase:onDelete()
end

function QTEBase:OnExitQTE(isSuccess)
end

-------------------------------------- 一般不需要重写 -------------------------------------------------------
function QTEBase:__Show()
    self:ResetQTEUI()
    self:CallEntityBehavior("EnterQTE", FightEnum.NewQTEType.Click, self.qteId)
    self:onShow()
end

function QTEBase:onCache()
    TableUtils.ClearTable(self.effectCache)
    self:__onCache()
    self:Hide()
end

function QTEBase:BeforeUpdate(deltaTime)
    if self.onHide or self.isPause then
        return
    end
    self.lastRemainingTime = self.remainingTime
    self.remainingTime = self.remainingTime - deltaTime
    if self.remainingTime <= 0 then
        self.onHide = true
        self:OnExitQTE(false)
    end
    self:_BeforeUpdate(deltaTime)
end

--function QTEBase:ChangeQTETime(deltaTime)
--    self.lastRemainingTime = self.remainingTime
--    self.remainingTime = self.remainingTime + deltaTime
--    if self.remainingTime <= 0 then
--        self:ExitQTE(false)
--    end
--end

function QTEBase:ResetQTEUI()
    if self.setting.anchorType then
        self:SetAnchorType(self.setting.anchorType)
        UnityUtils.SetAnchoredPosition(self.QTE.transform, self.setting.posX, self.setting.posY)
    end
end

function QTEBase:CallEntityBehavior(name, ...)
    Fight.Instance.entityManager:CallBehaviorFun(name, ...)
end

function QTEBase:SetAnchorType(anchorType)
    if anchorType == FightEnum.QTEAnchorType.LeftTop then
        UnityUtils.SetAnchorMinAndMax(self.QTE.transform, 0, 1, 0, 1)
    elseif anchorType == FightEnum.QTEAnchorType.LeftBottom then
        UnityUtils.SetAnchorMinAndMax(self.QTE.transform, 0, 0, 0, 0)
    elseif anchorType == FightEnum.QTEAnchorType.RightTop then
        UnityUtils.SetAnchorMinAndMax(self.QTE.transform, 1, 1, 1, 1)
    elseif anchorType == FightEnum.QTEAnchorType.RightBottom then
        UnityUtils.SetAnchorMinAndMax(self.QTE.transform, 1, 0, 1, 0)
    else
        UnityUtils.SetAnchorMinAndMax(self.QTE.transform, 0.5, 0.5, 0.5, 0.5)
    end
end

function QTEBase:PlayEffect(effectName, parentName, position)
    local name = parentName
    if not self[parentName] then
        LogError("指定的 parentName 不存在 :" .. parentName)
        return
    end
    self.effectCache[name] = self.effectCache[name] or {}
    local effectInfo = self.effectCache[name][effectName]
    if not effectInfo then
        if not self[effectName] then
            LogError("指定的 effectName 不存在 :" .. effectName)
        end

        local object = GameObject.Instantiate(self[effectName])
        local transform = object.transform

        transform:SetParent(self[parentName].transform)
        transform:ResetAttr()

        if position then
            CustomUnityUtils.SetLocalPosition(transform, position[1], position[2], position[3])
        end

        effectInfo = { object = object, visible = true }
        self.effectCache[name][effectName] = effectInfo
    end

    local toScale = 1
    UnityUtils.SetLocalScale(effectInfo.object.transform, toScale, toScale, toScale)
    effectInfo.object:SetActive(false)
    effectInfo.object:SetActive(true)
    effectInfo.visible = true
end

function QTEBase:StopEffect(effectName, parentName)
    local name = parentName
    self.effectCache[name] = self.effectCache[name] or {}
    local effectInfo = self.effectCache[name][effectName]
    if not effectInfo then
        return
    end

    if not effectInfo.visible then
        return
    end

    effectInfo.object:SetActive(false)
    effectInfo.visible = false
end

function QTEBase:StopAllEffect()
    for _, node in pairs(self.effectCache) do
        for _, effectInfo in pairs(node) do
            GameObject.Destroy(effectInfo.object)
        end
    end
end

function QTEBase:_BeforeUpdate(deltaTime)
end

function QTEBase:SetObjActive(obj, active)
    if not obj then return end

    if obj.activeSelf ~= active then
        obj:SetActive(active)
    end
end