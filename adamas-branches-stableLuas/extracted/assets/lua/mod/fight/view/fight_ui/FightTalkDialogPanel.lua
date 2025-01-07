FightTalkDialogPanel = BaseClass("FightTalkDialogPanel",BaseView)

function FightTalkDialogPanel:__init()
	self:SetAsset("Prefabs/UI/Fight/DiaogPanel/talk_dialog_panel.prefab")
    self.dialogConfig = nil
end

function FightTalkDialogPanel:__delete()
end

function FightTalkDialogPanel:__CacheObject()
	self.nameText = UtilsUI.GetText(self:Find("name"))
    self.contentText = UtilsUI.GetText(self:Find("content"))

    self.optionItems = {}
    for i=1,6 do self:GetOptionItem(i) end
end

function FightTalkDialogPanel:GetOptionItem(index)
    local root = self:Find("options/"..index)
    local objs = {}
    objs.node = root.gameObject
    objs.btn = root.gameObject:GetComponent(Button)
    objs.icon = root:Find("icon").gameObject:GetComponent(Image)
    objs.msg = UtilsUI.GetText(root:Find("msg").gameObject)
    table.insert(self.optionItems,objs)
end

function FightTalkDialogPanel:__Create()
end

function FightTalkDialogPanel:__BindEvent()
end

function FightTalkDialogPanel:__BindListener()
    self:Find("bg",Button).onClick:AddListener(self:ToFunc("BackClick"))

    for i,v in ipairs(self.optionItems) do
        v.btn:SetClick(self:ToFunc("OptionClick"),i)
    end
end

function FightTalkDialogPanel:__Show()
    local dialogId = self.args
    self:SetDialogConfig(dialogId)
    self:RefreshInfo()
	EventMgr.Instance:Fire(EventName.ActiveView, FightEnum.UIActiveType.Main, false)
end

function FightTalkDialogPanel:__Hide()

end

function FightTalkDialogPanel:PassClick()
    self:CloseDialog()
end

function FightTalkDialogPanel:NextClick()
    if self.dialogConfig.next_id ~= 0 then
        self:SetDialogConfig(self.dialogConfig.next_id)
        self:RefreshInfo()
    else
        self:CloseDialog()
    end
end

function FightTalkDialogPanel:RefreshInfo()
    if not self.dialogConfig then
        return
    end

    self.nameText.text = self.dialogConfig.name
    self.contentText.text = self.dialogConfig.content

    for i,v in ipairs(self.dialogConfig.options) do
        local objs = self.optionItems[i]
        objs.node:SetActive(true)

        local msg = v[1]
        local icon = v[2]

        --设置icon
        objs.msg.text = msg

        self:SetSprite(objs.icon,AssetConfig.fightTalkOptionIcon,tostring(icon),true)
    end

    for i=#self.dialogConfig.options + 1,#self.optionItems do
        self.optionItems[i].node:SetActive(false)
    end
end

function FightTalkDialogPanel:SetDialogConfig(dialogId)
    self.dialogConfig = Config.DataFightDialog.data_talk_dialog[dialogId]
	if not self.dialogConfig then
		LogError("找不到Npc对话框配置 ".. dialogId)
	end
end

function FightTalkDialogPanel:CloseDialog()
	EventMgr.Instance:Fire(EventName.ActiveView, FightEnum.UIActiveType.Main, true)
    self:Hide()
end

function FightTalkDialogPanel:BackClick()
    if #self.dialogConfig.options > 0 then
        return
    end

    if self.dialogConfig.next_id == 0 then
        self:CloseDialog()
    else
        self:SetDialogConfig(self.dialogConfig.next_id)
        self:RefreshInfo()
    end
end

function FightTalkDialogPanel:OptionClick(index)
    local data = self.dialogConfig.options[index]
    local nextId = data[3]

    if nextId == 0 then
        self:CloseDialog()
		EventMgr.Instance:Fire(EventName.KeyAutoUp, FightEnum.CommonKeyIndex[index])
    else
        self:SetDialogConfig(nextId)
        self:RefreshInfo()
    end
end