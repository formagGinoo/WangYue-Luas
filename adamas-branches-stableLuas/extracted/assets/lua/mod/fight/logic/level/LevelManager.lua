
---@class LevelManager
LevelManager = BaseClass("LevelManager")
local DataDuplicateLevel = Config.DataDuplicate.data_duplicate_level
local DataLevelOccupancy = Config.LevelOccupancyData --关卡点位数据
local DataLevelGroup = Config.LevelGroupData --关卡组id数据

function LevelManager:__init(fight)
	self.fight = fight
	self.levelMap = {}
	-- 关卡会绑定任务
	self.levelBindTask = {}
	self.removeList = {}
	self.assetsNodeManager = self.fight.clientFight.assetsNodeManager
	self.levelOccupancyList = {} --区域占用id列表
	self.curLevelOccupancyId = nil

	self.waitCreateList = {}

	self.mapAreaOnShow = {}
	self.enemyOnShow = {}

	self:BindListener()
end

function LevelManager:BindListener()
	EventMgr.Instance:AddListener(EventName.TaskFinish, self:ToFunc("OnTaskChange"))
	EventMgr.Instance:AddListener(EventName.TaskOccupy, self:ToFunc("OnTaskChange"))
	EventMgr.Instance:AddListener(EventName.LevelInstructionComplete, self:ToFunc("LevelInstructionComplete"))
end

function LevelManager:RemoveListener()
	EventMgr.Instance:RemoveListener(EventName.TaskFinish, self:ToFunc("OnTaskChange"))
	EventMgr.Instance:RemoveListener(EventName.TaskOccupy, self:ToFunc("OnTaskChange"))
	EventMgr.Instance:RemoveListener(EventName.LevelInstructionComplete, self:ToFunc("LevelInstructionComplete"))
end

function LevelManager:LogicUpdate()
	for k, v in pairs(self.removeList) do
		if self.assetsNodeManager:CheckGetingCount(k) == 0 then
			self.removeList[k] = nil
			self:RemoveLevel(k)
		end
	end

	for k, v in pairs(self.levelMap) do
		if v.levelBehavior then
			v.levelBehavior:Update()
		end
	end
end

function LevelManager:CallBehaviorFun(funName, ...)
	for k, v in pairs(self.levelMap) do
		local levelBehavior = v.levelBehavior
		if not levelBehavior then
			goto continue
		end

		if levelBehavior[funName] then
			levelBehavior[funName](levelBehavior, ...)
		end
		levelBehavior:CallFunc(funName, ...)

		::continue::
	end
end

function LevelManager:StartFight(levelId)
	if levelId and levelId > 0 then
		self.defaultLevelId = levelId
		self:CreateLevel(levelId)
	end

	local duplicateId, dupLevelId = mod.WorldMapCtrl:GetDuplicateInfo()
	if dupLevelId then
		self:CreateLevel(dupLevelId)
	end
end

function LevelManager:CheckLevelOccupy(levelId)
	--获取目前关卡对应的关卡组数据
	local levelGroupList = DataLevelGroup[levelId]
	if not levelGroupList or not next(levelGroupList) then
		--没有重叠的不用管
		return true
	end
	
	local isCanCreate = true

	local mapId = Fight.Instance:GetFightMap()
	local levelPointDataList = DataLevelOccupancy[mapId]

	--获取人物目前的点位信息
	local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	local pos = entity.transformComponent:GetPosition()
	
	local InAreaLevelId
	--再判断该level组
	for i, id in pairs(levelGroupList) do
		if self.levelMap[id] then
			local levelPointData = levelPointDataList[id]
			if BehaviorFunctions.IsPointInsidePolygon(pos, levelPointData) then
				InAreaLevelId = id
			end
		end
	end
	
	--当前需要创建的关卡和已经占用的关卡进行对比，返回是否能创建
	local curType = DataDuplicateLevel[levelId].type
	if InAreaLevelId then
		local inAreaType = DataDuplicateLevel[InAreaLevelId].type
		--当前优先级的值大于或者等于已经占用的优先级，则不能创建
		if curType >= inAreaType then
			isCanCreate = false
		end
	end
	
	return isCanCreate, InAreaLevelId
