XLuaBridge = {}

local GameLuaStart = GameLuaStart

function XLuaBridge.Start()
	GameLuaStart.New()
	GameLuaStart.Instance:Start()
end

function XLuaBridge.Update()
	GameLuaStart.Instance:Update()
end

function XLuaBridge.FixedUpdate()
	GameLuaStart.Instance:FixedUpdate()
end

function XLuaBridge.AreaTriggerEnter(colliderInstanceId, areaObjInsId, layer, triggerObjName, param0)
	if Fight.Instance then
		local entityMgr = Fight.Instance.entityManager
		if entityMgr then
			entityMgr:OnTriggerColliderEntityEnter(FightEnum.TriggerType.Terrain, colliderInstanceId, areaObjInsId, layer, triggerObjName, param0)
		end
	end
end

function XLuaBridge.AreaTriggerExit(colliderInstanceId, areaObjInsId, layer, triggerObjName, param0)
	if Fight.Instance then
		local entityMgr = Fight.Instance.entityManager
		if entityMgr then
			entityMgr:OnTriggerColliderEntityExit(FightEnum.TriggerType.Terrain, colliderInstanceId, areaObjInsId, layer, triggerObjName, param0)
		end
	end
end

function XLuaBridge.AreaTriggerRemove(colliderInstanceId, layer, triggerObjName, param0)
	if Fight.Instance then
		local entityMgr = Fight.Instance.entityManager
		if entityMgr then
			entityMgr:OnTriggerColliderRemove(FightEnum.TriggerType.Terrain, colliderInstanceId, layer, triggerObjName, param0)
		end
	end
end

function XLuaBridge.EntityTriggerEnter(triggerType, objInsId, enterObjInsId, layer, name, param0)
	if Fight.Instance then
		local entityMgr = Fight.Instance.entityManager
		if entityMgr then
			entityMgr:OnTriggerColliderEntityEnter(triggerType, objInsId, enterObjInsId, layer, name, param0)
		end
	end
end

function XLuaBridge.EntityTriggerExit(triggerType, objInsId, enterObjInsId, layer, name, param0)
	if Fight.Instance then
		local entityMgr = Fight.Instance.entityManager
		if entityMgr then
			entityMgr:OnTriggerColliderEntityExit(triggerType, objInsId, enterObjInsId, layer, name, param0)
		end
	end
end

function XLuaBridge.EntityTriggerRemove(triggerType, objInsId, layer)
	if Fight.Instance then
		local entityMgr = Fight.Instance.entityManager
		if entityMgr then
			entityMgr:OnTriggerColliderRemove(triggerType, objInsId, layer)
		end
	end
end


function XLuaBridge.RecvCallServerList()
	local curWindow = WindowManager.Instance:GetCurWindow()
	if curWindow ~= "LoginWindow" then
		return
	end

	local window = WindowManager.Instance:GetWindow("LoginWindow")
	if not window then return end
	window:RecvCallServerList()
end