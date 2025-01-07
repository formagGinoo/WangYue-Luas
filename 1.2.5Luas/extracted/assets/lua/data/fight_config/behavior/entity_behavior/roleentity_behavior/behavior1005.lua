Behavior1005 = BaseClass("Behavior1005",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior1005.GetGenerates()
	local generates = {}
	return generates
end
function Behavior1005.GetOtherAsset()
	local generates = {
	}
	return generates
end

function Behavior1005:Init()
	--变量声明
	self.Me = self.instanceId	--记录自己

	--普攻技能Id
	self.NormalAttack = {1005001,1005002,1005003,1005004,1005005}
	self.NormalSkill = {1005010,1005011,1005012}  --普通技能Id
	self.MoveSkill = {1005030,1005031}	--闪避技能Id
	self.FallAttack = {1005170,1005171,1005172}	--下落攻击Id
	--self.AirAttack = {1005101,1005102,1005103}	--空中攻击Id
	self.partnerAttack = {1005996,1005997} --仲魔技能id
	--self.LeapAttack = {1005160}	--起跳攻击Id
	self.CoreSkill = {1005040}	--核心技能Id
	self.QTESkill = {1005001}	--QTE技能Id
	--self.DodgeAttack = {1005070}	--闪避反击技能
	self.JumpAttack = {1005080,1005081,1005082}	--闪避反击技能
	self.UltimateSkill = {1005050,1005051}	--大招技能Id

	self.QTEtype = 1			--QTE类型：1切换角色放技能，2不切换角色下场放技能，3AI援助
	self.QTEPosRef = 1			--QTE出场坐标参考：1参考在场角色，2参考其他目标
	self.QTEChangeCD = 1		--QTE/切换角色冷却时间

	self.LockDistance = 15
	self.CancelLockDistance = 30

	--通用参数组合初始化、角色组合合集
	self.RoleAllParm = BehaviorFunctions.CreateBehavior("RoleAllParm",self)
	self.RoleAllBehavior = BehaviorFunctions.CreateBehavior("RoleAllBehavior",self)

	--组合缩写
	self.RAB = self.RoleAllBehavior
	self.RAP = self.RoleAllParm

	self.NormalSkillFrame = 0	--强化技能释放帧数
	self.CoreNum = {0,0,0}
	self.CoreNumFrame = {0,0,0}
	self.CanyingFrame = 0

	self.partner = 0
	self.partnerMisson = 0
	self.partnerId = 0

	--暗杀目标和是否可暗杀参数
	self.assTarget = 0
	self.targetAssLimit = 0
	self.assDistance = 15 --暗杀距离5
	self.assingTarget = 0
	self.setPartnerBtn = 0 --按钮设置状态
	self.assNewTarget = 0
	self.AllTargetList = {}
	self.cameraState = 0
	self.assTargetState = 0
end

function Behavior1005:Update()

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

		--获取仲魔信息
		self:GetPartnerInfo()

	end
end

--角色个人判断
function Behavior1005:Core()

	--检查核心资源率
	self.RAP.CoreResRatio = BF.GetEntityAttrValueRatio(self.Me,1204)
	self.RAP.CoreRes = BF.GetEntityAttrVal(self.Me,1204)

	--if not BF.HasBuffKind(self.Me,1005054) then
		--BF.AddBuff(self.Me,self.Me,1005054,1)
	--end
	
	----核心UI动效判断 -- 核心资源充满
	--if self.RAP.CtrlRole == self.Me and self.RAP.CoreRes >= 3 then
		--BF.SetCoreEffectVisible(self.Me,"22098",true)
	--else
		--BF.SetCoreEffectVisible(self.Me,"22098",false)
	--end

	--角色在场逻辑
	if self.RAP.CtrlRole == self.Me then

		--技能-闪躲衔接技能-反击判断
		if self.RAP.CurrentSkill == self.NormalSkill[2] and BF.GetSkillSign(self.Me,10050011) then
			BF.BreakSkill(self.Me)
			self.RAB.RoleCatchSkill:ActiveSkill(0,self.NormalSkill[3],2,2,0,0,0,{0},"Immediately","ClearClick",true)
		end
		
		--BF.SetCoreUIScale(self.Me, 1)
		--BF.SetCoreUIPosition(self.Me, 0, 0)

		----核心UI显示判断
		--if (BF.CheckPlayerInFight() or self.RAP.CoreUiFrame > self.RAP.RealFrame) then
			--BF.SetCoreUIVisible(self.Me, true, 0.2)
		--else
			--BF.SetCoreUIVisible(self.Me, false, 0.5)
		--end

		----核心按钮长按提示判断
		--if self.RAP.CoreRes >= 3 then
			--BF.PlayFightUIEffect("20015","J")
			--BF.SetPlayerCoreEffectVisible("20027", true)
			--BF.SetPlayerCoreEffectVisible("20028", true)
		--else
			--BF.StopFightUIEffect("20015","J")
			--BF.SetPlayerCoreEffectVisible("20027", false)
			--BF.SetPlayerCoreEffectVisible("20028", false)
		--end

		----技能强化动效判断
		--if BF.GetSkillCostValue(self.Me,FK.NormalSkill) >= 2 then
		--BF.SetSkillBehaviorConfig(self.Me, 1001010, "ReadyEffectPath", BehaviorFunctions.GetEffectPath(22096))
		--elseif BF.GetSkillCostValue(self.Me,FK.NormalSkill) == 1 then
		--BF.SetSkillBehaviorConfig(self.Me, 1001010, "ReadyEffectPath", BehaviorFunctions.GetEffectPath(22058))
		--end

		----全身隐藏显示判断
		--if BF.GetSkillSign(self.Me,10010002) and not BF.HasBuffKind(self.Me,1001902) then
			--BF.AddBuff(self.Me,self.Me,1001902,1)
		--elseif not BF.GetSkillSign(self.Me,10010002) and BF.HasBuffKind(self.Me,1001902) then
			--BF.RemoveBuff(self.Me,1001902,5)
		--end
	end
end

--重写角色释放技能组合
function Behavior1005:RoleCatchSkill()
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
				or (self.RAP.MyState == FES.Skill and BF.GetSkillType(self.Me) ~= 50 and BF.GetSkillType(self.Me) ~= 80 and BF.GetSkillType(self.Me) ~= 81))then
			if self.RAP.MyState == FES.Skill then
				BF.BreakSkill(self.Me)
			end
			if BF.DoJump(self.Me) then
				self.RAB.RoleCatchSkill:ClearButtonPart(ClickButton,"ClearClick")
			end
		--大招释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.UltimateSkill and BF.CheckEntityHeight(self.Me) == 0 then
			if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.UltimateSkill[1],5,3,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
				BF.CastSkillCost(self.Me,self.UltimateSkill[1])
			end
		--闪避释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.Dodge and BF.CheckEntityHeight(self.Me) == 0 then
			if self.RAB.RoleCatchSkill:MoveSkill(ClickButton,3,3,0,0,0,{21},"ClearClick") then
				BF.CastSkillCost(self.Me,self.MoveSkill[1],"ClearClick")
			end
		--普通技能释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.NormalSkill and BF.CheckEntityHeight(self.Me) == 0 then
			if BF.GetSkillCostValue(self.Me,FK.NormalSkill) >= 2 then
				--if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalSkill[1],2,2,0,0,0,{0},"Immediately","ClearClick",true) then
					--BF.CastSkillCost(self.Me,self.NormalSkill[1])
				--end
				self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalSkill[1],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1)
				--self.RAB.RoleCatchSkill:ContSkill(ClickButton,self.NormalSkill,2,2,10000002,0,0,{0},"Immediately","ClearClick",true)
			end
		--普攻长按释放判断(空中)
		elseif self.RAP.PressButton[PressButton] == FK.Attack and self.RAP.PressButtonFrame[PressButton] >= 7
			and BF.CheckEntityHeight(self.Me) >= 1 then
			self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.FallAttack[1],170,170,0,0,0,{0},"0","ClearPress",true,0,-1)
		--普攻长按释放判断(地面)
		elseif self.RAP.PressButton[PressButton] == FK.Attack and self.RAP.PressButtonFrame[PressButton] >= 12 then
			--and BF.CheckEntityHeight(self.Me) == 0 and self.RAP.CoreRes >= 3 then
			--if self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.CoreSkill[1],2,2,0,0,0,{0},"Immediately","ClearPress",true) then
				----BF.CastSkillCost(self.Me,1204)
				----BF.SetCoreEffectVisible(self.Me,"22099",false)
				----BF.SetCoreEffectVisible(self.Me,"22099",true)
				----BF.ChangeEntityAttr(self.Me,1204,-300,1)	--总-3
			--end
		--普攻点按释放判断(地面)
		elseif self.RAP.ClickButton[ClickButton] == FK.Attack and BF.CheckEntityHeight(self.Me) == 0 then
			--闪避反击释放判断
			if BF.HasEntitySign(self.Me,10000000) then
				if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.DodgeAttack[1],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
					BF.RemoveEntitySign(self.Me,10000000)
				end
			else
				self.RAB.RoleCatchSkill:ContSkill(ClickButton,self.NormalAttack,1,1,10000002,0,0,{0},"Immediately","ClearClick",true,0,-1)
			end
		--释放仲魔临时逻辑
		elseif self.RAP.ClickButton[ClickButton] == FK.Partner and self.partner then
			self:DoPartnerSkill()
		end
	end
