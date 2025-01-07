NightMareHeroBuffPanel = BaseClass("NightMareHeroBuffPanel", BasePanel)
--梦魇关卡进入界面
local _tinsert = table.insert
local DataReward = Config.DataReward.Find --奖励表
local yellowTextColor = "<#FFA234>"

function NightMareHeroBuffPanel:__init()
    self:SetAsset("Prefabs/UI/NightMareDuplicate/NightMareHeroBuffPanel.prefab")
    self.systemDuplicateId = nil --系统副本id
    self.basicSelectList = {} --必选配置
    self.betterSelectList = {} --推荐配置 
    self.bestSelectList = {} --最高配置
    
    self.useBuffList = {} --最后使用的buff列表
    self.allFightList = {} --所有的词条
    
    --ui 
    self.leftBuffItem = {}--左侧buffitem
    self.leftFightLine = {} --左侧每一个词条
    self.leftBuffIcon = {}
    self.rightUseBuffList = {} --右侧已经选择的buffList
    self.rightBuffDescList = {}--右侧buff的详细描述
    
    --timer
    self.onPointDownTimer = nil --计时
    self.buffTime = 0 --计时
end

function NightMareHeroBuffPanel:__CacheObject()

end

function NightMareHeroBuffPanel:__BindListener()
    self.closeBtn_btn.onClick:AddListener(self:ToFunc("OnClickClosePanel"))
    self.betterBtn_btn.onClick:AddListener(self:ToFunc("OnClickBetterBtn"))
    self.bestBtn_btn.onClick:AddListener(self:ToFunc("OnClickBestBtn"))
    self.submitBtn_btn.onClick:AddListener(self:ToFunc("OnClickSubmitBtn"))
end

function NightMareHeroBuffPanel:__Show()
    self.systemDuplicateId = self.args.systemDuplicateId
    self.nightMareDupCfg = NightMareConfig.GetDataNightmareDuplicate(self.systemDuplicateId)
    --获取词缀组
    self.fightListById = NightMareConfig.GetDataNightmareTagFindById(self.nightMareDupCfg.final_fight_id)
    --初始化数据
    if not self.first then
        self.first = true
        self:InitLeftBuffData()
    end
    self:UpdateUI()
end

function NightMareHeroBuffPanel:__Hide()

end

function NightMareHeroBuffPanel:__delete()
    self:PushLeftBuffItem()
    self:PushLeftFightLine()
    self:PushLeftBuffIcon()
    self:PushUseBuffIcon()
    self:PushBuffDescIcon()
    self:RemoveBuffPointTimer()
end

function NightMareHeroBuffPanel:PushLeftBuffItem()
    for i, v in pairs(self.leftBuffItem) do
        self:PushItem("buffItem", v)
    end
    self.leftBuffItem = {}
end

function NightMareHeroBuffPanel:PushLeftFightLine()
    for i, v in pairs(self.leftFightLine) do
        self:PushItem("fightLine", v)
    end
    self.leftFightLine = {}
end

function NightMareHeroBuffPanel:PushLeftBuffIcon()
    for i, v in pairs(self.leftBuffIcon) do
        self:PushItem("buff", v)
    end
    self.leftBuffIcon = {}
end

function NightMareHeroBuffPanel:PushUseBuffIcon()
    for i, v in pairs(self.rightUseBuffList) do
        self:PushItem("buff", v)
    end
    self.rightUseBuffList = {}
end

function NightMareHeroBuffPanel:PushBuffDescIcon()
    for i, v in pairs(self.rightBuffDescList) do
        self:PushItem("buffDescItem", v)
    end
    self.rightBuffDescList = {}
end

function NightMareHeroBuffPanel:UpdateUI()
    self:UpdateLeft()
    self:UpdateRight()
end

function NightMareHeroBuffPanel:UpdateLeft()
    --词条分为必选和挑战 {[1] = {  }, [2] = }
    self:UpdateLeftScrollView()
end

