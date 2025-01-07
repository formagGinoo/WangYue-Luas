NightMareLevelEntryPanel = BaseClass("NightMareLevelEntryPanel", BasePanel)
--梦魇关卡进入界面
local _tinsert = table.insert
local DataReward = Config.DataReward.Find --奖励表
local MaxHeroIconNum = 3 --最大数量的heroIcon

function NightMareLevelEntryPanel:__init()
    self:SetAsset("Prefabs/UI/NightMareDuplicate/NightMareLevelEntryPanel.prefab")
    self.systemDuplicateId = nil --系统副本id
    self.useHeroIdList = {} --角色列表
    self.useBuffList = {} --buff列表
    
    --ui 
    self.heroBuffIconListUI = {}
    self.heroIconListUI = {}
    self.monsterIconListUI = {}
end

function NightMareLevelEntryPanel:__CacheObject()

end

function NightMareLevelEntryPanel:__BindListener()
    self.closeBtn_btn.onClick:AddListener(self:ToFunc("OnClickClose"))
    self.formationCtrlBtn_btn.onClick:AddListener(self:ToFunc("OnClickOpenFormationEditor"))
    self.enterLevelBtn_btn.onClick:AddListener(self:ToFunc("OnClickEnterDupBtn"))
    self.selectBuffBtn_btn.onClick:AddListener(self:ToFunc("OpenNightMareHeroBuffPanel"))
    EventMgr.Instance:AddListener(EventName.NightMareSelectRole, self:ToFunc("UpdateHeroListInfo"))
    EventMgr.Instance:AddListener(EventName.FormationEditorSelect, self:ToFunc("UpdateHeroListByFormation"))
end

function NightMareLevelEntryPanel:__Show()
    self.systemDuplicateId = self.args.systemDuplicateId
    self.nightMareDupCfg = NightMareConfig.GetDataNightmareDuplicate(self.systemDuplicateId)
    self.groupRoleList = mod.NightMareDuplicateCtrl:GetNightMareDupGroupRoleList(self.systemDuplicateId)--副本组角色列表
    self:UpdateUI()
end

function NightMareLevelEntryPanel:__Hide()

end

function NightMareLevelEntryPanel:__delete()
    for i, v in pairs(self.heroIconListUI) do
        self:PushUITmpObject("heroIcon", v)
    end
    self.heroIconListUI = {}

    for i, v in pairs(self.monsterIconListUI) do
        self:PushUITmpObject("monsterIcon", v)
    end
    self.monsterIconListUI = {}
    EventMgr.Instance:RemoveListener(EventName.NightMareSelectRole, self:ToFunc("UpdateHeroListInfo"))
    EventMgr.Instance:RemoveListener(EventName.FormationEditorSelect, self:ToFunc("UpdateHeroListByFormation"))
end

function NightMareLevelEntryPanel:UpdateUI()
    self:UpdateLeft()
    self:UpdateRight()
end

function NightMareLevelEntryPanel:UpdateLeft()
    local dupState = mod.DuplicateCtrl:GetDuplicateStateBySysId(self.systemDuplicateId)
    local config = {
        roleList = mod.RoleCtrl:GetRoleIdList(),
        collectedList = self.groupRoleList,
        selectRoleList = (dupState and dupState.current_score ~= 0) and dupState.use_hero_id_list or {},--哪些被选中了
        selectMode = FormationConfig.SelectMode.Plural,
        name = TI18N("脉者选择"),
        onClickRoleItemCallback = self:ToFunc("OnClickRoleItem")
    }
    self.parentWindow:OpenPanel(RoleSelectPanel, config)
end

function NightMareLevelEntryPanel:UpdateRight()
    --标题
    self:UpdateTop()
    --历史最高分
    self:UpdateBestScore()
    --环境buff
    self:UpdateEnvironmentInfo()
    --人物buff
    self:RefreshHeroBuffInfo()
    --怪物信息
    self:UpdateMonsterListInfo()
    --人物列表
    self:RefreshHeroListInfo()
    --挑战队伍信息
    self:UpdateGroupInfo()
