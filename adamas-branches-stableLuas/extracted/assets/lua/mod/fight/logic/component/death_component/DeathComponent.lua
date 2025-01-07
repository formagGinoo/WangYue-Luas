---@class DeathComponent
DeathComponent = BaseClass("DeathComponent", PoolBaseClass)

local DeathConditions = FightEnum.DeathCondition

function DeathComponent:__init()
    self.judgeList = nil
    self.judgeConditions = nil
    self.judgeSurfaceList = {}
    
    self.judgeFuncs =
    {
        [DeathConditions.Drown] = self.Drown,
        [DeathConditions.Terrain] = self.TerrainDeath
    }
end

function DeathComponent:Init(fight, entity)
    self.fight = fight
    self.entity = entity

    self.isDeath = false
    self.config = entity:GetComponentConfig(FightEnum.ComponentType.Death)
    self:BindJudgeListener()
	
	self.deathRayHeight = self.entity.collistionComponent.height * 1.2

    EventMgr.Instance:AddListener(EventName.EnterDeath, self:ToFunc("AddToJudgeList"))
    EventMgr.Instance:AddListener(EventName.ExitDeath, self:ToFunc("RemoveInJudgeList"))
    EventMgr.Instance:AddListener(EventName.Revive, self:ToFunc("Revive"))
    EventMgr.Instance:AddListener(EventName.ChangeCollistionParam, self:ToFunc("ChangeCollistionParam"))
end

function DeathComponent:ChangeCollistionParam()
	self.deathRayHeight = self.entity.collistionComponent.height * 1.2
end

-- 通过配置绑定对应的判断方法
-- deathConditions是对应的子配置 deathTime是死亡动画播放时间
function DeathComponent:BindJudgeListener()
    for k, v in pairs(self.config.DeathList) do
        if not self.judgeConditions then
            self.judgeConditions = {}
        end

        self.judgeConditions[v.DeathReason] = { deathReason = FightEnum.DeathCondition2Reason[v.DeathReason], judgeFunc = self.judgeFuncs[v.DeathReason], deathConditions = v.deathCondition, deathTime = v.DeathTime }
    end
end

function DeathComponent:BeforeUpdate()

end

function DeathComponent:Update()
    if not self.judgeList or not next(self.judgeList) then
        return
    end

    for k, v in pairs(self.judgeList) do
        if v.judgeFunc(self, v.deathConditions) then
            EventMgr.Instance:Fire(EventName.EntityWillDie, self.entity.instanceId)
            self.entity.stateComponent:SetState(FightEnum.EntityState.Death, v.deathReason)
            self.isDeath = true
            break
        end
    end

    if self.isDeath then
        self:ClearJudgeList()
    end
end

function DeathComponent:AfterUpdate()

end

function DeathComponent:ClearJudgeList()
    TableUtils.ClearTable(self.judgeList)
    TableUtils.ClearTable(self.judgeSurfaceList)
end

-- 只是获取配置
function DeathComponent:GetJudgeCondition(deathReason)
    return self.judgeConditions[deathReason]
end

-- 获取当前正在判断的死亡状态
function DeathComponent:GetJudgeInfo(deathReason)
    return self.judgeList[deathReason]
end

function DeathComponent:IsInJudge(deathReason)
    return self.judgeList and self.judgeList[deathReason] ~= nil
end

--#region 死亡状态
function DeathComponent:Drown(config)
    if config.DrownHeight then
        local pos = self.entity.transformComponent.position
        local surfaceOfWater = self.entity.moveComponent:GetSurfaceOfWater()
        if surfaceOfWater - pos.y >= config.DrownHeight then
            return true
        end
    end

    if config.CheckPower and self.entity.stateComponent:IsState(FightEnum.EntityState.Swim) and self.entity.attrComponent then
        local stamina = BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.CurStaminaValue)
        if stamina <= 0 then
            return true
        end
    end

    return false
end

