GoalFightBack = BaseClass("GoalFightBack",GOAPGoalBase)

function GoalFightBack:__init()

end

function GoalFightBack:GetGoalTendency(planner)
    if planner.dynamicAttrs["Money"] < planner.dynamicAttrs["Hunger"] then
        return 996
    elseif planner.globalAttrs.globalStates["Time"] < 90 then
        return 2
    elseif planner.globalAttrs.globalStates["Danger"] > 90 then
        return 1001
    end
    return 1
end

function GoalFightBack:__delete()

end