end

function NightMareLevelEntryPanel:UpdateTop()
    self.dupName_txt.text = self.nightMareDupCfg.name
end

function NightMareLevelEntryPanel:UpdateBestScore()
    local dupState = mod.DuplicateCtrl:GetDuplicateStateBySysId(self.systemDuplicateId)
    local score = dupState and dupState.best_score or 0
    self.bestScore_txt.text = string.format("历史最高分: %s", score)
end

function NightMareLevelEntryPanel:UpdateEnvironmentInfo()
	local len = 0
	for k, v in pairs(self.nightMareDupCfg.environment_buff_id) do
		if v ~= 0 then 
			len = len + 1
		end
	end
    self.environmentBuff_recyceList:SetLuaCallBack(self:ToFunc("RefreshEnvironmentBuffItem"))
    self.environmentBuff_recyceList:SetCellNum(len)
end

function NightMareLevelEntryPanel:RefreshEnvironmentBuffItem(index, item)
    local node = UtilsUI.GetContainerObject(item)
    local buffId = self.nightMareDupCfg.environment_buff_id[index]
    local systemBuffCfg = NightMareConfig.GetDataSystemBuff(buffId)
    --名字
    node.buffName_txt.text = systemBuffCfg.name
    --描述
    node.desc_txt.text = systemBuffCfg.desc
end

function NightMareLevelEntryPanel:RefreshHeroBuffInfo()
    --优先判断是否有上次失败
    local lastUseBuffList = mod.NightMareDuplicateCtrl:GetLastDupUseBuffList(self.systemDuplicateId)
    local dupState = mod.DuplicateCtrl:GetDuplicateStateBySysId(self.systemDuplicateId)
    self.useBuffList = {}
    
    if lastUseBuffList then
        for _, v in pairs(lastUseBuffList) do
            self.useBuffList[v.key] = v.value
        end
    elseif dupState and next(dupState.use_buff_list) then --第二优先选择之前已经选择的buff
        for _, v in pairs(dupState.use_buff_list) do
            self.useBuffList[v.key] = v.value
        end
    else
        --最后判断是否有必选的
        self.useBuffList = mod.NightMareDuplicateCtrl:GetBasicUseBuffList(self.systemDuplicateId)
    end
    self:UpdateHeroBuffInfo(self.useBuffList)
end

function NightMareLevelEntryPanel:UpdateHeroBuffInfo(useBuffList)
    ----获取该关卡的挑战词缀
    useBuffList = useBuffList or {}
    for i, v in pairs(self.heroBuffIconListUI) do
        UtilsUI.SetActive(v.object, false)
    end
    
    --fight_base_id: 该关卡的挑战词缀
    --index: 第几个 
    local nowPoint = 0
    for fight_base_id, index in pairs(useBuffList) do
        if index ~= 0 then
            local nightBuffCfg = NightMareConfig.GetDataNightmareBuff(fight_base_id)
            local fight_buff = nightBuffCfg.fight_buff[index]
            local buffId = fight_buff[1]
            local pointId = fight_buff[2]
            if buffId == 0 then --buffId等于0代表找不到该buff
                goto continue
            end
            
            local pointConfig = NightMareConfig.GetDataNightmarePointRule(pointId)
            if pointConfig then
                --当前分数
                nowPoint = nowPoint + pointConfig.point
            end
            
            if not self.heroBuffIconListUI[fight_base_id] then
                self.heroBuffIconListUI[fight_base_id] = self:PopUITmpObject("buffIcon", self.heroBuffContent.transform)
                self:BindBuffIconListener(fight_base_id)
            end
            UtilsUI.SetActive(self.heroBuffIconListUI[fight_base_id].object, true)
            self:UpdateHeroBuffIcon(fight_base_id, buffId, pointConfig)
        end
        ::continue::
    end
    
    local maxPoint = mod.NightMareDuplicateCtrl:GetDupMaxPoint(self.systemDuplicateId)
    --刷新积分(当前配置的buff积分和巅峰配置的buff的积分)
    self.heroBuffScore_txt.text = nowPoint..'/'..maxPoint
