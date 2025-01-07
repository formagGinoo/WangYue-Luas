DebugDamagePanel = BaseClass("DebugDamagePanel", BasePanel)
local FrameRate = 30

function DebugDamagePanel:__init()
    self:SetAsset("Prefabs/UI/FightDebug/DebugDamage.prefab")
    self.recording = false
    self.records = {}
    self.recordObjs = {}
end

function DebugDamagePanel:__BindListener()
    self.StartBtn_btn.onClick:AddListener(self:ToFunc("OnClick_Start"))
    self.ReportBtn_btn.onClick:AddListener(self:ToFunc("OpenReport"))
    self.Close_btn.onClick:AddListener(self:ToFunc("CloseReport"))
    self.Move_drag.onDrag = self:ToFunc("MoveButton")
    self.Team_btn.onClick:AddListener(self:ToFunc("OnClick_Team"))
    self.Curve_btn.onClick:AddListener(self:ToFunc("OnClick_Curve"))
    self.Role_btn.onClick:AddListener(self:ToFunc("OnClick_Role"))
    self.Buff_btn.onClick:AddListener(self:ToFunc("OnClick_Buff"))
end

function DebugDamagePanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.EntityAttrChangeImmediately, self:ToFunc("EntityAttrChangeImmediately"))
    EventMgr.Instance:AddListener(EventName.PlayerAttrChange, self:ToFunc("PlayerAttrChange"))
    EventMgr.Instance:AddListener(EventName.SetCurEntity, self:ToFunc("SetCurEntity"))
    EventMgr.Instance:AddListener(EventName.OnDoDamage, self:ToFunc("OnDoDamage"))
    EventMgr.Instance:AddListener(EventName.OnEntityBuffChange, self:ToFunc("BuffChanged"))
end

function DebugDamagePanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.hide)
end

function DebugDamagePanel:ShowDisplay()
    
end

function DebugDamagePanel:__Show()
    
end

function DebugDamagePanel:OnClick_Start()
    self.recording = not self.recording
    if self.recording then
        self:StartRecord()
    else
        self:StopRecord()
    end
end

function DebugDamagePanel:MoveButton(data)
    local pos = self.ButtonGorup_rect.anchoredPosition
    UnityUtils.SetAnchoredPosition(self.ButtonGorup_rect, pos.x + data.delta.x, pos.y + data.delta.y)
end

function DebugDamagePanel:StartRecord()
    self.CurTime:SetActive(true)
    self.CurTime_txt.text = 0
    self.StartDesc_txt.text = "停止统计"
    self.curRecrd = {
        startFrame = nil,
        lastFrame = 0,
        curEntity = nil,
        entityDamage = {},--记录伤害
        entityBuff = {}, --记录buff
        entityState = {}, --记录前后台状态
        costRecrd = {}, --消耗记录
    }

end

