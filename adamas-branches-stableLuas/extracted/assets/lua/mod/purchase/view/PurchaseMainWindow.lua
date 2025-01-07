PurchaseMainWindow = BaseClass("PurchaseMainWindow", BaseWindow)

function PurchaseMainWindow:__init()
    self:SetAsset("Prefabs/UI/Purchase/PurchaseMainWindow.prefab")
    self.typeObjList = {}
end

function PurchaseMainWindow:__BindListener()
    --self:SetHideNode("PurchaseMainWindow_Eixt")
    self:BindCloseBtn(self.CommonBack2_btn, self:ToFunc("Close_HideCallBack"), self:ToFunc("OnBack"))
end

function PurchaseMainWindow:__CacheObject()

end

function PurchaseMainWindow:__Create()

end

function PurchaseMainWindow:__delete()
    self:CacheCurrencyBar()
    self.CommonBack2_btn.onClick:RemoveAllListeners()
end

function PurchaseMainWindow:__ShowComplete()

end
function PurchaseMainWindow:__Hide()
end

function PurchaseMainWindow:__Show()
    local args = self.args or {}
    self.selectType = args._jump and args._jump[1]
    self:CreateTypeList(PurchaseConfig.PurchaseToggleInfo)

    if self.selectType then
        if type(self.selectType) == "string" then
            self.selectType = tonumber(self.selectType)
        end
        self:SelectType(self.selectType)
    end
end

function PurchaseMainWindow:Update()
    if not self.curType then return end
    local curPanel = PurchaseConfig.PagePanel[self.curType]
    local panelClass = self:GetPanel(curPanel)
    if panelClass and panelClass.Update then
        panelClass:Update()
    end
end

function PurchaseMainWindow:GetSubSelectTagIdx()
    if not self.args or not self.args._jump then
        return
    end
    -- 传过来的是shopid
    local selectIdx = self.args._jump[2]
    if type(selectIdx) == "string" then
        selectIdx = tonumber(selectIdx)
    end
    return selectIdx
end

function PurchaseMainWindow:CreateTypeList(tabList)
    for _, typeInfo in pairs(tabList) do
        ---检查系统是否开放
        local isOpen = Fight.Instance.conditionManager:CheckSystemOpen(typeInfo.systemId)
        if not typeInfo.systemId or isOpen then
            if not self.defaultSelect and not self.selectType then
                self.defaultSelect = typeInfo.type
            end
            local typeObj = self:GetTypeObj()
            self:BindRedPoint(PurchaseConfig.PageTypeRedPoint[typeInfo.type], typeObj.Red)
            typeObj.UTypeName_txt.text = typeInfo.name
            typeObj.STypeName_txt.text = typeInfo.name
            typeObj.callback = typeInfo.callback
            --typeObj.checkredpoint = typeInfo.checkredpoint
            --
            if type(typeInfo.icon) == "table" then
                AtlasIconLoader.Load(typeObj.SIcon, typeInfo.icon[1])
                AtlasIconLoader.Load(typeObj.UIcon, typeInfo.icon[2])
            elseif type(typeInfo.icon) == "string" and typeInfo.icon ~= "" then
                local cfg = SystemConfig.GetIconConfig(typeInfo.icon)
                AtlasIconLoader.Load(typeObj.UIcon, cfg.icon1)
                AtlasIconLoader.Load(typeObj.SIcon, cfg.icon2)
            end
            local onToggleFunc = function(isEnter)
                self:OnToggle_Type(typeInfo.type, isEnter)
                if isEnter then
                    self:UpdateCurrencyBarInfo(typeInfo.currencyList)
                end
            end
            local hideCb = function()
                typeObj.Selected:SetActive(false)
            end
            typeObj.SingleType_tog.onValueChanged:RemoveAllListeners()
            typeObj.SingleType_tog.onValueChanged:AddListener(onToggleFunc)
            --typeObj.Selected_HideNode_hcb.HideAction:RemoveAllListeners()
            --typeObj.Selected_HideNode_hcb.HideAction:AddListener(hideCb)
            typeObj.object:SetActive(true)


            --self:InitRedPoint(typeInfo, typeObj)
            self.typeObjList[typeInfo.type] = typeObj
        end
    end
    if self.defaultSelect then
        self:SelectType(self.defaultSelect)
    end
end

function PurchaseMainWindow:SelectType(typeId)
    local typeObj = self.typeObjList[typeId]
    if not typeObj then
        return
    end
    if typeObj.SingleType_tog.isOn == true then
        self:OnToggle_Type(typeId, true)
    end
    typeObj.SingleType_tog.isOn = true
end

function PurchaseMainWindow:OnToggle_Type(typeId, isEnter)
    self.curType = typeId
    local typeObj = self.typeObjList[typeId]
    if not typeObj then
        return
    end

    if isEnter then
        typeObj.Selected:SetActive(true)
        --typeObj.Selected_ShowNode:SetActive(false)
        typeObj.UnSelect:SetActive(false)
    else
        typeObj.Selected:SetActive(false)
        --typeObj.Selected_HideNode:SetActive(false)
        typeObj.UnSelect:SetActive(true)
    end

    typeObj.callback(self, typeObj.SingleType_tog.isOn)
end

--更新货币栏
function PurchaseMainWindow:UpdateCurrencyBarInfo(CurrencyList)
    if not CurrencyList then
        return
    end
    for i = 1, 3 do
        local uiName = "CurrencyBar_" .. i
        local objName = "CurrencyBar" .. i
        if CurrencyList[i] and CurrencyList[i] ~= 0 then
            self[uiName]:SetActive(true)
            if self[objName] then
                self[objName]:ChangeCurrencyId(CurrencyList[i])
            else
                self[objName] = Fight.Instance.objectPool:Get(CurrencyBar)
                self[objName]:init(self[uiName], CurrencyList[i])
            end
        else
            self[uiName]:SetActive(false)
        end
    end
end

--缓存货币栏
function PurchaseMainWindow:CacheCurrencyBar()
    for i = 1, 3 do
        local objName = "CurrencyBar" .. i
        if self[objName] then
            self[objName]:OnCache()
            self[objName] = nil
        end
    end
end

--设置倒计时
function PurchaseMainWindow:SetCountDown(text, timestamp)

end

function PurchaseMainWindow:GetTypeObj()
    local obj = self:PopUITmpObject("SingleType")
    if self.closeSound then
        obj.SingleType_sound.notActive = true
    else
        obj.SingleType_sound.notActive = false
    end
    obj.objectTransform:SetParent(self.TypeList.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    return obj
end

function PurchaseMainWindow:OnBack()

end

function PurchaseMainWindow:Close_HideCallBack()
    WindowManager.Instance:CloseWindow(self)
end