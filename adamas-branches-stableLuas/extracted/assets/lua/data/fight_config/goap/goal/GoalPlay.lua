GoalPlay = BaseClass("GoalPlay",GOAPGoalBase)

function GoalPlay:__init()

end

function GoalPlay:GetGoalTendency(planner)
    if planner.dynamicAttrs["Mood"] > planner.dynamicAttrs["Hunger"] then
        return 996
    elseif planner.globalAttrs.globalStates["Danger"] > 50 then
        return 998
    end
    return 1
end

function GoalPlay:__delete()

end
