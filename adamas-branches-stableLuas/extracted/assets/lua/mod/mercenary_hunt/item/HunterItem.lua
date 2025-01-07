HunterItem = BaseClass("HunterItem", Module)

function HunterItem:__init()

end

function HunterItem:__delete()

end

function HunterItem:InitHunter(object, hunterInfo, defaultShow)
	-- 获取对应的组件
	self.object = object
	self.node = UtilsUI.GetContainerObject(self.object.transform)
	if defaultShow ~= nil then self.defaultShow = defaultShow end
	self.loadDone = true
	self.hunterInfo = hunterInfo
	self.object:SetActive(false)
    self:AddClickListener()
	self:Show()
end

function HunterItem:Show()
	if not self.loadDone then 
        return 
    end

    self.ecoId = self.hunterInfo.ecosystem_id
    self.ecoInfo = MercenaryHuntConfig:GetMercenaryEcoConfig(self.ecoId)
    self.hunterNameList = self.hunterInfo.name_list
    self.hunterLevel = self.hunterInfo.level
    self.mainId = mod.MercenaryHuntCtrl:GetMainId()
    self.mainConfig = MercenaryHuntConfig.GetMercenaryHuntMainConfig(self.mainId)
    self.rewardTime = mod.MercenaryHuntCtrl:GetRewardTime()
    self.isDiscover = self.hunterInfo.discover_state
    self.isChase = self.hunterInfo.chase_state
    self:SetHunterInfo()
    self:SetMark()
    SingleIconLoader.Load(self.node.IconButton, self.ecoInfo.head_icon)
	
    if self.defaultShow then
		self.object:SetActive(true)
	end
end

function HunterItem:AddClickListener()
    self.node.IconButton_btn.onClick:AddListener(self:ToFunc("OnClick_HunterInfo"))
    self.node.MapTraceBtn_btn.onClick:AddListener(self:ToFunc("OnClick_HunterMapInfo"))
end

function HunterItem:SetMark()
    if(self.mainConfig.reward_count > self.rewardTime) then
        self.node.Mark:SetActive(true)
    else
        self.node.Mark:SetActive(false)
    end
end

function HunterItem:SetHunterInfo()
    if self.isDiscover == 0 then
        self.node.IconMask:SetActive(true)
        self.node.NameLevelText_txt.text = "???"
        self.node.DescText_txt.text = self.ecoInfo.tip_desc
        self.node.HunterDesc:SetActive(true)
        self.node.MapTraceBtn:SetActive(false)

    elseif self.isDiscover == 1 then
        -- self.node.IconMask:SetActive(false)
        local name = MercenaryHuntConfig.GetHunterFullName(self.ecoInfo.name_prefix_id, self.ecoInfo.name_id, self.hunterNameList[1], self.hunterNameList[2])
        local space = "  "
        local level = "Lv." .. self.hunterLevel
        self.node.DescText_txt.text = ""
        self.node.NameLevelText_txt.text = name .. space .. level
    end

    if self.isChase == 0 and self.isDiscover == 1 then
        --TODO 显示怪物出生点
        -- BehaviorFunctions.GetTerrainPositionP()
        
        -- self.node.HunterPosition:SetActive(true)
        self.node.HunterTracing:SetActive(false)
    elseif self.isChase == 1 then
        self.node.DescText_txt.text = ""
        self.node.HunterTracing:SetActive(true)
    elseif self.isChase == 0 then
        self.node.HunterTracing:SetActive(false)
    end
end

function HunterItem:GetHunterFullName(preNameId, nameId, preNameIndex, nameIndex)
    self.preName = MercenaryHuntConfig.GetMercenaryName(preNameId, preNameIndex)
    self.name = MercenaryHuntConfig.GetMercenaryName(nameId, nameIndex)
    return self.preName .. self.name
end

function HunterItem:OnClick_HunterInfo()
    PanelManager.Instance:OpenPanel(MercenaryTipsPanel, {openType = 0, hunterInfo = self.hunterInfo})
end

function HunterItem:OnClick_HunterMapInfo()
    local markInstance = mod.MercenaryHuntCtrl:GetMercenaryMapMark(self.ecoId)
    WindowManager.Instance:OpenWindow(WorldMapWindow, { mark = markInstance })
end

function HunterItem:OnReset()

end