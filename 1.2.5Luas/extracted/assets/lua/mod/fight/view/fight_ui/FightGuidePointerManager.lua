FightGuidePointerManager = BaseClass("FightGuidePointerManager")

function FightGuidePointerManager:__init(clientFight)
	self.clientFight = clientFight

	self.guidePointer = {}
	self.uniqueIndex = 0

	self.guideEcoPointer = {}

	self.ScreenWidth = UIDefine.canvasRoot.rect.width
	self.ScreenHeight = UIDefine.canvasRoot.rect.height
end

function FightGuidePointerManager:StartFight()
	EventMgr.Instance:AddListener(EventName.SetCurEntity, self:ToFunc("UpdateCurPlayer"))
	EventMgr.Instance:AddListener(EventName.PlayerUpdate, self:ToFunc("UpdateCtrlEntity"))
	EventMgr.Instance:AddListener(EventName.UpdateEntityGuidePos, self:ToFunc("UpdateEntityGuide"))
end

function FightGuidePointerManager:__delete()
	for k, v in pairs(self.guidePointer) do
		self:RemoveGuide(k)
	end
	self.guidePointer = {}

	EventMgr.Instance:RemoveListener(EventName.SetCurEntity, self:ToFunc("UpdateCurPlayer"))
	EventMgr.Instance:RemoveListener(EventName.PlayerUpdate, self:ToFunc("UpdateCtrlEntity"))
	EventMgr.Instance:RemoveListener(EventName.UpdateEntityGuidePos, self:ToFunc("UpdateEntityGuide"))
end

function FightGuidePointerManager:UpdateCurPlayer(entity)
	self.curEntity = entity
end

function FightGuidePointerManager:GetUniqueIndex()
	local index = self.uniqueIndex
	self.uniqueIndex = self.uniqueIndex + 1
	return index
end

function FightGuidePointerManager:AddGuideEntity(entity, setting, guideType, taskId)
	if not entity or not entity.transformComponent then
		return
	end

	local position = entity.transformComponent:GetPosition()
	local extraSetting = { entityInstance = entity.instanceId, guideType = guideType, taskId = taskId }
	local index = self:AddGuidePosition(position, setting, extraSetting)

	entity.transformComponent:AddGuidePointer(index)

	return index
end

function FightGuidePointerManager:AddGuideEcoEntity(ecoId, setting, guideType, taskId)
	local ecoCfg = Fight.Instance.entityManager:GetEntityConfigByID(ecoId)
	if not ecoCfg or not next(ecoCfg) then
		return
	end

	local isNpc = Fight.Instance.entityManager.npcEntityManager:CheckEcoIdIsNpc(ecoId)
	local entity
	if isNpc then
		entity = BehaviorFunctions.GetNpcEntity(ecoId)
	else
		local instanceId = BehaviorFunctions.GetEcoEntityByEcoId(ecoId)
		if instanceId then
			entity = BehaviorFunctions.GetEntity(instanceId)
		end
	end

	local position
	if not entity then
		position = BehaviorFunctions.GetEcoEntityBornPosition(ecoId)
	else
		position = entity.transformComponent:GetPosition()
	end

	if not position then
		return
	end

	local extraSetting = { ecoId = ecoId, guideType = guideType, taskId = taskId }
	local index = self:AddGuidePosition(position, setting, extraSetting)

	self.guideEcoPointer[ecoId] = index

	return index
end

function FightGuidePointerManager:AddGuidePosition(pos, setting, extraSetting)
	if not pos then
		return
	end

	local index = self:GetUniqueIndex()
	self.guidePointer[index] = {pos = pos, showType = FightEnum.PointerShowType.Hide, setting = setting}

	if extraSetting and next(extraSetting) then
		for k, v in pairs(extraSetting) do
			self.guidePointer[index][k] = v
		end
	end
	EventMgr.Instance:Fire(EventName.AddGuidePointer, index)
	return index
end

function FightGuidePointerManager:RemoveGuide(index)
	if not self.guidePointer or not self.guidePointer[index] then
		return
	end

	if self.guidePointer[index].entityInstance then
		local entity = Fight.Instance.entityManager:GetEntity(self.guidePointer[index].entityInstance)
		if entity and entity.transformComponent then
			entity.transformComponent:RemoveGuidePointer(index)
		end
	end

	if self.guidePointer[index].ecoId then
		self.guideEcoPointer[self.guidePointer[index].ecoId] = nil
	end

	EventMgr.Instance:Fire(EventName.RemoveGuidePointer, index)
	self.guidePointer[index] = nil
end

function FightGuidePointerManager:UpdateEntityGuide(index, x, y, z, showType)
	if not self.guidePointer[index] then
		return
	end

	if x and y and z then
		local position = Vec3.New(x, y, z)
		self.guidePointer[index].pos = position
	end

	if showType then
		self.guidePointer[index].showType = showType
	end
end

function FightGuidePointerManager:UpdateEcoGuide(index, ecoId)
	local ecoCfg = Fight.Instance.entityManager:GetEntityConfigByID(ecoId)
	if not ecoCfg or not next(ecoCfg) then
		return
	end

	local isNpc = Fight.Instance.entityManager.npcEntityManager:CheckEcoIdIsNpc(ecoId)
	local entity
	if isNpc then
		entity = BehaviorFunctions.GetNpcEntity(ecoId)
	else
		local instanceId = BehaviorFunctions.GetEcoEntityByEcoId(ecoId)
		if instanceId then
			entity = BehaviorFunctions.GetEntity(instanceId)
		end
	end

	local position
	if not entity or not entity.transformComponent then
		position = BehaviorFunctions.GetEcoEntityBornPosition(ecoId)
	else
		position = entity.transformComponent:GetPosition()
	end

	if not position then
		return
	end

	self.guidePointer[index].pos = position
