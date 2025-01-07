EcosystemCtrlManager = BaseClass("EcosystemCtrlManager")
--生态实体刷新控制器   管理器
--用于管理    生态实体刷新控制器
function EcosystemCtrlManager:__init()
	self.ecosystemCtrls = {}
	self.removeCtrls = {}
	self.addCtrls = {}
	self.removeOffset = 5--卸载距离缓冲，避免玩家在边缘反复横跳
	self.ctrlEntity = 2
	self.instanceCtrlQueue = {}
	self.pauseCount = 0

	self.createEntityFunc = {
		[FightEnum.CreateEntityType.Ecosystem] = function(config) return self.entityManager.ecosystemEntityManager:CreateSysEntity(config, FightEnum.CreateEntityType.Ecosystem) end,
		[FightEnum.CreateEntityType.Npc] = function(config) return self.entityManager.npcEntityManager:CreateNpc(config) end,
		[FightEnum.CreateEntityType.Drop] = function(config) return self.entityManager.ecosystemEntityManager:CreateDropEntity(config) end,
		[FightEnum.CreateEntityType.Mercenary] = function (config)
			return self.entityManager.ecosystemEntityManager:CreateSysEntity(config)
		end,
	}
	self.lastX = 0
	self.lastY = 0
	self.lastZ = 0
	self.failTime = 0
end

function EcosystemCtrlManager:Init(fight,entityManager)
	self.fight = fight
	self.entityManager = entityManager
	self.assetsNodeManager = self.fight.clientFight.assetsNodeManager
end

--表格分块加载
function EcosystemCtrlManager:AddEcosystemEntity(ecosystemConfig, type, waitCreate)
	local ctrl = self.fight.objectPool:Get(EcosystemCtrl)
	ctrl:Init(self, ecosystemConfig, type, waitCreate)

	self.addCtrls[ecosystemConfig.id] = ctrl
end

--表格分块卸载(表格先卸载再加载，缓存利用率更高)
function EcosystemCtrlManager:RemoveEcosystemEntity(ecosystemConfig)
	self:RemoveEcosystemEntityByID(ecosystemConfig.id)
end

function EcosystemCtrlManager:RemoveEcosystemEntityByID(ecoId)
	if not self.ecosystemCtrls[ecoId] then
		return
	end

	table.insert(self.removeCtrls, ecoId)
end

function EcosystemCtrlManager:Update()
	if self.pauseCount > 0 then
		return
	end
	self.ctrlEntity = BehaviorFunctions.GetCtrlEntity()
	--if not self:NeckCheck() then
		----Log("近距离不检测")
		--return
	--end
	--Log("距离检测")
	--CustomUnityUtils.BeginSample("EcosystemCtrlManager:Update")
	
	for k, v in pairs(self.addCtrls) do
		self.ecosystemCtrls[k] = v
	end
	for k, v in pairs(self.removeCtrls) do
		local ctrl = self.ecosystemCtrls[v]
		self.fight.objectPool:Cache(EcosystemCtrl,ctrl)
		self.ecosystemCtrls[v] = nil
	end
	for k, ctrl in pairs(self.ecosystemCtrls) do
		ctrl:Update()
	end
	TableUtils.ClearTable(self.addCtrls)
	TableUtils.ClearTable(self.removeCtrls)
	local instanceCtrl = table.remove(self.instanceCtrlQueue)
	if instanceCtrl then
		local entity = self.createEntityFunc[instanceCtrl.createEntityType](instanceCtrl.ecosystemConfig)
		entity:SetComponentLodInfo()
		instanceCtrl:SetEntity(entity)
	end
	--CustomUnityUtils.EndSample()
end

--
function EcosystemCtrlManager:NeckCheck()
	if self.fight.fightFrame < 100 then
		return true
	end
	self.failTime = self.failTime - 1
	if self.failTime <= 0 then
		self.failTime = 5
		local x,y,z = BehaviorFunctions.GetPosition(self.ctrlEntity)
		self.lastX = x
		self.lastY = y
		self.lastZ = z
		return true
	end
	local x,y,z = BehaviorFunctions.GetPosition(self.ctrlEntity)
	local radiusSquare2 = (self.lastX - x) * (self.lastX - x) +
	(self.lastY - y) * (self.lastY - y) + (self.lastZ - z) * (self.lastZ - z)
	if radiusSquare2 > 2 then
		self.lastX = x
		self.lastY = y
		self.lastZ = z
		self.failTime = 5
		return true
	end
	
	return false
end

function EcosystemCtrlManager:Pause()
	self.pauseCount = self.pauseCount + 1
end

function EcosystemCtrlManager:Resume()
	if self.pauseCount > 0 then
		self.pauseCount = self.pauseCount - 1
	end
end

function EcosystemCtrlManager:AddInstanceQueue(ctrl)
	table.insert(self.instanceCtrlQueue,ctrl)
end

function EcosystemCtrlManager:ChangeEntityCreateState(ecoId, state)
	if not self.ecosystemCtrls[ecoId] then
		return
	end

	self.ecosystemCtrls[ecoId]:ChangeCreateState(state)
end

function EcosystemCtrlManager:ChangeCtrlPosition(ecoId, position)
	if not self.ecosystemCtrls[ecoId] then
		return
	end

	self.ecosystemCtrls[ecoId]:ChangePosition(position)
end

function EcosystemCtrlManager:GetEcosystemCtrl(ecoId)
	return self.ecosystemCtrls[ecoId]
end

function EcosystemCtrlManager:__cache()

end

function EcosystemCtrlManager:__delete()

end