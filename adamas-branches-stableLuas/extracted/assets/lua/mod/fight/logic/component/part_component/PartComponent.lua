---@class PartComponent
PartComponent = BaseClass("PartComponent",PoolBaseClass)

local AimViewSearch = Config.EntityCommonConfig.AimViewSearch

local FightConfig = Config.FightConfig

function PartComponent:__init()
	self.tmpSearchDistVec = Vec3.New()
	self.parts = {}

	-- 死亡区域记录
	self.deathZoneRecord = {}

	self.triggerLayer = {}
	self.triggerArea = {}
	
	--debug
	self.debugEnable = false
end

function PartComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.partConfig = entity:GetComponentConfig(FightEnum.ComponentType.Part)
	if not next(self.partConfig) then
		LogError("partConfig null "..entity.entityId)
	end
	self.animatorComponent = self.entity.animatorComponent
	self.transformComponent = self.entity.transformComponent
end

function PartComponent:LateInit()
	for k, v in ipairs(self.partConfig.PartList) do
		local part = self.fight.objectPool:Get(HitPart)
		part:Init(self.fight, self.entity, v, self.partConfig.isTrigger)
		table.insert(self.parts, part)
	end

	self:Update()
end

local DrawColor = Color(1, 0, 0, 0.5)
function PartComponent:Update()
	if DebugClientInvoke.Cache.ShowAttackCollider or self.debugEnable then
		for k, v in ipairs(self.parts) do
			v:Draw(DrawColor, DebugClientInvoke.Cache.ShowAttackCollider)
			self.debugEnable = DebugClientInvoke.Cache.ShowAttackCollider
		end
	end
end

function PartComponent:GetPart(partName)
	if not partName or partName == "" then
		return self.parts[1]
	end

	for k, v in pairs(self.parts) do
		if v.partName and v.partName == partName then
			return v
		end
	end
end

function PartComponent:SetCollisionLayer(layer)
	for k, v in pairs(self.parts) do
		v:SetCollisionLayer(layer)
	end
end

function PartComponent:SetCollisionEnable(enable)
	for k, v in pairs(self.parts) do
		v:SetCollisionEnable(enable)
	end
end

function PartComponent:PartsColliderCheckByAttack(attack, colliderList, hitHead)
	local hitPart, collisionAttacked
	if #self.parts == 1 then
		hitPart = self.parts[1]
		collisionAttacked = hitPart.colliderList[1]
	else
		local distance
		for k, v in pairs(colliderList) do
			local part, collision = self:GetPartByColliderInsId(v.colliderInsId)
			if part and part.enable then
				local collisonDistance = v.distance
				if hitHead and part.partWeakType and part.partWeakType == FightEnum.PartWeakType.Head then
					collisonDistance = 0
				end

				if not distance or distance > collisonDistance then
					hitPart = part
					distance = collisonDistance
					collisionAttacked = collision
				end

				if collisonDistance == 0 then
					break
				end
			end
		end
	end

	if hitPart and collisionAttacked then
		hitPart:SetCollisionAttacked(collisionAttacked)
	end

	return hitPart, collisionAttacked
end

function PartComponent:PartsColliderCheckByDodge(attack)
	local attackColliderList = attack:GetColliderList()
	local dodgeComponent = self.entity.dodgeComponent
	for i,transInfo in ipairs(dodgeComponent.transInfos) do
		for k, v in ipairs(self.parts) do
			if v.logicVisible then
				local colliderList = v:GetColliderList()
				for _, collision in ipairs(colliderList) do
					for __, atkCollision in ipairs(attackColliderList) do
						if CollisionCheck:GJKCheck(atkCollision, collision, transInfo) then
							return v
						end
					end
				end
			end
		end
	end
end

function PartComponent:GetBoneAnimationTransform(boneName)

	local boneAnimation = self.partConfig.BoneClipCurves[boneName]
	if not boneAnimation then
		return
	end

	local animationName = self.animatorComponent:GetAnimationName()
	if not boneAnimation[animationName] then
		return
	end

	-- local animator = self.entity.clientEntity.clientAnimatorComponent.animator
	local frame = self.animatorComponent:GetFrame()
	-- local clientFrame = CustomUnityUtils.GetAnimatorCurFrame(animator)
	-- print("animationName "..animationName.."frame "..frame.." clientFrame "..clientFrame)
	frame = frame % boneAnimation[animationName].FrameCount + 1

	local position = boneAnimation[animationName].Positions[frame]
	local euler 
	if boneAnimation[animationName].EulerAngels then
		euler = boneAnimation[animationName].EulerAngels[frame]
	end

	return position, euler
