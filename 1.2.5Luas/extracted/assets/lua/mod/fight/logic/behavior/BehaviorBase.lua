BehaviorBase = BaseClass("BehaviorBase")

function BehaviorBase:__init()
	self.childBehaviors = {}
end

function BehaviorBase:SetInstanceId(instanceId, sInstanceId)
	self.instanceId = instanceId
	self.sInstanceId = sInstanceId
end

function BehaviorBase:CallFunc(funName, ...)
	if not self.childBehaviors then
		return 
	end
	for k,v in ipairs(self.childBehaviors) do
		if v[funName] then
			v[funName](v,...)
		end
		v:CallFunc(funName, ...)
	end
end

function BehaviorBase:BeforeUpdate()

end

function BehaviorBase:Update()

end

function BehaviorBase:AfterUpdate()

end

function BehaviorBase:Remove()

end

function BehaviorBase:__delete()
	self.entity = nil
end


--[[
function BehaviorBase:Born(instanceId, entityId)

end

function BehaviorBase:CastSkill(instanceId,skillId,skillType)

end

function BehaviorBase:BreakSkill(instanceId,skillId,skillType)

end

function BehaviorBase:FinishSkill(instanceId,skillId,skillType)

end

function BehaviorBase:ClearSkill(instanceId,skillId,skillType)

end


function BehaviorBase:BeforeHit(attackInstanceId,hitInstanceId,hitType)

end

function BehaviorBase:Hit(attackInstanceId,hitInstanceId,hitType)

end

function BehaviorBase:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)

end

-- shakeStrenRatio ik抖动强度系数
-- attackType FightEnum.EAttackType攻击类型
function BehaviorBase:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType)

end

function BehaviorBase:BeforeDie(instanceId)
end

function BehaviorBase:BeforeAttack(attackInstanceId,hitInstanceId)

end

function BehaviorBase:Attack(attackInstanceId,hitInstanceId)

end

function BehaviorBase:AfterAttack(attackInstanceId,hitInstanceId)

end

function BehaviorBase:BeforeCalculateDamage(attackInstanceId,hitInstanceId,damageType,magicId,damageElementType,attackType,partType,damageInfo,ownerInstanceId)
end

function BehaviorBase:BeforeDamage(attackInstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal,attackType,partType,damageInfo,ownerInstanceId,isCirt)

end

function BehaviorBase:Damage(attackInstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal,attackType,partType,damageInfo,ownerInstanceId,isCirt)
end

function BehaviorBase:AfterDamage(attackInstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal,attackType,partType,damageInfo,ownerInstanceId,isCirt)

end

function BehaviorBase:BeforeCure(healerInstanceId,treateeInstanceId,magicId,cure)

end

function BehaviorBase:Cure(healerInstanceId,treateeInstanceId,magicId,cure)

end

function BehaviorBase:AfterCure(healerInstanceId,treateeInstanceId,magicId,cure)

end

function BehaviorBase:BerforeCure(attackInstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal)

end

function BehaviorBase:Cure(attackInstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal)

end

function BehaviorBase:AfterCure(attackInstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal)

end

function BehaviorBase:Die(attackInstanceId,dieInstanceId)

end

function BehaviorBase:DeathEnter(instanceId)

end

function BehaviorBase:Death(instanceId, isFormationRevive)

end

function BehaviorBase:Revive(instanceId, entityId)

end

function BehaviorBase:RemoveEntity(instanceId)

end

function BehaviorBase:ChangeForeground(instanceId)

end

function BehaviorBase:ChangeBackground(instanceId)

end


function BehaviorBase:BeforeDodge(attackInstanceId,hitInstanceId,limit)
	--print(string.format("进入躲避回调[攻击者实体Id:%s]",attackInstanceId))
end

function BehaviorBase:BeforeBeDodge(attackInstanceId,hitInstanceId,limit)
	--print(string.format("进入躲避回调[攻击者实体Id:%s]",attackInstanceId))
end


--躲避
function BehaviorBase:Dodge(attackInstanceId,hitInstanceId,limit)
	--print(string.format("进入躲避回调[攻击者实体Id:%s]",attackInstanceId))
end

--被闪避
function BehaviorBase:BeDodge(attackInstanceId,hitInstanceId,limit)
	--print(string.format("进入躲避回调[攻击者实体Id:%s]",attackInstanceId))
end

--躲避
function BehaviorBase:JumpDodge(attackInstanceId,hitInstanceId,limit,notJumpBeatBack)
	--print(string.format("进入躲避回调[攻击者实体Id:%s]",attackInstanceId))
end

--被闪避
function BehaviorBase:JumpBeDodge(attackInstanceId,hitInstanceId,limit,notJumpBeatBack)
	--print(string.format("进入躲避回调[攻击者实体Id:%s]",attackInstanceId))
end

--进入触发交互
function BehaviorBase:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	--print(string.format("进入交互[触发实例Id:%s][触发实体Id:%s][角色实例Id:%s]",triggerInstanceId,triggerEntityId,roleInstanceId))
end

--退出触发交互
function BehaviorBase:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	--print(string.format("退出交互[触发实例Id:%s][触发实体Id:%s][角色实例Id:%s]",triggerInstanceId,triggerEntityId,roleInstanceId))
end

