---@class DamageCalculate
DamageCalculate = BaseClass("DamageCalculate")

local AttrType = EntityAttrsConfig.AttrType 
local _floor = math.floor
local _max = math.max
local DataGlobal = Config.DataGlobal.data_global
local GlobalLevel = Config.DataGlobal.data_global_level
local EntityCommonConfig = Config.EntityCommonConfig
local RoleConfig = RoleConfig

local P = {}
P.InjuryReliefBase = DataGlobal.InjuryReliefBase.ivalue / 10000		  -- 伤害减免子乘区保底
P.AtkCritBase = DataGlobal.AtkCritBase.ivalue / 10000                 -- 双爆区保底值
P.IgnoreDefBase = DataGlobal.IgnoreDefBase.ivalue / 10000    	      -- 无视防御保底
P.WeaknessBase = DataGlobal.WeaknessBase.ivalue / 10000		          -- 脆弱状态保底
P.WeaknessParam1 = DataGlobal.WeaknessParam1.ivalue / 10000	          -- 脆弱状态公式参数1
P.WeaknessParam2 = DataGlobal.WeaknessParam2.ivalue / 10000	          -- 脆弱状态公式参数2
P.VulParam1 = DataGlobal.VulParam1.ivalue / 10000 		              -- 易伤状态公式参数1
P.VulParam2 = DataGlobal.VulParam2.ivalue  / 10000		              -- 易伤状态公式参数2
P.ResistanceParam1 = DataGlobal.ResistanceParam1.ivalue / 10000   	  -- 抗性公式参数1
P.ResistanceParam2 = DataGlobal.ResistanceParam2.ivalue / 10000    	  -- 抗性公式参数2
P.ResistanceParam3 = DataGlobal.ResistanceParam3.ivalue / 10000       -- 抗性公式参数3
P.ResistanceParam4 = DataGlobal.ResistanceParam4.ivalue / 10000       -- 抗性公式参数4
P.PartInjuryRelief = DataGlobal.PartInjuryRelief.ivalue / 10000       -- 部位伤害减免
P.ArmorInjuryRelief = DataGlobal.ArmorInjuryRelief.ivalue / 10000     -- 霸体伤害减免
P.ElementRelationDmg = DataGlobal.ElementRelationDmg.ivalue / 10000   --五行克制伤害系数
P.ElementRelationBreak = DataGlobal.ElementRelationBreak.ivalue / 10000  --五行克制击破系数
P.DamagetoArmor = DataGlobal.DamagetoArmor.ivalue / 10000                --伤害转换霸体系数
P.AssassinateMinDmg = DataGlobal.AssassinateMinDmg.ivalue / 10000     --最小刺杀系数


local PlayerDefParam1 = 5     -- 角色承伤系数1
local PlayerDefParam2 = 500   -- 角色承伤系数2
local PlayerLvParam = 100     -- 角色防御等级系数
local MonsterLvParam = 100    -- 角色防御等级系数
local AtkLvParam = 100 		  -- 攻击方等级系数
local ElementFixPrama1 = 2    -- 抗性修正系数1
local ElementFixPrama2 = 0.5  -- 抗性修正系数2
local FightConfig = Config.FightConfig

local DamageBuild = {
	UniqueKey = 0, --唯一id

	--基础伤害区
	Atk = 0, --*合计攻击力
	SkillBase = 0, --技能倍率
	AtkAttrType = 0, --参考属性
	SkillPercent = 0, --技能倍率加成
	Extra = 0,--额外附加伤害

	--增伤区
	DmgDefercent = 0, --伤害减免、属性伤害减免
	DmgAtkPercent = 0, --伤害加成、属性伤害加成

	--双爆区
	UnableCrit = false, --必定不暴击
	IsCrit = false, --是否暴击
	TempCrit = 0, --临时暴击率
	TempCritDef = 0, --临时暴击抵抗
	CritDmgPercent = 0, --暴击伤害加成
	CritDmgDef = 0, --暴击伤害减免

	--防御区
	DefBase = 0, --*合计防御力
	IgnoreDefBase = 0, --基础无视防御
	IgnoreDef = {}, --#无视防御乘区
	IsWeaknees = false, --是否有脆弱效果
	Weakness = 0,--受击方脆弱
	DefLev = 0, --防御方等级

	--状态振幅区
	IsVulnerability = false, --是否有易伤效果
	Vulnerability = 0, --易伤和

	--状态强度区
	ElementAtk = 0, --攻击方强度(元素精通,放大易伤和脆弱效果)

	--抗性区
	ThroughPercentE = 0, --穿透
	DefPercentE = 0, --抵抗

	--部位承伤区
	IsHitPart = false, --是否名字部位
	PartDefPercent = 0, --部位伤害减免
	PartAtkPercent = 0, --部位伤害加成

	--霸体减伤区
	IsArmor = false, --是否存在霸体
	ArmorDefPercent = 0, --霸体伤害减免

	--元素克制区
	IsElementRelation = false, --是否克制
	BeElementRelation = false, --是否被克制
	ElementRelationValue = 0, --元素克制加成
	ApplyRelation = false, --应用元素克制

	--五行击破效果值
	ElementBreakValue = 0, -- 五行击破基础值
	ElementBreakPercent = 0, --五行击破加成
	ApplyBreak = false, --应用五行击破克制

	DmgLog = {}
}

local CureBuild = {
	CureAtk = 0, --治疗主属性
	SkillBase = 0, --技能倍率
	SkillPercent = 0, --技能倍率加成
	Extra = 0, --额外治疗量

	CurePercent = 0,--治疗加成和
}

local DamageParam = FightEnum.DamageParam
local CureParam = FightEnum.CureParam

local _type = type

