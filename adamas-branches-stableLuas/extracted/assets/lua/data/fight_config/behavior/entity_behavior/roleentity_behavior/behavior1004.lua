Behavior1004 = BaseClass("Behavior1004",EntityBehaviorBase)
	
local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent

function Behavior1004.GetGenerates()
	local generates = {1004040001,1004040002,1004040003,1004040004,1004040005,1004040006,1004040007,100404002,1004020001,1000000000,1000000001}
	return generates
end
function Behavior1004.GetMagics()
	local generates = {1004102,1004075,361020100}
	return generates
end

function Behavior1004:Init()
	--变量声明
	self.Me = self.instanceId		--记录自己
	
	--普攻连段Id
	self.NormalAttack = {1004001,1004002,1004003,1004004,1004005,1004006}	

	self.SpecialSkill = {1004010,1004050} 		--红色技能Id
	self.BlueSkill = {1004020}				--蓝色技能Id
	self.MoveSkill = {1004030,1004031}		--闪避技能Id
	
	self.CoreSkill = {1004040,1004041}		--核心技能Id

	self.DodgeCounter = {1004050}	--闪避反击技能Id
	self.QTESkill = {1004060}		--QTE技能Id
	self.UltimateSkill = {1004070}	--大招技能Id
	--self.CoreSkill = {1004080}		--缔约技能Id
	
	self.QTEtype = 1			--QTE类型：1切换角色放技能，2不切换角色下场放技能，3AI援助
	self.QTEPosRef = 1			--QTE出场坐标参考：1参考在场角色，2参考其他目标
	self.QTEChangeCD = 1		--QTE/切换角色冷却时间
	
	self.LockDistance = 10

	--通用参数组合初始化、角色组合合集
	self.RoleAllParm = BehaviorFunctions.CreateBehavior("RoleAllParm",self)
	self.RoleAllBehavior = BehaviorFunctions.CreateBehavior("RoleAllBehavior",self)
	
	--组合缩写
	self.RAB = self.RoleAllBehavior
	self.RAP = self.RoleAllParm
	self.RAIB = self.RoleAllBehavior.RoleAiBase
	
	--角色自身参数
	self.BlueSkillCharge = 0		--蓝色技能充能次数
	self.BlueSkillHitFrame = 0		--蓝色技能额外伤害间隔
	self.CoreAttackFrame = 0   		--核心攻击间隔帧数
	self.CoreSkillCancelFrame = 0	--核心攻击取消延迟帧数
	self.CoreResRatio = 0			--核心资源填充率
	--self.RedSkillResNum = 0			--红色技能获得核心和能量资源次数
	self.RedSkillType = 0			--红色技能释放类型，1为命中增加资源，2为命中不增加资源
	self.AttackPauseFrame = 0		--普攻禁用时间
	self.UltimateStateResNum = 0	--大招状态红色技能获得核心资源次数
	
	----AI相关参数
	--self.FightActiveDistance = 3.5	--战斗激活距离
	--self.FightCancelDistance = 5.5	--战斗取消距离
	
	----AI意图集
	--self.MainPurpose = {} 
	--self.MainPurpose[1] = {
				--function()return self.RAB.RoleAiBase:ClickButtonGroup(
					--{{FK.Attack,1,"Click"},{10000,10000,10000}},
					--{{FK.NormalSkill,2,"Click"},{200,200,200}},
					--{{FK.BlueSkill,2,"Click"},{200,200,200}}
				--)end,0,
				--{{9,"BuffKind",{1004073,0,0},{10000,10000,10000}},
				--{7,"Attr",{1005,nil,10000},{10000,10000,10000}},
				--{4,"EntitySign",{10040000,0,0},{10000,10000,10000}}}}
	
	--self.MainPurpose[2] = {function()return self.RAB.RoleAiBase:ResCondition({1204,nil,10000},{10000,10000,10000})end,0,nil}
	--self.MainPurpose[3] = {function()return self.RAB.RoleAiBase:PressButton(FK.Attack,9,false)end,0,nil}
	--self.MainPurpose[4] = {function()return self.RAB.RoleAiBase:HasCondition({10040000,nil,nil},{10000,10000,10000})end,0,nil}
	--self.MainPurpose[5] = {function()return self.RAB.RoleAiBase:ResCondition({1204,0,nil},{10000,10000,10000})end,0,nil}
	--self.MainPurpose[6] = {function()return self.RAB.RoleAiBase:PressButton(FK.Attack,9,false)end,0,nil}

	--self.MainPurpose[7] = {function()return self.RAB.RoleAiBase:ResCondition({1005,nil,10000},{10000,10000,10000})end,0,nil}
	--self.MainPurpose[8] = {function()return self.RAB.RoleAiBase:ClickButton(FK.UltimateSkill,{10000,10000,10000})end,0,nil}
	
	----大招状态下且不在核心残影攻击状态，核心资源较少则释放红色技能
	--self.MainPurpose[9] = {function()return self.RAB.RoleAiBase:HasCondition({nil,1004073,nil},{10000,10000,10000})end,0,nil}
	--self.MainPurpose[10] = {function()return self.RAB.RoleAiBase:HasCondition({-10040000,nil,nil},{10000,10000,10000})end,0,nil}
	--self.MainPurpose[11] = {function()return self.RAB.RoleAiBase:ResCondition({1005,nil,-1500},{10000,10000,10000})end,0,nil}
	--self.MainPurpose[12] = {function()return self.RAB.RoleAiBase:ClickButton(FK.NormalSkill,{10000,10000,10000})end,0,nil}
	
