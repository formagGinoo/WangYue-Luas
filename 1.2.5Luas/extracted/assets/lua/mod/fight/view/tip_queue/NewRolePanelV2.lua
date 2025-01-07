NewRolePanelV2 = BaseClass("NewRolePanelV2", BasePanel)

local DataHero = Config.DataHeroMain.Find
local DataElementItem = Config.DataHeroElement.Find
local DataHeroStand = Config.DataHeroStand.Find
local DataHeroQuality = Config.DataHeroQuality.Find

local DataHeroSkill = Config.DataSkill.Find

function NewRolePanelV2:__init()
    self:SetAsset("Prefabs/UI/Notice/NewPartnerPanel.prefab")
end

function NewRolePanelV2:__delete()
    if self.blurBack then
        self.blurBack:Destroy()
    end
end

function NewRolePanelV2:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function NewRolePanelV2:__BindListener()
    self.LeftButton_btn.onClick:AddListener(self:ToFunc("OnClickSkillLastBtn"))
    self.RightButton_btn.onClick:AddListener(self:ToFunc("OnClickSkillNextBtn"))
end

function NewRolePanelV2:__Show(args)
    self:OnShow()

    InputManager.Instance:AddLayerCount(InputManager.Instance.actionMapName, "UI")

    local roleInfo = DataHero[self.args.roleId]

    self:SetInfo(roleInfo)
    self:InitSkillInfo(roleInfo)

    self:SetLayer()

    self.waitShowTimer = LuaTimerManager.Instance:AddTimer(1, 1, self:ToFunc("WaitShow"))

    self.waitCloseTimer = LuaTimerManager.Instance:AddTimer(1, 3.5, self:ToFunc("BindClose"))

    self.waitVerticalDrawingTimer = LuaTimerManager.Instance:AddTimer(1, 2.7, function ()
        self.VerticalDrawingReal_rect:DOAnchorPos({ x = self.verticalDrawingOffset[1], y = self.verticalDrawingOffset[2] }, 0.3)
    end)
end

function NewRolePanelV2:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show()
end

function NewRolePanelV2:__Hide()
    self:OnHide()

    InputManager.Instance:MinusLayerCount()

    LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function ()
        EventMgr.Instance:Fire(EventName.CloseNoticePnl)
    end)
end

function NewRolePanelV2:SetInfo(roleInfo)
    local elementInfo = DataElementItem[roleInfo.element]

    -- 设置Tips
    if elementInfo then
        SingleIconLoader.Load(self.AttributeIcon, elementInfo.element_icon_big)
    end
    UtilsUI.SetActive(self.Attribute, true)
    self.Name_txt.text = TI18N(roleInfo.name)
    
    -- 设置立绘
    if not roleInfo.stand_icon or roleInfo.stand_icon == "" then
        UtilsUI.SetActive(self.VerticalDrawingReal, false)
        self.verticalDrawingOffset = {0, 0}
    else
        local standInfo = DataHeroStand[string.format("%d_1", roleInfo.id)]
        if not standInfo then
            standInfo = DataHeroStand["0_1"]
        end
        UnityUtils.SetSizeDelata(self.VerticalDrawingReal_rect, standInfo.stand_size[1], standInfo.stand_size[2])
        self.verticalDrawingOffset = standInfo.stand_position
        UtilsUI.SetActive(self.VerticalDrawingReal, true)
        SingleIconLoader.Load(self.VerticalDrawingReal, roleInfo.stand_icon)
    end

    -- 启动粒子
    self.particle = self:GetObject(DataHeroQuality[roleInfo.quality].tips_effect, self.Effect.transform)

    self.Text_txt.text = TI18N("获得新角色")
end

function NewRolePanelV2:InitSkillInfo(roleInfo)
    self.curSkillIndex = 1
    self.skillLists = {}

    local skills = roleInfo.show_skill_list
    if skills then
        for i, skillId in ipairs(skills) do
            if skillId == 0 then
                break
            end
            self.skillLists[i] = DataHeroSkill[skillId]
        end
    end

    UtilsUI.SetActive(self.Info, false)

    if not roleInfo.show_video or roleInfo.show_video == "" then
        UtilsUI.SetActive(self.Video, false)
    else
        UtilsUI.SetActive(self.Video, true)
        self:LoadVideo(roleInfo.show_video)
    end

    if #self.skillLists >= 1 then
        self:ShowSkillInfo(1)
    end
