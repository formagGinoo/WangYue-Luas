Behavior1010 = BaseClass("Behavior1010",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType

function Behavior1010.GetGenerates()
	local generates = {
	}
	return generates
end
function Behavior1010.GetOtherAsset()
	local generates = {
		BehaviorFunctions.GetEffectPath("22099"),
		BehaviorFunctions.GetUIEffectPath("UI_CoreUI1001_man"),
		BehaviorFunctions.GetEffectPath("22097"),
		BehaviorFunctions.GetEffectPath("22096"),
		BehaviorFunctions.GetUIEffectPath("UI_SkillPanel_jiuxu"),
		--BehaviorFunctions.GetEffectPath("22059"),
		--"Effect/UI/22060.prefab"
		"UIEffect/Prefab/UI_SkillPanel_changan.prefab",
	}
	return generates
end

function Behavior1010:Init()
	
	--通用参数组合初始化、角色组合合集
	self.RoleAllParm = BehaviorFunctions.CreateBehavior("RoleAllParm",self)
	self.RoleAllBehavior = BehaviorFunctions.CreateBehavior("RoleAllBehavior",self)

	--组合缩写
	self.RAP = self.RoleAllParm
	self.RAB = self.RoleAllBehavior

	--变量声明
	self.Me = self.instanceId		--记录自己

	self.NormalAttack = {1010001,1010002,1010003,1010004,1010005}  --普攻技能Id
	self.NormalSkill = {1010010}	--普通技能Id
	self.NormalDeriveSkill = {1010011,1010012}	--技能派生Id
	self.BurstAttack = {1010013,1010014,1010016}	--爆气连段技能Id
	self.CoreSkill = {1010040}	--核心技能Id
	self.MoveSkill = {1010030,1010031}	--闪避技能Id
	self.FallAttack = {1010170,1010171,1010172}	--下落攻击Id
	self.JumpAttack = {1010080,1010081,1010082}	--跳反技能
	self.UltimateSkill = {1010050,1010051}	--大招技能Id
	--self.PartnerConnect = {1001999}	--佩从连携技能id
	self.PartnerCall = {1010061,1010062,1010063,1010064} --佩从召唤动作
	self.PartnerHenshin = {1010060} --佩从变身动作集合
	
	self.QTEtype = 4			--QTE类型：1切换角色放技能，2不切换角色下场放技能，3AI援助,4转镜切人
	self.QTEPosRef = 1			--QTE出场坐标参考：1参考在场角色，2参考其他目标
	self.QTEChangeCD = 1		--QTE/切换角色冷却时间
	
	self.LockDistance = 15
	self.CancelLockDistance = 30
	
	self.RAP.backgroundRes1 = 6.1 --后台日相恢复速度，单位秒，多少秒回复一格
	
	self.CoreCost = 300 --需要多少核心资源来开爆气
	self.CoreStateTime = 13.5 --核心爆气状态持续时间，单位秒
	self.CoreStateframe = 0  --用来计算爆气时间(不用配)
	self.CoreState = false    --用来判断是否要减少核心能量
	self.DeriveSkillCostHP = 0.025   --技能派生烧自己当前%生命，0.1就是10%
	
	--==============================================================

end

function Behavior1010:LateInit()
	self.RAP:LateInit()
end


function Behavior1010:BeforeUpdate()
	--通用参数组合更新
	self.RAP:BeforeUpdate()

end

function Behavior1010:Update()
 
	if BF.CheckEntity(self.Me) then

		--通用参数组合更新
		self.RAP:Update()

		--角色目标选择判断
		self.RAB.RoleSelectTarget:Update(self.LockDistance,self.CancelLockDistance)

		--角色锁定目标判断
		self.RAB.RoleLockTarget:Update(self.LockDistance,self.CancelLockDistance)

		--按键缓存组合
		self.RAB.RoleClickButtonCache:Update()

		--角色释放技能组合，可复制最多3次，同帧内执行3种按键操作
		self:RoleCatchSkill()
		--self:RoleCatchSkill()

		--角色杂项判断（角色独立）
		self:Core()

		--通用角色参数开放
		self.RAP:SetEntityValuePart()
		
		--角色通用佩从判断
		self.RAB.RolePartnerBase:Update()
		
		--角色相机逻辑外接
		self.RAB.RoleCameraParm:Update()
		
		self.RoleList = BF.GetCurFormationEntities()	--获取全队id
		
		--判断技能窗口1010009，有的话且日相满足，则替换E或普攻的技能图标
		if BF.GetSkillSign(self.Me,1010009) then
			if BF.GetEntityAttrVal(self.Me,1201) >= 20000 then
				BF.SetFightUISkillBtnId(self.Me,FightEnum.KeyEvent.NormalSkill,1010012)
			end
			if BF.GetEntityAttrVal(self.Me,1201) >= 10000 then
				BF.SetFightUISkillBtnId(self.Me,FightEnum.KeyEvent.Attack,1010011)
			end
		else
			BF.SetFightUISkillBtnId(self.Me,FightEnum.KeyEvent.NormalSkill,1010010)
			BF.SetFightUISkillBtnId(self.Me,FightEnum.KeyEvent.Attack,1010001)		
		end	
	end
end

--核心相关逻辑
function Behavior1010:Core()
	
	--检查核心资源率
	self.RAP.CoreResRatio = BF.GetEntityAttrValueRatio(self.Me,1204)
	self.RAP.CoreRes = BF.GetEntityAttrVal(self.Me,1204)
	
	if self.CoreState == true then

		BF.ChangeEntityAttr(self.Me,1204,-(self.CoreCost/(self.CoreStateTime*30)),1)
		
		BF.SetBodyDamping(0.8,1,0.8)	--设置核心相机过渡
		self.RAP.extraCameraDistance = 0.2	--角色额外的相机距离
		
		if self.RAP.CoreRes == 0 then
			BF.RemoveBuffByGroup(self.Me,101004001) --移除所有爆气标记buff

			BF.RemoveBuffByGroup(self.Me,101004002) --移除所有【虎势】

			BF.RemoveBuffByGroup(self.Me,101004007) --移除所有【雷心】

			BF.RemoveBuffByGroup(self.Me,101004009) --移除所有虎势标记

			BF.ChangeDisableMask(self.Me,1005,false)   --取消屏蔽技能按钮
			
			self.CoreState = false
			
			BF.SetBodyDamping(0.5,0.5,0.5)	--设置核心相机过渡
			self.RAP.extraCameraDistance = 0	--角色额外的相机距离
		end
	end
		
	--计算核心爆气时间，时间到了处理相关逻辑
	--if self.RAP.RealFrame >= self.CoreStateframe then
		--BF.RemoveBuffByGroup(self.Me,101004001) --移除所有爆气标记buff
		
		--BF.RemoveBuffByGroup(self.Me,101004002) --移除所有【虎势】

		--BF.RemoveBuffByGroup(self.Me,101004007) --移除所有【雷心】
		
		--BF.RemoveBuffByGroup(self.Me,101004009) --移除所有虎势标记

		--BF.ChangeDisableMask(self.Me,1005,false)   --取消屏蔽技能按钮
	--end
	
	--核心UI动效判断 -- 核心资源充满
	if self.RAP.CtrlRole == self.Me and self.RAP.CoreRes >= self.CoreCost then
		BF.SetCoreEffectVisible(self.Me,"22092",true)
	else
		BF.SetCoreEffectVisible(self.Me,"22092",false)
	end

	--角色在场逻辑
	if self.RAP.CtrlRole == self.Me then

		BF.SetCoreUIScale(self.Me, 0.8)
		--BF.SetCoreUIPosition(self.Me, 0, 0)
		
		--核心UI显示判断
		if (BF.CheckPlayerInFight() or self.RAP.CoreUiFrame > self.RAP.RealFrame) then
			BF.SetCoreUIVisible(self.Me, true, 0.2)
		else
			BF.SetCoreUIVisible(self.Me, false, 0.5)
		end

		--核心按钮长按提示判断
		if self.RAP.CoreRes >= self.CoreCost then
			BF.PlaySkillUIEffect("UIEffect/Prefab/UI_SkillPanel_changan.prefab","J")
			BF.SetPlayerCoreEffectVisible("20027", true)
			BF.SetPlayerCoreEffectVisible("20028", true)
		else
			BF.StopSkillUIEffect("UIEffect/Prefab/UI_SkillPanel_changan.prefab","J")
			BF.SetPlayerCoreEffectVisible("20027", false)
			BF.SetPlayerCoreEffectVisible("20028", false)
		end
	end
end

--重写角色释放技能组合
function Behavior1010:RoleCatchSkill()
	--检查点击缓存
	local ClickButton = 0
	if self.RAP.ClickButton[1] ~= 0 and self.RAP.ClickButton[1] ~= nil then
		ClickButton = 1
	elseif self.RAP.ClickButton[2] ~= 0 and self.RAP.ClickButton[2] ~= nil then
		ClickButton = 2
	elseif self.RAP.ClickButton[3] ~= 0 and self.RAP.ClickButton[3] ~= nil then
		ClickButton = 3
	end
	--检查长按缓存
	local PressButton = 0
	if self.RAP.PressButton[1] ~= 0 and self.RAP.PressButton[1] ~= nil then
		PressButton = 1
	elseif self.RAP.PressButton[2] ~= 0 and self.RAP.PressButton[2] ~= nil then
		PressButton = 2
	elseif self.RAP.PressButton[3] ~= 0 and self.RAP.PressButton[3] ~= nil then
		PressButton = 3
	end
	--按钮存在判断
	if ((ClickButton == 1 or ClickButton == 2 or ClickButton == 3) or (PressButton == 1 or PressButton == 2 or PressButton == 3))
		and BF.CheckEntityForeground(self.Me) then
		--进行跳跃流程
		if self.RAP.ClickButton[ClickButton] == FK.Jump and not BF.HasBuffKind(self.Me,1000033) and not BF.HasBuffKind(self.Me,1000034)
			and (self.RAP.MyState ~= FES.Climb or (self.RAP.MyState == FES.Climb and not BF.CheckKeyPress(FK.Jump))) and (self.RAP.MyState ~= FES.Skill
				or (self.RAP.MyState == FES.Skill and BF.GetSkillConfigSign(self.Me) ~= 50 and BF.GetSkillConfigSign(self.Me) ~= 80 and BF.GetSkillConfigSign(self.Me) ~= 81 
					and BF.GetSkillConfigSign(self.Me) ~= 170 and BF.GetSkillConfigSign(self.Me) ~= 171 ))then
			if self.RAP.MyState == FES.Skill then
				BF.BreakSkill(self.Me)
			end
			if BF.DoJump(self.Me) then
				self.RAB.RoleCatchSkill:ClearButtonPart(ClickButton,"ClearClick")
			end
			
			--大招释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.UltimateSkill and BF.CheckEntityHeight(self.Me) == 0 then
			if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.UltimateSkill[1],6,5,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
				BF.CastSkillCost(self.Me,self.UltimateSkill[1])
			end
			
			--闪避释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.Dodge and BF.CheckEntityHeight(self.Me) == 0 then
			if self.RAB.RoleCatchSkill:MoveSkill(ClickButton,5,5,0,0,0,{21},"ClearClick") then
				BF.CastSkillCost(self.Me,self.MoveSkill[1],"ClearClick")
			end
			
			--普通技能释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.NormalSkill and BF.CheckEntityHeight(self.Me) == 0 then
			if BF.GetSkillSign(self.Me,1010001) then
				if self.RAP.ClickButton[ClickButton] == FK.NormalSkill and BF.GetEntityAttrVal(self.Me,1201) >= 20000 then
					self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalDeriveSkill[2],3,3,0,0,0,{0},"Immediately","ClearClick",true,0,-1)
				end
			else
				if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalSkill[1],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
					BF.CastSkillCost(self.Me,self.NormalSkill[1])
				end
			end
			--if self.RAP.ClickButton[ClickButton] == FK.NormalSkill and BF.GetEntityAttrValueRatio(self.Me,1201) >= 10000 then
				--self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalDeriveSkill[2],3,3,0,0,0,{0},"Immediately","ClearClick",true,0,-1)
			--elseif self.RAP.ClickButton[ClickButton] == FK.Attack and BF.GetEntityAttrValueRatio(self.Me,1201) >= 5000 then
				--self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalDeriveSkill[1],3,3,0,0,0,{0},"Immediately","ClearClick",true,0,-1)
			--end

			--普攻长按释放判断(空中)
		elseif self.RAP.PressButton[PressButton] == FK.Attack and self.RAP.PressButtonFrame[PressButton] >= 7
			and BF.CheckEntityHeight(self.Me) >= 1 then
			self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.FallAttack[1],170,170,0,0,0,{0},"0","ClearPress",true,0,-1)
			
			--普攻长按释放判断(地面)
		elseif self.RAP.PressButton[PressButton] == FK.Attack and self.RAP.PressButtonFrame[PressButton] >= 12
			and BF.CheckEntityHeight(self.Me) == 0 and self.RAP.CoreRes >= self.CoreCost then
				self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.CoreSkill[1],4,4,0,0,0,{0},"Immediately","ClearPress",true,0,-1)

			--普攻点按释放判断(地面)
		elseif self.RAP.ClickButton[ClickButton] == FK.Attack and BF.CheckEntityHeight(self.Me) == 0 then
			--爆气后点普攻
			if BF.GetBuffCount(self.Me,101004001) > 0 or BF.GetBuffCount(self.Me,101004014) > 0 then
				self.RAB.RoleCatchSkill:ContSkill(ClickButton,self.BurstAttack,4,4,10000002,0,0,{0},"Immediately","ClearClick",true,0,-1)
			elseif BF.GetSkillSign(self.Me,1010001) and self.RAP.ClickButton[ClickButton] == FK.Attack and BF.GetEntityAttrVal(self.Me,1201) >= 1000 then
				self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalDeriveSkill[1],3,3,0,0,0,{0},"Immediately","ClearClick",true,0,-1)	
			else
				if self.RAP.CoreRes < self.CoreCost then
					self.RAB.RoleCatchSkill:ContSkill(ClickButton,self.NormalAttack,1,1,10000002,0,0,{0},"Immediately","ClearClick",true,0,-1)
				else
					if (BF.GetSkill(self.Me) > self.NormalAttack[1] and BF.GetSkill(self.Me) < self.NormalAttack[5])
						or not BF.CheckKeyPress(FK.Attack) then
							self.RAB.RoleCatchSkill:ContSkill(ClickButton,self.NormalAttack,1,1,10000002,0,0,{0},"Immediately","ClearClick",true,0,-1)
					end
				end
			end
			--长按佩从按钮（地面）
		elseif 	self.RAP.PressButton[PressButton] == FK.Partner and self.RAP.PressButtonFrame[PressButton] >= 7 and self.RAP.partner and self.RAP.partnerType == 2 and BF.CheckPartnerShow(self.Me) then
			self.RAB.RolePartnerBase:PartnerSkill(PressButton)	--在场放技能
			--点按佩从按钮（地面）
		elseif self.RAP.ClickButton[ClickButton] == FK.Partner and self.RAP.partner then
			if (not BF.CheckPartnerShow(self.Me) and (self.RAP.partnerType == 2 or self.RAP.partnerType == 0 or self.RAP.partnerType == 1)) or self.RAP.partnerType == 3 then
				self.RAB.RolePartnerBase:PartnerSkill(ClickButton)	--不在场召出
			end
		end
	end
