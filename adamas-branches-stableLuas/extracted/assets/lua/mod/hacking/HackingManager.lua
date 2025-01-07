---@class HackingManager
HackingManager = BaseClass("HackingManager")


function HackingManager:__init(fight)
	self.fight = fight
	
	self.hackPanel = nil
	
	self.hackMode = nil
	self.hackTargetList = {}
	
	self.hackingId = nil
	self.lastSelectedId = nil
	self.selectedId = nil
	
	self.mode = nil

	self.adsorptionHack = true
	self.coverTest = true

	self.taskEntitySign = {}

	self.overrideEntityInformation = {}
	self.overrideEntityEffect = {}

	
end

function HackingManager:__delete()
end

function HackingManager:StartFight()
	self.curRamValue = BehaviorFunctions.GetPlayerAttrValueAndMaxValue(FightEnum.PlayerAttr.CurRamValue)
end

function HackingManager:Update()
	local curRamValue, maxRamValue = BehaviorFunctions.GetPlayerAttrValueAndMaxValue(FightEnum.PlayerAttr.CurRamValue)

	if self.curRamValue ~= curRamValue then
		self.curRamValue = curRamValue
		EventMgr.Instance:Fire(EventName.PlayerRamChange)
	end
end

function HackingManager:OpenHackPanel()
	if self.hackPanel then
		return
	end
	
	local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	self.hackPanel = mainUI:OpenPanel(HackPanel)
end

function HackingManager:CloseHackPanel()
	if not self.hackPanel then
		return
	end
	
	local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	mainUI:ClosePanel(self.hackPanel)
	self.hackPanel = nil
end

function HackingManager:EnterHackingMode(args)
	SystemStateMgr.Instance:AddState(SystemStateConfig.StateType.Hack, args)
end

function HackingManager:TempEnterHackingMode(args)
	self.oldCameraState = BehaviorFunctions.GetCameraState()
	if not args or not args.mode or args.mode == FightEnum.HackMode.Hack then
		InputManager.Instance:AddLayerCount("Hack")
	end

	local ctrlId = BehaviorFunctions.fight.playerManager:GetPlayer():GetCtrlEntity()
	local ctrlEntity = BehaviorFunctions.GetEntity(ctrlId)
	if ctrlEntity.stateComponent:GetState() == FightEnum.EntityState.Hack then
		ctrlEntity.stateComponent:SetHackState(FightEnum.HackState.HackStart)
	else
		--BehaviorFunctions.DoSetEntityState(ctrlId, FightEnum.EntityState.Hack)
		SystemStateMgr.Instance:ChangeEntityState(SystemStateConfig.StateType.Hack, FightEnum.EntityState.Hack)
	end
	
	SystemStateMgr.Instance:SetFightVisible(SystemStateConfig.StateType.Hack, "100010000")
	-- BehaviorFunctions.SetFightPanelVisible("100010000")
	BehaviorFunctions.SetRamVisible(true)
	
	self:OpenHackPanel(args)
end

function HackingManager:ExitHackingMode(isBreak)
	local hackId = self:GetHackingId()
	if hackId then
		local hackComponent = self:GetHackComponent(hackId)
		if hackComponent then
			hackComponent:StopHacking()
		end
	end
	local selectId = self:GetSelectedId()
	if selectId then
		local hackComponent = self:GetHackComponent(selectId)
		if hackComponent then
			hackComponent:StopHacking()
		end
	end
	
	local ctrlEntity = BehaviorFunctions.fight.playerManager:GetPlayer():GetCtrlEntityObject()
	
	local state = ctrlEntity.stateComponent:GetState()
	if state == FightEnum.EntityState.Hack then
		ctrlEntity.stateComponent:SetHackState(FightEnum.HackState.HackEnd)
	else
		--BehaviorFunctions.DoSetEntityState(ctrlEntity.instanceId, FightEnum.EntityState.Idle)
		--BehaviorFunctions.SetCameraState(self.oldCameraState)
	end

	--BehaviorFunctions.SetFightPanelVisible("-1")
	BehaviorFunctions.SetRamVisible(false)
	self:CloseHackPanel()
	
	self.mode = nil
	self.fight.entityManager:CallBehaviorFun("ExitHacking")

	InputManager.Instance:MinusLayerCount("Hack")

	SystemStateMgr.Instance:RemoveState(SystemStateConfig.StateType.Hack)
end

function HackingManager:SetHackingId(id)
	self.hackingId = id
end

function HackingManager:GetHackingId()
	return self.hackingId
end

function HackingManager:SetHackMode(mode)
	self.mode = mode
end

function HackingManager:GetHackMode()
	return self.mode
end

function HackingManager:UpdateSelectedId(id)
	self.lastSelectedId = self.selectedId
	self.selectedId = id
end

function HackingManager:GetSelectedId()
	return self.selectedId, self.lastSelectedId
