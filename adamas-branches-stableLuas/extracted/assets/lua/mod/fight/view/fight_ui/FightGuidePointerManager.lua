FightGuidePointerManager = BaseClass("FightGuidePointerManager")

function FightGuidePointerManager:__init(clientFight)
	self.clientFight = clientFight

	self.guidePointer = {}
	self.uniqueIndex = 0

	self.guideEcoPointer = {}
	self.cachePotnter = {} --临时缓存的追踪点

	self.ScreenWidth = UIDefine.canvasRoot.rect.width
	self.ScreenHeight = UIDefine.canvasRoot.rect.height

	-- 拿来存数据的 省点内存是省点吧
	self.navGuideTemp = {}
	self.navGuideResult = {}
	-- posArray = {}
	self.navGuideCheckList = {}

	self.navGuideList = {}
	self.navGuideIndex = 0
end

function FightGuidePointerManager:StartFight()
	EventMgr.Instance:AddListener(EventName.SetCurEntity, self:ToFunc("UpdateCurPlayer"))
	EventMgr.Instance:AddListener(EventName.PlayerUpdate, self:ToFunc("UpdateCtrlEntity"))
	EventMgr.Instance:AddListener(EventName.UpdateEntityGuidePos, self:ToFunc("UpdateEntityGuide"))
	EventMgr.Instance:AddListener(EventName.EnterTaskTimeArea, self:ToFunc("EnterTaskTimeArea"))
end

function FightGuidePointerManager:__delete()
	for k, v in pairs(self.guidePointer) do
		self:RemoveGuide(k)
	end
	self:RemoveNavGuide()
	self.guidePointer = {}

	EventMgr.Instance:RemoveListener(EventName.SetCurEntity, self:ToFunc("UpdateCurPlayer"))
	EventMgr.Instance:RemoveListener(EventName.PlayerUpdate, self:ToFunc("UpdateCtrlEntity"))
	EventMgr.Instance:RemoveListener(EventName.UpdateEntityGuidePos, self:ToFunc("UpdateEntityGuide"))
	EventMgr.Instance:RemoveListener(EventName.EnterTaskTimeArea, self:ToFunc("EnterTaskTimeArea"))
end

function FightGuidePointerManager:UpdateCurPlayer(entity)
	self.curEntity = entity
end

function FightGuidePointerManager:GetUniqueIndex()
	local index = self.uniqueIndex
	self.uniqueIndex = self.uniqueIndex + 1
	return index
end

function FightGuidePointerManager:AddGuideEntity(entity, setting, guideType, taskId)
	if not entity or not entity.transformComponent then
		return
	end

	local position = entity.transformComponent:GetPosition()
	local extraSetting = { entityInstance = entity.instanceId, guideType = guideType, taskId = taskId }
	local index = self:AddGuidePosition(position, setting, extraSetting)

	entity.transformComponent:AddGuidePointer(index)

	return index
end

function FightGuidePointerManager:AddGuideEcoEntity(ecoId, setting, guideType, taskId)
	local ecoCfg = Fight.Instance.entityManager:GetEntityConfigByID(ecoId)
	if not ecoCfg or not next(ecoCfg) then
		return
	end

	local isNpc = Fight.Instance.entityManager.npcEntityManager:CheckEcoIdIsNpc(ecoId)
	local entity
	if isNpc then
		entity = BehaviorFunctions.GetNpcEntity(ecoId)
	else
		local instanceId = BehaviorFunctions.GetEcoEntityByEcoId(ecoId)
		if instanceId then
			entity = BehaviorFunctions.GetEntity(instanceId)
		end
	end

	local position
	if not entity then
		position = BehaviorFunctions.GetEcoEntityPosition(ecoId)
	else
		position = entity.transformComponent:GetPosition()
	end

	if not position then
		return
	end

	local extraSetting = { ecoId = ecoId, guideType = guideType, taskId = taskId }
	local index = self:AddGuidePosition(position, setting, extraSetting)

	self.guideEcoPointer[ecoId] = index

	return index
end

function FightGuidePointerManager:AddGuidePosition(pos, setting, extraSetting)
	if not pos then
		return
	end

	local index = self:GetUniqueIndex()
	self.guidePointer[index] = {pos = pos, showType = FightEnum.PointerShowType.Hide, setting = setting}--将实体位置存储起来

	if extraSetting and next(extraSetting) then
		for k, v in pairs(extraSetting) do
			self.guidePointer[index][k] = v
		end
	end

	if extraSetting.guideType == FightEnum.GuideType.Task then
		local inTimeArea = Fight.Instance.taskManager:IsInTimeArea(extraSetting.taskId)
		if not inTimeArea then
			self:CacheGuide(index, true)
			return index
		end
	end

	EventMgr.Instance:Fire(EventName.AddGuidePointer, index)
	return index
