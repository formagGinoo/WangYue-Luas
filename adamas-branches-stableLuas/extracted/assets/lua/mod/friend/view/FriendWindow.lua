FriendWindow = BaseClass("FriendWindow", BaseWindow)

local MAXFRIENDCOUNT = Config.DataCommonCfg.Find["FriendLimit"].int_val
local REFRESHINTERVAL = Config.DataCommonCfg.Find["RefreshInterval"].int_val

function FriendWindow:__init()  
    self:SetAsset("Prefabs/UI/Friend/FriendWindow.prefab")
    self.curSelectitem = nil
    self.curList = nil
    self.curType = nil
    self.playerInfoItem = nil
    self.friendObjList = {}
    self.curSelectitem = nil
end

function FriendWindow:__BindListener()
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("OnClick_Close"))

    self.ApplicationListBtn_btn.onClick:AddListener(self:ToFunc("OnClick_ChangeToApplication"))
    self.RecommendListBtn_btn.onClick:AddListener(self:ToFunc("OnClick_ChangeToRecommend"))
    self.FriendListBtn_btn.onClick:AddListener(self:ToFunc("OnClick_ChangeToFriend"))
    
    self.BlackList_btn.onClick:AddListener(self:ToFunc("OpenBlaskListPanel"))
    self.StartTalkBtn_btn.onClick:AddListener(self:ToFunc("OpenTalkWindow"))
    self.EditorInfoBtn_btn.onClick:AddListener(self:ToFunc("OpenEditorNode"))
    self.EditorMenu_btn.onClick:AddListener(self:ToFunc("CloseEditorNode"))

    self.FreshBtn_btn.onClick:AddListener(self:ToFunc("OnClick_RefreshBtn"))
    self.AddFriendBtn_btn.onClick:AddListener(self:ToFunc("OnClick_AddFriendBtn"))

    self.AllRefuse_btn.onClick:AddListener(self:ToFunc("RefuseAll"))
    self.AllAgree_btn.onClick:AddListener(self:ToFunc("AgreeAll"))
    self.RefuseBtn_btn.onClick:AddListener(self:ToFunc("OnClick_RefuseBtn"))
    self.AgreeBtn_btn.onClick:AddListener(self:ToFunc("OnClick_AgreeBtn"))

    self.DeleteBtn_btn.onClick:AddListener(self:ToFunc("DeleteFriendTips"))
    self.AddBlackListBtn_btn.onClick:AddListener(self:ToFunc("AddToBlackListTips"))
    self.SetNameBtn_btn.onClick:AddListener(self:ToFunc("OpenSetRemarkPanel"))

    self.SearchBtn_btn.onClick:AddListener(self:ToFunc("SearchPlayer"))

    self:BindRedPoint(RedPointName.FriendRequest,self.RequestRed)
end

function FriendWindow:__BindEvent()
    EventMgr.Instance:AddListener(EventName.FriendListRefresh, self:ToFunc("FriendListRefresh"))
    EventMgr.Instance:AddListener(EventName.ModifyRemark,self:ToFunc("SetRemark"))
end

function FriendWindow:__Create()
end

function FriendWindow:__AfterExitAnim()
    WindowManager.Instance:CloseWindow(self)
end

function FriendWindow:__delete()
    EventMgr.Instance:RemoveListener(EventName.FriendListRefresh, self:ToFunc("FriendListRefresh"))
    EventMgr.Instance:RemoveListener(EventName.ModifyRemark,self:ToFunc("SetRemark"))

    PoolManager.Instance:Push(PoolType.class, "PlayerInfoItem", self.playerInfoItem)

    for _, v in ipairs(self.friendObjList) do
        PoolManager.Instance:Push(PoolType.class, "FriendItem", v.friendItem)
    end


end

function FriendWindow:__Hide()

end

function FriendWindow:__TempShow()
    self:CallPanelFunc("TempShow")
end

function FriendWindow:__Show()
    self.animator = self.gameObject:GetComponent(Animator)
    self.curType = 0 
    -- 
    self.recommendTime = TimeUtils.GetCurTimestamp() - mod.FriendCtrl:GetLastRefreshRecommendTime()
    self.curList = mod.FriendCtrl:GetFriendIdList()

    self.SearchInputField = self.Search.transform:GetComponent(TMP_InputField)
    self.SearchInputField.onSubmit:AddListener(self:ToFunc("SearchPlayer"))

    self.SearchInputField.onValueChanged:AddListener(self:ToFunc("SearchInput"))

    local setting = { passEvent = UIDefine.BlurBackCaptureType.Scene, blurRadius = 2, bindNode = self.BlurNode }
    self:SetBlurBack(setting)
end


function FriendWindow:__ShowComplete()
    --CustomUnityUtils.SetDepthOfFieldBoken(true, 0.117, 42, 26)
    self:SetTitle()
    self:SetFriendCount()
    self.playerInfoItem = PoolManager.Instance:Pop(PoolType.class, "PlayerInfoItem")
	if not self.playerInfoItem then
		self.playerInfoItem = PlayerInfoItem.New()
	end
    self.playerInfoItem:InitItem(self.PlayerInfoItem, self)
    if #self.curList > 0 then
        self:ChangeType(1)
    else
        self:ChangeType(2)
    end