end

function HackingManager:GetHackComponent(id)
	id = id or self.selectedId
	if not id or not BehaviorFunctions.CheckEntity(id) then
		return
	end

	local entity = BehaviorFunctions.GetEntity(id)
	if not entity then
		return
	end
	
	return entity.hackingInputHandleComponent
end

function HackingManager:GetHackConfig(id)
	local component = self:GetHackComponent(id)
	if not component then
		return 
	end
	
	return component:GetConfig()
end

function HackingManager:IsHackEnable(id)
	local component = self:GetHackComponent(id)
	if not component then
		return false
	end
	
	return component.enable
end

function HackingManager:GetHackingTargetList()
	TableUtils.ClearTable(self.hackTargetList)
	local entities = Fight.Instance.entityManager:GetEntites()
	for _, v in pairs(entities) do
		if self:IsHackEnable(v.instanceId) then
			table.insert(self.hackTargetList, v.instanceId)
		end
	end

	return self.hackTargetList
end

function HackingManager:GetEntityHackingTransform(instanceId, boneName)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity or not entity.clientTransformComponent then
		return 
	end
	
	local transform = entity.clientTransformComponent:GetTransform(boneName)
	if not transform then
		transform = entity.clientTransformComponent:GetTransform()
	end
	return transform
end

local ViewportCenter = {0.5, 0.5}
function HackingManager:UpdateNearestHackingTarget(viewPortRange, worldRange, boneName, targetList)
	targetList = targetList or self:GetHackingTargetList()
	
	local ctrlId = Fight.Instance.playerManager:GetPlayer():GetCtrlEntity()
	local playerTransform = self:GetEntityHackingTransform(ctrlId, boneName)
	
	local nearestSquareDis = viewPortRange^2
	local worldSquareRange = worldRange^2
	
	local instanceId
	for _, v in pairs(targetList) do
		local targetTransform = self:GetEntityHackingTransform(v, boneName)
		if targetTransform then
			local pos = targetTransform.position
			if Vec3.SquareDistance(pos, playerTransform.position) <= worldSquareRange then
				local ingScreen, viewX, viewY = CustomUnityUtils.CheckWorldPosIngScreen(pos.x, pos.y, pos.z)
				if ingScreen then
					local squareDis = (viewX - ViewportCenter[1])^2 + (viewY - ViewportCenter[2])^2
					if nearestSquareDis > squareDis then
						nearestSquareDis = squareDis
						
						instanceId = v
					end
				end
			end
		end
	end

	return instanceId
end

function HackingManager:GetHackingTarget(viewPortRange, worldRange, boneName)
	if self.adsorptionHack then
		return self:GetHackingTargetAdsorption(viewPortRange, worldRange, boneName)
	else
		return self:GetHackingTargetNoAdsorption(viewPortRange, worldRange, boneName)
	end
end

function HackingManager:GetHackingTargetNoAdsorption(viewPortRange, worldRange, boneName)
	local cameraState = BehaviorFunctions.fight.clientFight.cameraManager.states[FightEnum.CameraState.Hacking]
	local cameraDistance = cameraState:GetCameraDistance()
	local camera = self.fight.clientFight.cameraManager:GetMainCameraTransform()
	
	local distance = cameraDistance + worldRange
	local idList, count = CS.CustomUnityUtils.GetRaycastEntity(camera.position, camera.rotation * Vector3.forward, 
		distance, FightEnum.LayerBit.EntityCollision, count)
	
	if count == 0 then
		return
	end
	
	--TableUtils.ClearTable(self.hackTargetList)
	
	local minSquareDis = distance^2
	local ctrlId = Fight.Instance.playerManager:GetPlayer():GetCtrlEntity()
	local playerTransform = self:GetEntityHackingTransform(ctrlId, boneName)
	
	local id
	for i = 0, count - 1 do
		local curId = idList[i]
		if curId ~= ctrlId then
			if self:IsHackEnable(curId) then
				local targetTransform = self:GetEntityHackingTransform(curId, boneName)
				local squareDis = Vec3.SquareDistance(targetTransform.position, playerTransform.position)
				if squareDis < minSquareDis then
					id = curId
					minSquareDis = squareDis
				end
				--table.insert(self.hackTargetList, curId)
			end
		end
	end
	
	
	--return self:UpdateNearestHackingTarget(viewPortRange, worldRange, boneName, self.hackTargetList)
	return id
end

local entityCollision = FightEnum.LayerBit.EntityCollision | FightEnum.LayerBit.Wall | FightEnum.LayerBit.CarBody | FightEnum.LayerBit.Default | FightEnum.LayerBit.Entity

