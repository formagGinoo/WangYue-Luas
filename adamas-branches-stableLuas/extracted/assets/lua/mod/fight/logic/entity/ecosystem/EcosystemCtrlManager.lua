EcosystemCtrlManager = BaseClass("EcosystemCtrlManager")
--生态实体刷新控制器   管理器
--用于管理    生态实体刷新控制器
function EcosystemCtrlManager:__init(fight, entityManager)
	self.ecosystemCtrls = {}
	self.removeCtrls = {}
	self.addCtrls = {}
	self.removeOffset = 5--卸载距离缓冲，避免玩家在边缘反复横跳
	self.ctrlEntity = 2
	self.instanceCtrlQueue = {}
	self.pauseCount = 0

	self.fight = fight
	self.entityManager = entityManager
	self.assetsNodeManager = self.fight.clientFight.assetsNodeManager

	self.createEntityFunc = {
		[FightEnum.CreateEntityType.Ecosystem] = function(config) return self.entityManager.ecosystemEntityManager:CreateSysEntity(config, FightEnum.CreateEntityType.Ecosystem) end,
		[FightEnum.CreateEntityType.Npc] = function(config) return self.entityManager.npcEntityManager:CreateNpc(config) end,
		[FightEnum.CreateEntityType.Drop] = function(config) return self.entityManager.ecosystemEntityManager:CreateDropEntity(config) end,
		[FightEnum.CreateEntityType.Mercenary] = function (config)
			return self.entityManager.ecosystemEntityManager:CreateSysEntity(config, FightEnum.CreateEntityType.Mercenary)
		end,
	}
	self.lastX = 0
	self.lastY = 0
	self.lastZ = 0
	self.failTime = 0
end

--表格分块加载
function EcosystemCtrlManager:AddEcosystemEntity(ecosystemConfig, type, waitCreate, isGm)
	if self.ecosystemCtrls[ecosystemConfig.id] or self.addCtrls[ecosystemConfig.id] then
		LogError("生态已创建 ecoId = ".. ecosystemConfig.id)
		return
	end

	if type ~= FightEnum.CreateEntityType.Drop then
		local mailingId = StoryConfig.GetMailingId(ecosystemConfig.id)
		if mailingId and mod.MailingCtrl:CheckMailingState(mailingId, FightEnum.MailingState.Finished) then
			return
		end
	end

	local ctrl = self.fight.objectPool:Get(EcosystemCtrl)
	ctrl:Init(self, ecosystemConfig, type, waitCreate, isGm)

	if isGm and ecosystemConfig.gmCfg then
		ctrl.gmCfg = ecosystemConfig.gmCfg
	end

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

function EcosystemCtrlManager:StartLoading(mapId, loadProgress)
	self.loadProgress = loadProgress
	mod.WorldFacade:SendMsg("ecosystem_state", mapId)
end

function EcosystemCtrlManager:OnRecvEcosystemState()
	self.entityManager.ecosystemEntityManager:Update()
     self:Update()
	 self.loadingCount = self:GetLoadingCount()
	 self.loadCount = self.loadingCount
	 self.loadingStart = true	
end

function EcosystemCtrlManager:LoadingUpdate()
	if not self.loadingStart then
		return
	end

	self:Update()
	self.loadingCount = self:GetLoadingCount()
	if self.loadingCount == 0 then
		self.loadingStart = false
		self.loadProgress(1)
	else
		self.loadProgress((self.loadCount - self.loadingCount) / self.loadCount)
	end
end

function EcosystemCtrlManager:GetLoadingCount()
	local count = 0
	for k, ctrl in pairs(self.ecosystemCtrls) do
		if ctrl.isLoading then
			count = count + 1
		end
	end

	return count
end

function EcosystemCtrlManager:Update()
	if self.pauseCount > 0 then
		return
	end
	self.ctrlEntity = BehaviorFunctions.GetCtrlEntity()
	
	for k, v in pairs(self.addCtrls) do
		if self.ecosystemCtrls[k] then
			LogError("重复加载生态 ecoId = ".. k)
		end
		self.ecosystemCtrls[k] = v
	end
	
	for k, v in pairs(self.removeCtrls) do
		local ctrl = self.ecosystemCtrls[v]
		self.fight.objectPool:Cache(EcosystemCtrl,ctrl)
		self.ecosystemCtrls[v] = nil
	end
	
	local lodCenter = self.fight.playerManager:GetPlayer():GetLodCenterPoint()
	for k, ctrl in pairs(self.ecosystemCtrls) do
		ctrl:Update(lodCenter)
	end
	--由于这里清掉了removeCtrls，所以由于超出距离删除的entity的删除ecoCtrl逻辑不会生效，还是可以继续计算是否在加载范围内
	TableUtils.ClearTable(self.addCtrls)
	TableUtils.ClearTable(self.removeCtrls)
	local instanceCtrl = table.remove(self.instanceCtrlQueue)
	if instanceCtrl then
		if not self.createEntityFunc[instanceCtrl.createEntityType] then
			print("instanceCtrl.createEntityType", instanceCtrl.createEntityType)
		end
		local entity = self.createEntityFunc[instanceCtrl.createEntityType](instanceCtrl.ecosystemConfig)
		if entity then
			instanceCtrl:SetEntity(entity)
			if entity.rotateComponent then
				entity.rotateComponent:Async()
			end

			if WorldSwitchTimeLine.Instance.switchStart then
				entity:Update()
			end
		end
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

