---@class AssetNodeManager
AssetsNodeManager = BaseClass("AssetsNodeManager")

local nodeType = {
	Entity = 1,
	Equip = 2,
	Glider = 3,
	Level = 4,
	Other = 5,
	Partener = 6,
	PartenerSkills = 7,
	Player = 8,
	Role = 9,
	Weapon = 10,
	Task = 11,
	AbilityPartner = 12,
}

AssetsNodeManager.AnalyseAssetsCache = {}

--先加载再卸载，可以避免合集部分卸载在加载,这里只会记录根节点
function AssetsNodeManager:__init(fight)
	self.dynamic = false
	self.fight = fight
	self.nodes = {}
	for k, v in pairs(nodeType) do
		self.nodes[v] = {}
	end
	self.nodeTypes = {
		[nodeType.Entity] = EntityDependenciesNode,
		[nodeType.Equip] = EquipDependenciesNode,
		[nodeType.Glider] = GliderDependenciesNode,
		[nodeType.Level] = LevelDependenciesNode,
		[nodeType.Other] = OtherDependenciesNode,
		[nodeType.Partener] = PartenerDependenciesNode,
		[nodeType.PartenerSkills] = PartenerSkillsDependenciesNode,
		[nodeType.Player] = PlayerDependenciesNode,
		[nodeType.Role] = RoleDependenciesNode,
		[nodeType.Weapon] = WeaponDependenciesNode,
		[nodeType.Task] = TaskDependenciesNode,
	}
	self.totalAssetPool = TotalAssetPool.New(self)
	self.removeList = {}
end

function AssetsNodeManager:Init()

end

function AssetsNodeManager:SetAssetPoolRoot(root,fight)
	self.totalAssetPool.assetPoolRoot = root
	self.fight = fight
end

function AssetsNodeManager:LoadLevel(levelId, callback)
	local node = self:Load(nodeType.Level,levelId, callback)
	return node.blackCurtain, node.blackTime or 0
end

function AssetsNodeManager:LoadTask(taskId, callback)
	local node = self:Load(nodeType.Task,taskId, callback)
end

function AssetsNodeManager:LoadEntity(entityId, callback)
	self:Load(nodeType.Entity,entityId, callback)
end

function AssetsNodeManager:LoadPlayer(playerId,callback)
	self:Load(nodeType.Player,playerId, callback)
end

function AssetsNodeManager:LoadRole(playerId,roleId,callback)
	local playerNode = self.nodes[nodeType.Player][playerId]
	if not playerNode then
		LogError("找不到playerNode！playerId = "..playerId)
	end
	local roleNode = RoleDependenciesNode.New(self.nodeManager,self.totalAssetPool)
	if 	playerNode:AddChildNote(roleId,roleNode) then
		roleNode:Analyse(roleId)
		roleNode.callback = callback
		roleNode:StartLoad(AssetLoadType.BothSync)
	elseif callback then
		callback()
	end
end

function AssetsNodeManager:UnLoadRole(playerId,roleId)
	local playerNode = self.nodes[nodeType.Player][playerId]
	if not playerNode then
		LogError("找不到playerNode！playerId = "..playerId)
	end
	playerNode:UnLoadChildNote(roleId)
end

function AssetsNodeManager:LoadWeapon(playerId,roleId,uniqueId,callback)
	local playerNode = self.nodes[nodeType.Player][playerId]
	if not playerNode then
		LogError("找不到playerNode！playerId = "..playerId)
	end
	local roleNode = playerNode.nodes[roleId]
	if not roleNode then
		LogError("找不到roleNode！playerId = "..playerId..",roleId = "..roleId)
	end
	local weaponNote = WeaponDependenciesNode.New(self.nodeManager,self.totalAssetPool)
	local key = "Weapon_"..uniqueId
	if roleNode:AddChildNote(key,weaponNote) then
		local weaponData = mod.BagCtrl:GetWeaponData(uniqueId)
		weaponNote:Analyse(weaponData.template_id)
		weaponNote.callback = callback
		weaponNote:StartLoad(AssetLoadType.BothSync)
	elseif callback then
		callback()
	end
end

