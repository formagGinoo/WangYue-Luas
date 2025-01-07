---@class DamageCalculate
DamageCalculate = BaseClass("DamageCalculate")

local AttrType = EntityAttrsConfig.AttrType 
local _floor = math.floor
local DataGlobal = Config.DataGlobal.data_global
local EntityCommonConfig = Config.EntityCommonConfig

local CritDmgBase = 2
local PlayerDefParam1 = 5     -- 角色承伤系数1
local PlayerDefParam2 = 500   -- 角色承伤系数2
local PlayerLvParam = 100     -- 角色防御等级系数
local MonsterLvParam = 100    -- 角色防御等级系数
local AtkLvParam = 100 		  -- 攻击方等级系数
local ElementFixPrama1 = 2    -- 抗性修正系数1
local ElementFixPrama2 = 0.5  -- 抗性修正系数2
local FightConfig = Config.FightConfig

function DamageCalculate:__init()
	self.damageInfo = {}
end

function DamageCalculate:DoDamage(fight, attack, hit, magicParam, part,attackEntity)
	if not self:CanDamage(hit) then
		self:_CalcElementValue(attack, hit, magicParam)
		return
	end
	TableUtils.ClearTable(self.damageInfo)

	local partType = 0
	if part then
		if not part:CheckHurtDamage() then
			return
		end
		partType = part.config.PartType
	end

	local atkAttrs = magicParam.UseSelfAttr and attack.attrComponent.attrs or attack.owner.attrComponent.attrs
	local hitAttrs = hit.attrComponent.attrs
	
	local attackType = 0
	if attackEntity and attackEntity.attackComponent then
		attackType = attackEntity.attackComponent.config.AttackType
	end
	
	self.damageInfo.atkCrit = atkAttrs[AttrType.CritPercent]
	fight.entityManager:CallBehaviorFun("BeforeCalculateDamage", attack.instanceId, hit.instanceId, magicParam.DamageType,magicParam.MagicId, magicParam.ElementType, attackType,partType,self.damageInfo,attack.owner.instanceId)
	
	--技能系数
	local flyPosition
	UnityUtils.BeginSample("DamageCalculate:_CalcDamage")
	local damage, isCrit, isRestriction = self:_CalcDamage(attack, hit, atkAttrs, hitAttrs, magicParam, self.damageInfo)
	UnityUtils.EndSample()
	local armor = damage * DataGlobal.DamagetoArmor.ivalue / 10000
	if ctx.Editor and attack.tagComponent and attack.tagComponent.npcTag == FightEnum.EntityNpcTag.Player then
		local showLog = PlayerPrefs.GetInt("GmCtrl_ShowDamageLog")
		if showLog ~= 0 then
			local entitySkillId = attack.skillComponent.skillId
			local systemSkillId = 0
			local magicId = magicParam.orginMagicId
			local magicLev = magicParam.magicLevel
			local log = string.format("系统技能:%s,实体技能%s:,magicId:%s,magicLev:%s,伤害值:%s,", systemSkillId, entitySkillId, magicId, magicLev, damage)
			Log(log)
		end
	end
	if magicParam.DamageKind ~= FightEnum.DamageType.Assassinate and part and part.damageParam then
		damage = damage * part.damageParam
		flyPosition = part:HurtDamage(damage,attackEntity)
	end

	hit.attrComponent:AddValue(AttrType.Armor, -armor)
	self.damageInfo.damage = damage
	fight.entityManager:CallBehaviorFun("BeforeDamage", attack.instanceId, hit.instanceId, magicParam.DamageType,magicParam.orginMagicId, magicParam.ElementType, damage, attackType,partType,self.damageInfo,attack.owner.instanceId, isCrit)
	damage = self.damageInfo.damage
	
	if ctx then
		local fontType = FightConfig.FontType.DAMAGE + magicParam.ElementType
		local flyText = true
		local isPlayer = magicParam.UseSelfAttr and attack.attrComponent.playerNpcTag or attack.owner.attrComponent.playerNpcTag
		if isPlayer then
			local ctrlId = fight.playerManager:GetPlayer():GetCtrlEntity()
			if attack.instanceId ~= ctrlId then
				flyText = false
			end
		end

		if flyText and BehaviorFunctions.CheckEntity(hit.instanceId) then
			fight.clientFight.fontAnimManager:PlayAnimation(hit, fontType, math.floor(damage), isCrit, isRestriction, nil, flyPosition)
		end
	end
	
	hit.attrComponent:SetDamageAttackEntity(attack)
	hit.attrComponent:AddValue(AttrType.Life, -damage)
	fight.entityManager:CallBehaviorFun("Damage", attack.instanceId, hit.instanceId, magicParam.DamageType,magicParam.orginMagicId, magicParam.ElementType, damage, attackType,partType,self.damageInfo,attack.owner.instanceId, isCrit)
	fight.entityManager:CallBehaviorFun("AfterDamage", attack.instanceId, hit.instanceId, magicParam.DamageType,magicParam.orginMagicId, magicParam.ElementType, damage, attackType,partType,self.damageInfo,attack.owner.instanceId, isCrit)
	EventMgr.Instance:Fire(EventName.OnDoDamage, attack.instanceId, hit.instanceId, magicParam.DamageType,magicParam.orginMagicId, magicParam.ElementType, damage, attackType)
