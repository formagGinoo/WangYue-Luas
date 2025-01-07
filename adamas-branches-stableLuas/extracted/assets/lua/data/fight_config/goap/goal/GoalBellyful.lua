GoalBellyful = BaseClass("GoalBellyful",GOAPGoalBase)

function GoalBellyful:__init()

end

function GoalBellyful:GetGoalTendency(planner)
    if planner.dynamicAttrs["Mood"] < planner.dynamicAttrs["Money"] then
        return 996
    elseif planner.globalAttrs.globalStates["Time"] < 60  and planner.globalAttrs.globalStates["Time"] > 50 then
        return 1000
    elseif planner.globalAttrs.globalStates["Danger"] < 25 then
        return 999
    end
    return 1
end

function GoalBellyful:__delete()

end
