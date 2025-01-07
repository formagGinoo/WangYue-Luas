RolePoolMgr = BaseClass("RolePoolMgr")

function RolePoolMgr:__init(poolMgr)
	self.poolMgr = poolMgr
	self.roleAssetGroup = {}
end

--角色资源管理
function RolePoolMgr:LoadRole(playerId, roleId, roleData, callBack, notCount)
	if not self.roleAssetGroup[playerId] then
		self.roleAssetGroup[playerId] = {}
	end
	local playerData = self.roleAssetGroup[playerId]
	local loadInfo = playerData[roleId]

	if not loadInfo then
		loadInfo = 	{
			roleEntity = RoleConfig.GetRoleEntityId(roleId) or roleId,
			weaponId = roleData.weaponId,
			partnerMgr = PartnerPoolMgr.New(self.poolMgr)
		}
		playerData[roleId] = loadInfo
	end

	local loadCount = 3

	local onLoad = function ()
		loadCount = loadCount - 1
		if loadCount == 0 and callBack then
			callBack()
		end
	end

	if roleData.partnerInfo then
		loadCount = loadCount + 1
		loadInfo.partnerMgr:LoadPartner(roleData.partnerInfo, onLoad, notCount)
	end

	self.poolMgr:LoadEntityPool(loadInfo.roleEntity, onLoad, false, notCount)
	self.poolMgr:LoadWeaponPool(loadInfo.weaponId, onLoad, notCount)
	onLoad()
end

function RolePoolMgr:ReloadWeapon(playerId, roleId, weaponId, callBack)
	if not self.roleAssetGroup[playerId][roleId] then
		return
	end

	local playerData = self.roleAssetGroup[playerId]

	playerData[roleId].isLoading = true

	local onLoad = function ()
		if callBack then
			callBack()
		end
		self.poolMgr:UnLoadWeaponPool(playerData[roleId].weaponId)
		playerData[roleId].isLoading = false
		playerData[roleId].weaponId = weaponId
	end

	self.poolMgr:LoadWeaponPool(weaponId, onLoad)
end

function RolePoolMgr:ReLoadPartner(playerId, roleId, partnerInfo, callBack)
	if not self.roleAssetGroup[playerId][roleId] then
		return
	end

	local playerData = self.roleAssetGroup[playerId]

	playerData[roleId].isLoading = true

	if not partnerInfo then
		if callBack then
			callBack()
		end
		playerData[roleId].partnerMgr:UnLoadPartner()
	elseif partnerInfo.partnerId then
		playerData[roleId].partnerMgr:LoadPartner(partnerInfo, callBack)
	elseif partnerInfo.skills then
		playerData[roleId].partnerMgr:ReLoadSkills(partnerInfo.skills, callBack)
	end
end

function RolePoolMgr:UnLoadRole(playerId, roleId)
	local loadInfo = self.roleAssetGroup[playerId][roleId]
	if not loadInfo then
		return
	end
	self.poolMgr:UnLoadEntityPool(loadInfo.roleEntity)
	self.poolMgr:UnLoadWeaponPool(loadInfo.weaponId)
	loadInfo.partnerMgr:UnLoadPartner()
	self.roleAssetGroup[playerId][roleId] = nil
end

function RolePoolMgr:UnLoadAllRole()
	for playerId, roles in pairs(self.roleAssetGroup) do
		for roleId, value in pairs(roles) do
			self:UnLoadRole(playerId, roleId)
		end
	end
	TableUtils.ClearTable(self.roleAssetGroup)
end