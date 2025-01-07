RoleSkillPanel = BaseClass("RoleSkillPanel", BasePanel)
local roleIndex = "RoleRoot"

function RoleSkillPanel:__init()
    self:SetAsset("Prefabs/UI/Skill/RoleSkillPanel.prefab")
    self.skillObjMap = {}
    self.skillMap = {}
end

function RoleSkillPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.SkillInfoChange, self:ToFunc("RoleSkillChange"))
	EventMgr.Instance:RemoveListener(EventName.RoleInfoUpdate, self:ToFunc("RoleInfoUpdate"))
    EventMgr.Instance:AddListener(EventName.ChangeShowRole, self:ToFunc("ChangeShowRole"))
end

function RoleSkillPanel:__Create()

end

function RoleSkillPanel:__BindListener()
    EventMgr.Instance:AddListener(EventName.SkillInfoChange, self:ToFunc("RoleSkillChange"))
	EventMgr.Instance:AddListener(EventName.RoleInfoUpdate, self:ToFunc("RoleInfoUpdate"))
    EventMgr.Instance:AddListener(EventName.ChangeShowRole, self:ToFunc("ChangeShowRole"))
    self.Viewport_btn.onClick:AddListener(self:ToFunc("CloseInfoPanel"))
    self.BGButton_btn.onClick:AddListener(self:ToFunc("CloseInfoPanel"))
end

function RoleSkillPanel:__Show()
    self.panelBodyPos = self.PanelBody_rect.position
    self.canvas.sortingOrder = 0
    self:ChangeShowRole()
    
    local blurConfig = RoleConfig.GetRoleBlurConfig(self:GetCurRole(), RoleConfig.PageBlurType.Skill)
    self:GetModelView():SetDepthOfFieldBoken(true, blurConfig.focus_distance, blurConfig.focal_length, blurConfig.aperture)
end

function RoleSkillPanel:__Hide()
    self.parentWindow:ClosePanel(SkillInfoPanel)
    if self.oldNode then
        UtilsUI.SetActive(self.oldNode.SelectBox, false)
    end
    self.PanelBody_rect.position = self.panelBodyPos
end

function RoleSkillPanel:ChangeShowRole(notTransition)
    if not self.active then
        return
    end
	self.Content_rect.anchoredPosition = Vector2.zero
    self:AnalysePrefab()
    self:AnalyseRoleSkill()
    self:ShowSkillNodes()
    self:SetContentSize()
    self:SetCameraView(self:GetCurRole(), RoleConfig.PageCameraType.Skill, notTransition)
end

function RoleSkillPanel:RoleSkillChange(roleId, newSkill)
    if roleId ~= self:GetCurRole() then
        return
    end
    local lev, ex_lev = mod.RoleCtrl:GetSkillInfo(roleId, newSkill.order_id)
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
        self:SetContentSize()
        local oldPos = self.Content_rect.position
        self.PanelBody_rect.position = self.panelBodyPos
        self.Content_rect.position = oldPos
        panel:ChangeSkill()
    end
end

function RoleSkillPanel:SetCameraView(roleId, case, notTransition)
    local cameraConfig = RoleConfig.GetRoleCameraConfig(roleId, case)
    if notTransition then
        self:GetModelView():SetCameraSettings(cameraConfig.camera_position, cameraConfig.camera_rotation, 24.5)
    else
        self:GetModelView():BlendToNewCamera(cameraConfig.camera_position, cameraConfig.camera_rotation, 24.5)
    end
    self:GetModelView():PlayModelAnim(roleIndex, cameraConfig.anim, 0.5)
    self:GetModelView():SetModelRotation(roleIndex,  cameraConfig.model_rotation)
end

--暂时不需要动态加载
function RoleSkillPanel:LoadPrefab()

end

function RoleSkillPanel:AnalysePrefab()
    TableUtils.ClearTable(self.skillObjMap)
    self.skillLayout = self.Content_rect:Find("SkillLayout")
    local typeNodes = UtilsUI.GetContainerObject(self.skillLayout)
    --暂定最大10类型
    for i = 1, 10, 1 do
        --每个类型最大20个技能
        local key1 = tostring(i)
        if not typeNodes[key1] then
            break
        end
        self.skillObjMap[i] = {}
        local skillNodes = UtilsUI.GetContainerObject(typeNodes[key1].transform)
        skillNodes.Title_txt.text = RoleConfig.GetSkillTypeName(i) or ""
        for j = 1, 20, 1 do
            local key2 = tostring(j)
            if not skillNodes[key2] then
                break
            end
            self.skillObjMap[i][j] = UtilsUI.GetContainerObject(skillNodes[key2].transform)
            self.skillObjMap[i][j].object = skillNodes[key2]
        end
    end
end

