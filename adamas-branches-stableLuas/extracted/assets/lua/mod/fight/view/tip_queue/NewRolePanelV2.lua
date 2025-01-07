NewRolePanelV2 = BaseClass("NewRolePanelV2", NewPartnerPanel)

local DataHero = Config.DataHeroMain.Find
local DataElementItem = Config.DataHeroElement.Find
local DataHeroStand = Config.DataHeroStand.Find
local DataHeroQuality = Config.DataHeroQuality.Find

local DataHeroSkill = Config.DataSkill.Find

function NewRolePanelV2:__CacheObject()
end

function NewRolePanelV2:__BindListener()
end

function NewRolePanelV2:__Show(args)
end

function NewRolePanelV2:__ShowComplete()
end

function NewRolePanelV2:__Hide()
end

function NewRolePanelV2:Init()
    local roleInfo = DataHero[self.args.roleId]

    self:SetInfo(roleInfo)
    self:InitSkillInfo(roleInfo)
end

function NewRolePanelV2:SetInfo(roleInfo)
    UtilsUI.SetActive(self.Quality, false)
    UtilsUI.SetActive(self.Attribute, true)

    local elementInfo = DataElementItem[roleInfo.element]

    -- 设置Tips
    if elementInfo then
        SingleIconLoader.Load(self.AttributeIcon, elementInfo.element_icon_big)
    end
    UtilsUI.SetActive(self.Attribute, true)
    self.Name_txt.text = TI18N(roleInfo.name)
    
    self.OneText_txt.text = TI18N("获得角色")

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

    SingleIconLoader.Load(self.OneHeadIcon, roleInfo.rhead_icon)

    UtilsUI.SetActive(self[string.format("OneBackQuality%d", roleInfo.quality)], true)
    UtilsUI.SetActive(self[string.format("TwoBackQuality%d", roleInfo.quality)], true)

    -- 启动粒子
    --self.particle = self:GetObject(DataHeroQuality[roleInfo.quality].tips_effect, self.Effect.transform)

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

    UtilsUI.SetActive(self.PartnerSkillItem, false)
    UtilsUI.SetActive(self.RoleSkillItem, true)

    if not roleInfo.show_video or roleInfo.show_video == "" then
        UtilsUI.SetActive(self.Video, false)
    else
        UtilsUI.SetActive(self.Video, true)
        self:LoadVideo(roleInfo.show_video)
    end

    if #self.skillLists >= 1 then
        self:ShowSkillInfo(1, true)
        UtilsUI.SetActive(self.Info, true)
    end
end

function NewRolePanelV2:ShowSkillInfo(index, flag)
    local skillInfo = self.skillLists[index]
    if not skillInfo then
        LogError("技能数据错误!")
        return
    end

    self:SetSkillIcon(skillInfo)
    
    self.SkillName_txt.text = "[" .. TI18N(skillInfo.name) .. "]"
    if not skillInfo.desc_brief or skillInfo.desc_brief == "" then
        self.SkillText_txt.text = ""
    else
        self.SkillText_txt.text = TI18N(skillInfo.desc_brief)
    end

    LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function ()
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.SkillText_rect)
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.ContentView_rect)
    end)

    self:CheckSkillSwitchBtn()
end

function NewRolePanelV2:SetSkillIcon(skillInfo)
    SingleIconLoader.Load(self.RoleSkillIcon, skillInfo.icon)
end