end

function DamageCalculate:_CalcDamage(attack, hit, atkAttrs, hitAttrs, magicParam, damageInfo)
	local elementType = magicParam.ElementType
	local entityAtkLevel = magicParam.UseSelfAttr and attack.attrComponent.level or attack.owner.attrComponent.level
	local entityDefLevel = hit.attrComponent.level

	local damagePercent = 1
	local isCrit = false
	if magicParam.DamageKind == FightEnum.DamageType.Normal then
		-- 通用伤害加成
		local atkDmgPercent = atkAttrs[AttrType.DmgAtkPercent] + atkAttrs[AttrType["AtkPercentEl"..elementType]] - 
			hitAttrs[AttrType.DmgDefercent] - hitAttrs[AttrType.ArmorDefPercent]
		atkDmgPercent = atkDmgPercent

		-- 角色近战/远程伤害加成
		local roleTypeDmgPercent = 0
		if attack.masterId then
			roleTypeDmgPercent = BehaviorFunctions.GetPlayerAttrVal(FightEnum.RoleDmgTypeToAttr[RoleConfig.GetRoleDmgType(attack.masterId)])
		end

		-- 守方防御承伤
		local defDmgPercent
		local def = hitAttrs[AttrType.Defense]
		if hit.tagComponent.npcTag == FightEnum.EntityNpcTag.Player then
			defDmgPercent = 1 - def / (def + entityDefLevel * PlayerDefParam1 + PlayerDefParam2)
			
		else
			local atkLvParam = entityAtkLevel + AtkLvParam
			defDmgPercent = atkLvParam / (atkLvParam + entityDefLevel + MonsterLvParam)
		end

		-- 守方元素承伤
		local elementPercent = hitAttrs[AttrType["DefPercentEl"..elementType]]
		local throughPercentElAtk = atkAttrs[AttrType["ThroughPercentEl"..elementType]]
		local elementDmgPercent = 1 + throughPercentElAtk
		if elementPercent > 7500 then
			elementDmgPercent = elementDmgPercent - elementPercent * ElementFixPrama1
		elseif elementPercent > 0 then
			elementDmgPercent = elementDmgPercent - elementPercent
		else
			elementDmgPercent = elementDmgPercent - elementPercent * ElementFixPrama2
		end

		-- 暴击(随机数后面统一换)
		isCrit = damageInfo.atkCrit - hitAttrs[AttrType.CritDefPercent] >= math.random()
		--isCrit = _floor(atkAttrs[AttrType.CritPercent] - hitAttrs[AttrType.CritDefPercent]) >= math.random(1, 10000)
		local critDmgPercent = 1
		if isCrit then
			critDmgPercent = math.max(CritDmgBase + atkAttrs[AttrType.CritAtkPercent] - hitAttrs[AttrType.CritDecPercent], 1)
		end
		
		damagePercent = (1 + atkDmgPercent + roleTypeDmgPercent) * defDmgPercent * elementDmgPercent * critDmgPercent
	end

	-- 基础伤害
	local skillParam = magicParam.SkillParam
	if not skillParam then
		if magicParam.DamageKind == FightEnum.DamageType.Normal or magicParam.DamageKind == FightEnum.DamageType.Assassinate then
			skillParam = 10000
		elseif magicParam.DamageKind == FightEnum.DamageType.Percent then
			skillParam = 100
		else
			skillParam = 0
		end
	end

	local baseDmg = 0
	if magicParam.DamageKind == FightEnum.DamageType.Normal then
		baseDmg = atkAttrs[AttrType.Attack] * skillParam / 10000
	elseif magicParam.DamageKind == FightEnum.DamageType.Assassinate then
		local levelDiff = entityDefLevel - entityAtkLevel > EntityCommonConfig.AssassinateMinLvDiff and entityDefLevel - entityAtkLevel - EntityCommonConfig.AssassinateMinLvDiff or 0
		local percent = (skillParam / 10000) - (hitAttrs[AttrType.AssassinateDef]) - (levelDiff * EntityCommonConfig.AssassinateLvParam)
		baseDmg = hitAttrs[AttrType.MaxLife] * percent
	elseif magicParam.DamageKind == FightEnum.DamageType.Percent then
		baseDmg = hitAttrs[AttrType.MaxLife] * skillParam / 100
	elseif magicParam.DamageKind == FightEnum.DamageType.Fixed then
		baseDmg = skillParam
	end

	-- magicParam.SkillParam = magicParam.SkillParam  or 10000
	-- local atk = atkAttrs[AttrType.Attack] * magicParam.SkillParam / 10000
	local skillBaseDmg = magicParam.SkillBaseDmg or 0
	--(基础伤害+技能固定伤害)*(1+通用伤害加成%+角色类型伤害加成%)*守方防御承伤%*守方抗性承伤%*部位承伤%*暴击
	local damage = (baseDmg + skillBaseDmg) * damagePercent

	-- 只有普通造成伤害才算元素
	if magicParam.DamageKind == FightEnum.DamageType.Normal then
		local atkElement = attack.elementStateComponent and attack.elementStateComponent.config.ElementType or FightEnum.ElementType.Phy
		local hitElement = hit.elementStateComponent and hit.elementStateComponent.config.ElementType or FightEnum.ElementType.Phy
		if FightEnum.ElementRelationDmgType[atkElement] == hitElement then
			damage = damage + damage *  DataGlobal.ElementRelationDmg.ivalue / 10000
		elseif FightEnum.ElementRelationDmgType[hitElement] == atkElement then
			damage = damage - damage *  DataGlobal.ElementRelationDmg.ivalue / 10000
		end
	end

	--if hit.elementStateComponent and magicParam.ElementType ~= FightEnum.ElementType.Phy then
		--hit.elementStateComponent:UpdateElementState(attack.instanceId, magicParam.ElementType, magicParam.ElementAccumulate)
	--end

	local isRestriction = self:_CalcElementValue(attack, hit, magicParam)
	-- print("damage "..damage.." atkDmgPercent "..atkDmgPercent.. " defDmgPercent "..defDmgPercent.." elementDmgPercent "..elementDmgPercent)
	return damage, isCrit, isRestriction