end

function FightGuidePointerManager:AddGuidePositionWithNav(pos, setting, extraSetting, checkPoints, diff)
	if not checkPoints or not next(checkPoints) then
		return
	end

	self.navGuideIndex = self.navGuideIndex + 1
	self.navGuideList[self.navGuideIndex] = { pos = pos, setting = setting, extraSetting = extraSetting, checkPoints = checkPoints, diff = diff }
	-- self.navGuidePos = pos
	-- self.navGuide = { pos = pos, setting = setting, extraSetting = extraSetting, checkPoints = checkPoints, diff = diff }

	-- 如果需要画线就画线
	if setting.needMark then
		self.navGuideList[self.navGuideIndex].navMark = Fight.Instance.mapNavPathManager:_DrawGuideEffect(2,pos, 0, FightEnum.NavDrawColor.Default)
	end

	return self.navGuideIndex
end

function FightGuidePointerManager:EnterTaskTimeArea(inArea, taskId)
	if inArea then
		for k, v in pairs(self.cachePotnter) do
			if v.guideType == FightEnum.GuideType.Task then
				if v.taskId == taskId then
					self:PopGuide(k)
				end
			end
		end
	else
		for k, v in pairs(self.guidePointer) do
			if v.guideType == FightEnum.GuideType.Task then
				if v.taskId == taskId then
					self:CacheGuide(k)
				end
			end
		end
	end
end

function FightGuidePointerManager:PopGuide(index)
	if self.cachePotnter[index] then
		self.guidePointer[index] = self.cachePotnter[index]
		self.cachePotnter[index] = nil
		EventMgr.Instance:Fire(EventName.AddGuidePointer, index)
	end
end

function FightGuidePointerManager:CacheGuide(index, onlyData)
	if self.guidePointer[index] then
		local data = self.guidePointer[index]
		if not onlyData then
			self:RemoveGuide(index)
		end
		self.cachePotnter[index] = data
		self.guidePointer[index] = nil
	end
end

function FightGuidePointerManager:RemoveGuide(index)
	if self.cachePotnter[index] then
		self.cachePotnter[index] = nil
		return
	end
	if not self.guidePointer or not self.guidePointer[index] then
		return
	end

	if self.guidePointer[index].entityInstance then
		local entity = Fight.Instance.entityManager:GetEntity(self.guidePointer[index].entityInstance)
		if entity and entity.transformComponent then
			entity.transformComponent:RemoveGuidePointer(index)
		end
	end

	if self.guidePointer[index].ecoId then
		self.guideEcoPointer[self.guidePointer[index].ecoId] = nil
	end

	EventMgr.Instance:Fire(EventName.RemoveGuidePointer, index)
	self.guidePointer[index] = nil
end

function FightGuidePointerManager:RemoveNavGuide(index)
	if not self.navGuideList[index] then
		return
	end

	local navGuide = self.navGuideList[index]
	self:RemoveGuide(navGuide.guide)
	if navGuide.navMark then
		Fight.Instance.mapNavPathManager:_RemoveGuideEffect(navGuide.navMark)
	end

	self.navGuideList[index] = nil
	-- self:RemoveGuide(self.navGuideIndex)
	-- if index == self.navGuideIndex then
	-- 	self.navGuidePos = nil
	-- 	self.navGuideIndex = nil
	-- 	self.navGuide = nil

	-- 	if self.navMark then
	-- 		Fight.Instance.mapNavPathManager:_RemoveGuideEffect(self.navMark)
	-- 		self.navMark = nil
	-- 	end
	-- end
end

function FightGuidePointerManager:UpdateEntityGuide(index, x, y, z, showType)
	if not self.guidePointer[index] then
		return
	end

	if x and y and z then
		local position = Vec3.New(x, y, z)
		self:UpdatePositionGuide(index, position)
	end

	if showType then
		self.guidePointer[index].showType = showType
	end
end

