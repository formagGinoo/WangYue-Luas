MessageMainPanel = BaseClass("MessageMainPanel", BasePanel)

function MessageMainPanel:__init()
    self:SetAsset("Prefabs/UI/Phone/MessageMainPanel.prefab")
    self.MessageContents={}
end

function MessageMainPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function  MessageMainPanel:__BindEvent()
end

function MessageMainPanel:__delete()
    
end

function MessageMainPanel:__BindListener()
    self.MessageCloseBtn_btn.onClick:AddListener(self:ToFunc("Close_HideCallBack"))
end

function MessageMainPanel:CreatItem(config,messageId)
    if not self.MessageContents[messageId]then
        self.MessageContents[messageId]={}
        local itemInfo = {
        selfmessageId = messageId,
        parent = self.Content,
        itemInfo = config,
        clickCallback = self:ToFunc("SelectItemCallback"),
    }
        self.MessageContents[messageId].itemInfo = itemInfo
        self.MessageContents[messageId].Item = MessageInfromItem.New(itemInfo)
    end
end

function MessageMainPanel:SelectItemCallback(ItemInfo,messageId)
    local talkId = mod.MessageCtrl:GetProgressTalkId(ItemInfo)
    self.openTalkFunc(messageId,ItemInfo.group_id,talkId)
end

function MessageMainPanel:__Show()
   self.closeFunc = self.args.closeFunc
   self.openTalkFunc = self.args.openTalkFunc
   self:UpdataeMessageInfo()
end

function MessageMainPanel:__Hide()

end

function MessageMainPanel:UpdataeMessageInfo()
    for _k, _v in pairs(MessageConfig.MessageTypes) do
        local config = Config.DataMessageDialog.Find[_v.talk_id]
       if not config.is_finish then
        self:CreatItem(_v,_k)
       end
    end
end

function MessageMainPanel:Close_HideCallBack()
    self.closeFunc()
end
