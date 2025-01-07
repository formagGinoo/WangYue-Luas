RoleDetailItem = BaseClass("RoleDetailItem", Module)

local DataHeroMain = Config.DataHeroMain.Find
local DataHeroElement = Config.DataHeroElement.Find
local itemPrefab = "Prefabs/UI/Role/RoleDetailItem.prefab"

function RoleDetailItem:__init()
	self.parent = nil
	self.assetLoader = nil
	self.object = nil
	self.node = {}
	self.isLoadObject = false
	self.loadDone = false
end

function RoleDetailItem:InitItem(object, roleId)
	-- 获取对应的组件
	self.object = object
	self:SetItem(roleId)
	self.node = UtilsUI.GetContainerObject(self.object.transform)
	self.loadDone = true

	self.object:SetActive(false)
	self:Show()
end

function RoleDetailItem:SetItem(roleId)
	self.roleId = roleId
	self.roleSetting = DataHeroMain[self.roleId]
	self.curRoleInfo = mod.RoleCtrl:GetRoleData(roleId)
end

function RoleDetailItem:Show()
	if not self.loadDone then return end
	if not self.curRoleInfo then
		self.node.Visible:SetActive(false)
		return
	end
	self.node.Visible:SetActive(true)
	self.node.Level_txt.text = "LV." .. self.curRoleInfo.lev
	SingleIconLoader.Load(self.node.HeadIcon, self.roleSetting.shead_icon)
	SingleIconLoader.Load(self.node.ElementIcon, DataHeroElement[self.roleSetting.element].element_icon_big)
	self:SetQuality(self.node, self.roleSetting.quality)
	self:SetRedPoint()
end

function RoleDetailItem:SetRedPoint()
	UtilsUI.SetActive(self.node.RedPoint,mod.RoleCtrl:CheckRedPointById(self.roleId))
end

function RoleDetailItem:SetBtnEvent(btnFunc)
    local onclickFunc = function()
        if btnFunc then btnFunc() return end
    end
	self.node.Button_btn.onClick:RemoveAllListeners()
	self.node.Button_btn.onClick:AddListener(onclickFunc)
end

function RoleDetailItem:SetSelected_Normal(select)
	self.node.Select:SetActive(select)
	self.node.UnSelect:SetActive(not select)
	if select then
		self.node.Level_txt.color = Color(1, 1, 1, 1)
	else
		self.node.Level_txt.color = Color(0, 0, 0, 1)
	end
	if select then
		mod.RoleCtrl:SetCurUISelectRole(self.roleId)
	end
end

function RoleDetailItem:SetSelected_Formation(select, count)
	self.node.Select:SetActive(false)
	self.node.UnSelect:SetActive(not select)
	self.node.FormationSelect:SetActive(select)
	if count then
		self.node.Count_txt.text = count
	end
end

function RoleDetailItem:SetQuality(itemObj, quality)
	local frontImg, backImg = ItemManager.GetItemColorImg(quality)
	if not frontImg or not backImg then
		return
	end

	--local frontPath = AssetConfig.GetQualityIcon(frontImg)
	local backPath = AssetConfig.GetQualityIcon(backImg)
	--SingleIconLoader.Load(itemObj.QualityFront, frontPath)
	SingleIconLoader.Load(itemObj.QualityBack, backPath)
end