end

--@ 区域占用，总而言之就是处理重叠情况下到底创建谁的问题
----这里的逻辑是为了处理动态的过程，必须要同时满足 需要创建又重叠的情况
function LevelManager:CreateLevelByOccupancyData(levelId)
	
	local result, InAreaLevelId = self:CheckLevelOccupy(levelId)

	--说明有区域占用
	if InAreaLevelId then
		--判断优先级，同级则提示
		--大于当前优先级则remove
		local curType = DataDuplicateLevel[levelId].type
		local inAreaType = DataDuplicateLevel[InAreaLevelId].type

		if curType < inAreaType then
			self:RemoveLevel(InAreaLevelId)
		end
		if curType == FightEnum.LevelType.EntityType then
			--提示 
			EventMgr.Instance:Fire(EventName.ShowLevelOccupancyTips, {isShow = true, display = true})
		end
	end

	if result then
		return levelId
	else
		if not self.levelOccupancyList[InAreaLevelId] then
			self.levelOccupancyList[InAreaLevelId] = {}
		end
		if not self.levelOccupancyList[InAreaLevelId][levelId] then
			self.fight.entityManager:CallBehaviorFun("CreateLevelOccupancyFail", levelId)
			--把占用id添加到占用列表中
			self.levelOccupancyList[InAreaLevelId][levelId] = true
		end
	end
end

function LevelManager:CreateLevel(levelId, taskId, preload, params, loadCallback)
	--创建关卡时增加区域占用规则的判定
	local realLevelId = self:CreateLevelByOccupancyData(levelId)
	if not realLevelId then
		return
	end
	if self.levelMap[realLevelId] or self.waitCreateList[realLevelId] then
		return
	end

	self.waitCreateList[realLevelId] = true
	local callBack = function ()
		local blackCurtain = self:_CreateLevel(realLevelId, taskId, params)
		if blackCurtain then
			CurtainManager.Instance:FadeOut(0.8)
		end
		if loadCallback then
			loadCallback()
		end
	end
	
	-- if not CurtainManager.Instance then
	-- 	--CurtainManager.New()
	-- end

	local blackCurtain, blackTime
	if not preload then
		blackCurtain, blackTime = self.assetsNodeManager:LoadLevel(realLevelId, callBack)
	end
	if blackCurtain then
		CurtainManager.Instance:FadeIn(true, blackTime)
	end
	if preload then
		callBack()
	end

	self.fight.mapAreaManager:AddLevelArea(levelId)
end

function LevelManager:_CreateLevel(levelId, taskId, params)
	--if not self.assetsPoolMgr.poolParent then
		--return
	--end
	params = params or {}
	if not self.defaultLevelId then
		self.defaultLevelId = levelId
	end

	if not self.fight.clientFight.clientMap.transform then
		return
	end

	local levelConfig = DataDuplicateLevel[levelId]

	local logicObject 
	local sceneObjectsCmp
	if levelConfig.scene_logic ~= "" then
		local logicPath = "Prefabs/Scene/"..levelConfig.scene_logic
		logicObject = self.fight.clientFight.assetsPool:Get(logicPath)
		logicObject.name = string.gsub(logicObject.name, "[(]Clone[)]", "")
		logicObject.transform:SetParent(self.fight.clientFight.clientMap.transform)
		local transform = logicObject.transform
		transform:ResetAttr()
		sceneObjectsCmp = logicObject:GetComponent(SceneObjects)
		if not UtilsBase.IsNull(sceneObjectsCmp) then
			sceneObjectsCmp:Init()
		end
	end

	local levelBehavior
	local levelBehaviorClass = _G[levelConfig.behavior]
	local blackCurtain,blackTime = false, 0
	if levelBehaviorClass then
		params.levelId = levelId
		params.taskId = taskId
		levelBehavior = self:InitLevelBehaviorData(levelBehaviorClass, params)
		if levelBehavior.NeedBlackCurtain then
			blackCurtain, blackTime = levelBehavior.NeedBlackCurtain()
		end
	end

	local levelInfo = {
		levelId = levelId,
		logicObject = logicObject,
		levelBehavior = levelBehavior,
		sceneObjectsCmp = sceneObjectsCmp,
	}

	self.levelMap[levelId] = levelInfo
	self.waitCreateList[levelId] = nil

	local task = mod.TaskCtrl:GetTask(taskId)
	if task then
		if not self.levelBindTask[taskId] then
			self.levelBindTask[taskId] = {}
		end

		self.levelBindTask[taskId][task.stepId] = levelId
	end

	return blackCurtain, blackTime or 0.2
