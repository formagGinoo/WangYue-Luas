SkillInfoPanel = BaseClass("SkillInfoPanel", BasePanel)

local TmepType = {
    Desc = "DescObj",
    Attr = "AttrObj"
}

function SkillInfoPanel:__init()
    self:SetAsset("Prefabs/UI/Skill/SkillInfoPanel.prefab")
    self.cacheMap = {}
end

function SkillInfoPanel:__delete()
    
end

function SkillInfoPanel:__BindListener()
    self.DescButton_btn.onClick:AddListener(self:ToFunc("ShowSkillDesc"))
    self.AttrButton_btn.onClick:AddListener(self:ToFunc("ShowSkillAttr"))
    self.PowerUpButton_btn.onClick:AddListener(self:ToFunc("OpenSkillUpgradePanel"))
end

function SkillInfoPanel:__Show()
    self.uid = self.args.uid
    if self.uid then
        UtilsUI.SetActiveByScale(self.LockPart,false)
        UtilsUI.SetActiveByScale(self.PowerUp,false)
    end
    self.curType = TmepType.Desc
    self:ChangeSkill(self.args.roleId, self.args.skillId)
end

function SkillInfoPanel:__Hide()
    if self.descList and next(self.descList) then
        for i = #self.descList, 1, -1 do
            self:CacheObject(table.remove(self.descList, i), TmepType.Desc)
        end
    end
    if self.attrList and next(self.attrList) then
        for i = #self.attrList, 1, -1 do
            self:CacheObject(table.remove(self.attrList, i), TmepType.Attr)
        end
    end
end

function SkillInfoPanel:ChangeSkill(roleId, skillId)
    self:SetSkillInfo(roleId, skillId)
    self:ShowDetail()
    if self.curType == TmepType.Desc or not self:AttrExist() then
        self:ShowSkillDesc()
    else
        self:ShowSkillAttr()
    end
end

function SkillInfoPanel:SetSkillInfo(roleId, skillId)
    self.roleId = roleId or self.roleId
    self.isRobot = mod.RoleCtrl:CheckRoleIsRobot(roleId)
    self.skillId = skillId or self.skillId
end

function SkillInfoPanel:ShowDetail()
    local skillId = self.skillId
    local roleId = self.roleId
    local lev, exLev = mod.RoleCtrl:GetSkillInfo(roleId, skillId,self.uid)
    local skillConfig = RoleConfig.GetSkillConfig(skillId)

    SingleIconLoader.Load(self.SkillIcon, skillConfig.icon)
    self.SkillName_txt.text = skillConfig.name
    self.CurLevel_txt.text = lev + exLev
    self.MaxLevel_txt.text =  "/"..(skillConfig.level_limit + exLev)
    self.PosName_txt.text = RoleConfig.GetSkillUiConfig(skillId).pos_name

    if not skillConfig.video then
        UtilsUI.SetActive(self.Video, false)
        local sizeDelta = self.DescView_rect.sizeDelta
        sizeDelta.y = 240 + self.Video_rect.sizeDelta.y
        self.DescView_rect.sizeDelta = sizeDelta
        self.AttrView_rect.sizeDelta = sizeDelta
    else
        UtilsUI.SetActive(self.Video, true)
        local sizeDelta = self.DescView_rect.sizeDelta
        sizeDelta.y = 240
        self.DescView_rect.sizeDelta = sizeDelta
        self.AttrView_rect.sizeDelta = sizeDelta
        for i = self.Video_rect.childCount, 1, -1 do
            GameObject.DestroyImmediate(self.Video_rect:GetChild(i - 1).gameObject)
        end
        self:CreateVideo(skillConfig.video)
    end
    
    local attrExist = self:AttrExist()
    UtilsUI.SetActive(self.AttrButton, attrExist)
    --如果是机器人
    if self.isRobot then
        UtilsUI.SetActive(self.PowerUp, false)
        UtilsUI.SetActive(self.LockPart, false)
        return
    end

    --达到最大等级不显示
    UtilsUI.SetActive(self.PowerUp, skillConfig.level_limit ~= lev)

    local roleData = mod.RoleCtrl:GetRoleData(roleId,self.uid)
    local levelLimit = RoleConfig.GetRoleSkillLevelLimit(roleId, roleData.stage)

    local unlockType = skillConfig.unlock_type
    if lev + exLev == 0 then
        if unlockType == 2 or unlockType == 3 then
            UtilsUI.SetActive(self.LockPart, true)
            UtilsUI.SetActive(self.PowerUpButton, false)
            if unlockType == 2 then
                local stage = RoleConfig.GetSkillUnlockStage(skillId)
                self.LockText_txt.text = string.format(TI18N("角色突破%s解锁"), stage)
            end
            if unlockType == 3 then
                self.LockText_txt.text = TI18N("角色脉象开放后解锁")
            end
        else
            UtilsUI.SetActive(self.LockPart, false)
            UtilsUI.SetActive(self.PowerUpButton, true)
            if unlockType == 4 then
                self.PowerUpText_txt.text = TI18N("解锁")
            else
                self.PowerUpText_txt.text = TI18N("升级")
            end
        end
    elseif lev == levelLimit then
        UtilsUI.SetActive(self.LockPart, lev ~= skillConfig.level_limit)
        UtilsUI.SetActive(self.PowerUpButton, false)
        self.LockText_txt.text = string.format(TI18N("角色突破等级%s可继续升级"), roleData.stage + 1)
    else
        UtilsUI.SetActive(self.LockPart, false)
        UtilsUI.SetActive(self.PowerUpButton, true)
        self.PowerUpText_txt.text = TI18N("升级")
    end