function AssetsNodeManager:UnLoadWeapon(playerId,roleId,uniqueId)
	local playerNode = self.nodes[nodeType.Player][playerId]
	if not playerNode then
		LogError("找不到playerNode！playerId = "..playerId)
	end
	local roleNode = playerNode.nodes[roleId]
	if not roleNode then
		LogError("找不到roleNode！playerId = "..playerId..",roleId = "..roleId)
	end
	local key = "Weapon_"..uniqueId
	roleNode:UnLoadChildNote(key)
end

function AssetsNodeManager:LoadPartner(playerId, roleId, partnerId, callback)
	local playerNode = self.nodes[nodeType.Player][playerId]
	if not playerNode then
		LogError("找不到playerNode！playerId = "..playerId)
	end
	local roleNode = playerNode.nodes[roleId]
	if not roleNode then
		LogError("找不到roleNode！playerId = "..playerId..",roleId = "..roleId)
	end
	local partenerNode = PartenerDependenciesNode.New(self.nodeManager,self.totalAssetPool)
	local key = "Partner_"..partnerId
	if roleNode:AddChildNote(key,partenerNode) then
		partenerNode.roleId = roleId
		partenerNode:Analyse(partnerId)
		partenerNode.callback = callback
		partenerNode:StartLoad(AssetLoadType.BothSync)
	elseif callback then
		callback()
	end
end

function AssetsNodeManager:UnLoadPartner(playerId,roleId,partnerId)
	local playerNode = self.nodes[nodeType.Player][playerId]
	if not playerNode then
		LogError("找不到playerNode！playerId = "..playerId)
	end
	local roleNode = playerNode.nodes[roleId]
	if not roleNode then
		LogError("找不到roleNode！playerId = "..playerId..",roleId = "..roleId)
	end
	local key = "Partner_"..partnerId
	roleNode:UnLoadChildNote(key)
end

function AssetsNodeManager:LoadPartnerSkills(playerId, roleId, partnerId, skills, callback)
	local playerNode = self.nodes[nodeType.Player][playerId]
	if not playerNode then
		LogError("找不到playerNode！playerId = "..playerId)
	end
	local roleNode = playerNode.nodes[roleId]
	if not roleNode then
		LogError("找不到roleNode！playerId = "..playerId..",roleId = "..roleId)
	end
	local key = "Partner_"..partnerId
	local partnerNode = roleNode.nodes[key]
	if not partnerNode then
		LogError("找不到partnerNode！playerId = "..playerId..",roleId = "..roleId.."partnerId = "..partnerId)
	end
	local loadCount = 1
	local onLoad = function ()
		loadCount = loadCount - 1
		if loadCount == 0 and callback then
			callback()
		end
	end

	for _, skillId in pairs(skills) do
		local skillConfig = RoleConfig.GetPartnerSkillConfig(skillId)
		if skillConfig and skillConfig.fight_magic and next(skillConfig.fight_magic) then
			local skillNode = PartenerSkillsDependenciesNode.New(self.nodeManager,self.totalAssetPool)
			local name = skillId
			if partnerNode:AddChildNote(name,skillNode) then
				loadCount = loadCount + 1
				skillNode:Analyse(skillId)
				skillNode.callback = onLoad()
				skillNode:StartLoad(AssetLoadType.BothSync)
			end
		end
	end
	onLoad()
end

function AssetsNodeManager:UnLoadPartnerSkills(playerId, roleId, partnerId, skills)
	local playerNode = self.nodes[nodeType.Player][playerId]
	if not playerNode then
		LogError("找不到playerNode！playerId = "..playerId)
	end
	local roleNode = playerNode.nodes[roleId]
	if not roleNode then
		LogError("找不到roleNode！playerId = "..playerId..",roleId = "..roleId)
	end
	local key = "Partner_"..partnerId
	local partnerNode = roleNode.nodes[key]
	if not partnerNode then
		LogError("找不到partnerNode！playerId = "..playerId..",roleId = "..roleId.."partnerId = "..partnerId)
	end

	for _, skillId in pairs(skills) do
		local skillConfig = RoleConfig.GetPartnerSkillConfig(skillId)
		if skillConfig and skillConfig.fight_magic and next(skillConfig.fight_magic) then
			partnerNode:UnLoadChildNote(skillId)
		end
	end