end

function Behavior1004:LateInit()
	self.RAP:LateInit()
end

function Behavior1004:Update()


	if BF.CheckEntity(self.Me) then
		
		----临时装备效果施加
		--if not BF.HasBuffKind(self.Me,361020100) then
			--BF.DoMagic(self.Me,self.Me,361020100,1)
		--end
		
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
		
		--角色释放技能组合，可复制最多3次，同帧内执行3种按键操作
		self:RoleCatchSkill()
		self:RoleCatchSkill()
		
		--角色杂项判断（角色独立）
		self:Core()
		
		--目标参数开放
		BF.SetEntityValue(self.Me,"LockTarget",self.RAP.LockTarget)
		BF.SetEntityValue(self.Me,"AttackTarget",self.RAP.AttackTarget)
		BF.SetEntityValue(self.Me,"LockTargetPart",self.RAP.LockTargetPart)
		BF.SetEntityValue(self.Me,"AttackTargetPart",self.RAP.AttackTargetPart)
		BF.SetEntityValue(self.Me,"QTEtype",self.QTEtype)
	end
end

--角色杂项判断（角色独立）
function Behavior1004:Core()

	----蓝色技能充能特效判断
	--self.BlueSkillCharge = BF.GetEntityAttrVal(self.Me,1211)
	--if self.BlueSkillCharge == 0 then
		--if BF.HasBuffKind(self.Me,1004103) then
			--BF.RemoveBuff(self.Me,1004103,5)
		--end
		--if BF.HasBuffKind(self.Me,1004104) then
			--BF.RemoveBuff(self.Me,1004104,5)
		--end
	--end
	
	--随机选择1段主动技能
	--self.NormalSkill[1] = BF.RandomSelect(1004010,1004011,1004012)
	
	----获取红色技能按钮技能Id
	--local r = BF.GetFightUISkillBtnId(self.Me,FK.NormalSkill)
	----红色技能大招状态设置 / 红色技能非大招状态设置
	--if self.RedSkillType ~= 2 and BF.HasBuffKind(self.Me,1004073) and self.UltimateStateResNum > 0 then
		--弃用
		--self.RedSkillType = 2	--红色技能命中不增加资源
	--elseif self.RedSkillType ~= 1 and (not BF.HasBuffKind(self.Me,1004073) or (BF.HasBuffKind(self.Me,1004073) 
			--and self.UltimateStateResNum == 0)) then
		--弃用
		--self.RedSkillType = 1	--红色技能命中增加资源
	--end

	----临时弱点清除检查
	--if BF.HasEntitySign(self.Me,10049998) then
		--BF.ChangeEntityAttr(self.Me,1204,100,1)
		--BF.ChangeEntityAttr(self.Me,1005,25,1)
		--BF.RemoveEntitySign(self.Me,10049998)
	--end
	
	--检查核心资源率
	self.CoreResRatio = BF.GetEntityAttrValueRatio(self.Me,1204)
	if BF.CheckEntityForeground(self.Me) then
		
		--角色被操控
		if self.Me == self.RAP.CtrlRole then
			--提示长按普攻按钮动效显示判断
			if self.CoreResRatio >= 5000 and not BF.HasEntitySign(self.Me,10040000) then
				BF.SetFightMainNodeVisible(1,"JEffect20015",true,1)
			else
				BF.SetFightMainNodeVisible(1,"JEffect20015",false,1)
			end
			--提示连点主动按钮动效显示判断
			if BF.GetSkillSign(self.Me,10000005) and not BF.HasBuffKind(self.Me,1004073) and BF.CheckBtnUseSkill(self.Me,FK.RedSkill) then
				BF.SetFightMainNodeVisible(1,"IEffect20014",true,1)
			else
				BF.SetFightMainNodeVisible(1,"IEffect20014",false,1)
			end
			--提示点击红色技能按钮动效显示判断
			if BF.HasBuffKind(self.Me,1004073) and self.UltimateStateResNum > 0
				and (BF.CanCastSkill(self.Me) or (self.RAP.MyState == FES.Skill and self.RAP.CurrentSkill ~= 1004040))
				and BF.CheckBtnUseSkill(self.Me,FK.NormalSkill) and self.CoreResRatio < 5000 then
				BF.SetFightMainNodeVisible(1,"IEffect20016",true,1)
			else
				BF.SetFightMainNodeVisible(1,"IEffect20016",false,1)
			end
			--角色资源条--就绪动效显示判断
			if self.CoreResRatio >= 5000 and not(self.RAP.MyState == FES.Skill and self.RAP.CurrentSkill == 1004040) then
				BF.SetPlayerCoreEffectVisible("20052", true)
				--BF.SetPlayerCoreEffectVisible("20057", true)
			else
				BF.SetPlayerCoreEffectVisible("20052", false)
				--BF.SetPlayerCoreEffectVisible("20057", false)
			end
			--角色资源条--状态动效显示判断
			if self.CoreResRatio < 5000 and (self.RAP.MyState == FES.Skill and self.RAP.CurrentSkill == 1004040) then
				BF.SetPlayerCoreEffectVisible("20029", true)
				BF.SetPlayerCoreEffectVisible("20030", true)
			else
				BF.SetPlayerCoreEffectVisible("20029", false)
				BF.SetPlayerCoreEffectVisible("20030", false)
			end

			--全屏特效显示判断
			if BF.HasBuffKind(self.Me,1004073) and not BF.HasBuffKind(self.Me,1004075) and not BF.HasBuffKind(self.Me,1003) then
				BF.AddBuff(self.Me,self.Me,1004075,1)
			elseif BF.HasBuffKind(self.Me,1004075) and (not BF.HasBuffKind(self.Me,1004073) or BF.HasBuffKind(self.Me,1003) )then
				BF.RemoveBuff(self.Me,1004075,5)
			end
		end
		
		--核心技能释放判断,可释放技能或处于技能状态且技能优先级低，且长按时间和资源足够
		if (BF.CanCastSkill(self.Me) or (BF.CheckEntityState(self.Me,FES.Skill)
			and (self.RAP.CurrentSkillPriority < 2 or BF.GetSkillSign(self.Me,1004070) or BF.GetSkillSign(self.Me,1004010)))) 
			and self.RAP.PressButton[1] == FK.Attack and self.RAP.PressButtonFrame[1] >= 7 and self.CoreResRatio >= 5000 then

			if BF.CheckEntityState(self.Me,FES.Skill) then
				BF.BreakSkill(self.Me)
			end
			self.RAB.RoleCatchSkill:CatchSkillPart(self.CoreSkill[1],"Lerp")
			self.RAP.CurrentSkillPriority = 2
		end
		
		--存在核心攻击标记判断
		if BF.HasEntitySign(self.Me,10040000) then
			--核心资源大于0、核心攻击非冷却、按键时间不等于0
			if self.RAP.CoreRes[1] > 0 and self.CoreAttackFrame < self.RAP.RealFrame and
				(self.RAP.PressButtonFrame[1] > 0 or self.CoreSkillCancelFrame > self.RAP.RealFrame) then
				self:CoreAttack()
				local m1 = 0
				--释放间隔帧数判断
				if BF.HasBuffKind(self.Me,1004073) then
					m1 = 4
				else
					m1 = 4
				end
				self.CoreAttackFrame = self.RAP.RealFrame + m1
				--大招状态释放残影消耗
				if BF.HasBuffKind(self.Me,1004073) then
					BF.DoMagic(self.Me,self.Me,1004043,1)
				--非大招状态释放残影消耗
				else
					BF.DoMagic(self.Me,self.Me,1004043,1)
					--BF.DoMagic(self.Me,self.Me,1004042,1)
				end
			--核心资源等于0，或普攻按钮无长按，且核心技能取消延迟时间结束
			elseif (self.RAP.CoreRes[1] <= 0 or self.RAP.PressButtonFrame[1] == 0) and self.CoreSkillCancelFrame < self.RAP.RealFrame then
				BF.RemoveEntitySign(self.Me,10040000)
				if BF.CheckEntityState(self.Me,FES.Skill) and self.RAP.CurrentSkill == 1004040 then
					BF.BreakSkill(self.Me)
					BF.CastSkillBySelfPosition(self.Me,1004041)
					BF.CreateEntity(100404002, self.Me, self.RAP.MyPos.x, self.RAP.MyPos.y, self.RAP.MyPos.z)
				end
				BF.RemoveBuff(self.Me,1004041,5) --移除隐藏骨骼
			end
		end
	end
