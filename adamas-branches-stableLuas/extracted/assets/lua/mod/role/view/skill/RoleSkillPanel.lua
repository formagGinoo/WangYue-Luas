RoleSkillPanel = BaseClass("RoleSkillPanel", BasePanel)
local roleIndex = "RoleRoot"

function RoleSkillPanel:__init()
    self:SetAsset("Prefabs/UI/Skill/RoleSkillPanel.prefab")
    self.skillObjMap = {}
    self.skillMap = {}
end

function RoleSkillPanel:__delete()
	EventMgr.Instance:RemoveListener(EventName.RoleInfoUpdate, self:ToFunc("RoleInfoUpdate"))
    EventMgr.Instance:AddListener(EventName.ShowRoleModelLoad, self:ToFunc("ChangeShowRole"))
end

function RoleSkillPanel:__Create()
    local tf = self:GetModelView():GetTargetTransform("RoleSkill3D", true)
    self.part3D = UtilsUI.GetContainerObject(tf)
end

function RoleSkillPanel:__BindListener()
	EventMgr.Instance:AddListener(EventName.RoleInfoUpdate, self:ToFunc("RoleInfoUpdate"))
    EventMgr.Instance:AddListener(EventName.ShowRoleModelLoad, self:ToFunc("ChangeShowRole"))
    --self.Viewport_btn.onClick:AddListener(self:ToFunc("CloseInfoPanel"))
    self.BGButton_btn.onClick:AddListener(self:ToFunc("CloseInfoPanel"))
end

function RoleSkillPanel:__Show()
    EventMgr.Instance:AddListener(EventName.SkillInfoChange, self:ToFunc("RoleSkillChange"))
    self.uid = self.args.uid
    --self.Content_rect:DOAnchorPosX(self.DefaultPos_rect.anchoredPosition.x, 0)
    self:AnalysePrefab()
    self:ChangeShowRole()
    self.part3D.Root:SetActive(true)
end

function RoleSkillPanel:__Hide()
    EventMgr.Instance:RemoveListener(EventName.SkillInfoChange, self:ToFunc("RoleSkillChange"))
    self.parentWindow:ClosePanel(SkillInfoPanel)
    if self.oldNode then
        UtilsUI.SetActive(self.oldNode.SelectBox, false)
    end
    self.part3D.Root:SetActive(false)
end

function RoleSkillPanel:__BeforeExitAnim()
    self.part3D._uianim:PlayExitAnimator()
end

function RoleSkillPanel:__AfterExitAnim()
    self.parentWindow:ClosePanel(RoleSkillPanel)
end

function RoleSkillPanel:ChangeShowRole(notTransition)
    if not self.active then
        return
    end
    self._uianim:PlayEnterAnimator()
    self.part3D._uianim:PlayEnterAnimator()
	--self.Content_rect.anchoredPosition = Vector2.zero
    self:AnalyseRoleSkill()
    self:ShowSkillNodes()
    --self:SetContentSize()
    self:SetCameraView(self:GetCurRole(), RoleConfig.PageCameraType.Skill, notTransition)
    local blurConfig = RoleConfig.GetRoleBlurConfig(self:GetCurRole(), RoleConfig.PageBlurType.Skill)
    self:GetModelView():SetDepthOfFieldBoken(true, blurConfig.focus_distance, blurConfig.focal_length, blurConfig.aperture)
end

function RoleSkillPanel:RoleSkillChange(roleId, newSkill)
    if roleId ~= self:GetCurRole() then
        return
    end
    local lev, ex_lev = mod.RoleCtrl:GetSkillInfo(roleId, newSkill.order_id,self.uid)
    local config = {
        skillId = newSkill.order_id,
        oldLev = lev, ex_lev,
        newLev = newSkill.lev + newSkill.ex_lev
    }
    PanelManager.Instance:OpenPanel(SkillUpgradeTipPanel, config)
end

function RoleSkillPanel:RoleInfoUpdate(index, roleData)
    if roleData.id ~= self:GetCurRole() then
        return
    end
    PanelManager.Instance:ClosePanel(SkillUpgradePanel)
    self:ShowSkillNodes()
    local panel = self.parentWindow:GetPanel(SkillInfoPanel)
    if panel and panel.active then
        --self:SetContentSize()
        --self.Content_rect.position = oldPos
        panel:ChangeSkill()
    end
