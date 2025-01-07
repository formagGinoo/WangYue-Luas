BuildConfig = BuildConfig or {}
local BuildData = Config.DataBuild.Find
local FindByEntityId = Config.DataBuild.FindbyInstanceId

function BuildConfig.getNodesInfo(nodes)
    local costEnergy = 0
    local totalCurability = 0
    local costCount1 = 0
    local costCount2 = 0

    for _, node in pairs(nodes.child_list or {}) do
        local childCostEnergy, childCurability, childCostCount1, childCostCount2 = BuildConfig.getNodesInfo(node)
        local config = BuildData[node.build_id]
        costEnergy = costEnergy + childCostEnergy + config.cost_energy
        totalCurability = totalCurability + childCurability + config.curability
        costCount1 = costCount1 + childCostCount1 + config.cost_count
        costCount2 = costCount2 + childCostCount2 + config.cost_count2
    end
    return costEnergy, totalCurability, costCount1, costCount2
end

--根据蓝图计算承载量和消耗信息
function BuildConfig.GetBluePrintInfo(bluePrint)
    local baseConfig = BuildData[bluePrint.build_id]
    local maxEnergy = baseConfig.output_energy
    local totalCurability = baseConfig.curability
    local costEnergy, extraCurability, childCostCount1, childCostCount2 = BuildConfig.getNodesInfo(bluePrint)
    totalCurability = totalCurability + extraCurability
    local costCount1 = baseConfig.cost_count + childCostCount1
    local costCount2 = baseConfig.cost_count2 + childCostCount2

    maxEnergy = maxEnergy + BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.ExtraBuildEnergy)

    return maxEnergy, costEnergy, totalCurability, costCount1, costCount2
end

function BuildConfig.GetBluePrintById(id)
    --如果预设中能找到，用预设的，否则用自定义数据

    for k, v in pairs(mod.HackingCtrl.custom_blueprint_list) do
        if v.blueprint_id == id then
            return v
        end
    end
end

function BuildConfig.CheckInstanceIsBuild(instanceId)
    local entity = BehaviorFunctions.GetEntity(instanceId)
    if entity then
        for _, v in pairs(BuildData) do
            if entity.entityId == v.instance_id then
                return true
            end
        end
    end
end

--获取材料数量
function BuildConfig.GetPowerCount()
    local currency = mod.BagCtrl:GetBagByType(BagEnum.BagType.Currency)
    for k, info in pairs(currency) do
        if info.template_id == 8 then
            return info.count or 0
        end
    end
    return 0
end

function BuildConfig.GetCorePowerCount()
    local currency = mod.BagCtrl:GetBagByType(BagEnum.BagType.Currency)
    for k, info in pairs(currency) do
        if info.template_id == 9 then
            return info.count or 0
        end
    end
    return 0
end

function BuildConfig.GetBuildConfigByEntityId(entityId)
    if FindByEntityId[entityId] then
        return BuildData[FindByEntityId[entityId][1]]
    end
end