end

--技能释放判断
function Behavior1010:CastSkill(instanceId,skillId,skillSign,skillType)
	
	--技能派生1、2以及爆气2、3段会产生一些效果：
	if instanceId == self.Me and (skillId == 1010011 or skillId == 1010012 or skillId == 1010014 or skillId == 1010016) then
		--1、扣自己当前生命值的血
		self:ConsumeLife(self.DeriveSkillCostHP)

		--2、脉象5判断：添加百兽之王buff
		if BF.HasEntitySign(self.Me,10101005) then
			BF.AddBuff(instanceId,instanceId,101001001)
		end

		--3、固定天赋：每次释放派生攻击使自身生命降低后，会获得10%的后台日相回复效率加成（再次上场时该效果失效）
		if BF.GetBuffCount(instanceId,101001) == 0 then
			BF.AddBuff(instanceId,instanceId,101001)
		end
	end

	--爆气1段也要扣血
	if instanceId == self.Me and skillId == 1010013 then
		self:ConsumeLife(self.DeriveSkillCostHP)
	end

	--技能派生1获得1个核心能量
	if instanceId == self.Me and skillId == 1010011 then
		if BF.GetEntityAttrVal(self.Me,1201) >= 10000 then
			BF.ChangeEntityAttr(self.Me,1201,-10000,1)
			BF.ChangeEntityAttr(self.Me,1204,100,1)
		end
	end
	
	--技能派生2获得2个核心能量
	if instanceId == self.Me and skillId == 1010012 then
		if BF.GetEntityAttrVal(self.Me,1201) >= 20000 then
			BF.ChangeEntityAttr(self.Me,1201,-20000,1)
			BF.ChangeEntityAttr(self.Me,1204,200,1)
		end
	end
	
	--进战，或脱战但放了非闪避技能，就会延长核心能量图标的显示时间
	if instanceId == self.Me and (((skillSign ~= 30 and skillSign ~= 31) and not BF.CheckPlayerInFight()) or BF.CheckPlayerInFight()) then
		self.RAP.CoreUiFrame = self.RAP.RealFrame + 90
	end
	
	--释放爆气技能列表时，根据不同的虎势标记添加对应的【虎势】buff
	--if instanceId == self.Me and 
		--(skillId == 1010013 or skillId == 1010014 or skillId == 1010016) and 
		--(BF.GetBuffCount(instanceId,101004001) > 0 or BF.GetBuffCount(instanceId,101004014) > 0) then
			--if BF.GetBuffCount(instanceId,101004009) == 1 then
				--BF.AddBuff(instanceId,instanceId,101004002)
			--elseif BF.GetBuffCount(instanceId,101004010) == 1 then
				--BF.AddBuff(instanceId,instanceId,101004003)
			--elseif BF.GetBuffCount(instanceId,101004011) == 1 then
				--BF.AddBuff(instanceId,instanceId,101004004)
			--elseif BF.GetBuffCount(instanceId,101004012) == 1 then
				--BF.AddBuff(instanceId,instanceId,101004005)
			--elseif BF.GetBuffCount(instanceId,101004013) == 1 then
				--BF.AddBuff(instanceId,instanceId,101004006)
			--end
	--end