end

function RoleSkillPanel:SetCameraView(roleId, case, notTransition, onlyCam)
    local cameraConfig = RoleConfig.GetRoleCameraConfig(roleId, case)
    if notTransition then
        self:GetModelView():SetCameraSettings(cameraConfig.camera_position, cameraConfig.camera_rotation, 24.5)
    else
        self:GetModelView():BlendToNewCamera(cameraConfig.camera_position, cameraConfig.camera_rotation, 24.5)
    end
    if not onlyCam then
        self:GetModelView():PlayModelAnim(roleIndex, cameraConfig.anim, 0.5)
    end
    self:GetModelView():SetModelRotation(roleIndex,  cameraConfig.model_rotation)
end

--暂时不需要动态加载
function RoleSkillPanel:LoadPrefab()

end

function RoleSkillPanel:AnalysePrefab()
    self:PushAllUITmpObject("SkillObj", self.Cache_rect)
    TableUtils.ClearTable(self.skillObjMap)
    --暂定最大10类型
    for i = 1, 3, 1 do
        --每个类型最大20个技能
        self.skillObjMap[i] = {}
        self["TypeTitle"..i.."_txt"].text = RoleConfig.GetSkillTypeName(i) or ""
        local root = self["TypeContent"..i.."_rect"]
        for j = 1, 4, 1 do
            self.skillObjMap[i][j] = self:PopUITmpObject("SkillObj", root)
            UnityUtils.SetAnchored3DPosition(self.skillObjMap[i][j].objectTransform, 0, 0, 0)
        end
    end
end

function RoleSkillPanel:AnalyseRoleSkill()
    TableUtils.ClearTable(self.skillMap)
    local skillInfos = self:GetCurRoleSkillData()
    for key, skillId in pairs(skillInfos) do
        local config = RoleConfig.GetSkillUiConfig(skillId)
        if config and next(config) then
            if config.skill_type < 4 then
                self.skillObjMap[config.skill_type][config.pos].Name_txt.text = config.pos_name
                if not self.skillMap[config.skill_type] then
                    self.skillMap[config.skill_type] = {}
                end
                self.skillMap[config.skill_type][config.pos] = skillId
            end
        end
    end
end

function RoleSkillPanel:ShowSkillNodes()
    for type, value in pairs(self.skillObjMap) do
        if next(value) then
            for pos, node in pairs(value) do
                if self.skillMap[type] and self.skillMap[type][pos] then
                    UtilsUI.SetActive(node.object, true)
                    self:SkillObjDetail(type, pos)
                else
                    UtilsUI.SetActive(node.object, false)
                end
            end
        end
    end
end

function RoleSkillPanel:SkillObjDetail(type, pos)
    local node = self.skillObjMap[type][pos]
    local skillId = self.skillMap[type][pos]
    local roleId = self:GetCurRole()
    local lev, exLev = mod.RoleCtrl:GetSkillInfo(roleId, skillId,self.uid)
    local skillConfig = RoleConfig.GetSkillConfig(skillId)
    if skillConfig.condition_id then
        local isPass, desc = Fight.Instance.conditionManager:CheckConditionByConfig(skillConfig.condition_id)
        if not isPass then
            UtilsUI.SetActive(node.object, false)
            return
        end
    end
    --local skillLevelConfig = RoleConfig.GetSkillLevelConfig(skillId, lev + exLev)

    UtilsUI.SetActive(node.Locked, lev + exLev == 0)
    if lev + exLev == 0 then
        --node.Icon_canvas.alpha = 0.3
    else
        --node.Icon_canvas.alpha = 1
    end
    UtilsUI.SetActive(node.Level, (skillConfig.level_limit + exLev > 1 and lev + exLev > 0))
    UtilsUI.SetActive(node.LevelBg, (skillConfig.level_limit + exLev > 1 and lev + exLev > 0))
    SingleIconLoader.Load(node.Icon, skillConfig.icon)
    if skillConfig.level_limit + exLev > 1 then
        local curLev = lev + exLev
        local maxLev = skillConfig.level_limit + exLev
        if exLev == 0 then
            node.Level_txt.text = string.format("<color=#ffd189>%s</color>/%s", curLev, maxLev)
        else
            node.Level_txt.text = string.format("<color=#8de0ff>%s</color>/%s", curLev, maxLev)
        end
    end
    UtilsUI.SetActive(node.Arrow, not self.uid and mod.RoleCtrl:CanUpgradeSkill(skillId, lev + 1))

    node.SkillBody_btn.onClick:RemoveAllListeners()
    node.SkillBody_btn.onClick:AddListener(function ()
        self:OpenSkillInfo(type,pos)
    end)
