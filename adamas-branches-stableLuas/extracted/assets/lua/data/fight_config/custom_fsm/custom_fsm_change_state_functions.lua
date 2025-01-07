CustomFsmChangeStateFunctions = {}
--受威胁相关-------------------------------------------------------------------------------------
--tip:DefaultToThreatened[默认进受威胁判断]
function CustomFsmChangeStateFunctions.DefaultToThreatened(instanceId,parentBehavior,curBehavior,mainBehavior)
	if parentBehavior.onHit == true or parentBehavior.aimLock == true then
		return true
	end
end

--tip:ThreatenedToDefault[受威胁进默认判断]
function CustomFsmChangeStateFunctions.ThreatenedToDefault(instanceId,parentBehavior,curBehavior,mainBehavior)
	if curBehavior.canEscape == false then
		return true
	end
end

--碰撞相关-------------------------------------------------------------------------------------
--tip:DefaultToCollide[默认进碰撞判断]
function CustomFsmChangeStateFunctions.DefaultToCollide(instanceId,parentBehavior,curBehavior,mainBehavior)
	if parentBehavior.onCollide == true then
		if BehaviorFunctions.GetSubMoveState(parentBehavior.role) == FightEnum.EntityMoveSubState.RunStart
			or BehaviorFunctions.GetSubMoveState(parentBehavior.role) == FightEnum.EntityMoveSubState.Run then
			parentBehavior.onCollide = false
			parentBehavior.collideAct = parentBehavior.CollideActEnum.Collide
			return true
		elseif BehaviorFunctions.GetSubMoveState(parentBehavior.role) == FightEnum.EntityMoveSubState.Sprint
			or BehaviorFunctions.GetSkillSign(parentBehavior.role,10000007) then
			parentBehavior.onCollide = false
			parentBehavior.collideAct = parentBehavior.CollideActEnum.Dodge
			return true
		else
			parentBehavior.onCollide = false
		end
	end
end

--tip:CollideToDefault[碰撞进默认判断]
function CustomFsmChangeStateFunctions.CollideToDefault(instanceId,parentBehavior,curBehavior,mainBehavior)
	return true
end

--警告相关-------------------------------------------------------------------------------------
--tip:DefaultToAlert[默认进警告判断]
function CustomFsmChangeStateFunctions.DefaultToAlert(instanceId,parentBehavior,curBehavior,mainBehavior)
	return false
end

--tip:AlertToTalk[警告进对话判断]
function CustomFsmChangeStateFunctions.AlertToTalk(instanceId,parentBehavior,curBehavior,mainBehavior)
	if parentBehavior.inAlertTalk == true then
		return true
	end
end


--逃跑相关-------------------------------------------------------------------------------------
--tip:DefaultToEscape[默认进逃跑判断]
function CustomFsmChangeStateFunctions.DefaultToEscape(instanceId,parentBehavior,curBehavior,mainBehavior)
	local inCrimeValue = BehaviorFunctions.GetBlackBoardValue(CustomFsmDataBlackBoardEnum.inCrime)
	if inCrimeValue then
		local distance = 10
		local crimePos = inCrimeValue
		local myPos = BehaviorFunctions.GetPositionP(parentBehavior.me)
		if BehaviorFunctions.GetDistanceFromPos(crimePos,myPos) <= distance then
			return true
		end
	end
end

--tip:ThreatenedToEscape[受威胁进逃跑判断]
function CustomFsmChangeStateFunctions.ThreatenedToEscape(instanceId,parentBehavior,curBehavior,mainBehavior)
	if curBehavior.canEscape == true then
		return true
	end
end

--tip:EscapeToDefault[逃跑进默认判断]
function CustomFsmChangeStateFunctions.EscapeToDefault(instanceId,parentBehavior,curBehavior,mainBehavior)
	return true
end

--战斗相关-------------------------------------------------------------------------------------
--tip:DefaultToFight[默认进战斗判断]
function CustomFsmChangeStateFunctions.DefaultToFight(instanceId,parentBehavior,curBehavior,mainBehavior)
	return false
end

--tip:FightToDefault[战斗进默认判断]
function CustomFsmChangeStateFunctions.FightToDefault(instanceId,parentBehavior,curBehavior,mainBehavior)
	return false
end

--对话相关-------------------------------------------------------------------------------------
--tip:DefaultToTalk[默认进对话判断]
function CustomFsmChangeStateFunctions.DefaultToTalk(instanceId,parentBehavior,curBehavior,mainBehavior)
	if parentBehavior.inDefaultTalk then
		return true
	end
end

--tip:InTaskToTalk[任务占用进对话判断]
function CustomFsmChangeStateFunctions.InTaskToTalk(instanceId,parentBehavior,curBehavior,mainBehavior)
	if parentBehavior.inDefaultTalk then
		return true
	end
