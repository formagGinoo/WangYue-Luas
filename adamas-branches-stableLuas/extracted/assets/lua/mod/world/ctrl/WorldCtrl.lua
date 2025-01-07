---@class WorlrCtrl : Controller
WorldCtrl = BaseClass("WorldCtrl",Controller)

function WorldCtrl:__init()
	self:__Clear()
end


function WorldCtrl:__Clear()
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

	local player = Fight.Instance.playerManager:GetPlayer()
	local ctrlEntity = player:GetCtrlEntityObject()
	ctrlEntity.transformComponent:SetPosition(x, y, z)
	BehaviorFunctions.Resume()
	player:AutoCtrlEntitySwitch()
	Fight.Instance.clientFight.cameraManager:OnTransportCallback(x,y,z)
	-- 通知一下现在传送了
	Fight.Instance.entityManager:CallBehaviorFun("OnTransport")

	-- 传送完了同步一下服务器
	local position = ctrlEntity.transformComponent.position
		local rotation = ctrlEntity.transformComponent:GetRotation():ToEulerAngles()
		local syncPos = {
			pos_x = math.floor(position.x * 10000),
			pos_y = math.floor(position.y * 10000),
			pos_z = math.floor(position.z * 10000)
		}

		local syncRot = {
			pos_x = math.floor(rotation.x * 10000),
			pos_y = math.floor(rotation.y * 10000),
			pos_z = math.floor(rotation.z * 10000)
		}
		mod.WorldFacade:SendMsg("map_sync_position", {mapId = self.fight:GetFightMap(), position = syncPos, rotate = syncRot})
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
	local mapId = Fight.Instance:GetFightMap()
	local mapConfig = mod.WorldMapCtrl:GetMapConfig(mapId)
	for k, v in pairs(self.transportPoint) do
		local ecoCfg = Fight.Instance.entityManager.ecosystemEntityManager:GetEcoEntityConfig(k)
		if not ecoCfg then
			goto continue
		end

		if mapId == ecoCfg.map_id then
			local transportPointPos = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(mapConfig.position_id, ecoCfg.position[2], ecoCfg.position[1])
			local dis = Vector3.Distance(transportPointPos, pos)
			if not minDis or minDis > dis then
				minDis = dis
				targetPoint = k
			end
		end

		::continue::
	end

	return targetPoint
end

-- 临时设置传送位置的接口 后续屏蔽
function WorldCtrl:SetTransportPos(x, y, z)
	if not x or not y or not z then
		self.transPos = nil
		return
	end

	self.transPos = Vec3.New(x, y, z)
end

function WorldCtrl:GetTransportPos()
	return self.transPos
end

function WorldCtrl:CheckIsTransportPointActive(id)
	if not self.transportPoint then
		return false
	end

	return self.transportPoint[id] == true
end

function WorldCtrl:__delete()

end
