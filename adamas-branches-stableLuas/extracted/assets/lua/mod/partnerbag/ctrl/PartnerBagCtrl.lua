PartnerBagCtrl = BaseClass("PartnerBagCtrl",Controller)

local _tinsert = table.insert

function PartnerBagCtrl:__init()
    EventMgr.Instance:AddListener(EventName.PartnerInfoChange, self:ToFunc("PartnerInfoChange"))
end

function PartnerBagCtrl:__delete()
    EventMgr.Instance:RemoveListener(EventName.PartnerInfoChange, self:ToFunc("PartnerInfoChange"))
end

function PartnerBagCtrl:PartnerInfoChange(oldData, newData)
    --过滤下数据，如果饱食度、、相关属性变化
    self:CheckPartnerWorkInfoChange(oldData, newData)
end

function PartnerBagCtrl:CheckPartnerWorkInfoChange(oldData, newData)

    if oldData.work_info.satiety ~= newData.work_info.satiety
            or oldData.work_info.san ~= newData.work_info.san
            or oldData.work_info.asset_id ~= newData.work_info.asset_id
            or oldData.work_info.status ~= newData.work_info.status
            or oldData.work_info.work_speed ~= newData.work_info.work_speed
            or oldData.work_info.work_decoration_id ~= newData.work_info.work_decoration_id
            or oldData.work_info.status_decoration_id ~= newData.work_info.status_decoration_id
    then
        EventMgr.Instance:Fire(EventName.PartnerWorkUpdate, newData.unique_id)
    end
end