end

--tip:TalkToDefault[对话进默认判断]
function CustomFsmChangeStateFunctions.TalkToDefault(instanceId,parentBehavior,curBehavior,mainBehavior)
	if not parentBehavior.inDefaultTalk and not parentBehavior.inAlertTalk then
		return true
	end
end

--任务占用相关-------------------------------------------------------------------------------------
--tip:InTask[任务占用]
function CustomFsmChangeStateFunctions.InTask(instanceId,parentBehavior,curBehavior,mainBehavior)
	if parentBehavior.isInTask == true then
		return true
	end
end

--tip:OutTask[取消任务占用]
function CustomFsmChangeStateFunctions.OutTask(instanceId,parentBehavior,curBehavior,mainBehavior)
	if parentBehavior.isInTask == false then
		return true
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------子状态---------------------------------------------------------------------------
--默认子状态
--tip:ActToPatrol[演出到巡逻]
function CustomFsmChangeStateFunctions.ActToPatrol(instanceId,parentBehavior,curBehavior,mainBehavior)
	if parentBehavior.needPatrol then
		return true
	end
end

--tip:PatrolToAct[巡逻到演出]
function CustomFsmChangeStateFunctions.PatrolToAct(instanceId,parentBehavior,curBehavior,mainBehavior)
	if not parentBehavior.needPatrol then
		return true
	end
end

-------------------------------------守卫临时-----------------------------------------
--tip:GuardThreatenedToDefault[受威胁进默认判断]
function CustomFsmChangeStateFunctions.GuardThreatenedToDefault(instanceId,parentBehavior,curBehavior,mainBehavior)
	if curBehavior.chooseSorry == true then
		return true
	end
end
--tip:GuardThreatenedToFight[受威胁进战斗判断]
function CustomFsmChangeStateFunctions.GuardThreatenedToFight(instanceId,parentBehavior,curBehavior,mainBehavior)
	if curBehavior.chooseFight == true then
		return true
	end
end
--tip:GuardAlertToDefault[警告进默认判断]
function CustomFsmChangeStateFunctions.GuardAlertToDefault(instanceId,parentBehavior,curBehavior,mainBehavior)
	if curBehavior.alertChooseSorry == true then
		return true
	end
end
--tip:GuardAlertToFight[警告进战斗判断]
function CustomFsmChangeStateFunctions.GuardAlertToFight(instanceId,parentBehavior,curBehavior,mainBehavior)
	if curBehavior.alertChooseFight == true then
		return true
	end
end
--tip:GuardDefaultToAlert[默认进警告]
function CustomFsmChangeStateFunctions.GuardDefaultToAlert(instanceId,parentBehavior,curBehavior,mainBehavior)
	local inCrimeValue = BehaviorFunctions.GetBlackBoardValue(CustomFsmDataBlackBoardEnum.inCrime)
	if inCrimeValue then
		return true
	end
end

-------------------------------------怪物相关-----------------------------------------
-------------------------------------出生相关-----------------------------------------
--tip:BornDefaultToSpecial[怪物|出生默认进特殊]
function CustomFsmChangeStateFunctions.BornDefaultToSpecial(instanceId,parentBehavior,curBehavior,mainBehavior)
	if mainBehavior.haveSpecialBornLogic == true then
		return true
	end
end
--tip:BornDefaultToInitial[怪物|出生默认进初始化]
function CustomFsmChangeStateFunctions.BornDefaultToInitial(instanceId,parentBehavior,curBehavior,mainBehavior)
	if mainBehavior.haveSpecialBornLogic == false then
		return true
	end
end
--tip:BornToNonFight[怪物|出生进非战斗]
function CustomFsmChangeStateFunctions.BornToNonFight(instanceId,parentBehavior,curBehavior,mainBehavior)
	if curBehavior.isBorned == true then
		return true
	end
end
--tip:PeaceDefaultToPatrol[怪物|和平默认进巡逻]
function CustomFsmChangeStateFunctions.PeaceDefaultToPatrol(instanceId,parentBehavior,curBehavior,mainBehavior)
	if parentBehavior.peaceState == parentBehavior.PeaceStateEnum.Patrol then
		return true
	end
end
--tip:PeaceDefaultToAct[怪物|和平默认进生态表演]
function CustomFsmChangeStateFunctions.PeaceDefaultToAct(instanceId,parentBehavior,curBehavior,mainBehavior)
	if parentBehavior.peaceState == parentBehavior.PeaceStateEnum.Act then
		return true
	end
end
--tip:PeaceToWarning[怪物|和平进警戒动作]
function CustomFsmChangeStateFunctions.PeaceToWarning(instanceId,parentBehavior,curBehavior,mainBehavior)
	if parentBehavior.warnState == parentBehavior.warnStateEnum.Warning then
		return true
	end