function FightGuidePointerManager:UpdateEcoGuide(index, ecoId)
	local ecoCfg = Fight.Instance.entityManager:GetEntityConfigByID(ecoId)
	if not ecoCfg or not next(ecoCfg) then
		return
	end

	local isNpc = Fight.Instance.entityManager.npcEntityManager:CheckEcoIdIsNpc(ecoId)
	
	local entity
	if isNpc then
		entity = BehaviorFunctions.GetNpcEntity(ecoId)
	else	
		local instanceId = BehaviorFunctions.GetEcoEntityByEcoId(ecoId)
		if instanceId then
			entity = BehaviorFunctions.GetEntity(instanceId)
		end
	end

	local position
	if not entity or not entity.transformComponent then
		position = BehaviorFunctions.GetEcoEntityPosition(ecoId)
	else
		local markCaseTransform = entity.clientTransformComponent:GetTransform("MarkCase")
		local hitCaseTransform = entity.clientTransformComponent:GetTransform("HitCase")
		BehaviorFunctions.fight.clientFight.headInfoManager:HideCharacterHeadTips(entity.instanceId)
		if markCaseTransform  and markCaseTransform.position then
			position = markCaseTransform.position
		elseif hitCaseTransform and hitCaseTransform.position then
			position = hitCaseTransform.position
		else
			position = entity.transformComponent:GetPosition()
		end
	end

	if not position then
		return
	end

	self:UpdatePositionGuide(index, position)
end

function FightGuidePointerManager:UpdatePositionGuide(index, position)
	if not self.guidePointer[index] then
		return
	end

	-- local position = Vec3.New(x, y, z)
	self.guidePointer[index].pos = position
end

function FightGuidePointerManager:GetPointer(index)
	if not self.guidePointer or not next(self.guidePointer) then
		return
	end

	return self.guidePointer[index]
end

function FightGuidePointerManager:GetPointerPos(index)
	return self.guidePointer[index].pos
end

function FightGuidePointerManager:GetNavGuideIndex()
	return self.navGuideIndex
end

function FightGuidePointerManager:Update()
	if not self.curEntity then
		self:UpdateCtrlEntity()
	end

	for k, v in pairs(self.guideEcoPointer) do
		self:UpdateEcoGuide(v, k)
	end
end

function FightGuidePointerManager:LowUpdate()
	if not self.navGuideList or not next(self.navGuideList) then
		return
	end

	for k, v in pairs(self.navGuideList) do
		local guidePos = self:CalcNavGuidePoint(v.pos, v.checkPoints, v.diff)
		if v.guidePos and Vec3.Distance(guidePos, v.guidePos) <= 1 then
			goto continue
		end

		v.guidePos = guidePos
		if v.pointerIndex then
			self:RemoveGuide(v.pointerIndex)
		end
		v.pointerIndex = self:AddGuidePosition(v.guidePos, v.setting, v.extraSetting)

		::continue::
	end
	-- if not self.navGuide or not next(self.navGuide) then
	-- 	return
	-- end

	-- local guidePos = self:CalcNavGuidePoint()
	-- if Vec3.SquareDistance(guidePos, self.navGuidePos) <= 1 then
	-- 	return
	-- end

	-- self.navGuidePos = guidePos
	-- self:RemoveGuide(self.navGuideIndex)
	-- self.navGuideIndex = self:AddGuidePosition(guidePos, self.navGuide.setting, self.navGuide.extraSetting)
end

