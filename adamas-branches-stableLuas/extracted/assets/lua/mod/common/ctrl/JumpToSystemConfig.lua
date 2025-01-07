JumpToSystemConfig = JumpToSystemConfig or {}
local DataConfig = Config.DataNpcSystemJump.Find

local JumpType = {
    OpenNpcStore = 1,
    OpenTalent = 2,
    OpenMailing = 3,
    MercenaryHunt = 4,
    OpenAlchemy = 5,
    Task = 6,
    OpenTrade = 7,
    Bargain = 8,
    TaskDuplicate = 9,
	NightMareDuplicate = 11,	
    CitySimulation = 12,
    OutPrison = 13
}

JumpToSystemConfig.Functions = {
    [JumpType.TaskDuplicate] = function(dupilicateId)
        BehaviorFunctions.OpenTaskDuplicateUi(dupilicateId)
    end,
    [JumpType.OutPrison] = function()
        mod.CrimeCtrl:OutPrison()
    end,
    [JumpType.NightMareDuplicate] = function(dupilicateId)
        BehaviorFunctions.OpenNightMareDuplicateUi(dupilicateId)
    end,
}

function JumpToSystemConfig.DoJumpToSystemByTypeAndInstanceId(type, instanceId)
    local entity = Fight.Instance.entityManager:GetEntity(instanceId)
    if entity and entity.sInstanceId then
        local cfg = Fight.Instance.entityManager.ecosystemEntityManager:GetEcoEntityConfig(entity.sInstanceId)
        if cfg then
            --如果有跳转id
            for _, id in ipairs(cfg.jump_system_id) do
                local npcSystemJumpCfg = DataConfig[id]
                if npcSystemJumpCfg and npcSystemJumpCfg.type == type then
                    JumpToSystemConfig.Functions[type](npcSystemJumpCfg.param[1])
                end
            end
        end
    end
end

local DataNpcSystemJump = Config.DataNpcSystemJump.Find

function JumpToSystemConfig.GetNPCJumpConfig(id)
    return DataNpcSystemJump[id]
end
