LevelGuideSingle = BaseClass("LevelGuideSingle", PoolBaseClass)

local GuideEntityState = 
{
    None = 0,
    Far = 1,
    Near = 2,
}

function LevelGuideSingle:__init()
    
end

function LevelGuideSingle:__cache()
    self:UnLoad()
    if self.loaded then
        
    end
end

function LevelGuideSingle:Init(instanceId, isNew)
    local mark = mod.WorldMapCtrl:GetMark(instanceId)
    local data = {}
    data.instanceId = instanceId
    data.isTrace = mark.inTrace
    local jumpCfg = mark.jumpCfg
    data.needAutoTrace = jumpCfg.find_tips and jumpCfg.tracking_time > 0 --是否需要自动追踪
    data.autoTraced = false
    data.findDis = jumpCfg.find_tips_dis ^ 2
    data.autoTraceing = false --是否处于自动追踪
    data.traceTime = 0 -- 追踪时间
    if jumpCfg.tracking_entity_far ~= 0 then
        data.farEntity = jumpCfg.tracking_entity_far
        data.disFar = jumpCfg.tracking_dis_far ^ 2
    end
    if jumpCfg.tracking_entity_near ~= 0 then
        data.nearEntity = jumpCfg.tracking_entity_near
        data.disNear = jumpCfg.tracking_dis_near ^ 2
    end

    self.loaded = false
    self.isLoading = false
    self.guideState = GuideEntityState.None

    self.guideData = data
    self:InitComplete(mark)
end

function LevelGuideSingle:InitComplete(mark)
    -- local jumpCfg = mark.jumpCfg
    -- local traceTime = jumpCfg.tracking_time
    -- if self.guideData.autoTraceing then
    --     if traceTime and traceTime > 0 then
    --         self.guideData.isTrace = true
    --         self.guideData.traceTime = traceTime
    --         self:StartTrace()
    --     else
    --         self.guideData.autoTraceing = false
    --     end
    -- end
end

function LevelGuideSingle:Update(lodCenter)
    local data = self.guideData
    local markInstance = data.instanceId
    local mark = mod.WorldMapCtrl:GetMark(markInstance)

    local diatance = (mark.position.x - lodCenter.x) ^ 2 + (mark.position.y - lodCenter.y) ^ 2 + (mark.position.z - lodCenter.z) ^ 2
    if data.needAutoTrace then --是否需要提示
        if data.findDis >= diatance then
            if not data.autoTraced then
                data.autoTraced = true
                self:StartTrace()
            end
        else
            if data.autoTraced then
                --data.autoTraced = false
            end
        end
    end

    if data.autoTraceing then
        data.traceTime = data.traceTime - FightUtil.deltaTimeSecond
        if data.traceTime < 0 then
            self:StopTrace() --新添加时显示几秒钟
        end
    end
    if not data.disFar and not data.disNear then return end


    local maxDis = data.disFar or data.disNear
    if self.loaded and maxDis * 2 < diatance then
        self:ChangeState(GuideEntityState.None)
        self:UnLoad()
    end
    if maxDis < diatance then return end
    if not self.loaded then
        if not self.isLoading then
            self:Load()
        end
        return
    end
    
    if data.disFar and data.disNear then
        if data.disFar >= diatance and data.disNear < diatance then
            self:ChangeState(GuideEntityState.Far)
            return
        end
    end
    if data.disNear and data.disNear >= diatance then
        self:ChangeState(GuideEntityState.Near)
        return
    end
end

