RedPointConfig = RedPointConfig or {}

RedPointConfig.RootMap = 
{
    [RedPointName.SystemMenu] = {
        childs =
        {
            RedPointName.Task,
            RedPointName.Adv,
            RedPointName.Teach,
            RedPointName.AdvLimit,
            RedPointName.Role,
            --RedPointName.RoleList,
            RedPointName.Announcement,
            RedPointName.Mail,
            RedPointName.Purchase,
            RedPointName.Friend,
            RedPointName.UnReadChat,
            RedPointName.Activity,
            RedPointName.Identity,
            RedPointName.RoGue,
            RedPointName.Message,
        },
        eventList = {},
        checkFunc = nil,
        checkSystemOpenFunc = function()
            return true
        end
    },
    [RedPointName.RoleList] = {
        childs = {},
        eventList = {
            EventName.RoleInfoUpdate
        }, 
        checkFunc = function()
            return mod.RoleCtrl:CheckRoleListRedPoint()
        end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Role)
        end
    },
    
    [RedPointName.AssetTask] = 
    {
        childs = {},
        eventList = {
            EventName.SystemTaskUpdateComplete,
            EventName.SystemTaskUpdate,
            EventName.EnterAsset,
            EventName.SystemTaskAccept,
        },
        checkFunc = function ()
            return mod.AssetTaskCtrl:CheckAssetTaskRedPoint()
        end,
        checkSystemOpenFunc = function()
            return mod.AssetPurchaseCtrl:GetCurAssetId() ~= nil
        end
    }
}

