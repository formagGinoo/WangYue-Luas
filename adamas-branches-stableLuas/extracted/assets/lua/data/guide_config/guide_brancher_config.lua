GuideBrancherConfig = {}

function GuideBrancherConfig.Test999901()
    if BehaviorFunctions.CheckWeaponOn(1001001,2001101) or BehaviorFunctions.CheckWeaponOn(1001001,2001201) then
        LogInfo("2")
        return 2
    else
        LogInfo("8")
        return 8
    end
end

function GuideBrancherConfig.Test999701()
    if BehaviorFunctions.CheckAbilityOn(101) == true then
        LogInfo("2")
        return 2
    else
        LogInfo("3")
        return 3
    end
end

function GuideBrancherConfig.Test999702()
    if BehaviorFunctions.CheckAbilityWheelHasAbility(101) == true then
        LogInfo("5")
        return 5
    else
        LogInfo("6")
        return 6
    end
end

function GuideBrancherConfig.Test999801() --编入刻刻
    local Count = BehaviorFunctions.GetCurFormationRoleList().roleList --返回当前编队列表table
    if BehaviorFunctions.CheckRoleInCurFormation(1001002) ~= true then --刻刻未在编队中
        if  #Count ~= 3 then --如果编队未满
            return 2
        else
            LogInfo("8")
            return 8
        end
    else
        LogInfo("7")
        return 7
    end
end

function GuideBrancherConfig.Test999601()
    if BehaviorFunctions.CheckPartnerOn(1001001,false) == true then
        LogInfo("5")
        return 5
    else
        LogInfo("9")
        return 9
    end
end

function GuideBrancherConfig.Test999602()
    if BehaviorFunctions.GetHeroPartnerLevel(1001001) <= 6 then
        LogInfo("11")
        return 11
    else
        LogInfo("19")
        return 19
    end
end

function GuideBrancherConfig.Test999501()
    if BehaviorFunctions.GetRoleLevel(1001001) ~= 20 then
        LogInfo("4")
        return 4
    else
        LogInfo("9")
        return 9
    end
end