end

function LevelManager:InitLevelBehaviorData(levelBehaviorClass, params)
	local levelBehavior = levelBehaviorClass.New(self.fight)
	levelBehavior.levelId = params.levelId
	levelBehavior.taskId = params.taskId
	levelBehavior.rogueEventId = params.rogueEventId
	levelBehavior:Init()
	if levelBehavior.LateInit then
		levelBehavior:LateInit()
	end
	return levelBehavior
end

function LevelManager:ResetLevel(levelId)
	local levelInfo = self.levelMap[levelId]
	if not levelInfo then
		return
	end

	--根据策划要求先进黑幕
	if levelInfo.levelBehavior.NeedBlackCurtain then
		local blackCurtain, blackTime = levelInfo.levelBehavior.NeedBlackCurtain()
		-- if not CurtainManager.Instance then
		-- 	--CurtainManager.New()
		-- end
		if blackCurtain then
			CurtainManager.Instance:FadeIn(true, blackTime)
			self:StopCurtainTimer()
			self.curtainTimer = LuaTimerManager.Instance:AddTimer(1, 0.3, function()
				CurtainManager.Instance:FadeOut(1)
			end)
		end
	end

	--卸载掉关卡所属的entity
	self.fight.entityManager:RemoveLevelEntity(levelId)
	levelInfo.levelBehavior:DeleteMe()
	levelInfo.levelBehavior = nil

	local levelConfig = DataDuplicateLevel[levelId]
	local levelBehaviorClass = _G[levelConfig.behavior]
	levelInfo.levelBehavior = levelBehaviorClass.New(self.fight)
	levelInfo.levelBehavior.levelId = levelId

	if levelInfo.levelBehavior then
		levelInfo.levelBehavior:Init()
	end
	
	self.levelMap[levelId] = levelInfo
end

function LevelManager:StopCurtainTimer()
	if self.curtainTimer then
		LuaTimerManager.Instance:RemoveTimer(self.curtainTimer)
		self.curtainTimer = nil
	end
end

-- 看看后面需不需要再添加什么操作 目前就只是作为任务完成条件的判断而已
function LevelManager:FinishLevel(levelId)
	EventMgr.Instance:Fire(EventName.FinishLevel, levelId)
	self.fight.entityManager:CallBehaviorFun("FinishLevel", levelId)
	self:RemoveLevel(levelId)
end

function LevelManager:RemoveLevel(levelId)
	local levelConfig = DataDuplicateLevel[levelId]
	local levelInfo = self.levelMap[levelId]
	if not levelInfo then
		return
	end
	self:RemoveLevelOccupancy(levelId)

	if self.defaultLevelId and self.defaultLevelId == levelId then
		self.defaultLevelId = nil
	end

	local logicPath = "Prefabs/Scene/"..levelConfig.scene_logic
	self.fight.clientFight.assetsPool:Cache(logicPath, levelInfo.logicObject)

	self.levelMap[levelId].levelBehavior:Remove()
	self.levelMap[levelId] = nil

	self.fight.entityManager:RemoveLevelEntity(levelId)
	self.assetsNodeManager:UnLoadLevel(levelId)

	self:ShowMapArea(levelId, false)
	self:ShowLevelEnemyOnMap(levelId, false)
	self.fight.mapAreaManager:RemoveLevelArea(levelId)

	self.fight.entityManager:CallBehaviorFun("RemoveLevel", levelId)
	EventMgr.Instance:Fire(EventName.RemoveLevel, levelId)