-- TODO 性能优化点
function FightGuidePointerManager:CalcNavGuidePoint(pos, checkPoints, diff)
	local selfPos = self.curEntity.transformComponent.position
	-- local count = 0
	local posArray, count = CustomUnityUtils.NavCalculatePath(selfPos, pos, 1)
	if count == 0 then
		return pos
	end

	local lastPos = posArray[count - 1]
	if Vec3.SquareDistance(lastPos, pos) > 1 then
		return pos
	end

	for i = 0, count - 1 do
		if self.navGuideTemp[i + 1] then
			self.navGuideTemp[i + 1]:Set(posArray[i].x, posArray[i].y, posArray[i].z)
		else
			table.insert(self.navGuideTemp, Vec3.New(posArray[i].x, posArray[i].y, posArray[i].z))
		end
	end

	for i = #self.navGuideTemp, count, -1 do
		table.remove(self.navGuideTemp, i)
	end

	self.navGuideResult = {}
	local finish = false
	-- 还是做个保护 限制最大循环层数
	local protect = 100
	local comp = Vec3.New(0, 0, 0)
	while not finish do
		protect = protect - 1
		if protect <= 0 then
			finish = true
		end

		for i = 1, #self.navGuideTemp - 1 do
			table.insert(self.navGuideResult, self.navGuideTemp[i]:Clone())
			local dis = Vec3.SquareDistance(self.navGuideTemp[i], self.navGuideTemp[i + 1])
			if dis < 1 and i ~= #self.navGuideTemp - 1 and Vec3.SquareDistance(self.navGuideTemp[i], pos) > 1 then
				-- 遇到连接点了 要换新的地块的寻路列表
				posArray, count = CustomUnityUtils.NavCalculatePath(self.navGuideTemp[i + 1], pos, 1)
				comp = count > 0 and comp:Set(posArray[0].x, posArray[0].y, posArray[0].z) or comp
				-- navmesh的寻路，好像第一个点 有可能不是起点 但是之后会路过起点 所以会出问题 得记录一下做个比较 避免死循环
				if count > 0 and not comp:Equals(self.navGuideTemp[1]) then
					for j = 0, count - 1 do
						if self.navGuideTemp[j + 1] then
							self.navGuideTemp[j + 1]:Set(posArray[j].x, posArray[j].y, posArray[j].z)
						else
							table.insert(self.navGuideTemp, Vec3.New(posArray[j].x, posArray[j].y, posArray[j].z))
						end
					end

					for j = #self.navGuideTemp, count, -1 do
						table.remove(self.navGuideTemp, j)
					end
					break
				end
			end

			if i == #self.navGuideTemp - 1 then
				table.insert(self.navGuideResult, self.navGuideTemp[i + 1]:Clone())
				finish = true
			end
		end

		-- 如果只有一个寻路点了 那还费什么事呢
		if #self.navGuideTemp <= 1 then
			if #self.navGuideTemp == 1 then
				table.insert(self.navGuideResult, self.navGuideTemp[1]:Clone())
			end
			finish = true
		end
	end

	local diff = diff or 2
	for i = 1, #self.navGuideResult - 1 do
		local dir = Vec3.Normalize(self.navGuideResult[i + 1] - self.navGuideResult[i])
		local up = Vec3.Normalize(Vec3.Cross(dir, dir + Vec3.left))
		local left = Vec3.Normalize(Vec3.Cross(dir, up))

		-- 求出八个顶点 算出边界值
		local temp
		local minX, maxX, minY, maxY, minZ, maxZ
		for j = 1, 8 do
			temp = (j <= 4 and self.navGuideResult[i] or self.navGuideResult[i + 1]) + left * (j / 2 > 1 and 1 or -1) * diff + up * (j % 2 == 0 and 1 or -1) * diff
			maxX = maxX and math.max(maxX, temp.x) or temp.x
			minX = minX and math.min(minX, temp.x) or temp.x
			maxY = maxY and math.max(maxY, temp.y) or temp.y
			minY = minY and math.min(minY, temp.y) or temp.y
			maxZ = maxZ and math.max(maxZ, temp.z) or temp.z
			minZ = minZ and math.min(minZ, temp.z) or temp.z
		end

		-- 检查点是否在立方体内
		local checkPos
		self.navGuideCheckList = {}
		for j = 1, #checkPoints do
			checkPos = checkPoints[j]
			if checkPos.x >= minX and checkPos.x <= maxX and checkPos.y >= minY and checkPos.y <= maxY and checkPos.z >= minZ and checkPos.z <= maxZ then
				table.insert(self.navGuideCheckList, checkPos)
			end
		end

		-- 如果有多个点在立方体内，就拿离角色最近的那个点
		if #self.navGuideCheckList > 0 then
			if #self.navGuideCheckList == 1 then
				return self.navGuideCheckList[1]
			else
				local min
				local index = 0
				for j = 1, #self.navGuideCheckList do
					local dis = Vec3.SquareDistance(selfPos, self.navGuideCheckList[i])
					min = min and math.min(min, dis) or dis
					if min == dis then
						index = j
					end
				end

				return self.navGuideCheckList[index]
			end
		end
	end

	return pos
end

function FightGuidePointerManager:UpdateCtrlEntity()
	self.curEntity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
end

function FightGuidePointerManager:InScreen(sp)
	return math.abs(sp.x) <= self.ScreenWidth * 0.5 and math.abs(sp.y) <= self.ScreenHeight * 0.5 and sp.z > 0 --判断是否在屏幕内部
end