end
function FriendWindow:SetTitle()
    self.Title1_txt.text = TI18N("好友")
    self.Title2_txt.text = "haoyou"
end


function FriendWindow:SetFriendCount()
    self.FriendCount_txt.text =  string.format(TI18N("我的好友:%d/%d"),#mod.FriendCtrl:GetFriendIdList(),MAXFRIENDCOUNT)
end

function FriendWindow:RefreshPlayerScroll()
    if self.curSelectitem then
        self.curSelectitem.isSelect = false
        self.curSelectitem:SelectOut()
        self.curSelectitem = nil
    end

    local count = #self.curList

    self:SetEmptyState(count == 0)
    self.PlayerScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshPlayerCell"))
    self.PlayerScroll_recyceList:SetCellNum(count)
end

function FriendWindow:RefreshPlayerCell(index,go)
    if not go then
        return 
    end

    local friendItem
    local friendObj
    
    if not self.friendObjList[index] then
        friendItem = PoolManager.Instance:Pop(PoolType.class, "FriendItem")
        if not friendItem then
            friendItem = FriendItem.New()
        end

        self.friendObjList[index] = {friendItem = friendItem, friendObj = nil, isSelect = false }
    end

    local uiContainer = UtilsUI.GetContainerObject(go.transform)

    friendItem = self.friendObjList[index].friendItem
    friendObj = uiContainer.FriendItem
    self.friendObjList[index].friendObj = friendObj
    
    friendItem:InitItem(friendObj, mod.FriendCtrl:GetFriendInfo(self.curList[index]))

    local onClickFunc = function()
        self:OnClick_SingleFriend(self.friendObjList[index].friendItem)
    end
    friendItem:SetBtnEvent(false,onClickFunc)

    if index == 1 then 
        self:OnClick_SingleFriend(self.friendObjList[index].friendItem, true)
    end
end

function FriendWindow:OnClick_SingleFriend(friendItem,isFirstShow)
    --if self.curSelectitem and self.curSelectitem == friendItem and not isFirstShow then return end
    if self.curSelectitem and self.curSelectitem ~= friendItem then
        self.curSelectitem:SetSelect(false)
    end
    self.curSelectitem = friendItem
    self.curSelectitem:SetSelect(true)

    self.playerInfoItem:UpdataPlayerInfo(friendItem.playerInfo.information.uid)
    --self.playerInfoItem:PlayRefreshAnim()
end

local selectColor = Color(0.29,0.31,0.35)
local defautColor = Color(0.71,0.72,0.75)
function FriendWindow:ChangeType(type)
    if type == self.curType then return end
    
    if self.curType == 1 then
        self.FriendTxt_txt.color = defautColor
        UtilsUI.SetActiveByScale(self.Friend,false)
        UtilsUI.SetActiveByScale(self.FriendBtns,false)
        UtilsUI.SetActiveByScale(self.BlackList,false)
    elseif self.curType ==2 then 
        self.RecommendTxt_txt.color = defautColor
        UtilsUI.SetActiveByScale(self.Recommend,false)
        UtilsUI.SetActiveByScale(self.RecommendBtns,false)
    elseif self.curType == 3 then 
        self.ApplicationTxt_txt.color = defautColor
        UtilsUI.SetActiveByScale(self.Application,false)
        UtilsUI.SetActiveByScale(self.ApplicationBtns,false)
    end 
    self.curType = type
    if type == 1 then
        self.FriendTxt_txt.color = selectColor
        UtilsUI.SetActiveByScale(self.Friend,true)
        UtilsUI.SetActiveByScale(self.FriendBtns,true)
        UtilsUI.SetActiveByScale(self.BlackList,true)
        self.curList = mod.FriendCtrl:GetFriendIdList()
    elseif type ==2 then 
        self.RecommendTxt_txt.color = selectColor
        UtilsUI.SetActiveByScale(self.Recommend,true)
        UtilsUI.SetActiveByScale(self.RecommendBtns,true)
        self.curList = mod.FriendCtrl:GetRecommendList() 
        if not self.curList or not next(self.curList) or self.recommendTime > REFRESHINTERVAL then
            self:FreshRecommendList()
            -- return 
        end
    elseif type == 3 then 
        self.ApplicationTxt_txt.color = selectColor
        UtilsUI.SetActiveByScale(self.Application,true)
        UtilsUI.SetActiveByScale(self.ApplicationBtns,true)
        self.curList = mod.FriendCtrl:GetApplicationList()
    end 

    self:RefreshPlayerScroll()
end

function FriendWindow:FriendListRefresh(type)
    if type == 1 then
        self:SetFriendCount()
    end
    if type == self.curType then
        -- self.curType = 0
        -- self:ChangeType(type)
        if type == 1 then
            self.curList = mod.FriendCtrl:GetFriendIdList()
        elseif type == 2 then
            self.curList = mod.FriendCtrl:GetRecommendList()
            self.recommendTime = 0
        elseif type == 3 then
            self.curList = mod.FriendCtrl:GetApplicationList()
        end
        self:RefreshPlayerScroll()
    end
end


function FriendWindow:OnClick_ChangeToFriend()
    self:ChangeType(1)
end

function FriendWindow:OnClick_ChangeToRecommend()
    self:ChangeType(2)
end

function FriendWindow:OnClick_ChangeToApplication()
    self:ChangeType(3)
end

function FriendWindow:SearchPlayer()
    local id = tonumber(self.SearchInputField.text)
    if id then
        mod.FriendCtrl:SearchByID(id)
    end
end

function FriendWindow:DeleteFriendTips()
    self:CloseEditorNode()
    MsgBoxManager.Instance:ShowTextMsgBox(TI18N("你确定要删除该名好友吗？"), self:ToFunc("DeleteFriend"))
end

function FriendWindow:DeleteFriend()
    local targetId = self.curSelectitem.playerInfo.information.uid
    mod.FriendCtrl:RemoveFriend(targetId)
end

function FriendWindow:OnClick_Close()
    local time = TimeUtils.GetCurTimestamp() - self.recommendTime
    mod.FriendCtrl:SetLastRecommendTime(time)
    self.animator:Play("UI_FriendWindow_out")
    --WindowManager.Instance:CloseWindow(self)
end

function FriendWindow:SetEmptyState(state)
    state = not state
    UtilsUI.SetActive(self.PlayerScroll,state)
    UtilsUI.SetActive(self.PlayerInfoItem,state)
    if self.curType == 1 then
        UtilsUI.SetActiveByScale(self.FriendBtns,state)
    elseif self.curType == 2 then 
        UtilsUI.SetActiveByScale(self.RecommendBtns,true)
    elseif self.curType == 3 then
        UtilsUI.SetActiveByScale(self.ApplicationBtns,state)
    end
end

function FriendWindow:OpenBlaskListPanel()
    --print("OpenBlaskListPanel()")
    self:OpenPanel(BlackListPanel)
end

function FriendWindow:OpenTalkWindow()
    WindowManager.Instance:OpenWindow(ChatMainWindow, { nowSelectItem = self.curSelectitem})
end

function FriendWindow:OpenEditorNode()
    UtilsUI.SetActive(self.EditorMenu,true)
end

function FriendWindow:CloseEditorNode()
    UtilsUI.SetActive(self.EditorMenu,false)
end

function FriendWindow:FreshRecommendList()
    mod.FriendCtrl:FreshRecommendList()
end

function  FriendWindow:OnClick_RefreshBtn()
    if self.lastResfrshTime and TimeUtils.GetCurTimestamp() - self.lastResfrshTime < 5 then
        MsgBoxManager.Instance:ShowTips(TI18N("刷新过于频繁！"))
        return
    end
    self.lastResfrshTime = TimeUtils.GetCurTimestamp()
    self:FreshRecommendList()
end

function FriendWindow:OnClick_AddFriendBtn()
    if not self.curSelectitem then
        return
    end
    local targetId = self.curSelectitem.playerInfo.information.uid
    mod.FriendCtrl:AddFriend(targetId)
    --mod.FriendFacade:SendMsg("friend_request",targetId)
end

function FriendWindow:OnClick_RefuseBtn()
    local targetId = self.curSelectitem.playerInfo.information.uid
    mod.FriendCtrl:RefuseRequest(targetId)
end

function FriendWindow:OnClick_AgreeBtn()
    local targetId = self.curSelectitem.playerInfo.information.uid
    mod.FriendCtrl:AgreeRequest(targetId)
end

function FriendWindow:RefuseAll()
    mod.FriendCtrl:RefuseRequest(0)
end

function FriendWindow:AgreeAll()
    mod.FriendCtrl:AgreeRequest(0)
end

function FriendWindow:AddToBlackListTips()
    self:CloseEditorNode()
    MsgBoxManager.Instance:ShowTextMsgBox(TI18N("你确定要将该名玩家添加至黑名单吗？"), self:ToFunc("AddToBlackList"))
end

function FriendWindow:AddToBlackList()
    local targetId = self.curSelectitem.playerInfo.information.uid
    
    mod.FriendCtrl:AddToBlackList(targetId)
end

function FriendWindow:OpenSetRemarkPanel()
    self.editorPanel = PanelManager.Instance:OpenPanel(PlayerInfoEditorPanel,{view = PlayerInfoEditorPanel.EditorView.Remark,txt = mod.FriendCtrl:GetFriendRemark(self.curSelectitem.playerInfo.information.uid)})
    self:CloseEditorNode()
    self.editorPanel:Show()
end

function FriendWindow:SetRemark(remark)
    local targetId = self.curSelectitem.playerInfo.information.uid
    mod.FriendCtrl:SetFriendRemark(targetId,remark)
end

function FriendWindow:SearchInput()
    local txt = string.gsub(self.SearchInputField.text,"-","")
    self.SearchInputField.text = txt
end