function DeathComponent:TerrainDeath(config)
    local judgeCondition = self.judgeList[DeathConditions.Terrain]
    local checkConfig = judgeCondition.checkConfig
    local layer = judgeCondition.extraParam.layer
    if not checkConfig then
        for i = 1, #config.TerrainDeathList do
            if config.TerrainDeathList[i].TerrainDeath == layer then
                checkConfig = config.TerrainDeathList[i]
                break
            end

            if i == #config.TerrainDeathList then
                self:RemoveInJudgeList(DeathConditions.Terrain)
                return false
            end
        end
    end

    if not judgeCondition.checkTime then
        judgeCondition.checkTime = 0
        judgeCondition.checkConfig = checkConfig
    end

    judgeCondition.checkTime = judgeCondition.checkTime + (FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale())
    if checkConfig.TerrainDeathTime > 0 and judgeCondition.checkTime >= checkConfig.TerrainDeathTime then
        return true
    end

    if checkConfig.TerrainDeathHeight < 999 then
        local t1 = 0
        local pos = self.entity.transformComponent:GetPosition()
		
        if not self.judgeSurfaceList[judgeCondition.deathReason] then
            local isRayCastHit, terrainSurface = CS.PhysicsTerrain.LayerCheck(layer, pos, t1, self.deathRayHeight, 0)
			
            if isRayCastHit then
                self.judgeSurfaceList[judgeCondition.deathReason] = terrainSurface
			else
				self.judgeSurfaceList[judgeCondition.deathReason] = 0
            end
        end	
		
        return (self.judgeSurfaceList[judgeCondition.deathReason] - pos.y) > checkConfig.TerrainDeathHeight
    end

    return false
end
--#endregion

--#region 缓存/清空
function DeathComponent:OnCache()
    if self.judgeList then
        TableUtils.ClearTable(self.judgeList)
    end

    if self.judeSurfaceList then
        TableUtils.ClearTable(self.judeSurfaceList)
    end

    if self.judgeConditions then
        TableUtils.ClearTable(self.judgeConditions)
    end

    self.fight.objectPool:Cache(DeathComponent, self)
end

function DeathComponent:RemoveAllListeners()
    EventMgr.Instance:RemoveListener(EventName.EnterDeath, self:ToFunc("AddToJudgeList"))
    EventMgr.Instance:RemoveListener(EventName.ExitDeath, self:ToFunc("RemoveInJudgeList"))
    EventMgr.Instance:RemoveListener(EventName.Revive, self:ToFunc("Revive"))
    EventMgr.Instance:RemoveListener(EventName.ChangeCollistionParam, self:ToFunc("ChangeCollistionParam"))
end

function DeathComponent:__cache()
    self:RemoveAllListeners()
end

function DeathComponent:__delete()
    self:RemoveAllListeners()
end
--#endregion

function DeathComponent:AddToJudgeList(instanceId, deathInfo)
    if self.entity.instanceId ~= instanceId then
        return
    end

    if not self.judgeList then
        self.judgeList = {}
    end

    local deathReason = deathInfo.deathReason
    if self.judgeList[deathReason] or not self.judgeConditions[deathReason] then
        return
    end

    self.judgeList[deathReason] = UtilsBase.copytab(self.judgeConditions[deathReason])
    self.judgeList[deathReason].extraParam = deathInfo.extraParam
end

function DeathComponent:RemoveInJudgeList(instanceId, deathReason)
    if self.entity.instanceId ~= instanceId then
        return
    end
    self:RemoveJudgeList(deathReason)
    self:RemoveSurfaceList(deathReason)
end

function DeathComponent:RemoveJudgeList(deathReason)
    if not self.judgeList or not self.judgeList[deathReason] then
        return
    end

    self.judgeList[deathReason] = nil
end

function DeathComponent:RemoveSurfaceList(deathReason)
    if not self.judgeSurfaceList or not self.judgeSurfaceList[deathReason] then
        return
    end
    
    self.judgeSurfaceList[deathReason] = nil
end

function DeathComponent:Revive(instanceId)
    if self.entity.instanceId ~= instanceId then
        return
    end

    self.isDeath = false
end