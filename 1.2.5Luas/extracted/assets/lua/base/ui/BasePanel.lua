-- 面板
-- 一般情况下Panel依附于window，由window控制其生命周期
-- @author huangyq
---@class BasePanel : BaseView
BasePanel = BaseClass("BasePanel",BaseView)

function BasePanel:__init()
    -- 父对象，一般情况下是BaseWindow对象
    self.parentWindow = nil
    self.viewType = ViewType.Panel
    self.cacheMode = UIDefine.CacheMode.destroy
end

function BasePanel:__delete()

end

function BasePanel:__BaseCreate()
    self.parentCanvas = nil
    if self.parentWindow then
        self.parentCanvas = self.parentWindow.transform:GetComponent(Canvas)
    end

    self:SetUIAdapt()
    ---@type CS.UnityEngine.Canvas
    self.canvas = self:Find(nil, Canvas)
    self.canvas.overrideSorting = true
    self.canvas.sortingOrder = self.parentCanvas and self.parentCanvas.sortingOrder + 2 or WindowManager.Instance:GetMaxOrderLayer()
end

function BasePanel:SetUIAdapt()
    if Application.platform ~= RuntimePlatform.Android and Application.platform ~= RuntimePlatform.IPhonePlayer then
        return
    end

    local container = self.transform:Find("Content")
    if not container then
        container = self.transform
    end

    local uiAdaptor = self.transform:GetComponent(UIAdaptor)
    local offset = 80
    if uiAdaptor then
        offset = offset + (uiAdaptor.ExtraOffset * 2)
    end

    if self.parentWindow then
        local parentAdaptor = self.parentWindow.transform:GetComponent(UIAdaptor)
        if parentAdaptor then
            offset = offset + (parentAdaptor.ExtraOffset * 2)
        end
    else
        UnityUtils.SetSizeDelata(container, container.sizeDelta.x - offset, container.sizeDelta.y)
    end

    if uiAdaptor then
        if uiAdaptor.AdaptorObjList then
            for k, v in pairs(uiAdaptor.AdaptorObjList) do
                if v then 
                    UnityUtils.SetSizeDelata(v, v.sizeDelta.x + offset, v.sizeDelta.y)
                end
            end
        end

        if uiAdaptor.LeftObjList then
            for k, v in pairs(uiAdaptor.LeftObjList) do
                UnityUtils.SetSizeDelata(v, v.sizeDelta.x + offset, v.sizeDelta.y)
                UnityUtils.SetLocalPosition(v, v.localPosition.x - (offset / 2), v.localPosition.y, v.localPosition.z)
            end
        end

        if uiAdaptor.RightObjList then
            for k, v in pairs(uiAdaptor.RightObjList) do
                UnityUtils.SetSizeDelata(v, v.sizeDelta.x + offset, v.sizeDelta.y)
                UnityUtils.SetLocalPosition(v, v.localPosition.x + (offset / 2), v.localPosition.y, v.localPosition.z)
            end
        end
    end
end

function BasePanel:__BaseShow()
    self:SetParent(self.parentWindow and self.parentWindow.transform or UIDefine.canvasRoot.transform)
end

function BasePanel:CloseComplete()
    if self.cacheMode == UIDefine.CacheMode.destroy then
        self:Destroy()
    elseif self.cacheMode == UIDefine.CacheMode.hide then
        self:HideHandle()
    end
end

function BasePanel:SetCavansLayer(layer)
    local curLayer = WindowManager.Instance:GetCurOrderLayer()
    if (self.canvas.sortingOrder - layer == curLayer) or (self.canvas.sortingOrder == curLayer)then
        return
    end
    self.canvas.sortingOrder = self.parentCanvas and self.parentCanvas.sortingOrder + layer or WindowManager.Instance:GetMaxOrderLayer() + layer
end

function BasePanel:SetCacheMode(cacheMode)
    self.cacheMode = cacheMode or UIDefine.CacheMode.destroy
end
--判断其被window创建时是否受键盘等输入控制
function BasePanel:SetAcceptInput(accept)
    self._acceptInput = accept
end

function BasePanel:IsAcceptInput()
    return self._acceptInput or false
end

function BasePanel:SelfUpdate()
    return false
end
