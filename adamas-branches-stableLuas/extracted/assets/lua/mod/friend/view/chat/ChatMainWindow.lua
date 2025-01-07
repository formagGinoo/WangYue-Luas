ChatMainWindow = BaseClass("ChatMainWindow", BaseWindow)


function ChatMainWindow:__init()
	self:SetAsset("Prefabs/UI/Friend/ChatMainWindow.prefab")
    self.bubbleCachePool = {}
    self.bubbleShowPool = {}
    self.friendObjList = {}
end

function ChatMainWindow:__BindListener()
    -- self:SetHideNode("ChatMainWindow_Eixt")
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Close_HideCallBack"),self:ToFunc("OnBack"))
    self.SendMsgBtn_btn.onClick:AddListener(self:ToFunc("OnClick_SendChat"))
    self.ChatInputField_input.onSubmit:AddListener(self:ToFunc("OnClick_SendChat"))
    self.ClearChatBtn_btn.onClick:AddListener(self:ToFunc("ClearChat"))
    self.EmoticonIconBtn_btn.onClick:AddListener(self:ToFunc("OnClick_OpenEmoList"))
    self.FriendListBtn_btn.onClick:AddListener(self:ToFunc("OnClick_OpenFriendList"))
end

function ChatMainWindow:__BindEvent()
    EventMgr.Instance:AddListener(EventName.FriendRemove, self:ToFunc("ClearChat"))
    EventMgr.Instance:AddListener(EventName.ChatListRefresh, self:ToFunc("CreateAndSelectFriendItem"))
    EventMgr.Instance:AddListener(EventName.ChatListRefresh, self:ToFunc("RefreshChatList"))
    EventMgr.Instance:AddListener(EventName.ChatListRefresh, self:ToFunc("ShowAllChatRedPoint"))
end

function ChatMainWindow:__CacheObject()

end

function ChatMainWindow:__Create()
    self.ChatInputField_input = self.ChatInputField:GetComponent(TMP_InputField)
    self.ChatInputField_input.onValueChanged:AddListener(self:ToFunc("ChatInput"))
end

function ChatMainWindow:__delete()
    EventMgr.Instance:RemoveListener(EventName.FriendRemove, self:ToFunc("ClearChat"))
    EventMgr.Instance:RemoveListener(EventName.ChatListRefresh, self:ToFunc("RefreshChatList"))
    EventMgr.Instance:RemoveListener(EventName.ChatListRefresh, self:ToFunc("ShowAllChatRedPoint"))
    EventMgr.Instance:RemoveListener(EventName.ChatListRefresh, self:ToFunc("CreateAndSelectFriendItem"))
end

function ChatMainWindow:__ShowComplete()
    
end

function ChatMainWindow:__Hide()
    for i, logic in ipairs(self.bubbleShowPool) do
        logic:Reset()
    end
    self:PushAllUITmpObject("ChatReceive", self.ChatCacheNode_rect)
    self:PushAllUITmpObject("Time", self.ChatCacheNode_rect)
    self:PushAllUITmpObject("ChatSend", self.ChatCacheNode_rect)
    TableUtils.ClearTable(self.bubbleShowPool)
    TableUtils.ClearTable(self.bubbleCachePool)
    TableUtils.ClearTable(self.friendObjList)
end

function ChatMainWindow:FriendSelectCallBack(info, isSelect)
    if isSelect then
        self:RefreshChatList()
    end
end

function ChatMainWindow:RefreshChatList()
    for i, logic in ipairs(self.bubbleShowPool) do
        logic:Reset()
        table.insert(self.bubbleCachePool, logic)
    end
    TableUtils.ClearTable(self.bubbleShowPool)
    self:PushAllUITmpObject("ChatReceive", self.ChatCacheNode_rect)
    self:PushAllUITmpObject("ChatSend", self.ChatCacheNode_rect)
    self:PushAllUITmpObject("Time", self.ChatCacheNode_rect)
    self:SetChatInfo()
    self:SetChatContent()
    self:SetChatContentY()
    self:ShowAllChatRedPoint()

end

function ChatMainWindow:SetChatContentY()
    local scroll = self.ChatScroll.transform:GetComponent(ScrollRect)
    scroll.inertia = false
    local function SetChatContY()
        scroll.verticalScrollbar.value = 0
    end
    local function SetInertia()
        scroll.inertia = true
    end
    LuaTimerManager.Instance:AddTimer(10, 0.05, SetChatContY)
    LuaTimerManager.Instance:AddTimer(1, 0.5, SetInertia)
end 

