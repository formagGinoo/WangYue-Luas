ChatBubbleLogic = BaseClass("ChatBubbleLogic", PoolBaseClass)

function ChatBubbleLogic:__init()
    
end

function ChatBubbleLogic:__delete()
end

function ChatBubbleLogic:Cache()
	Fight.Instance.objectPool:Cache(ChatBubbleLogic, self)
end

function ChatBubbleLogic:__cache()
	
end

local ChatType =
{
    Characters = "1:",
    EmoticonIcon = "2:",
}

function ChatBubbleLogic:Init(obj, text, meme, parent, playerInfo, timeStamp)
    self.obj = obj
    UtilsUI.SetActive(self.obj.ChatDialogue, false)
    UtilsUI.SetActive(self.obj.Chatmeme, false)
    self.chatText = text
    self.memeInfo = meme
    self.parent = parent
    self.width = 0
    self.playerInfo = playerInfo
    self.targetFriendId = self.parent.targetFriendId
    self:AddListener()
    self:SetAvatarItem()
    self:SetChatInputField()
    self:SetMeme()
    self:SetBubbleLayout()
end

function ChatBubbleLogic:Reset()
    self:RemoveListener()
    if self.timer then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
    end
    self.obj = nil
    self.chatInputField = nil
    self.memeInfo = nil
    self.parent = nil
    self.playerInfo = nil
    self.targetFriendId = nil
    self.width = 0
end

function ChatBubbleLogic:RemoveListener()
    
end

function ChatBubbleLogic:AddListener()
    
end

function ChatBubbleLogic:SetAvatarItem()
    local avatarPath
    local framePath
    local uid
    if not self.playerInfo then
        self.playerInfo = {}
        self.playerInfo.information = mod.InformationCtrl:GetPlayerInfo()
        uid = mod.InformationCtrl:GetPlayerInfo().uid
    else
        uid = self.targetFriendId
    end
    avatarPath = RoleConfig.HeroBaseInfo[self.playerInfo.information.avatar_id].chead_icon
    framePath = InformationConfig.GetFrameIcon(self.playerInfo.information.frame_id)
    self.obj.NikeName_txt.text = self.playerInfo.information.nick_name
    SingleIconLoader.Load(self.obj.HeadIcon, avatarPath)
    SingleIconLoader.Load(self.obj.HeadIconFrame, framePath)
    self.obj.AvatarItem_btn.onClick:RemoveAllListeners()
    self.obj.AvatarItem_btn.onClick:AddListener(function()
        if uid == mod.InformationCtrl:GetPlayerInfo().uid then
            return
        end
        WindowManager.Instance:OpenWindow(PlayerInfoWindow,{uid = uid})
    end)
end

function ChatBubbleLogic:SetMeme()
    if not self.memeInfo then
        return
    end
    SingleIconLoader.Load(self.obj.ChatmemeIcon, self.memeInfo.meme)
    UtilsUI.SetActive(self.obj.ChatDialogue, false)
    UtilsUI.SetActive(self.obj.Chatmeme, true)
    UtilsUI.SetActive(self.obj.Bubble, false)
end

function ChatBubbleLogic:SetChatInputField()
    if self.chatText and not self.memeInfo then
        self.obj.ChatDialogue_txt.text = self.chatText
        self.width = self.obj.ChatDialogue_txt.preferredWidth
        UtilsUI.SetActive(self.obj.ChatDialogue, true)
        UtilsUI.SetActive(self.obj.Chatmeme, false)
        UtilsUI.SetActive(self.obj.Bubble, true)
    end
end

function ChatBubbleLogic:SetBubbleLayout()
    UtilsUI.SetActive(self.obj.object, false)
    self.timer = LuaTimerManager.Instance:AddTimer(10,0.02,function()
        if not self.parent or not self.obj then
            return
        end
        self:ForceRebuildLayout()
    end)
    self:SetBubbleWidth()
    self:ForceRebuildLayout()
end

function ChatBubbleLogic:ForceRebuildLayout()
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.obj.AvatarItem.transform.parent)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.parent.ChatContent.transform)
    UtilsUI.SetActive(self.obj.object, true)
end

function ChatBubbleLogic:SetBubbleWidth()
    -- 表情包
    if self.memeInfo then
        self.width = 100
    end
    -- 文字
    if self.width <= 522 then
        UnityUtils.SetSizeDelata(self.obj.Bubble_rect, self.width + 35, self.obj.Bubble_rect.height)
    else
        UnityUtils.SetSizeDelata(self.obj.Bubble_rect, 522 , self.obj.Bubble_rect.height)
    end
end

function ChatBubbleLogic:SendChat()
    local content
    if self.memeInfo then
        content = ChatType.EmoticonIcon .. self.memeInfo.id
    else
        content = ChatType.Characters .. self.chatText
    end
    local nowTimeStamp = TimeUtils.GetCurTimestamp() * 1000
    mod.FriendCtrl:UpdateChatListBySendChat(self.targetFriendId, content, nowTimeStamp)
    mod.FriendCtrl:SendChat(self.targetFriendId, content)
    LuaTimerManager.Instance:AddTimer(2, 0.05,function()
        self.parent:SetChatContentY()
    end)
end