end
--杂项判断延伸：核心攻击触发判断
function Behavior1004:CoreAttack()
	--参数项
	local d = 0  --偏移距离
	local r1 = BF.Random(45,135) --角度随机1
	local r2 = BF.Random(225,315) --角度随机2
	local s = 0  --残影Id
	local p1 = {} --创建坐标
	local p2 = {} --朝向坐标
	
	--随机距离
	d = BF.RandomSelect(0.6,0.8,1,1.2,1.4,1.6)
	--随机坐标
	p1 = BF.RandomFunctionWithParms(
		{BF.GetPositionOffsetBySelf,BF,{self.Me,d,r1}},
		{BF.GetPositionOffsetBySelf,BF,{self.Me,d,r2}}
	)
	--随机残影实体
	s = BF.RandomSelect(1004040001,1004040002,1004040003,1004040004,1004040005,1004040006,1004040007)
	self.RAB.RoleCatchSkill:TargetPart(false)
	--存在攻击目标，则向目标释放残影攻击
	if self.RAP.AttackTarget ~= 0 and self.RAP.AttackTarget ~= nil then
		p2 = BF.GetPositionP(self.RAP.AttackTarget) --以目标坐标为朝向点
		BF.CreateEntity(s, self.Me, p1.x, p1.y, p1.z, p2.x, p1.y, p2.z) --释放残影实体
		--尝试锁定目标
		if not BF.CheckLockTarget() and self.RAP.CtrlRole == self.Me then
			self.RAP.LockTarget = self.RAP.AttackTarget
			BF.SetLockTarget(self.RAP.LockTarget)
		end
	--如果有摇杆输入，则向摇杆方向释放残影
	elseif self.RAP.JoystickPosX ~= 0 and self.RAP.JoystickPosZ ~= 0 then
		BF.DoLookAtPositionImmediately(self.Me,self.RAP.MyFrontPos.x,self.RAP.MyFrontPos.y,self.RAP.MyFrontPos.z)
		BF.CreateEntity(s, self.Me, p1.x, p1.y, p1.z, self.RAP.MyFrontPos.x, p1.y, self.RAP.MyFrontPos.z)
	--不存在攻击目标，则朝前方释放残影攻击
	else
		BF.CreateEntity(s, self.Me, p1.x, p1.y, p1.z, self.RAP.MyFrontPos.x, p1.y, self.RAP.MyFrontPos.z)
	end
	--非大招状态增加能量
	if not BF.HasBuffKind(self.Me,1004073) then
		BF.DoMagic(self.Me,self.Me,1004044,1)
	end
	--核心攻击增加缔约值
	if not BF.HasEntitySign(1,10000009) then
		BF.DoMagic(self.Me,self.Me,1004082,1)
	end
	----随机施加震屏
	--BF.RandomFunctionWithParms(
		--{BF.DoMagic,BF,{self.Me,self.Me,1004047,1}},
		--{BF.DoMagic,BF,{self.Me,self.Me,1004048,1}}
	--)
