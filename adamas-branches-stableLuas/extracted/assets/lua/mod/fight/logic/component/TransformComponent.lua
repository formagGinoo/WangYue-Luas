---@class TransformComponent
TransformComponent = BaseClass("TransformComponent",PoolBaseClass)
local Vec3 = Vec3
local Quat = Quat
function TransformComponent:__init()
	self.position = Vec3.New()
	self.rotation = Quat.New(0,0,0,1)

	self.lastPosition = Vec3.New()
	self.lastRotation = Quat.New(0,0,0,1)

	self.clonePosition = Vec3.New()
	self.cloneRotation = Quat.New()
	
	-- 从clientTransform去更新对应的pointer数据
	self.guidePointers = nil
end

function TransformComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity

	--TODO 定点数算法
	self.config = self.entity:GetComponentConfig(FightEnum.ComponentType.Transform)
	self.velocity = Vec3.New()
end

--kcc，采用代理设计，这个是kcc代理位置更新回调
function TransformComponent:SetCurPosition(x,y,z)
	-- if self.entity.entityId == 1001 then 
	-- 	LogError("SetCurPosition "..x.."     "..z)
	-- end
	self.position.x = x
	self.position.y = y
	self.position.z = z
	self.velocity:SetA(self.position - self.lastPosition)
end

function TransformComponent:BeforeUpdate()
	self.lastRotation:CopyValue(self.rotation)
	self.lastPosition:SetA(self.position)
	--local kCCCharacterProxyGO = self.entity.clientEntity.clientTransformComponent.kCCCharacterProxyGO
	-- if kCCCharacterProxyGO then
	-- 	local pos = kCCCharacterProxyGO.transform.position
	-- 	self.position.x = pos.x
	-- 	self.position.y = pos.y
	-- 	self.position.z = pos.z
	-- end

	-- TODO 临时处理 后续把透明度组件整合一下
	if self.entity.values["tempPause"] then
		self.entity.values["tempPause"] = nil
		self.entity.clientTransformComponent:SetTranslucentPause(false)
	end
end

function TransformComponent:AfterUpdate()
	--self.velocity:SetA(self.position - self.lastPosition)
	self.lastPosition:SetA(self.position)
end

function TransformComponent:SetStartRotate(startQ)
	if self.config.StartRotateType and self.config.StartRotateType == 2 then
		local x = self.config.StartRotateX + math.random(self.config.RandomMinX,self.config.RandomMaxX)
		local y = self.config.StartRotateX + math.random(self.config.RandomMinY,self.config.RandomMaxY)
		local z = self.config.StartRotateX + math.random(self.config.RandomMinZ,self.config.RandomMaxZ)
		local q = Quat.Euler(x, y, z)
		self:SetRotation(q)
	else
		self:SetRotation(startQ)
	end
end

function TransformComponent:SetPosition(x,y,z,ignoreCamera)
	--LogError("TransformComponent:SetPosition x = "..x..", z = "..z)
	self.position.x = x
	self.position.y = y
	self.position.z = z

	--self.position.y = self.fight.terrain:CheckTerrainY(self.position)

	self.lastPosition:SetA(self.position)
	self.entity.clientTransformComponent:SetPosition(x,y,z)
	if ctx then
		if self.entity.clientEntity and self.entity.clientTransformComponent then
			-- self.entity.clientTransformComponent:Update(1)
			self.entity.clientTransformComponent:Async()
		end
		local ctrlEntity = BehaviorFunctions.GetCtrlEntity()
		if self.entity.instanceId == ctrlEntity and not ignoreCamera then
			--原是用来处理过远距离导致镜头出现快速插值的过程，现因为会导致一些设timeline后的镜头出现一些表现问题，先注释掉
			--self.fight.clientFight.cameraManager:SetCameraPosition(x,y,z)
		end
	end
end

function TransformComponent:SetPositionOffset(x,y,z)
	--LogError("TransformComponent:SetPositionOffset x = "..x..", z = "..z)
	self.position.x = self.position.x + x
	self.position.y = self.position.y + y
	self.position.z = self.position.z + z
end

function TransformComponent:SetPositionOffsetY(y)
	self.position.y = y + self.position.y
end

function TransformComponent:Async()
	--self.lastPosition:SetA(self.position)
end

function TransformComponent:GetRealPositionY()
	return self.position.y
end

function TransformComponent:GetSpeed()
	return self.velocity:Magnitude() / FightUtil.deltaTimeSecond
end

function TransformComponent:OnCache()
	self.fight.objectPool:Cache(TransformComponent,self)
end

function TransformComponent:SetRotation(rotation)
	self.rotation:CopyValue(rotation)
	--self.lastRotation:CopyValue(rotation)
end

function TransformComponent:SetRotation2(x,y,z,w)
	self.rotation:Set(x,y,z,w)
	--self.lastRotation:CopyValue(rotation)
end

function TransformComponent:SetRotationBlend(rotation)
	--self.lastRotation:CopyValue(self.rotation)
	self.rotation:CopyValue(rotation)
end

function TransformComponent:AsyncRotate()
	self.lastRotation:CopyValue(self.rotation)
end

function TransformComponent:GetPosition()
	self.clonePosition:SetA(self.position)
	return self.clonePosition
end

function TransformComponent:GetRotation()
	self.cloneRotation:CopyValue(self.rotation)
	return self.cloneRotation
end

function TransformComponent:GetDistanceFromTarget(targetEntity, checkRadius)
	if not targetEntity then
		return 0
	end
	
	local x1 = self.position.x
	local y1 = self.position.z
	local x2 = targetEntity.transformComponent.position.x
	local y2 = targetEntity.transformComponent.position.z
	local dist = math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))

	if checkRadius then
		if self.entity.collistionComponent then
			dist = dist - self.entity.collistionComponent.radius
		end

		if targetEntity.collistionComponent then
			dist = dist - targetEntity.collistionComponent.radius
		end
	end

	return dist
end

function TransformComponent:AddGuidePointer(index)
	if not self.guidePointers then
		self.guidePointers = {}
	end

	self.guidePointers[index] = true
end

function TransformComponent:RemoveGuidePointer(index)
	if not self.guidePointers or not self.guidePointers[index] then
		return
	end

	self.guidePointers[index] = nil
end

function TransformComponent:__cache()
	if self.guidePointers and next(self.guidePointers) then
		for k, v in pairs(self.guidePointers) do
			self.fight.clientFight.fightGuidePointerManager:RemoveGuide(k)
		end
		TableUtils.ClearTable(self.guidePointers)
	end

	self.fight = nil
	self.entity = nil
	self.position:Set()
	self.rotation:Set(0,0,0,1)

	self.lastPosition:Set()
	self.lastRotation:Set(0,0,0,1)
end

function TransformComponent:__delete()
	if self.guidePointers then
		for k, v in pairs(self.guidePointers) do
			self.fight.clientFight.fightGuidePointerManager:RemoveGuide(k)
		end
		TableUtils.ClearTable(self.guidePointers)
	end	
end