end

--属性变化判断
function Behavior1010:ChangeAttrValue(attrType,attrValue,changedValue)
	--核心能量有变化，核心UI显示就增加3秒
	if attrType == 1204 then
		self.RAP.CoreUiFrame = self.RAP.RealFrame + 90
	end
	
	--爆气状态下，检测到生命降低，会叠加【虎势】标记和【雷心】
	if attrType == 1001 and changedValue < 0 and (BF.GetBuffCount(self.Me,101004001) > 0 or BF.GetBuffCount(self.Me,101004014) > 0) then
		--虎势标记：这个是爆气状态期间可以叠加的。在放爆气连段技能时，根据标记添加实际加攻速的【虎势】
		if BF.GetBuffCount(self.Me,101004009) == 1 then
			BF.AddBuff(self.Me,self.Me,101004010)
			BF.RemoveBuff(self.Me,101004009)
		elseif BF.GetBuffCount(self.Me,101004010) == 1 then
			BF.AddBuff(self.Me,self.Me,101004011)
			BF.RemoveBuff(self.Me,101004010)
		elseif BF.GetBuffCount(self.Me,101004011) == 1 then
			BF.AddBuff(self.Me,self.Me,101004012)
			BF.RemoveBuff(self.Me,101004011)
		elseif BF.GetBuffCount(self.Me,101004012) == 1 then
			BF.AddBuff(self.Me,self.Me,101004013)
			BF.RemoveBuff(self.Me,101004012)
		end
		--雷心，包含1、2脉的效果
		if BF.HasEntitySign(self.Me,10101002) then
			if BF.HasEntitySign(self.Me,10101001) then
				BF.AddBuff(self.Me,self.Me,101004008)
				BF.AddBuff(self.Me,self.Me,101004008)
			else
				BF.AddBuff(self.Me,self.Me,101004008)
			end
		else
			if BF.HasEntitySign(self.Me,10101001) then
				BF.AddBuff(self.Me,self.Me,101004007)
				BF.AddBuff(self.Me,self.Me,101004007)
			else
				BF.AddBuff(self.Me,self.Me,101004007)
			end
		end	
	end
