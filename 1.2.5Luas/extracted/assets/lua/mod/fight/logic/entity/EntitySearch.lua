EntitySearch = BaseClass("EntitySearch")
local _insert = table.insert
local Vec3 = Vec3
local Color = Color
local Debug = Debug
local NpcTag = FightEnum.EntityTag.Npc

function EntitySearch:__init(entityManager)
	self.entityManager = entityManager
	self.earchResult = {}
end

function EntitySearch:SearchEntityByNpcTag()
	self.earchResult = {}
	for k, v in pairs(self.entityManager.entites) do
		if v.tagComponent and v.tagComponent.tag == FightEnum.EntityTag.Npc then
			local state = v.stateComponent:GetState()
			if v.stateComponent.backstage == FightEnum.Backstage.Foreground and state ~= FightEnum.EntityState.Death then
				table.insert(self.earchResult,k)
			end
		end
	end
	return self.earchResult
end

-- 相关距离和角度，有定点数后再具体改计算
local searchList = {}
function EntitySearch:SearchEntity(searchEntity, dist, minDegree, maxDegree, camp, tag,
		buffKind, nBuffKind, distWeight, degreeWeight, npcTag, getGroup, checkLogicLock, checkRay, heighWeight, viewWeight, lockWeight, searchWeight, cameraRt)

	local lastWeight = 0
	local entityId = searchEntity.entityId

	local searchTarget, searchTargetPart, searchTargetPartLock, searchTargetPartAttack
	local position = searchEntity.transformComponent.position
	if getGroup then
		TableUtils.ClearTable(searchList)
	end

	if minDegree and minDegree == 0 and maxDegree and maxDegree == 360 then
		minDegree = nil
		maxDegree = nil
	end

	local forward
	local degreePos = position
	if cameraRt then
		degreePos = CameraManager.Instance.cameraTransformPos
		forward = CameraManager.Instance.cameraTransformForward	
	else
		degreePos = position
		forward = searchEntity.transformComponent.rotation * Vec3.forward
	end


	local headTransform
	if checkRay then
		headTransform = searchEntity.clientEntity.clientTransformComponent:GetHeadTransform()
	end 

	local entites
	if tag and tag == NpcTag then
		entites = self.entityManager.bioEntites
	else
		entites = self.entityManager.entites
	end

	for k, v in pairs(entites) do
		if v.stateComponent and v.stateComponent.backstage ~= FightEnum.Backstage.Foreground then
			goto continue
		end

		if v.entityId == entityId then
			goto continue
		end

		if camp then
			if not v.campComponent or v.campComponent.camp ~= camp then
				goto continue
			end
		end

		if tag then
			if not v.tagComponent or v.tagComponent.tag ~= tag then
				goto continue
			else
				if v.stateComponent and v.tagComponent.tag == NpcTag then
					local state = v.stateComponent:GetState()
					if state == FightEnum.EntityState.Death then
						goto continue
					end
				end
			end
		end
		

		if npcTag then
			if not v.tagComponent or v.tagComponent.npcTag ~= npcTag then
				goto continue
			end
		end

		if buffKind then
			if not v.buffComponent or not v.buffComponent:HasBuffKind(buffKind) then
				goto continue
			end
		end	

		if nBuffKind then
			if not v.buffComponent or v.buffComponent:HasBuffKind(nBuffKind) then
				goto continue
			end
		end

		if checkRay then
			if not headTransform then
				goto continue
			end

			if not v.clientEntity.clientTransformComponent then
				Log("clientTransformComponent null "..v.instanceId)
				goto continue
			end

			local hitInfo = v.clientEntity.clientTransformComponent:TransformRayCastGroup(headTransform, "SearchRay")
			if not hitInfo then
				goto continue
			end
		end

		local partName, lockTransform, attackTransform, weight = v.partComponent:GetSearchTransform(dist, position, forward, degreePos, minDegree, 
			maxDegree, checkLogicLock, distWeight, degreeWeight, heighWeight, viewWeight, lockWeight, searchWeight)

		if not partName then
			goto continue
		end

		-- 转换成180度角
		-- degree = math.abs((degree + 180) % 360 - 180)
		-- local weight = self:CalcSearchWeight(dist, distance, degree, hDistance, viewDistance, distWeight, degreeWeight, heighWeight, viewWeight) + partWeight
		if getGroup then
			_insert(searchList, {[1] = v.instanceId, [2] = lockTransform, [3] = attackTransform, [4] = partName, weight = weight, entity = v})
		else
			if weight > lastWeight then
				lastWeight = weight
				searchTarget = v
				searchTargetPart = partName
				searchTargetPartLock = lockTransform
				searchTargetPartAttack = attackTransform
			end
		end

		::continue::
	end

	if searchList then
		local sort = function (a, b)
			return a.weight > b.weight
		end
		table.sort(searchList, sort)
		
		return searchList
	else
		if not searchTarget then
			return
		end

		return searchTarget.instanceId, searchTargetPartLock, searchTargetPartAttack, searchTargetPart
	end
end

function EntitySearch:SearchEntityPart(searchEntity, instanceId, dist, minDegree, maxDegree, distWeight, degreeWeight, checkLogicLock, 
	heighWeight, viewWeight, lockWeight, searchWeight, cameraRt)
	local targetEntity = Fight.Instance.entityManager:GetEntity(instanceId)
	local position = searchEntity.transformComponent.position
	local forward, degreePos
	if cameraRt then
		degreePos = CameraManager.Instance.cameraTransformPos
		forward = CameraManager.Instance.cameraTransformForward	
	else
		degreePos = position
		forward = searchEntity.transformComponent.rotation * Vec3.forward
	end

	local partName, lockTransform, attackTransform = targetEntity.partComponent:GetSearchTransform(dist, position, forward, degreePos, minDegree, maxDegree, checkLogicLock, 
		distWeight, degreeWeight, heighWeight, viewWeight, lockWeight, searchWeight)
	return lockTransform, attackTransform, partName
end

function EntitySearch:SearchAimLockViewEntity(searchEntity)
	local position = searchEntity.transformComponent.position
	local distanceX, distanceY
	local searchEntityForward = searchEntity.transformComponent.rotation * Vec3.forward
	local entity, partName, lockTransform, ViewDistance, checkViewSize
	for k, v in pairs(self.entityManager.entites) do
		if not v.campComponent or v.campComponent.camp ~= FightEnum.EntityCamp.Camp2 then
			goto continue
		end

		if not v.tagComponent or v.tagComponent.tag ~= FightEnum.EntityTag.Npc then
			goto continue
		end

		if not v.partComponent then
			goto continue
		end

		local _partName, _lockTransform, _viewDistance, _checkViewSize, _distanceX, _distanceY = v.partComponent:SearchAimLockView(position, searchEntityForward)
		if _partName then
			if not ViewDistance or ViewDistance > _viewDistance then
				entity = v
				partName = _partName
				lockTransform = _lockTransform
				ViewDistance = _viewDistance
				checkViewSize = _checkViewSize
				distanceX = _distanceX
				distanceY = _distanceY
			end
		end
		::continue::
	end

	return entity, partName, lockTransform, ViewDistance, checkViewSize, distanceX, distanceY
end

function EntitySearch:__delete()

end