end

function SkillInfoPanel:CanUpgrade()
    local roleId = self.roleId
    local skillId = self.skillId
    local lev, exLev = mod.RoleCtrl:GetSkillInfo(self.roleId, skillId,self.uid)
    local skillConfig = RoleConfig.GetSkillConfig(skillId)

    --达到极限等级
    if lev == skillConfig.level_limit then
        return false
    end

    --达到突破等级限制
    local roleData = mod.RoleCtrl:GetRoleData(roleId,self.uid)
    local value = RoleConfig.GetRoleSkillLevelLimit(roleId, roleData.stage)
    if value and lev >= value then
        return false
    end
    return true
end

function SkillInfoPanel:CanUnlock()
    local roleId = self.roleId
    local skillId = self.skillId
    local lev, exLev = mod.RoleCtrl:GetSkillInfo(self.roleId, skillId)
    local baseLevCfg = RoleConfig.GetSkillLevelConfig(skillId, lev + 1)
    if lev == 0 and baseLevCfg then
        if not baseLevCfg.need_item or #baseLevCfg.need_item == 0 then
            return false
        end
    end
    return true
end

local ScreenFactor = math.max(Screen.width / 1920, Screen.height / 1080)
function SkillInfoPanel:CreateVideo(videoPath)
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
        if self.videoLoader then
            AssetMgrProxy.Instance:CacheLoader(self.videoLoader)
            self.videoLoader = nil
        end
    end

    if self.videoLoader then
        AssetMgrProxy.Instance:CacheLoader(self.videoLoader)
        self.videoLoader = nil
    end

    self.videoLoader = AssetMgrProxy.Instance:GetLoader("CreateVideo")
    self.videoLoader:AddListener(callback)
    self.videoLoader:LoadAll(resList)

end

