GoalWork = BaseClass("GoalWork",GOAPGoalBase)

function GoalWork:__init()

end

function GoalWork:GetGoalTendency(planner)
    if  planner.dynamicAttrs["Money"] < 10 then
        return 997
    end
    if  planner.dynamicAttrs["Money"] < planner.dynamicAttrs["Mood"] then
        return 995
    elseif planner.globalAttrs.globalStates["Time"] > 20  and planner.globalAttrs.globalStates["Time"] < 80 then
        return 999
    end
    return 1
end

function GoalWork:__delete()

end
