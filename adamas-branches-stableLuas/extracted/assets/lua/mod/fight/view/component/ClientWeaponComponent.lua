---@class ClientWeaponComponent
ClientWeaponComponent = BaseClass("ClientWeaponComponent",PoolBaseClass)
--轻量的武器控制，复杂的需要做成实体

local _min = math.min
local _max = math.max
local _tInsert = table.insert
local _tRemove = table.remove

function ClientWeaponComponent:__init()
	self.weaponMap = {}
	self.weaponAnimators = {}
end

function ClientWeaponComponent:Update()
	self:UpdatePos()
	self:TestUpdate()
end

function ClientWeaponComponent:Init(clientFight,clientEntity,info)
	self.clientFight = clientFight
	self.clientEntity = clientEntity
	self.weaponId = info
	self:BindWeapon(self.weaponId)

	self.effects = {}
	self.effectInstance = 0
end

local DataHeroMain = Config.DataHeroMain.Find

function ClientWeaponComponent:BindWeapon(weaponId)
	local bindConfig = RoleConfig.GetWeaponAsset(weaponId)
	local rootParent = self.clientEntity.entity.root
	if bindConfig then
		for i = 1, #bindConfig do
			local masterId = rootParent and rootParent.masterId or self.clientEntity.entity.masterId
			masterId = mod.RoleCtrl:GetRealRoleId(masterId)
			local bindPoint = DataHeroMain[masterId].bind[i]
			local tf = self.clientEntity.clientTransformComponent:GetTransform(bindPoint)
			if tf and tf.childCount > 0 then
				if next(self.weaponMap) then
					local go = tf:GetChild(tf.childCount - 1)
					local x, y = string.find(go.name, "ClientWeapon_")
					if x or y then
						go.name = string.gsub(go.name, "ClientWeapon_", "")
						self.clientFight.assetsPool:Cache(self.weaponMap[bindPoint].path, go.gameObject)
					end
				end
			end
			local go = self.clientFight.assetsPool:Get(bindConfig[i][1])
			go.name = "ClientWeapon_"..go.name
			self.clientEntity.clientTransformComponent:SetTransformChild(go.transform, bindPoint, go.name)
			go.transform:ResetAttr()
			self.weaponMap[bindPoint] = {
				path = bindConfig[i][1],
				obj = go.gameObject,
				weaponTrans = go.transform,
				cacheGroupTransform = {},
				transformGroup = go.gameObject:GetComponent(BindTransform),
				parentTrans = go.transform.parent,
			}
			self.weaponAnimators[i] = go.gameObject:GetComponentInChildren(Animator)
		end
		CustomUnityUtils.SetShadowRenderers(self.clientEntity.clientTransformComponent.gameObject)
		self.clientEntity.clientTransformComponent:ReSetMeshRendererGetter()
	end
end

function ClientWeaponComponent:GetWeaponPosition(boneName)
	local trans = self:GetWeaponTransByBindName(boneName)
	if not trans then return end
	return trans.position
end

function ClientWeaponComponent:GetWeaponByBindName(boneName)
	if self.weaponMap[boneName] then
		return self.weaponMap[boneName].obj
	end
end

function ClientWeaponComponent:GetWeaponTransByBindName(boneName, name)
	local weapon = self.weaponMap[boneName]
	if weapon then
		if not name or name == "" or name == weapon.weaponTrans.name then
			return weapon.weaponTrans
		end

		if weapon.cacheGroupTransform[name] then
			return weapon.cacheGroupTransform[name]
		end

		if not weapon.transformGroup then
			return
		end
		weapon.cacheGroupTransform[name] = weapon.transformGroup:GetTransform(name)
		return weapon.cacheGroupTransform[name]
	end
end

-- function ClientWeaponComponent:GetWeaponBindBone(weaponId)
-- 	local bindConfig = RoleConfig.GetWeaponAsset(weaponId)
-- 	if not bindConfig then
-- 		LogError("[weapon] 这个武器没有配置 weaponId = "..weaponId)
-- 		return
-- 	end

-- 	local bindBones = {}
-- 	for i = 1, #bindConfig do
-- 		table.insert(bindBones, bindConfig[i][1])
-- 	end

-- 	return bindBones
-- end

function ClientWeaponComponent:ChangeWeapon(weaponId)
	self:CacheWeapon(self.weaponId)
	self.weaponId = weaponId
	self:BindWeapon(self.weaponId)
end

function ClientWeaponComponent:CacheWeapon(weaponId)
	for k, v in pairs(self.weaponMap) do
		local obj = v.obj
		local x, y = string.find(obj.name, "ClientWeapon_")
		if x or y then
			obj.name = string.gsub(obj.name, "ClientWeapon_", "")
		end
		self.clientFight.assetsPool:Cache(v.path, obj)
	end
	TableUtils.ClearTable(self.weaponMap)
	TableUtils.ClearTable(self.weaponAnimators)
