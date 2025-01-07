BulletChatShotPanel = BaseClass("BulletChatShotPanel", BasePanel)

function BulletChatShotPanel:__init()
    self:SetAsset("Prefabs/UI/BulletChat/BulletChatShotPanel.prefab")
end

function BulletChatShotPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function BulletChatShotPanel:__BindListener()
    self.CommonBack_btn.onClick:AddListener(self:ToFunc("OnClickCloseButton"))
    self.DownloadButton_btn.onClick:AddListener(self:ToFunc("OnClickDownloadButton"))
end

function BulletChatShotPanel:__BindEvent()

end

function BulletChatShotPanel:__delete()
    
end

function BulletChatShotPanel:__Show()
    self.fightMainView = WindowManager.Instance:GetWindow("FightMainUIView")

    self.mainUiIsActive = UtilsUI.IsActiveInHierarchy(self.fightMainView.gameObject)

    if self.mainUiIsActive then
        UtilsUI.SetActive(self.fightMainView.gameObject, false)
    end

    local playerInfo = mod.InformationCtrl:GetPlayerInfo()
    self.NickNameText_txt.text = playerInfo.nick_name
    self.UidText_txt.text = string.format("UID:%d", playerInfo.uid)
end

function BulletChatShotPanel:__ShowComplete()
    local setting1 = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 4, bindNode = self.BlurBackNode, downSamle = 2 }
    self.blurBack = BlurBack.New(self, setting1)
    local setting2 = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 0, bindNode = self.BlurFrontNode, downSamle = 1 }
    self.photoBlur = BlurBack.New(self, setting2)

    self.blurBack:Show({self:ToFunc("BlurBackComplete")})
    
end

function BulletChatShotPanel:BlurBackComplete()
    self.photoBlur:Show({self:ToFunc("PhotoBackComplete")})
end

function BulletChatShotPanel:PhotoBackComplete()
    self:Complete()
end

function BulletChatShotPanel:Complete()
    self:InitBtn()
end

function BulletChatShotPanel:InitBtn()
    UtilsUI.SetActive(self.NickNameText, false)
    UtilsUI.SetActive(self.UidText, false)
    UtilsUI.SetActive(self.Logo, false)
    UtilsUI.SetActive(self.ButtonList, true)
    UtilsUI.SetActive(self.BlurBackNode, true)
    UtilsUI.SetActive(self.BackGround, true)
    UtilsUI.SetActive(self.PhotoFrame, true)
    UtilsUI.SetActive(self.CommonBack, true)
    UtilsUI.SetActive(self.BlurFrontNode, true)
end

function BulletChatShotPanel:OnClickCloseButton()
    if self.mainUiIsActive then
        UtilsUI.SetActive(self.fightMainView.gameObject, true)
    end
    mod.BulletChatCtrl:OnCloseSharePanel()
end

function BulletChatShotPanel:OnClickDownloadButton()
    if not self.isSave then
        local rt = self.photoBlur:GetRt()
        if rt then
            local nowTimeStamp = TimeUtils.GetCurTimestamp()
            local name = os.date("%Y%m%d%H%M%S.png", nowTimeStamp)
            local result = CustomUnityUtils.SaveScreenShotToPng(rt, name)
            if not result then
                MsgBoxManager.Instance:ShowTips(TI18N("该图片已保存"))
                return
            end
            MsgBoxManager.Instance:ShowTips(TI18N("已保存图片"))
        else
            LogError("获取RT失败")
        end

        self.isSave = true
    else
        MsgBoxManager.Instance:ShowTips(TI18N("该图片已保存"))
    end
end