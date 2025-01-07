CommonItem = BaseClass("CommonItem", Module)

function CommonItem:__init()
	self.parent = nil
	self.assetLoader = nil
	self.object = nil
	self.itemInfo = nil
	self.itemConfig = nil
	self.node = {}
	self.isLoadObject = false
	self.loadDone = false
	self.defaultShow = true
end

function CommonItem:LoadItem(parent, itemInfo, defaultShow)
	self.isLoadObject = true
	self.parent = parent
	self.itemInfo = itemInfo
	if defaultShow ~= nil then self.defaultShow = defaultShow end

	local flag, item = self:GetItemObj()
	self.loadDone = flag

	if flag then self:OnLoadDone(item) end
end

function CommonItem:InitItem(object, itemInfo, defaultShow)
	-- 获取对应的组件
	self.object = object
	if defaultShow ~= nil then self.defaultShow = defaultShow end
	self:SetItem(itemInfo)
	self.node = UtilsUI.GetContainerObject(self.object.transform)
	self.loadDone = true
	self:RemoveItemBtnListeners()
	self.object:SetActive(false)
	self:Show()
end

function CommonItem:__delete()
	if self.assetLoader then
		self.assetLoader:DeleteMe()
		self.assetLoader = nil
	end
end

function CommonItem:Reset()
	self:SetScale(1)

	local longPressEvent = self.object:GetComponent(LongPressEvent)
	if longPressEvent then
		longPressEvent.enabled = false
	end

	if self.isLoadObject and self.object then
		PoolManager.Instance:Push(PoolType.object, self.itemObjectName, self.object)
		self.object = nil
		self.node = {}
	end

	self.parent = nil
	self.itemInfo = nil
	self.itemConfig = nil
	self.loadDone = false
	self.defaultShow = true
end

--[[itemInfo = {
	star,--星级
	scale,--默认采用原有的缩放，eg: scale = 0.8
	lev,--等级
	count,--数量
	onlyCount --仅显示数量
	role_id,--归属哪个角色
	effectShow,--是否显示特效，当前只在关卡胜利界面使用
	quality,--品质
	nameShow,--是否显示物品名
	nameColor,--物品名颜色，默认白色(1, 1, 1, 1)
	numColor, --物品数颜色，默认白色(1, 1, 1, 1)
	noShowDetail,--默认点击事件为弹出物品详情框，true不弹出，不设置或为false则弹出
	btnFunc,--物品点击事件，如果有则屏蔽默认点击事件
	onClickRefresh --任意点击后重绘按钮
	selectedNormal --是否为普通选中
	lack --显示不足

	reduceFunc, --减少按钮事件
	selectBoxGreen, --绿色选择框
	selectedMarkGreen -- 已选标记（绿色）
	selectCount, --已选数量
	acquired --已经获得
}]]

function CommonItem:SetItem(itemInfo)
    self.itemInfo = itemInfo
    if itemInfo and next(itemInfo) then
		if ItemConfig.GetItemType(self.itemInfo.template_id) == BagEnum.BagType.Partner then
			self.itemConfig = RoleConfig.GetPartnerConfig(itemInfo.template_id)
		else
			self.itemConfig = ItemConfig.GetItemConfig(itemInfo.template_id)
		end
    else
        self.itemConfig = nil
    end
end

function CommonItem:Show()
	if not self.loadDone then return end
    local isItemNil = self.itemInfo == nil or next(self.itemInfo) == nil
    self.node.Empty:SetActive(isItemNil)
    self.node.Info:SetActive(not isItemNil)

    if not isItemNil then
        local itemStar = self.itemInfo.isEquip and self.itemInfo.star or self.itemConfig.star

		self:SetScale(self.itemInfo.scale)
        self:SetIcon(self.itemInfo.template_id)
        self:SetQuality(self.itemConfig.quality)
        self:SetNum(self.itemInfo.count, self.itemInfo.lev ~= nil, self.itemInfo.numColor, self.itemInfo.onlyCount)
        self:SetLevel(self.itemInfo.lev)
        self:SetClass(self.itemInfo.refine)
        self:SetLockState(self.itemInfo.is_locked)
        self:SetItemBelong(self.itemInfo.hero_id)
        self:SetIsDisable(false)
		self:SetName(self.itemInfo.nameShow, self.itemInfo.nameColor)
		self:SetBtnEvent(self.itemInfo.noShowDetail, self.itemInfo.btnFunc, self.itemInfo.onClickRefresh)
		self:SetSelected_Normal(self.itemInfo.selectedNormal)

		self:SetReduceBtnEvent(self.itemInfo.reduceFunc, self.itemInfo.onClickRefresh)
		self:SetSelected_Green(self.itemInfo.selectBoxGreen)
		self:SetSelectedMarkGreen(self.itemInfo.selectedMarkGreen)
		self:SetSelectedCount(self.itemInfo.selectCount)
		self:SetLackState(self.itemInfo.lack)

		self:SetTalent(self.itemConfig.talent)
		self:SetSkillType(self.itemConfig.skill_type)
		self:SetAcquired(self.itemInfo.acquired)
		self:SetAddition(self.itemConfig.add_icon)
		self:SetYinyangIcon(self.itemConfig.yinyang_icon)
	else
		if self.defaultShow then
			self.object:SetActive(true)
		end
    end