end

function ClientWeaponComponent:PlayWeaponAnimation(index,name,startFrame)
	local animator = self.weaponAnimators[index]
	if animator then
		local speed = self.clientEntity.entity.timeComponent:GetTimeScale()
		local fixedTimeOffset = speed == 0 and 0 or startFrame / speed
		--Log("fixedTimeOffset "..fixedTimeOffset* FightUtil.deltaTimeSecond)
		-- animator:CrossFadeInFixedTime(name,0,0,fixedTimeOffset * FightUtil.deltaTimeSecond)
		self.waitPlayParam = { index = index, name = name, fixedTimeOffset = fixedTimeOffset}
	end
end

-- TODO 临时方案 等TA修改工具之后不用这个东西了
function ClientWeaponComponent:AddWeaponEffect(effectPath, offset)
	if not self.weaponMap or not next(self.weaponMap) then
		return
	end

	local gameObject = self.clientFight.assetsPool:Get(effectPath)
	if not gameObject then
		return
	end

	local instanceId = self.effectInstance + 1
	self.effectInstance = self.effectInstance + 1
	self.effects[instanceId] = {}
	for k, v in pairs(self.weaponMap) do
		local renderer = v.obj:GetComponentInChildren(SkinnedMeshRenderer)
		if not renderer then
			goto continue
		end

		gameObject.transform:SetParent(renderer.gameObject.transform)
		gameObject.transform.localPosition = Vector3(offset[1], offset[2], offset[3])
		_tInsert(self.effects[instanceId], { obj = gameObject, path = effectPath })

		::continue::
	end

	return instanceId
end

function ClientWeaponComponent:RemoveWeaponEffect(instanceId)
	if not self.effects[instanceId] then
		return
	end

	for k, v in pairs(self.effects[instanceId]) do
		self.clientFight.assetsPool:Cache(v.path, v.obj)
	end

	self.effects[instanceId] = nil
end

function ClientWeaponComponent:RemoveAllWeaponEffect()
	for k, v in pairs(self.effects) do
		self:RemoveWeaponEffect(k)
	end
end

function ClientWeaponComponent:AfterUpdate()
	if not self.waitPlayParam  then
		return
	end
	local params = self.waitPlayParam
	local animator = self.weaponAnimators[params.index]
	if animator then
		local speed = self.clientEntity.entity.timeComponent:GetTimeScale()
		local fixedTimeOffset = speed == 0 and 0 or params.fixedTimeOffset / speed
		animator:CrossFadeInFixedTime(params.name, 0, 0, fixedTimeOffset* FightUtil.deltaTimeSecond)
	end
	self.waitPlayParam = nil
end

function ClientWeaponComponent:SetTimeScale(timeScale)
	for i, animator in ipairs(self.weaponAnimators) do
		if animator then
			animator.speed = timeScale
		end
	end
end

function ClientWeaponComponent:OnCache()
	self:RemoveAllWeaponEffect()

	for _, info in pairs(self.weaponMap) do
		self.clientFight.assetsPool:Cache(info.path, info.obj)
	end

	-- if next(self.weaponMap) then
	-- 	CustomUnityUtils.SetShadowRenderers(self.gameObject)
	-- end

	TableUtils.ClearTable(self.weaponMap)
	self.clientFight.fight.objectPool:Cache(ClientWeaponComponent,self)

end

function ClientWeaponComponent:__cache()
	--self.clientFight.assetsPool:Cache(self.path,self.animatorController)
end

function ClientWeaponComponent:__delete()
	self.clientFight = nil
	self.clientEntity = nil
end

function ClientWeaponComponent:PTMMove(allFrame, maxSpeed, minSpeed, isRevert, boneName, isBindTarget, targetOffset, ignoreY)
	local entity = self.clientEntity.entity
	local skillComponent = entity.skillComponent
	local target = skillComponent.target
	local skiiTargetPos = skillComponent.targetPosition
	self.skillTargetPos = skiiTargetPos

	-- if isRevert then
	-- 	target = entity
	-- end

	if target then
		local targetTrans = target.clientEntity.clientTransformComponent:GetTransform(boneName)
		self.targetTrans = targetTrans
	end
	self.target = target

	self.allFrame = allFrame == 0 and 1 or allFrame
	self.isPTM = true
	self.isRevert = isRevert
	self.boneName = boneName
	self.maxSpeed = maxSpeed
	self.minSpeed = minSpeed

	local euler = self.clientEntity.entity.transformComponent.rotation:ToEulerAngles()
	local vec = Vector3(targetOffset[1], targetOffset[2], targetOffset[3])
	local q = Quaternion.AngleAxis(euler.y, Vector3.up) * vec
	self.targetOffset = q

	self.PTMIgnoreY = ignoreY
	local rot = entity.transformComponent.rotation
	
	for _, data in pairs(self.weaponMap) do
		local obj = data.obj
		if isBindTarget and not isRevert and target then
			target.clientEntity.clientTransformComponent:SetTransformChild(obj.transform, boneName)
		else
			obj.transform:SetParent(self.clientFight.clientEntityManager.entityRoot.transform)
		end
		UnityUtils.SetRotation(obj.transform, rot.x, rot.y, rot.z, rot.w)
		self:UpdatePosition(obj)
	end
