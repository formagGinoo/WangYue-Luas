Behavior1003 = BaseClass("Behavior1003",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType

function Behavior1003.GetGenerates()
	local generates = {}
	return generates
end
function Behavior1003.GetMagics()
	local generates = {}
	return generates
end

function Behavior1003:Init()
	--变量声明
	self.Me = self.instanceId		--记录自己
	
	--普攻连段Id
	self.NormalAttack = {1003001,1003002,1003003,1003004,1003005,1003006}

	self.NormalSkill = {1003010,1003020}	--主动技能Id
	self.MoveSkill = {1003030,1003031}	--闪避技能Id

	self.CoreSkill = {1003040}	--核心技能Id
	
	self.DodgeCounter = {1003050}	--闪避反击技能Id
	self.QTESkill = {1003060}	--QTE技能Id
	self.UltimateSkill = {1003070}	--大招技能Id

	self.QTEtype = 1			--QTE类型：1切换角色放技能，2不切换角色下场放技能，3AI援助
	self.QTEPosRef = 1			--QTE出场坐标参考：1参考在场角色，2参考其他目标
	self.QTEChangeCD = 1		--QTE/切换角色冷却时间
	
	self.LockDistance = 7
	
	--通用参数组合初始化、角色组合合集
	self.RoleAllParm = BehaviorFunctions.CreateBehavior("RoleAllParm",self)
	self.RoleAllBehavior = BehaviorFunctions.CreateBehavior("RoleAllBehavior",self)

	--组合缩写
	self.RAB = self.RoleAllBehavior
	self.RAP = self.RoleAllParm
	
	--角色自身参数
	self.CoreResRatio = 0		--核心资源填充率
	self.CoreResReduceFrame = 0	--核心资源减少间隔
	self.ScreenEffectDelayFrame = 0 --全屏特效播放延迟
	self.QuganCd = 0
	self.MoveFrame = 0
	
	self.QTEKey = 0
	self.QTEFrame = 0
	
	--self.FollowShiftSkill = {}
	----距离、按钮、技能优先级、技能Id、(打断优先、技能窗口)、（实体标记条件、Buff类型条件)，是否消耗资源，消耗资源技能
	--self.FollowShiftSkill[1] = {5,FK.BlueSkill,2,1003020,2,0,0,0,true,1003020}
	
	
	----AI相关参数
	--self.FightActiveDistance = 3	--战斗激活距离
	--self.FightCancelDistance = 5	--战斗取消距离
	
	----AI意图集
	--self.MainPurpose = {}
	--self.MainPurpose[1] = {
				--function()return self.RAB.RoleAiBase:ClickButtonGroup(
					--{{FK.Attack,1,"Click"},{10000,10000,10000}},
					--{{FK.NormalSkill,2,"Click"},{400,400,400}},
					--{{FK.BlueSkill,2,"Click"},{400,400,400}}
				--)end,0,
				----链接序号、类型、条件、概率
				--{ {6,"Attr",{1005,nil,10000},{10000,10000,10000}},
				--{4,"BuffKind",{10030000,nil,nil},{10000,10000,10000}} } }
	
	--self.MainPurpose[2] = {function()return self.RAB.RoleAiBase:ResCondition({1204,nil,10000},{10000,10000,10000})end,0,nil}
	--self.MainPurpose[3] = {function()return self.RAB.RoleAiBase:PressButton(FK.Attack,9,true)end,0,nil}
	--self.MainPurpose[4] = {function()return self.RAB.RoleAiBase:HasCondition({10030000,nil,nil},{10000,10000,10000})end,0,nil}
	
	--self.MainPurpose[5] = {
				--function()return self.RAB.RoleAiBase:ClickButtonGroup(
					--{{FK.Attack,2,"Click"},{10000,10000,10000}},
					--{{FK.NormalSkill,2,"Click"},{400,400,400}},
					--{{FK.BlueSkill,2,"Click"},{400,400,400}}
				--)end,0,nil}
	
	--self.MainPurpose[6] = {function()return self.RAB.RoleAiBase:ResCondition({1005,nil,10000},{10000,1500,10000})end,0,nil}
	--self.MainPurpose[7] = {function()return self.RAB.RoleAiBase:ClickButton(FK.UltimateSkill,{10000,10000,10000})end,0,nil}
	