function ChatMainWindow:__Show()
    self:SetBlurBack({ bindNode = self.BlurNode1 })
    self:PushAllUITmpObject("FriendItem")
    local args = self.args or {}
    self.selectItemByFriendWindow = args.nowSelectItem
    self.selectItemUID = self.selectItemByFriendWindow and self.selectItemByFriendWindow.playerInfo.information.uid or 0
    mod.FriendCtrl:SetClearChatUnShowListByFriendId(self.selectItemUID)
    local createList
    self.curList, createList = self:GetAndSortFriendIdList()
    if not next(createList) then
        WindowManager.Instance:OpenWindow(FriendWindow)
        WindowManager.Instance:CloseWindow(self)
        return
    end
    self:CreateFriendList(createList)

    if self.selectFriend then
        if type(self.selectFriend) == "string" then
            self.selectFriend = tonumber(self.selectFriend)
        end
        self:SelectFriend(self.selectFriend)
    end
    self:ShowAllChatRedPoint()
    self:CheckChatPartState()
end

function ChatMainWindow:GetAndSortFriendIdList()
    local curList = UtilsBase.copytab(mod.FriendCtrl:GetFriendIdList())
    local uid = self.selectItemUID
    for i, id in ipairs(mod.FriendCtrl:GetFriendIdList()) do
        if mod.FriendCtrl:GetLastChatTimeByFriendId(id) == 0 and id ~= uid then
            curList[i] = nil
        end
    end
    local function idSortFunc(a, b)
        if a == uid then
            return true
        end
        if b == uid then
            return false
        end
        return mod.FriendCtrl:GetLastChatTimeByFriendId(a) > mod.FriendCtrl:GetLastChatTimeByFriendId(b)
    end
    table.sort(curList, idSortFunc)
    local createList = {}
    for k, id in pairs(curList) do
        if not mod.FriendCtrl:GetChatUnShowListByFriendId(id) then
            table.insert(createList,{uid = id})
        end
    end
    local createList = {}
    for k, id in pairs(curList) do
        if not mod.FriendCtrl:GetChatUnShowListByFriendId(id) then
            table.insert(createList,{uid = id})
        end
    end
    return curList, createList
end

function ChatMainWindow:ShowAllChatRedPoint(newFriendId)
    self.curList = self.curList or {}
    if newFriendId then
        local haveNewFriend = false
        for i, v in ipairs(self.curList) do
            if v == haveNewFriend then 
                haveNewFriend = true
            end
        end
        if not haveNewFriend then
            table.insert(self.curList, newFriendId)
        end
    end
    
    for _, friendId in pairs(self.curList) do
        self:ShowChatRedPointByFriendId(friendId)
    end
end

function ChatMainWindow:ShowChatRedPointByFriendId(friendId)
    local obj = self.friendObjList[friendId]
    if obj then
        if mod.FriendCtrl:GetChatReadStateByTargetId(friendId) == true then
            UtilsUI.SetActive(obj.RedPoint, true)
        else
            UtilsUI.SetActive(obj.RedPoint, false)
        end
    end
end

function ChatMainWindow:OnBack()

end

function ChatMainWindow:SetChatInfo()
    local friendObj = self.friendObjList[self.curfriendId]
    if not friendObj then
        return
    end
    self.FriendNickName_txt.text = friendObj.info.name
    self.targetFriendId = friendObj.info.uid
    if friendObj.info.remarkName then
        UtilsUI.SetActive(self.RemarkFriendName, friendObj.info.remarkName ~= "")
        self.RemarkFriendName_txt.text = string.format("(%s)",friendObj.info.remarkName)
    else
        self.RemarkFriendName_txt.text = ""
    end
    UnityUtils.SetAnchoredPosition(
        self.RemarkFriendName_rect,
        self.FriendNickName_rect.anchoredPosition.x + self.FriendNickName_txt.preferredWidth + 15,
        self.FriendNickName_rect.anchoredPosition.y
    )
end

local ChatBubbleType =
{
    Characters = 1,
    EmoticonIcon = 2,
}

local ChatType = 
{
    ChatSend = "ChatSend",
    ChatReceive = "ChatReceive",
}

function ChatMainWindow:SetChatContent()
    mod.FriendCtrl:SetChatReadStateByTargetId(self.targetFriendId)
    self.nowSelectfriendChatInfo = mod.FriendCtrl:GetChatListByFriendId(self.targetFriendId)
    if not self.nowSelectfriendChatInfo then
        return
    end
    self.lastTimeStamp = 0
    for i, info in ipairs(self.nowSelectfriendChatInfo) do
        -- 1小时--3600000000
        self:CheckAndPopByTimeStampOffset(info.timestamp, FriendConfig.OneHourTimeStamp)
        if info.from_id == mod.InformationCtrl:GetPlayerInfo().uid then
            --之前自己发的聊天记录
            self:GetChatRecord(info.content, ChatType.ChatSend)
        else
            --之前别人发给自己的
            self:GetChatRecord(info.content, ChatType.ChatReceive)
        end
    end
