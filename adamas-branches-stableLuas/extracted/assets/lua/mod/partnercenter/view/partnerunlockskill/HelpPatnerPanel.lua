HelpPatnerPanel = BaseClass("HelpPatnerPanel", BasePanel)

function HelpPatnerPanel:__init()
    self:SetAsset("Prefabs/UI/AttendantCenter/HelpPatnerPanel.prefab")

end

function HelpPatnerPanel:__delete()

end

function HelpPatnerPanel:__BindListener()

end

function HelpPatnerPanel:__Create()

end

function HelpPatnerPanel:__Show()
    self.nightMareMainItem={}
    self.rewardItemObjs={}
    self.typeObjList={}
    
    for i=1,3 ,1  do
        local typeObj = self:GetTypeObj()
        self:UpdateActivityItem(typeObj,i,self.args)
        self.typeObjList[i] = typeObj
        self:UpdatePrimaryContent(i,self.args)
    end
end

function HelpPatnerPanel:UpdatePrimaryContent(idx,data)
    local obj=self.typeObjList[idx]
    --obj.name_txt.text=data.name
end

function HelpPatnerPanel:GetTypeObj()
    local obj = self:PopUITmpObject("SingleType")
    obj.objectTransform:SetParent(self.Content.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    UnityUtils.SetActive(obj.object,true)
    return obj
end

function HelpPatnerPanel:UpdateActivityItem(typeObj,idx,typeInfo)

    typeObj.callback = typeInfo.callback

    local onToggleFunc = function(isEnter)
        self:OnToggle_Type(idx, isEnter)
    end

    typeObj.SingleType_tog.isOn = false
    typeObj.SingleType_tog.onValueChanged:RemoveAllListeners()
    typeObj.SingleType_tog.onValueChanged:AddListener(onToggleFunc)

end

function HelpPatnerPanel:OnToggle_Type(typeId, isEnter)
    self.curType = typeId
    local typeObj = self.typeObjList[typeId]
    if not typeObj then
        return
    end

    if isEnter then
        typeObj.choose:SetActive(true)
    else
        typeObj.choose:SetActive(false)
    end

    typeObj.callback(isEnter,typeId)
end

function HelpPatnerPanel:SelectType(typeId)
    local typeObj = self.typeObjList[typeId]
    if typeObj then
        self.curType = typeId
        typeObj.SingleType_tog.isOn = true
    end
end

function HelpPatnerPanel:__Hide()

end