end

function Behavior1003:Update()

	if BF.CheckEntity(self.Me) then
		
		--通用参数组合更新
		self.RAP:Update()

		--角色目标选择判断
		self.RAB.RoleSelectTarget:Update(self.LockDistance)

		--通用Ai
		--self.RAB.RoleAiBase:Update(self.MainPurpose)

		--角色锁定目标判断
		self.RAB.RoleLockTarget:Update()

		--按键缓存组合
		self.RAB.RoleClickButtonCache:Update()

		--核心状态额外判断
		if BF.CheckEntityForeground(self.Me) then
			--核心状态下杂项判断
			if BF.HasEntitySign(self.Me,10030000) then
				--核心资源耗尽退出核心状态
				if self.CoreResRatio == 0 and (BF.CanCastSkill(self.Me) or (self.RAP.MyState == FightEnum.EntityState.Skill
							and not BF.GetSkillSign(self.Me,10030040))) then
					BF.RemoveEntitySign(self.Me,10030000)
				end
			end
			--普攻形式判断
			if BF.HasEntitySign(self.Me,10030000) then
				self.NormalAttack = {1003042,1003043,1003044}
			elseif not BF.HasEntitySign(self.Me,10030000) then
				--self.NormalAttack = {1003900}
				self.NormalAttack = {1003001,1003002,1003003,1003004,1003005,1003006}
				--self.NormalAttack = {1003001,1003001,1003001,1003001,1003001,1003001}
			end
		end
		
		--角色释放技能组合，可复制最多3次，同帧内执行3种按键操作
		self:RoleCatchSkill()
		--self:RoleCatchSkill()
		
		--角色杂项判断（角色独立）
		self:Core()
		
		--目标参数开放
		BF.SetEntityValue(self.Me,"LockTarget",self.RAP.LockTarget)
		BF.SetEntityValue(self.Me,"AttackTarget",self.RAP.AttackTarget)
		BF.SetEntityValue(self.Me,"LockTargetPart",self.RAP.LockTargetPart)
		BF.SetEntityValue(self.Me,"AttackTargetPart",self.RAP.AttackTargetPart)
		BF.SetEntityValue(self.Me,"CancelLockFrame",self.RAP.CancelLockFrame)
		BF.SetEntityValue(self.Me,"QTEPosRef",self.QTEPosRef)
		BF.SetEntityValue(self.Me,"QTEtype",self.QTEtype)
		BF.SetEntityValue(self.Me,"QTESkill",self.QTESkill[1])
		BF.SetEntityValue(self.Me,"QTEChangeCD",self.QTEChangeCD)
		BF.SetEntityValue(self.Me,"NormalAttack[1]",self.NormalAttack[1])
	end
end