function NightMareHeroBuffPanel:InitLeftBuffData()
    self.allFightList = {}
    for _, id in pairs(self.fightListById) do
        local fightCfg = NightMareConfig.GetDataNightmareTag(id)
        --是否解锁
        local isPass, desc = Fight.Instance.conditionManager:CheckConditionByConfig(fightCfg.condition)
        if isPass then
            self.bestSelectList[fightCfg.fight_base_id] = self:InitBestSelectList(fightCfg.fight_base_id)
            self.useBuffList[fightCfg.fight_base_id] = 0
        end
        --如果是必选的
        if fightCfg.basic_base_buff ~= 0 and isPass then
            self.basicSelectList[fightCfg.fight_base_id] = fightCfg.basic_base_buff
            self.useBuffList[fightCfg.fight_base_id] = fightCfg.basic_base_buff
        end
        --如果是推荐配置的
        if fightCfg.better_base_buff ~= 0 and isPass then
            self.betterSelectList[fightCfg.fight_base_id] = fightCfg.better_base_buff
        end
        --按照类型分栏
        if not self.allFightList[fightCfg.fight_base_type] then
            self.allFightList[fightCfg.fight_base_type] = {}
        end
        _tinsert(self.allFightList[fightCfg.fight_base_type], fightCfg)
    end

    for i, value in pairs(self.allFightList) do
        table.sort(value, self:ToFunc("SortFightId"))
    end
end

function NightMareHeroBuffPanel:InitBestSelectList(fight_base_id, best_base_buff)
    local bestBaseBuff = 0
    local fightBaseBuffCfg = NightMareConfig.GetDataNightmareBuff(fight_base_id)
    --如果读不到则，选择最后面的
    if fightBaseBuffCfg.fight_buff then
        bestBaseBuff = #fightBaseBuffCfg.fight_buff
    end
    
    return bestBaseBuff
end

function NightMareHeroBuffPanel:SortFightId(a, b)
    return a.fight_base_id < b.fight_base_id
end

function NightMareHeroBuffPanel:UpdateLeftScrollView()
    for base_type, tb in ipairs(self.allFightList) do
        if not self.leftBuffItem[base_type] then
            self.leftBuffItem[base_type] = self:PopItem("buffItem", self.leftContent.transform)
        end
        --更新title
        self:UpdateLeftBuffItem(base_type)
        
        for _, cfg in ipairs(tb) do
            if not self.leftFightLine[cfg.fight_base_id] then
                self.leftFightLine[cfg.fight_base_id] = self:PopItem("fightLine", self.leftBuffItem[base_type].itemLine.transform)
            end
            --更新词条底板
            self:UpdateLeftFightLine(cfg.fight_base_id, cfg)
            
            local buffCfg = NightMareConfig.GetDataNightmareBuff(cfg.fight_base_id)
            for index, value in ipairs(buffCfg.fight_buff) do
                local buffId = value[1]
                local pointId = value[2]
                
                if buffId ~= 0 then
                    if not self.leftBuffIcon[buffId] then
                        self.leftBuffIcon[buffId] = self:PopItem("buff", self.leftFightLine[cfg.fight_base_id].buffContent.transform)
                        self:BindBuffIconListener(cfg.fight_base_id, index, buffId)
                    end
                    --更新buffIcon
                    self:UpdateLeftBuffIcon(cfg, index, value)
                end
            end
        end
    end
end

function NightMareHeroBuffPanel:PopItem(name, parent, scale)
    local obj = self:PopUITmpObject(name, parent)
    UtilsUI.SetActive(obj.object, true)
    UnityUtils.SetLocalScale(obj.object.transform, scale or 1, scale or 1, scale or 1)
    return obj
end

function NightMareHeroBuffPanel:PushItem(name, obj)
    if obj then
        self:PushUITmpObject(name, obj)
    end
end

function NightMareHeroBuffPanel:UpdateLeftBuffItem(base_type)
    local item = self.leftBuffItem[base_type]
    local tagGroup = NightMareConfig.GetDataNightmareCommonConfigByTaggroup()
    --名字
    item.titleText_txt.text = tagGroup.string_tab[base_type]
end