end

--首次命中判断
function Behavior1004:FirstCollide(attackInstanceId,hitInstanceId,InstanceIdId)
	--红色技能首次命中判断，加核心资源、能量
	local I = BF.GetEntityTemplateId(InstanceIdId)
	if attackInstanceId == self.Me and (I == 1004001001) then
		BF.ChangeBtnSkillCDTime(self.Me,FK.NormalSkill,-0.7)
	end
	if attackInstanceId == self.Me and (I == 1004002001 or I == 1004002002) then
		BF.ChangeBtnSkillCDTime(self.Me,FK.NormalSkill,-0.5)
	end
	if attackInstanceId == self.Me and (I == 1004003001 or I == 1004003002 or I == 1004003003) then
		BF.ChangeBtnSkillCDTime(self.Me,FK.NormalSkill,-0.8)
	end
	if attackInstanceId == self.Me and (I == 1004004001 or I == 1004004002) then
		BF.ChangeBtnSkillCDTime(self.Me,FK.NormalSkill,-0.5)
	end
	if attackInstanceId == self.Me and (I == 1004005001 or I == 1004005002 or I == 1004005003 or I == 1004005004) then
		BF.ChangeBtnSkillCDTime(self.Me,FK.NormalSkill,-0.7)
	end
	if attackInstanceId == self.Me and (I == 1004006001) then
		BF.ChangeBtnSkillCDTime(self.Me,FK.NormalSkill,-1)
	end
	--if attackInstanceId == self.Me and (I == 1004010001 or I == 1004010002) and not BF.HasBuffKind(self.Me,1004073) 
		--and self.RedSkillResNum < 8 and self.RedSkillType == 1 then
		--self.RedSkillResNum = self.RedSkillResNum + 1
		--BF.DoMagic(self.Me,self.Me,1004011,1) --增加核心资源
		--BF.DoMagic(self.Me,self.Me,1004012,1) --增加能量
	--end
