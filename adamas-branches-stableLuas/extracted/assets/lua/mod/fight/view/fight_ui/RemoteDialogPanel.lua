RemoteDialogPanel = BaseClass("RemoteDialogPanel",BaseView)

function RemoteDialogPanel:__init()
	self:SetAsset("Prefabs/UI/Fight/DiaogPanel/remote_dialog_panel.prefab")
    self.dialogConfig = nil
    self.showTimer = nil
    self.settings = {}
end

function RemoteDialogPanel:__delete()
	self:RemoveTimer()
end

function RemoteDialogPanel:__CacheObject()
	self.nameText = UtilsUI.GetText(self:Find("info_node/name"))
    self.passBtnNode = self:Find("info_node/pass_btn").gameObject
    self.contentText = UtilsUI.GetText(self:Find("info_node/content"))
    self.nextBtnNode = self:Find("next_btn").gameObject
end

function RemoteDialogPanel:__Create()
end

function RemoteDialogPanel:__BindEvent()
end

function RemoteDialogPanel:__BindListener()
    self:Find("info_node/pass_btn",Button).onClick:AddListener(self:ToFunc("PassClick"))
    self:Find("next_btn",Button).onClick:AddListener(self:ToFunc("NextClick"))
end

function RemoteDialogPanel:__Show()
    self.settings = self.args
    local dialogId = self.settings.dialogId
    local isHideMain = self.settings.isHideMain or false
    self:SetDialogConfig(dialogId)
    self:RefreshInfo()
    
    if isHideMain then
        EventMgr.Instance:Fire(EventName.ActiveView, FightEnum.UIActiveType.Main, false)
    end
end

function RemoteDialogPanel:__Hide()
    self:RemoveTimer()
end

function RemoteDialogPanel:PassClick()
    self:CloseDialog()
    EventMgr.Instance:Fire(EventName.KeyAutoUp, FightEnum.KeyEvent.Common2)
end

function RemoteDialogPanel:NextClick()
    if self.dialogConfig.next_id ~= 0 then
        self:SetDialogConfig(self.dialogConfig.next_id)
        self:RefreshInfo()
    else
        self:CloseDialog()
        EventMgr.Instance:Fire(EventName.KeyAutoUp, FightEnum.KeyEvent.Common2)
    end
end

function RemoteDialogPanel:RefreshInfo()
    if not self.dialogConfig then
        return
    end

    self.passBtnNode:SetActive(self.dialogConfig.exist_btn)
    self.nextBtnNode:SetActive(self.dialogConfig.exist_btn)

    self.nameText.text = self.dialogConfig.name
    self.contentText.text = self.dialogConfig.content
    
    local headIconPath = AssetConfig.GetDialogIcon(self.dialogConfig.head)
    SingleIconLoader.Load(self.HeadImage, headIconPath)

    if not self.dialogConfig.exist_btn and self.dialogConfig.last_time > 0 then
        self:RemoveTimer()
        self.showTimer = LuaTimerManager.Instance:AddTimer(1,self.dialogConfig.last_time,self:ToFunc("LastTimeComplete"))
    end
end

function RemoteDialogPanel:SetDialogConfig(dialogId)
    self.dialogConfig = Config.DataFightDialog.data_remote_dialog[dialogId]
	if not self.dialogConfig then
		LogError("找不到远程对话框配置 ".. dialogId)
	end
end

function RemoteDialogPanel:CloseDialog()
    local isHideMain = self.settings.isHideMain or false
    if isHideMain then
        EventMgr.Instance:Fire(EventName.ActiveView, FightEnum.UIActiveType.Main, true)
    end

    self:Hide()
end

function RemoteDialogPanel:LastTimeComplete()
    self.showTimer = nil
    self:CloseDialog()
end

function RemoteDialogPanel:RemoveTimer()
    if self.showTimer then
        LuaTimerManager.Instance:RemoveTimer(self.showTimer)
        self.showTimer = nil
    end
end