end

function NewRolePanelV2:SetLayer()
    local layer = WindowManager.Instance:GetCurOrderLayer()

    local particleRenderers = self.particle:GetComponentsInChildren(Renderer)
    for i = 0, particleRenderers.Length - 1, 1 do
        particleRenderers[i].sortingOrder = layer + 1
    end

    self.ShowPartner:GetComponent(Canvas).sortingOrder = layer + 2
end

function NewRolePanelV2:WaitShow()
    if #self.skillLists >= 1 then
        UtilsUI.SetActive(self.Info, true)
    end
end

local ScreenFactor = math.max(Screen.width / 1280, Screen.height / 720)
function NewRolePanelV2:LoadVideo(videoPath)
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
    end

    if self.videoLoader then
        self.videoLoader:DeleteMe()
        self.videoLoader = nil
    end
    self.videoLoader = AssetBatchLoader.New("CreateVideo" .. videoPath)
    self.videoLoader:AddListener(callback)
    self.videoLoader:LoadAll(resList)
end

function NewRolePanelV2:ShowSkillInfo(index)
    local skillInfo = self.skillLists[index]
    if not skillInfo then
        LogError("技能数据错误!")
        return
    end

    SingleIconLoader.Load(self.SkillIcon, skillInfo.icon)
    self.SkillName_txt.text = "[" .. TI18N(skillInfo.name) .. "]"
    if not skillInfo.desc_brief or skillInfo.desc_brief == "" then
        self.SkillText_txt.text = ""
    else
        self.SkillText_txt.text = TI18N(skillInfo.desc_brief)
    end

    self:CheckSkillSwitchBtn()
end

function NewRolePanelV2:OnClickCloseBtn()
    if self.waitCloseTimer then
        LuaTimerManager.Instance:RemoveTimer(self.waitCloseTimer)
        self.waitCloseTimer = nil
    end

    if self.waitShowTimer then
        LuaTimerManager.Instance:RemoveTimer(self.waitShowTimer)
        self.waitShowTimer = nil
    end
    
    if self.effecrsTimer then
        LuaTimerManager.Instance:RemoveTimer(self.effecrsTimer)
        self.waitShowTimer = nil
    end

    if self.waitVerticalDrawingTimer then
        LuaTimerManager.Instance:RemoveTimer(self.waitVerticalDrawingTimer)
        self.waitVerticalDrawingTimer = nil
    end
    PanelManager.Instance:ClosePanel(NewRolePanelV2)
end

function NewRolePanelV2:OnClickSkillLastBtn()
    self.curSkillIndex = self.curSkillIndex - 1
    self:ShowSkillInfo(self.curSkillIndex)
end

function NewRolePanelV2:OnClickSkillNextBtn()
    self.curSkillIndex = self.curSkillIndex + 1
    self:ShowSkillInfo(self.curSkillIndex)
end

function NewRolePanelV2:CheckSkillSwitchBtn()
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

function NewRolePanelV2:BindClose()
    UtilsUI.SetActive(self.CloseButton, true)
    self:SetHideNode("NewPartnerPanel_Exit")
    self:BindCloseBtn(self.CloseButton_btn, self:ToFunc("OnClickCloseBtn"))
end

function NewRolePanelV2:OnShow()
    --暂停游戏
    BehaviorFunctions.Pause()
    --隐藏引导
    if true then
        local guideId, guideStage = Fight.Instance.clientFight.guideManager:GetPlayingGuide()
        if guideId then
            self.curGuideId = guideId
            self.curGuideStage = guideStage
        end
    end

    Fight.Instance.clientFight.guideManager:ClearGuidingData()
    --隐藏战斗UI
    EventMgr.Instance:Fire(EventName.ShowFightDisplay, false)
end

function NewRolePanelV2:OnHide()
    BehaviorFunctions.Resume()
    if self.curGuideId then
        Fight.Instance.clientFight.guideManager:PlayGuideGroup(self.curGuideId, self.curGuideStage, true)
    end
    EventMgr.Instance:Fire(EventName.ShowFightDisplay, true)
end