end

--首次命中判断
function Behavior1005:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	local I = BF.GetEntityTemplateId(instanceId)
	if attackInstanceId == self.Me then
		--普攻子弹--总2格--总50点核心-1/6
		if I == 1005001001 then
			BF.AddSkillPoint(self.Me,1201,0.2)	--总0.2格
			--BF.ChangeEntityAttr(self.Me,1204,3,1)--总3
		end
		if I == 1005002001 or I == 1005002002 or I == 1005002003 then
			BF.AddSkillPoint(self.Me,1201,0.1)	--总0.3格
			--BF.ChangeEntityAttr(self.Me,1204,3,1)--总9
		end
		if I == 1005003001 or I == 1005003002 or I == 1005003003 or I == 1005003004 then
			BF.AddSkillPoint(self.Me,1201,0.125)	--总0.5格
			--BF.ChangeEntityAttr(self.Me,1204,4,1)--总16
		end
		if I == 1005004001 or I == 1005004002 then
			BF.AddSkillPoint(self.Me,1201,0.12)	--总0.36格
			--BF.ChangeEntityAttr(self.Me,1204,4,1)--总12
		end
		if I == 1005005001 or I == 1005005002 or I == 1005005003 then
			BF.AddSkillPoint(self.Me,1201,0.32)	--总0.64格
			--BF.ChangeEntityAttr(self.Me,1204,5,1)--总10
		end
		----跳反子弹强制打断敌人技能
		--if BF.CheckEntity(hitInstanceId) and I == 1001081001 then
			--BF.BreakSkill(hitInstanceId)
		--end
		--临时跳反踩踏子弹强制打断敌人技能
		if BF.CheckEntity(hitInstanceId) and I == 1000000019 then
			BF.BreakSkill(hitInstanceId)
		end
	end
