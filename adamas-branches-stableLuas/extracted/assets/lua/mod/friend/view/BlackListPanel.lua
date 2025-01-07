BlackListPanel = BaseClass("BlackListPanel", BasePanel)

local BLACKLISTMAXSIZE = Config.DataCommonCfg.Find["BlackListLimit"].int_val

function BlackListPanel:__init()  
    self:SetAsset("Prefabs/UI/Friend/BlackListPanel.prefab")
    self.blackListObjList = {}
end

function BlackListPanel:__BindListener()
    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("OnClick_Close"))
    self.CommonGrid_btn.onClick:AddListener(self:ToFunc("OnClick_Close"))
end

function BlackListPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.FriendBlackListRefresh, self:ToFunc("UpdateBlackListInfo"))
end

function BlackListPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy) 
end

function BlackListPanel:__Create()
end

function BlackListPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.FriendBlackListRefresh, self:ToFunc("UpdateBlackListInfo"))

    self.blackListObjList = {}
end

function BlackListPanel:__Hide()

end

function BlackListPanel:__Show()
    local setting = { bindNode = self.BlurNode }
    self:SetBlurBack(setting)
end

function BlackListPanel:TempShow()
    UtilsUI.SetActive(self.BlackListScroll,false)
    local tiemer = LuaTimerManager.Instance:AddTimerByNextFrame(1,0,function()
        UtilsUI.SetActive(self.BlackListScroll,true)
    end
    )
end

function BlackListPanel:__ShowComplete()
    self:UpdateBlackListInfo()
end

function BlackListPanel:UpdateBlackListInfo()
    self.curList = mod.FriendCtrl:GetBlackList()
    self.Count_txt.text =  string.format(TI18N("黑名单： %d/%d"),#self.curList,BLACKLISTMAXSIZE)
    self:RefreshBlackListScroll()
end

function BlackListPanel:RefreshBlackListScroll()
    local count = #self.curList
    self.BlackListScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshBlackListCell"))
    self.BlackListScroll_recyceList:SetCellNum(count)
end

function BlackListPanel:RefreshBlackListCell(index,go)
    if not go then
        return 
    end

    local blackListItem
    local blackListObj
    if self.blackListObjList[index] then
        blackListItem = self.blackListObjList[index].blackListItem
        blackListObj = self.blackListObjList[index].blackListObj
    else
        local uiContainer = {}
        uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
        blackListItem = PoolManager.Instance:Pop(PoolType.class, "BlackListItem")
        if not blackListItem then
            blackListItem = BlackListItem.New()
        end
        blackListObj = uiContainer.BlackListItem
        self.blackListObjList[index] = {}
        self.blackListObjList[index].blackListItem = blackListItem
        self.blackListObjList[index].blackListObj = blackListObj
    end

    blackListItem:InitItem(blackListObj,mod.FriendCtrl:GetFriendInfo(self.curList[index]))
end

function BlackListPanel:OnClick_Close()
    self.parentWindow:ClosePanel(self)
end