end

function CommonItem:RemoveItemBtnListeners()
	local itemBtn = self.object.transform:GetComponent(Button)
	itemBtn.onClick:RemoveAllListeners()
end

function CommonItem:SetAddition(addIcon)
	if not self.node.CornerAddition then
		return
	end
	if addIcon == "" or not addIcon then
        if self.node.CornerAddition then
            self.node.CornerAddition:SetActive(false)
        end
        return
	end
	self.node.CornerAddition:SetActive(true)
	SingleIconLoader.Load(self.node.CornerAddition, addIcon)
end

function CommonItem:SetYinyangIcon(yinyangIcon)
	if not self.node.CornerYinyang then
		return
	end
	if yinyangIcon == "" or not yinyangIcon then
        if self.node.CornerYinyang then
            self.node.CornerYinyang:SetActive(false)
        end
        return
	end
	self.node.CornerYinyang:SetActive(true)
	SingleIconLoader.Load(self.node.CornerYinyang, yinyangIcon)
end

function CommonItem:SetScale(scale)
	if scale then
		UnityUtils.SetLocalScale(self.object.transform, scale, scale, scale)
	end
end

function CommonItem:SetIcon(id, default)
    local path = AssetConfig.GetItemIcon(default)
    if id then
		path = ItemConfig.GetItemIcon(id)
    else
        self.node.Icon:SetActive(false)
    end

    self.node.Icon:SetActive(true)

	local callback = function()
		if self.defaultShow then
			self.object:SetActive(true)
		end
	end

    SingleIconLoader.Load(self.node.Icon, path, callback)
end

function CommonItem:SetQuality(quality)
    local frontImg, backImg = ItemManager.GetItemColorImg(quality)
    if not frontImg or not backImg then
        LogError("")
        return
    end

    local frontPath = AssetConfig.GetQualityIcon(frontImg)
    local backPath = AssetConfig.GetQualityIcon(backImg)
    SingleIconLoader.Load(self.node.QualityFront, frontPath)
    SingleIconLoader.Load(self.node.QualityBack, backPath)
end

function CommonItem:SetNum(num, hideNum, numColor, onlyCount)
    self.node.Num:SetActive(num and not hideNum)
    if num and type(num) ~= "table" then
		if not onlyCount then
			self.node.Num_txt.text = "x" ..num
		else
			self.node.Num_txt.text = num
		end
		if num == 0 then
			local backRect = self.node.QualityBack_rect
			backRect.anchoredPosition = Vector2(backRect.anchoredPosition.x, -38.5)
			self.node.Num:SetActive(false)
			self.node.LvlBack:SetActive(false)
		end
    end

	if numColor then
		self.node.Num_txt.color = Color(numColor[1], numColor[2], numColor[3], numColor[4])
	else
		self.node.Num_txt.color = Color.white
	end
end

function CommonItem:SetLevel(lev, hideLvl)
    self.node.Level:SetActive(lev and not hideLvl)
    if lev and type(lev) ~= "table" then
        self.node.Level_txt.text = "Lv."..lev
    end
end

function CommonItem:SetClass(class, hideClass)
    self.node.Class:SetActive(class and not hideClass)
    if class and type(class) ~= "table" then
        self.node.ClassNum_txt.text = class
    end
end

function CommonItem:SetLockState(isLock)
    self.node.Lock:SetActive(isLock)
end

function CommonItem:SetItemBelong(heroId)
	if heroId and heroId ~= 0 then
		self.node.Equiped:SetActive(true)
		local belongIcon = RoleConfig.GetRoleConfig(heroId).rhead_icon
        SingleIconLoader.Load(self.node.Belongs, belongIcon)
	else
		self.node.Equiped:SetActive(false)
	end

end

-- TODO Test
function CommonItem:SetSelected_Normal(select, showEffect)
    self.node.SelectedItemBack:SetActive(select)
    self.node.Selected:SetActive(select)
	if self.node["21038"] then
		UtilsUI.SetEffectSortingOrder(self.node["21038"], 100)
		self.node["21038"]:SetActive(select and showEffect)
	end
end

function CommonItem:SetSelected_Red(select)
	self.node.RedSelected:SetActive(select)
end

function CommonItem:SetSelected_Green(select)
	self.node.GreenSelected:SetActive(select or false)
end