end

function DamageCalculate:_CalcElementValue(attack, hit, magicParam)
	local isRestriction = false
	local elementType = magicParam.ElementType
	if hit.elementStateComponent then
		local hitElementType = hit.elementStateComponent.elementType
		local hitElementAccu = hit.elementStateComponent.elementAccu
		local accuAmount = magicParam.ElementAccumulate
		--克制，包括克制的属性和相同的属性
		if elementType == hitElementAccu or elementType == hitElementType then
			accuAmount = accuAmount * 2
			isRestriction = true
		--被克制
		elseif FightEnum.ElementRelationDmgType[hitElementType] == elementType then
			accuAmount = accuAmount / 2
		end

		hit.elementStateComponent:UpdateElementState(attack.instanceId, hitElementAccu, accuAmount)
	end

	return isRestriction
end

function DamageCalculate:DoCure(fight, attack, hit, magicParam)
	if not self:CanCure(hit) then
		return
	end
	local atkAttrs = attack.attrComponent.attrs
	local hitAttrs = hit.attrComponent.attrs
	
	local cure = 0
	if magicParam.CureType == FightEnum.CureType.Normal then
		local cureAtkPercent = atkAttrs[AttrType.CureAtkPercent]
		local cureDefPercent = atkAttrs[AttrType.CureDefPercent]
		cure = (atkAttrs[AttrType.Attack] * magicParam.SkillParam / 10000 + magicParam.SkillAdditionParam) * 
			(1 + cureAtkPercent / 10000 + cureDefPercent / 10000)
	elseif magicParam.CureType == FightEnum.CureType.Percent then
		local attrs = magicParam.SkillCalculateType == 1 and atkAttrs or hitAttrs
		cure = attrs[AttrType.MaxLife] * magicParam.SkillParam / 10000
	elseif magicParam.CureType == FightEnum.CureType.ToPercent then
		cure = hitAttrs[AttrType.MaxLife] * magicParam.SkillParam / 10000 - hitAttrs[AttrType.Life]
		cure = math.max(cure, 0)
	elseif magicParam.CureType == FightEnum.CureType.Fixed then
		cure = magicParam.SkillParam
	end
	
	local flyPosition = hit.clientEntity.clientTransformComponent:GetTransform().position
	local fontType = FightConfig.FontType.HEAL
	local flyText = true
	--if hit.attrComponent.playerNpcTag then
		--local ctrlId = fight.playerManager:GetPlayer():GetCtrlEntity()
		--if attack.instanceId ~= ctrlId then
			--flyText = false
		--end
	--end

	if flyText and BehaviorFunctions.CheckEntity(hit.instanceId) then
		fight.clientFight.fontAnimManager:PlayAnimation(hit, fontType, math.floor(cure), true, nil, nil, flyPosition)
	end

	fight.entityManager:CallBehaviorFun("BeforeCure", attack, hit, magicParam.MagicId,cure)

	hit.attrComponent:AddValue(AttrType.Life, cure)

	fight.entityManager:CallBehaviorFun("Cure", attack, hit, magicParam.MagicId,cure)
	fight.entityManager:CallBehaviorFun("AfterCure", attack, hit, magicParam.MagicId,cure)
end

function DamageCalculate:CanDamage(hitEntity)
	return not hitEntity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneDamage)
end

function DamageCalculate:CanCure(hitEntity)
	return not hitEntity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneCure)
end

function DamageCalculate:__delete()
end