end

--跳跃反击着地回调
function Behavior1010:OnLand(instanceId)
	if instanceId == self.Me and self.RAP.MyState == FES.Skill
		and self.RAP.CurrentSkillType == 81 then
		BF.BreakSkill(self.Me)
		BF.CastSkillBySelfPosition(self.Me,self.JumpAttack[3])
		self.RAP.CurrentSkillPriority = 2
		--待机切换等待时间、移除锁定镜头延迟时间
		self.RAP.LeisurelyIdleChangeFrame = self.RAP.RealFrame + 150
		self.RAP.CancelLockFrame = self.RAP.RealFrame + 5
		BF.SetCameraParams(FightEnum.CameraState.ForceLocking) --重置强锁定镜头参数
	elseif instanceId == self.Me and self.RAP.CurrentSkillType == 81 then
		BF.SetCameraParams(FightEnum.CameraState.ForceLocking) --重置强锁定镜头参数
	end
end

--技能完成判断
function Behavior1010:FinishSkill(instanceId,skillId,skillSign,skillType)
	
	--爆气状态下，每次放完爆气连段技能就删掉【虎势】
	if instanceId == self.Me and
		(skillId == 1010013 or skillId == 1010014 or skillId == 1010016) and
		(BF.GetBuffCount(instanceId,101004001) > 0 or BF.GetBuffCount(instanceId,101004014) > 0) then
			BF.RemoveBuffByGroup(self.Me,101004002) --移除所有【虎势】
	end