function NightMareHeroBuffPanel:UpdateLeftFightLine(fight_base_id, cfg)
    local item = self.leftFightLine[cfg.fight_base_id]
    local nightMareBuffCfg =  NightMareConfig.GetDataNightmareBuff(fight_base_id)
    --图标 todo 
    --item.leftIconBg
    --图标品质
    --titleQualityBg_
    --底板
    --item.bg
    
    --名字
    item.titleName_txt.text = nightMareBuffCfg.name
    if cfg.condition ~= 0 then
        --locked 
        local isPass, desc = Fight.Instance.conditionManager:CheckConditionByConfig(cfg.condition)
        item.locked:SetActive(not isPass)
        --解锁描述
        local conditionCfg = Config.DataCondition.data_condition[cfg.condition]
        item.lockedDesc_txt.text = conditionCfg.description
    else
        item.locked:SetActive(false)
    end
end

function NightMareHeroBuffPanel:BindBuffIconListener(fight_base_id, index, buffId)
    local item = self.leftBuffIcon[buffId]
    --添加UIDrag事件
    local dragBehaviour = item.object:GetComponent(UIDragBehaviour)
    if not dragBehaviour then
        dragBehaviour = item.object:AddComponent(UIDragBehaviour)
    end
    dragBehaviour.ignorePass = true
    dragBehaviour.onPointerDown = function(data)
        self:OnPointerDown(data, fight_base_id, index)
    end
    dragBehaviour.onPointerUp = function(data)
        --传词缀id和第几个
        self:OnPointerUp(data, fight_base_id, index)
    end
    dragBehaviour.onPointerClick = function(data)
        self:OnClickBuff(fight_base_id, index)
    end
    --dragBehaviour.onBeginDrag = function(data)
    --    --传词缀id和第几个
    --    self:OnBeginDrag(data)
    --end
end

function NightMareHeroBuffPanel:UpdateLeftBuffIcon(cfg, index, value)
    local buffId = value[1]
    local pointId = value[2]
    local item = self.leftBuffIcon[buffId]
    local buffConfig = NightMareConfig.GetDataSystemBuff(buffId)
    local pointConfig = NightMareConfig.GetDataNightmarePointRule(pointId)

    --icon 
    if buffConfig.icon ~= "" then
        AtlasIconLoader.Load(item.icon, buffConfig.icon)
    end
    --quality
    if buffConfig.quality ~= "" then
        local path = AssetConfig.GetNightMareQualityIcon(buffConfig.quality)
        AtlasIconLoader.Load(item.quality, path)
    end
    --等级
    item.level_txt.text = "LV."..buffConfig.buff_level
	if pointConfig then 
    	--分数
    	item.score_txt.text = pointConfig.point
	end
    --是否选中，或者是必选
    local selectIndex = self.useBuffList[cfg.fight_base_id]
    item.select:SetActive(selectIndex == index)
end

function NightMareHeroBuffPanel:UpdateRight()
    for i, v in pairs(self.rightUseBuffList) do
        UnityUtils.SetActive(v.object, false)
    end
    for i, v in pairs(self.rightBuffDescList) do
        UnityUtils.SetActive(v.object, false)
    end
    
    local nowPoint = 0
    for fight_base_id, index in pairs(self.useBuffList) do
        if index ~= 0 then
            --获取buffId 
            local nightMareBuffCfg = NightMareConfig.GetDataNightmareBuff(fight_base_id)
            local values = nightMareBuffCfg.fight_buff[index]
            local buffId = values[1]
            local pointId = values[2]
            if buffId == 0 then --buffId等于0代表找不到该buff
                goto continue
            end
            
            local pointConfig = NightMareConfig.GetDataNightmarePointRule(pointId)
            if pointConfig then
                --当前分数
                nowPoint = nowPoint + pointConfig.point
            end

            self:UpdateRightBuffIcon(fight_base_id, buffId, pointConfig)
            self:UpdateRightBottom(fight_base_id, buffId, pointConfig)
        end
        
        ::continue::
    end
    local maxPoint = mod.NightMareDuplicateCtrl:GetDupMaxPoint(self.systemDuplicateId)
    --积分
    self.rightTopScore_txt.text = nowPoint..'/'..maxPoint
