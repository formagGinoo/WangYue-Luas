PurchaseRecommendPanel = BaseClass("PurchaseRecommendPanel", BasePanel)

function PurchaseRecommendPanel:__init()
    self:SetAsset("Prefabs/UI/Purchase/PurchaseRecommendPanel.prefab")
    self.typeObjList = {}
end

function PurchaseRecommendPanel:__BindListener()
    --self:SetHideNode("PurchaseRecommendPanel_Eixt")
    -- self:BindCloseBtn(self.CommonBack2_btn, self:ToFunc("Close_HideCallBack"), self:ToFunc("OnBack"))
end

function PurchaseRecommendPanel:__CacheObject()

end

function PurchaseRecommendPanel:__Create()
    self.defaultSelect = 1
    self:CreateTypeList(PurchaseConfig.PurchaseRecommendToggleInfo)
    local args = self.args or {}
    local selectType = args._jump and args._jump[1]
    if selectType then
        selectType = tonumber(selectType)
        self.tabPanel:SelectType(selectType)
    end
end

function PurchaseRecommendPanel:__delete()

end

function PurchaseRecommendPanel:__ShowComplete()
    if self.curType then
        self:SelectType(self.curType)
    end

end
function PurchaseRecommendPanel:__Hide()
    if self.curType then
        self.typeObjList[self.curType].callback(self, false)
    end
end

function PurchaseRecommendPanel:__Show()
    
end

function PurchaseRecommendPanel:SelectType(typeId)
    local typeObj = self.typeObjList[typeId]
    if typeObj then
        if typeObj.SingleType_tog.isOn == true then
            self:OnToggle_Type(typeId, true)
        end
        typeObj.SingleType_tog.isOn = true
    end
end

function PurchaseRecommendPanel:CreateTypeList(tabList)
    for _, typeInfo in pairs(tabList) do
        ---检查系统是否开放
        local isOpen = Fight.Instance.conditionManager:CheckSystemOpen(typeInfo.systemId)
        if not typeInfo.systemId or isOpen then
            local typeObj = self:GetTypeObj()
            typeObj.UTypeName_txt.text = typeInfo.name
            typeObj.STypeName_txt.text = typeInfo.name
            typeObj.callback = typeInfo.callback
            local onToggleFunc = function(isEnter)
                self:OnToggle_Type(typeInfo.type, isEnter)
            end
            local hideCb = function()
                typeObj.Selected:SetActive(false)
            end
            typeObj.SingleType_tog.onValueChanged:RemoveAllListeners()
            typeObj.SingleType_tog.onValueChanged:AddListener(onToggleFunc)
            typeObj.object:SetActive(true)

            self.typeObjList[typeInfo.type] = typeObj
        end
    end
    if self.defaultSelect then
        self:SelectType(self.defaultSelect)
    end
end

function PurchaseRecommendPanel:OnToggle_Type(typeId, isEnter)
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

function PurchaseRecommendPanel:GetTypeObj()
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