end


function PartComponent:GetSearchTransform(searchDist, searchEntityPos, searchEntityForward, degreePos,
	minDegree, maxDegree, checkLogicLock, distWeight, degreeWeight, heighWeight, viewWeight, useLockWeight, useSearchWeight)
	-- UnityUtils.BeginSample("GetSearchTransform")
	local lockTransform, attackTransform, distance, partName, partWeight
	local degree = 0
	for k, v in pairs(self.parts) do
		if v:IsPartLogicSearch() then
			if not checkLogicLock or v:IsPartLogicLock() then
				local colliderList = v:GetColliderList()
				for _, collider in ipairs(colliderList) do

					local pos = collider:GetPosition()
					if not pos then
						goto continue	
					end

					local collisonDistance = Vec3.Distance(searchEntityPos, pos) - collider.radius
					if searchDist < collisonDistance then
						goto continue
					end
					
					self.tmpSearchDistVec:SetA(pos)
					self.tmpSearchDistVec:Sub(degreePos)
					degree = CustomUnityUtils.AngleSigned(searchEntityForward, self.tmpSearchDistVec) % 360

					if minDegree and maxDegree then	
                       if minDegree > maxDegree then
                            if minDegree > degree and degree > maxDegree then
                                    goto continue
                            end
                        else
                            if minDegree > degree or degree > maxDegree then
                                goto continue
                            end
                        end
					end

					degree = math.abs((degree + 180) % 360 - 180)
					local hDistance = math.abs(pos.y - searchEntityPos.y)
					local viewPoint = CameraManager.Instance.mainCameraComponent:WorldToViewportPoint(pos)
					local viewDistance = math.max(math.abs(viewPoint.x - 0.5) / 0.5, math.abs(viewPoint.y - 0.5) / 0.5)
					local _partWeight, result = self:CalcSearchWeight(searchDist, collisonDistance, degree, hDistance, viewDistance, distWeight, degreeWeight, heighWeight, viewWeight) 
					if not result then
						goto continue
					end

					if useLockWeight then
						_partWeight = _partWeight + v.lockWeight
					end

					if useSearchWeight then
						_partWeight = _partWeight + v.searchWeight
					end

					if partWeight and partWeight > _partWeight then
						goto continue
					end

					partName = v.partName
					lockTransform = v.lockTransformName  
					attackTransform = v.attackTransformName
					distance = collisonDistance
					partWeight = _partWeight

					::continue::
				end
			end
		end
	end
	-- UnityUtils.EndSample()
	return partName, lockTransform, attackTransform, partWeight
end


function PartComponent:CalcSearchWeight(searchDist, distance, degree, hDistance, viewDistance, distWeight, degreeWeight, heighWeight, viewWeight)
	if viewWeight == FightEnum.SearchOnlyWeight then
		if 1 - viewDistance < 0 then
			return 0, false
		end
	end

	--( 距离权重 * (1.0 - 两者距离 / 搜索半径) + 角度权重 * (1.0 - 两者夹角 / 180°) ) + 
	--高度权重 * (1.0 - 两者高度差 / 搜索距离) ) + 画面内权重 * (1.0 - 画面内位置 / 画面中心距离)
	local weight = distWeight * (1 - distance / searchDist) + degreeWeight * (1 - degree / 180)
	weight = weight + heighWeight * (1 - hDistance / searchDist) + viewWeight * (1 - viewDistance)
	return weight, true
end


function PartComponent:GetAimSearchTransform(searchEntityPos)
	if #self.parts == 1 then
		return self.parts[1].lockTransform
	end

	local lockTransform, distance
	local degree = 0

	local searchIngScreen
	local searchWeakWeight
	local searchLockTransform
	for k, v in pairs(self.parts) do
		if v:IsPartLogicSearch() then
			local position = v.lockTransform.position
			local ingScreen, viewX, viewY = CustomUnityUtils.CheckWorldPosIngScreen(position.x, position.y, position.z)
			ingScreen = ingScreen and 1 or 0
			local distance = Vec3.SquareDistance(searchEntityPos, position)
			local distanceWeight = 0
			for k, v in ipairs(FightConfig.SearchAimDistWeight) do
				if distance < v[1] then
					distanceWeight = v[2]
					break
				end
			end
			
			local weakWeight = v.weakWeight - distance * distanceWeight
			if ingScreen == 1 then
				local screenWeightX = FightConfig.CalcSearchScreenParam(viewX) 
				local screenWeightY = FightConfig.CalcSearchScreenParam(viewY)
				weakWeight = screenWeightX + screenWeightY
			end

			local sort = false
			if not searchIngScreen then 
				sort = true
			else
				if searchIngScreen < ingScreen then
					sort = true
				else
					sort = weakWeight > searchWeakWeight
				end
			end

			if sort then
				searchIngScreen = ingScreen
				searchWeakWeight = weakWeight
				searchLockTransform = v.lockTransform
			end
		end
	end

	return searchLockTransform