--角色杂项判断（角色独立）
function Behavior1003:Core()
	
	if not BF.CheckEntityForeground(self.Me) and self.QTEKey == 3 then
		BF.ChangeBtnSkillCDTime(self.Me,FK.NormalSkill,-0.033)
	end
	if self.QTEKey == 2 then
		self.QTEKey = 3
		BF.ChangeBtnSkillCDTime(self.Me,FK.NormalSkill,-99)
	end
	if self.QTEKey == 1 then
		self.QTEKey = 2
		--BF.ChangeBtnSkillCDTime(self.Me,FK.NormalSkill,-99)
	end
	if self.QTEKey == 0 then
		--BF.ChangeEntityAttr(self.Me,1211,450,1)
		self.QTEKey = 1
		BF.ChangeBtnSkillCDTime(self.Me,FK.NormalSkill,-99)
	end

	----临时恢复QTE条
	--BF.ChangeEntityAttr(self.Me,1211,1,1)
	--self.QTEFrame = BF.GetEntityAttrVal(self.Me,1211)

	--QTE条动效显示判断
	if self.RAP.CtrlRole == self.Me and self.QTEFrame == 450 then
		BF.SetPlayerCoreEffectVisible("20051", true)
	else
		BF.SetPlayerCoreEffectVisible("20051", false)
	end
	
	--核心按钮点击提示判断
	if self.RAP.CtrlRole == self.Me and self.CoreResRatio == 10000 then
		BF.PlayFightUIEffect("20016","R")
	else
		BF.StopFightUIEffect("20016","R")
	end
	
	--记录核心资源比率
	self.CoreResRatio = BF.GetEntityAttrValueRatio(self.Me,1204)
	
	--角色在场逻辑
	if self.RAP.CtrlRole == self.Me then
		
		--普攻形式判断
		if BF.HasEntitySign(self.Me,10030000) then
			self.NormalAttack = {1003042,1003043,1003044}
		elseif not BF.HasEntitySign(self.Me,10030000) then
			--self.NormalAttack = {1003900}
			self.NormalAttack = {1003001,1003002,1003003,1003004,1003005,1003006}
			--self.NormalAttack = {1003001,1003001,1003001,1003001,1003001,1003001}
		end
		
		--自身为当前操控角色时
		if self.Me == self.RAP.CtrlRole then
			----提示长按普攻动效显示判断
			--if self.CoreResRatio == 10000 and not BF.HasEntitySign(self.Me,10030000) then
				--BF.SetFightMainNodeVisible(1,"JEffect20015",true,1)
			--else
				--BF.SetFightMainNodeVisible(1,"JEffect20015",false,1)
			--end
			----提示连点普攻动效显示判断
			--if BF.HasEntitySign(self.Me,10030000) then
				--BF.SetFightMainNodeVisible(1,"JEffect20014",true,1)
			--else
				--BF.SetFightMainNodeVisible(1,"JEffect20014",false,1)
			--end
			----提示连点主动按钮动效显示判断
			--if BF.GetSkillSign(self.Me,10000005) and BF.CheckBtnUseSkill(self.Me,FK.NormalSkill) then
				--BF.SetFightMainNodeVisible(1,"IEffect20014",true,1)
			--else
				--BF.SetFightMainNodeVisible(1,"IEffect20014",false,1)
			--end
			----角色资源条--就绪动效显示判断
			--if self.CoreResRatio == 10000 and not BF.HasEntitySign(self.Me,10030000) then
				--BF.SetPlayerCoreEffectVisible("20051", true)
				----BF.SetPlayerCoreEffectVisible("20056", true)
			--else
				--BF.SetPlayerCoreEffectVisible("20051", false)
				----BF.SetPlayerCoreEffectVisible("20056", false)
			--end
			----角色资源条--状态动效显示判断
			--if BF.HasEntitySign(self.Me,10030000) then
				--BF.SetPlayerCoreEffectVisible("20027", true)
				--BF.SetPlayerCoreEffectVisible("20028", true)
			--else
				--BF.SetPlayerCoreEffectVisible("20027", false)
				--BF.SetPlayerCoreEffectVisible("20028", false)
			--end
			----全屏特效显示判断
			--if BF.HasEntitySign(self.Me,10030000) and not BF.HasBuffKind(self.Me,1003049) and not BF.HasBuffKind(self.Me,1003) 
				--and not BF.HasBuffKind(self.Me,1003090) and self.ScreenEffectDelayFrame < self.RAP.RealFrame then
				--BF.AddBuff(self.Me,self.Me,1003049,1)
			--elseif BF.HasBuffKind(self.Me,1003049) and (not BF.HasEntitySign(self.Me,10030000) or BF.HasBuffKind(self.Me,1003)) then
				--BF.RemoveBuff(self.Me,1003049,5)
			--end
		end
			
		----核心技能释放判断，可释放技能或处于技能状态且技能优先级低，且长按时间、资源足够，且不存在核心被动实体标记
		--if (BF.CanCastSkill(self.Me) or (BF.CheckEntityState(self.Me,FightEnum.EntityState.Skill) and self.RAP.CurrentSkillPriority < 2 ))
			--and self.RAP.PressButton[1] == FK.Attack and self.RAP.PressButtonFrame[1] >= 9 and self.CoreResRatio == 10000 
			--and not BF.HasEntitySign(self.Me,10030000) then

			--if BF.CheckEntityState(self.Me,FightEnum.EntityState.Skill) then
				--BF.BreakSkill(self.Me)
			--end
			--self.RAB.RoleCatchSkill:CatchSkillPart(self.CoreSkill[1],"Immediately")
			--self.RAP.CurrentSkillPriority = 2
			--BF.AddEntitySign(self.Me,10030000,-1) --核心状态标记
			--self.ScreenEffectDelayFrame = self.RAP.RealFrame + 5
		--end
		----核心状态下杂项判断
		--if BF.HasEntitySign(self.Me,10030000) then
			----核心资源间隔减少，缔约资源增加
			--if self.CoreResRatio > 0 and self.CoreResReduceFrame < self.RAP.RealFrame and (BF.CanCastSkill(self.Me)
					--or (self.RAP.MyState == FightEnum.EntityState.Skill and (self.RAP.CurrentSkill == 1003042 or self.RAP.CurrentSkill == 1003043
						--or self.RAP.CurrentSkill == 1003044))) then
				--BF.DoMagic(self.Me,self.Me,1003047,1) --核心资源减少
				----BF.DoMagic(self.Me,self.Me,1003047,1) --核心资源减少
				----转换缔约值判断
				--if not BF.HasEntitySign(1,10000009) then
					--BF.DoMagic(self.Me,self.Me,1003082,1) --缔约资源增加
				--end
				--self.CoreResReduceFrame = self.RAP.RealFrame
			--end
			----核心资源耗尽退出核心状态
			--if self.CoreResRatio == 0 and (BF.CanCastSkill(self.Me) or (self.RAP.MyState == FightEnum.EntityState.Skill 
					--and not BF.GetSkillSign(self.Me,10030040))) then
				--BF.RemoveEntitySign(self.Me,10030000)
			--end
		--end
	end