end


function RoleSkillPanel:MoveToCenter()
    --self.Content_rect:DOAnchorPosX(self.CenterPoint_rect.anchoredPosition.x,0.5)
    self._anim:Play("UI_RoleSkillPanel_xuanzhong_in_PC")
    self.part3D._anim:Play("UI_RoleSkill3D_xuanzhong_in_PC")
    self:SetCameraView(self:GetCurRole(), RoleConfig.PageCameraType.SkillInfo, false, true)
end

-- function RoleSkillPanel:CanUpgrade(skillId, level)
--     local roleId = self:GetCurRole()
--     local skillConfig = RoleConfig.GetSkillConfig(skillId)
--     if skillConfig.level_limit < level then
--         return false
--     end
--     local skillLevelConfig = RoleConfig.GetSkillLevelConfig(skillId, level)
--     if not skillLevelConfig then
--         return false
--     end

--     if not skillLevelConfig.need_item or #skillLevelConfig.need_item == 0 then
--         return false
--     else
--         for i = 1, #skillLevelConfig.need_item, 1 do
--             local itemId = skillLevelConfig.need_item[i][1]
--             local needCount = skillLevelConfig.need_item[i][2]
--             local curCount = mod.BagCtrl:GetItemCountById(itemId)
--             if curCount < needCount then
--                 return false
--             end
--         end
--     end

--     local roleData = mod.RoleCtrl:GetRoleData(roleId)
--     local value = RoleConfig.GetRoleSkillLevelLimit(roleId, roleData.stage)
--     if value and level > value then
--         return false
--     end

--     return true
-- end

function RoleSkillPanel:OpenSkillInfo(type,pos)
    self.BGButton:SetActive(true)
    local skillId = self.skillMap[type][pos]
    local curNode = self.skillObjMap[type][pos]
    if self.oldNode then
        UtilsUI.SetActive(self.oldNode.SelectBox, false)
    end
    UtilsUI.SetActive(curNode.SelectBox, true)
    self.oldNode = curNode
    local skillInfoPanel = self.parentWindow:GetPanel(SkillInfoPanel)
    if skillInfoPanel and skillInfoPanel.active then
        skillInfoPanel:ChangeSkill(self:GetCurRole(), skillId)
    else
        self.parentWindow:OpenPanel(SkillInfoPanel, {uid = self.uid, roleId = self:GetCurRole(), skillId = skillId})
        self:MoveToCenter()
    end
end

function RoleSkillPanel:CloseInfoPanel()
    self.parentWindow:ClosePanel(SkillInfoPanel)
    self.BGButton:SetActive(false)
    self._anim:Play("UI_RoleSkillPanel_xuanzhong_out_PC")
    self.part3D._anim:Play("UI_RoleSkill3D_xuanzhong_out_PC")
    --self.Content_rect:DOAnchorPosX(self.DefaultPos_rect.anchoredPosition.x,0.5)
    self:SetCameraView(self:GetCurRole(), RoleConfig.PageCameraType.Skill, false, true)
    if self.oldNode then
        UtilsUI.SetActive(self.oldNode.SelectBox, false)
    end
end

function RoleSkillPanel:GetCurRole()
    return mod.RoleCtrl:GetCurUISelectRole()
end

function RoleSkillPanel:GetCurRealRoleId()
    local roleId = self:GetCurRole()
    return mod.RoleCtrl:GetRealRoleId(roleId)
end

function RoleSkillPanel:GetCurRoleSkillData()
    local roleId = self:GetCurRealRoleId()
    return RoleConfig.GetRoleSkill(roleId)
end

function RoleSkillPanel:GetModelView()
    return Fight.Instance.modelViewMgr:GetView()
end