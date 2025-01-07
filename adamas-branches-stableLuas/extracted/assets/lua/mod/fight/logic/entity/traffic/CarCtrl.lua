CarCtrl = BaseClass("CarCtrl",BaseCarCtrl)

local _random = math.random

function CarCtrl:__init()

end

function CarCtrl:Init(fight, trafficManager, carInstanceId, entityId, startPos,streetId)
	self:InitParams(fight, trafficManager, carInstanceId)

	self:LoadCarEntity(entityId, startPos)
	self.streetId = streetId
	self.debugLogRecord = false
end

function CarCtrl:InitByEntity(fight, trafficManager, carInstanceId, instanceId)
	self:InitParams(fight, trafficManager, carInstanceId)

	local entity = BehaviorFunctions.GetEntity(instanceId)
	self:UpdateCarEntity(entity, entity.transformComponent.position)
end

function CarCtrl:InitParams(fight, trafficManager, carInstanceId)
	
	self:BaseFunc("Init",fight, trafficManager, carInstanceId)
end


-- 根据起点生成路径
function CarCtrl:GetTrackPath(startPos)
	if startPos then
		self.streetId = self.trafficManager:GetClosestStreet(startPos)
	end
	local streetId = self.streetId 
	local street = self.trafficManager:GetStreetCenterData(streetId)
	local startPointIndex,roadLine = self.trafficManager:GetClosestStartPointIndex(startPos,streetId)

	local temp = {}
	local trackPoint = self.trafficManager:CreateTrackPoint(startPos,1)
	table.insert(temp, trackPoint)
	local startData = {pointIndex = startPointIndex,roadLine = roadLine}
	local trackPath = self.trafficManager:GetTrackPath(street, startData,temp)
	if self.trafficManager.debug then
		self.debugPoints = self.trafficManager:DrawPoints(trackPath,self.entity.entityId)
	end
	return trackPath
end

-- 自循环生成路径
function CarCtrl:LoopCarRoute()
	if not self.entity.moveComponent or not self.entity.moveComponent.moveComponent then
		if not self.debugLogRecord then
			LogError("car ctrl entity without moveComponent.moveComponent id = "..self.entity.entityId)
			self.debugLogRecord = true
		end
		return
	end

	local trackPath = self:GetTrackPath(self.entity.transformComponent.position)
	self.entity.moveComponent.moveComponent:SetTrackPath(trackPath, self.trafficParams,function ()
		self:LoopCarRoute()
	end)
end

function CarCtrl:LoadCarEntity(entityId, startPos)
	
	self:BaseFunc("LoadCarEntity",entityId,function()
		self:UpdateCarEntity(self.entity , startPos)
	end)
end

function CarCtrl:UpdateCarEntity(entity, startPos)
	self.entity = entity
	self.trackMovement = self.entity.moveComponent.moveComponent
	if not self.entity.moveComponent or not self.entity.moveComponent.moveComponent then
		if not self.debugLogRecord then
			LogError("car ctrl entity without moveComponent.moveComponent id = "..self.entity.entityId)
			self.debugLogRecord = true
		end
		return
	end

	--BehaviorFunctions.DrawRoadPath3(self.entity.instanceId)
	if self.entity.moveComponent.config.MoveType == FightEnum.MoveType.TrackPoint then
		local trackPath = self:GetTrackPath(startPos)
		self.entity.moveComponent.moveComponent:SetTrackPath(trackPath, self.trafficParams,function ()
			self:LoopCarRoute()
		end)
	end

	LuaTimerManager.Instance:AddTimer(1, 0.1, function()
		self.isLoad = true
		--self:EnableLogic(true)
	end)
end



function CarCtrl:Update()
	if not self.isLoad then
		return
	end

	if not self.entity.moveComponent or not self.entity.moveComponent.moveComponent then
		if not self.debugLogRecord then
			LogError("car ctrl entity without moveComponent.moveComponent id = "..self.entity.entityId)
			self.debugLogRecord = true
		end
		return
	end

	if not self.hasDrive and not self.crashed and self.enable then
		self.entity.moveComponent.moveComponent:SetEnable(true)
	else
		-- 系统车被撞或被开算作block随机准备消除
		self.entity.moveComponent.moveComponent:SetEnable(false,true)
	end
	
	local checkInView = BehaviorFunctions.CheckPosIsInScreen(self.entity.transformComponent.position)
	if self:CheckCarBlock() and not checkInView then
		self:Unload()
		return
	end
	
	self:BaseFunc("Update")
end


function CarCtrl:__cache()
	self.debugLogRecord = false
	self.fight.entityManager:RemoveEntity(self.entity.instanceId)
	self:BaseFunc("__cache")
end