end

--技能打断判断
function Behavior1010:BreakSkill(instanceId,skillId,skillSign,skillType)
	
	--爆气状态下，每次放完爆气连段技能就删掉【虎势】
	if instanceId == self.Me and
		(skillId == 1010013 or skillId == 1010014 or skillId == 1010016) and
		(BF.GetBuffCount(instanceId,101004001) > 0 or BF.GetBuffCount(instanceId,101004014) > 0) then
			BF.RemoveBuffByGroup(self.Me,101004002) --移除所有【虎势】
	end
	
end

--技能窗口处理
function Behavior1010:AddSkillSign(instanceId,sign)
	--1010001:技能派生（技能后半段，按普攻键触发派生1，按技能键触发派生2）
	--if instanceId == self.Me and sign == 1010001 and BF.CheckEntityHeight(self.Me) == 0 and BF.CheckEntityForeground(self.Me) then 
		----检查点击缓存
		--local ClickButton = 0
		--if self.RAP.ClickButton[1] ~= 0 and self.RAP.ClickButton[1] ~= nil then
			--ClickButton = 1
		--elseif self.RAP.ClickButton[2] ~= 0 and self.RAP.ClickButton[2] ~= nil then
			--ClickButton = 2
		--elseif self.RAP.ClickButton[3] ~= 0 and self.RAP.ClickButton[3] ~= nil then
			--ClickButton = 3
		--end
		----检查长按缓存
		--local PressButton = 0
		--if self.RAP.PressButton[1] ~= 0 and self.RAP.PressButton[1] ~= nil then
			--PressButton = 1
		--elseif self.RAP.PressButton[2] ~= 0 and self.RAP.PressButton[2] ~= nil then
			--PressButton = 2
		--elseif self.RAP.PressButton[3] ~= 0 and self.RAP.PressButton[3] ~= nil then
			--PressButton = 3
		--end
		
		--if BF.GetEntityAttrValueRatio(self.Me,1201) >= 10000 then
			--BF.SetFightUISkillBtnId(self.Me,FightEnum.KeyEvent.NormalSkill,1010012)
		--end
		
		--if self.RAP.ClickButton[ClickButton] == FK.NormalSkill and BF.GetEntityAttrValueRatio(self.Me,1201) >= 10000 then
			--self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalDeriveSkill[2],3,3,0,0,0,{0},"Immediately","ClearClick",true,0,-1)
		--elseif self.RAP.ClickButton[ClickButton] == FK.Attack and BF.GetEntityAttrValueRatio(self.Me,1201) >= 5000 then
			--self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalDeriveSkill[1],3,3,0,0,0,{0},"Immediately","ClearClick",true,0,-1)
		--end
	--end
	
	
	
	--1010002:核心技能上buff，还有其他处理
	if instanceId == self.Me and sign == 1010002 and BF.CheckEntityForeground(self.Me) then
		--self.CoreStateframe = self.RAP.RealFrame + self.CoreStateTime * 30  --核心爆气后，开始计时
		BF.ChangeDisableMask(self.Me,1005,true)   --屏蔽技能按钮
		--BF.ChangeEntityAttr(self.Me,1204,-self.CoreCost,1)	--爆气后消耗核心资源
		self.CoreState = true
		
		if BF.GetBuffCount(self.Me,101004009) == 0 then
			BF.AddBuff(self.Me,self.Me,101004009)  --虎势标记：+30%攻速
		end
		
		if BF.HasEntitySign(self.Me,10101003) then
			if BF.GetBuffCount(self.Me,101004014) == 0 then
				BF.AddBuff(self.Me,self.Me,101004014)  --3脉的带霸体的爆气标记
			end
		else
			if BF.GetBuffCount(self.Me,101004001) == 0 then
				BF.AddBuff(self.Me,self.Me,101004001)  --正常的爆气标记
			end
		end
	end
	
	--1010003:爆气连段2会瞬移到目标后面
	
	if instanceId == self.Me and sign == 1010003 and self.RAP.LockTarget ~= 0 then
		local distance = BF.GetCollideRadius(self.Me) + BF.GetCollideRadius(self.RAP.LockTarget)
		local angle = 180	
		local pos = BF.GetPositionOffsetBySelf(self.RAP.LockTarget,distance,angle)
		local height = BF.CheckPosHeight(pos)
		if height <= 1 then
			pos.y = pos.y - height
		else
			pos = self:GetRandomPos(distance)
			--如果实在找不到这个合法的点位，在原地释放
			if not pos then
				pos = BF.GetPositionP(self.Me)
			end
		end
		BF.DoSetPositionP(self.Me,pos)
		BF.DoLookAtTargetImmediately(self.Me,self.RAP.LockTarget,"HitCase")
	end
	
	--1010004:爆气连段1会瞬移到目标前面
	--if instanceId == self.Me and sign == 1010004 and self.RAP.LockTarget ~= 0 then
		--local distance = 0.5
		--local angle = 0
		--local pos = BF.GetPositionOffsetBySelf(self.RAP.LockTarget,distance,angle)
		--local height = BF.CheckPosHeight(pos)
		--if height <= 1 then
			--pos.y = pos.y - height
		--else
			--pos = self:GetRandomPos(distance)
			----如果实在找不到这个合法的点位，在原地释放
			--if not pos then
				--pos = BF.GetPositionP(self.Me)
			--end
		--end
		--BF.DoLookAtTargetImmediately(self.Me,self.RAP.LockTarget,"HitCase")
		--BF.DoSetPositionP(self.Me,pos)
	--end
	
	--1010005:爆气连段会瞬移到目标前面
	if instanceId == self.Me and sign == 1010005 then
		if self.RAP.LockTarget ~= 0 then
			local distance = BF.GetCollideRadius(self.Me) + BF.GetCollideRadius(self.RAP.LockTarget)
			local angle = 0
			local pos = BF.GetPositionOffsetBySelf(self.RAP.LockTarget,distance,angle)
			local height = BF.CheckPosHeight(pos)
			if height <= 1 then
				pos.y = pos.y - height
			else
				pos = self:GetRandomPos(distance)
				--如果实在找不到这个合法的点位，在原地释放
				if not pos then
					pos = BF.GetPositionP(self.Me)
				end
			end
			BF.DoSetPositionP(self.Me,pos)
			BF.DoLookAtTargetImmediately(self.Me,self.RAP.LockTarget,"HitCase")
		end
	end
	
	--1010006:4脉核心爆气额外伤害
	if instanceId == self.Me and sign == 1010006 and BF.HasEntitySign(self.Me,10101004) then
		local x,y,z = BF.GetPosition(instanceId)
		BF.CreateEntity(1010040001,instanceId,x,y,z)
	end
	
	--1010007:6脉派生额外范围伤害
	if instanceId == self.Me and sign == 1010007 and BF.HasEntitySign(self.Me,10101006) then
		local x,y,z = BF.GetPosition(instanceId)
		BF.CreateEntity(1010040002,instanceId,x,y,z)
	end
	
	--1010008:爆气连段加攻速，根据身上标记播放对应攻速下的音效
	if instanceId == self.Me and sign == 1010008 and (BF.GetBuffCount(instanceId,101004001) > 0 or BF.GetBuffCount(instanceId,101004014) > 0) then
		if BF.GetBuffCount(instanceId,101004009) == 1 then
			BF.AddBuff(instanceId,instanceId,101004002)
		elseif BF.GetBuffCount(instanceId,101004010) == 1 then
			BF.AddBuff(instanceId,instanceId,101004003)
		elseif BF.GetBuffCount(instanceId,101004011) == 1 then
			BF.AddBuff(instanceId,instanceId,101004004)
		elseif BF.GetBuffCount(instanceId,101004012) == 1 then
			BF.AddBuff(instanceId,instanceId,101004005)
		elseif BF.GetBuffCount(instanceId,101004013) == 1 then
			BF.AddBuff(instanceId,instanceId,101004006)
		end
		
		--播放爆气连段音效		
		if BF.GetBuffCount(instanceId,101004009) == 1 and BF.GetSkill(instanceId) == 1010013 then
			BF.DoEntityAudioPlay(instanceId,"ZhaiwugeR31M11_Atk013_40",true)
		elseif BF.GetBuffCount(instanceId,101004010) == 1 then
			if BF.GetSkill(instanceId) == 1010013 then
				BF.DoEntityAudioPlay(instanceId,"ZhaiwugeR31M11_Atk013_40",true)
			elseif BF.GetSkill(instanceId) == 1010014 then
				BF.DoEntityAudioPlay(instanceId,"ZhaiwugeR31M11_Atk014_40",true)
			elseif BF.GetSkill(instanceId) == 1010016 then
				BF.DoEntityAudioPlay(instanceId,"ZhaiwugeR31M11_Atk016_40",true)
			end
		elseif BF.GetBuffCount(instanceId,101004011) == 1 then
			if BF.GetSkill(instanceId) == 1010013 then
				BF.DoEntityAudioPlay(instanceId,"ZhaiwugeR31M11_Atk013_50",true)
			elseif BF.GetSkill(instanceId) == 1010014 then
				BF.DoEntityAudioPlay(instanceId,"ZhaiwugeR31M11_Atk014_50",true)
			elseif BF.GetSkill(instanceId) == 1010016 then
				BF.DoEntityAudioPlay(instanceId,"ZhaiwugeR31M11_Atk016_50",true)
			end
		elseif BF.GetBuffCount(instanceId,101004012) == 1 then
			if BF.GetSkill(instanceId) == 1010013 then
				BF.DoEntityAudioPlay(instanceId,"ZhaiwugeR31M11_Atk013_60",true)
			elseif BF.GetSkill(instanceId) == 1010014 then
				BF.DoEntityAudioPlay(instanceId,"ZhaiwugeR31M11_Atk014_60",true)
			elseif BF.GetSkill(instanceId) == 1010016 then
				BF.DoEntityAudioPlay(instanceId,"ZhaiwugeR31M11_Atk016_60",true)
			end
		elseif BF.GetBuffCount(instanceId,101004013) == 1 then
			if BF.GetSkill(instanceId) == 1010013 then
				BF.DoEntityAudioPlay(instanceId,"ZhaiwugeR31M11_Atk013_70",true)
			elseif BF.GetSkill(instanceId) == 1010014 then
				BF.DoEntityAudioPlay(instanceId,"ZhaiwugeR31M11_Atk014_70",true)
			elseif BF.GetSkill(instanceId) == 1010016 then
				BF.DoEntityAudioPlay(instanceId,"ZhaiwugeR31M11_Atk016_70",true)
			end
		end
	end