end

--技能释放判断
function Behavior1003:CastSkill(instanceId,skillId,skillSign,skillType)
	
	--QTE释放判断
	if instanceId == self.Me and skillId == 1003060 then
		self.CurrentSkillPriority = 2
		BF.ChangeEntityAttr(self.Me,1204,180,1)	--总180
		BF.ChangeEntityAttr(self.Me,1005,2,1)	--总25
	end
end

--技能打断判断
function Behavior1003:BreakSkill(instanceId,skillId,skillSign,skillType)
	
	--QTE打断判断，移除免疫受击buff
	if instanceId == self.Me and skillId == 1003060 then
		if BF.HasBuffKind(self.Me,1003062) then
			BF.RemoveBuff(self.Me,1003062,5)
		end
	end
	--闪避反击打断判断，移除免疫受击buff
	if instanceId == self.Me and skillId == 1003050 then
		if BF.HasBuffKind(self.Me,1003052) then
			BF.RemoveBuff(self.Me,1003052,5)
		end
	end
	--蓝色技能打断判断，移除免疫受击buff
	if instanceId == self.Me and skillId == 1003020 then
		if BF.HasBuffKind(self.Me,1003024) then
			BF.RemoveBuff(self.Me,1003024,5)
		end
	end
end

--重写角色释放技能组合
function Behavior1003:RoleCatchSkill()
	--检查按键缓存
	local ClickButton = 0
	if self.RAP.ClickButton[1] ~= 0 and self.RAP.ClickButton[1] ~= nil then
		ClickButton = 1
	elseif self.RAP.ClickButton[2] ~= 0 and self.RAP.ClickButton[1] ~= nil then
		ClickButton = 2
	elseif self.RAP.ClickButton[3] ~= 0 and self.RAP.ClickButton[1] ~= nil then
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
		--大招释放判断
		if self.RAP.ClickButton[ClickButton] == FK.UltimateSkill and BF.CheckEntityHeight(self.Me) == 0 then
			if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.UltimateSkill[1],5,3,0,0,0,{0},"Immediately","ClearClick") then
				BF.CastSkillCost(self.Me,self.UltimateSkill[1])
			end
		--闪避释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.Dodge and BF.CheckEntityHeight(self.Me) == 0 then
			if self.RAB.RoleCatchSkill:MoveSkill(ClickButton,3,3,0,0,0,{0},"ClearClick") then
				BF.CastSkillCost(self.Me,self.MoveSkill[1],"ClearClick")
			end
		--核心技能释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.Partner and BF.CheckEntityHeight(self.Me) == 0
			and BF.GetEntityAttrValueRatio(self.Me,1204) == 10000 then
			if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.CoreSkill[1],2,2,0,0,0,{0},"Immediately","ClearClick") then
				BF.CastSkillCost(self.Me,self.CoreSkill[1])
			end
		--普通技能释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.NormalSkill and BF.CheckEntityHeight(self.Me) == 0 then
			if self.RAB.RoleCatchSkill:ContSkill(ClickButton,self.NormalSkill,2,2,10000001,0,0,{0},"Immediately","ClearClick") then
				BF.CastSkillCost(self.Me,self.NormalSkill[1])
			end
		--普攻点按释放判断(地面)
		elseif self.RAP.ClickButton[ClickButton] == FK.Attack and BF.CheckEntityHeight(self.Me) == 0
			and ((not BF.GetSkillSign(self.Me,10000002) and not BF.CheckKeyPress(FK.Attack)) or BF.GetSkillSign(self.Me,10000002)) then
			self.RAB.RoleCatchSkill:ContSkill(ClickButton,self.NormalAttack,1,1,10000002,0,0,{0},"Immediately","ClearClick")
		end
	end