function SkillInfoPanel:ShowSkillDesc()
    self.curType = TmepType.Desc
    local skillId = self.skillId
    local lev, exLev = mod.RoleCtrl:GetSkillInfo(self.roleId, skillId,self.uid)
    local level = lev + exLev
    if level == 0 then
        level = 1
    end
    local skillLevConfig = RoleConfig.GetSkillLevelConfig(skillId, level)
    UtilsUI.SetActive(self.DescSelect, true)
    UtilsUI.SetActive(self.AttrSelect, false)
    UtilsUI.SetActive(self.DescView, true)
    UtilsUI.SetActive(self.AttrView, false)
    UtilsUI.SetTextColor(self.DescButtonText_txt,"#191818")
    UtilsUI.SetTextColor(self.AttrButtonText_txt,"#E6E6E6")

    if not self.descList then
        self.descList = {}
    end
    if self.descList and next(self.descList) then
        for i = #self.descList, 1, -1 do
            self:CacheObject(table.remove(self.descList, i), TmepType.Desc)
        end
    end
    for i = 1, #skillLevConfig.desc_info, 1 do
        local config = skillLevConfig.desc_info[i]
        local obj = self:GetTempObj(TmepType.Desc)
        obj.objectTransform:SetParent(self.DescContent_rect)
        obj.objectTransform:ResetAttr()
        --TODO改表导致结构变化
        if #config == 1 then
            obj.Title_txt.text = ""
            obj.Content_txt.text = config[1]
        else
            obj.Title_txt.text = config[1]
            obj.Content_txt.text = config[2]
        end

        table.insert(self.descList, obj)
    end
end

function SkillInfoPanel:ShowSkillAttr()
    self.curType = TmepType.Attr
    local skillId = self.skillId
    local lev, exLev = mod.RoleCtrl:GetSkillInfo(self.roleId, skillId,self.uid)
    local level = lev + exLev
    if level == 0 then
        level = 1
    end
    local skillLevConfig = RoleConfig.GetSkillLevelConfig(skillId, level)
    UtilsUI.SetActive(self.DescSelect, false)
    UtilsUI.SetActive(self.AttrSelect, true)
    UtilsUI.SetActive(self.DescView, false)
    UtilsUI.SetActive(self.AttrView, true)
    UtilsUI.SetTextColor(self.DescButtonText_txt,"#E6E6E6")
    UtilsUI.SetTextColor(self.AttrButtonText_txt,"#191818")

    if not self.attrList then
        self.attrList = {}
    end
    if self.attrList and next(self.attrList) then
        for i = #self.attrList, 1, -1 do
            self:CacheObject(table.remove(self.attrList, i), TmepType.Attr)
        end
    end

    for i = 1, #skillLevConfig.desc_attr, 1 do
        local config = skillLevConfig.desc_attr[i]
        local obj = self:GetTempObj(TmepType.Attr)
        obj.objectTransform:SetParent(self.AttrContent_rect)
        UtilsUI.SetActive(obj.BG, not (i % 2 == 0))
        obj.objectTransform:ResetAttr()
        obj.Key_txt.text = config[1]
        obj.Value_txt.text = config[2]
        table.insert(self.attrList, obj)
    end
end

function SkillInfoPanel:AttrExist()
    local skillId = self.skillId
    local lev, exLev = mod.RoleCtrl:GetSkillInfo(self.roleId, skillId,self.uid)
    local level = lev + exLev
    if level == 0 then
        level = 1
    end

    local skillLevConfig = RoleConfig.GetSkillLevelConfig(skillId, level)
    if not skillLevConfig.desc_attr then
        return false
    end

    return true
end

function SkillInfoPanel:GetTempObj(type)
    if self.cacheMap[type] and next(self.cacheMap[type]) then
        return table.remove(self.cacheMap[type])
    end
    local obj = self:PopUITmpObject(type)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    return obj
end

function SkillInfoPanel:CacheObject(obj, type)
    obj.objectTransform:SetParent(self.CacheRoot_rect)
    if not self.cacheMap[type] then
        self.cacheMap[type] = {}
    end
    table.insert(self.cacheMap[type], obj)
end

function SkillInfoPanel:OpenSkillUpgradePanel()
    PanelManager.Instance:OpenPanel(SkillUpgradePanel,{skillId = self.skillId, roleId = self.roleId})
end