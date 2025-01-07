DebugStoryPanel = BaseClass("DebugStoryPanel", BasePanel)

function DebugStoryPanel:__init()
    self:SetAsset("Prefabs/UI/FightDebug/DebugStory.prefab")
end

function DebugStoryPanel:__ShowComplete()
    self.canvas.sortingOrder = 9999
    if ctx.Editor and BehaviorFunctions.fight then
        if BehaviorFunctions.fight.storyDialogManager.ignoreSkipConfig then
            self.IgnoreSkip_img.color = Color.green
        else
            self.IgnoreSkip_img.color = Color.white
        end
    end
end

function DebugStoryPanel:__BindListener()
    self.dialogIdInput = UtilsUI.GetInputField(self.DialogIdInput)
    self.timeInInput = UtilsUI.GetInputField(self.TimeInInput)
    self.timeOutInput = UtilsUI.GetInputField(self.TimeOutInput)
    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClick_Submit"))
    self.Reset_btn.onClick:AddListener(self:ToFunc("OnClick_Reset"))
    self.IgnoreSkip_btn.onClick:AddListener(self:ToFunc("OnClick_IgnoreSkip"))
    self.Cancel_btn.onClick:AddListener(self:ToFunc("OnClick_Cancel"))
end

function DebugStoryPanel:OnClick_Submit()
    local dialogId = tonumber(self.dialogIdInput.text)
    local timeIn = tonumber(self.timeInInput.text)
    local timeOut = tonumber(self.timeOutInput.text)
    BehaviorFunctions.StartStoryDialog(dialogId, nil, timeIn or 0, timeOut or 0)
end

function DebugStoryPanel:OnClick_Reset()
    self.dialogIdInput.text = ""
    self.timeInInput.text = ""
    self.timeOutInput.text = ""
end

function DebugStoryPanel:OnClick_IgnoreSkip()
    local res = BehaviorFunctions.fight.storyDialogManager:ChangeIgnoreSkipConfig()
    if res then
        self.IgnoreSkip_img.color = Color.green
    else
        self.IgnoreSkip_img.color = Color.white
    end
end

function DebugStoryPanel:OnClick_Cancel()
    self:Hide()
end