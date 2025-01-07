EntityBehaviorMgr = BaseClass("EntityBehaviorMgr")

local EVENTS = BehaviorEvent.EventName

function EntityBehaviorMgr:__init(entityManager)
    self.entityManager = entityManager
	self.beahviorCacheEvents = {}
	for _, funcName in pairs(EVENTS) do
		self[funcName] = {}
	end
end


function EntityBehaviorMgr:CreateBehavior(name, parentBehavior, instanceId, sInstanceId, params)
    if not _G[name] then
        LogError("创建行为树失败！"..name)
        return nil
    end
    local beahvior = _G[name].New()

    if parentBehavior then
        local mainBehavior
        if parentBehavior.MainBehavior then
            mainBehavior = parentBehavior.MainBehavior
        else
            mainBehavior = parentBehavior
        end
        parentBehavior.childBehaviors = parentBehavior.childBehaviors or {}
        table.insert(parentBehavior.childBehaviors,beahvior)
        beahvior.MainBehavior = mainBehavior
        beahvior.ParentBehavior = parentBehavior
        instanceId = mainBehavior.instanceId
        sInstanceId = mainBehavior.sInstanceId
    end

    beahvior:SetInstanceId(instanceId, sInstanceId, self)
    if params and params.paramList and params.magicLevel then
        beahvior:SetCustomParam(params.paramList, params.magicLevel)
    end

    beahvior:Init()

    local beahviorCacheEvents
    if self.beahviorCacheEvents[name] then
        beahviorCacheEvents = self.beahviorCacheEvents[name]
    end

    if beahviorCacheEvents then
        for _, funcName in pairs(beahviorCacheEvents) do
            table.insert(self[funcName], beahvior)
        end
    else
        beahviorCacheEvents = {}
        for _, funcName in pairs(EVENTS) do
            if beahvior[funcName] then
                table.insert(self[funcName], beahvior)
                table.insert(beahviorCacheEvents, funcName)
            end
        end
        self.beahviorCacheEvents[name] = beahviorCacheEvents
    end
        
    return beahvior
end

function EntityBehaviorMgr:RemoveBehavior(beahvior)
    local beahviorCacheEvents = self.beahviorCacheEvents[beahvior.__className]
    if beahviorCacheEvents then
        for _, funcName in pairs(beahviorCacheEvents) do
            self[funcName][beahvior] = nil
        end
    end
end

function EntityBehaviorMgr:CallEventFun(funcName, ...)
    if not self[funcName] then
        return false
    end

    for _, behavior in pairs(self[funcName]) do
        if not self.entityManager:GetEntity(behavior.instanceId) then
            goto continue
        end
        -- if self.entityManager.entityInstances[behavior.instanceId] then
        behavior[funcName](behavior, ...)
        -- end
        ::continue::
    end

    return true
end