TalentItem = BaseClass("TalentItem", PoolBaseClass)

function TalentItem:__init()
	self.parent = nil
	self.talentInfo = nil
	self.object = nil
	self.node = {}
	self.isSelect = false
end

function TalentItem:OnReset()
	TableUtils.ClearTable(self.node)
	self.isSelect = false
	self.talentInfo = nil
	self.object = nil
	self.effectRenderer1 = nil
	self.effectRenderer2 = nil
	self.selecetAnim = nil
end

function TalentItem:InitTalentItem(object, talent_id, isLock)
	-- 获取对应的组件
    self.isLock = isLock or false
	self.object = object
	self.node = UtilsUI.GetContainerObject(self.object.transform)
	self.talent_id = talent_id

	--UtilsUI.SetHideCallBack(self.node.Select_Eixt, self:ToFunc("SelectClose_HideCallBack"))

	self:SetTalent(talent_id)
	self.object:SetActive(true)
	self:UpdateInfo()
end

function TalentItem:SetTalent(talentId)
	self.talentInfo = TalentConfig.GetTalentInfoById(talentId)
    self.talent_lev = mod.TalentCtrl:GetTalentLv(talentId)
    self.talent_max_lev = TalentConfig.GetTalentMaxLvById(talentId)
	self:UpdateInfo()
end

function TalentItem:UpdateInfo()
	self:SetBg()
    self:SetIcon()
    self:SetName()
	self:SetGrade()
    self:SetLock()
	self:SetSelectBox()
	self:SetCanUpgrade()
	self:SetLayer()
end

function TalentItem:SetBg()
    if  self.talent_lev > 0  then
        UtilsUI.SetActive(self.node.NormalBg,true)
		UtilsUI.SetActive(self.node.CanUnlockBg,false)
    end
    if self.talent_lev == 0 and not self.isLock then
		UtilsUI.SetActive(self.node.NormalBg,false)
        UtilsUI.SetActive(self.node.CanUnlockBg,true)
    end
end

function TalentItem:SetName()
	self.node.TalentName_txt.text = self.talentInfo.name
end

function TalentItem:SetIcon()
    SingleIconLoader.Load(self.node.TalentIcon, self.talentInfo.icon)
end

function TalentItem:SetGrade()
    if self.talent_lev == nil or self.talent_lev == 0 then
       UtilsUI.SetActive(self.node.Grade,false)
       return
    end
    UtilsUI.SetActive(self.node.Grade,true)
    local gradeTxt = self.talent_lev .. "/" .. self.talent_max_lev
    self.node.gradeText_txt.text = gradeTxt
end

function TalentItem:SetSelectBox()
	if self.isSelect then
		self:AddListener()
	else 
		self:RemoveListener()
	end
	if self.isSelect == true then
		UtilsUI.SetActive(self.node["22109"],true)
		UtilsUI.SetActive(self.node["22106"],true)
		UtilsUI.SetActive(self.node.SelectBox_Open,true)
		UtilsUI.SetActive(self.node.Select_Open,true)
	else 
		UtilsUI.SetActive(self.node.SelectBox_Eixt,true)
		UtilsUI.SetActive(self.node.Select_Eixt,true)
	end
end

function TalentItem:SetLock()
	UtilsUI.SetActive(self.node.LockedBg,self.isLock)
    UtilsUI.SetActive(self.node.Locked,self.isLock)
end

function TalentItem:SetCanUpgrade()
	if self.isLock or self.talent_lev == self.talent_max_lev then
        UtilsUI.SetActive(self.node.CanUpgrade,false)
		UtilsUI.SetActive(self.node.CanLvUpAnim,false)
		return
    end
	local canLvUp = self:CheckCondition()
    UtilsUI.SetActive(self.node.CanUpgrade,canLvUp)
	UtilsUI.SetActive(self.node.CanLvUpAnim,canLvUp)
end

function TalentItem:CheckCondition()
    local talentConfig = TalentConfig.GetUpgradeConfig(self.talentInfo.talent_id, self.talent_lev + 1)
    if not talentConfig then
        return true
    end
    return TalentConfig.CheckConditionIsDone(talentConfig.condition_id1) 
			and TalentConfig.CheckConditionIsDone(talentConfig.condition_id2) 
			and BagCtrl:GetItemCountById(talentConfig.consume_id) >= talentConfig.consume_count
end

function TalentItem:OnClick()
	
end

function TalentItem:SetBtnEvent(noShowPanel, btnFunc, onClickRefresh)
	local itemBtn = self.node.InfoBtn_btn
	if noShowPanel and not btnFunc then
		itemBtn.enabled = false
	else
		itemBtn.enabled = true
		local onclickFunc = function()
			if self.node.Select_Eixt.activeSelf == true or self.node.Select_Open.activeSelf == true then
				 return
			end
			if btnFunc then
				btnFunc()
				if onClickRefresh then
					self:Show()
				end
				return
			end
			if not noShowPanel then ItemManager.Instance:ShowItemTipsPanel(self.itemInfo) end
		end
		itemBtn.onClick:RemoveAllListeners()
		itemBtn.onClick:AddListener(onclickFunc)
	end
end

function TalentItem:AddListener()
	EventMgr.Instance:AddListener(EventName.UpdateTalentData, self:ToFunc("onTalentDataUpdate"))
end
function TalentItem:RemoveListener()
	EventMgr.Instance:RemoveListener(EventName.UpdateTalentData, self:ToFunc("onTalentDataUpdate"))
end

function TalentItem:onTalentDataUpdate(type, talentId)
	if talentId == self.talent_id then
		self:SetTalent(talentId)
	end
end

function TalentItem:SetLayer()
	if not self.effectRenderer1 then
		self.effectRenderer1 = self.node["22107"].transform:GetComponent(Renderer)
		self.effectRenderer2 = self.node.diban.transform:GetComponent(Renderer)
		--self.selecetAnim = self.node.hua_Rotation.transform:GetComponent(SortingGroup)
		self.selectAnims = self.node["22106"].transform:GetComponentsInChildren(Renderer,true)
	end
	if not self.itemLayer then
		self.itemLayer = WindowManager.Instance:GetCurOrderLayer() + 1
	end
    self.effectRenderer1.sortingOrder = self.itemLayer
	self.effectRenderer2.sortingOrder = self.itemLayer
	for i = 0, self.selectAnims.Length - 1 do
		self.selectAnims[i].sortingOrder = self.itemLayer
	end
end