end

function NightMareLevelEntryPanel:BindBuffIconListener(fight_base_id)
    local item = self.heroBuffIconListUI[fight_base_id]
    --添加UIDrag事件
    local dragBehaviour = item.object:GetComponent(UIDragBehaviour)
    if not dragBehaviour then
        dragBehaviour = item.object:AddComponent(UIDragBehaviour)
    end
    dragBehaviour.ignorePass = true
    dragBehaviour.onPointerClick = function(data)
        self:OnClickBuff()
    end
end

function NightMareLevelEntryPanel:OnClickBuff()
    PanelManager.Instance:OpenPanel(NightMareBuffTipsPanel, {buffList = self.useBuffList})
end

function NightMareLevelEntryPanel:UpdateHeroBuffIcon(fight_base_id, buffId, pointConfig)
    local item = self.heroBuffIconListUI[fight_base_id]
    local buffConfig = NightMareConfig.GetDataSystemBuff(buffId)
    
    --等级
    item.level_txt.text = "LV."..buffConfig.buff_level
    if pointConfig then
        --分数
        item.score_txt.text = pointConfig.point
    end
    --icon
    if buffConfig.icon ~= "" then
        AtlasIconLoader.Load(item.icon, buffConfig.icon)
    end
    --quality
    if buffConfig.quality ~= "" then
        local path = AssetConfig.GetNightMareQualityIcon(buffConfig.quality)
        AtlasIconLoader.Load(item.quality, path)
    end
end

function NightMareLevelEntryPanel:UpdateMonsterListInfo()
    for i, v in pairs(self.monsterIconListUI) do
        UtilsUI.SetActive(v.object, false)
    end
    local systemDuplicateConfig = DuplicateConfig.GetSystemDuplicateConfigById(self.systemDuplicateId)
    local num = 0
    for i, monsterId in ipairs(systemDuplicateConfig.show_monster_id) do
        if monsterId ~= 0 then
            if not self.monsterIconListUI[monsterId] then
                self.monsterIconListUI[monsterId] = self:PopUITmpObject("monsterIcon", self.monsterContent.transform)
            end
            UtilsUI.SetActive(self.monsterIconListUI[monsterId].object, true)
            self:UpdateMonsterICon(monsterId)
            num = num + 1
        end
    end
    --刷新提示信息
    self.monsterTips_txt.text = string.format("<#E4B265>%s</color>波敌人", num)
end

function NightMareLevelEntryPanel:UpdateMonsterICon(monsterId)
    local item = self.monsterIconListUI[monsterId]
    local monsterCfg = TaskDuplicateConfig.GetMonsterConfig(monsterId)
    if monsterCfg and monsterCfg.icon ~= "" then
        SingleIconLoader.Load(item.icon, monsterCfg.icon)
    end
    if monsterCfg and monsterCfg.level then
        item.level_txt.text = string.format("%s级", monsterCfg.level)
    end
    item.icon_btn.onClick:RemoveAllListeners()
    item.icon_btn.onClick:AddListener(function()
        self:OnClickShowMonsterTips(monsterId)
    end)
end

function NightMareLevelEntryPanel:OnClickShowMonsterTips(monsterId)
    local systemDuplicateConfig = DuplicateConfig.GetSystemDuplicateConfigById(self.systemDuplicateId)
    PanelManager.Instance:OpenPanel(NightMareMonsterTipsPanel, {monsterList = systemDuplicateConfig.show_monster_id, selectId = monsterId})
end

function NightMareLevelEntryPanel:RefreshHeroListInfo()
    self.useHeroIdList = {}
    
    local dupState = mod.DuplicateCtrl:GetDuplicateStateBySysId(self.systemDuplicateId)
    if dupState and dupState.current_score ~= 0 then
        for index, roleId in pairs(dupState.use_hero_id_list) do
            self.useHeroIdList[index] = roleId
        end
    end
    self:UpdateHeroIconList()
end

