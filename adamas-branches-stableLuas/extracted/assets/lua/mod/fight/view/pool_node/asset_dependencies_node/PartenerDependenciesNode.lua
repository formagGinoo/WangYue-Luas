---@class PartenerDependenciesNode
PartenerDependenciesNode = BaseClass("PartenerDependenciesNode",DependenciesNodeBase)

function PartenerDependenciesNode:Init()

end

function PartenerDependenciesNode:Analyse(key)
	self.name = "Partener_"..key
	local loaderHelp = FightResuorcesLoadHelp.New()
	local entityId, skills, panelList, passiveList = mod.RoleCtrl:GetRolePartnerEntityId(self.roleId)
	if entityId then
		loaderHelp:PreloadEntity(entityId, false, true)
	end

	self.resList = loaderHelp.resList

	if skills then
		for _, skill in pairs(skills) do
			local levelConfig = RoleConfig.GetPartnerSkillConfig(skill.key)
			if levelConfig then
				local skillNode = PartenerSkillsDependenciesNode.New(self.nodeManager,self.totalAssetPool)
				local name = skill.key
				self:AddChildNote(name,skillNode)
				skillNode:Analyse(skill.key)
			end
		end
	end

	if panelList then
		for _, panel in pairs(panelList) do
			for k, skill in pairs(panel.skill_list) do
				if skill.is_active then
					local skillNode = PartenerSkillsDependenciesNode.New(self.nodeManager,self.totalAssetPool)
					local name = skill.skill_id
					self:AddChildNote(name,skillNode)
					skillNode:Analyse(skill.skill_id)
				end
			end
		end
	end

	if passiveList then
		for _, passiveSkill in pairs(passiveList) do
			local config = RoleConfig.GetPartnerSkillConfig(passiveSkill.value)
			if config then
				local skillNode = PartenerSkillsDependenciesNode.New(self.nodeManager,self.totalAssetPool)
				local name = passiveSkill.value
				self:AddChildNote(name,skillNode)
				skillNode:Analyse(passiveSkill.value)
			end
		end
	end
end

function PartenerDependenciesNode:OnCache()
	self.fight.objectPool:Cache(PartenerDependenciesNode,self)
end

function PartenerDependenciesNode:__delete()

end