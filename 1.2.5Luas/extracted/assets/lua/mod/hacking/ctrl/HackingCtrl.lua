HackingCtrl = BaseClass("HackingCtrl", Controller)

function HackingCtrl:__init()
    self.clientHackingData = {}
    self.clientBuild = {}
    self.buildTypeList = {}

    self:AddListener()
end

function HackingCtrl:AddListener()
    EventMgr.Instance:AddListener(EventName.RemoveEntity, self:ToFunc("OnBuildRemove"))
    EventMgr.Instance:AddListener(EventName.OnEntityTimeoutDeath, self:ToFunc("OnEntityTimeoutDeath"))
    EventMgr.Instance:AddListener(EventName.EnterMap, self:ToFunc("OnEnterMap"))
    EventMgr.Instance:AddListener(EventName.Revive, self:ToFunc("OnEnterMap"))
end

function HackingCtrl:OnEnterMap()
    TableUtils.ClearTable(self.clientBuild)
end

--检查列表中的建造物是否消失，返回当前建造物数量
function HackingCtrl:GetTotalBuildCount()
    return #self.clientBuild
end

--检查列表中的建造物是否消失，返回当前建造物数量
function HackingCtrl:GetTypeBuildCount(typeId)
    local count = 0
    for k, v in pairs(self.clientBuild) do
        if v.typeId == typeId then
            count = count + 1
        end
    end
    return count
end

--增加新的建造物
function HackingCtrl:AddBuild(typeId, instanceId)
    table.insert(self.clientBuild, { typeId = typeId, instanceId = instanceId })
end

--主动销毁建造物
function HackingCtrl:RemoveBuild(typeId)
    local instanceId
    if typeId then
        for i = 1, #self.clientBuild, 1 do
            if self.clientBuild[i].typeId == typeId then
                instanceId = self.clientBuild[i].instanceId
                break
            end
        end
    else
        instanceId = self.clientBuild[#self.clientBuild].instanceId
    end
    local entity = Fight.Instance.entityManager:GetEntity(instanceId)
    entity.timeoutDeathComponent:SetDeath()
end

local BuildRemoveEffect = 1000083
--建造物被销毁时，从记录中移除
function HackingCtrl:OnEntityTimeoutDeath(instanceId)
    for k, v in pairs(self.clientBuild) do
        if v.instanceId == instanceId then
            table.remove(self.clientBuild, k)
            --激活退场动画
            local entity = Fight.Instance.entityManager:GetEntity(instanceId)
            --TODO 临时逻辑，下版本改为配置
            BehaviorFunctions.RemoveBuffByKind(entity.instanceId, 1010)
            if entity.entityId == 2030501 then
                BehaviorFunctions.DoMagic(1, entity.instanceId, BuildRemoveEffect)
            elseif entity.entityId == 2030502 then
                BehaviorFunctions.DoMagic(1, entity.instanceId, 1000086)
            end
            EventMgr.Instance:Fire(EventName.RemoveHackingBuild)
            break
        end
    end
end

function HackingCtrl:ReqCostPower(build_id, func)
    local id, cmd = mod.HackingFacade:SendMsg("hacking_build", build_id)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function()
        func()
    end)
end

function HackingCtrl:__InitComplete()
end

function HackingCtrl:__delete()
    EventMgr.Instance:RemoveListener(EventName.RemoveEntity, self:ToFunc("OnBuildRemove"))
    EventMgr.Instance:RemoveListener(EventName.OnEntityTimeoutDeath, self:ToFunc("OnEntityTimeoutDeath"))
    EventMgr.Instance:RemoveListener(EventName.EnterMap, self:ToFunc("OnEnterMap"))
    EventMgr.Instance:RemoveListener(EventName.Revive, self:ToFunc("OnEnterMap"))
end