end

function AssetsNodeManager:LoadAbilityPartner(playerId, partnerId, callback)
	local playerNode = self.nodes[nodeType.Player][playerId]
	if not playerNode then
		LogError("找不到playerNode！playerId = "..playerId)
	end
	local key = "AbilityPartner_"..partnerId
	local node = AbilityPartnerDependenciesNode.New(self.nodeManager,self.totalAssetPool)

	if playerNode:AddChildNote(key,node) then
		node:Analyse(partnerId)
		node.callback = callback
		node:StartLoad()
	elseif callback then
		callback()
	end
end

function AssetsNodeManager:UnLoadAbilityPartner(playerId, partnerId)
	local playerNode = self.nodes[nodeType.Player][playerId]
	if not playerNode then
		LogError("找不到playerNode！playerId = "..playerId)
	end
	local key = "AbilityPartner_"..partnerId
	playerNode:UnLoadChildNote(key)
end

function AssetsNodeManager:LoadOther(key,list,callback,cellCallBack)
	self:Load(nodeType.Other,key, callback,list,cellCallBack)
end

function AssetsNodeManager:UnLoadOther(key)
	self:UnLoad(nodeType.Other,key)
end

function AssetsNodeManager:UnLoadLevel(key)
	self:UnLoad(nodeType.Level,key,true)
end

function AssetsNodeManager:UnloadEntity(key)
	self:UnLoad(nodeType.Entity,key)
end

function AssetsNodeManager:Load(type,key,callback,resList, cellCallBack)
	if not key then
		LogError("要加载的key为空，查看错误堆栈")
		callback()
		return
	end
	local nodes = self.nodes[type]
	if nodes[key] then
		if self.dynamic then
			nodes[key].count = nodes[key].count + 1
		end
		if not nodes[key].node.isLoading then
			if callback then
				if not nodes[key].node.isDone or nodes[key].node.isPoping then
					nodes[key].node:AddCallback(callback)
				else
					callback()
				end
			end
			return nodes[key].node
		end
		nodes[key].node:AddCallback(callback)
		return nodes[key].node
	end
	local node = self:CreateNode(type)
	nodes[key] = node
	if self.dynamic then
		node.count = 1
	else
		node.count = 0
	end
	
	node.node = node
	if type == nodeType.Other then--Other不需要分析
		node:SetAssets(resList)
		node.name = "Other_"..key
	else
		node:AnalyseAssets(key)
	end
	node.rootNote = node
	node.callback = callback
	node.cellCallBack = cellCallBack
	node:StartLoad()
	return node
end

--要等所有的都加载完成才能卸载，否则会出现计划可以不加载，加载完成后实际已卸载的情况
function AssetsNodeManager:UnLoad(type,key,ignoreCount)
	if self:IsLoading() then
		table.insert(self.removeList,{type = type,key = key})
		return
	end
	self:DoUnLoad(type,key,ignoreCount)
end

function AssetsNodeManager:IsLoading()
	for _, type in pairs(nodeType) do
		local nodes = self.nodes[type]
		for _, v in pairs(nodes) do
			if v.isLoading then
				--LogError("isLoading "..v.name)
				return true
			end
		end
	end
	return false
end

function AssetsNodeManager:DoUnLoad(type,key,ignoreCount)
	local nodes = self.nodes[type]
	if not nodes[key] then
		LogError("找不到Note!".."type = "..type.." key = "..key)
		return
	end
	nodes[key].count = nodes[key].count - 1
	if ignoreCount or nodes[key].count == 0 then
		local node = nodes[key]
		node:Unload()
		nodes[key] = nil
	end
end

function AssetsNodeManager:CreateNode(type)
	return self.nodeTypes[type].New(self,self.totalAssetPool)
end

function AssetsNodeManager:LoadDone()
	if not next(self.removeList) then
		return
	end
	if not self:IsLoading() then
		for k, v in pairs(self.removeList) do
			self:DoUnLoad(v.type, v.key)
			self.removeList[k] = nil
		end
	end
end


function AssetsNodeManager:__delete()
	self.totalAssetPool:DeleteMe()
end