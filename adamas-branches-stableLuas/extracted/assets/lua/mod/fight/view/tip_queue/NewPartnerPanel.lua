NewPartnerPanel = BaseClass("NewPartnerPanel", BasePanel)

local DataPartnerStand = Config.DataPartnerStand.Find
local DataPartnerQuality = Config.DataPartnerQuality.Find

local VideoPosition = {
    Work  = {x = 339, y = 12, z = 0}, --佩丛开启工作后的位置
}

function NewPartnerPanel:__init()
    self:SetAsset("Prefabs/UI/Notice/NewPartnerPanel.prefab")
    self.workItemObjList = {}
end

function NewPartnerPanel:__delete()
    for i, v in pairs(self.workItemObjList) do
        self:PushUITmpObject("workItem", v)
    end
    TableUtils.ClearTable(self.workItemObjList)
end

function NewPartnerPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function NewPartnerPanel:__BindListener()
    self.LeftButton_btn.onClick:AddListener(self:ToFunc("OnClickSkillLastBtn"))
    self.RightButton_btn.onClick:AddListener(self:ToFunc("OnClickSkillNextBtn"))
end

function NewPartnerPanel:__Show(args)
    self:OnShow()

    self:Init()

    UtilsUI.SetHideCallBack(self.NewPartnerPanel_in, self:ToFunc("BindClose"))
end

function NewPartnerPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show()
end

function NewPartnerPanel:__Hide()
    self:OnHide()
    --EventMgr.Instance:Fire(EventName.TipHideEvent, self.__className)
end

function NewPartnerPanel:Init()
    local partnerInfo = ItemConfig.GetPartnerGroupInfo(self.args.partnerId)

    self:SetInfo(partnerInfo)
    --如果佩丛工作开启了，并且佩丛具有工作功能
    local isShowWork = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.PartnerWork)
    if isShowWork then
        local partnerWorkCfg = PartnerBagConfig.GetPartnerWorkConfig(self.args.partnerId)
        --读表判断该佩丛是否有生产功能
        if not partnerWorkCfg then
            isShowWork = false
        end
    end
    if isShowWork then
        self:InitWorkInfo(partnerInfo)
    else
        self:InitSkillInfo(partnerInfo)
    end

    if not partnerInfo.show_video or partnerInfo.show_video == "" then
        UtilsUI.SetActive(self.Video, false)
    else
        UtilsUI.SetActive(self.Video, true)
        self:LoadVideo(partnerInfo.show_video)
    end
end

function NewPartnerPanel:SetInfo(partnerInfo)
    UtilsUI.SetActive(self.Quality, true)
    UtilsUI.SetActive(self.Attribute, false)

    -- 设置Tips
    local qualityInfo = DataPartnerQuality[partnerInfo.quality]
    SingleIconLoader.Load(self.PartnerQualityBg, qualityInfo.icon)
    self.PartnerQualityDesc_txt.text = TI18N(qualityInfo.name)
    UtilsUI.SetActive(self.Quality, true)
    self.Name_txt.text = TI18N(partnerInfo.name)

    self.OneText_txt.text = TI18N("获得月灵")

    -- 设置立绘
    if not partnerInfo.stand_icon or partnerInfo.stand_icon == "" then
        UtilsUI.SetActive(self.VerticalDrawingReal, false)
        self.verticalDrawingOffset = {0, 0}
    else
        local standInfo = DataPartnerStand[string.format("%d_1", partnerInfo.id)]
        if not standInfo then
            standInfo = DataPartnerStand["0_1"]
        end
        UnityUtils.SetSizeDelata(self.VerticalDrawingReal_rect, standInfo.stand_size[1], standInfo.stand_size[2])
        self.verticalDrawingOffset = standInfo.stand_position
        UtilsUI.SetActive(self.VerticalDrawingReal, true)
        SingleIconLoader.Load(self.VerticalDrawingReal, partnerInfo.stand_icon)
    end
    
    SingleIconLoader.Load(self.OneHeadIcon, partnerInfo.head_icon)
    
    UtilsUI.SetActive(self[string.format("OneBackQuality%d", partnerInfo.quality)], true)
    UtilsUI.SetActive(self[string.format("TwoBackQuality%d", partnerInfo.quality)], true)

    -- 启动粒子
    --self.particle = self:GetObject(DataPartnerQuality[partnerInfo.quality].tips_effect, self.Effect.transform)

    self.Text_txt.text = TI18N("获得新月灵")
end

function NewPartnerPanel:InitWorkInfo(partnerInfo)
    --隐藏战斗相关信息
    UtilsUI.SetActive(self.fightInfo, false)
    --设置video位置
    UnityUtils.SetLocalPosition(self.VideoBack.transform, VideoPosition.Work.x, VideoPosition.Work.y, VideoPosition.Work.z)
    --展示佩丛工作相关信息
    UtilsUI.SetActive(self.workInfo, true)
    
    local partnerWorkCfg = PartnerBagConfig.GetPartnerWorkConfig(self.args.partnerId)
    for i, v in ipairs(partnerWorkCfg.career) do
        local careerId = v[1]
        if careerId ~= 0 then
            if not self.workItemObjList[i] then
                self.workItemObjList[i] = self:GetWorkItem(self.workIconList.transform)
            end
            local partnerCareerCfg = PartnerBagConfig.GetPartnerWorkCareerCfgById(careerId)
            self.workItemObjList[i].name_txt.text = partnerCareerCfg.name
            if partnerCareerCfg.icon ~= "" then
                SingleIconLoader.Load(self.workItemObjList[i].icon, partnerCareerCfg.icon)
            end
        end
    end
