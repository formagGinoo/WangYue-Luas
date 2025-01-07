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

function RoleDetailItem:InitItem(object, roleId, collectedList)
	-- 获取对应的组件
	self.object = object
	self:SetItem(roleId)
	self.node = UtilsUI.GetContainerObject(self.object.transform)
	if roleId then
		self.object.transform.parent.name = "role_" .. roleId
	end
	self.loadDone = true
	self.collectedList = collectedList or {}

	self:Show()
end

function RoleDetailItem:SetItem(roleId)
	self.roleId = roleId
	local hero_id = RoleCtrl:GetRealRoleId(self.roleId)
	self.roleSetting = DataHeroMain[hero_id]
	self.curRoleInfo = mod.RoleCtrl:GetRoleData(roleId)
end

function RoleDetailItem:Show()
	if not self.loadDone then return end
	if not self.curRoleInfo then
		self.node.Visible:SetActive(false)
		return
	end
	if self.curRoleInfo.isRobot then
		self.node.robotTips:SetActive(true)
	else
		self.node.robotTips:SetActive(false)
	end
	self.node.Visible:SetActive(true)
	self.node.Level_txt.text = self.curRoleInfo.lev
	SingleIconLoader.Load(self.node.HeadIcon, RoleConfig.GetRoleConfig(self.curRoleInfo.id).rhead_icon)
	SingleIconLoader.Load(self.node.ElementIcon, DataHeroElement[self.roleSetting.element].element_icon_big)
	self:SetQuality(self.node, self.roleSetting.quality)
	self:SetCollected()
	self:SetRedPoint()
	self.object:SetActive(true)
end

function RoleDetailItem:SetRedPoint(show)
	if show == nil then
		UtilsUI.SetActive(self.node.RedPoint,mod.RoleCtrl:CheckRedPointById(self.roleId))
	else
		UtilsUI.SetActive(self.node.RedPoint,show)
	end
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
    local frontImg, backImg, itemFrontImg, itemFrontImg2, backImg2 = ItemManager.GetItemColorImg(quality)
    if not frontImg or not backImg or not itemFrontImg or not itemFrontImg2 then
        return
    end
	local frontPath = AssetConfig.GetQualityIcon(itemFrontImg)
    local frontPath2 = AssetConfig.GetQualityIcon(itemFrontImg2)
    local backPath = AssetConfig.GetQualityIcon(backImg)
    local back2Path = AssetConfig.GetQualityIcon(backImg2)
	SingleIconLoader.Load(itemObj.QualityFront, frontPath)
    SingleIconLoader.Load(itemObj.QualityFront2, frontPath2)
    SingleIconLoader.Load(itemObj.QualityBack, backPath)
	SingleIconLoader.Load(itemObj.QualityBack2, back2Path)

end

function RoleDetailItem:SetCollected()
	local isCollect = self.collectedList[self.roleId]
	self.node.Collected:SetActive(isCollect or false)
end