function CommonItem:SetSelectedMarkGreen(select)
	self.node.SelectedMarkGreen:SetActive(select or false)
end

function CommonItem:SetSelectedCount(count)
	if not count or count == 0 then
		self.node.SelectCountGroup:SetActive(false)
		return
	end
	self.node.SelectCountGroup:SetActive(true)
	self.node.SelectCount_txt.text = count
end

function CommonItem:SetLackState(lack)
	self.node.Lack:SetActive(lack or false)
end

function CommonItem:SetIsDisable(state)
    self.node.Disable:SetActive(state)
end

function CommonItem:SetName(nameShow, nameColor)
	local show = nameShow or false
	if not self.node.ItemName then
		return
	end
	self.node.ItemName:SetActive(show)
	if show then
		self.node.ItemName_txt.text = self.itemConfig.name
		if nameColor then
			self.node.ItemName_txt.color = Color(nameColor[1], nameColor[2], nameColor[3], nameColor[4])
		end
	end
end

function CommonItem:SetBtnEvent(noShowPanel, btnFunc, onClickRefresh)
	local itemBtn = self.object.transform:GetComponent(Button)
	if noShowPanel and not btnFunc then
		itemBtn.enabled = false
	else
		itemBtn.enabled = true
		local onclickFunc = function()
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

function CommonItem:SetLongPressEvent(noShowPanel, btnFunc, pressTime, invokeRate)
	local longPressEvent = self.object:GetComponent(LongPressEvent)
	if noShowPanel and not btnFunc then
		if longPressEvent then
			longPressEvent.enabled = false
		end
	else
		if not longPressEvent then
			longPressEvent = self.object:AddComponent(LongPressEvent)
		end
		
		longPressEvent.enabled = true
		local onclickFunc = function()
			if btnFunc then
				btnFunc()
				return
			end
			if not noShowPanel then ItemManager.Instance:ShowItemTipsPanel(self.itemInfo) end
		end
		
		longPressEvent:SetLongPressParam(onclickFunc, pressTime, invokeRate or 0)
	end
end

function CommonItem:SetReduceBtnEvent(reduceFunc, onClickRefresh)
	if not reduceFunc then
		self.node.ReduceButton:SetActive(false)
		return
	end
	self.node.ReduceButton:SetActive(true)
	local itemBtn = self.node.ReduceButton_btn
	if reduceFunc then
		itemBtn.onClick:RemoveAllListeners()
		itemBtn.onClick:AddListener(reduceFunc)
	end
end

function CommonItem:SetTalent(talent)
	if not self.node.Talent then
		return
	end
	if not talent then
        if self.node.Talent then
            self.node.Talent:SetActive(false)
        end
        return
	end
	self.node.Talent:SetActive(true)
	local config = RoleConfig.GetPartnerTalentConfig(talent)
	if config then
		SingleIconLoader.Load(self.node.Talent, config.icon)
	end
end

function CommonItem:SetSkillType(skillType)
	if not self.node.SkillType then
		return
	end
    if not skillType then
        if self.node.SkillType then
            self.node.SkillType:SetActive(false)
        end
        return
    end
	self.node.SkillType:SetActive(true)
	local config = RoleConfig.GetPartnerSkillTypeConfig(skillType)
	if config then
		SingleIconLoader.Load(self.node.SkillTypeBg, config.bg)
		SingleIconLoader.Load(self.node.SkillTypeIcon, config.icon)
	end
end

function CommonItem:SetAcquired(acquired)
	if self.node.Acquired then
		self.node.Acquired:SetActive(acquired or false)
	end
end

function CommonItem:GetItemObj()
	local itemPrefab = "Prefabs/UI/Common/CommonItem.prefab"
	self.itemObjectName = "CommonItemObject"

	if ItemConfig.GetItemType(self.itemInfo.template_id) == BagEnum.BagType.Partner and self.itemInfo.unique_id then
		itemPrefab = "Prefabs/UI/Partner/PartnerItem.prefab"
		self.itemObjectName = "PartnerItemObject"
	end

	local item = PoolManager.Instance:Pop(PoolType.object, self.itemObjectName)
	if not item then
		local callback = function()
			local object = self.assetLoader:Pop(itemPrefab)
			self:OnLoadDone(object)
		end
		
		local resList = {
			{path = itemPrefab, type = AssetType.Prefab}
		}
		self.assetLoader = AssetBatchLoader.New("CommonItemLoader")
		self.assetLoader:AddListener(callback)
		self.assetLoader:LoadAll(resList)
		return false
	end
	return true, item
end

function CommonItem:OnLoadDone(object)
	if self.assetLoader then
		self.assetLoader:DeleteMe()
		self.assetLoader = nil
	end

	UtilsUI.AddUIChild(self.parent, object)

	self:InitItem(object, self.itemInfo, self.defaultShow)
end

function CommonItem:OnReset()

end