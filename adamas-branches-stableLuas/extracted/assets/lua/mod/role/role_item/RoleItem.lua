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

function RoleItem:InitItem(object, roleId,uid)
	-- 获取对应的组件
	self.object = object
	self.uid = uid
	self:SetItem(roleId)
	self.node = UtilsUI.GetContainerObject(self.object.transform)
	if roleId then
		self.object.transform.parent.name = "role_" .. roleId
	end
	self.loadDone = true

	self:Show()
end

function RoleItem:SetItem(roleId)
	self.roleId = roleId
	local hero_id = mod.RoleCtrl:GetRealRoleId(self.roleId)
	self.isRobot = mod.RoleCtrl:CheckRoleIsRobot(roleId)
	self.itemConfig = DataHeroMain[hero_id]
end

function RoleItem:Show()
	if not self.loadDone then return end

	if self.itemConfig then
		self:SetIcon(self.itemConfig.rhead_icon)
		self:SetRedPoint()
	end
	self.node.robotTips:SetActive(self.isRobot)
	
	local CurFormation = mod.FormationCtrl:GetCurFormationInfo()
	local isInCurFormation = false
	for _, roleId in pairs(CurFormation.roleList) do
		if roleId == self.roleId then
			isInCurFormation= true
			break
		end
	end
	self.node.InFormation:SetActive(not self.uid and isInCurFormation)
	--self:SetBtnEvent(self.itemInfo.btnFunc)
	--self:SetSelected_Normal(self.itemInfo.selectedNormal)
	self.object:SetActive(true)
end

function RoleItem:SetIcon(path)
    self.node.RoleIcon:SetActive(true)
    local callback = function()
        --self.object:SetActive(true)
    end

    SingleIconLoader.Load(self.node.RoleIcon, path, callback)
end

function RoleItem:SetRedPoint()
	UtilsUI.SetActive(self.node.RedPoint,not self.uid and mod.RoleCtrl:CheckRedPointById(self.roleId))
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
	if select then
		mod.RoleCtrl:SetCurUISelectRole(self.roleId)
		self.node.xuanzhong_uianim:PlayEnterAnimator()
		self.node.xuanzhong:SetActive(true)
		self.node.SelectBg:SetActive(true)
		self.node.UnSelectBg:SetActive(false)
	else
		self.node.xuanzhong_uianim:PlayExitAnimator()
		self.node.SelectBg:SetActive(false)
		self.node.UnSelectBg:SetActive(true)
	end
end