end

function NewPartnerPanel:GetWorkItem(parent)
    local obj = self:PopUITmpObject("workItem", parent)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UnityUtils.SetLocalEulerAngles(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    UtilsUI.SetActive(obj.object, true)
    return obj
end

function NewPartnerPanel:InitSkillInfo(partnerInfo)
    self.curSkillIndex = 1
    self.skillLists = {}

    local skillsList = Config.DataPartnerSkill.Find 
    local skills = partnerInfo.show_skill_list
    for i, skillId in ipairs(skills) do
        if skillId == 0 then
            break
        end
        self.skillLists[i] = skillsList[skillId]
    end


    UtilsUI.SetActive(self.PartnerSkillItem, true)
    UtilsUI.SetActive(self.RoleSkillItem, false)
    self.SkillItemCont = UtilsUI.GetContainerObject(self.PartnerSkillItem)

    if #self.skillLists >= 1 then
        self:ShowSkillInfo(1, true)
        UtilsUI.SetActive(self.Info, true)
    end
end

local ScreenFactor = math.max(Screen.width / 1920, Screen.height / 1080)
function NewPartnerPanel:LoadVideo(videoPath)
    local resList = {
        { path = videoPath, type = AssetType.Prefab},
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
        if self.videoLoader then
            AssetMgrProxy.Instance:CacheLoader(self.videoLoader)
            self.videoLoader = nil
        end
    end

    self.videoLoader = AssetMgrProxy.Instance:GetLoader("CreateVideo")
    self.videoLoader:AddListener(callback)
    self.videoLoader:LoadAll(resList)
end

function NewPartnerPanel:ShowSkillInfo(index, flag)
    local skillInfo = self.skillLists[index]
    if not skillInfo then
        LogError("技能数据错误!")
        return
    end

    self:SetSkillIcon(skillInfo)
    
    self.SkillName_txt.text = "[" .. TI18N(skillInfo.name) .. "]"
    if not skillInfo.desc or skillInfo.desc == "" then
        self.SkillText_txt.text = ""
    else
        self.SkillText_txt.text = TI18N(skillInfo.desc)
    end

    LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function ()
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.SkillText_rect)
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.ContentView_rect)
    end)

    self:CheckSkillSwitchBtn()
end

function NewPartnerPanel:SetSkillIcon(skillInfo)
    SingleIconLoader.Load(self.SkillItemCont.SkillIcon, skillInfo.icon)
end

function NewPartnerPanel:OnClickCloseBtn()
    if self.waitCloseTimer then
        LuaTimerManager.Instance:RemoveTimer(self.waitCloseTimer)
        self.waitCloseTimer = nil
    end

    PanelManager.Instance:ClosePanel(self)
end

function NewPartnerPanel:OnClickSkillLastBtn()
    self.curSkillIndex = self.curSkillIndex - 1
    self:ShowSkillInfo(self.curSkillIndex)
end

function NewPartnerPanel:OnClickSkillNextBtn()
    self.curSkillIndex = self.curSkillIndex + 1
    self:ShowSkillInfo(self.curSkillIndex)
end

function NewPartnerPanel:CheckSkillSwitchBtn()
    if self.curSkillIndex <= 1 then
        UtilsUI.SetActive(self.LeftButton, false)
    else
        UtilsUI.SetActive(self.LeftButton, true)
    end

    if self.curSkillIndex >= #self.skillLists then
        UtilsUI.SetActive(self.RightButton, false)
    else
        UtilsUI.SetActive(self.RightButton, true)
    end
end

function NewPartnerPanel:BindClose()
    --UtilsUI.SetActive(self.CloseButton, false)
    self:BindCloseBtn(self.CloseButton_btn, self:ToFunc("OnClickCloseBtn"))
end

function NewPartnerPanel:CloseEf()
    UtilsUI.SetActive(self.NewPartnerPanel_Exit, true)
end

function NewPartnerPanel:OnShow()
    --暂停游戏
    BehaviorFunctions.Pause()
    --隐藏引导
    local guideId, guideStage = Fight.Instance.clientFight.guideManager:GetPlayingGuide()
    if guideId then
        self.curGuideId = guideId
        self.curGuideStage = guideStage
    end

    Fight.Instance.clientFight.guideManager:ClearGuidingData()
    --隐藏战斗UI
    EventMgr.Instance:Fire(EventName.ShowFightDisplay, false)

    InputManager.Instance:AddLayerCount("UI")
    EventMgr.Instance:Fire(EventName.ShowFightDisplay, true)
    EventMgr.Instance:Fire(EventName.ShowCursor, true)
end

function NewPartnerPanel:OnHide()
    BehaviorFunctions.Resume()
    if self.curGuideId then
        Fight.Instance.clientFight.guideManager:PlayGuideGroup(self.curGuideId, self.curGuideStage, true)
    end
    InputManager.Instance:MinusLayerCount("UI")
    EventMgr.Instance:Fire(EventName.ShowCursor, false)
end

function NewPartnerPanel:__AfterExitAnim()
    self:OnClickCloseBtn()
end