function DamageCalculate:ChangeDamageParam(type, value)
	local damageInfo = self.damageInfos[#self.damageInfos]
	if value == nil then
		LogError("该参数不能为空", type)
		return
	end

	if not DamageBuild[type] and not damageInfo[type] then
		LogError("该参数不能修改", type)
		return
	end

	if FightEnum.PercentParam[type] then
		value = value * 0.0001
	end

	if DamageBuild[type] then
		if _type(DamageBuild[type]) == "boolean" then
			DamageBuild[type] = DamageBuild[type] or value
		elseif _type(DamageBuild[type]) == "table"then
			table.insert(DamageBuild[type], value)
		elseif _type(DamageBuild[type]) == "number" then
			DamageBuild[type] = DamageBuild[type] + value
		else
			DamageBuild[type] = DamageBuild[type]
		end
	else
		damageInfo[type] = value
	end
end

function DamageCalculate:GetDamageParam(type)
	local damageInfo = self.damageInfos[#self.damageInfos]
	local res
	if DamageBuild[type] then
		res = DamageBuild[type]
	elseif damageInfo[type] then
		res = damageInfo[type]
	else
		LogError("类型不存在", type)
		return
	end
	if FightEnum.PercentParam[type] then
		res = res * 10000
	end
	return res
end


function DamageCalculate:ChangeCureParam(type, value)
	if not value then
		LogError("该参数不能为空", type)
	end

	if FightEnum.PercentParam[type] then
		value = value * 0.0001
	end
	if _type(CureBuild[type]) == "boolean" then
		CureBuild[type] = CureBuild[type] or value
	else
		CureBuild[type] = CureBuild[type] + value
	end
end

function DamageCalculate:GetCureParam(type)
	local res = CureBuild[type]
	if FightEnum.PercentParam[type] then
		res = res * 10000
	end
	return res
end

function DamageCalculate:__init()
	self.damageInfos = {}
	self.cacheDamageInfo = {}
end

function DamageCalculate:PopDamageInfo()
	local info
	if next(self.cacheDamageInfo) then
		info = table.remove(self.cacheDamageInfo, #self.cacheDamageInfo)
	end
	info = info or {}
	table.insert(self.damageInfos, info)
	return info
end

function DamageCalculate:CacheDamageInfo(info)
	local info = table.remove(self.damageInfos, #self.damageInfos)
	TableUtils.ClearTable(info)
	table.insert(self.cacheDamageInfo, info)
end

function DamageCalculate:DoDamage(fight, attack, hit, magicParam, part, attackEntity)
	local damageInfo = self:PopDamageInfo()

	local partType = 0
	if part then
		if not part:CheckHurtDamage() then
			return
		end
		partType = part.config.PartType
		damageInfo.partType = partType
	end

	local atkAttr
	if magicParam.UseAttrType then
		if magicParam.UseAttrType == FightEnum.UseAttrType.Self then
			atkAttr = attack.attrComponent
		elseif magicParam.UseAttrType == FightEnum.UseAttrType.Creator then
			atkAttr = attack.parent.attrComponent
		elseif magicParam.UseAttrType == FightEnum.UseAttrType.CreatorRoot then
			atkAttr = attack.root.attrComponent
		end
	elseif attack.attrComponent then
		atkAttr = attack.attrComponent
		Log("伤害使用属性来源未配置,默认攻击者使用自身，MagicId:",magicParam.MagicId)
	else
		LogError("伤害使用属性来源未配置,且攻击者自身没有属性组件,MagicId:", magicParam.MagicId)
	end
	
	local hitAttr = hit.attrComponent
	if attack.root then
		damageInfo.rootInstanceId = attack.root.instanceId
	else
		LogError("实体的root为空，请检查!", attack.entityId)
		damageInfo.rootInstanceId = attack.instanceId
	end

	damageInfo.skillType = magicParam.DamageSkillType or 0
	damageInfo.attackType = 0
	damageInfo.attackInstanceId = 0
	if attackEntity and attackEntity.attackComponent then
		--子弹类型
		if attackEntity.attackComponent.attackType ~= 0 then
			damageInfo.attackType = attackEntity.attackComponent.attackType
		end
		--伤害类型
		if attackEntity.attackComponent:GetSkillType() ~= 0 then
			damageInfo.skillType = attackEntity.attackComponent:GetSkillType()
		end
		damageInfo.attackInstanceId = attackEntity.instanceId
	elseif magicParam._SkillType and magicParam._SkillType ~= 0 then
		damageInfo.skillType = magicParam._SkillType
	end

	damageInfo.atkTag = FightEnum.EntityNpcTag.None
	if attack.tagComponent then
		damageInfo.atkTag = attack.tagComponent.npcTag
	end

	damageInfo.atkCamp = 0
	if attack.tagComponent then
		damageInfo.atkCamp = attack.tagComponent.camp
	end


	damageInfo.atkElement = attack.elementStateComponent and attack.elementStateComponent.config.ElementType
	damageInfo.atkElement = damageInfo.atkElement or FightEnum.ElementType.Phy
	damageInfo.hitElement = hit.elementStateComponent and hit.elementStateComponent.config.ElementType 
	damageInfo.hitElement = damageInfo.hitElement or FightEnum.ElementType.Phy
	damageInfo.dmgElement = magicParam.ElementType
	if not self:CanDamage(hit) then
		self:_ClearBuild(DamageBuild)
		self:GetElementArea(attack, hit, atkAttr, hit.attrComponent, magicParam, damageInfo)
		self:CalcElementValueV2(attack, hit, atkAttr, hit.attrComponent, magicParam, damageInfo)
		return
	end
	
	--技能系数
	local flyPosition
	UnityUtils.BeginSample("DamageCalculate:_CalcDamage")
	local damage, isCrit, isRestriction = self:_CalcDamageV2(attack, hit, atkAttr, hitAttr, magicParam, damageInfo)

	UnityUtils.EndSample()
	local armor = damage * P.DamagetoArmor
	if magicParam.DamageKind ~= FightEnum.DamageType.Assassinate and part and part.damageParam then
		flyPosition = part:HurtDamage(damage * part.damageParam,attackEntity)
	end

	hit.attrComponent:AddValue(AttrType.Armor, -armor)
	damageInfo.damage = damage
	if damageInfo.dmgElement < 1 or damageInfo.dmgElement > 6 then
		LogError("伤害元素类型不存在,MagicId:", magicParam.MagicId)
	end
	fight.entityManager:CallBehaviorFun("BeforeDamage", attackEntity.instanceId, hit.instanceId, 
	magicParam.DamageType,magicParam.MagicId, damageInfo.dmgElement, damage, damageInfo.attackType,
	partType, damageInfo,damageInfo.rootInstanceId, isCrit)
	damage = damageInfo.damage
	
	if ctx then
		local fontType = FightConfig.FontType.DAMAGE + damageInfo.dmgElement
		local flyText = true
		local isPlayer = atkAttr.playerNpcTag
		if isPlayer then
			local ctrlId = fight.playerManager:GetPlayer():GetCtrlEntity()
			if damageInfo.rootInstanceId ~= ctrlId then
				flyText = false
			end
		end

		if flyText and BehaviorFunctions.CheckEntity(hit.instanceId) then
			fight.clientFight.fontAnimManager:PlayAnimation(hit, fontType, math.floor(damage), isCrit, isRestriction, nil, flyPosition)
		end
	end

	-- GM命令
	if ctx.IsDebug then
		if DebugClientInvoke.Cache.damageMultiplier then
			local player = BehaviorFunctions.fight.playerManager:GetPlayer()
			if player and damageInfo.rootInstanceId == player.ctrlId then
				damage = damage * DebugClientInvoke.Cache.damageMultiplier
			end
		end

		if DebugClientInvoke.Cache.IsInvincibleSwitchOn then
			local isAtkPlayer = atkAttr.playerNpcTag
			if not isAtkPlayer then
				damage = 0
			end
		end
	end

	hit.attrComponent:SetDamageAttackEntity(attack)
	local originalDamage = damage
	damage = hit.attrComponent:DeductShield(damage) --护盾吸收伤害
	hit.attrComponent:AddValue(AttrType.Life, -damage)

	damageInfo.damage = originalDamage
	local elementBreakValue = DamageBuild.ElementBreakValue
	fight.entityManager:CallBehaviorFun("Damage", attackEntity.instanceId, hit.instanceId, 
	magicParam.DamageType,magicParam.MagicId, damageInfo.dmgElement, originalDamage, damageInfo.attackType,partType,
	damageInfo,damageInfo.rootInstanceId, isCrit)

	EventMgr.Instance:Fire(EventName.OnDoDamage, attackEntity.instanceId, hit.instanceId, magicParam.DamageType, 
	magicParam.MagicId, damageInfo.dmgElement, originalDamage, damageInfo.attackType,damageInfo.rootInstanceId, 
	elementBreakValue)

	fight.entityManager:CallBehaviorFun("AfterDamage", attackEntity.instanceId, hit.instanceId, 
	magicParam.DamageType,magicParam.MagicId, damageInfo.dmgElement, originalDamage, damageInfo.attackType,partType,
	damageInfo,damageInfo.rootInstanceId, isCrit)

	self:CacheDamageInfo()
end

function DamageCalculate:ClearCureBuild()
	self:_ClearBuild(CureBuild)
end

function DamageCalculate:_ClearBuild(build)
	for k, v in pairs(build) do
		if k == "UniqueKey" then
			build[k] = build[k] + 1
		elseif type(v) == "table" then
			TableUtils.ClearTable(v)
		elseif type(v) == "boolean" then
			build[k] = false
		else
			build[k] = 0
		end
	end
end

function DamageCalculate:_CalcDamageV2(attack, hit, atkAttr, hitAttr, magicParam, damageInfo)
	local elementType = damageInfo.dmgElement

	self:_ClearBuild(DamageBuild)
	local dmgValue = self:GetBaseArea(attack, hit, atkAttr, hitAttr, magicParam, damageInfo) --基础伤害区
	if magicParam.DamageKind == FightEnum.DamageType.Normal then
		damageInfo.atkElement = attack.elementStateComponent and attack.elementStateComponent.config.ElementType 
		or FightEnum.ElementType.Phy
		damageInfo.hitElement = hit.elementStateComponent and hit.elementStateComponent.config.ElementType 
		or FightEnum.ElementType.Phy

		local rootInstanceId = damageInfo.rootInstanceId
		Fight.Instance.entityManager:CallBehaviorFun("BeforeGetDamageParam",rootInstanceId, hit.instanceId, 
		damageInfo.attackType, magicParam.DamageKind, damageInfo.dmgElement, magicParam.MagicId, damageInfo.attackInstanceId)

		--获取公式参数
		self:GetAddArea(attack, hit, atkAttr, hitAttr, magicParam, damageInfo)
		self:GetCritArea(attack, hit, atkAttr, hitAttr, magicParam, damageInfo)
		self:GetDefArea(attack, hit, atkAttr, hitAttr, magicParam, damageInfo)
		self:GetStateAddArea(attack, hit, atkAttr, hitAttr, magicParam, damageInfo)
		self:GetStateIntensityArea(attack, hit, atkAttr, hitAttr, magicParam, damageInfo)
		self:GetDiffArea(attack, hit, atkAttr, hitAttr, magicParam, damageInfo)
		self:GetPartArea(attack, hit, atkAttr, hitAttr, magicParam, damageInfo)
		self:GetArmorArea(attack, hit, atkAttr, hitAttr, magicParam, damageInfo)
		self:GetElementArea(attack, hit, atkAttr, hitAttr, magicParam, damageInfo)

		Fight.Instance.entityManager:CallBehaviorFun("BeforeCalculateDamage",rootInstanceId, hit.instanceId, 
		damageInfo.attackType, magicParam.DamageKind, damageInfo.dmgElement, magicParam.MagicId, damageInfo.attackInstanceId)

		--计算乘区值
		local v1 = self:CalcBaseArea()
		local v2 = self:CalcAddArea()
		local v3 = self:CalcCritArea()
		local v4 = self:CalcDefArea()
		local v5 = self:CalcStateAddArea()
		local v6 = self:CalcStateIntensityArea()
		local v7 = self:CalcDiffArea()
		local v8 = self:CalcPartArea()
		local v9 = self:CalcArmorArea()
		local v10 = self:CalcElementArea()
		dmgValue = v1 * v2 * v3 * v4 * v5 * v6 * v7 * v8 * v9 * v10
	end
	local isRestriction = self:CalcElementValueV2(attack, hit, atkAttr, hitAttr, magicParam, damageInfo)

	if DebugConfig.ShowDamageLog then
		local orginMagicId = magicParam.orginMagicId
		local magicId =  magicParam.MagicId
		local magicLev = magicParam.magicLevel
		local log = "伤害信息：攻击实体: %s, 受击实体: %s, orginMagicId: %s, magicId: %s magicLev: %s"
		table.insert(DamageBuild.DmgLog, 1, string.format(log, attack.entityId, hit.entityId, orginMagicId, magicId, magicLev))
		LogTable(string.format("伤害计算结果：%s， 详细构成如下", dmgValue), DamageBuild.DmgLog)
		--LogTable("详细计算数据", DamageBuild)
	end

	return dmgValue, DamageBuild.IsCrit, isRestriction
end

function DamageCalculate:CalcElementValueV2(attack, hit, atkAttr, hitAttr, magicParam, damageInfo)
	local isRestriction = nil
	local elementType = damageInfo.dmgElement
	-- 物理属性
	-- if elementType == 1 then
	-- 	return
	-- end
	if not hit.elementStateComponent then
		return
	end
	DamageBuild.ElementBreakValue = magicParam.ElementAccumulate + DamageBuild.ElementBreakValue
	DamageBuild.ElementBreakPercent = DamageBuild.ElementBreakPercent + atkAttr:GetValue(AttrType.ElementBreakPercent)

	local accuAmount = (DamageBuild.ElementBreakValue * (1 + DamageBuild.ElementBreakPercent))
	--克制
	if DamageBuild.IsElementRelation and DamageBuild.ApplyBreak then
		accuAmount = accuAmount* P.ElementRelationBreak
		isRestriction = true
	--被克制
	elseif DamageBuild.BeElementRelation and DamageBuild.ApplyBreak then
		--accuAmount =  accuAmount / P.ElementRelationBreak
		isRestriction = false
	end

	if DebugConfig.ShowDamageLog then
		local log = "五行击破值(非伤害乘区)：合计 %s, 基础值 = %s, 击破加成 = %s, 是否克制 = %s, 是否被克制 = %s, 是否应用克制 = %s"
		table.insert(DamageBuild.DmgLog, 
		string.format(log, accuAmount, DamageBuild.ElementBreakValue, DamageBuild.ElementBreakPercent,
		tostring(DamageBuild.IsElementRelation), tostring(DamageBuild.BeElementRelation),tostring(DamageBuild.ApplyBreak)))
	end

	local hitElementAccu = hit.elementStateComponent.elementAccu	
	hit.elementStateComponent:UpdateElementState(attack.instanceId, hitElementAccu, accuAmount)
	return isRestriction
end

function DamageCalculate:CalcBaseArea()
	-- --基础伤害区
	-- Atk = 0, --合计攻击力
	-- SkillBase = 0, --技能倍率
	-- SkillPercent = 0, --技能倍率加成
	-- Extra = 0,--额外附加伤害

	local res = DamageBuild.Atk * DamageBuild.SkillBase * (1 + DamageBuild.SkillPercent) + DamageBuild.Extra
	if DebugConfig.ShowDamageLog then
		local name = EntityAttrsConfig.GetAttrName(DamageBuild.AtkAttrType)
		local log = "基础伤害区：合计 %s ,参考属性[%s] = %s, 技能倍率 = %s, 技能倍率加成 = %s, 额外附加伤害 = %s"
		table.insert(DamageBuild.DmgLog, 
		string.format(log, res, name, DamageBuild.Atk, DamageBuild.SkillBase, DamageBuild.SkillPercent, DamageBuild.Extra))
	end
	return res
end

function DamageCalculate:CalcAddArea()
	-- --增伤区
	-- DmgDefercent = 0, --伤害减免、属性伤害减免
	-- DmgAtkPercent = 0, --伤害加成、属性伤害加成
	local dmgDefercent = _max((1 - DamageBuild.DmgDefercent), P.InjuryReliefBase)
	local res = (1 + DamageBuild.DmgAtkPercent) * dmgDefercent

	if DebugConfig.ShowDamageLog then
		local log = "增伤区：合计 %s, 伤害加成 = %s, 伤害减免 = %s"
		table.insert(DamageBuild.DmgLog, 
		string.format(log, res, DamageBuild.DmgAtkPercent, DamageBuild.DmgDefercent))
	end
	return res
	
end
function DamageCalculate:CalcCritArea()
	-- --双爆区
	-- isCrit = false, --是否暴击
	-- UnableCrit = false --必定不暴击
	-- TempCrit = 0, --临时暴击率
	-- TempCritDef = 0, --临时暴击抵抗
	-- CritDmgPercent = 0, --暴击伤害加成
	-- CritDmgDef = 0, --暴击伤害减免
	local res
	if DamageBuild.UnableCrit then
		DamageBuild.IsCrit = false
	end
	if DamageBuild.IsCrit then
		res = 1 + DamageBuild.CritDmgPercent - DamageBuild.CritDmgDef
	else
		res = 1
	end

	res = _max(res, P.AtkCritBase)

	if DebugConfig.ShowDamageLog then
		local log = "双爆区：合计 %s, 是否暴击 = %s, 暴击伤害加成 = %s, 暴击伤害减免 = %s"
		table.insert(DamageBuild.DmgLog, 
		string.format(log, res, tostring(DamageBuild.IsCrit), DamageBuild.CritDmgPercent, DamageBuild.CritDmgDef))
	end

	return res
end
function DamageCalculate:CalcDefArea()
	-- --防御区
	-- DefBase = 0, --合计防御力
	-- IgnoreDefBase = 0, --基础无视防御
	-- IgnoreDef = {}, --#无视防御乘区
	-- IsWeaknees = false, --是否有脆弱效果
	-- Weakness = 0,--受击方脆弱
	-- ElementAtk = 0, --攻击方强度(元素精通)
	-- DefLev = 0, --防御方等级

	local res

	local K = GlobalLevel[DamageBuild.DefLev].ivalue
	local realDefPercent = 1 - DamageBuild.IgnoreDefBase

	for _, v in pairs(DamageBuild.IgnoreDef) do
		realDefPercent = realDefPercent * (1 - v)
	end

	realDefPercent = _max(P.IgnoreDefBase, realDefPercent)

	if DamageBuild.IsWeaknees then
		local weaknees =  _max(P.WeaknessBase, 1 - DamageBuild.Weakness)
		local weakneesRes = weaknees * P.WeaknessParam1 / (P.WeaknessParam1 + P.WeaknessParam2 * DamageBuild.ElementAtk)
	
		res = K / (DamageBuild.DefBase * realDefPercent * weakneesRes + K)
	else
		res = K / (DamageBuild.DefBase * realDefPercent + K)
	end

	if DebugConfig.ShowDamageLog then
		local log = "防御区：合计 %s, 防御力 = %s, 无视防御 = %s, 防御方等级 = %s, 是否脆弱 = %s, 攻击方强度(元素精通) = %s, 受击方脆弱 = %s"
		table.insert(DamageBuild.DmgLog, 
		string.format(log, res, DamageBuild.DefBase, 1 - realDefPercent, DamageBuild.DefLev, 
		tostring(DamageBuild.IsWeaknees), DamageBuild.ElementAtk, DamageBuild.Weakness))
	end

	return res
end

function DamageCalculate:CalcStateAddArea()
	-- --状态振幅区
	-- IsVulnerability = false, --是否有易伤效果
	-- Vulnerability = 0, --易伤和
	local res = 1
	if DamageBuild.IsVulnerability then
		res = res * (1 + DamageBuild.Vulnerability)
	end

	if DebugConfig.ShowDamageLog then
		local log = "状态增幅区：合计 %s, 是否存在易伤 = %s, 易伤和 = %s"
		table.insert(DamageBuild.DmgLog, 
		string.format(log, res, tostring(DamageBuild.IsVulnerability), DamageBuild.Vulnerability))
	end

	return res
end
function DamageCalculate:CalcStateIntensityArea()
	-- --状态强度区
	-- ElementAtk = 0, --攻击方强度(元素精通)
	local res = 1
	if DamageBuild.IsVulnerability then
		res = res * (1 + P.VulParam1 * DamageBuild.ElementAtk / (DamageBuild.ElementAtk + P.VulParam2))
	end

	if DebugConfig.ShowDamageLog then
		local log = "状态强度区：合计 %s, 是否存在易伤 = %s, 攻击方强度(元素精通) = %s"
		table.insert(DamageBuild.DmgLog, 
		string.format(log, res, tostring(DamageBuild.IsVulnerability), DamageBuild.ElementAtk))
	end
	return res
end
function DamageCalculate:CalcDiffArea()
	-- --抗性区
	-- ThroughPercentE = 0, --穿透
	-- DefPercentE = 0, --抵抗
	local finalValue = DamageBuild.DefPercentE - DamageBuild.ThroughPercentE
	local res
	if finalValue <= 0 then
		res = 1 + P.ResistanceParam1 * finalValue / (finalValue - P.ResistanceParam2)
	else
		res = 1 / (1 + P.ResistanceParam3 * finalValue) ^ P.ResistanceParam4
	end

	if DebugConfig.ShowDamageLog then
		local log = "抗性区：合计 %s, 穿透 = %s, 抵抗 = %s"
		table.insert(DamageBuild.DmgLog, 
		string.format(log, res, DamageBuild.ThroughPercentE, DamageBuild.DefPercentE))
	end
	return res
end
function DamageCalculate:CalcPartArea()
	-- --部位承伤区
	-- IsHitPart = false, --是否名字部位
	-- PartDefPercent = 0, --部位伤害减免
	-- PartAtkPercent = 0, --部位伤害加成
	local res = 1
	if DamageBuild.IsHitPart then
		local partDefPercent = _max(P.PartInjuryRelief, (1 - DamageBuild.PartDefPercent))
		res = (1 + DamageBuild.PartAtkPercent) * partDefPercent
	end

	if DebugConfig.ShowDamageLog then
		local log = "部位承伤区：合计%s, 是否命中部位 = %s, 部位伤害减免 = %s, 部位伤害加成 = %s"
		table.insert(DamageBuild.DmgLog, 
		string.format(log, res, tostring(DamageBuild.IsHitPart), DamageBuild.PartDefPercent, DamageBuild.PartAtkPercent))
	end

	return res
end
function DamageCalculate:CalcArmorArea()
	-- --霸体减伤区
	-- IsArmor = false, --是否存在霸体
	-- ArmorDefPercent = 0, --霸体伤害减免
	local res = 1
	if DamageBuild.IsArmor then
		local armorDefPercent = DamageBuild.ArmorDefPercent
		res = _max(1 - armorDefPercent, P.ArmorInjuryRelief)
	end

	if DebugConfig.ShowDamageLog then
		local log = "霸体减伤区：合计%s, 是否命中霸体 = %s, 霸体伤害减免 = %s"
		table.insert(DamageBuild.DmgLog, 
		string.format(log, res, tostring(DamageBuild.IsArmor), DamageBuild.ArmorDefPercent))
	end

	return res
end
function DamageCalculate:CalcElementArea()
	-- --元素克制区
	-- IsElementRelation = false, --是否克制
	-- BeElementRelation = false,--是否被克制
	-- ElementRelationValue = 0, --元素克制加成
	local res = 1
	if DamageBuild.IsElementRelation and DamageBuild.ApplyRelation then
		res = 1 + (P.ElementRelationDmg + DamageBuild.ElementRelationValue)
	elseif DamageBuild.BeElementRelation and DamageBuild.ApplyRelation then
		--res = 1 - (P.ElementRelationDmg + DamageBuild.ElementRelationValue)
	end
	if DebugConfig.ShowDamageLog then
		local log = "元素克制区：合计%s, 是否克制 = %s, 是否被克制 = %s, 额外元素克制加成 = %s, 是否应用克制 = %s"
		table.insert(DamageBuild.DmgLog, 
		string.format(log, res, tostring(DamageBuild.IsElementRelation), tostring(DamageBuild.BeElementRelation), 
		DamageBuild.ElementRelationValue, tostring(DamageBuild.ApplyRelation)))
	end
	return res
end

--基础区
function DamageCalculate:GetBaseArea(attack, hit, atkAttr, hitAttr, magicParam, damageInfo)
	local entityAtkLevel = atkAttr.level
	local entityDefLevel = hit.attrComponent.level
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
		local dmgAttrType = AttrType.Attack
		if magicParam.DmgAttrType then
			dmgAttrType = magicParam.DmgAttrType
		end
		DamageBuild.AtkAttrType = dmgAttrType
		DamageBuild.Atk = atkAttr:GetValue(dmgAttrType) + DamageBuild.Atk
		DamageBuild.SkillBase = skillParam / 10000 + DamageBuild.SkillBase
		DamageBuild.SkillPercent = atkAttr:GetValue(AttrType.SkillPercent) + DamageBuild.SkillPercent
		DamageBuild.Extra = magicParam.SkillBaseDmg + DamageBuild.Extra
	elseif magicParam.DamageKind == FightEnum.DamageType.Assassinate then
		local levelDiff = entityDefLevel - entityAtkLevel > EntityCommonConfig.AssassinateMinLvDiff 
		and entityDefLevel - entityAtkLevel - EntityCommonConfig.AssassinateMinLvDiff or 0
		local percent = (skillParam / 10000) - hitAttr:GetValue(AttrType.AssassinateDef) - (levelDiff * EntityCommonConfig.AssassinateLvParam)
		percent = percent < P.AssassinateMinDmg and P.AssassinateMinDmg or percent
		baseDmg = hitAttr:GetValue(AttrType.MaxLife) * percent
	elseif magicParam.DamageKind == FightEnum.DamageType.Percent then
		baseDmg = hitAttr:GetValue(AttrType.MaxLife) * skillParam / 100
	elseif magicParam.DamageKind == FightEnum.DamageType.Fixed then
		baseDmg = skillParam
	end

	return baseDmg
end

--伤害增幅区
function DamageCalculate:GetAddArea(attack, hit, atkAttr, hitAttr, magicParam, damageInfo)
	local dmgElement = damageInfo.dmgElement
	local atkKey = "AtkPercentEl"..dmgElement
	DamageBuild.DmgAtkPercent = atkAttr:GetValue(AttrType.DmgAtkPercent) + atkAttr:GetValue(AttrType[atkKey]) + DamageBuild.DmgAtkPercent
	DamageBuild.DmgDefercent = hitAttr:GetValue(AttrType.DmgDefercent)  + DamageBuild.DmgDefercent
end

--双爆区
function DamageCalculate:GetCritArea(attack, hit, atkAttr, hitAttr, magicParam, damageInfo)
	if not DamageBuild.IsCrit then
		local atkCrit = atkAttr:GetValue(AttrType.CritPercent) + DamageBuild.TempCrit
		local defCrit = hitAttr:GetValue(AttrType.CritDefPercent) + DamageBuild.TempCritDef
		DamageBuild.IsCrit = atkCrit - defCrit >= math.random()
	end
	if DamageBuild.UnableCrit then
		DamageBuild.IsCrit = false
	end
	if DamageBuild.IsCrit then
		DamageBuild.CritDmgPercent = atkAttr:GetValue(AttrType.CritAtkPercent) + DamageBuild.CritDmgPercent
		DamageBuild.CritDmgDef = hitAttr:GetValue(AttrType.CritDecPercent) + DamageBuild.CritDmgDef
	end
end
--防御区
function DamageCalculate:GetDefArea(attack, hit, atkAttr, hitAttr, magicParam, damageInfo)
	DamageBuild.DefBase =  hitAttr:GetValue(AttrType.Defense)
	DamageBuild.IgnoreDefBase = atkAttr:GetValue(AttrType.IgnoreDefPercent)
	DamageBuild.DefLev = hit.attrComponent.level
	local weakValue = hitAttr:GetValue(AttrType.WeaknessPercent)
	local vulValue =  hitAttr:GetValue(AttrType.VulPercent)
	if weakValue > 0 or vulValue > 0 then
		DamageBuild.ElementAtk = atkAttr:GetValue(AttrType.ElementAtk) + DamageBuild.ElementAtk
	end
	if weakValue > 0 then
		DamageBuild.IsWeaknees = true
		DamageBuild.Weakness = weakValue
	else
		DamageBuild.IsWeaknees = false
	end
end
--状态增幅区
function DamageCalculate:GetStateAddArea(attack, hit, atkAttr, hitAttr, magicParam, damageInfo)
	local vulValue =  hitAttr:GetValue(AttrType.VulPercent)
	if vulValue > 0 then
		DamageBuild.IsVulnerability = true
		DamageBuild.Vulnerability = vulValue
	end
end

--状态强度区
function DamageCalculate:GetStateIntensityArea(attack, hit, atkAttr, hitAttr, magicParam, damageInfo)
	local vulValue =  hitAttr:GetValue(AttrType.VulPercent)
	if vulValue > 0 then
		DamageBuild.IsVulnerability = true
	end
end

--抗性区
function DamageCalculate:GetDiffArea(attack, hit, atkAttr, hitAttr, magicParam, damageInfo)
	local dmgElement = damageInfo.dmgElement
	local atkKey = "ThroughPercentEl"..dmgElement
	local defKey = "DefPercentEl"..dmgElement
	DamageBuild.ThroughPercentE = atkAttr:GetValue(AttrType[atkKey]) + DamageBuild.ThroughPercentE
	DamageBuild.DefPercentE = hitAttr:GetValue(AttrType[defKey]) + DamageBuild.DefPercentE
	if damageInfo.partType and  damageInfo.partType ~= 0 then
		defKey = "PartDefPercentEl"..dmgElement
		DamageBuild.DefPercentE = hitAttr:GetValue(AttrType[defKey]) + DamageBuild.DefPercentE
	end
end

--部位承伤区
function DamageCalculate:GetPartArea(attack, hit, atkAttr, hitAttr, magicParam, damageInfo)
	if damageInfo.partType and damageInfo.partType ~= 0 then
		DamageBuild.IsHitPart = true
		DamageBuild.PartAtkPercent = atkAttr:GetValue(AttrType.PartAtkPercent) + DamageBuild.PartAtkPercent
		DamageBuild.PartDefPercent = hitAttr:GetValue(AttrType.PartDefPercent) + DamageBuild.PartDefPercent
	end
end

--霸体减伤区
function DamageCalculate:GetArmorArea(attack, hit, atkAttrs, hitAttrs, magicParam, damageInfo)
	local armorValue = hitAttrs:GetValue(AttrType.Armor)
	if armorValue > 0 then
		DamageBuild.IsArmor = true
		DamageBuild.ArmorDefPercent =  hitAttrs:GetValue(AttrType.ArmorDefPercent)
	end
end 

--元素克制区
function DamageCalculate:GetElementArea(attack, hit, atkAttrs, hitAttrs, magicParam, damageInfo)
	local dmgElement = damageInfo.dmgElement
	local hitElement = damageInfo.hitElement
	if damageInfo.atkTag == FightEnum.EntityNpcTag.Player then
		DamageBuild.ApplyRelation = true
		DamageBuild.ApplyBreak = true
	end
	
	if FightEnum.ElementRelationDmgType[dmgElement] == hitElement then
		--克制
		DamageBuild.IsElementRelation = true
	elseif FightEnum.ElementRelationDmgType[hitElement] == dmgElement then
		--被克制
		DamageBuild.BeElementRelation = true
	end
end

function DamageCalculate:_CalcDamage(attack, hit, atkAttrs, hitAttrs, magicParam, damageInfo)
	local elementType = damageInfo.dmgElement
	local entityAtkLevel = atkAttrs.level
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
		if attack.masterId and RoleConfig.GetRoleConfig(attack.masterId) then
			roleTypeDmgPercent = BehaviorFunctions.GetPlayerAttrVal(
				FightEnum.RoleDmgTypeToAttr[RoleConfig.GetRoleDmgType(attack.masterId)]
			)
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
		isCrit = damageInfo.atkCrit - hitAttrs[AttrType.CritDefPercent]>= math.random()
		--isCrit = _floor(atkAttrs[AttrType.CritPercent] - hitAttrs[AttrType.CritDefPercent]) >= math.random(1, 10000)
		local critDmgPercent = 1
		if isCrit then
			critDmgPercent = math.max(1 + atkAttrs[AttrType.CritAtkPercent] - hitAttrs[AttrType.CritDecPercent], P.AtkCritBase)
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
		local levelDiff = entityDefLevel - entityAtkLevel > EntityCommonConfig.AssassinateMinLvDiff 
		and entityDefLevel - entityAtkLevel - EntityCommonConfig.AssassinateMinLvDiff or 0
		
		local percent = (skillParam / 10000) - (hitAttrs[AttrType.AssassinateDef]) - (levelDiff * EntityCommonConfig.AssassinateLvParam)
		baseDmg = hitAttrs[AttrType.MaxLife] * percent
		baseDmg = baseDmg >= 0 and baseDmg or 0
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
			damage = damage + damage *  P.ElementRelationDmg
		elseif FightEnum.ElementRelationDmgType[hitElement] == atkElement then
			damage = damage - damage *  P.ElementRelationDmg
		end
	end

	--if hit.elementStateComponent and magicParam.ElementType ~= FightEnum.ElementType.Phy then
		--hit.elementStateComponent:UpdateElementState(attack.instanceId, magicParam.ElementType, magicParam.ElementAccumulate)
	--end

	local isRestriction = self:_CalcElementValue(attack, hit, magicParam, damageInfo)
	-- print("damage "..damage.." atkDmgPercent "..atkDmgPercent.. " defDmgPercent "..defDmgPercent.." elementDmgPercent "..elementDmgPercent)
	return damage, isCrit, isRestriction
end

function DamageCalculate:_CalcElementValue(attack, hit, magicParam, damageInfo)
	local isRestriction = nil
	local elementType = damageInfo.dmgElement
	-- 物理属性
	if elementType == 1 then
		return
	end
	if hit.elementStateComponent then
		local hitElementType = hit.elementStateComponent.elementType
		local hitElementAccu = hit.elementStateComponent.elementAccu
		local accuAmount = magicParam.ElementAccumulate
		--克制,包括克制的属性和相同的属性
		if hitElementType == FightEnum.ElementRelationDmgType[elementType] or elementType == hitElementType then
			accuAmount = accuAmount * P.ElementRelationBreak
			isRestriction = true
		--被克制
		elseif FightEnum.ElementRelationDmgType[hitElementType] == elementType then
			accuAmount = accuAmount / P.ElementRelationBreak
			isRestriction = false
		end

		hit.elementStateComponent:UpdateElementState(attack.instanceId, hitElementAccu, accuAmount)
	end

	return isRestriction
end

function DamageCalculate:DoCure(fight, attack, hit, magicParam)
	if not self:CanCure(hit) then
		return
	end
	local atkAttr = attack.attrComponent
	local hitAttr = hit.attrComponent
	
	self:_ClearBuild(CureBuild)

	fight.entityManager:CallBehaviorFun("BeforeCalculateCure", attack.instanceId, hit.instanceId, magicParam.MagicId)

	local cure = self:CalcCure(fight, attack, hit, atkAttr, hitAttr, magicParam)
	
	local flyPosition = hit.clientTransformComponent:GetTransform("HitCase").position
	local fontType = FightConfig.FontType.HEAL
	local flyText = true
	--if hit.attrComponent.playerNpcTag then
		--local ctrlId = fight.playerManager:GetPlayer():GetCtrlEntity()
		--if attack.instanceId ~= ctrlId then
			--flyText = false
		--end
	--end
	-- 后台角色不显示飘字
	if hit.tagComponent.npcTag == FightEnum.EntityNpcTag.Player then
		local ctrlId = BehaviorFunctions.fight.playerManager:GetPlayer():GetCtrlEntity()
		if ctrlId ~= hit.instanceId then
			flyText = false
		end
	end


	if flyText and BehaviorFunctions.CheckEntity(hit.instanceId) then
		fight.clientFight.fontAnimManager:PlayAnimation(hit, fontType, -math.floor(cure), true, nil, nil, flyPosition)
	end

	fight.entityManager:CallBehaviorFun("BeforeCure", attack.instanceId,  hit.instanceId, magicParam.MagicId,cure)

	hit.attrComponent:AddValue(AttrType.Life, cure)

	fight.entityManager:CallBehaviorFun("Cure", attack.instanceId,  hit.instanceId, magicParam.MagicId,cure)
	fight.entityManager:CallBehaviorFun("AfterCure", attack.instanceId,  hit.instanceId, magicParam.MagicId,cure)
end

function DamageCalculate:CalcCure(fight, attack, hit, atkAttr, hitAttr, magicParam)
	local cure = 0
	if magicParam.CureType == FightEnum.CureType.Normal then
		local cureAtkPercent = atkAttr:GetValue(AttrType.CureAtkPercent)
		local cureDefPercent = hitAttr:GetValue(AttrType.CureDefPercent)
		CureBuild.CurePercent = CureBuild.CurePercent + cureAtkPercent + cureDefPercent + 1
		local cureAttrType = AttrType.Attack
		if magicParam.CureAttrType then
			cureAttrType = magicParam.CureAttrType
		end
		CureBuild.CureAtk = atkAttr:GetValue(cureAttrType) + CureBuild.CureAtk
		CureBuild.SkillBase = magicParam.SkillParam / 10000 + CureBuild.SkillBase
		CureBuild.Extra = magicParam.SkillAdditionParam + CureBuild.Extra
		local skillBase = (1 + CureBuild.SkillPercent) * CureBuild.SkillBase
		cure = (CureBuild.CureAtk * skillBase + CureBuild.Extra) * CureBuild.CurePercent
	elseif magicParam.CureType == FightEnum.CureType.Percent then
		local attr = magicParam.SkillCalculateType == 1 and atkAttr or hitAttr
		cure = attr:GetValue(AttrType.MaxLife) * magicParam.SkillParam / 10000
	elseif magicParam.CureType == FightEnum.CureType.ToPercent then
		cure = hitAttr:GetValue(AttrType.MaxLife) * magicParam.SkillParam / 10000 - hitAttr:GetValue(AttrType.Life)
		cure = math.max(cure, 0)
	elseif magicParam.CureType == FightEnum.CureType.Fixed then
		cure = magicParam.SkillParam
	end


	return cure
end

function DamageCalculate:CanDamage(hitEntity)
	return not hitEntity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneDamage)
end

function DamageCalculate:CanCure(hitEntity)
	return not hitEntity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneCure)
end

function DamageCalculate:__delete()
end