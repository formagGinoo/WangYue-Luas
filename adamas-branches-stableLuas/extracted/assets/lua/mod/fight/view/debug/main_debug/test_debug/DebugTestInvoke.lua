DebugTestInvoke = {}

function DebugTestInvoke.SetCache(cache)
	DebugTestInvoke.Cache = cache
end

function DebugTestInvoke.GetPartnerBalls()
	--num = tonumber(num)
	mod.GmFacade:SendMsg("gm_exec", "item_gain", { "40001", "100" })
	mod.GmFacade:SendMsg("gm_exec", "item_gain", { "40002", "100" })
	mod.GmFacade:SendMsg("gm_exec", "item_gain", { "40003", "100" })
	mod.GmFacade:SendMsg("gm_exec", "item_gain", { "40004", "100" })
	mod.GmFacade:SendMsg("gm_exec", "item_gain", { "40005", "100" })
end

function DebugTestInvoke.GetAbilityCard()
	--num = tonumber(num)
	mod.GmFacade:SendMsg("gm_exec", "item_gain", { "12401", "1" })
	mod.GmFacade:SendMsg("gm_exec", "item_gain", { "12402", "1" })
	mod.GmFacade:SendMsg("gm_exec", "item_gain", { "12403", "1" })
	mod.GmFacade:SendMsg("gm_exec", "item_gain", { "12404", "1" })
	mod.GmFacade:SendMsg("gm_exec", "item_gain", { "12405", "1" })
	mod.GmFacade:SendMsg("gm_exec", "item_gain", { "12406", "1" })
	mod.GmFacade:SendMsg("gm_exec", "item_gain", { "12407", "1" })
	mod.GmFacade:SendMsg("gm_exec", "item_gain", { "12408", "1" })
	
end

function DebugTestInvoke.SetDamageMultiplier(num)
	num = tonumber(num)
	if not num then
		LogError("参数需要为数值")
		return
	end
	if num < 0 then
		LogError("倍率不可为负数")
		return
	end
	DebugClientInvoke.Cache.damageMultiplier = num

	LogInfo("调整伤害倍率 x", num)
end