end

--命中判断
function Behavior1004:Collide(attackInstanceId,hitInstanceId,InstanceId)
	--蓝色技能命中判断，额外伤害、特效相关
	if attackInstanceId == self.Me and hitInstanceId ~= self.Me and 
		self.BlueSkillCharge > 0 and self.BlueSkillHitFrame < self.RAP.RealFrame then
		local P = BF.GetPositionP(hitInstanceId)
		BF.CreateEntity(1004020001, hitInstanceId, P.x, P.y+0.7, P.z)
		self.BlueSkillHitFrame = self.RAP.RealFrame + 1 --隔帧触发间隔
		--非大招状态减少充能次数获得能量、核心资源
		if not BF.HasBuffKind(self.Me,1004073) then
			BF.DoMagic(self.Me,self.Me,1004022,1) --减少蓝色技能充能次数
			BF.DoMagic(self.Me,self.Me,1004024,1) --增加能量
			BF.DoMagic(self.Me,self.Me,1004023,1) --增加核心资源
		end
	end
end

--技能释放判断
function Behavior1004:CastSkill(instanceId,skillId,skillSign,skillType)
	--核心技能释放判断，添加阻止打断时间
	if instanceId == self.Me and skillId == 1004040 then
		self.CoreSkillCancelFrame = self.RAP.RealFrame + 19
	end
	--红色技能释放判断
	if instanceId == self.Me and skillId == 1004010 or skillId == 1004011 or skillId == 1004012 then
		--大招状态加满核心资源 / 非大招状态清空资源获取次数
		if BF.HasBuffKind(self.Me,1004073) and self.UltimateStateResNum > 0 then
			BF.DoMagic(self.Me,self.Me,1004072,1) --大招加满核心资源
			--self.UltimateStateResNum = self.UltimateStateResNum - 1
			--self.RedSkillResNum = 8 --红色技能命中增加资源次数
		else
			--不存在缔约状态则获得缔约值
			if not BF.HasEntitySign(1,10000009) then
				BF.DoMagic(self.Me,self.Me,1004080,1) --红色技能增加缔约值
			end
			BF.DoMagic(self.Me,self.Me,1004011,1) --非大招状态增加核心资源
			BF.DoMagic(self.Me,self.Me,1004012,1) --非大招状态增加大招能量
			--self.RedSkillResNum = 0	--红色技能命中增加资源次数
		end
	end
	--大招技能释放判断
	if instanceId == self.Me and skillId == 1004070 then
		self.UltimateStateResNum = 2 --大招状态红色技能全满核心资源次数
	end
	--不在缔约状态则释放技能获得缔约值
	if instanceId == self.Me and not BF.HasEntitySign(1,10000009) then
		if skillSign == 10 then
			BF.DoMagic(self.Me,self.Me,1004080,1)
		end
		if skillSign == 20 then
			BF.DoMagic(self.Me,self.Me,1004081,1)
		end
		if skillSign == 70 then
			BF.DoMagic(self.Me,self.Me,1004083,1)
		end
	end