end

function ClientWeaponComponent:RevertWeaponInfo()
	self.isPTM = false
	for _, data in pairs(self.weaponMap) do
		if self.isRevert then
			-- self.target.clientEntity.clientTransformComponent:SetTransformChild(data.obj.transform, self.boneName)
			data.obj.transform:SetParent(data.parentTrans)
			data.obj.transform:ResetAttr()
		end
	end
	-- self.targetTrans = nil
	-- self.skillTargetPos = nil
end

function ClientWeaponComponent:UpdatePos()
	if not self.isPTM then return end
	if self.allFrame <= 0 then
		self:RevertWeaponInfo()
		return
	end

	for _, data in pairs(self.weaponMap) do
		self:UpdatePosition(data.obj)
	end
end

local PTMPos = Vec3.New()
function ClientWeaponComponent:UpdatePosition(weapon)
	local moveTrans = weapon.transform
	local scale = self.clientEntity.entity.timeComponent:GetTimeScale()
	local targetPos = self.skillTargetPos
	if self.targetTrans then
		targetPos = self.targetTrans.position
	end

	PTMPos.x = targetPos.x + self.targetOffset.x
	PTMPos.y = targetPos.y + self.targetOffset.y
	PTMPos.z = targetPos.z + self.targetOffset.z
	local curPos = moveTrans.position
	if self.PTMIgnoreY then
		PTMPos.y = curPos.y
	end

	local dir = PTMPos - curPos
	dir = Vec3.Normalize(dir)

	local dis = math.sqrt((PTMPos.x - curPos.x)^2 + (PTMPos.z - curPos.z)^2 + (PTMPos.y - curPos.y)^2)
	local speed = dis / self.allFrame
	speed = _min(speed, self.maxSpeed)
	speed = _max(speed, self.minSpeed)

	local movePos = dir * speed * scale
	UnityUtils.SetPosition(moveTrans, curPos.x + movePos.x, curPos.y + movePos.y, curPos.z + movePos.z)
	self.allFrame = self.allFrame - 1
end

function ClientWeaponComponent:FlyWeapon(bindName)
	local entity = self.clientEntity.entity
	local entityTransform = entity.clientTransformComponent.gameObject.transform
	local bezierTrack = entityTransform:GetComponent(BezierTrack)
	if not bezierTrack then return end

	if self.isFly then
		self.isFly = nil
		-- self.accVal = nil
		-- self.time = nil
		return
	end
	local rot = entity.transformComponent.rotation
	for _, data in pairs(self.weaponMap) do
		local obj = data.obj
		obj.transform:SetParent(self.clientFight.clientEntityManager.entityRoot.transform)
		UnityUtils.SetRotation(obj.transform, rot.x, rot.y, rot.z, rot.w)
		bezierTrack:SetMoveTrans(obj.transform)
	end

	self.isFly = true
	local tf = self.clientEntity.clientTransformComponent:GetTransform(bindName)
	if tf then
		bezierTrack:SetBindTransform(tf)
	end

	bezierTrack:SetBezierMoveEndCb(self:ToFunc("WeaponMoveEnd"))
	bezierTrack:StartMove()
end

function ClientWeaponComponent:WeaponMoveEnd()
	self.isFly = nil
	self:RevertWeaponInfo()
	self.isRevert = true
end

function ClientWeaponComponent:TestUpdate()
	if not self.isFly then return end
	-- local entity = self.clientEntity.entity
	-- self.time = self.time or FightUtil.deltaTimeSecond
	-- self.time = self.time + FightUtil.deltaTimeSecond

	-- self.accVal = self.accVal or 3
	-- local accVal = self.accVal * entity.timeComponent:GetTimeScale() * self.time
	-- accVal = math.min(accVal, 30)

	-- 武器自旋转
	for key, data in pairs(self.weaponMap) do
		local obj = data.obj
		local transEuler = obj.transform.rotation.eulerAngles
		obj.transform:Rotate(Vector3(50, 0, 0))
	end
end