end

function LevelManager:RemoveAllLevel()
	for k, v in pairs(self.levelMap) do
		self:RemoveLevel(k)
	end
end

function LevelManager:RemoveLevelOccupancy(levelId)
	--这里移除区域占用的id
	self.levelOccupancyList[levelId] = nil
	 
end

-- 如果任务占用改了 或者任务完成了 和任务绑定的关卡要卸载掉
function LevelManager:OnTaskChange(taskId, stepId)
	if not self.levelBindTask[taskId] or not self.levelBindTask[taskId][stepId] then
		return
	end

	self:RemoveLevel(self.levelBindTask[taskId][stepId])
end

function LevelManager:LevelInstructionComplete(tipId)
	self.fight.entityManager:CallBehaviorFun("LevelInstructionComplete", tipId)
end

function LevelManager:GetLevelInfo(levelId)
	levelId = levelId or self.defaultLevelId
	return self.levelMap[levelId]
end

function LevelManager:GetSceneObject(objName, levelId)
	local levelInfo = self:GetLevelInfo(levelId)
	if not levelInfo.sceneObjectsCmp then
		return
	end

	return levelInfo.sceneObjectsCmp:GetObject(objName)
end

function LevelManager:SetSceneSpeed(speed)
	for k, v in pairs(self.levelMap) do
		if v.sceneObjectsCmp then
			v.sceneObjectsCmp:SetSceneSpeed(speed)
		end
	end
end

function LevelManager:CheckLevelIsCreateOrCreating(levelId)
	return self.waitCreateList[levelId] or self.levelMap[levelId]
end

function LevelManager:GetCurLevelOccupancyId()
	return self.curLevelOccupancyId
end

function LevelManager:__delete()
	self:RemoveListener()
	self:StopCurtainTimer()
	if self.levelMap then
		for k, v in pairs(self.levelMap) do
			if v.levelBehavior then
				v.levelBehavior:DeleteMe()
			end
		end

		self.levelMap = nil
		self.levelManager = nil
	end

	TableUtils.ClearTable(self.levelBindTask)
	self.removeList = {}
	self.waitCreateList = {}
	self.levelOccupancyList = {}
	self.curLevelOccupancyId = nil
end

function LevelManager:GMChangeBehaviorMonsterId(newId)
	local curMapId, levelId = mod.WorldMapCtrl:GetDuplicateInfo()
	-- print("curMapId = ", curMapId, levId)
	local levMapInfo = self.levelMap[levelId]
	if not levMapInfo then return end
	local levBehavior = levMapInfo.levelBehavior
	if levBehavior.GMSetMonsterId then
		levBehavior:GMSetMonsterId(newId)
	end
end

function LevelManager:ShowMapArea(levelId, isShow)
	if (not self.mapAreaOnShow[levelId]) ~= isShow or not self:GetLevelOccupancyData(levelId) then
		return
	end

	self.mapAreaOnShow[levelId] = isShow
	EventMgr.Instance:Fire(EventName.ShowLevelOnMap, levelId, isShow)
end

function LevelManager:GetLevelOccupancyData(levelId)
	local mapId = Fight.Instance:GetFightMap()
	local levelPointDataList = DataLevelOccupancy[mapId]
	if not levelPointDataList then
		return
	end

	return TableUtils.CopyTable(levelPointDataList[levelId])
end

function LevelManager:GetMapAreaOnShow()
	return self.mapAreaOnShow
end

function LevelManager:ShowLevelEnemyOnMap(levelId, isShow)
	if (not self.enemyOnShow[levelId]) ~= isShow then
		return
	end

	self.enemyOnShow[levelId] = isShow
	self.fight.entityManager:ShowLevelEnemyOnMap(levelId, isShow)
end

function LevelManager:GetEnemyOnMap()
	return self.enemyOnShow
end

function LevelManager:GetDuplicateCfg(levelId)
	return DataDuplicateLevel[levelId]
end