function DebugDamagePanel:StopRecord()
    self.CurTime:SetActive(false)
    self.StartDesc_txt.text = "开始统计"
    local curRecrd = self.curRecrd
    if not curRecrd.startFrame then
        return
    end

    local frame = curRecrd.lastFrame - curRecrd.startFrame
    if curRecrd.curEntity then
        local data = curRecrd.entityState[curRecrd.curEntity]
        data[#data].endFrame = frame
    end
    for k, entityState in pairs(curRecrd.entityState) do
        for k, v in pairs(entityState) do
            if v.startFrame > frame then
                entityState[k] = nil
            elseif v.endFrame > frame then
                v.endFrame = frame
            end
        end
    end
    for k, entityBuff in pairs(curRecrd.entityBuff) do
        for k, v in pairs(entityBuff) do
            if v.frame > frame then
                entityBuff[k] = nil
            end
        end
    end

    for id, costRecrd in pairs(curRecrd.costRecrd) do
        local res = 0
        for attrType, values in pairs(costRecrd) do
            for k, v in pairs(values) do
                if v.frame < frame then
                    res = res + v.value
                end
            end
            costRecrd[attrType] = res
        end
    end
    self:SaveData()
end

function DebugDamagePanel:OpenReport()
    BehaviorFunctions.Pause()
    self.Window:SetActive(true)
    local key = next(self.records)
    if key and not self.curObj then
        self:ShowContent(self.records[key])
    end
end

function DebugDamagePanel:CloseReport()
    BehaviorFunctions.Resume()
    self.Window:SetActive(false)
end

function DebugDamagePanel:RealStart()
    local curRecrd = self.curRecrd
    local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    curRecrd.curEntity = entity.entityId
    curRecrd.entityState[curRecrd.curEntity] = {}
    local info = {startFrame = 0}
    table.insert(curRecrd.entityState[curRecrd.curEntity], info)
    local entityList = Fight.Instance.playerManager:GetPlayer():GetEntityList()
    for k, v in pairs(entityList) do
        self:RecrdBuff(v)
    end
end

function DebugDamagePanel:UpdateTime()
    local frame = self.curRecrd.lastFrame - self.curRecrd.startFrame
    local time = frame / FrameRate
    self.CurTime_txt.text = string.format("%0.2f",time) 
end

function DebugDamagePanel:OnDoDamage(intanceId, _, damageType, magicId, 
    dmgElement, damage, _, rootInstanceId, elementBreakValue)
    if not self.recording then
        return
    end
    local entity = BehaviorFunctions.GetEntity(rootInstanceId)
    if not entity.tagComponent or not entity.tagComponent:IsPlayer() then
        return
    end
    
    local curRecrd = self.curRecrd
    local curFrame = Fight.Instance:GetFrame()
    if not curRecrd.startFrame then
        curRecrd.startFrame = curFrame
        self:RealStart()
    end
    if curRecrd.lastFrame ~= curFrame then
        curRecrd.lastFrame = curFrame
    end
    self:UpdateTime()
    local frame = curFrame - curRecrd.startFrame
    
    local skillType = BehaviorFunctions.GetDamageParam(FightEnum.DamageInfo.SkillType)
    local entityId = entity.entityId
    curRecrd.entityDamage[entityId] = curRecrd.entityDamage[entityId] or {}
    local damageInfo = curRecrd.entityDamage[entityId]
    local info = {}
    info.entityId = entityId
    info.frame = frame
    info.magicId = magicId
    info.skillType = skillType
    info.damage = damage
    info.elementBreakValue = elementBreakValue or 0

    table.insert(damageInfo, info)
end

function DebugDamagePanel:BuffChanged(intanceId, buffIntanceId, buffId)
    if not self.recording then
        return
    end
    local curRecrd = self.curRecrd
    if not curRecrd.startFrame then
        return
    end
    local entity = BehaviorFunctions.GetEntity(intanceId)
    if not entity or not entity.tagComponent or not entity.tagComponent:IsPlayer() then
        return
    end
    self:RecrdBuff(entity)
end

function DebugDamagePanel:RecrdBuff(entity)
    local entityId = entity.entityId
    local buffIds = entity.buffComponent:GetTotalBuffId()
    for buffId, v in pairs(buffIds) do
        if not BehaviorFunctions.CheckIsBuffByID(entityId, buffId) and
        not BehaviorFunctions.CheckIsDebuffByID(entityId, buffId) then
            buffIds[buffId] = false
        end
    end

    local curFrame = Fight.Instance:GetFrame()
    local frame = curFrame - self.curRecrd.startFrame

    local entityBuff = self.curRecrd.entityBuff
    entityBuff[entityId] = entityBuff[entityId] or {}
    local data = {infos = {}, frame = frame}

    for buffId, v in pairs(buffIds) do
        if v then
            local count = entity.buffComponent:GetBuffCount(buffId)
            local info = {count = count, buffId = buffId}
            if count > 0 then
                data.infos[buffId] = info
            end
        end
    end

    if not next(data.infos) then
        return
    end

    if next(entityBuff[entityId]) then
        local topData = entityBuff[entityId][#entityBuff[entityId]]
        if topData.frame == data.frame then
            entityBuff[entityId][#entityBuff[entityId]] = nil
        end
    end

    table.insert(entityBuff[entityId], data)
end

function DebugDamagePanel:SetCurEntity()
    if not self.recording then
        return
    end
    local curRecrd = self.curRecrd
    if not curRecrd.startFrame then
        return
    end
    local curFrame = Fight.Instance:GetFrame()
    local frame = curFrame - curRecrd.startFrame
    local entityId = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject().entityId
    if entityId == curRecrd.curEntity then
        return
    end
    if curRecrd.curEntity then
        local data = curRecrd.entityState[curRecrd.curEntity]
        data[#data].endFrame = frame
    end

    curRecrd.curEntity = entityId
    curRecrd.entityState[curRecrd.curEntity] = curRecrd.entityState[curRecrd.curEntity] or {}
    local info = {startFrame = frame}
    table.insert(curRecrd.entityState[curRecrd.curEntity], info)
end

local AttrType = {
    Limit = FightEnum.PlayerAttr.Curqteres,
    ExSkill = EntityAttrsConfig.AttrType.ExSkillPoint,
    Skill = EntityAttrsConfig.AttrType.NormalSkillPoint,
}
--记录大招消耗
function DebugDamagePanel:PlayerAttrChange(attrType, newValue, oldValue)

    if not self.recording then
        return
    end
    local curRecrd = self.curRecrd
    if not curRecrd.startFrame then
        return
    end

    if AttrType.Limit ~= attrType then
        return
    end

    if newValue >= oldValue then
        return
    end

    local curFrame = Fight.Instance:GetFrame()
    local frame = curFrame - curRecrd.startFrame
    
    local value = oldValue - newValue
    if curRecrd.curEntity then
        curRecrd.costRecrd[curRecrd.curEntity] = curRecrd.costRecrd[curRecrd.curEntity] or {}
        local data = curRecrd.costRecrd[curRecrd.curEntity]
        data[AttrType.Limit] = data[AttrType.Limit] or {}
        table.insert(data[AttrType.Limit], {value = value, frame = frame})
    end
end

--记录日月相消耗
function DebugDamagePanel:EntityAttrChangeImmediately(entity, attrType, newValue, oldValue)
    if not self.recording then
        return
    end
    local curRecrd = self.curRecrd
    if not curRecrd.startFrame then
        return
    end
    if newValue >= oldValue then
        return
    end
    if attrType ~= AttrType.Skill and attrType ~= AttrType.ExSkill then
        return
    end

    if not entity.tagComponent or not entity.tagComponent:IsPlayer() then
        return
    end

    local curFrame = Fight.Instance:GetFrame()
    local frame = curFrame - curRecrd.startFrame

    local id = entity.entityId
    local value = oldValue - newValue
    curRecrd.costRecrd[id] = curRecrd.costRecrd[id] or {}
    local temp = curRecrd.costRecrd[id]
    temp[attrType] = temp[attrType] or {}
    table.insert(temp[attrType],  {value = value, frame = frame})
end

function DebugDamagePanel:SaveData()
    local res = TableUtils.CopyTable(self.curRecrd)
    res.name = os.date("%H:%M:%S")
    self.records[res.name] = res
    self.curRecrd = nil

    local obj = self:PopUITmpObject("TitleObj", self.LeftContent_rect)
    obj.Select:SetActive(false)
    obj.UnSelect:SetActive(true)
    obj.name = res.name
    obj.Name_txt.text = res.name
    self.recordObjs[res.name] = obj
    obj._btn.onClick:RemoveAllListeners()
    obj._btn.onClick:AddListener(function()
        self:ShowContent(res)
    end)
end

function DebugDamagePanel:ShowContent(data)
    if self.curObj and self.curObj.name == data.name then
        --return
    end
    if self.curObj then
        self.curObj.Select:SetActive(false)
        self.curObj.UnSelect:SetActive(true)
    end

    self.curObj = self.recordObjs[data.name]
    self.curObj.Select:SetActive(true)
    self.curObj.UnSelect:SetActive(false)

    self:PushAllUITmpObject("TeamObj", self.Cache_rect)
    self:PushAllUITmpObject("CurveBar", self.Cache_rect)
    self:PushAllUITmpObject("DamageObj", self.Cache_rect)
    self:PushAllUITmpObject("DamageGorupObj", self.Cache_rect)
    self:PushAllUITmpObject("SkillObj", self.Cache_rect)
    self:PushAllUITmpObject("SkillGorupObj", self.Cache_rect)
    self:PushAllUITmpObject("BuffObj", self.Cache_rect)
    self:PushAllUITmpObject("BuffGorupObj", self.Cache_rect)
    self:PushAllUITmpObject("TimelineObj", self.Cache_rect)
    self:PushAllUITmpObject("TimelineGorupObj", self.Cache_rect)

    self:ShowTeamPart(data)
    self:ShowRolePart(data)
    self:ShowBuffPart(data)
end

function DebugDamagePanel:ShowTeamPart(data)

    local teamReslut = 
    {
        totalDamge = 0,
        totalBreakValue = 0,
        totalFrame = data.lastFrame - data.startFrame,
        entityAreaDamage = {},
        teamAreaDamage = {},
        entityDamageInfo = {},
        totalCost = {},
    }
    local entityAreaDamage = teamReslut.entityAreaDamage
    local entityDamageInfo = teamReslut.entityDamageInfo
    local teamAreaDamage = teamReslut.teamAreaDamage
    --统计伤害
    local maxIndex = 1
    for id, damages in pairs(data.entityDamage) do
        entityAreaDamage[id] = {}
        entityDamageInfo[id] = {totalDamge = 0}
        local index
        for k, damageInfo in pairs(damages) do
            --记录每秒造成的伤害
            local index = math.floor((damageInfo.frame - 1) / FrameRate) + 1
            maxIndex = index > maxIndex and index or maxIndex
            entityAreaDamage[id][index] = entityAreaDamage[id][index] or {total = 0, infos ={}}
            entityAreaDamage[id][index].total = entityAreaDamage[id][index].total + damageInfo.damage
            table.insert(entityAreaDamage[id][index].infos, damageInfo)
            teamAreaDamage[index] = teamAreaDamage[index] or {total = 0, infos ={}}
            teamAreaDamage[index].total = teamAreaDamage[index].total + damageInfo.damage
            table.insert(teamAreaDamage[index].infos, damageInfo)

            entityDamageInfo[id].totalDamge = entityDamageInfo[id].totalDamge + damageInfo.damage
            teamReslut.totalDamge = teamReslut.totalDamge + damageInfo.damage
            teamReslut.totalBreakValue = teamReslut.totalBreakValue + damageInfo.elementBreakValue
        end
    end

    for i = 1, maxIndex, 1 do
        for k, area in pairs(entityAreaDamage) do
            area[i] = area[i] or {total = 0, infos ={}}
        end
        teamAreaDamage[i] = teamAreaDamage[i] or {total = 0, infos ={}}
    end


    --分析站场时间
    for id, states in pairs(data.entityState) do
        for k, state in pairs(states) do
            entityDamageInfo[id] = entityDamageInfo[id] or {}
            entityDamageInfo[id].totalFrame = entityDamageInfo[id].totalFrame or 0
            entityDamageInfo[id].totalFrame = entityDamageInfo[id].totalFrame + (state.endFrame - state.startFrame)
        end
    end

    --统计资源消耗
    for k, v in pairs(AttrType) do
        teamReslut.totalCost[v] = 0
    end
    for id, costs in pairs(data.costRecrd) do
        for attrType, value in pairs(costs) do
            teamReslut.totalCost[attrType] = teamReslut.totalCost[attrType] + value
        end
    end

    data.teamReslut = teamReslut

    local totalTime = teamReslut.totalFrame / FrameRate
    local teamDps = teamReslut.totalDamge / totalTime
    local costs = teamReslut.totalCost

    local res = "累计伤害:%.0f 战斗时间:%.0f秒 DPS:%.0f 累计五行击破:%.0f 日相消耗:%.0f 月相消耗:%.0f 绝技点消耗:%.0f"
    self.TeamResult_txt.text = string.format(res,teamReslut.totalDamge, totalTime, teamDps,
    teamReslut.totalBreakValue, costs[AttrType.Skill], costs[AttrType.ExSkill], costs[AttrType.Limit])

    for id, info in pairs(teamReslut.entityDamageInfo) do
        local obj = self:PopUITmpObject("TeamObj", self.TeamContent_rect)
        local tempTime = info.totalFrame / FrameRate
        local dps = info.totalDamge / tempTime
        local cost = data.costRecrd[id] and data.costRecrd[id][AttrType.Skill] or 0
        obj.BG_canvas.alpha = 0
        obj.Text1_txt.text = id
        obj.Text2_txt.text = string.format("%.0f", info.totalDamge)
        obj.Text3_txt.text = string.format("%0.2f", (info.totalDamge / teamReslut.totalDamge) * 100).."%"
        obj.Text4_txt.text = string.format("%.0f&%0.2f", tempTime, info.totalFrame / teamReslut.totalFrame * 100) .."%"
        obj.Text5_txt.text = string.format("%0.2f", info.totalDamge / tempTime)
        obj.Text6_txt.text = string.format("%.0f", cost or 0)
        self.selectRoleObj = nil
        obj._btn.onClick:RemoveAllListeners()
        obj._btn.onClick:AddListener(function()
            if self.selectRoleObj then
                self.selectRoleObj.BG_canvas.alpha = 0
                if self.selectRoleObj == obj then
                    for k, objInfo in pairs(self.DamageBar) do
                        objInfo.obj.ChildBar_img.fillAmount = 0
                    end
                    self.selectRoleObj = nil
                    return
                end
            end
            self.selectRoleObj = obj
            obj.BG_canvas.alpha = 1
            for i, areaInfo in ipairs(entityAreaDamage[id]) do
                local objInfo = self.DamageBar[i]
                objInfo.obj.ChildBar_img.fillAmount = areaInfo.total / self.maxAreaValue
                local isFront
                if areaInfo.total > 0 then
                    isFront = self:CheckInFront(data.entityState[id], i)
                end

                if isFront then
                    objInfo.obj.ChildBar_canvas.alpha = 1
                else
                    objInfo.obj.ChildBar_canvas.alpha = 0.5
                end
            end
        end)
    end

    self.DamageBar = {}
    self.maxAreaValue = 10
    for i, info in ipairs(teamAreaDamage) do
        self.maxAreaValue = info.total > self.maxAreaValue and info.total or self.maxAreaValue
    end
    for i, info in ipairs(teamAreaDamage) do
        local objInfo = {index = i}
        local obj = self:PopUITmpObject("CurveBar", self.CurveContent_rect)
        obj._img.fillAmount = info.total / self.maxAreaValue
        obj.ChildBar_img.fillAmount = 0
        objInfo.obj = obj
        self.DamageBar[i] = objInfo
    end
end

function DebugDamagePanel:CheckInFront(states, index)
    local endFrame = index * FrameRate - 1
    local startFrame = endFrame - FrameRate + 1

    for i, state in ipairs(states) do
        if startFrame < state.endFrame and startFrame >= state.startFrame then
            return true
        end
        if endFrame <= state.endFrame and endFrame > state.startFrame then
            return true
        end
    end
    return false
end

local SkillTypeP = DmageDebugConfig.SkillTypeP
local M_SkillType = DmageDebugConfig.M_SkillType
local SkillType2M = DmageDebugConfig.SkillType2M
local M_SkillTypeName = DmageDebugConfig.M_SkillTypeName

function DebugDamagePanel:ShowRolePart(data)
    local roleResult = {
        roleDamages = {},
        roleSkills = {},
    }

    local roleDamages = roleResult.roleDamages
    local roleSkills = roleResult.roleSkills
    for id, damages in pairs(data.entityDamage) do
        roleDamages[id] = {}
        for k, damage in pairs(damages) do
            local type = self:GetDamageType(damage.skillType)
            roleDamages[id] = roleDamages[id] or {}
            roleDamages[id][type] = roleDamages[id][type] or 0
            roleDamages[id][type] = roleDamages[id][type] + damage.damage

            local magicId = damage.magicId
            roleSkills[id] = roleSkills[id] or {}
            roleSkills[id][magicId] = roleSkills[id][magicId] or {count = 0, atkCount = 0, type = type, total = 0}
            roleSkills[id][magicId].count = roleSkills[id][magicId].count + 1
            roleSkills[id][magicId].total = roleSkills[id][magicId].total + damage.damage
        end 
    end

    data.roleResult = roleResult

    for id, damages in pairs(roleDamages) do
        local gorup = self:PopUITmpObject("DamageGorupObj", self.DamageContent_rect)
        gorup.EntityId_txt.text = "角色ID:"..id
        local totalDamage = data.teamReslut.entityDamageInfo[id].totalDamge
        for k, type in pairs(M_SkillType) do
            local damage = roleDamages[id][type] or 0
            local obj = self:PopUITmpObject("DamageObj", gorup.Content_rect)
            obj.Text1_txt.text = M_SkillTypeName[type]
            obj.Text2_txt.text = string.format("%.0f", damage)
            obj.Text3_txt.text = string.format("%0.2f", damage / totalDamage * 100).."%"
        end
    end

    for id, skills in pairs(roleSkills) do
        local gorup = self:PopUITmpObject("SkillGorupObj", self.SkillContent_rect)
        gorup.EntityId_txt.text = "角色ID:"..id
        local totalDamage = data.teamReslut.entityDamageInfo[id].totalDamge
        for magicId, skill in pairs(skills) do
            local obj = self:PopUITmpObject("SkillObj", gorup.Content_rect)
            obj.Text1_txt.text = magicId
            obj.Text2_txt.text = skill.count
            obj.Text3_txt.text = M_SkillTypeName[skill.type]
            obj.Text4_txt.text = "/"
        end
    end
end

function DebugDamagePanel:GetDamageType(skillType)
    for i, types in ipairs(SkillTypeP) do
        for k, type in pairs(types) do
            if BehaviorFunctions.AnalyseSkillType(skillType, type) then
                return SkillType2M[type]
            end
        end
    end
    return M_SkillType.Other
end

function DebugDamagePanel:ShowBuffPart(data)
    local entityBuff = data.entityBuff
    local entityDamage = data.entityDamage
    local teamReslut = data.teamReslut

    local resultBuff = {}
    local buffTimes = {
        buffLine = {}, 
        timeline = {},
        times = {}
    }

    for id, entityBuffs in pairs(entityBuff) do
        buffTimes.times[id] = {}
        buffTimes.buffLine[id] = {}
        local curBuff = {}
        for i, buffInfo in ipairs(entityBuffs) do
            for _, info in pairs(buffInfo.infos) do
                if not curBuff[info.buffId] then
                    curBuff[info.buffId] = {startFrame = buffInfo.frame, buffId = info.buffId}
                end
            end
            for buffId, v in pairs(curBuff) do
                if not buffInfo.infos[buffId] then
                    v.endFrame = buffInfo.frame
                    local total = v.endFrame - v.startFrame
                    buffTimes.times[id][buffId] = buffTimes.times[id][buffId] or 0
                    buffTimes.times[id][buffId] = buffTimes.times[id][buffId] + total

                    buffTimes.buffLine[id][buffId] = buffTimes.buffLine[id][buffId] or {}
                    table.insert(buffTimes.buffLine[id][buffId], {startFrame = v.startFrame, endFrame = v.endFrame})
                    curBuff[buffId] = nil
                end
            end
        end

        local totalTime = math.floor(teamReslut.totalFrame / FrameRate)
        buffTimes.timeline[id] = {}
        for i = 1, totalTime, 1 do
            local buffInfo = self:GetBuffDataByIndex(entityBuffs, i)
            if buffInfo then
                buffTimes.timeline[id][i] = buffInfo.infos
            end
        end
    end

    for id, _ in pairs(entityDamage) do
        local gorup = self:PopUITmpObject("BuffGorupObj", self.BuffContent_rect)
        gorup.EntityId_txt.text = "角色ID:"..id
        if next(buffTimes.times[id]) then
            for buffId, totalFrame in pairs(buffTimes.times[id]) do
                local obj = self:PopUITmpObject("BuffObj", gorup.Content_rect)
                obj.Text1_txt.text = buffId
                obj.Text2_txt.text = string.format("%0.2f", totalFrame / FrameRate)
            end
        end
    end

    for id, _ in pairs(entityDamage) do
        local gorup = self:PopUITmpObject("TimelineGorupObj", self.TimelineContent_rect)
        gorup.EntityId_txt.text = "角色ID:"..id
        self:ShowTimelineV1(id, gorup, teamReslut, buffTimes)
        --self:ShowTimelineV2(id, gorup, entityBuff[id])
    end
end

function DebugDamagePanel:ShowTimelineV1(id, gorup, teamReslut, buffTimes)
    local totalTime = math.floor(teamReslut.totalFrame / FrameRate)
    for i = 1, totalTime, 1 do
        local obj = self:PopUITmpObject("TimelineObj", gorup.Content_rect)
        obj.Text1_txt.text = i
        obj.Text2_txt.text = ""
        if next(buffTimes.timeline[id]) and next(buffTimes.timeline[id][i]) then
            local res = ""
            for k, info in pairs(buffTimes.timeline[id][i]) do
                res = string.format("%s  %s&%s", res, info.buffId, info.count)
            end
            obj.Text2_txt.text = res
        end
    end
end

function DebugDamagePanel:ShowTimelineV2(id, gorup, buffs)
    for i = 1, #buffs - 1, 1 do
        local obj = self:PopUITmpObject("TimelineObj", gorup.Content_rect)
        local infos = buffs[i].infos
        local res = ""
        for k, info in pairs(infos) do
            res = string.format("%s  %s&%s", res, info.buffId, info.count)
        end
        obj.Text1_txt.text = string.format("%0.2f ~ %0.2f", buffs[i].frame / FrameRate, buffs[i + 1].frame / FrameRate)
        obj.Text2_txt.text = res
    end
end

function DebugDamagePanel:GetBuffDataByIndex(entityBuffs, index)
    local endFrame = index * FrameRate - 1

    for i, buffInfo in ipairs(entityBuffs) do
        if buffInfo.frame > endFrame then
            local res = i - 1
            return entityBuffs[res]
        end
    end

    return entityBuffs[#entityBuffs]
end


function DebugDamagePanel:OnClick_Team()
    self.showTeam = self.showTeam == nil and true or self.showTeam
    self.showTeam = not self.showTeam
    self.TeamBG:SetActive(self.showTeam)
    self.TeamGorup:SetActive(self.showTeam)
end

function DebugDamagePanel:OnClick_Curve()
    self.showCurve = self.showCurve == nil and true or self.showCurve
    self.showCurve = not self.showCurve
    self.CurveBG:SetActive(self.showCurve)
    self.CurveGorup:SetActive(self.showCurve)
end

function DebugDamagePanel:OnClick_Role()
    self.showRole = self.showRole == nil and true or self.showRole
    self.showRole = not self.showRole
    self.RoleBG:SetActive(self.showRole)
    self.RoleGorup:SetActive(self.showRole)
end

function DebugDamagePanel:OnClick_Buff()
    self.showBuff = self.showBuff == nil and true or self.showBuff
    self.showBuff = not self.showBuff
    self.BuffBG:SetActive(self.showBuff)
    self.BuffGorup:SetActive(self.showBuff)
end