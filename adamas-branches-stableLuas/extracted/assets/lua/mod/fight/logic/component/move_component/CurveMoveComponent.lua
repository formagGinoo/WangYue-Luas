CurveMoveComponent = BaseClass("CurveMoveComponent",PoolBaseClass)

local Vec3 = Vec3


function CurveMoveComponent:__init()
end

function CurveMoveComponent:Init(moveComponent, moveConfig)
	self.entity = moveComponent.entity
	self.speed = moveConfig.Speed
	self.moveComponent = moveComponent
	self.transformComponent = self.moveComponent.transformComponent
	self.curveConfig = moveConfig.CurveConfig
	local pos = self.entity.transformComponent.position
	self.orginPos = Vec3.New(pos.x, pos.y, pos.z) 
	self.speedY = 0
	self.speed = self.curveConfig.speed

	-- 加速度
	self.speedAccValue = self.curveConfig.speedAccValue
	self.speedAccTime = self.curveConfig.speedAccTime
	-- 加速度结束时间
	self.speedAccEndTime = self.curveConfig.speedAccEndTime
	self.speedAccEndDist = self.curveConfig.speedAccEndDist
	-- 减速度
	self.speedDecValue = self.curveConfig.speedDecValue
	self.speedDecTime = self.curveConfig.speedDecTime
	-- Y减速度
	self.speedYDecValue = self.curveConfig.speedYDecValue
	self.speedYDecMax = self.curveConfig.speedYDecMax

	self.speedStateTime = 0
	self.addSpeedState = true
end

function CurveMoveComponent:Update()
	if not self.orginPos then
		return
	end

	local scale = 1
	if self.entity.timeComponent then
		scale = self.entity.timeComponent:GetTimeScale()
	end
	local time =  scale * FightUtil.deltaTimeSecond
	self.speedStateTime = self.speedStateTime + time

	if self.addSpeedState then
		self:UpdateAddSpeedMove(time)
	else
		self:UpdateDecSpeedMove(time)
	end

	self.moveComponent:DoMoveForward(self.speed * time)
	if self.speedY ~= 0 then
		self.entity.transformComponent:SetPositionOffsetY(self.speedY * time)
	end
end

function CurveMoveComponent:UpdateAddSpeedMove(time)
	if not self.orginPos then
		local pos = self.entity.transformComponent.position
		self.orginPos = Vec3.New(pos.x, pos.y, pos.z) 
	end

	local dist = Vec3.Distance(self.orginPos, self.entity.transformComponent.position)
	if dist > self.speedAccEndDist then
		self.speedStateTime = 0
		self.addSpeedState = false
		return
	end

	if self.speedAccTime > 0 then
		self.speedAccTime = self.speedAccTime - time
    	self.speed = self.speed + (self.speedAccValue * time)
    end
end

function CurveMoveComponent:UpdateDecSpeedMove(time)
	if self.speedDecTime > 0 then
		self.speedDecTime = self.speedDecTime - time
    	self.speed = self.speed + (self.speedDecValue * time)
    end

    local tempSpeedY = self.speedY + (self.speedYDecValue * time)
    self.speedY = math.max(self.speedYDecMax, tempSpeedY)
end

function CurveMoveComponent:OnCache()
	self.targetEntity = nil
	self.moveComponent.fight.objectPool:Cache(CurveMoveComponent,self)
end

function CurveMoveComponent:__cache()
end

function CurveMoveComponent:__delete()
end