end

-- 其他人发来的
function ChatMainWindow:GetChatRecord(content, chatType)
    local partten1Res = string.match(content, "^1:(.+)")
    local partten2Res = string.match(content, "^2:(.+)")
    local iconInfo = FriendConfig.GetMemeInfoByMemeId(partten2Res)
    if chatType == ChatType.ChatReceive then
        local playerInfo = self.friendObjList[self.targetFriendId] and self.friendObjList[self.targetFriendId].info.allInfo
        self:GetChatBubble(chatType, partten1Res , iconInfo, playerInfo)
    elseif chatType == ChatType.ChatSend then
        self:GetChatBubble(chatType, partten1Res , iconInfo, nil)
    end
end

function ChatMainWindow:OnClick_SendEmotionChat(emoInfo)
    local nowTimeStamp = TimeUtils.GetCurTimestamp() * 1000
    self:CheckAndPopByTimeStampOffset(nowTimeStamp, FriendConfig.OneHourTimeStamp)
    local logic = self:GetChatBubble(ChatType.ChatSend, nil, emoInfo, nil)
    logic:SendChat()
end

function ChatMainWindow:CheckAndPopByTimeStampOffset(timestamp, offset)
    if timestamp - (self.lastTimeStamp or 0) >= offset then
        local timeObj = self:PopUITmpObject("Time", self.ChatContent_rect)
        timeObj.Time_txt.text = FriendConfig.GetTimeByStamp(timestamp)
        UtilsUI.SetActive(timeObj.object, true)
        LayoutRebuilder.ForceRebuildLayoutImmediate(timeObj.objectTransform.parent.transform)
    end
    self.lastTimeStamp = timestamp
end

function ChatMainWindow:OnClick_SendChat()
    if self.ChatInputField_input.text == "" then
        return
    end
    local isFWord, newText, logic = false, "", nil
    isFWord, newText = SWBlocking.Query(self.ChatInputField_input.text, newText)
    newText = isFWord and newText or self.ChatInputField_input.text

    local nowTimeStamp = TimeUtils.GetCurTimestamp() * 1000
    self:CheckAndPopByTimeStampOffset(nowTimeStamp, FriendConfig.OneHourTimeStamp)
    logic = self:GetChatBubble(ChatType.ChatSend, newText, nil, nil)
    logic:SendChat()
    self.ChatInputField_input.text = ""
end


function ChatMainWindow:GetChatBubble(chatType, character, emotionInfo, playerInfo)
    local chatObj = self:PopUITmpObject(chatType, self.ChatContent_rect)
    local logic
    if self.bubbleCachePool and next(self.bubbleCachePool) then
		logic = table.remove(self.bubbleCachePool)
		logic:Reset()
    else
        logic = ChatBubbleLogic.New()
        table.insert(self.bubbleShowPool, logic)
	end
    UtilsUI.SetActiveByScale(chatObj, true)
    logic:Init(chatObj, character, emotionInfo, self, playerInfo)
    return logic
end

--没好友了就隐藏右边的聊天页签
function ChatMainWindow:CheckChatPartState()
    if not self.friendObjList or not next(self.friendObjList) then
        UtilsUI.SetActive(self.ChatPart, false)
        self.selectFriend = nil
        self.curfriendId = nil
        self.defaultSelect = nil
        return
    end
    UtilsUI.SetActive(self.ChatPart, true)
end

function ChatMainWindow:ClearChat(friendId)
    self.friendObjList[friendId or self.curfriendId].logic:OnReset()
    self:PushUITmpObject("FriendItem",self.friendObjList[friendId or self.curfriendId], self.FriendCacheNode_rect)
    self.friendObjList[friendId or self.curfriendId] = nil
    mod.FriendCtrl:SetChatUnShowListByFriendId(friendId or self.curfriendId)
    local isTrue
    self:CheckChatPartState()
    for uid, obj in pairs(self.friendObjList) do
        isTrue = self:SelectFriend(uid)
        if isTrue == true then
            return
        end
    end
end

function ChatMainWindow:OnClick_OpenEmoList()
    PanelManager.Instance:OpenPanel(EmoticonIconListPanel, {friendId = self.curfriendId})
end

