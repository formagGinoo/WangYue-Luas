RedPointConfig = RedPointConfig or {}

RedPointConfig.RootMap = 
{
    [RedPointName.SystemMenu] = {
        childs =
        {
            RedPointName.Adv,
            RedPointName.Teach,
            RedPointName.AdvLimit,
            RedPointName.Role,
            RedPointName.RoleList,
        },
        eventList = {},
        checkFunc = nil,
        checkSystemOpenFunc = function()
            return true
        end
    },
}

RedPointConfig.ChildMap = 
{
    [RedPointName.Role] = {
        childs = {},
        eventList = {}, 
        checkFunc = function()
            return mod.RoleCtrl:CheckRoleRedPoint()
        end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Role)
        end
    },
    [RedPointName.RoleList] = {
        childs = {},
        eventList = {}, 
        checkFunc = function()
            return mod.RoleCtrl:CheckRoleListRedPoint()
        end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Role)
        end
    },
    [RedPointName.Teach] = {
        childs = 
        {
            RedPointName.TeachReward
        },
        eventList = {}, 
        checkFunc = nil,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Teach)
        end
    },
    [RedPointName.TeachReward] = {
        childs = {},
        eventList = {
            EventName.AddTeach,
            EventName.RetTeachLookReward,
        }, 
        checkFunc = function()
            return mod.TeachCtrl:CheckCanGetReward()
        end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Teach)
        end
    },
    [RedPointName.Adv] = {
        childs =
        {
            RedPointName.WorldLev,
            RedPointName.DailyActivity,
            RedPointName.MercenaryRankReward,
        },
        eventList = {},
        checkFunc = nil,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.MaoXian)
        end
    },
    [RedPointName.WorldLev] = {
        childs = 
        {
            RedPointName.WorldLevTask,
            RedPointName.WorldLevBreak,
        },
        eventList = {},
        checkFunc = nil,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.WorldLevel)
        end
    },

    [RedPointName.WorldLevBreak] = {
        childs = {},
        eventList = {
            EventName.SystemTaskUpdateComplete,
            EventName.SystemTaskUpdate,
            EventName.WorldLevelChange,
        },
        checkFunc = function ()
            return mod.WorldLevelCtrl:CheckWorldLevBreak()
        end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.WorldLevel)
        end
    },

    [RedPointName.WorldLevTask] = {
        childs = {},
        eventList = {
            EventName.SystemTaskUpdateComplete,
            EventName.SystemTaskUpdate,
        },
        checkFunc = function ()
            return mod.WorldLevelCtrl:CheckWorldLevFinish()
        end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.WorldLevel)
        end
    },
	
	[RedPointName.DailyActivity] = {
		childs =
		{
			RedPointName.DailyTask,
			RedPointName.DailyReward
		},
		eventList = {},
		checkFunc = nil,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.ShiMaiLieShou)
        end
	},
	
	[RedPointName.DailyTask] = {
		childs = {},
		eventList = {
            EventName.SystemTaskUpdateComplete,
            EventName.SystemTaskUpdate,
		},
		checkFunc = function ()
			return mod.DailyActivityCtrl:CheckTaskCanFinish()
		end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.ShiMaiLieShou)
        end
	},

	[RedPointName.DailyReward] = {
		childs = {},
		eventList = {
			EventName.UpdateDailyActivity,
		},
		checkFunc = function ()
			return mod.DailyActivityCtrl:CheckCanGetReward()
		end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.ShiMaiLieShou)
        end
	},

    [RedPointName.MercenaryRankReward] = {
        childs = {},
        eventList = {
            EventName.UpdateMercenaryRankVal,
            EventName.GetRankReward,
        },
        checkFunc = function ()
            return mod.MercenaryHuntCtrl:CheckCanGetRankReward()
        end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.ShiMaiLieShou)
        end
    },

    [RedPointName.AdvLimit] = {
        childs = {},
        eventList = {
            EventName.AdventureChange,
        },
        checkFunc = function ()
            return mod.WorldLevelCtrl:CheckAdvLevLimit()
        end,
        checkSystemOpenFunc = function()
            return true
        end
    },
}

function RedPointConfig.GetNodeData(id)
    if RedPointConfig.RootMap[id] then
        return RedPointConfig.RootMap[id]
    elseif RedPointConfig.ChildMap[id] then
        return RedPointConfig.ChildMap[id]
    else
        LogError("索引不存在的红点信息", id)
    end
end