function EcosystemCtrlManager:ChangeEntityCreateState(ecoId, state, isNotCreateCtrl)
	if not self.ecosystemCtrls[ecoId] then
		if self.addCtrls[ecoId] then
			self.addCtrls[ecoId]:ChangeCreateState(state)
			return
		end
		-- TODO 这里是为了野外boss处理添加的限制
		if not isNotCreateCtrl and state then
			local ecoCfg, ecoType = self.entityManager:GetEntityConfigByID(ecoId)
			local createType = ecoType == FightEnum.EcoEntityType.Npc and FightEnum.CreateEntityType.Npc or FightEnum.CreateEntityType.Ecosystem
			if not ecoCfg or not next(ecoCfg) then
				return
			end
			self:AddEcosystemEntity(ecoCfg, createType, not state)
		end
		return
	end

	self.ecosystemCtrls[ecoId]:ChangeCreateState(state)
end

function EcosystemCtrlManager:UpdateNpcTaskBind(ecoId, state, pos)
	if not self.ecosystemCtrls[ecoId] then
		if not self.addCtrls[ecoId] then
			--npc还未加载时,记录到运行时生态数据表中,这样走到对应区域时就会创建ctrl，并在init时调用UpdateTaskOccupy()
			self.entityManager.ecosystemEntityManager:AddRunTimeEcoData(ecoId, state, pos)
			self.entityManager.ecosystemEntityManager:SetImmediateUpdate()
		else
			self.addCtrls[ecoId]:UpdateTaskOccupy()
		end
		return
	end

	self.ecosystemCtrls[ecoId]:UpdateTaskOccupy()
end

function EcosystemCtrlManager:CancelNpcTaskBind(ecoId)
	self.entityManager.ecosystemEntityManager:RemoveRunTimeEcoData(ecoId)
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

function EcosystemCtrlManager:IsEcoHaveCtrl(ecoId)
	return self.ecosystemCtrls[ecoId] or self.addCtrls[ecoId]
end

function EcosystemCtrlManager:GetEcoBornPos(ecoId)
	if self.ecosystemCtrls[ecoId] or self.addCtrls[ecoId] then
		return self.ecosystemCtrls[ecoId] and self.ecosystemCtrls[ecoId]:GetPosition() or self.addCtrls[ecoId]:GetPosition()
	end

	local positionName
	local levelId
	local belongId
	local bindTask = self.entityManager.npcEntityManager:GetNpcBindTask(ecoId)
	if bindTask then
		local task = mod.TaskCtrl:GetTask(bindTask.taskId)
		if task then
			local occupyCfg = mod.TaskCtrl:GetTaskOccupyConfig(task.taskId, task.stepId)
			if occupyCfg then
				for k, v in pairs(occupyCfg.occupy_list) do
					if k == ecoId then
						levelId = v[3] ~= 0 and v[3] or levelId
						positionName = v[6] ~= "" and v[6] or positionName
						belongId = v[5] ~= "" and v[5] or belongId
						break
					end
				end
			end
		end
	end

	if not levelId or not positionName then
		local ecoCfg = self.entityManager:GetEntityConfigByID(ecoId)
		if not ecoCfg then
			LogError("没有这个生态啊 ecoId = "..ecoId)
			return Vec3.New(0, 0, 0)
		end

		levelId = ecoCfg.map_id
		positionName = ecoCfg.position[2]
		belongId = ecoCfg.position[1]
	end

	local mapPos = BehaviorFunctions.GetTerrainPositionP(positionName, levelId, belongId)
	if not mapPos then
		LogError("找不到生态出生点信息 :name = "..positionName..", belongId = "..belongId.." levelId = "..levelId)
		return Vec3.New(0, 0, 0)
	end

	return Vec3.New(mapPos.x, mapPos.y, mapPos.z)
end

function EcosystemCtrlManager:__cache()

end

function EcosystemCtrlManager:__delete()

end