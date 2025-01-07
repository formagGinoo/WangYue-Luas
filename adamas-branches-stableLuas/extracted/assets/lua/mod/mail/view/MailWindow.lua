MailWindow = BaseClass("MailWindow", BaseWindow)

local MAXCOUNT = 2000

function MailWindow:__init()  
    self:SetAsset("Prefabs/UI/Mail/MailWindow.prefab")
    self.selectMail = nil
    self.mailObjList = {}
    self.mailList = {}
    self.rewardObjList = {}
    self.rewardList = {}
end

function MailWindow:__BindListener()
    self.CommonBack2_btn.onClick:AddListener(self:ToFunc("OnClickClose"))
    self.GetAllBtn_btn.onClick:AddListener(self:ToFunc("GetAll"))
    self.DeleteReadBtn_btn.onClick:AddListener(self:ToFunc("DeleteRead"))
    self.DeleteBtn_btn.onClick:AddListener(self:ToFunc("DeleteShow"))
    self.GetBtn_btn.onClick:AddListener(self:ToFunc("GetShow"))
end

function MailWindow:__BindEvent()
    EventMgr.Instance:AddListener(EventName.MailRefresh,self:ToFunc("RefreshAll"))
    EventMgr.Instance:AddListener(EventName.MailGetAward,self:ToFunc("RefreshMailInfo"))
end

function MailWindow:__Create()
end

function MailWindow:__delete()
    EventMgr.Instance:AddListener(EventName.MailRefresh,self:ToFunc("RefreshAll"))
    EventMgr.Instance:RemoveListener(EventName.MailGetAward,self:ToFunc("RefreshMailInfo"))

    for k, v in pairs(self.mailObjList) do
		PoolManager.Instance:Push(PoolType.class, "CommonMail", v.commonMail)
	end

    for k, v in pairs(self.rewardObjList) do
		PoolManager.Instance:Push(PoolType.class, "CommonItem", v.commonReward)
	end

    self.selectMail = nil
    self.mailObjList = {}
end

function MailWindow:__Hide()
end

function MailWindow:__Show()
    self.rectView = self.MainInfo:GetComponent(ScrollRect)
    -- local list = Config.DataMail.Find
    -- for k, v in pairs(list) do
    --     table.insert(self.mailList,v)
    -- end
end

function MailWindow:__ShowComplete()
    self:RefreshAll()
end

function MailWindow:RefreshAll()
    self.mailList = mod.MailCtrl:GetmailList()
    self:SetTopInfo()
    if not self.mailList or #self.mailList == 0 then 
        UtilsUI.SetActiveByScale(self.Empty,true)
        UtilsUI.SetActiveByScale(self.InfoRoot,false)
        return 
    else
        UtilsUI.SetActiveByScale(self.Empty,false)
        UtilsUI.SetActiveByScale(self.InfoRoot,true)
    end
    self:RefreshMailList()
end

