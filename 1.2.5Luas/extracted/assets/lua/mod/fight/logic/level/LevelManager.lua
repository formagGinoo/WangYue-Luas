
---@class LevelManager
LevelManager = BaseClass("LevelManager")
local DataDuplicateLevel = Config.DataDuplicate.data_duplicate_level

function LevelManager:__init(fight)
	self.fight = fight
	self.levelMap = {}
	self.levelList = {}
	self.removeList = {}
	self.assetsNodeManager = self.fight.clientFight.assetsNodeManager

	self.waitCreateList = {}
end

function LevelManager:LogicUpdate()
	for k, v in pairs(self.removeList) do
		if self.assetsNodeManager:CheckGetingCount(k) == 0 then
			self.removeList[k] = nil
			self:RemoveLevel(k)
		end
	end

	for k, v in ipairs(self.levelList) do
		if v.levelBehavior then
			v.levelBehavior:Update()
		end
	end
end

function LevelManager:CallBehaviorFun(funName, ...)
	for k, v in ipairs(self.levelList) do
		local levelBehavior = v.levelBehavior
		if levelBehavior then
			levelBehavior.SuperFunc(levelBehavior,funName,true,...)
		end
	end
end

function LevelManager:StartFight(levelId)
	if levelId > 0 then
		self.defaultLevelId = levelId
		self:CreateLevel(levelId)
	end

	local duplicateId, dupLevelId = mod.WorldMapCtrl:GetDuplicateInfo()
	if dupLevelId then
		self:CreateLevel(dupLevelId)
	end
end


function LevelManager:CreateLevel(levelId, taskId, preload)
	if self.levelMap[levelId] or self.waitCreateList[levelId] then
		return
	end

	self.waitCreateList[levelId] = true
	local callBack = function ()
		local blackCurtain = self:_CreateLevel(levelId, taskId)
		if blackCurtain then
			CurtainManager.Instance:FadeOut(0.8)
		end
	end
	
	if not CurtainManager.Instance then
		CurtainManager.New()
	end

	local blackCurtain, blackTime
	if not preload then
		blackCurtain, blackTime = self.assetsNodeManager:LoadLevel(levelId, callBack)
	end
	if blackCurtain then
		CurtainManager.Instance:FadeIn(true, blackTime)
	end
	if preload then
		callBack()
	end
end

function LevelManager:_CreateLevel(levelId, taskId)
	--if not self.assetsPoolMgr.poolParent then
		--return
	--end

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
		if sceneObjectsCmp then
			sceneObjectsCmp:Init()
		end
	end

	local levelBehavior
	local levelBehaviorClass = _G[levelConfig.behavior]
	local blackCurtain,blackTime = false, 0
	if levelBehaviorClass then
		levelBehavior = levelBehaviorClass.New(self.fight)
		levelBehavior.levelId = levelId
		levelBehavior.taskId = taskId
		levelBehavior:Init()
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

	table.insert(self.levelList, levelInfo)	
	self.levelMap[levelId] = levelInfo
	self.waitCreateList[levelId] = nil
	return blackCurtain, blackTime or 0.2
end

function LevelManager:RemoveLevel(levelId)
	local levelInfo = self.levelMap[levelId]
	if not levelInfo then
		return
	end

	-- print("RemoveLevel "..levelId)
	--if self.assetsNodeManager:CheckGetingCount(levelId) ~= 0 then
		--if not self.removeList[levelId] then
			--self.removeList[levelId] = true
		--end
		--return
	--end

	-- print("RemoveLevel cmp"..levelId)
	--GameObject.Destroy(levelInfo.logicObject)

	for k, v in pairs(self.levelList) do
		if v.levelId == levelId then
			table.remove(self.levelList, k)
		end
	end

	self.levelMap[levelId] = nil

	self.fight.entityManager:RemoveLevelEntity(levelId)
	self.assetsNodeManager:UnLoadLevel(levelId)
end

function LevelManager:RemoveAllLevel()
	for k, v in pairs(self.levelMap) do
		self:RemoveLevel(k)
	end
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
	for k, v in ipairs(self.levelList) do
		if v.sceneObjectsCmp then
			v.sceneObjectsCmp:SetSceneSpeed(speed)
		end
	end
end

function LevelManager:CheckLevelIsCreateOrCreating(levelId)
	return self.waitCreateList[levelId] or self.levelMap[levelId]
end

function LevelManager:__delete()
	if self.levelList then
		--local assetsPoolMgr = mod.WorldCtrl.assetsPoolMgr
		for k, v in ipairs(self.levelList) do
			--assetsPoolMgr:UnLoadLevelPool(v.levelId)
			if v.levelBehavior then
				v.levelBehavior:DeleteMe()
			end
		end

		self.levelList = nil
		self.levelMap = nil
		self.levelManager = nil
	end

	self.removeList = {}
	self.waitCreateList = {}
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
