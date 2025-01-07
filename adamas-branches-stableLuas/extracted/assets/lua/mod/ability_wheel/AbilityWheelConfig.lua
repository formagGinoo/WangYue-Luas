AbilityWheelConfig = AbilityWheelConfig or {}

local DataAbilityMain = Config.DataAbilityMain.Find
local DataAbilityMainBySkillType = Config.DataAbilityMain.FindbySkillType
local DataAbilityMainLength = Config.DataAbilityMain.FindLength

AbilityWheelConfig.PartnerConcludeId = 401

AbilityWheelConfig.StartActiveLinkPos = 1
AbilityWheelConfig.MaxActiveLinkNum = 8
AbilityWheelConfig.EndActiveLinkPos = AbilityWheelConfig.StartActiveLinkPos + AbilityWheelConfig.MaxActiveLinkNum - 1

AbilityWheelConfig.StartPassiveLinkPos = 101
AbilityWheelConfig.MaxPassiveLinkNum = 3
AbilityWheelConfig.EndPassiveLinkPos = AbilityWheelConfig.StartPassiveLinkPos + AbilityWheelConfig.MaxPassiveLinkNum - 1

AbilityWheelConfig.WheelUseFuntion = 
{
    [AbilityWheelEnum.AbilityType.Photo] = function()
        mod.PhotoCtrl:OpenPhoto()
        return true
    end,
    [AbilityWheelEnum.AbilityType.Car] = function()
        WindowManager.Instance:OpenWindow(CallVehicleWindow)
        return true
    end,
    [AbilityWheelEnum.AbilityType.Conclude] = function()
        -- WindowManager.Instance:OpenWindow(CallVehicleWindow)
        -- print("点击了缔结")
        return BehaviorFunctions.fight.partnerManager:OnClikcConcludeBtn()
    end, 
}

function AbilityWheelConfig.SystemOpenCallback(linkId)
    local abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)
    if AbilityWheelConfig.WheelUseFuntion[abilityInfo.type] then
        return AbilityWheelConfig.WheelUseFuntion[abilityInfo.type]
    else
        return function ()
            MsgBoxManager.Instance:ShowTips("功能未支持")
            return false
        end
    end
end

function AbilityWheelConfig.GetWheelAbilityList()
    return DataAbilityMain, DataAbilityMainLength
end

function AbilityWheelConfig.GetWheelAbility(linkId)
    return DataAbilityMain[linkId]
end

function AbilityWheelConfig.GetActiveAbilityId()
    return DataAbilityMainBySkillType[AbilityWheelEnum.AbilitySkillType.Active]
end

function AbilityWheelConfig.GetPassiveAbilityId()
    return DataAbilityMainBySkillType[AbilityWheelEnum.AbilitySkillType.Passive]
end

local cacheVec1 = Vec3.New(0, 0)
local cacheVec2 = Vec3.New(0, 0)

function AbilityWheelConfig.GetVector2Cross(rootPointX, rootPointY, p1X, p1Y, p2X, p2Y)
    cacheVec1:Set(p1X - rootPointX, p1Y - rootPointY)
    cacheVec2:Set(p2X - rootPointX, p2Y - rootPointY)

    return Vec3.Angle(cacheVec1, cacheVec2)
end