end

--首次命中判断
function Behavior1003:FirstCollide(attackInstanceId,hitInstanceId,InstanceIdId)
	local I = BF.GetEntityTemplateId(InstanceIdId)
	if attackInstanceId == self.Me then
		--普攻子弹
		if I == 1003001001 then
			BF.ChangeBtnSkillCDTime(self.Me,FK.NormalSkill,-0.8)
			BF.ChangeEntityAttr(self.Me,1005,1,1)	--总1
		end
		if I == 1003002001 or I == 1003002002 then
			BF.ChangeBtnSkillCDTime(self.Me,FK.NormalSkill,-0.6)
			BF.ChangeEntityAttr(self.Me,1005,1,1)	--总1
		end
		if I == 1003003001 or I == 1003003002 or I == 1003003003 then
			BF.ChangeBtnSkillCDTime(self.Me,FK.NormalSkill,-0.6)
			BF.ChangeEntityAttr(self.Me,1005,1,1)	--总2
		end
		if I == 1003004001 then
			BF.ChangeBtnSkillCDTime(self.Me,FK.NormalSkill,-1.5)
			BF.ChangeEntityAttr(self.Me,1005,1,1)	--总3
		end
		if I == 1003005001 or I == 1003005002 or I == 1003005003 then
			BF.ChangeBtnSkillCDTime(self.Me,FK.NormalSkill,-0.6)
			BF.ChangeEntityAttr(self.Me,1005,3,1)	--总3
		end
		if I == 1003006001 then
			BF.ChangeBtnSkillCDTime(self.Me,FK.NormalSkill,-1)
			BF.ChangeEntityAttr(self.Me,1005,3,1)	--总3
		end
		--普通技能子弹
		if I == 1003010001 or I == 1003010002 then
			BF.ChangeEntityAttr(self.Me,1204,20,1)	--总40
			BF.ChangeEntityAttr(self.Me,1005,2,1)	--总4
		end
		if I == 1003020001 or I == 1003020002 then
			BF.ChangeEntityAttr(self.Me,1204,12,1)	--总60
			BF.ChangeEntityAttr(self.Me,1005,2,1)	--总8
		end
		----核心技能子弹
		--if I == 1001041001 or I == 1001041002 then
			--BF.ChangeEntityAttr(self.Me,1005,2,1)	--总4
		--end
		--if I == 1001042001 or I == 1001042002 then
			--BF.ChangeEntityAttr(self.Me,1005,2,1)	--总4
		--end
		--if I == 1001043001 or I == 1001043002 or I == 1001043003 then
			--BF.ChangeEntityAttr(self.Me,1005,2,1)	--总6
		--end
	end
end

--触发元素状态判断
function Behavior1003:EnterElementState(atkInstanceId,instanceId,element)
	if atkInstanceId == self.Me and BF.CheckEntity(instanceId) and element == FEET.Wood then
		--and self.QTEFrame == 450 then
		BF.ChangeEntityAttr(self.Me,1211,-450,1)
		BF.SetEntityElementStateDurationTime(instanceId,element,20) --设置元素状态持续时间

		--临时QTE激活判断
		BF.CreateEntity(1000000011,self.Me,self.RAP.MyPos.x,self.RAP.MyPos.y,self.RAP.MyPos.z) --释放一般闪避特效
		BF.AddEntitySign(1,10000002,-1) --给场景怪加QTE激活标记
	end
end
