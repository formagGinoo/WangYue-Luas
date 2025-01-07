CustomFsmChangeStateFunctions = {}

--tip:DefaultToHit[默认进受击判断]
function CustomFsmChangeStateFunctions.DefaultToHit(instanceId,mainBehavior,subBehavior)
	if mainBehavior.inHit == true then
		return true
	end
end

--tip:HitToDefault[受击进默认判断]
function CustomFsmChangeStateFunctions.HitToDefault(instanceId,mainBehavior,subBehavior)
	if subBehavior.hitOver == true then
		return true
	end

end