--720转1080p分辨率 *1.5
local CycleWidth = 420 * 1.5
local CycleHeight = 225 * 1.5
local guideYTip = 2
function FightGuidePointerManager:CalaPointerPos(index, guideType)
	local setting = self.guidePointer[index]
	local offsetY = (setting and setting.setting) and setting.setting.offsetY or 0
	local radius = (setting and setting.setting) and setting.setting.radius or setting.radius or 0
	local pos = TableUtils.CopyTable(self.guidePointer[index].pos)
	if offsetY then
		pos.y = pos.y + offsetY
	end

	local hideOnSee = self.guidePointer[index].setting and self.guidePointer[index].setting.hideOnSee or false
	local sp = UtilsBase.WorldToUIPointBase(pos.x,pos.y,pos.z)
	
	if hideOnSee then
		if self:InScreen(sp) then
			return FightEnum.PointerShowType.Hide
		elseif guideType == FightEnum.GuideType.FightTarget then
			local entity = Fight.Instance.entityManager:GetEntity(setting.entityInstance)
			local markCaseTransform = entity.clientTransformComponent:GetTransform("MarkCase")
			local hitCaseTransform = entity.clientTransformComponent:GetTransform("HitCase")
			local markInScreen, hitInScreen = true, true
			
			if not UtilsBase.IsNull(markCaseTransform) then
				local markPos = markCaseTransform.position
				markInScreen = self:InScreen(UtilsBase.WorldToUIPointBase(markPos.x,markPos.y,markPos.z))
			end
			
			if not UtilsBase.IsNull(hitCaseTransform) then
				local hitPos = hitCaseTransform.position
				hitInScreen = self:InScreen(UtilsBase.WorldToUIPointBase(hitPos.x,hitPos.y,hitPos.z))
			end
			
			if hitInScreen and markInScreen then
				return FightEnum.PointerShowType.Hide
			end
		end
	end
	local showType = FightEnum.PointerShowType.Show
	local spX = sp.x
	local spY = sp.y
	local showDistance = self:InScreen(sp)

	if sp.z < 0 then
		spX = -spX
		spY = -spY
		if spX >= -CycleWidth and spX <= CycleWidth then
			spY = spY > 0 and CycleHeight or -CycleHeight
		end
	end

	local spXPercent = spX / CycleWidth
	local spYPercent = spY / CycleHeight
	local poinyIngRange = math.sqrt(spXPercent * spXPercent + spYPercent * spYPercent)
	if poinyIngRange > 1 then
		spX = spX / poinyIngRange
		spY = spY / poinyIngRange
	end

	if sp.x == spX and sp.y == spY then
		showType = FightEnum.PointerShowType.ShowAndHideArrow
	end
	sp.x = spX
	sp.y = spY

	local selfPos = self.curEntity.transformComponent.position
	local distance = math.floor(Vec3.Distance(pos, selfPos))
	local disDesc = distance.."m"
	if distance >= radius then
		if pos.y - selfPos.y > guideYTip then
			disDesc = string.format(TI18N("高处 %s"), disDesc)
		elseif pos.y - selfPos.y < -guideYTip then
			disDesc = string.format(TI18N("低处 %s"), disDesc)
		end
	elseif radius ~= 0 then
		if setting.guideType and setting.guideType == FightEnum.GuideType.Task then
			disDesc = TI18N("已在任务区域内")
		end
		showType = FightEnum.PointerShowType.Hide
	end

	return showType, sp, showDistance, disDesc
end

function FightGuidePointerManager:GetPointerIcon(index)
	local guidePointer = self.guidePointer[index]
	if not guidePointer then
		return
	end

	if guidePointer.guideType == FightEnum.GuideType.Task then
		-- local taskConfig = mod.TaskCtrl:GetTaskConfig(guidePointer.taskId)
		local taskType = mod.TaskCtrl:GetTaskType(guidePointer.taskId)
		-- return AssetConfig.GetTaskTypeIcon(taskConfig.type)
		if not taskType then
			taskType = 1
		end
		return AssetConfig.GetTaskTypeIcon(taskType)
	elseif guidePointer.guideType == FightEnum.GuideType.FightTarget then
		return
	elseif guidePointer.guideType == FightEnum.GuideType.SummonCar then
		return
	elseif guidePointer.guideType == FightEnum.GuideType.Custom then
		return guidePointer.guideIcon
	end
	return SystemConfig.GetIconConfig("guide_"..guidePointer.guideType).icon1
end

function FightGuidePointerManager:CheckPointerAttackAlarm(index, instanceId)
	local guidePointer = self.guidePointer[index]
	if not guidePointer then
		return false
	end
	
	return instanceId == self.guidePointer[index].entityInstance
end

function FightGuidePointerManager:GetAllPointerKey()
	local keys = {}
	for index, value in pairs(self.guidePointer) do
		table.insert(keys, index)
	end
	return keys
end