function RoleSkillPanel:AnalyseRoleSkill()
    TableUtils.ClearTable(self.skillMap)
    local skillInfos = RoleConfig.GetRoleSkill(self:GetCurRole())
    for key, skillId in pairs(skillInfos) do
        local config = RoleConfig.GetSkillUiConfig(skillId)
        if config and next(config) then
            self.skillObjMap[config.skill_type][config.pos].Name_txt.text = config.pos_name
            if not self.skillMap[config.skill_type] then
                self.skillMap[config.skill_type] = {}
            end
            self.skillMap[config.skill_type][config.pos] = skillId
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
    local lev, exLev = mod.RoleCtrl:GetSkillInfo(roleId, skillId)
    local skillConfig = RoleConfig.GetSkillConfig(skillId)
    if skillConfig.condition_id then
        local isPass, desc = Fight.Instance.conditionManager:CheckConditionByConfig(skillConfig.condition_id)
        if not isPass then
            UtilsUI.SetActive(node.object, false)
            return
        end
    end
    --local skillLevelConfig = RoleConfig.GetSkillLevelConfig(skillId, lev + exLev)

    UtilsUI.SetActive(node.BgNull, false)
    UtilsUI.SetActive(node.LockBg, lev + exLev == 0)
    UtilsUI.SetActive(node.Locked, lev + exLev == 0)
    if lev + exLev == 0 then
        node.Icon_img.alpha = 0.3
    else
        node.Icon_img.alpha = 1
    end
    UtilsUI.SetActive(node.Level, (skillConfig.level_limit + exLev > 1 and lev + exLev > 0))
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
    UtilsUI.SetActive(node.Arrow, self:CanUpgrade(skillId, lev + 1))
    node.SkillBody_btn.onClick:RemoveAllListeners()
    node.SkillBody_btn.onClick:AddListener(function ()
        self:OpenSkillInfo(type,pos)
    end)
end

function RoleSkillPanel:SetContentSize()
    local minX, maxX, minY, maxY = -125, 125, -125, 125
    for key, value in pairs(self.skillObjMap) do
        for k, v in pairs(value) do
            if v.object.activeSelf then
                local pos = v.object.transform.position
                pos = self.skillLayout:InverseTransformPoint(pos)
                minX = math.min(minX, pos.x)
                maxX = math.max(maxX, pos.x)
                minY = math.min(minY, pos.y)
                maxY = math.max(maxX, pos.y)
            end
        end
    end
    local x = maxX - minX + 250
    local y = maxY - minY + 300
    UnityUtils.SetSizeDelata(self.Content_rect, x, y)
end

function RoleSkillPanel:MoveToCenter(type,pos)
    local node = self.skillObjMap[type][pos]
    local centerPos = self.CenterPoint_rect.position
    local nodePos = node.object.transform.position
    local contentOffset = self.Content_rect.position - self.Viewport_rect.position
    local offect = centerPos - nodePos + contentOffset

    UnityUtils.SetSizeDelata(self.Content_rect, 0, 0)
    --UnityUtils.SetAnchoredPosition(self.Content_rect, 0, 0)
    local oldPos = self.Content_rect.position
    self.PanelBody_rect.position = self.PanelBody_rect.position + offect
    self.Content_rect.position = oldPos
end

function RoleSkillPanel:CanUpgrade(skillId, level)
    local roleId = self:GetCurRole()
    local skillConfig = RoleConfig.GetSkillConfig(skillId)
    if skillConfig.level_limit < level then
        return false
    end
    local skillLevelConfig = RoleConfig.GetSkillLevelConfig(skillId, level)
    if not skillLevelConfig then
        return false
    end

    if not skillLevelConfig.need_item or #skillLevelConfig.need_item == 0 then
        return false
    else
        for i = 1, #skillLevelConfig.need_item, 1 do
            local itemId = skillLevelConfig.need_item[i][1]
            local needCount = skillLevelConfig.need_item[i][2]
            local curCount = mod.BagCtrl:GetItemCountById(itemId)
            if curCount < needCount then
                return false
            end
        end
    end

    local roleData = mod.RoleCtrl:GetRoleData(roleId)
    local value = RoleConfig.GetRoleSkillLevelLimit(roleId, roleData.stage)
    if value and level > value then
        return false
    end

    return true
end

function RoleSkillPanel:OpenSkillInfo(type,pos)
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
        self.parentWindow:OpenPanel(SkillInfoPanel, {roleId = self:GetCurRole(), skillId = skillId})
    end
    self:MoveToCenter(type, pos)
end

function RoleSkillPanel:CloseInfoPanel()
    self.parentWindow:ClosePanel(SkillInfoPanel)
    self:SetContentSize()
    local oldPos = self.Content_rect.position
    self.PanelBody_rect.position = self.panelBodyPos
    self.Content_rect.position = oldPos
    if self.oldNode then
        UtilsUI.SetActive(self.oldNode.SelectBox, false)
    end
end

function RoleSkillPanel:GetCurRole()
    return mod.RoleCtrl:GetCurUISelectRole()
end

function RoleSkillPanel:GetModelView()
    return Fight.Instance.modelViewMgr:GetView()
end