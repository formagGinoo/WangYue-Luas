DebugPlanInvoke = {}
DebugPlanInvoke.NotClear = true

function DebugPlanInvoke.SetCache(cache)
	DebugPlanInvoke.Cache = cache
end

function DebugPlanInvoke.TransferToBaXi()
	local targetPos = BehaviorFunctions.GetTerrainPositionP("checkPoint13",10020001,"Logic10020001_6")
	BehaviorFunctions.Transport(10020001,targetPos.x,targetPos.y,targetPos.z)
end

function DebugPlanInvoke.TransferToGetSword()
	local targetPos = BehaviorFunctions.GetTerrainPositionP("tp_Sword",10020001,"Logic10020001_6")
	BehaviorFunctions.Transport(10020001,targetPos.x,targetPos.y,targetPos.z)
end

function DebugPlanInvoke.TransferToXiLaiCity()
	BehaviorFunctions.Transport(10020001,414,75,1722)
end

function DebugPlanInvoke.SkipRookieTask()
	mod.GmFacade:SendMsg("gm_exec", "task_accept", {"102010101"})
end

function DebugPlanInvoke.ReciveBlbtTrainLevel()
	mod.GmFacade:SendMsg("gm_exec", "task_accept", {"101062201"})
end

function DebugPlanInvoke.SkipBlbtTrainLevel()
	mod.GmFacade:SendMsg("gm_exec", "task_accept", {"101060801"})
end

function DebugPlanInvoke.ReciveBaXiTask()
	mod.GmFacade:SendMsg("gm_exec", "task_accept", {"101070101"})
end