end

function FightGuidePointerManager:UpdatePositionGuide(index, x, y, z)
	if not self.guidePointer[index] then
		return
	end

	local position = Vec3.New(x, y, z)
	self.guidePointer[index].pos = position
end

function FightGuidePointerManager:GetPointer(index)
	if not self.guidePointer or not next(self.guidePointer) then
		return
	end

	return self.guidePointer[index]
end

function FightGuidePointerManager:GetPointerPos(index)
	return self.guidePointer[index].pos
end

function FightGuidePointerManager:Update()
	if not self.curEntity then
		self:UpdateCtrlEntity()
	end

	for k, v in pairs(self.guideEcoPointer) do
		self:UpdateEcoGuide(v, k)
	end
end

function FightGuidePointerManager:UpdateCtrlEntity()
	self.curEntity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
end

function FightGuidePointerManager:InScreen(sp)
	return math.abs(sp.x) <= self.ScreenWidth * 0.5 and math.abs(sp.y) <= self.ScreenHeight * 0.5 and sp.z > 0
end

local CycleWidth = 420
local CycleHeight = 225
local guideYTip = 2
function FightGuidePointerManager:CalaPointerPos(index, guideType)
	local setting = self.guidePointer[index]
	local offsetY = setting and setting.offsetY or 0
	local radius = setting and setting.radius or 0
	local pos = TableUtils.CopyTable(self.guidePointer[index].pos)
	if offsetY then
		pos.y = pos.y + offsetY
	end

	local hideOnSee = self.guidePointer[index].setting and self.guidePointer[index].setting.hideOnSee or false
	local sp = UtilsBase.WorldToUIPointBase(pos.x,pos.y,pos.z)
	
	if hideOnSee then
		if self:InScreen(sp) then
			return FightEnum.PointerShowType.Hide
		elseif guideType == FightEnum.GuideType.FightTarget then
			local entity = Fight.Instance.entityManager:GetEntity(setting.entityInstance)
			local markCaseTransform = entity.clientEntity.clientTransformComponent:GetTransform("MarkCase")
			local hitCaseTransform = entity.clientEntity.clientTransformComponent:GetTransform("HitCase")
			local markInScreen, hitInScreen = true, true
			
			if not UtilsBase.IsNull(markCaseTransform) then
				local markPos = markCaseTransform.position
				markInScreen = self:InScreen(UtilsBase.WorldToUIPointBase(markPos.x,markPos.y,markPos.z))
			end
			
			if not UtilsBase.IsNull(hitCaseTransform) then
				local hitPos = hitCaseTransform.position
				hitInScreen = self:InScreen(UtilsBase.WorldToUIPointBase(hitPos.x,hitPos.y,hitPos.z))
			end
			
			if hitInScreen and markInScreen then
				return FightEnum.PointerShowType.Hide
			end
		end
	end
	local showType = FightEnum.PointerShowType.Show
	local spX = sp.x
	local spY = sp.y
	local showDistance = self:InScreen(sp)

	if sp.z < 0 then
		spX = -spX
		spY = -spY
		if spX >= -CycleWidth and spX <= CycleWidth then
			spY = spY > 0 and CycleHeight or -CycleHeight
		end
	end

	local spXPercent = spX / CycleWidth
	local spYPercent = spY / CycleHeight
	local poinyIngRange = math.sqrt(spXPercent * spXPercent + spYPercent * spYPercent)
	if poinyIngRange > 1 then
		spX = spX / poinyIngRange
		spY = spY / poinyIngRange
	end

	if sp.x == spX and sp.y == spY then
		showType = FightEnum.PointerShowType.ShowAndHideArrow
	end
	sp.x = spX
	sp.y = spY

	local selfPos = self.curEntity.transformComponent.position
	local distance = math.floor(Vec3.Distance(pos, selfPos))
	local disDesc = distance.."m"
	if distance >= radius then
		if pos.y - selfPos.y > guideYTip then
			disDesc = TI18N("高处 ")..disDesc
		elseif pos.y - selfPos.y < -guideYTip then
			disDesc = TI18N("低处 ")..disDesc
		end
	elseif setting.guideType and setting.guideType == FightEnum.GuideType.Task then
		disDesc = "已在任务区域内"
		showType = FightEnum.PointerShowType.Hide
	end

	return showType, sp, showDistance, disDesc
end

function FightGuidePointerManager:GetPointerIcon(index)
	local guidePointer = self.guidePointer[index]
	if not guidePointer then
		return
	end

	if guidePointer.guideType == FightEnum.GuideType.Task then
		local taskConfig = mod.TaskCtrl:GetTaskConfig(guidePointer.taskId)
		return AssetConfig.GetTaskTypeIcon(taskConfig.type)
	elseif guidePointer.guideType == FightEnum.GuideType.FightTarget then
		return
	end
	return SystemConfig.GetIconConfig("guide_"..guidePointer.guideType).icon1
end

function FightGuidePointerManager:CheckPointerAttackAlarm(index, instanceId)
	local guidePointer = self.guidePointer[index]
	if not guidePointer then
		return false
	end
	
	return instanceId == self.guidePointer[index].entityInstance
end

function FightGuidePointerManager:GetAllPointerKey()
	local keys = {}
	for index, value in pairs(self.guidePointer) do
		table.insert(keys, index)
	end
	return keys
end