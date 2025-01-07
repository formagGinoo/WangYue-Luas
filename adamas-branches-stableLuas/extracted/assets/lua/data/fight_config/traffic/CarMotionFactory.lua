CarMotionFactory = CarMotionFactory or {}


function CarMotionFactory.CreateObstacleMotion(checkDis, canVehicle)
    local aiCarMotion = Fight.Instance.objectPool:Get(AiCarMotion)

    aiCarMotion:AddActiveCondition(function ()
        return aiCarMotion:GetCondition(FightEnum.AiCarConditionType.CheckObstacle,checkDis)
    end)
    aiCarMotion:AddActiveCondition(function ()
        return aiCarMotion:GetCondition(FightEnum.AiCarConditionType.CheckPassableSpace,canVehicle,0.1)
    end)

    aiCarMotion:AddCancelCondition(function ()
        return aiCarMotion:IsComplete()
    end )

    aiCarMotion:AddAction(FightEnum.AiCarActionType.changeLanes)

    return aiCarMotion
end

function CarMotionFactory.CreateMaxSpeedMultMotion(multAcceleration,multSpeed,cd,duration,distance)
    local aiCarMotion = Fight.Instance.objectPool:Get(AiCarMotion)

    aiCarMotion:AddActiveCondition(function ()
        return aiCarMotion:GetSinceLastActiveTime() > cd
    end)
    aiCarMotion:AddActiveCondition(function ()
        return aiCarMotion:GetCondition(FightEnum.AiCarConditionType.GetPlayerDistance) < distance
    end)

    aiCarMotion:AddCancelCondition(function ()
        return aiCarMotion:GetStayTime() > duration
    end )
	
	aiCarMotion:AddAction(FightEnum.AiCarActionType.accelerationMultiplier,multAcceleration)
    aiCarMotion:AddAction(FightEnum.AiCarActionType.maxSpeedMultiplier,multSpeed)
    return aiCarMotion
end

--function CarMotionFactory.CreateMaxAccelerationSpeedMultMotion2(multAcceleration, cd,duration,distance)
	--local aiCarMotion = Fight.Instance.objectPool:Get(AiCarMotion)

	--aiCarMotion:AddActiveCondition(function ()
			--return aiCarMotion:GetSinceLastActiveTime() > cd
		--end)
	--aiCarMotion:AddActiveCondition(function ()
			--return aiCarMotion:GetCondition(FightEnum.AiCarConditionType.GetPlayerDistance) < distance
		--end)

	--aiCarMotion:AddCancelCondition(function ()
			--return aiCarMotion:GetStayTime() > duration
		--end )

	--aiCarMotion:AddAction(FightEnum.AiCarActionType.accelerationMultiplier,multAcceleration)
	--return aiCarMotion
--end

--function CarMotionFactory.CreateMaxSpeedMultMotion3(multSpeed, cd,duration,distance)
	--local aiCarMotion = Fight.Instance.objectPool:Get(AiCarMotion)

	--aiCarMotion:AddActiveCondition(function ()
			--return aiCarMotion:GetSinceLastActiveTime() > cd
		--end)
	--aiCarMotion:AddActiveCondition(function ()
			--return aiCarMotion:GetCondition(FightEnum.AiCarConditionType.GetPlayerDistance) < distance
		--end)

	--aiCarMotion:AddCancelCondition(function ()
			--return aiCarMotion:GetStayTime() > duration
		--end )
	--aiCarMotion:AddAction(FightEnum.AiCarActionType.maxSpeedMultiplier,multSpeed)
	--return aiCarMotion
--end


function CarMotionFactory.ChangeSpeedFromDistance(mult, cd,duration,distance,distanceMode)
	local aiCarMotion = Fight.Instance.objectPool:Get(AiCarMotion)

	aiCarMotion:AddActiveCondition(function ()
			return aiCarMotion:GetSinceLastActiveTime() > cd
		end)
	if distanceMode == 0 or not distanceMode then
		aiCarMotion:AddActiveCondition(function ()
				return aiCarMotion:GetCondition(FightEnum.AiCarConditionType.GetPlayerDistance) < distance
			end)
	elseif distanceMode == 1 then
		aiCarMotion:AddActiveCondition(function ()
				return aiCarMotion:GetCondition(FightEnum.AiCarConditionType.GetPlayerDistance) >= distance
			end)
	end

	aiCarMotion:AddCancelCondition(function ()
			return aiCarMotion:GetStayTime() > duration
		end )

	aiCarMotion:AddAction(FightEnum.AiCarActionType.maxSpeedMultiplier,mult)
	aiCarMotion:AddAction(FightEnum.AiCarActionType.accelerationMultiplier,mult)
	return aiCarMotion
end


function CarMotionFactory.CreateUnStopMotion(massMult)
    local aiCarMotion = Fight.Instance.objectPool:Get(AiCarMotion)

    aiCarMotion:AddAction(FightEnum.AiCarActionType.unStopable,massMult)
    return aiCarMotion
end