LevelGuideManager = BaseClass("LevelGuideManager")

function LevelGuideManager:__init(fight)
    self.marksMap = {}
    self.removeQueue = {}
    self.fight = fight
end

function LevelGuideManager:__delete()
    EventMgr.Instance:RemoveListener(EventName.MarkUpdate, self:ToFunc("MarkUpdate"))
    EventMgr.Instance:RemoveListener(EventName.WorldMapCtrlEntityLoadDone, self:ToFunc("InitComplete"))
end

function LevelGuideManager:StartFight()
    if mod.WorldMapCtrl:CheckWorldEntityInitDone() then
        self:InitComplete()
    end
    EventMgr.Instance:AddListener(EventName.MarkUpdate, self:ToFunc("MarkUpdate"))
    EventMgr.Instance:AddListener(EventName.WorldMapCtrlEntityLoadDone, self:ToFunc("InitComplete"))
end

function LevelGuideManager:InitComplete()
    local mapId = mod.WorldMapCtrl:GetCurMap()
    local marks = mod.WorldMapCtrl:GetMapMark(mapId) or {}

    for k, v in pairs(marks) do
        for instanceId, _ in pairs(v) do
            local mark = mod.WorldMapCtrl:GetMark(instanceId)
            if mark.jumpCfg then
                self:AddMark(instanceId)
            end
        end
    end
    self.mapId = mapId
    self.isActive = true
end

function LevelGuideManager:Update()
    if not self.isActive then return end
    -- if not Fight.Instance.playerManager then return end
	local lodCenter = Fight.Instance.playerManager:GetPlayer():GetCtrlEnityPosition()
    for k, v in pairs(self.removeQueue) do
        if not v:IsLoading() then
            self:PushObject(v)
            self.removeQueue[k] = nil
        end
    end
    for k, v in pairs(self.marksMap) do
        v:Update(lodCenter)
    end
end

function LevelGuideManager:MarkUpdate(markOpera, markInstance)
    if not self.isActive then return end
    if markOpera == WorldEnum.MarkOpera.Add then
        local mark = mod.WorldMapCtrl:GetMark(markInstance)
        --if mark.map ~= self.mapId then return end
        if mark.jumpCfg then
            self:AddMark(markInstance, true)
        end
    elseif markOpera == WorldEnum.MarkOpera.Refresh then
        self:MarkChanged(markInstance)
    elseif markOpera == WorldEnum.MarkOpera.Remove then
        self:RemoveMark(markInstance)
    end
end

function LevelGuideManager:MarkChanged(markInstance)
    if self.marksMap[markInstance] then
        self.marksMap[markInstance]:MarkChanged()
    end
end

function LevelGuideManager:AddMark(instanceId, isNew)
    if self.marksMap[instanceId] then
        LogError("重复添加指引:"..instanceId)
        return
    end
    local obj = self:PopObject()
    obj:Init(instanceId, isNew)
    self.marksMap[instanceId] = obj
end

function LevelGuideManager:RemoveMark(instanceId)

    if not self.marksMap[instanceId] then return end
    self.removeQueue[instanceId] = self.marksMap[instanceId]
    self.marksMap[instanceId] = nil
end

function LevelGuideManager:PopObject()
    return Fight.Instance.objectPool:Get(LevelGuideSingle)
end

function LevelGuideManager:PushObject(object)
    Fight.Instance.objectPool:Cache(LevelGuideSingle, object)
end