function MailWindow:SetTopInfo()
    self.WindowTitle_txt.text = TI18N("邮件")
    self.Title2_txt.text = "youjian"
    self.MailCount_txt.text = TI18N(string.format("邮件数量  %d/%d",#self.mailList,MAXCOUNT))
end

function MailWindow:RefreshMailList()
    self.refreshAll = true

    local listNum = #self.mailList
    self.MailScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshMailCell"))
    self.MailScroll_recyceList:SetCellNum(listNum, true)
end

function MailWindow:RefreshMailCell(index,go)
    if not go then
        return
    end

    local commonMail
    local mailObj

    if not self.mailObjList[index] then
        commonMail = PoolManager.Instance:Pop(PoolType.class, "CommonMail")
        if not commonMail then
            commonMail = CommonMail.New()
        end

        self.mailObjList[index] = { commonMail = commonMail, mailObj = nil, isSelect = false }
    end
    commonMail = self.mailObjList[index].commonMail
    local uiContainer = {}
    uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
    mailObj = uiContainer.CommonMail
    self.mailObjList[index].mailObj = mailObj

    commonMail:InitMail(mailObj,self.mailList[index],true)
    local onClickFunc = function()
        self:OnClick_SingleMail(self.mailObjList[index].commonMail)
    end
    commonMail:SetBtnEvent(false,onClickFunc)

    if self.refreshAll and index == 1 then 
        self.refreshAll = false
        self:OnClick_SingleMail(commonMail)
    end

    if not self.mailList[index] or not next(self.mailList[index]) then
        return 
    end
end

function MailWindow:OnClick_SingleMail(singleMail)
    self.rectView.normalizedPosition = Vector2(0,1)
    if self.selectMail and self.selectMail ~= singleMail then
        self.selectMail.isSelect = false
        self.selectMail:SetSelectBox()
    end
    if singleMail.isRead == false then
        mod.MailFacade:SendMsg("mail_read",singleMail.mailInfo.id)
        singleMail.isRead = false
        singleMail:SetRedPoint()
    end
    singleMail.isSelect = true
    singleMail:SetSelectBox()
    singleMail:OnClick()
    self.selectMail = singleMail

    self:RefreshMailInfo()
end

function MailWindow:RefreshMailInfo()
    local mailInfo = self.selectMail.mailInfo
    self.InfoTitle_txt.text = mailInfo.title
    self.Sender_txt.text = mailInfo.sender
    self.SendTime_txt.text = os.date("%Y-%m-%d %H:%M",mailInfo.send_ts)
    self.MainInfoText_txt.text = mailInfo.content

    if not mailInfo.item_list or #mailInfo.item_list == 0 then 
        UtilsUI.SetActive(self.MailAward,false)
    else
        UtilsUI.SetActive(self.MailAward,true)
        self:SetRewardList(mailInfo)
    end

    if mailInfo.item_list and #mailInfo.item_list > 0 and mailInfo.reward_flag == 0 then 
        UtilsUI.SetActive(self.GetBtn,true)
    else
        UtilsUI.SetActive(self.GetBtn,false)
    end
    --LayoutRebuilder.ForceRebuildLayoutImmediate(self.MainText.transform)
end

function MailWindow:SetRewardList(mailInfo)
    self.rewardList = mailInfo.item_list
    if #self.rewardList > 0 then 
        self:RefreshRewardList()
    end
end

function MailWindow:RefreshRewardList()
    local listNum = #self.rewardList
    self.MailAwardScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshRewardCell"))
    self.MailAwardScroll_recyceList:SetCellNum(listNum, true)
end

function MailWindow:RefreshRewardCell(index,go)
    if not go then
        return
    end

    local commonReward
    local rewardObj

    if not self.rewardObjList[index] then
        commonReward = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
        if not commonReward then
            commonReward = CommonItem.New()
        end
        self.rewardObjList[index] = {commonReward = commonReward, rewardObj = nil, isSelect = false}
    end

    local uiContainer = {}
    uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
    rewardObj = uiContainer
    commonReward = self.rewardObjList[index].commonReward

    commonReward:InitItem(rewardObj.CommonItem,ItemConfig.GetItemConfig(self.rewardList[index].key),true)
    commonReward:SetNum(self.rewardList[index].value)
    UtilsUI.SetActive(rewardObj.ReceivedImg,self.selectMail.mailInfo.reward_flag == 1)

    if not self.rewardList[index] or not next(self.rewardList[index]) then
        return
    end
end

function MailWindow:MailListUpdate()
    if self.selectMail then
        self.selectMail.isSelect = false
        self.selectMail:SetSelectBox()
        self.selectMail = nil
    end
    self:RefreshMailList()
end

function MailWindow:OnClickClose()
    WindowManager.Instance:CloseWindow(self)
end

function MailWindow:GetAll()
    if mod.MailCtrl:CheckCanGetAll() then 
        MsgBoxManager.Instance:ShowTextMsgBox(TI18N("是否领取全部邮件奖励?"),function ()
            mod.MailCtrl:GetAll()
        end)
    else
        MsgBoxManager.Instance:ShowTips("无相关邮件！")
    end
end

function MailWindow:GetShow()
    if self.selectMail.mailInfo.expire_ts == 0 or self.selectMail.mailInfo.expire_ts > TimeUtils.GetCurTimestamp() then
        mod.MailCtrl:GetReward(self.selectMail.mailInfo.id)
    else
        --mod.MailCtrl:GetReward(self.selectMail.mailInfo.id)
        MsgBoxManager.Instance:ShowTips("邮件已过期！")
        self:RefreshAll()
    end
end 

function MailWindow:DeleteRead()
    if mod.MailCtrl:CheckCanDeleteRead() then
        MsgBoxManager.Instance:ShowTextMsgBox(TI18N("是否删除已读邮件?"),function ()
            mod.MailCtrl:DeleteRead()
        end)
    else
        MsgBoxManager.Instance:ShowTips("无相关邮件！")
    end
end

function MailWindow:DeleteShow()
    MsgBoxManager.Instance:ShowTextMsgBox(TI18N("是否删除选中邮件?"),function ()
        mod.MailFacade:SendMsg("mail_delete",{self.selectMail.mailInfo.id})
    end)
end