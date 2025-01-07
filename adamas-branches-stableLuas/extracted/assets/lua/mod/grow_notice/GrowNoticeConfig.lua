GrowNoticeConfig = GrowNoticeConfig or {}

GrowNoticeConfig.NoticeMap = {
    [GrowNoticeEnum.RoleState] = {
        eventList = {
            EventName.RoleLevUpEnd,
            EventName.RoleStageUpEnd,
            EventName.ItemRecv,
        },
        checkFunc = function()
            Fight.Instance.growNoticeManager:UpdateRoleState()
        end
    },
    [GrowNoticeEnum.Weapon] = {
        eventList = {
            EventName.RoleWeaponChangeEnd,
            EventName.ItemRecv,
        },
        checkFunc = function()
            Fight.Instance.growNoticeManager:UpdateWeapon()
        end
    },
    [GrowNoticeEnum.WeaponState] = {
        eventList = {
            EventName.RoleWeaponLevUpEnd,
            EventName.RoleWeaponStageUpEnd,
            EventName.RoleWeaponChangeEnd,
            EventName.ItemRecv,
        },
        checkFunc = function()
            Fight.Instance.growNoticeManager:UpdateWeaponState()
        end
    },
    [GrowNoticeEnum.Partner] = {
        eventList = {
            EventName.RolePartnerChangeEnd,
            EventName.ItemRecv,
        },
        checkFunc = function()
            Fight.Instance.growNoticeManager:UpdatePartner()
        end
    },
    [GrowNoticeEnum.RoleSkillUp] = {
        eventList = {
            EventName.RoleSkillUpEnd,
            EventName.ItemRecv,
        },
        checkFunc = function()
            Fight.Instance.growNoticeManager:UpdateRoleSkillUp()
        end
    },
    [GrowNoticeEnum.RolePeriod] = {
        eventList = {
            EventName.RoleInfoUpdate,
            EventName.ItemRecv,
        },
        checkFunc = function()
            Fight.Instance.growNoticeManager:UpdateRolePeriod()
        end
    },
    [GrowNoticeEnum.RoleTalent] = {
        eventList = {
            EventName.RoleInfoUpdate,
            EventName.ItemRecv,
        },
        checkFunc = function()
            Fight.Instance.growNoticeManager:UpdateRoleTalent()
        end
    },
}