end
--tip:NonFightToInFight[怪物|非战斗进战斗]
function CustomFsmChangeStateFunctions.NonFightToInFight(instanceId,parentBehavior,curBehavior,mainBehavior)
	if mainBehavior.inFight == true then
		return true	
	end
end
--tip:WanderToCastSkill[怪物|游荡进释放技能]
function CustomFsmChangeStateFunctions.WanderToCastSkill(instanceId,parentBehavior,curBehavior,mainBehavior)
	if parentBehavior.skillState == parentBehavior.skillStateEnum.HaveSkill then
		return true
	end
end
--tip:CastSkillDefaultToCastingSkill[怪物|释放技能默认进释放技能中]
function CustomFsmChangeStateFunctions.CastSkillDefaultToCastingSkill(instanceId,parentBehavior,curBehavior,mainBehavior)
	if parentBehavior.ParentBehavior.skillState == parentBehavior.ParentBehavior.skillStateEnum.Ready then
		return true
	end
end
--tip:CastSkillDefaultToTurning[怪物|释放技能默认进转向]
function CustomFsmChangeStateFunctions.CastSkillDefaultToTurning(instanceId,parentBehavior,curBehavior,mainBehavior)
	if parentBehavior.ParentBehavior.skillState ~= parentBehavior.ParentBehavior.skillStateEnum.Ready then
		return true
	end
end
--tip:CastSkillTurningToCastingSkill[怪物|释放技能转向进释放技能中]
function CustomFsmChangeStateFunctions.CastSkillTurningToCastingSkill(instanceId,parentBehavior,curBehavior,mainBehavior)
	if parentBehavior.ParentBehavior.skillState == parentBehavior.ParentBehavior.skillStateEnum.Ready then
		return true
	end
end
--tip:CastSkillToWander[怪物|释放技能进游荡]
function CustomFsmChangeStateFunctions.CastSkillToWander(instanceId,parentBehavior,curBehavior,mainBehavior)
	if curBehavior.skillDone == true then
		return true
	end
end
--tip:InFightToExitFight[怪物|战斗进脱战]
function CustomFsmChangeStateFunctions.InFightToExitFight(instanceId,parentBehavior,curBehavior,mainBehavior)
	if mainBehavior.inFight == false then
		return true
	end
end
--tip:ExitFightToPeace[怪物|脱战进和平]
function CustomFsmChangeStateFunctions.ExitFightToPeace(instanceId,parentBehavior,curBehavior,mainBehavior)
	if curBehavior.rebornDone == true then
		return true
	end
end
--tip:WanderAnyStateToPathFind[怪物|游荡任意进寻路]
function CustomFsmChangeStateFunctions.WanderAnyStateToPathFind(instanceId,parentBehavior,curBehavior,mainBehavior)
	if parentBehavior.cannotWander == true then
		return true
	end
end
--tip:WanderAnyStateToFarRun[怪物|游荡任意进超远距离跑]
function CustomFsmChangeStateFunctions.WanderAnyStateToFarRun(instanceId,parentBehavior,curBehavior,mainBehavior)
	if parentBehavior.cannotWander == false
		and parentBehavior.battleRange == parentBehavior.BattleRangeEnum.Far
		and mainBehavior.myFrame >= parentBehavior.walkSwitchFrame then
		return true
	end
end
--tip:WanderAnyStateToLongRun[怪物|游荡任意进长距离跑]
function CustomFsmChangeStateFunctions.WanderAnyStateToLongRun(instanceId,parentBehavior,curBehavior,mainBehavior)
	if parentBehavior.cannotWander == false
		and parentBehavior.battleRange == parentBehavior.BattleRangeEnum.Long
		and mainBehavior.myFrame >= parentBehavior.walkSwitchFrame then
		return true
	end
end
--tip:WanderAnyStateToMidWander[怪物|游荡任意进中距离游荡]
function CustomFsmChangeStateFunctions.WanderAnyStateToMidWander(instanceId,parentBehavior,curBehavior,mainBehavior)
	if parentBehavior.cannotWander == false
		and parentBehavior.battleRange == parentBehavior.BattleRangeEnum.Mid then
		return true
	end
end
--tip:WanderAnyStateToShortBack[怪物|游荡任意进近距离后退]
function CustomFsmChangeStateFunctions.WanderAnyStateToShortBack(instanceId,parentBehavior,curBehavior,mainBehavior)
	if parentBehavior.cannotWander == false
		and parentBehavior.battleRange == parentBehavior.BattleRangeEnum.Short
		and mainBehavior.myFrame > parentBehavior.walkSwitchFrame
		and parentBehavior.moveState ~= parentBehavior.MoveStateEnum.RunAndHit then
		return true
	end
end



