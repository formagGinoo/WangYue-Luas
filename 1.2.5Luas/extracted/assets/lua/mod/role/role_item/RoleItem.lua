RoleItem = BaseClass("RoleItem", Module)

local DataHeroMain = Config.DataHeroMain.Find
local itemPrefab = "Prefabs/UI/Role/RoleItem.prefab"

function RoleItem:__init()
	self.parent = nil
	self.assetLoader = nil
	self.object = nil
	self.node = {}
	self.isLoadObject = false
	self.loadDone = false
end

function RoleItem:InitItem(object, roleId)
	-- 获取对应的组件
	self.object = object
	self:SetItem(roleId)
	self.node = UtilsUI.GetContainerObject(self.object.transform)
	self.loadDone = true

	self.object:SetActive(false)
	self:Show()
end

function RoleItem:SetItem(roleId)
	self.roleId = roleId
	self.itemConfig = DataHeroMain[roleId]
end

function RoleItem:Show()
	if not self.loadDone then return end

	if self.itemConfig then
		self:SetIcon(self.itemConfig.rhead_icon)
		self:SetRedPoint()
	end

	local CurFormation = mod.FormationCtrl:GetCurFormationInfo()
	local isInCurFormation = false
	for _, roleId in pairs(CurFormation.roleList) do
		if roleId == self.roleId then
			isInCurFormation= true
			break
		end
	end
	self.node.InFormation:SetActive(isInCurFormation)
	--self:SetBtnEvent(self.itemInfo.btnFunc)
	--self:SetSelected_Normal(self.itemInfo.selectedNormal)
end

function RoleItem:SetIcon(path)
    self.node.RoleIcon:SetActive(true)
    local callback = function()
        --self.object:SetActive(true)
    end

    SingleIconLoader.Load(self.node.RoleIcon, path, callback)
end

function RoleItem:SetRedPoint()
	UtilsUI.SetActive(self.node.RedPoint,mod.RoleCtrl:CheckRedPointById(self.roleId))
end

function RoleItem:SetBtnEvent(btnFunc)
    local itemBtn = self.object.transform:GetComponent(Button)
    local onclickFunc = function()
        if btnFunc then btnFunc() return end
    end
    itemBtn.onClick:RemoveAllListeners()
    itemBtn.onClick:AddListener(onclickFunc)
end

function RoleItem:SetSelected_Normal(select)
	self.node.SelectBg:SetActive(select)
	self.node.UnSelectBg:SetActive(not select)
	self.node.Select:SetActive(select)
	self.node.xuanzhong:SetActive(select)
	--self.node.RoleItem_Loop:SetActive(select)
	if select then
		mod.RoleCtrl:SetCurUISelectRole(self.roleId)
	end
end