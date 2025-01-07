SystemCtrl = BaseClass("SystemCtrl",Controller)

local DataSystemOpen = Config.DataSystemOpen.data_system_open

function SystemCtrl:__init()
    self.sucSystemIdMap = {}
    self.noSucSystemIdMap = {}
    self.isInit = false
end

function SystemCtrl:Update()

end

function SystemCtrl:GetNoSucSystemIdMap()
    return self.noSucSystemIdMap
end

function SystemCtrl:OnRecv_SystemInitData(idMap)
    for _, val in pairs(idMap) do
        self.sucSystemIdMap[val] = true
        self.noSucSystemIdMap[val] = nil
    end

    if not self.isInit then
        for id, cfg in pairs(DataSystemOpen) do
            if not self.sucSystemIdMap[id] and cfg.condition ~= 0 then
                self.noSucSystemIdMap[id] = true
            end
        end
        self.isInit = true
    end
end

function SystemCtrl:IsShowSystemOpenPnl(systemId)
    return self.sucSystemIdMap[systemId]
end
