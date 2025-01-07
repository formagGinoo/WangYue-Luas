LocalEntityManager = BaseClass("LocalEntityManager")
local _floor = math.floor

local DataDrop = Config.DataDropBase.Find
local HitTime = 10

function LocalEntityManager:__init(fight, entityManager)
    self.fight = fight
    self.entityManager = entityManager
	self.entitiesMap = {}
end

function LocalEntityManager:StartFight()
	self:OnLoadingMap()
	self:CreateLocalEntityByConfig()
end


function LocalEntityManager:OnLoadingMap()
	self.mapId = self.fight.fightData.MapConfig.id
	self.entitiesConfig = Config["LocalEntitesScene" .. self.mapId]
end

function LocalEntityManager:Update()
	UnityUtils.BeginSample("Fight:LocalEntityManagerUpdate")
	self.loadedCtrlIndex = self.loadedCtrlIndex or 1
	local endIndex = (self.loadedCtrlIndex or 1) + 50
	for i = self.loadedCtrlIndex, math.min(endIndex, #self.entitiesMap) do
		local ctrl = self.entitiesMap[i]
		ctrl:Update()
	end
	
	self.loadedCtrlIndex = endIndex + 1
	
	if self.loadedCtrlIndex > #self.entitiesMap then
		self.loadedCtrlIndex = 1
	end
	UnityUtils.EndSample()
end

function LocalEntityManager:CreateLocalEntityByConfig()
	if not self.entitiesConfig or not next(self.entitiesConfig) then
		return
	end
	for _, config in ipairs(self.entitiesConfig) do
		local ctrl = self.fight.objectPool:Get(LocalEntityCtrl)
		ctrl:Init(self.fight, config, self.entityManager) 
		if ctrl.loadRadius == -1 then
			ctrl:Load()
		end
		table.insert(self.entitiesMap, ctrl)
	end
end

function LocalEntityManager:__delete()
	self.entitiesMap = {} 
end