function BehaviorBase:ExtraEnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
end

function BehaviorBase:ExtraExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
end

function BehaviorBase:ChangeRole(index, curInstance, instance)
	-- LogError(string.format("BehaviorBase:ChangeRole(%s, %s, %s)", index, curInstance, instance))
end

function BehaviorBase:EnterArea(triggerInstanceId, areaName, logicName)

end

function BehaviorBase:ExitArea(triggerInstanceId, areaName, logicName)

end

function BehaviorBase:EntityHitEnd(instanceId)

end

function BehaviorBase:OnLand(instanceId)

end

function BehaviorBase:EnterElementStateReady(atkInstanceId, instanceId, element)

end

function BehaviorBase:EnterElementCoolingState(atkInstanceId, instanceId, element)

end

function BehaviorBase:OnAnimEvent(instanceId, eventType, params)

end

function BehaviorBase:OnEntityCollision(instanceId, collisionInstanceId)

end

function BehaviorBase:ReboundAttack(instanceId, attackInstanceId)

end

function BehaviorBase:ChangeAttrValue(attrType, attrValue, changedValue)

end

function BehaviorBase:ChargeBeforeChange(instanceId, curValue, changedValue, keyEvent, attrType)
	
end

function BehaviorBase:ChargeChanged(instanceId, oldValue, curValue, changedValue, keyEvent, attrType)
	
end

function BehaviorBase:SkillPointChangeBefore(instanceId, type, curValue, changedValue)
	
end

function BehaviorBase:SkillPointChangeAfter(instanceId, type, oldValue, curValue, changedValue)
	
end

function BehaviorBase:CastSkillCostBefore(instanceId, skillId, exChange, normalChange, curEx, curNormal, all)
	
end

function BehaviorBase:CastSkillCostAfter(instanceId, skillId, exChange, normalChange, curEx, curNormal, all)
	
end

function BehaviorBase:PartHit(instanceId, partName, damageShield, damage,attackTyp, shakeStrenRatio)

end

function BehaviorBase:PartDestroy(instanceId, partName, eventId)

end

function BehaviorBase:AimSwitchState(instanceId, state)

end

function BehaviorBase:WorldInteractClick(uniqueId)

end

function BehaviorBase:StoryStartEvent(dialogId)

end

function BehaviorBase:StoryEndEvent(dialogId)

end

function BehaviorBase:StorySelectEvent(dialogId)

end
function BehaviorBase:StoryPassEvent(dialogId)
	
end

function BehaviorBase:EnterHoldQTE(qteId)

end

function BehaviorBase:ClickQTE(qteId)

end

function BehaviorBase:EnterQTE(qteType, qteId)

end

function BehaviorBase:ExitQTE(qteType, returnValue, qteId)

end

function BehaviorBase:SwitchQTE(ForeInstanceId, BackInstanceId, index, isClick)

end

function BehaviorBase:EndAssassinQTE(qteId, result)

end

function BehaviorBase:OnGuideStart(guideId, stage)
end

function BehaviorBase:OnGuideFinish(guideId, stage)
end

function BehaviorBase:AddBuff(entityInstanceId, buffInstanceId,buffId)
end

function BehaviorBase:RemoveBuff(entityInstanceId, buffInstanceId,buffId)
end

function BehaviorBase:PathFindingEnd(instanceId,result)
	
end

function BehaviorBase:KeyInput(key, status)

end

function BehaviorBase:AddEntitySign(instance, sign)

end

function BehaviorBase:RemoveEntitySign(instance, sign)
	
end

function BehaviorBase:AddSkillSign(instance, sign)

end

function BehaviorBase:Warning(instance, targetInstance, sign, isEnd)
end

function BehaviorBase:TopTargetClose(configId)

end

function BehaviorBase:ConditionEvent(instanceId, eventId)

end

function BehaviorBase:OnGuideImageTips(tipsId, isOpen)
end

function BehaviorBase:OpenDoorMonster(entityId, entityIdBefore)
end

function BehaviorBase:OpenKeySuccess(instanceId)
end

function BehaviorBase:OpenKeyFinish(instanceId)
end

function BehaviorBase:PartnerDeparture(instanceId)
end

function BehaviorBase:PartnerLeave(instanceId)
end

function BehaviorBase:PartnerHide(instanceId)
end

function BehaviorBase:BeforePartnerReplaced(roleInstanceId, partnerInstanceId)
end

function BehaviorBase:MailingActive(npcId, mailingId)
end

function BehaviorBase:MailingExchangeBeforeFinish(npcId, mailingId)
end

function BehaviorBase:MailingExchangeFinish(npcId, mailingId)
end

function BehaviorBase:UnlockConditionSuc()
end

function BehaviorBase:BackGroundEnd(groupId)
end

function BehaviorBase:CatchPartnerEnd()
end

function BehaviorBase:LeaveFighting(instanceId)
end

function BehaviorBase:Hacking(instanceId)
end

function BehaviorBase:StopHacking(instanceId)
end

function BehaviorBase:HackingClickUp(instanceId)
end

function BehaviorBase:HackingClickDown(instanceId)
end

function BehaviorBase:HackingClickLeft(instanceId)
end

function BehaviorBase:HackingClickRight(instanceId)
end
]]