RedPointConfig.ChildMap = 
{
    [RedPointName.Role] = {
        childs = {},
        eventList = {
            EventName.GetRole,
            EventName.RoleInfoUpdate,
            EventName.ItemRecv,
        }, 
        checkFunc = function()
            return mod.RoleCtrl:CheckRoleRedPoint()
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
            RedPointName.UpdateDailyRewardInfo,
        },
        eventList = {},
        checkFunc = nil,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.MaoXian)
        end
    },
    [RedPointName.Activity] = {
        childs =
        {
        },
        eventList = {},
        checkFunc = nil,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.HuoDong)
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
            EventName.UpdateDailyRewardInfo
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

    [RedPointName.Announcement] = {
        childs = {
            RedPointName.AnnouncementActiveLab,
            RedPointName.AnnouncementGameLab
        },
        eventList = {},
        checkFunc = nil,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Announcement)
        end
    },

    [RedPointName.AnnouncementGameLab] = {
        childs = {},
        eventList = {
            EventName.AnnouncementRefresh,
        },
        checkFunc = function()
            return mod.AnnouncementCtrl:CheckGameLabRedPoint()
        end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Announcement)
        end
    },

    [RedPointName.AnnouncementActiveLab] = {
        childs = {},
        eventList = {
            EventName.AnnouncementRefresh,
        },
        checkFunc = function()
            return mod.AnnouncementCtrl:CheckActiveLabRedPoint()
        end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Announcement)
        end
    },

    [RedPointName.Mail] = {
        childs = {},
        eventList = {
            EventName.MailRefresh,
            EventName.MailRead,
            EventName.MailGetAward,
        },
        checkFunc = function()
            return mod.MailCtrl:MailRedPoint()
        end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.EMail)
        end
    },
    [RedPointName.Purchase] = {
        childs = {
            RedPointName.PurchasePackage,
            RedPointName.PurchaseExchange,
            RedPointName.PurchaseRecommend,
            RedPointName.PurchaseRecharge,
            RedPointName.PurchaseSkin,
        },
        eventList = {
        },
        checkFunc = nil,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.ShangCheng)
        end
    },
    [RedPointName.PurchaseExchange] = {
        childs = {
        },
        eventList = {
        },
        checkFunc = nil,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Exchanage)
        end
    },
    [RedPointName.PurchaseRecommend] = {
        childs = {
        },
        eventList = {
        },
        checkFunc = nil,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Monthcard)
        end
    },
    [RedPointName.PurchaseRecharge] = {
        childs = {
        },
        eventList = {
        },
        checkFunc = nil,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.ChongZhi)
        end
    },
    [RedPointName.PurchasePackage] = {
        childs = {
            RedPointName.PurchasePackagePageRMB,
            RedPointName.PurchasePackagePageDaily,
            RedPointName.PurchasePackagePageLevel,
        },
        eventList = {
        },
        checkFunc = nil,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.LiBao)
        end
    },
    [RedPointName.PurchaseSkin] = {
        childs = {
        },
        eventList = {
        },
        checkFunc = nil,
        checkSystemOpenFunc = function()
            -- 后续加皮肤商城后改
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.ShangCheng)
        end
    },
    [RedPointName.PurchasePackagePageRMB] = {
        childs = {},
        eventList = {
            EventName.GetPurchasePackage,
        },
        checkFunc = function()
            return mod.PurchaseCtrl:CheckRedPointByPage(PurchaseConfig.PackagePage[1].id)
        end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.LiBao)
        end
    },
    [RedPointName.PurchasePackagePageDaily] = {
        childs = {},
        eventList = {
            EventName.GetPurchasePackage,
        },
        checkFunc = function()
            return mod.PurchaseCtrl:CheckRedPointByPage(PurchaseConfig.PackagePage[2].id)
        end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.LiBao)
        end
    },
    [RedPointName.PurchasePackagePageLevel] = {
        childs = {},
        eventList = {
            EventName.GetPurchasePackage,
        },
        checkFunc = function()
            return mod.PurchaseCtrl:CheckRedPointByPage(PurchaseConfig.PackagePage[3].id)
        end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.LiBao)
        end
    },
    [RedPointName.Task] = {
        childs = {
            RedPointName.TaskChapter
        },
        eventList = {},
        checkFunc = nil,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Task)
        end
    },
    [RedPointName.TaskChapter] = {
        childs = {},
        eventList = {
            EventName.TaskRewardRed
        },
        checkFunc = function()
            return mod.TaskCtrl:CheckTaskChapterIsRed()
        end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Task)
        end
    },
    [RedPointName.Friend] = {
        childs = {
            RedPointName.FriendRequest
        },
        eventList = {},
        checkFunc = nil,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Friend)
        end
    },
    [RedPointName.FriendRequest] = {
        childs = {},
        eventList = {
            EventName.FriendListRefresh
        },
        checkFunc = function()
            return mod.FriendCtrl:CheckFriendRedPoint()
        end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Friend)
        end
    },
    [RedPointName.UnReadChat] = {
        childs = {},
        eventList = {
            EventName.ChatListRefresh,
            EventName.ChatRedPointRefresh,
        },
        checkFunc = function()
            return mod.FriendCtrl:CheckUnReadRedPointState()
        end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Friend)
        end
    },
    [RedPointName.Identity] = {
        childs = {},
        eventList = {
            EventName.IdentityLvChange,
            EventName.IdentitRewardRefresh
        },
        checkFunc = function()
            return mod.IdentityCtrl:CheckIdentityRedPoint()
        end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Identity)
        end
    },
    [RedPointName.RoGue] = {
        childs = {
            RedPointName.RoGueReward,
            RedPointName.RoGueEvolution,
            RedPointName.RoGueBless,
        },
        eventList = {},
        checkFunc = nil,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Rogue)
        end
    },
    [RedPointName.RoGueReward] = {
        childs = {},
        eventList = {
            EventName.CheckRogueRed,
        },
        checkFunc = function()
            return mod.RoguelikeCtrl:CheckRogueRewardRedPoint()
        end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Rogue)
        end
    },
    [RedPointName.RoGueEvolution] = {
        childs = {},
        eventList = {
            EventName.CheckRogueRed,
        },
        checkFunc = function()
            return mod.RoguelikeCtrl:CheckRogueEvolutionRedPoint()
        end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Rogue)
        end
    },
    [RedPointName.RoGueBless] = {
        childs = {},
        eventList = {
            EventName.CheckRogueRed,
        },
        checkFunc = function()
            return mod.RoguelikeCtrl:CheckRogueBlessRedPoint()
        end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Rogue)
        end
    },
    [RedPointName.Message] = {
        childs =
        {
            
        },
        eventList = {
            
        },
        checkFunc = function()
            return mod.MessageCtrl:CheckNewMessageRed()
        end,
        checkSystemOpenFunc = function()
            return Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Message)
        end
    }
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