function ChatMainWindow:OnClick_OpenFriendList()
	local window = WindowManager.Instance:GetWindow("FriendWindow")
	if not window then 
        WindowManager.Instance:CloseWindow(self)
        WindowManager.Instance:OpenWindow(FriendWindow)
        return
    end
    WindowManager.Instance:CloseWindow(self)
end

function ChatMainWindow:CreateFriendList(tabList)
    for _, friendInfo in pairs(tabList) do
        self:CreateFriendItem(friendInfo)
    end
    if self.defaultSelect then
        self:SelectFriend(self.defaultSelect)
    end
end

-- 外部刷新
function ChatMainWindow:CreateAndSelectFriendItem(friendId)
    if self.friendObjList[friendId] then
        return
    end
    self:CreateFriendItem(friendId)
    self:SetDefaultFriend(friendId)
    if self.defaultSelect and not self.curfriendId then
        self:CheckChatPartState()
        self:SelectFriend(self.defaultSelect)
    end
    self:ShowAllChatRedPoint()
end

function ChatMainWindow:CreateFriendItem(friendInfo)
    if type(friendInfo) == "number" then
        local uid = friendInfo
        friendInfo = {}
        friendInfo.uid  = uid
    end
    if not friendInfo 
    or not friendInfo.uid
    or self.friendObjList[friendInfo.uid] then
        return
    end
    local friendItemLogic = FriendItem.New()
    if not self.defaultSelect and not self.selectFriend then
        self.defaultSelect = friendInfo.uid
    end
    local friendInfoByServer = mod.FriendCtrl:GetFriendInfo(friendInfo.uid)
    friendInfo.remarkName = mod.FriendCtrl:GetFriendRemark(friendInfo.uid)
    friendInfo.name = friendInfoByServer.information.nick_name
    friendInfo.allInfo = friendInfoByServer
    local friendObj = self:GetFriendObj()
    self.friendObjList[friendInfo.uid] = friendObj
    friendObj.callback = self:ToFunc("FriendSelectCallBack")
    friendObj.info = friendInfo

    local onToggleFunc = function(isEnter)
        self:OnToggle_Friend(friendInfo.uid, isEnter)
    end
    
    friendItemLogic:InitItem(friendObj.object, friendInfoByServer)
    friendObj.logic = friendItemLogic
    friendObj.FriendItem_tog.onValueChanged:RemoveAllListeners()
    friendObj.FriendItem_tog.onValueChanged:AddListener(onToggleFunc)
    friendObj.object:SetActive(true)
end

function ChatMainWindow:SetFriendName(friendObj, friendInfo)
    if friendInfo.remarkName then
        friendObj.RemarkName_txt.text = friendInfo.remarkName
    else
        friendObj.NickName_txt.text = friendInfo.name
    end
    UtilsUI.SetActive(friendObj.RemarkName, friendInfo.remarkName)
    UtilsUI.SetActive(friendObj.NickName, not friendInfo.remarkName)
end

function ChatMainWindow:SelectFriend(friendId)
    local friendObj = self.friendObjList[friendId]
    if not friendObj then
        return false
    end
    if friendObj.FriendItem_tog.isOn == true then
        self:OnToggle_Friend(friendId, true)
    end
    friendObj.FriendItem_tog.isOn = true
    return true
end

local SelectColor = Color(0.16,0.17,0.19)
local UnSelectColor = Color(0.86,0.86,0.86)
function ChatMainWindow:OnToggle_Friend(friendId, isEnter)
    local friendObj = self.friendObjList[friendId]
    if not friendObj then
        return
    end
    -- self:ShowChatRedPointByFriendId(friendId)
    if isEnter then
        friendObj.Select:SetActive(true)
        friendObj.NickName_txt.color = SelectColor
    else
        self:SetDefaultFriend(friendId)
    end
    friendObj.logic:SetSelect(isEnter)
    if self.curfriendId == friendId then
        return
    end
    self.curfriendId = friendId
    friendObj.callback(friendObj, friendObj.FriendItem_tog.isOn)
end

function ChatMainWindow:SetDefaultFriend(friendId)
    local friendObj = self.friendObjList[friendId]
    if not friendObj then
        return
    end
    -- friendObj.Select:SetActive(false)
    friendObj.NickName_txt.color = UnSelectColor
end

function ChatMainWindow:GetFriendObj()
    local obj = self:PopUITmpObject("FriendItem")
    obj.FriendItem_tog.isOn = false
    obj.objectTransform:SetParent(self.FriendListContent.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    return obj
end

function ChatMainWindow:Close_HideCallBack()
    WindowManager.Instance:CloseWindow(self)
end

function ChatMainWindow:ChatInput()
    self.ChatInputField_input.text = UtilsUI.FullWidthToHalfWidth(self.ChatInputField_input.text)
end