end

--命中判断
function Behavior1005:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType)
	if hitInstanceId == self.Me then
		--技能受击切换技能
		if self.RAP.CurrentSkill == 1005010 and BF.GetSkillSign(self.Me,10050010) 
			and (attackType == FEEAT.General or attackType == FEEAT.Special) then
			BF.SetHitType(self.Me,0)
			BF.DoSetEntityState(self.Me,FES.Idle)
			self.RAB.RoleCatchSkill:ActiveSkill(0,self.NormalSkill[2],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1)
		end
	end
	
	local I = BF.GetEntityTemplateId(instanceId)
	if BF.HasBuffKind(self.Me,1005054) and attackInstanceId == self.Me and (I == 1005003001 or I == 1005003001 or I == 1005003001 
			or I == 1005003001) and self.CanyingFrame <= self.RAP.RealFrame then
		--攻击命中产生残影
		--if self.RAP.CurrentSkill == 1005001 then
			local p0 = BF.GetPositionP(self.Me)
			local p1 = BF.GetPositionP(hitInstanceId)
			local r = BF.RandomSelect(90,120,150,210,240,270,160,170,190,200)
			local p2 = BF.GetPositionOffsetP(p1,p0,3,r)
			local c = 1005050099
			local s = BF.RandomSelect(1005050001,1005050002,1005050003,1005050004,1005050005)
			local m = BF.CreateEntity(c, self.Me, p2.x, p2.y, p2.z,p1.x, p1.y, p1.z) --释放大招子弹实体
			BF.AddDelayCallByFrame(0, self, function()
				BF.CastSkillByTarget(m,s,hitInstanceId)
			end)
			BF.AddBuff(self.Me,m,1005051,1)
			BF.AddBuff(self.Me,m,1005052,1)
			BF.AddBuff(self.Me,m,1005053,1)
		--end
	end
end