end

-- 搜索屏幕中心最近部位
function PartComponent:SearchAimLockView(searchEntityPos, searchEntityForward)
	local partName, lockTransform, searchViewDistance, searchCheckViewSize
	local distanceX, distanceY
	for k, v in pairs(self.parts) do
		if v:IsPartLogicSearch() and v.lockTransform then
			local position = v.lockTransform.position
			
			local viewPoint = CameraManager.Instance.mainCameraComponent:WorldToViewportPoint(position)
			
			local ingScreen, viewX, viewY = CustomUnityUtils.CheckWorldPosIngScreen(position.x, position.y, position.z)
			if not ingScreen then
				goto continue
			end

			self.tmpSearchDistVec:SetA(position)
			self.tmpSearchDistVec:Sub(searchEntityPos)
			local degree = CustomUnityUtils.AngleSigned(searchEntityForward, self.tmpSearchDistVec) % 360
			degree = math.abs((degree + 180) % 360 - 180)
			if degree > AimViewSearch.CheckViewDegree then
				goto continue
			end

			local distX = math.abs(viewX - 0.5)
			local distY = math.abs(viewY - 0.5)
			local viewDistance = math.max(distX / 0.5, distY / 0.5)
			local distance = Vec3.Distance(searchEntityPos, position)
			local checkViewSize = AimViewSearch.MaxViewSize - math.min(math.max(distance * AimViewSearch.ViewDistanceParam - 0.05,0), AimViewSearch.MaxViewSize)
			checkViewSize = math.max(checkViewSize, AimViewSearch.MinViewSize)
			-- print("distance "..distance.." checkViewSize "..checkViewSize)
			if viewDistance <= checkViewSize then
				if not searchViewDistance or searchViewDistance > viewDistance then
					partName = v.partName
					lockTransform = v.lockTransform
					searchViewDistance = viewDistance
					searchCheckViewSize = checkViewSize
					distanceX = distX
					distanceY = distY
				end
			end
		end
		
		::continue::
	end

	return partName, lockTransform, searchViewDistance, searchCheckViewSize, distanceX, distanceY
end

function PartComponent:GetPartPosition(transformName)
	for k, v in pairs(self.parts) do
		local colliderList = v:GetColliderList()
		for _, collision in ipairs(colliderList) do
			if transformName == collision.colliderCfg.ParentName then
				return collision.transformComponent.position
			end
			::continue::
		end
	end	
end

function PartComponent:SetLogicVisible(visible)
	for k, v in pairs(self.parts) do
		v:SetLogicVisible(visible)
	end	
end

function PartComponent:OnDisable()
	if self.parts then
		for k, v in ipairs(self.parts) do
			if v.DeleteMe then
				v:DeleteMe()
			end
		end
		TableUtils.ClearTable(self.parts)
	end
end

function PartComponent:GetPartByColliderInsId(instanceId)
	for k, v in ipairs(self.parts) do
		local colliderList = v:GetColliderList()
		for _, collision in ipairs(colliderList) do
			if collision.colliderObjInsId == instanceId then
				return v, collision
			end
		end
	end
end

function PartComponent:CreateWeakEffect()
	self.setWeakNessOn = true
	self.entity.clientTransformComponent:SetMatKeyWord("_WEAKNESS_ON", true)
end

function PartComponent:DestroyWeakEffect()
	if not self.setWeakNessOn then
		return
	end

	self.entity.clientTransformComponent:SetMatKeyWord("_WEAKNESS_ON", false)
end

function PartComponent:DestroyCollider()
	for k, v in ipairs(self.parts) do
		v:DestroyCollider()
	end
end

function PartComponent:OnCache()
	for k, v in pairs(self.parts) do
		v:OnCache()
	end
	TableUtils.ClearTable(self.parts)
	self.fight.objectPool:Cache(PartComponent,self)
end

function PartComponent:__cache()
end

function PartComponent:__delete()
	if self.parts then
		for k, v in ipairs(self.parts) do
			if v.DeleteMe then
				v:DeleteMe()
			end
		end

		self.parts = nil
	end
end

