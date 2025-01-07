IdentityShowPanel = BaseClass("IdentityShowPanel", BasePanel)

function IdentityShowPanel:__init()
    self:SetAsset("Prefabs/UI/Identity/IdentityShowPanel.prefab")

    self.identityObjList = {}
    self.identityList = {}
    self.rewardObjList = {}
end

function IdentityShowPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function IdentityShowPanel:__BindListener()
    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("OnClick_Close"))
    self.ChangeBtn_btn.onClick:AddListener(self:ToFunc("ChangeIdentity"))

    EventMgr.Instance:AddListener(EventName.IdentityGetReward, self:ToFunc("GetIdentityReward"))
    EventMgr.Instance:AddListener(EventName.IdentityChange, self:ToFunc("AfterChangeIdentity"))
    EventMgr.Instance:AddListener(EventName.IdentitRewardRefresh, self:ToFunc("RefreshRewardList"))
end

function IdentityShowPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.IdentityGetReward, self:ToFunc("GetIdentityReward"))
    EventMgr.Instance:RemoveListener(EventName.IdentityChange, self:ToFunc("AfterChangeIdentity"))
    EventMgr.Instance:RemoveListener(EventName.IdentitRewardRefresh, self:ToFunc("RefreshRewardList"))

    for k, v in pairs(self.identityObjList) do
        PoolManager.Instance:Push(PoolType.class, "IdentityItem", v.commonIdentity)
    end
    for k, v in pairs(self.rewardObjList) do
        PoolManager.Instance:Push(PoolType.class, "IdentityRewardItem", v.commonReward)
    end
end

function IdentityShowPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function IdentityShowPanel:__Show()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurNode }
        --self.blurBack = BlurBack.New(self, setting)
        local cb = function ()
            self:SetActive(true)
            self:RefreshIdentityList()
        end
        self:SetBlurBack(setting,cb)
    end

    self:SetActive(false)
    --self.blurBack:Show()
end

function IdentityShowPanel:__ShowComplete()
    --self:RefreshIdentityList()
end

function IdentityShowPanel:ShowDetail()
    
end

function IdentityShowPanel:RefreshIdentityList()
    self.identityList = mod.IdentityCtrl:GetIdentityList()

    local listNum = #self.identityList
    self.IdentityScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshIdentityCell"))
    self.IdentityScroll_recyceList:SetCellNum(listNum)
end

function IdentityShowPanel:RefreshIdentityCell(index,go)
    if not go then
        return 
    end

    local commonIdentity
    local identityObj
    if self.identityObjList[index] then
        commonIdentity = self.identityObjList[index].commonIdentity
        identityObj = self.identityObjList[index].identityObj
    else
        local uiContainer = {}
        uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
        commonIdentity = PoolManager.Instance:Pop(PoolType.class, "IdentityItem")
        if not commonIdentity then
            commonIdentity = IdentityItem.New()
        end
        identityObj = uiContainer.IdentityItem
        self.identityObjList[index] = {}
        self.identityObjList[index].commonIdentity = commonIdentity
        self.identityObjList[index].identityObj = identityObj
        self.identityObjList[index].isSelect = false
    end
    commonIdentity:OnReset()
    commonIdentity:InitItem(identityObj,self.identityList[index])
    local onClickFunc = function()
        self:OnClick_SingleIdentity(self.identityObjList[index].commonIdentity)
    end
    commonIdentity:SetBtnEvent(false,onClickFunc)

    if index == 1 then 
        self:OnClick_SingleIdentity(self.identityObjList[index].commonIdentity)
    end

    if not self.identityList[index] or not next(self.identityList[index]) then
        return
    end
end

function IdentityShowPanel:OnClick_SingleIdentity(identityItem)
    if self.curIdentityItem and self.curIdentityItem ~= identityItem then
        self.curIdentityItem.isSelect = false
        self.curIdentityItem:SetSelect()
    end
    self.curIdentityItem = identityItem
    identityItem.isSelect = true
    identityItem:SetSelect()
    self:UpdataIndentityInfo()
end

