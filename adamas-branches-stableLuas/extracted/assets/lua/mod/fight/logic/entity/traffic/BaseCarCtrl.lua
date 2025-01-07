BaseCarCtrl = BaseClass("BaseCarCtrl",PoolBaseClass)

local _random = math.random

function BaseCarCtrl:__init()

end

function BaseCarCtrl:Init(fight, trafficManager, carInstanceId)
	self.fight = fight
	self.trafficManager = trafficManager
	self.carInstanceId = carInstanceId
	self.playerManager = self.fight.playerManager
	self.entityManager = self.fight.entityManager
	self.trafficParams = self.trafficManager.trafficParams
	
	self.blockUnloadFrame = self.trafficParams.block_unload_time * FightUtil.targetFrameRate
	
	self.isLoad = false
	self.enable = true
	self.hasDrive = false
	self.crashed = false
	self.timeLeaveView = 0
	self.closeDist = self.trafficManager.trafficParams.range[1]^2
	self.farDist = self.trafficManager.trafficParams.range[2]^2
end

function BaseCarCtrl:LoadCarEntity(entityId, callback)
	local callback = function()
        self.entity = self.entityManager:CreateEntity(entityId)
		self.trackMovement = self.entity.moveComponent.moveComponent
		if self.entity.attackComponent then
			self.entity.attackComponent:SetSleep(true)
		end
		--LuaTimerManager.Instance:AddTimer(1, 0.1, function()
			--self:EnableLogic(true)
		--end)

		self.isLoad = true
		if callback then
            callback()
        end
	end
	self.fight.clientFight.assetsNodeManager:LoadEntity(entityId, callback)
end

function BaseCarCtrl:Unload()
    if not self:CheckIsDriving() then
	    self.trafficManager:RemoveCtrl(self.carInstanceId)
    end
end


function BaseCarCtrl:SetDriveOn(isOn,driveInstance)
    if isOn then
        self.enable = false -- todo暂时上了车的都停止
	    self.hasDrive = true
    else
	    self.hasDrive = false
    end
end

-- 设置被撞击状态
function BaseCarCtrl:SetCrash()
    if self.isLoad and not self.crashed then
        self.crashed = true
        self.enable = false -- todo暂时上了车的都停止
    end
end

function BaseCarCtrl:CheckIsDriving()
	return self.hasDrive
end


--获取距离平方，开方速度慢
function BaseCarCtrl:SquareDistanceToCtrlEntity()
	local pos = self.entity.transformComponent.position
	local ctrlEntity = BehaviorFunctions.GetCtrlEntity()
	local x,y,z = BehaviorFunctions.GetPosition(ctrlEntity)
	local radiusSquare2 = (pos.x - x) * (pos.x - x) +
			(pos.y - y) * (pos.y - y) + (pos.z - z) * (pos.z - z)
	return radiusSquare2
end

function BaseCarCtrl:EnableLogic(enable)
	if self.enable == enable then
		return 
	end
	self.enable = enable
	UnityUtils.SetActive(self.entity.clientTransformComponent.model.gameObject, self.enable)
end

function BaseCarCtrl:CheckCarBlock()
	if not self.entity or not self.entity.moveComponent then
		return 
	end
	
	local blockFrame = self.trackMovement.blockFrame or 0
	return blockFrame >= self.blockUnloadFrame
end

function BaseCarCtrl:Update()
	
	if not BehaviorFunctions.CheckEntity(self.entity.instanceId) then
		self:Unload()
		return
	end

	local curStreetIndex = self.trackMovement:GetCurStreetIndex()
	local inHotSpace = false
	if curStreetIndex then
		inHotSpace = self.trafficManager:CheckInHotSpace(curStreetIndex)
	end
	

	local checkInView = BehaviorFunctions.CheckPosIsInScreen(self.entity.transformComponent.position)
	if not checkInView then
		self.timeLeaveView = self.timeLeaveView  + FightUtil.deltaTimeSecond
	else
		self.timeLeaveView = 0
	end

	
	local squareDis = self:SquareDistanceToCtrlEntity()

	-- 大于最远距离直接卸载
	-- 在最小距离内或在热点区等待比较长
	-- 否则很快卸载
	local longSave = squareDis < self.closeDist or inHotSpace
	if squareDis > self.farDist
		or  (longSave and self.timeLeaveView> 7)
		or  (not longSave and self.timeLeaveView > 2) then
		self:Unload()
		return
	end

	if self.enable and self.trafficManager.tccaLodEnable and self.entity then
		if squareDis > self.trafficManager.tccaLodDistance ^2 then
			self.trackMovement:SetMoveType(1)
		else
			self.trackMovement:SetMoveType(2)
		end
	end
end


function BaseCarCtrl:__cache()
	self.entity = nil
	self.enable = false
	self.isLoad = false
	self.crashed = false
	self.playerDriving = false
	self.trackMovement = nil

end

function BaseCarCtrl:__delete()
end
