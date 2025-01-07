AbilityFirstGetPanel = BaseClass("AbilityFirstGetPanel", BasePanel)

function AbilityFirstGetPanel:__init()
    self:SetAsset("Prefabs/UI/AbilityWheel/AbilityFirstGetPanel.prefab")
end

function AbilityFirstGetPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function AbilityFirstGetPanel:__BindListener()
    self:BindCloseBtn(self.CloseBackNode_btn)
end

function AbilityFirstGetPanel:__BindEvent()

end

function AbilityFirstGetPanel:__delete()

end

function AbilityFirstGetPanel:__Show()
    --暂停游戏
    BehaviorFunctions.Pause()
    InputManager.Instance:AddLayerCount("UI")

    self:SetBlurBack()
    local linkId = self.args.linkId
    if linkId then
        self:Init(linkId)
    else
        LogError("能力Id 为空")
    end
end

function AbilityFirstGetPanel:Init(linkId)
    local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)
    if abilityInfo then
        if abilityInfo.skill_type == AbilityWheelEnum.AbilitySkillType.Active then
            self:InitActive(abilityInfo)
        elseif abilityInfo.skill_type == AbilityWheelEnum.AbilitySkillType.Passive then
            self:InitPassive(abilityInfo)
        else
            LogError(string.format("%d 既不是主动技也不是被动技", linkId))
        end
    else
        LogError(string.format("%d 找不到对应的能力信息", linkId))
    end
end

function AbilityFirstGetPanel:InitActive(abilityInfo)
    UtilsUI.SetActive(self.PassiveSkillBackNode, false)
    UtilsUI.SetActive(self.ActiveSkillBackNode, true)
    UtilsUI.SetActive(self.PassiveSkillIconNode, false)
    UtilsUI.SetActive(self.ActiveSkillIconNode, true)
    UtilsUI.SetActive(self.PassiveSkillIconReflectionNode, false)
    UtilsUI.SetActive(self.ActiveSkillIconReflectionNode, true)
    UtilsUI.SetActive(self.PassiveSkillBottomNode, false)
    UtilsUI.SetActive(self.ActiveSkillBottomNode, true)

    self:CommonInit(abilityInfo)
end

function AbilityFirstGetPanel:InitPassive(abilityInfo)
    UtilsUI.SetActive(self.PassiveSkillBackNode, true)
    UtilsUI.SetActive(self.ActiveSkillBackNode, false)
    UtilsUI.SetActive(self.PassiveSkillIconNode, true)
    UtilsUI.SetActive(self.ActiveSkillIconNode, false)
    UtilsUI.SetActive(self.PassiveSkillIconReflectionNode, true)
    UtilsUI.SetActive(self.ActiveSkillIconReflectionNode, false)
    UtilsUI.SetActive(self.PassiveSkillBottomNode, true)
    UtilsUI.SetActive(self.ActiveSkillBottomNode, false)

    self:CommonInit(abilityInfo)
end

function AbilityFirstGetPanel:CommonInit(abilityInfo)
    self.DescTitle_txt.text = string.format("【%s】", abilityInfo.name)
    self.DescContent_txt.text = abilityInfo.desc or ""

    if abilityInfo.video then
        UtilsUI.SetActive(self.VideoNode, true)
        self:LoadVideo(abilityInfo.video)
    else
        UtilsUI.SetActive(self.VideoNode, false)
    end

    self.SkillName_txt.text = abilityInfo.name
    if abilityInfo.icon then
        UtilsUI.SetActive(self.SkillIcon, true)
        SingleIconLoader.Load(self.SkillIcon, abilityInfo.icon)
    else
        UtilsUI.SetActive(self.SkillIcon, false)
    end

    if abilityInfo.type == AbilityWheelEnum.AbilityType.Partner then
        UtilsUI.SetActive(self.PartnerIconNode, true)
        if abilityInfo.partner then
            local partnerId = abilityInfo.partner[1]
            local partnerCfg = PartnerConfig.GetPartnerConfig(partnerId)
            SingleIconLoader.Load(self.PartnerIcon, partnerCfg.chead_icon)
        else
            UtilsUI.SetActive(self.PartnerIcon, false)
        end
    else
        UtilsUI.SetActive(self.PartnerIconNode, false)
    end
end

local ScreenFactor = math.max(Screen.width / 1920, Screen.height / 1080)
function AbilityFirstGetPanel:LoadVideo(videoPath)
    local resList = {
        { path = videoPath, type = AssetType.Prefab},
    }

    local callback = function ()
        local videoObj = self.videoLoader:Pop(videoPath)
        videoObj.transform:SetParent(self.VideoNode_rect)
        videoObj.transform:ResetAttr()
		videoObj.transform.sizeDelta = self.VideoNode_rect.sizeDelta
        local videorRimg = videoObj:GetComponent(RawImage)
        local rect = videoObj.transform.rect
        local factor = math.min(ScreenFactor, 2)
        local rtTemp = CustomUnityUtils.GetTextureTemporary(math.floor(rect.width * factor), math.floor(rect.height * factor))
        videorRimg.texture = rtTemp
        local vedioPlayer = videoObj:GetComponent(CS.UnityEngine.Video.VideoPlayer)
        vedioPlayer.targetTexture = rtTemp
        if self.videoLoader then
            AssetMgrProxy.Instance:CacheLoader(self.videoLoader)
            self.videoLoader = nil
        end
    end

    self.videoLoader = AssetMgrProxy.Instance:GetLoader("CreateVideo")
    self.videoLoader:AddListener(callback)
    self.videoLoader:LoadAll(resList)
end

function AbilityFirstGetPanel:__Hide()
    InputManager.Instance:MinusLayerCount("UI")
    BehaviorFunctions.Resume()
    if self.curGuideId then
        Fight.Instance.clientFight.guideManager:PlayGuideGroup(self.curGuideId, self.curGuideStage, true)
    end

    if self.args.closeCallback then
        self.args.closeCallback()
    end
end

function AbilityFirstGetPanel:__ShowComplete()
    --隐藏引导
    local guideId, guideStage = Fight.Instance.clientFight.guideManager:GetPlayingGuide()
    if guideId then
        self.curGuideId = guideId
        self.curGuideStage = guideStage
    end
    Fight.Instance.clientFight.guideManager:ClearGuidingData()
end

function AbilityFirstGetPanel:__AfterExitAnim()
    PanelManager.Instance:ClosePanel(self)
end