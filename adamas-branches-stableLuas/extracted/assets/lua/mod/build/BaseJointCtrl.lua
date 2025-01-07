--记录建造物组合信息，计算几何中心点，记录结构，避免过多的递归计算，
local BF = BehaviorFunctions
BaseJointCtrl = BaseClass("BaseJointCtrl",PoolBaseClass)

function BaseJointCtrl:__init()
    self.childBuildList = {}
end

function BaseJointCtrl:Init(fight, build)
    self.fight = fight
    self:AddBuild(build)
end

--增加新的建造物,并把新的建造物关联的建造物也加进来
---@param build Entity
function BaseJointCtrl:AddBuild(build, ignoreId)
    --TODO 记录建造结构
    local oldCtrl = build.jointComponent.jointCtrl
    if oldCtrl then
        self.fight.objectPool:Cache(BaseJointCtrl, oldCtrl)
    end

    self.childBuildList[build.instanceId] = build.entityId
    build.jointComponent:SetJointCtrl(self)
    --遍历父子节点
    for k, v in pairs(build.jointComponent.parentIdList) do
        if ignoreId ~= v then
            local entity = BF.GetEntity(v)
            self:AddBuild(entity, build.instanceId)
        end
    end

    for k, v in pairs(build.jointComponent.childIdList) do
        if ignoreId ~= v then
            local entity = BF.GetEntity(v)
            self:AddBuild(entity, build.instanceId)
        end
    end
end

function BaseJointCtrl:RemoveBuild(build, ignoreId, isRoot)
    --TODO 记录建造结构
    self.childBuildList[build.instanceId] = nil
    build.jointComponent:RemoveJointCtrl()

    --遍历父子节点
    for k, v in pairs(build.jointComponent.parentIdList) do
        if ignoreId ~= v then
            local entity = BF.GetEntity(v)
            self:RemoveBuild(entity, build.instanceId)
        end
    end

    for k, v in pairs(build.jointComponent.childIdList) do
        if ignoreId ~= v then
            local entity = BF.GetEntity(v)
            self:RemoveBuild(entity, build.instanceId)
        end
    end

    if isRoot then
        local ctrl = self.fight.objectPool:Get(BaseJointCtrl)
        ctrl:Init(self.fight, build)
    end
end

function BaseJointCtrl:GetJointCenterPoint()
        local init = false
        for instanceId, _ in pairs(self.childBuildList) do
            local entity = BF.GetEntity(instanceId)
            if not init then
                self.centerPoint = entity.transformComponent.position:Clone()
                init = true
            else
                Vec3.LerpA(self.centerPoint, entity.transformComponent.position, 0.5, self.centerPoint)
            end
        end

    return self.centerPoint
end
--

function BaseJointCtrl:CheckEntityOnJoint(instanceId)
    return self.childBuildList[instanceId]
end

function BaseJointCtrl:CheckEntityByEntityId(entityId)
    for k, v in pairs(self.childBuildList) do
        if v == entityId then
            return k
        end
    end
    return false
end

function BaseJointCtrl:Update()
end

function BaseJointCtrl:OnEntityRemove(instanceId)
    if self.childBuildList[instanceId] then
        self.childBuildList[instanceId] = nil
        if TableUtils.GetTabelLen(self.childBuildList) == 0 then
            self.fight.objectPool:Cache(BaseJointCtrl, self)
        end
    end
end

function BaseJointCtrl:Unload()
    self.centerPoint = nil
    for instanceId, _ in pairs(self.childBuildList) do
        local entity = BF.GetEntity(instanceId)
        entity.jointComponent:RemoveJointCtrl()
    end
    TableUtils.ClearTable(self.childBuildList)
end

function BaseJointCtrl:__cache()
    self:Unload()
    self.fight = nil
end

function BaseJointCtrl:__delete()
end
