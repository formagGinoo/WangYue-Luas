---@class WorldCtrl : Controller
WorldCtrl = BaseClass("WorldCtrl",Controller)

function WorldCtrl:__init()
	self.mapId = 0
	self.duplicateId = nil
	self.transportPoint = nil

	self.loginMapID = 0
	self.loginMapPos = nil

	self.updatePosTime = 0
	self.debugDuplicate = false
end

function WorldCtrl:InMapTransport(position, posX, posY, posZ, isReloadUI)
	Fight.Instance.entityManager:CallBehaviorFun("BeforeTransport")
	local x, y, z
	if position then
		x, y, z = position.x, position.y, position.z
	else
		x, y, z = posX, posY, posZ
	end

	local callBack = function()
		local player = Fight.Instance.playerManager:GetPlayer()
		local ctrlEntity = player:GetCtrlEntityObject()
		ctrlEntity.transformComponent:SetPosition(x, y, z)
		BehaviorFunctions.Resume()
		player:AutoCtrlEntitySwitch()
		Fight.Instance.clientFight.cameraManager:OnTransportCallback(x,y,z)
		-- 通知一下现在传送了
		Fight.Instance.entityManager:CallBehaviorFun("OnTransport")
	end
	BehaviorFunctions.Pause()
	local resLoad = MapResourcesPreload.New(x, y, z, callBack)
	resLoad:DoPreload(not isReloadUI)
end

function WorldCtrl:SetTransportPoints(data)
	local isInit = false
	if not self.transportPoint then
		isInit = true
		self.transportPoint = {}
	end

	local unlockArea = 0
	for k, v in pairs(data.entity_born_id) do
		self.transportPoint[v] = true
		if not isInit and unlockArea == 0 then
			local transportCfg = Config.DataMap.data_map_transport[v]
			unlockArea = transportCfg.mid_area
		end
		
		if not isInit then
			EventMgr.Instance:Fire(EventName.TransportPointActive, v)
		end
	end

	if Fight.Instance and Fight.Instance.mapAreaManager then
		Fight.Instance.mapAreaManager:InitAreaState()
	end

	if unlockArea ~= 0 then
		WindowManager.Instance:OpenWindow(WorldMapWindow, { unlockArea = unlockArea })
	end
end

function WorldCtrl:GetTransportPoint()
	return self.transportPoint
end

function WorldCtrl:GetNearByTransportPoint(fromPos)
	local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	local pos = fromPos and Vector3(fromPos.x, fromPos.y, fromPos.z) or entity.transformComponent.position
	local minDis, targetPoint

	local mapConfig = mod.WorldMapCtrl:GetMapConfig(self.mapId)
	for k, v in pairs(self.transportPoint) do
		local ecoCfg = Fight.Instance.entityManager.ecosystemEntityManager:GetEcoEntityConfig(k)
		if self.mapId == ecoCfg.map_id then
			local transportPointPos = mod.WorldMapCtrl:GetMapPositionConfig(mapConfig.level_id, ecoCfg.position[2], ecoCfg.position[1])
			local dis = Vector3.Distance(transportPointPos, pos)
			if not minDis or minDis > dis then
				minDis = dis
				targetPoint = k
			end
		end
	end

	return targetPoint
end

function WorldCtrl:CheckIsTransportPointActive(id)
	if not self.transportPoint then
		return false
	end

	return self.transportPoint[id] == true
end

function WorldCtrl:__delete()

end