--搜索离屏幕中心最近的可骇入实体
function HackingManager:GetHackingTargetAdsorption(viewPortRange, worldRange, boneName)

	if self.tempSwapCount then
		self.tempSwapCount = false
		return self.tempCacheEntity
	end

	local cameraState = BehaviorFunctions.fight.clientFight.cameraManager.states[FightEnum.CameraState.Hacking]
	local cameraDistance = cameraState:GetCameraDistance()
	local distance = (cameraDistance + worldRange)
	local squareDistance = distance * distance


	local mainCamera = cameraState.mainCamera
	local cameraTransform = self.fight.clientFight.cameraManager:GetMainCameraTransform()

	local curMinDisEntity = nil
	local curMinDis = 999999

	local entites = BehaviorFunctions.fight.entityManager:GetEntites()
	for _instanceId, v in pairs(entites) do
		if self:IsHackEnable(_instanceId) then
			local targetTransform = self:GetEntityHackingTransform(_instanceId, boneName)
			if UtilsBase.IsNull(targetTransform) then
				LogError(string.format("实例Id:%d, 实体Id:%d 找不到骇入点%s", _instanceId, v.entityId, boneName))
				goto continue
			end
			local viewPosX, viewPosY, viewPosZ = CustomUnityUtils.WorldToViewportPointTransfer(cameraState.mainCamera, targetTransform)
			if viewPosZ > 0 and viewPosX > 0.333 and viewPosX < 0.666 and viewPosY > 0.333 and viewPosY < 0.666 then
				--在视角空间下
				local squareEntityDis = Vec3.SquareDistance(targetTransform.position, cameraTransform.position)
				if squareEntityDis < squareDistance then
					local entitySquareDis = (viewPosX - 0.5) * (viewPosX - 0.5) + (viewPosY - 0.5) * (viewPosY - 0.5)
					if entitySquareDis < curMinDis then
						--打射线 判断是否有遮挡
						if self.coverTest then
							local direction = (targetTransform.position - cameraTransform.position).normalized
							local res = CustomUnityUtils.GetRaycastEntityHasBlock(cameraTransform.position, direction, distance, entityCollision, _instanceId)
							if res then
								curMinDis = entitySquareDis
								curMinDisEntity = _instanceId
							end
						else
							curMinDis = entitySquareDis
							curMinDisEntity = _instanceId
						end
					end
				end
			end
			::continue::
		end
	end
	self.tempCacheEntity = curMinDisEntity
	self.tempSwapCount = true

	return curMinDisEntity
end

function HackingManager:OpenDronePanel(targetInstanceId, isSetState)
	if self.dronePanel then
		return
	end
	local curEntity = BehaviorFunctions.fight.playerManager:GetPlayer():GetCtrlEntity()
	if not isSetState then
		BehaviorFunctions.DoSetEntityState(curEntity, FightEnum.EntityState.Hack)
	end

	BehaviorFunctions.SetFightPanelVisible("100010000")

	BehaviorFunctions.SetRamVisible(true)

	local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	self.dronePanel = mainUI:OpenPanel(ControlDronePanel)
	self.dronePanel:SetDroneId(targetInstanceId)
	
end

function HackingManager:CloseDronePanel(isSetState)
	if not self.dronePanel then
		return
	end
	local curEntity = BehaviorFunctions.fight.playerManager:GetPlayer():GetCtrlEntity()
	if not isSetState then
		BehaviorFunctions.DoSetEntityState(curEntity, FightEnum.EntityState.Idle)
	end

	BehaviorFunctions.SetFightPanelVisible("-1")
	BehaviorFunctions.SetRamVisible(false)

	local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
	mainUI:ClosePanel(self.dronePanel)
	self.dronePanel = nil
end

function HackingManager:CheckEntityIsTaskSign(instanceId)
	return self.taskEntitySign[instanceId] or false
end

function HackingManager:SetEntityTaskSign(instanceId, isTask)
	if isTask then
		self.taskEntitySign[instanceId] = isTask
	else
		self.taskEntitySign[instanceId] = nil
	end

	EventMgr.Instance:Fire(EventName.HackEntityTaskEffectUpdate, instanceId)
end

function HackingManager:SetOverrideEntityHackInformation(instanceId, title, icon, desc)
	local information = self.overrideEntityInformation[instanceId]

	if information then
		information.title = title
		information.icon = icon
		information.desc = desc
	else
		information = { title = title, icon = icon, desc = desc }
		self.overrideEntityInformation[instanceId] = information
	end
	
	EventMgr.Instance:Fire(EventName.HackEntityInformationUpdate, instanceId)
end

function HackingManager:GetOverrideEntityHackInformation(instanceId)
	local information = self.overrideEntityInformation[instanceId]
	return information
end

function HackingManager:SetOverrideEntityEffect(instanceId, effectType)
	self.overrideEntityEffect[instanceId] = effectType
	EventMgr.Instance:Fire(EventName.HackEntityEffectUpdate, instanceId)
end

function HackingManager:GetOverrideEntityEffect(instanceId)
	return self.overrideEntityEffect[instanceId]
end