--技能释放判断
function Behavior1005:CastSkill(instanceId,skillId,skillType)
	--if instanceId == self.Me and (((skillType ~= 30 and skillType ~= 31) and not BF.CheckPlayerInFight()) or BF.CheckPlayerInFight()) then
		--self.RAP.CoreUiFrame = self.RAP.RealFrame + 90
		----BF.ChangeEntityAttr(self.Me,1206,-250,1)
		----self.ChangeLockTargetFrame = 0 --闪避重置切换锁定目标间隔时间
	--end
end

--属性变化判断
function Behavior1005:ChangeAttrValue(attrType,attrValue,changedValue)
	if attrType == 1204 then
		self.RAP.CoreUiFrame = self.RAP.RealFrame + 90
		--if changedValue ~= 0 then
		--self:CorePart(changedValue)
		--end
	end
end

--通用闪避成功判断
function Behavior1005:Dodge(attackInstanceId,hitInstanceId,limit)
	if hitInstanceId == self.Me and limit == true then
		BF.ChangeEntityAttr(self.Me,1204,1,1)
		--BF.ChangeEntityAttr(self.Me,1204,75,1)
		--BF.AddEntitySign(hitInstanceId,10000000,3) --角色3秒内反击标记
	end
end

--动画帧事件判断
function Behavior1005:OnAnimEvent(instanceId,eventType,params)
	----左手武器显隐判断
	--if instanceId == self.Me and eventType == FEAET.LeftWeaponVisible then
		--if params.visible then
			--if BF.HasBuffKind(self.Me,1000074) then
				--BF.RemoveBuff(self.Me,1000074,5)
			--end
		--else
			--if not BF.HasBuffKind(self.Me,1000074) then
				--BF.AddBuff(self.Me,self.Me,1000074,1)
			--end
		--end
	--end
	--右手武器显隐判断
	if instanceId == self.Me and eventType == FEAET.RightWeaponVisible then
		if params.visible then
			if BF.HasBuffKind(self.Me,1000073) then
				BF.RemoveBuff(self.Me,1000073,5)
			end
		else
			if not BF.HasBuffKind(self.Me,1000073) then
				BF.AddBuff(self.Me,self.Me,1000073,1)
			end
		end
	end
end

--跳跃反击着地回调
function Behavior1005:OnLand(instanceId)
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

--技能结束判断
function Behavior1005:FinishSkill(instanceId,skillId,skillType)
	--if instanceId == self.Me and skillId == 1001081 then
		--BF.SetCameraParams(FightEnum.CameraState.ForceLocking) --重置强锁定镜头参数
	--end
end

--获取仲魔信息
function Behavior1005:GetPartnerInfo()


	self.partnerPos = BehaviorFunctions.GetPositionOffsetBySelf(self.Me,2,280)	--战中技能释放位置
	self.partnerPos2 = BehaviorFunctions.GetPositionOffsetBySelf(self.Me,0,0)	--战前技能释放位置
	self.partner = BehaviorFunctions.GetPartnerInstanceId(self.Me)				--获取仲魔id



	--穿上时获取仲魔相关信息，卸下时重置
	if self.partner then
		self.partnerId = BehaviorFunctions.GetEntityTemplateId(self.partner)
	else
		self.partnerId = 0
	end


	--潜行类型仲魔获取钻地状态
	if self.partnerId == 610025 then
		self.hideState = BehaviorFunctions.GetEntityValue(self.partner,"hideState")
	end
end



--临时仲魔技能逻辑
function Behavior1005:DoPartnerSkill()
	if BehaviorFunctions.CheckPlayerInFight() then
		if self.partnerId == 62001 or self.partnerId == 610040 or self.partnerId == 600060 then
			if BF.CheckEntityHeight(self.Me) == 0 then
				if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.partnerAttack[1],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then

				end

			end
		elseif self.partnerId == 610025 then
			if self.hideState == 0 then
				if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.partnerAttack[2],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
				end
			end
		end
	else
		if self.partnerId == 610040 or self.partnerId == 600060 then
			if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.partnerAttack[1],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then

			end
			--暗杀
		elseif self.partnerId == 62001 then
			--地面暗杀
			if BF.CheckEntityHeight(self.Me) == 0 and not BF.HasEntitySign(self.Me,62001001) then
				if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.partnerAttack[2],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
				end

			end
			--钻地
		elseif self.partnerId == 610025 and self.hideState == 0 and BF.CheckEntityHeight(self.Me) == 0 then
			--if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.partnerAttack[2],2,2,0,0,0,{0},"Immediately","ClearClick",true) then
			if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.partnerAttack[2],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then

			end
			--BehaviorFunctions.CastSkillCost(self.partner,self.worldSkill)
			--end
		end
	end
end


