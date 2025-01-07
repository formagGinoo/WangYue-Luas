GoalSleep = BaseClass("GoalSleep",GOAPGoalBase)

function GoalSleep:__init()

end

function GoalSleep:GetGoalTendency(planner)
    if planner.dynamicAttrs["Stamina"] < planner.dynamicAttrs["Mood"] then
        return 996
    elseif planner.globalAttrs.globalStates["Time"] > 90 then
        return 998
    elseif planner.globalAttrs.globalStates["Danger"] < 5 then
        return 997
    end
    return 1
end

function GoalSleep:__delete()

end
