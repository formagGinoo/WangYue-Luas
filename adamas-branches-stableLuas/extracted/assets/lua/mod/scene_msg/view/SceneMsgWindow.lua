SceneMsgWindow = BaseClass("SceneMsgWindow", BaseWindow)
local MsgConfig = SceneMsgConfig.MsgConfig
local Preference = SceneMsgConfig.Preference
local ColorConfig = SceneMsgConfig.ColorConfig

function SceneMsgWindow:__init()
    self:SetAsset("Prefabs/UI/SceneMsg/SceneMsgWindow.prefab")
end

function SceneMsgWindow:__BindEvent()
    EventMgr.Instance:AddListener(EventName.SceneMsgUpdateData, self:ToFunc("UpdateData"))
end

function SceneMsgWindow:__BindListener()
     
    self:BindCloseBtn(self.CommonGrid_btn,self:ToFunc("HideEvent"))
    self:BindCloseBtn(self.SubmitBtn_btn,self:ToFunc("HideEvent"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("HideEvent"))

    self.LikeButton_btn.onClick:AddListener(self:ToFunc("OnClik_Like"))
    self.DislikeButton_btn.onClick:AddListener(self:ToFunc("OnClik_DisLike"))
end

function SceneMsgWindow:__delete()
    EventMgr.Instance:RemoveListener(EventName.SceneMsgUpdateData, self:ToFunc("UpdateData"))
end

function SceneMsgWindow:__Create()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode, passEvent = UIDefine.BlurBackCaptureType.Scene }
        self.blurBack = BlurBack.New(self, setting)
    end
    self.blurBack:Show()
end

function SceneMsgWindow:__Show()
    self.TitleText_txt.text = TI18N("青乌传书")
    if self.args == nil then
        LogError("打开传书界面时没有传入ID")
        return
    end
    self.msgId = self.args
    if MsgConfig[self.msgId] then
        self.ContentText_txt.text = MsgConfig[self.msgId].content
        self.TitleText_txt.text = MsgConfig[self.msgId].title
        SingleIconLoader.Load(self.ContentImage, MsgConfig[self.msgId].image_path)
    end
    self:ActivationButton(false)
    self:UpdateData(mod.SceneMsgCtrl:GetData(self.msgId))
end

function SceneMsgWindow:__ShowComplete()

end

function SceneMsgWindow:__Hide()
end

function SceneMsgWindow:UpdateData(msgData)
    if msgData and msgData.id == self.msgId then
        if msgData.like then
            self.LikeCount_txt.text = string.format(TI18N("(%s人)"), msgData.like + MsgConfig[self.msgId].initial_like)
        end
        if msgData.dislike then
            self.DislikeCount_txt.text = string.format(TI18N("(%s人)"), msgData.dislike + MsgConfig[self.msgId].initial_dislike)
        end
        if msgData.operation == Preference.like then
            self.LikedIcon:SetActive(true)
            self.DislikeIcon_canvas.alpha = 0.5
            UtilsUI.SetTextColor(self.LikeCount_txt, ColorConfig.select)
        elseif msgData.operation == Preference.dislike then
            self.DislikedIcon:SetActive(true)
            self.LikeIcon_canvas.alpha = 0.5
            UtilsUI.SetTextColor(self.DislikeCount_txt, ColorConfig.select)
        else
            self:ActivationButton(true)
        end
    else
        self.LikeCount_txt.text = ""
        self.DislikeCount_txt.text = ""
    end
end

function SceneMsgWindow:ActivationButton(active)
    self.LikeButton_btn.enabled = active
    self.DislikeButton_btn.enabled = active
end

function SceneMsgWindow:HideEvent()
    WindowManager.Instance:CloseWindow(SceneMsgWindow)
end

function SceneMsgWindow:OnClik_Like()
    self:ActivationButton(false)
    MsgBoxManager.Instance:ShowTips(TI18N("点赞成功"))
    local data = mod.SceneMsgCtrl:GetData(self.msgId)
    if data.like then
        data.like = data.like + 1
    end
    mod.SceneMsgCtrl:LikeMsg(self.msgId, Preference.like)
end

function SceneMsgWindow:OnClik_DisLike()
    self:ActivationButton(false)
    MsgBoxManager.Instance:ShowTips(TI18N("点踩成功"))
    local data = mod.SceneMsgCtrl:GetData(self.msgId)
    if data.dislike then
        data.dislike = data.dislike + 1
    end
    mod.SceneMsgCtrl:LikeMsg(self.msgId, Preference.dislike)
end