end

--技能打断判断
function Behavior1004:BreakSkill(instanceId,skillId,skillSign,skillType)	

	--红色技能打断判断，移除免疫受击buff
	if instanceId == self.Me and (skillId == 1004010 or skillId == 1004011 and skillId == 1004012) then
		if BF.HasBuffKind(self.Me,1004012) then
			BF.RemoveBuff(self.Me,1004012,5)
		end
	end
	--核心技能打断判断，移除隐藏骨骼效果、免疫受击、创建取消特效
	if instanceId == self.Me and skillId == 1004040 then
		if BF.HasBuffKind(self.Me,1004041) then
			BF.RemoveBuff(self.Me,1004041,5)
		end
		if BF.HasBuffKind(self.Me,1004045) then
			BF.RemoveBuff(self.Me,1004045,5)
		end
		BF.CreateEntity(100404002, self.Me, self.RAP.MyPos.x, self.RAP.MyPos.y, self.RAP.MyPos.z)
		--移除核心技能残影攻击实体标记
		if BF.HasEntitySign(self.Me,10040000) then
			BF.RemoveEntitySign(self.Me,10040000)
		end
		if self.RAP.CtrlRole == self.Me then
			self.RAP.AttackPressFrame = 0 --重置普攻按钮长按帧数
			BF.RemoveKeyPress(FK.Attack) --重置普攻按钮长按状态
		end
	end
	--闪避反击打断判断，移除免疫受击buff
	if instanceId == self.Me and skillId == 1004050 then
		if BF.HasBuffKind(self.Me,1004051) then
			BF.RemoveBuff(self.Me,1004051,5)
		end
	end
	--QTE打断判断，移除免疫受击buff
	if instanceId == self.Me and skillId == 1004060 then
		if BF.HasBuffKind(self.Me,1004061) then
			BF.RemoveBuff(self.Me,1004061,5)
		end
	end