function NightMareLevelEntryPanel:UpdateHeroListInfo(roleList)
    self.useHeroIdList = {}
    roleList = roleList or {}
    for roleId, index in pairs(roleList) do
        self.useHeroIdList[index] = roleId
    end
    self:UpdateHeroIconList()
end

function NightMareLevelEntryPanel:UpdateHeroListByFormation(roleList)
    self.useHeroIdList = {}
    roleList = roleList or {}
	for index, roleId in pairs(roleList) do
        self.useHeroIdList[index] = roleId
	end
	self:UpdateHeroIconList()
end

function NightMareLevelEntryPanel:UpdateHeroIconList()
    for i = 1, MaxHeroIconNum do
        local roleId = self.useHeroIdList[i]
        
        if not self.heroIconListUI[i] then
            self.heroIconListUI[i] = self:PopUITmpObject("heroIcon", self.heroListContent.transform)
            UtilsUI.SetActive(self.heroIconListUI[i].object, true)
        end
        self:UpdateHeroIcon(i, roleId)
    end
end

function NightMareLevelEntryPanel:UpdateHeroIcon(index, roleId)
    local item = self.heroIconListUI[index]
    if not roleId then 
        item.icon:SetActive(false) 
        return 
    end 
    
    local heroCfg = Config.DataHeroMain.Find[roleId]
    if heroCfg and heroCfg.chead_icon ~= "" then
        SingleIconLoader.Load(item.icon, heroCfg.chead_icon, function()
            item.icon:SetActive(true)
        end)
    end 
end

--刷新角色的buff(选择词缀面板调用过来)
function NightMareLevelEntryPanel:RefreshHeroBuff(useBuffList)
    self.useBuffList = useBuffList
    self:UpdateHeroBuffInfo(useBuffList)
end

function NightMareLevelEntryPanel:UpdateGroupInfo()
    local groupNum = mod.NightMareDuplicateCtrl:GetNightMareDupGroupOrder(self.systemDuplicateId)
    self.heroGroupNum_txt.text = groupNum
end

function NightMareLevelEntryPanel:GetCurRole()
    return mod.RoleCtrl:GetCurUISelectRole()
end

function NightMareLevelEntryPanel:OnClickClose()
    self.parentWindow:ClosePanel(RoleSelectPanel)
    self.parentWindow:ClosePanel(self)
end

--选择词缀界面
function NightMareLevelEntryPanel:OpenNightMareHeroBuffPanel()
    local args = {systemDuplicateId = self.systemDuplicateId}
    self.parentWindow:OpenPanel(NightMareHeroBuffPanel, args)
end

--点击角色item
function NightMareLevelEntryPanel:OnClickRoleItem(roleId, submitCallback)
    --如果存在副本组，则打开界面提示->确定->选择角色
    local sameSysDupId = self.groupRoleList[roleId]
    if sameSysDupId then
        PanelManager.Instance:OpenPanel(NightMareEnterDupTipsPanel, {sameRoleId = roleId, sysDupId = sameSysDupId, submitCallback = submitCallback})
    else
        submitCallback()
    end
end

--进入挑战
function NightMareLevelEntryPanel:OnClickEnterDupBtn()
    if not self.systemDuplicateId then return end
    if not next(self.useHeroIdList) then return end 
    
    local submitCallback = function()
        --数据处理
        local useHeroIds = {}
        for i = 1, 3 do
            local roleId = self.useHeroIdList[i]
            if roleId then
                _tinsert(useHeroIds, roleId)
            else
                _tinsert(useHeroIds, 0)
            end
        end
        
        local buffList = {}
        for fight_base_id, index in pairs(self.useBuffList) do
            if index ~= 0 then
                _tinsert(buffList, {key = fight_base_id, value = index})
            end
        end
        local params = {useHeroIdList = useHeroIds, useBuffList = buffList}
        if Fight.Instance then
            Fight.Instance.duplicateManager:CreateDuplicate(self.systemDuplicateId, params)
        end
    end

    submitCallback()
end

--队伍预设界面
function NightMareLevelEntryPanel:OnClickOpenFormationEditor()
    WindowManager.Instance:OpenWindow(FormationEditorWindow, {closeParent = true})
end


