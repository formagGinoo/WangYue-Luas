---@class BuildCtrl
BuildCtrl = BaseClass("BuildCtrl", Controller)

function BuildCtrl:__init()
    self.unlock_build_list = {}
    self.unlock_progress_list = {}

    self.unlock_blueprint_list = {}
    self.custom_blueprint_list = {}
    self.needBuildLimitTip = true

    self.build_use_time = {}
    self.build_use_history = {}
end

function BuildCtrl:OnEnterMap()

end

function BuildCtrl:__InitComplete()
end

--蓝图是否解锁
function BuildCtrl:IsBuildUnLock(buildId)
    return TableUtils.ContainValue(self.unlock_build_list, buildId)
end

function BuildCtrl:AddPreBlueprint(unlock_list)
    for k, v in pairs(unlock_list) do
        table.insert(self.unlock_blueprint_list, v)
    end
end

function BuildCtrl:AddCustomBlueprint(customList)
    for k, v in pairs(customList) do
        table.sort(v.nodes, function(a, b) return a.index < b.index end)
        table.insert(self.custom_blueprint_list, v)
    end
end

function BuildCtrl:SetUseTime(use_time)
    for k, v in pairs(use_time) do
        self.build_use_time[k] = v
    end
end

function BuildCtrl:AddUseTime(buildId)
    if not self.build_use_time[buildId] then
        self.build_use_time[buildId] = 0
    end
    self.build_use_time[buildId] = self.build_use_time[buildId] + 1
end

function BuildCtrl:SetUseHistory(use_time)
    for k, v in pairs(use_time) do
        self.build_use_history[k] = v
    end
end

function BuildCtrl:UpdateUseHistory(buildId)
    self.build_use_history[buildId] = os.time()
end

function BuildCtrl:DeleteBluePrint(blueprint_id, callback)
    local id, cmd = mod.BuildFacade:SendMsg("blueprint_custom_delete",blueprint_id)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function()
        for k, v in pairs(self.custom_blueprint_list) do
            if v.blueprint_id == blueprint_id then
                table.remove(self.custom_blueprint_list, k)
                break
            end
        end
        callback()
    end)
end

function BuildCtrl:SaveBluePrint(data)
    table.sort(data.nodes, function(a, b) return a.index < b.index end)
    local id, cmd = mod.BuildFacade:SendMsg("blueprint_custom_save", data)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function()
        table.insert(self.custom_blueprint_list, data)
    end)
end

function BuildCtrl:GetBluePrintConfig(id)
    for k, v in pairs(self.custom_blueprint_list) do
        if v.blueprint_id == id then
            return v
        end
    end
end

function BuildCtrl:__delete()

end