function PartnerBagCtrl:LockPartner(uniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    if not partnerData then 
        return false
    end
    if partnerData.work_info.asset_id ~= 0 then
        MsgBoxManager.Instance:ShowTipsImmediate(TI18N("该月灵在资产中，无法解锁"))
        return false
    end
    local wheelPartnerList = mod.AbilityWheelCtrl:GetAbilityWheelPartnerList()
    for k, v in pairs(wheelPartnerList) do
        if uniqueId == v then
            MsgBoxManager.Instance:ShowTips(TI18N("该月灵在轮盘列表中，请先从轮盘列表卸下。"))
            return false
        end
    end
    mod.BagCtrl:SetItemLockState(uniqueId, not partnerData.is_locked, BagEnum.BagType.Partner)
    return true
end

function PartnerBagCtrl:GetPartnerDataByUniqueId(uniqueId)
    return mod.BagCtrl:GetPartnerData(uniqueId)
end

--月灵是否拥有某一项职业
function PartnerBagCtrl:CheckPartnerIsHaveCareer(uniqueId, careerId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    local partnerWorkCfg = PartnerBagConfig.GetPartnerWorkConfig(partnerData.template_id)
    if not partnerWorkCfg then
        return false
    end
    
    for i, v in ipairs(partnerWorkCfg.career) do
        if v[1] ~= 0 and v[1] == careerId then
            return true
        end
    end
    
    return false
end

--佩丛某一项职业的等级
function PartnerBagCtrl:GetPartnerCareerLvById(uniqueId, careerId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    local partnerWorkCfg = PartnerBagConfig.GetPartnerWorkConfig(partnerData.template_id)
    if not partnerWorkCfg then
        return 0
    end

    for i, v in ipairs(partnerWorkCfg.career) do
        if v[1] ~= 0 and v[1] == careerId then
            return v[2]
        end
    end

    return 0
end

--月灵是否可以工作
function PartnerBagCtrl:CheckPartnerIsCanWork(uniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    local partnerWorkCfg = PartnerBagConfig.GetPartnerWorkConfig(partnerData.template_id)
    if not partnerWorkCfg then
        return false
    end
    return true
end

--获取月灵的工作信息work_info
function PartnerBagCtrl:GetPartnerWorkInfo(uniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    if partnerData and partnerData.work_info then
        return partnerData.work_info
    end
end

--获取月灵当前的san值
function PartnerBagCtrl:GetPartnerCurSanValue(uniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    if partnerData and partnerData.work_info then
        return partnerData.work_info.san
    else
        return 0
    end
end

--获取月灵当前的饱食度
function PartnerBagCtrl:GetPartnerCurFeedValue(uniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    if partnerData and partnerData.work_info then
        return partnerData.work_info.satiety
    else
        return 0
    end
end

--获取月灵最大饱食度和 san值
function PartnerBagCtrl:GetPartnerMaxFeedAndSanValue(uniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    if not partnerData then
        return 0, 0
    end
    local baseCfg = PartnerBagConfig.GetPartnerWorkConfig(partnerData.template_id)
    if not baseCfg then
        return 0, 0
    end
    
    local maxFeed = baseCfg.max_feed
    local maxSan = baseCfg.max_san
    
    --该月灵是否有特性
    for index, value in pairs(partnerData.affix_list) do
        local affixCfg = PartnerBagConfig.GetPartnerWorkAffixCfg(value.id, value.level)
        if affixCfg then
            for _, v in pairs(affixCfg.effect) do
                if v[1] == PartnerBagConfig.PartnerWorkAffixEnum.FeedMaxUp then
                    maxFeed = math.floor(maxFeed + (maxFeed * (v[2] * 0.0001)) + 0.5) --万分比
                elseif v[1] == PartnerBagConfig.PartnerWorkAffixEnum.SanMaxUp then
                    maxSan = math.floor(maxSan + (maxSan * (v[2] * 0.0001)) + 0.5)
                end
            end
        end
    end
    
    return maxFeed, maxSan
end

--获取月灵某一个职业的工作速度
function PartnerBagCtrl:GetPartnerWorkSpeed(uniqueId, careerId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    local baseCfg = PartnerBagConfig.GetPartnerWorkConfig(partnerData.template_id)
    if not baseCfg then
        return 0
    end

    local maxSpeed = 0

    for i, v in ipairs(baseCfg.career) do
        local id = v[1] 
        local lv = v[2]
        if id == careerId then 
            local careerLvCfg = PartnerBagConfig.GetPartnerWorkCareerLevelCfg(id, lv)
            maxSpeed =  careerLvCfg.work_speed --基础速度值
            break
        end
    end
    
    --该月灵是否有特性
    for index, value in pairs(partnerData.affix_list) do
        local affixCfg = PartnerBagConfig.GetPartnerWorkAffixCfg(value.id, value.level)
        if affixCfg then
            for _, v in pairs(affixCfg.effect) do
                if v[1] == PartnerBagConfig.PartnerWorkAffixEnum.SpeedUp then
                    maxSpeed = math.floor(maxSpeed + (maxSpeed * (v[2] * 0.0001)) + 0.5) --万分比
                end
            end
        end
    end

    return maxSpeed
end

--获取月灵的状态， 是否处于饥饿状态或者抑郁状态 （抑郁 > 饥饿）
function PartnerBagCtrl:GetAssetPartnerState(uniqueId)
    if not uniqueId then
       return 
    end
    local curHunger = self:GetPartnerCurFeedValue(uniqueId)
    local curSan = self:GetPartnerCurSanValue(uniqueId)
    local maxFeed, maxSan = self:GetPartnerMaxFeedAndSanValue(uniqueId)
    
    local hungerPercent = PartnerBagConfig.GetPartnerWorkCommonCfg(PartnerBagConfig.PartnerWorkCommonEnum.PartnerHungerPercent) / 10000
    local sanPercent = PartnerBagConfig.GetPartnerWorkCommonCfg(PartnerBagConfig.PartnerWorkCommonEnum.PartnerSadPercent) / 10000
    
    --先判断是不是抑郁
    --当前值/上限值
    local isSad = (curSan / maxSan) <= sanPercent
    local isHunger = (curHunger / maxFeed) <= hungerPercent

    if isSad and isHunger then
        return FightEnum.PartnerStatusEnum.HungerAndSad
    elseif isSad then
        return FightEnum.PartnerStatusEnum.Sad
    elseif isHunger then
        return FightEnum.PartnerStatusEnum.Hunger
    end
    
    return FightEnum.PartnerStatusEnum.None
end

--获取月灵的状态文本
function PartnerBagCtrl:GetPartnerStateText(uniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    local str = TI18N("没有工作安排")

    if partnerData.work_info.work_decoration_id ~= 0 then
        local deviceInfo = mod.AssetPurchaseCtrl:GetCurAssetDeviceWorkData(partnerData.work_info.work_decoration_id)
        local deviceCfg = AssetPurchaseConfig.GetAssetDeviceInfoById(deviceInfo.template_id)
        if partnerData.work_info.status == PartnerBagConfig.PartnerWorkStatusEnum.Work then -- 有工作设备代表在工作
            str = string.format(TI18N("【%s】工作中"), deviceCfg.name)
        elseif partnerData.work_info.status == PartnerBagConfig.PartnerWorkStatusEnum.Eat then -- 吃饭
            str = string.format(TI18N("【%s】吃饭中"), deviceCfg.name)
        elseif partnerData.work_info.status == PartnerBagConfig.PartnerWorkStatusEnum.Sleep then -- 睡觉
            str = string.format(TI18N("【%s】睡觉中"), deviceCfg.name)
        end
    end
    
    return str
end

-- 检查月灵专属技能是否解锁
function PartnerBagCtrl:CheckAssetPartnerSkillUnlock(curUniqueId, skillId)
    local partnerData = mod.BagCtrl:GetPartnerData(curUniqueId)
    if not partnerData then return false end
    local assetSkillList = partnerData.asset_skill_list
    for _, id in pairs(assetSkillList) do
       if id == skillId then
           return true
       end
    end
    return false
end

function PartnerBagCtrl:CheckAssetPartnerSkillAllUnlock(curUniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(curUniqueId)
    if not partnerData then return false end
    local partnerId = partnerData.template_id
    local exclusiveSkillCfg = PartnerCenterConfig.GetPartnerExclusiveSkillConfig(partnerId)
    if not exclusiveSkillCfg then return false end
    local skillList = exclusiveSkillCfg.partner_skill_id
    for _, skillId in pairs(skillList) do
        if skillId and skillId ~= 0 and not self:CheckAssetPartnerSkillUnlock(curUniqueId, skillId) then
            return false
        end 
    end

    return true
end

function PartnerBagCtrl:GetCareerPartnerList(curUniqueId)
    -- local curPartnerData = mod.BagCtrl:GetPartnerData(curUniqueId)
    -- if not curPartnerData then
    --     return
    -- end

    -- local partnerId = curPartnerData.template_id
    -- local careerCfg = PartnerBagConfig.GetPartnerWorkConfig(partnerId) 
    -- if not careerCfg then
    --     return
    -- end

    local career = {}
    -- 技能升级台Id
    local deviceTemplateId = 1001006
    local deviceCfg = AssetPurchaseConfig.GetAssetDeviceInfoById(deviceTemplateId)
    career[deviceCfg.career] = true

    local asset_id = mod.AssetPurchaseCtrl:GetCurAssetId()
    if not asset_id then
        return
    end

    local curOriginData = {}
    local partnerMap = mod.AssetPurchaseCtrl:GetAssetPartnerList(asset_id)
    if not next(partnerMap) then
        return
    end

    for i, UniqueId in pairs(partnerMap) do
        local data = mod.BagCtrl:GetPartnerData(UniqueId)
        if data then
            _tinsert(curOriginData, data)
        end
    end

    local curBagData = TableUtils.CopyTable(curOriginData)
    local sort = {
        sortType = {},
        element = career,
        quality = {},
    }
    local newData = self:PickItem(curBagData, sort)
    if not next(newData) then return end
    
    return newData
end

function PartnerBagCtrl:PickItem(bagData, sortRule)
    local pickQuality = sortRule.quality
    local pickCareer = sortRule.element

    local pickTb = {}
    for i, v in pairs(bagData) do
        local res = true
        local partnerConfig = ItemConfig.GetItemConfig(v.template_id)
        local partnerWorkConfig = PartnerBagConfig.GetPartnerWorkConfig(v.template_id)
        --筛选了品质
        if next(pickQuality) and not pickQuality[partnerConfig.quality] then
            res = false
        end

        local careerLv = 0
        --筛选了职业
        if next(pickCareer) then
            local carRes = false
            if partnerWorkConfig then
                for _, data in pairs(partnerWorkConfig.career) do
                    local careerId = data[1]
                    local lv = data[2]
                    if pickCareer[careerId] then
                        carRes = true
                        careerLv = careerLv < lv and lv or careerLv
                    end
                end
            end
            res = carRes
        end
        
        if res then
            local newData = TableUtils.CopyTable(v)
            newData.quality = partnerConfig.quality
            newData.careerLv = partnerConfig.careerLv
            _tinsert(pickTb, newData)
        end
    end
    
    return pickTb
end

function PartnerBagCtrl:CheckActivateSkillCostItem(curUniqueId, skillId)
    local partnerData = mod.BagCtrl:GetPartnerData(curUniqueId)
    if not partnerData then
        return
    end
    local isUnLockSkill = self:CheckAssetPartnerSkillUnlock(curUniqueId, skillId)
    if isUnLockSkill then
        LogError("技能已解锁")
        return
    end

    local skillCfg = PartnerCenterConfig.GetPartnerExclusiveSkillUnlockConfig(skillId)
    if not skillCfg then
        return
    end
    local needResList = skillCfg.item_consume
    for i = 1, #needResList do
        local resId = needResList[i][1]
        local resNum = needResList[i][2]
        local curNum = mod.BagCtrl:GetItemCountById(resId)
        if curNum < resNum then
            MsgBoxManager.Instance:ShowTips("道具消耗不足")
            return
        end
    end
    return true
end