end

function NightMareHeroBuffPanel:UpdateRightBuffIcon(fight_base_id, buffId, pointConfig)
    if not self.rightUseBuffList[fight_base_id] then
        self.rightUseBuffList[fight_base_id] = self:PopItem("buff", self.useBuffContent.transform)
    end
    local item = self.rightUseBuffList[fight_base_id]
    UnityUtils.SetActive(item.object, true)
    
    local buffConfig = NightMareConfig.GetDataSystemBuff(buffId)
    --icon 
    if buffConfig.icon ~= "" then
        AtlasIconLoader.Load(item.icon, buffConfig.icon)
    end
    --quality
    if buffConfig.quality ~= "" then
        local path = AssetConfig.GetNightMareQualityIcon(buffConfig.quality)
        AtlasIconLoader.Load(item.quality, path)
    end
    --等级
    item.level_txt.text = "LV."..buffConfig.buff_level
    if pointConfig then
        --分数
        item.score_txt.text = pointConfig.point
    end
end

function NightMareHeroBuffPanel:UpdateRightBottom(fight_base_id, buffId, pointConfig)
    if not self.rightBuffDescList[fight_base_id] then
        self.rightBuffDescList[fight_base_id] = self:PopItem("buffDescItem", self.buffDescContent.transform)
    end
    local item = self.rightBuffDescList[fight_base_id]
    UnityUtils.SetActive(item.object, true)
    local buffConfig = NightMareConfig.GetDataSystemBuff(buffId)
    
    if buffConfig then
        item.buffName_txt.text = buffConfig.name
        item.buffDesc_txt.text = buffConfig.desc
    end
end

--点击buff(长按弹出buff详情界面)
function NightMareHeroBuffPanel:OnPointerDown(data, fight_base_id, index)
    if not self.onPointDownTimer then
        local delayFunc = function()
            self.buffTime = self.buffTime + 0.2
            
            if self.buffTime > 1 then
                PanelManager.Instance:OpenPanel(NightMareBuffTipsPanel, {buffList = {[fight_base_id] = index}})
                self:RemoveBuffPointTimer()
            end
        end
        self.onPointDownTimer = LuaTimerManager.Instance:AddTimer(0, 0.2, delayFunc)
    end
end

function NightMareHeroBuffPanel:OnBeginDrag(data)
    self:RemoveBuffPointTimer()
end

function NightMareHeroBuffPanel:OnPointerUp(data, fight_base_id, index)
    self:RemoveBuffPointTimer()
end

--点击buff(做选中功能  如果是必选类的buff，则不能取消选中)
function NightMareHeroBuffPanel:OnClickBuff(fight_base_id, index)
    if self.useBuffList[fight_base_id] == index then
        if self.basicSelectList[fight_base_id] then
            return --如果该词缀为必选（不可置空）
        end
        self.useBuffList[fight_base_id] = nil
    else
        self.useBuffList[fight_base_id] = index
    end
    self:UpdateUI()
end

function NightMareHeroBuffPanel:RemoveBuffPointTimer()
    if self.onPointDownTimer then
        LuaTimerManager.Instance:RemoveTimer(self.onPointDownTimer)
        self.onPointDownTimer = nil
    end
    self.buffTime = 0
end

function NightMareHeroBuffPanel:OnClickClosePanel()
    self.parentWindow:ClosePanel(self)
end

--推荐配置
function NightMareHeroBuffPanel:OnClickBetterBtn()
    --获取当前副本组的推荐配置
    for fight_base_id, index in pairs(self.betterSelectList) do
        self.useBuffList[fight_base_id] = index
    end
    self:UpdateUI()
end

--巅峰配置
function NightMareHeroBuffPanel:OnClickBestBtn()
    for fight_base_id, index in pairs(self.bestSelectList) do
        self.useBuffList[fight_base_id] = index
    end
    self:UpdateUI()
end

--确认效果
function NightMareHeroBuffPanel:OnClickSubmitBtn()
    self.parentWindow:RefreshHeroBuff(self.useBuffList)
    self.parentWindow:ClosePanel(self)
end




