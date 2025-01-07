PartnerSkillInfoPanel = BaseClass("PartnerSkillInfoPanel", BasePanel)

function PartnerSkillInfoPanel:__init()
    self:SetAsset("Prefabs/UI/Partner/PartnerSkillInfoPanel.prefab")
end

function PartnerSkillInfoPanel:__delete()
    
end

function PartnerSkillInfoPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy) 
end

function PartnerSkillInfoPanel:__BindListener()
    self:SetHideNode("PartnerSkillInfoPanel_Exit")
    self:BindCloseBtn(self.BGButton_btn,self:ToFunc("HideCallback"))
end

function PartnerSkillInfoPanel:__Show()
    self:SetAcceptInput(true)
    self.canShow = true
    self:ChangeSkill(self.args.template_id, self.args.unique_id, self.args.skillId, self.args.index)
    self.callBack = self.args.callBack
    if self.callBack then
        self.callBack()
    end
end

function PartnerSkillInfoPanel:__Hide()
end

function PartnerSkillInfoPanel:ChangeSkill(template_id, unique_id, skillId, index)
    self:SetSkillInfo(template_id, unique_id, skillId)
    if self.canShow then
        self:ShowDetail(template_id,unique_id, skillId, index)
    end
end

function PartnerSkillInfoPanel:SetSkillInfo(template_id, unique_id, skillId, index)
    self.skillId = skillId
    self.partnerTemplateId = template_id
    self.partnerUniqueId = unique_id
end

function PartnerSkillInfoPanel:ShowDetail(partnerTemplateId, partnerUniqueId, skillId, index)
    self.BGButton:SetActive(not self.parentWindow)
    local skillConfig = RoleConfig.GetPartnerSkillConfig(skillId)
	local lev = mod.BagCtrl:GetPartnerSkillLevel(partnerUniqueId, skillId) or 1
    local levelConfig = RoleConfig.GetPartnerSkillLevelConfig(skillId, lev)

    self.LockBg:SetActive(false)
    SingleIconLoader.Load(self.Icon, skillConfig.icon)
    self.Box:SetActive(skillConfig.type == RoleConfig.PartnerSkillType.Specificity)
    self.Level_txt.text = lev

    self.SkillName_txt.text = skillConfig.name
    self.CurLevel_txt.text = lev
    self.MaxLevel_txt.text = RoleConfig.GetPartnerSkillMaxLev(partnerTemplateId)
    self.PosName_txt.text = RoleConfig.PartnerSkillDesc[skillConfig.type]

    if not levelConfig.video or levelConfig.video == "" then
        UtilsUI.SetActive(self.Video, false)
        local sizeDelta = self.DescView_rect.sizeDelta
        sizeDelta.y = 300 + self.Video_rect.sizeDelta.y
        self.DescView_rect.sizeDelta = sizeDelta
        self.AttrView_rect.sizeDelta = sizeDelta
    else
        UtilsUI.SetActive(self.Video, true)
        local sizeDelta = self.DescView_rect.sizeDelta
        sizeDelta.y = 300
        self.DescView_rect.sizeDelta = sizeDelta
        self.AttrView_rect.sizeDelta = sizeDelta
        for i = self.Video_rect.childCount, 1, -1 do
            GameObject.DestroyImmediate(self.Video_rect:GetChild(i - 1).gameObject)
        end
        self:CreateVideo(levelConfig.video)
    end
    self.DescText_txt.text = levelConfig.desc_info

    --TODO 临时判断条件
    self.PowerUp:SetActive(skillConfig.type == RoleConfig.PartnerSkillType.Talent)
    self.LockPart:SetActive(skillConfig.type ~= RoleConfig.PartnerSkillType.Talent and partnerUniqueId ~= nil)
    self.PowerUpButton:SetActive(partnerUniqueId ~= nil)
    if skillConfig.type == RoleConfig.PartnerSkillType.Talent then
        self.PowerUpButton_btn.onClick:RemoveAllListeners()
        self.PowerUpButton_btn.onClick:AddListener(function ()
            local config = {
                uniqueId = partnerUniqueId,
                initTag = RoleConfig.PartnerPanelType.Talent,
                defaultParm = index,
            }
            if self.parentWindow then
                self.parentWindow:ClosePanel(self)
            else
                self:Close()
            end
            WindowManager.Instance:OpenWindow(PartnerMainWindow,config)
        end)
    end
end

local ScreenFactor = math.max(Screen.width / 1280, Screen.height / 720)
function PartnerSkillInfoPanel:CreateVideo(videoPath)
    local resList = {
        {path = videoPath, type = AssetType.Prefab},
    }

    local callback = function ()
        local videoObj = self.videoLoader:Pop(videoPath)
        videoObj.transform:SetParent(self.Video_rect)
        videoObj.transform:ResetAttr()
		videoObj.transform.sizeDelta = self.Video_rect.sizeDelta
        local videorRimg = videoObj:GetComponent(RawImage)
        local rect = videoObj.transform.rect
        local factor = math.min(ScreenFactor, 2)
        local rtTemp = CustomUnityUtils.GetTextureTemporary(math.floor(rect.width * factor), math.floor(rect.height * factor))
        videorRimg.texture = rtTemp
        local vedioPlayer = videoObj:GetComponent(CS.UnityEngine.Video.VideoPlayer)
        vedioPlayer.targetTexture = rtTemp
    end

    if self.videoLoader then
        self.videoLoader:DeleteMe()
        self.videoLoader = nil
    end
    self.videoLoader = AssetBatchLoader.New("CreateVideo"..videoPath)
    self.videoLoader:AddListener(callback)
    self.videoLoader:LoadAll(resList)
end

function PartnerSkillInfoPanel:Close()
    self.PartnerSkillInfoPanel_Exit:SetActive(true)
end

function PartnerSkillInfoPanel:HideCallback()
    if self.parentWindow then
        self.parentWindow:ClosePanel(self)
    else
        PanelManager.Instance:ClosePanel(self)
    end

end