end

--放派生烧自己血，当前血量百分比，但不会烧死
function Behavior1010:ConsumeLife(ratio)
	local CurrentLife = BF.GetEntityAttrVal(self.Me,1001)
	local ReduceHP = CurrentLife * ratio
	if CurrentLife - ReduceHP > 0 then
		BF.ChangeEntityAttr(self.Me,1001,-ReduceHP)
	end
end

--上场判断
function Behavior1010:ChangeForeground(instanceId)
	if BF.GetBuffCount(instanceId,101001) > 0 then
		BF.RemoveBuffByGroup(instanceId,101001)
	end
end

--获取随机坐标
function Behavior1010:GetRandomPos(radius)
	for i = 60,360,60 do
		local positionP = BF.GetPositionOffsetBySelf(self.Me,radius,i)
		positionP.y = positionP.y + 0.2
		--检测障碍：
		if BF.CheckEntityCollideAtPosition(BF.GetEntityTemplateId(self.Me), positionP.x, positionP.y, positionP.z, {self.Me},self.Me,true) then
			local y,layer = BF.CheckPosHeight(positionP)
			--检测到触地坐标以后返回
			if y and y == 0 then
				return positionP
				--设置坐标：
			end
		end
	end
	return nil
end

--死亡判断
function Behavior1010:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId == self.Me and (BF.GetBuffCount(dieInstanceId,101004001) > 0 or BF.GetBuffCount(dieInstanceId,101004014) > 0) then
		if self.RAP.CoreRes > 0 then
			BF.ChangeEntityAttr(dieInstanceId,1204,-self.RAP.CoreRes,1)
		end
	end
end