function LevelGuideSingle:ChangeState(state)
    if self.guideState == state then return end
    local instanceId = self.guideData.instanceId
    local data = self.guideData
    local mark = mod.WorldMapCtrl:GetMark(instanceId)
    local pos = mark.position

    if state == GuideEntityState.None then
        if self.farEntity then
            BehaviorFunctions.RemoveEntity(self.farEntity)
            self.farEntity = nil
        end
        if self.nearEntity then
            BehaviorFunctions.RemoveEntity(self.nearEntity)
            self.nearEntity = nil
        end
    elseif state == GuideEntityState.Near then
        if not self.nearEntity then
            self.nearEntity = BehaviorFunctions.CreateEntity(data.nearEntity, nil, pos.x, pos.y, pos.z)
        end
        if self.farEntity then
            BehaviorFunctions.RemoveEntity(self.farEntity)
            self.farEntity = nil
        end
    elseif state == GuideEntityState.Far then
        if not self.farEntity then
            self.farEntity = BehaviorFunctions.CreateEntity(data.farEntity, nil, pos.x, pos.y, pos.z)
        end
    end
    
    self.guideState = state
end

function LevelGuideSingle:MarkChanged()
    local instanceId = self.guideData.instanceId
    local data = self.guideData
    local mark = mod.WorldMapCtrl:GetMark(instanceId)
    local isTrace = mark.inTrace or data.autoTraceing
    if self.guideData.isTrace ~= isTrace then
        self.guideData.isTrace = isTrace
        if isTrace then self:StopTrace() end
    end
end

function LevelGuideSingle:Load()
    local assetsNodeManager = Fight.Instance.clientFight.assetsNodeManager
    local data = self.guideData
    local loadCount = 1
    self.isLoading = true
    local function loadDone()
        loadCount = loadCount - 1
        if loadCount == 0 then
            self:LoadDone()
        end
    end

    if data.farEntity then
        loadCount = loadCount + 1
        assetsNodeManager:LoadEntity(data.farEntity, loadDone)
    end
    if data.nearEntity then
        loadCount = loadCount + 1
        assetsNodeManager:LoadEntity(data.nearEntity, loadDone)
    end
    loadDone()
end

function LevelGuideSingle:LoadDone()
    self.loaded = true
    self.isLoading = false
end

function LevelGuideSingle:UnLoad()
    self:StopTrace()
    if self.farEntity then
        BehaviorFunctions.RemoveEntity(self.farEntity)
        self.farEntity = nil
    end
    if self.nearEntity then
        BehaviorFunctions.RemoveEntity(self.nearEntity)
        self.nearEntity = nil
    end
    if not self.loaded then return end
    local assetsNodeManager = Fight.Instance.clientFight.assetsNodeManager
    local data = self.guideData
    if data.farEntity then
        assetsNodeManager:UnloadEntity(data.farEntity)
    end
    if data.nearEntity then
        assetsNodeManager:UnloadEntity(data.nearEntity)
    end
    self.loaded = false
end

function LevelGuideSingle:StartTrace()
    local mark = mod.WorldMapCtrl:GetMark(self.guideData.instanceId)
    self.guideData.autoTraceing = true --是否处于临时追踪
    local jumpCfg = mark.jumpCfg
    local traceTime = jumpCfg.tracking_time
    self.guideData.traceTime = traceTime

    if mark.type == FightEnum.MapMarkType.Ecosystem then
        local ecoId = mark.ecoCfg.id
    else
        local pos = mark.position
    end
    --没有追踪的话，添加追踪点
    if not self.guideData.isTrace then
        local extraSetting = { guideType = FightEnum.GuideType.Custom,  guideIcon = mark.icon}
        self.guidePoint = Fight.Instance.clientFight.fightGuidePointerManager:AddGuidePosition(mark.position, nil, extraSetting)
    end
    --Log("添加追踪点", self.guidePoint)
    --显示提示
    EventMgr.Instance:Fire(EventName.LevelMarkActive, mark.jumpCfg.jump_id)
end

function LevelGuideSingle:StopTrace()
    if self.guideData.autoTraceing then
        self.guideData.autoTraceing = false
        --移除追踪点
        if self.guidePoint then
            Fight.Instance.clientFight.fightGuidePointerManager:RemoveGuide(self.guidePoint)
            --Log("移除追踪点", self.guidePoint)
            self.guidePoint = nil
        end
    end
end

function LevelGuideSingle:IsLoading()
    return self.isLoading
end