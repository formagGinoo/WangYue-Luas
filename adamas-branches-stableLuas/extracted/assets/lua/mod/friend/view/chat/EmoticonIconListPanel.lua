EmoticonIconListPanel = BaseClass("EmoticonIconListPanel", BasePanel)


function EmoticonIconListPanel:__init()
	self:SetAsset("Prefabs/UI/Friend/EmoticonIconListPanel.prefab")
    self.groupObjList = {}
    -- self.iconList = {}
end

function EmoticonIconListPanel:__BindListener()
    -- self:SetHideNode("EmoticonIconListPanel_Eixt")
    EventMgr.Instance:AddListener(EventName.FriendRemove, self:ToFunc("OnFriendRemove"))
    self:BindCloseBtn(self.BgBtn_btn,self:ToFunc("Close_HideCallBack"),self:ToFunc("OnBack"))
end

function EmoticonIconListPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function EmoticonIconListPanel:__Create()
end

function EmoticonIconListPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.FriendRemove, self:ToFunc("OnFriendRemove"))
end

function EmoticonIconListPanel:__ShowComplete()

end
function EmoticonIconListPanel:__Hide()

end

function EmoticonIconListPanel:__Show()
    self.groupConfig = FriendConfig.GetMemeGroup()
    local args = self.args or {}
    self.selectGroup = args._jump and args._jump[1]

    self.EmotionGroupList = {}
    for _, groupInfo in pairs(self.groupConfig) do
        if mod.FriendCtrl:CheckMemeByGroupId(groupInfo.id) then 
            table.insert(self.EmotionGroupList, {
                id = groupInfo.id,
                info = groupInfo,
            })
        end
    end
    self:CreateEmotionGroupList(self.EmotionGroupList)
end

function EmoticonIconListPanel:OnBack()

end

function EmoticonIconListPanel:SetIconItemObjInfo(obj)
    
end

function EmoticonIconListPanel:GetIconObj()
    local obj = self:PopUITmpObject("IconItem")
    obj.objectTransform:SetParent(self.IconContent.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    return obj
end

function EmoticonIconListPanel:SetTypeItemObjInfo(groupObj, groupInfo)
    SingleIconLoader.Load(groupObj.TypeIcon, groupInfo.info.meme)
end

function EmoticonIconListPanel:SetIconObjInfo(obj, info)
    UtilsUI.SetActive(obj.object, false)
    SingleIconLoader.Load(obj.EmoticonIcon, info.meme, function()
        UtilsUI.SetActive(obj.object, true)
    end)
    obj.EmoticonIcon_btn.onClick:RemoveAllListeners()
    obj.EmoticonIcon_btn.onClick:AddListener(function()
        local window = WindowManager.Instance:GetWindow("ChatMainWindow")
        if not window then return end
        window:OnClick_SendEmotionChat(info)
        self:Close_HideCallBack()
    end)
end

function EmoticonIconListPanel:GetTypeObj()
    local obj = self:PopUITmpObject("TypeItem")
    obj.objectTransform:SetParent(self.TypeContent.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    return obj
end

function EmoticonIconListPanel:CreateEmotionGroupList(tabList)
    for _, groupInfo in pairs(tabList) do
        if groupInfo.info.meme == "" then
            return
        end
        if not self.defaultSelect and not self.selectGroup then
            self.defaultSelect = groupInfo.id
        end
        local groupObj = self:GetTypeObj()
        groupObj.callback = self:ToFunc("OnSelectGroup")
        groupObj.info = groupInfo
        self:SetTypeItemObjInfo(groupObj, groupInfo)
        local onToggleFunc = function(isEnter)
            self:OnToggle_EmoGroup(groupInfo.id, isEnter)
        end

        groupObj.TypeItem_tog.onValueChanged:RemoveAllListeners()
        groupObj.TypeItem_tog.onValueChanged:AddListener(onToggleFunc)
        groupObj.object:SetActive(true)
        self.groupObjList[groupInfo.id] = groupObj
    end
    if self.defaultSelect then
        self:SelectGroup(self.defaultSelect)
        self:OnToggle_EmoGroup(self.groupObjList[self.defaultSelect], true)
    end
end

function EmoticonIconListPanel:OnSelectGroup(parent, isSelect)
    if isSelect then
        self:PushAllUITmpObject("IconItem", self.IconItemCacheNode_rect)
        if not self.curGroupId then
            return
        end
        for k, info in pairs(FriendConfig.GetMemeListByGroupId(self.curGroupId)) do
            if mod.FriendCtrl:CheckMemeByMemeId(info.id) == true then
                local obj = self:GetIconObj()
                self:SetIconObjInfo(obj, info)
            end
        end
    else
        
    end
end

function EmoticonIconListPanel:SelectGroup(groupId)
    local groupObj = self.groupObjList[groupId]
    if not groupObj then
        return
    end
    if groupObj.TypeItem_tog.isOn == true then
        self:OnToggle_EmoGroup(groupId, true)
    end
    groupObj.TypeItem_tog.isOn = true
end

function EmoticonIconListPanel:OnToggle_EmoGroup(groupId, isEnter)

    local groupObj = self.groupObjList[groupId]
    if not groupObj then
        return
    end

    if isEnter then
        groupObj.SelectedType:SetActive(true)
    else
        groupObj.SelectedType:SetActive(false)
    end
    if self.curGroupId == groupId then
        return
    end
    self.curGroupId = groupId
    groupObj.callback(self, groupObj.TypeItem_tog.isOn)
end

function EmoticonIconListPanel:OnFriendRemove(friendId)
    if friendId == self.args.friendId then
        PanelManager.Instance:ClosePanel(self)
    end
end

function EmoticonIconListPanel:Close_HideCallBack()
    PanelManager.Instance:ClosePanel(self)
end