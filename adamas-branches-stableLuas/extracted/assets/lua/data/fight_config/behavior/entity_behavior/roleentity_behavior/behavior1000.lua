Behavior1000 = BaseClass("Behavior1000",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType

function Behavior1000.GetGenerates()
	local generates = {
		
	}
	return generates
end
function Behavior1000.GetOtherAsset()
	local generates = {
	}
	return generates
end

function Behavior1000:Init()
	--变量声明
	self.Me = self.instanceId		--记录自己

	--以下技能集合，如果没有该技能或者动作，最好随便找一个有ID的技能先占着
	self.NormalAttack = {1001001,1001002,1001003,1001004,1001005}	--普攻的连段
	self.NormalSkill = {1001010}	--普通技能Id
	self.MoveSkill = {1001030,1001031}	--闪避技能Id：前闪避，后闪避
	self.FallAttack = {1001170,1001171,1001172}	--下落攻击Id
	self.CoreSkill = {1001044}	--核心技能Id
	self.UltimateSkill = {1001051,1001052}	--大招技能Id
	
	
	self.JumpAttack = {1001080,1001081,1001082}	--跳跃反击技能，需要在动画工具中配置跳反识别帧

	
	--佩从技能相关，缺失则会导致释放佩从技能报错，配置这些技能之前看一下佩从的通用窗口
	
	self.PartnerCall = {1001061,1001062} --佩从召唤动作，60000002，通用出场窗口
	self.PartnerHenshin = {1001060} --佩从变身动作集合，600000020：通用出场窗口
	
	
	self.LockDistance = 15	--锁定距离
	self.CancelLockDistance = 30	--撤销锁定距离

	--通用参数组合初始化、角色组合合集
	self.RoleAllParm = BehaviorFunctions.CreateBehavior("RoleAllParm",self)
	self.RoleAllBehavior = BehaviorFunctions.CreateBehavior("RoleAllBehavior",self)

	--组合缩写
	self.RAB = self.RoleAllBehavior
	self.RAP = self.RoleAllParm

	self.NormalSkillFrame = 0	--强化技能释放帧数
	

	
	--QTE参数重写，如果不需要特殊的QTE则直接屏蔽
	--self.RAP.QTEDistance  = 4		--连携QTE距离
	--self.RAP.QTEAngle = 135			--连携QTE角度
	--self.RAP.QTECd = 5				--QTE冷却
	--self.QTEtype = 4			--QTE类型：1切换角色放技能，2不切换角色下场放技能，3AI援助,4转镜切人
	--self.QTEPosRef = 1			--QTE出场坐标参考：1参考在场角色，2参考其他目标
	--self.QTEChangeCD = 1		--QTE/切换角色冷却时间
end

function Behavior1000:LateInit()
	self.RAP:LateInit()
end

function Behavior1000:Update()

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
		--self:RoleCatchSkill()
		self.RAB.RoleCatchSkill:Update()
		
		--通用角色参数开放
		self.RAP:SetEntityValuePart()
		
		--角色通用佩从判断
		self.RAB.RolePartnerBase:Update()
		
		--角色相机逻辑外接
		self.RAB.RoleCameraParm:Update()
	end
end


--重写角色释放技能组合,如果不需要重写则不需要添加
function Behavior1000:RoleCatchSkill()
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
			if BF.GetSkillCostValue(self.Me,FK.NormalSkill) >= 2 then
				if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalSkill[1],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
					BF.CastSkillCost(self.Me,self.NormalSkill[1])
	
				end
			end
			--普攻长按释放判断(空中)
		elseif self.RAP.PressButton[PressButton] == FK.Attack and self.RAP.PressButtonFrame[PressButton] >= 7
			and BF.CheckEntityHeight(self.Me) >= 1 then
			self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.FallAttack[1],170,170,0,0,0,{0},"0","ClearPress",true,0,-1)
			--普攻长按释放判断(地面)，核心能量>3时，长按普攻释放核心
		elseif self.RAP.PressButton[PressButton] == FK.Attack and self.RAP.PressButtonFrame[PressButton] >= 12
			and BF.CheckEntityHeight(self.Me) == 0 and self.RAP.CoreRes >= 3 then
			if self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.CoreSkill[1],2,2,0,0,0,{0},"Immediately","ClearPress",true,0,-1) then
				
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

--首次命中判断，如果不需要命中添加日相则不需要添加
function Behavior1000:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	local I = BF.GetEntityTemplateId(instanceId)
	if attackInstanceId == self.Me then
		--子弹命中加日相
		--普攻子弹--总2格--总50点核心-1/6
		if I == 1001001001 then
			BF.AddSkillPoint(self.Me,1201,0.0471,FE.SkillPointSource.NormalAttack)
		end
		if I == 1001002001 or I == 1001002002 then
			BF.AddSkillPoint(self.Me,1201,0.0563,FE.SkillPointSource.NormalAttack)
		end
		if I == 1001003001 or I == 1001003002 then
			BF.AddSkillPoint(self.Me,1201,0.044,FE.SkillPointSource.NormalAttack)
		end
		if I == 1001004001 or I == 1001004002 or I == 1001004003 or I == 1001004004 then
			BF.AddSkillPoint(self.Me,1201,0.0502,FE.SkillPointSource.NormalAttack)
		end
		if I == 1001005001 then
			BF.AddSkillPoint(self.Me,1201,0.044,FE.SkillPointSource.NormalAttack)
		end
		if I == 1001005002 then
			BF.AddSkillPoint(self.Me,1201,0.0563,FE.SkillPointSource.NormalAttack)
		end
	end
end

--技能释放判断
function Behavior1000:CastSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.Me and skillId == 1001010 then
		self.NormalSkillFrame = self.RAP.RealFrame + 35
	end
end

--动画帧事件判断,打开res，shift+W召出动画工具，选中实体-动作配置武器显隐事件，勾选返回true，不勾选返回false
function Behavior1000:OnAnimEvent(instanceId,eventType,params)
	--左手武器显隐判断
	if instanceId == self.Me and eventType == FEAET.LeftWeaponVisible then
		if params.visible then
			if BF.HasBuffKind(self.Me,1000074) then
				BF.RemoveBuff(self.Me,1000074,5)
			end
		else
			if not BF.HasBuffKind(self.Me,1000074) then
				BF.AddBuff(self.Me,self.Me,1000074,1)
			end
		end
	end
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

function Behavior1000:FinishSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.Me and skillId == 1001081 then
		BF.SetCameraParams(FightEnum.CameraState.ForceLocking) --重置强锁定镜头参数
	end
end