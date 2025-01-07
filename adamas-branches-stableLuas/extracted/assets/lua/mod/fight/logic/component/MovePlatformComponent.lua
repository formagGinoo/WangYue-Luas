---@class MovePlatformComponent
MovePlatformComponent = BaseClass("MovePlatformComponent", PoolBaseClass)

function MovePlatformComponent:__init()
end

function MovePlatformComponent:Init(fight, entity)
    self.fight = fight
    self.entity = entity
    self.config = entity:GetComponentConfig(FightEnum.ComponentType.MovePlatform)
    self.shapeType = self.config.ShapeType or FightEnum.CollisionType.Sphere
    self.InCacheTable = {}
    self.OutCacheTable = {}
    self.triggerEntities = {}
    self.enabled = true

    self.removeList = {}

    EventMgr.Instance:AddListener(EventName.RemoveEntity, self:ToFunc("OnRemoveEntity"))
end


function MovePlatformComponent:LateInit()
    local normalOffset = self.config.Offset
    local outOffset = self.config.SetOutOffset and self.config.OutOffset or self.config.Offset
    if self.shapeType == FightEnum.CollisionType.Sphere then
        local radius = self.config.Radius
        local radiusOut = self.config.RadiusOut or radius
        self:InitTrigger(self.shapeType, radius, nil, nil, radiusOut, nil, nil, self.config.SetOutOffset, normalOffset, outOffset)
    elseif self.shapeType == FightEnum.CollisionType.Cube then
        local size = self.config.CubeIng
        local sizeOut = self.config.CubeOut or size
        self:InitTrigger(self.shapeType, size[1], size[2], size[3], sizeOut[1], sizeOut[2], sizeOut[3], self.config.SetOutOffset, normalOffset, outOffset)
    end
end

function MovePlatformComponent:InitTrigger(shape, inRangeX, inRangeY, inRangeZ, outRangeX, outRangeY, outRangeZ, differentOffset, offset, outOffset)
    local sameCollider = false
    if inRangeX and inRangeX ~= 0 then
        local triggerType = FightEnum.TriggerType.MovePlatformIn
        if outRangeX == inRangeX and outRangeY == inRangeY and outRangeZ == inRangeZ and not differentOffset then
            triggerType = triggerType | FightEnum.TriggerType.MovePlatformOut
            sameCollider = true
        end

        local collider = self:CreateCollider(shape, triggerType, inRangeX, inRangeY, inRangeZ, offset[1], offset[2], offset[3])
        self.inCollider = collider
        if sameCollider then
            self.outCollider = collider
        end
    end

    if not sameCollider and outRangeX and outRangeX ~= 0 then
        local collider = self:CreateCollider(shape, FightEnum.TriggerType.MovePlatformOut, outRangeX, outRangeY, outRangeZ, outOffset[1], outOffset[2], outOffset[3])
        self.outCollider = collider
    end
end

function MovePlatformComponent:CreateCollider(shape, triggerType, x, y, z, offsetX, offsetY, offsetZ)
    local parent = self.entity.clientTransformComponent:GetTransform()
    local collider = BaseCollider.Create(shape, x, y, z, offsetX, offsetY, offsetZ, FightEnum.Layer.IgnoreRayCastLayer, parent, self.entity)
    if collider then
        collider:AddTriggerComponent(triggerType, 1 << FightEnum.Layer.EntityCollision)
    end

    return collider
end


function MovePlatformComponent:Update()
    if not self.enabled then
        return
    end

    local inArea = self.entity:GetTriggerEntity(FightEnum.TriggerType.MovePlatformIn, self.inCollider.colliderObjInsId, self.InCacheTable)
    local outArea = self.entity:GetTriggerEntity(FightEnum.TriggerType.MovePlatformOut, self.outCollider.colliderObjInsId, self.OutCacheTable)

    local player = Fight.Instance.playerManager:GetPlayer()
    local needUpdatePlayers = false

    --延迟一帧去设置停止检测跟随移动，解决平台移速过快把人甩出去的问题
    for k, v in pairs(self.removeList) do
        self.triggerEntities[v] = nil
        if BehaviorFunctions.CheckEntity(v) then
            if not player:GetEntityInfo(v) then
                local entity = BehaviorFunctions.GetEntity(v)
                if entity.moveComponent then
                    entity.moveComponent.CheckMovePlatform = false
                end
            else
                needUpdatePlayers = true
            end
        end
    end
    TableUtils.ClearTable(self.removeList)

    for _, v in pairs(self.triggerEntities) do
        local out = true
        for _, vv in pairs(outArea) do
            if vv == v then
                out = false
                break
            end
        end

        if out then
            table.insert(self.removeList, v)
        end
    end


    for _, v in pairs(inArea) do
        if not self.triggerEntities[v] then
            self.triggerEntities[v] = v
            if not player:GetEntityInfo(v) then
                --设置开始检测跟随移动
                local entity = BehaviorFunctions.GetEntity(v)
                if entity and entity.moveComponent then
                    entity.moveComponent.CheckMovePlatform = true
                end
            else
                needUpdatePlayers = true
            end
        end
    end

    if needUpdatePlayers then
        self:CheckPlayerAllEntity()
    end
end

---玩家切换角色/切换队伍时,在切换的那一帧不会触发进入/离开区域判定，所以要以player为对象来设置跟随移动
function MovePlatformComponent:CheckPlayerAllEntity()
    local player = Fight.Instance.playerManager:GetPlayer()
    local entityList = player:GetEntityList()

    local haveRoleInArea = false
    for k, v in pairs(self.triggerEntities) do
        if player:GetEntityInfo(v) then
            haveRoleInArea = true
            break
        end
    end

    for _, v in pairs(entityList) do
        v.moveComponent.CheckMovePlatform = haveRoleInArea
    end

    self.entity.clientTransformComponent.presentationMoveVector:Set()
end


function MovePlatformComponent:__cache()
    self.fight = nil
    self.entity = nil
end

function MovePlatformComponent:__delete()

end

function MovePlatformComponent:OnCache()
    EventMgr.Instance:RemoveListener(EventName.RemoveEntity, self:ToFunc("OnRemoveEntity"))
    if self.inCollider then
        self.inCollider:OnCache()
    end

    if self.outCollider and self.outCollider ~= self.inCollider then
        self.outCollider:OnCache()
    end

    self.enabled = true
    self.inCollider = nil
    self.outCollider = nil
    self.fight.objectPool:Cache(MovePlatformComponent,self)
end

function MovePlatformComponent:OnRemoveEntity(instanceId)
    if instanceId ~= self.entity.instanceId then
        return
    end

    for _, v in pairs(self.triggerEntities) do
        --设置停止检测跟随移动
        local entity = BehaviorFunctions.GetEntity(v)
        if entity and entity.moveComponent then
            entity.moveComponent.CheckMovePlatform = false
        end
    end
    TableUtils.ClearTable(self.triggerEntities)
end

function MovePlatformComponent:SetMovePlatformEnabled(enabled)
    self.enabled = enabled
    if not enabled then
        for _, v in pairs(self.triggerEntities) do
            local entity = BehaviorFunctions.GetEntity(v)
            if entity and entity.moveComponent then
                entity.moveComponent.CheckMovePlatform = false
            end
        end
        TableUtils.ClearTable(self.triggerEntities)
        self.entity.clientTransformComponent.presentationMoveVector:Set()
    end
end