function IdentityShowPanel:UpdataIndentityInfo()
    local identityConfig = self.curIdentityItem.identityConfig
    local nextLvConfig = IdentityConfig.GetIdentityTitleConfigNextLv(self.curIdentityItem.identityId,self.curIdentityItem.identityLv)
    self.EffectDesc_txt.text = identityConfig.desc
    if nextLvConfig then
        local conditionDesc = TI18N("道途属性达到")
        for k, v in ipairs(nextLvConfig.need_item) do
            if v[1] == 10 then
                conditionDesc = conditionDesc .. TI18N(IdentityConfig.GetIdentityAttrConfig(10).name) .. v[2]
            elseif v[1] == 11 then
                conditionDesc = conditionDesc .. TI18N(IdentityConfig.GetIdentityAttrConfig(11).name) .. v[2]
            elseif v[1] == 12 then
                conditionDesc = conditionDesc .. TI18N(IdentityConfig.GetIdentityAttrConfig(12).name) .. v[2]
            end
        end
        self.LvUpConditionDesc_txt.text = conditionDesc
    else
        self.LvUpConditionDesc_txt.text = TI18N("已达最大等级")
    end

    if self.curIdentityItem.identityLv == 0 then
        UtilsUI.SetActive(self.UnClick,true)
        UtilsUI.SetActive(self.ChangeBtn,false)
        UtilsUI.SetActive(self.InUseTxt,false)
        UtilsUI.SetActive(self.UnGetTxt,true)
    elseif self.curIdentityItem.identityId == mod.IdentityCtrl:GetNowIdentity().id then
        UtilsUI.SetActive(self.UnClick,true)
        UtilsUI.SetActive(self.ChangeBtn,false)
        UtilsUI.SetActive(self.InUseTxt,true)
        UtilsUI.SetActive(self.UnGetTxt,false)
    else
        UtilsUI.SetActive(self.ChangeBtn,true)
        UtilsUI.SetActive(self.UnClick,false)
    end

    LayoutRebuilder.ForceRebuildLayoutImmediate(self.EffectTitle.transform.parent)

    self:RefreshRewardList()
end

function IdentityShowPanel:RefreshRewardList()
    self.showRewardList = mod.IdentityCtrl:GetIdentityRewardList(self.curIdentityItem.identityId)
    local listNum = #self.showRewardList
    self.RewardScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshRewardCell"))
    self.RewardScroll_recyceList:SetCellNum(listNum)
end

function IdentityShowPanel:RefreshRewardCell(index,go)
    if not go then
        return 
    end

    local commonReward
    local rewardObj
    local uiContainer = {}
    uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
    rewardObj = uiContainer.IdentityRewardItem

    if self.rewardObjList[index] then
        commonReward = self.rewardObjList[index].commonReward
    else
        commonReward = PoolManager.Instance:Pop(PoolType.class, "IdentityRewardItem")
        if not commonReward then
            commonReward = IdentityRewardItem.New()
        end
        self.rewardObjList[index] = {}
        self.rewardObjList[index].commonReward = commonReward
        self.rewardObjList[index].isSelect = false
    end

    commonReward:InitReward(rewardObj,self.showRewardList[index])
    local onClickFunc = function()
        self:OnClick_SingleReward(self.rewardObjList[index].commonReward)
    end
    --commonReward:SetBtnEvent(false,onClickFunc)
end

function IdentityShowPanel:GetIdentityReward()
    mod.IdentityCtrl:GetIdentityReward(self.curIdentityItem.identityId)
end

function IdentityShowPanel:ChangeIdentity()
    mod.IdentityCtrl:SendChangeIdentity(self.curIdentityItem.identityId,self.curIdentityItem.identityLv)
end

function IdentityShowPanel:AfterChangeIdentity()
    if self.curIdentityItem.identityLv == 0 then
        UtilsUI.SetActive(self.UnClick,true)
        UtilsUI.SetActive(self.ChangeBtn,false)
        UtilsUI.SetActive(self.InUseTxt,false)
        UtilsUI.SetActive(self.UnGetTxt,true)
    elseif self.curIdentityItem.identityId == mod.IdentityCtrl:GetNowIdentity().id then
        UtilsUI.SetActive(self.UnClick,true)
        UtilsUI.SetActive(self.ChangeBtn,false)
        UtilsUI.SetActive(self.InUseTxt,true)
        UtilsUI.SetActive(self.UnGetTxt,false)
    else
        UtilsUI.SetActive(self.ChangeBtn,true)
        UtilsUI.SetActive(self.UnClick,false)
    end
end

function IdentityShowPanel:OnClick_SingleReward(rewardItem)
    
end

function IdentityShowPanel:OnClick_Close()
    PanelManager.Instance:ClosePanel(self)
end