end


--重写角色释放技能组合
function Behavior1004:RoleCatchSkill()
	--检查按键缓存
	local Button = 0
	if self.RAP.ClickButton[1] ~= 0 and self.RAP.ClickButton[1] ~= nil then
		Button = 1
	elseif self.RAP.ClickButton[2] ~= 0 and self.RAP.ClickButton[1] ~= nil then
		Button = 2
	elseif self.RAP.ClickButton[3] ~= 0 and self.RAP.ClickButton[1] ~= nil then
		Button = 3
	end
	--按钮存在判断
	if (Button == 1 or Button == 2 or Button == 3) and BF.CheckEntityForeground(self.Me) then
		--大招释放判断
		if self.RAP.ClickButton[Button] == FK.UltimateSkill then
			if self.RAB.RoleCatchSkill:ActiveSkill(Button,self.UltimateSkill[1],5,3,0,0,0,{0},"Immediately") then
				BF.CastSkillCost(self.Me,self.UltimateSkill[1])
			end
		--闪避释放判断
		elseif self.RAP.ClickButton[Button] == FK.Dodge then
			if self.RAB.RoleCatchSkill:MoveSkill(Button,3,3,0,0,0,{0}) then
				--BF.CastSkillCost(self.Me,self.MoveSkill[1])
			end
		--核心释放判断
		--elseif self.RAP.ClickButton[Button] == FK.Partner then
			----通用主动技能释放判断：按钮、技能优先级、技能Id、(打断优先、技能窗口)、（实体标记条件、Buff类型条件)、打断受击集
			--if self.RAB.RoleCatchSkill:ActiveSkill(Button,6,self.Core[1],5,0,0,0,{-1}) then
				----BF.CastSkillCost(self.Me,self.Core[1])
			--end
		--普通技能释放判断
		elseif self.RAP.ClickButton[Button] == FK.NormalSkill then
			if BF.HasBuffKind(self.Me,1004073) and self.RAP.CurrentSkill == 1004070 and BF.GetSkillSign(self.Me,1004070) then
				BF.BreakSkill(self.Me)
			end
			if BF.HasBuffKind(self.Me,1004073) then
				if self.RAB.RoleCatchSkill:ActiveSkill(Button,self.SpecialSkill[1],5,3,0,0,0,{0},"Immediately") then
					BF.CastSkillCost(self.Me,self.SpecialSkill[1])
				end
			else
				if self.RAB.RoleCatchSkill:ContSkill(Button,self.SpecialSkill,2,2,10000001,0,0,{0},"Immediately") then
					BF.CastSkillCost(self.Me,self.SpecialSkill[1])
				end
			end
		--普攻释放判断
		elseif self.RAP.ClickButton[Button] == FK.Attack then
			if BF.HasEntitySign(self.Me,10000000) then
				if self.RAB.RoleCatchSkill:ActiveSkill(Button,self.DodgeCounter[1],2,2,0,0,0,{0},"Immediately") then
					BF.RemoveEntitySign(self.Me,10000000)
				end
			--判断是否处于普攻暂停使用期间
			elseif self.AttackPauseFrame < self.RAP.RealFrame then
				self.RAB.RoleCatchSkill:ContSkill(Button,self.NormalAttack,1,1,10000001,0,0,{0},"Lerp")
			end
		end
	end
end 
