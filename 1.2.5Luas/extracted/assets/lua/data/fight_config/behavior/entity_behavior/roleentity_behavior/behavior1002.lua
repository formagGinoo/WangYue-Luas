Behavior1002 = BaseClass("Behavior1002",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType

function Behavior1002.GetOtherAsset()
	local generates = {
		BehaviorFunctions.GetEffectPath("22058"),
		BehaviorFunctions.GetEffectPath("22059"),
		"Effect/UI/22060.prefab"
	}
	return generates
end


function Behavior1002:Init()
	--变量声明
	self.Me = self.instanceId		--记录自己

	--普攻技能Id
	self.NormalAttack = {1002001,1002002,1002003,1002004,1002005}
	self.NormalSkill = {1002010,1002011,1002012,1002013}	--普通技能Id
	self.MoveSkill = {1002030,1002031}	--闪避技能Id
	self.FallAttack = {1002170,1002171,1002172}	--下落攻击Id

	self.CoreSkill = {1002001}	--核心技能Id
	self.QTESkill = {1002060}	--QTE技能Id
	self.DodgeAttack = {1002071}	--闪避反击技能
	self.JumpAttack = {1002080,1002081}	--闪避反击技能
	self.UltimateSkill = {1002051,1002052}	--大招技能Id

	self.partnerAttack = {1002996,1002997} --仲魔技能id

	self.QTEtype = 1			--QTE类型：1切换角色放技能，2不切换角色下场放技能，3AI援助
	self.QTEPosRef = 1			--QTE出场坐标参考：1参考在场角色，2参考其他目标
	self.QTEChangeCD = 1		--QTE/切换角色冷却时间

	self.LockDistance = 20
	self.CancelLockDistance = 30

	--通用参数组合初始化、角色组合合集
	self.RoleAllParm = BehaviorFunctions.CreateBehavior("RoleAllParm",self)
	self.RoleAllBehavior = BehaviorFunctions.CreateBehavior("RoleAllBehavior",self)

	--组合缩写
	self.RAB = self.RoleAllBehavior
	self.RAP = self.RoleAllParm

	--角色自身参数
	self.AimNum = 0		--瞄准流程阶段序号
	self.AimMode = 0	--瞄准模式，1长按瞄准，2点按瞄准
	self.AimUpTime = 5		--抬手帧数
	self.AimUpFrame = 0		--抬手-当前帧数
	self.AimDownTime = 0	--暂无，放手帧数
	self.AimDownFrame = 0	--暂无，放手当前帧数
	self.AimShootTime = 12	--射击帧数
	self.AimShootFrame = 0	--射击-当前帧数
	self.AimShootCount = 0	--射击次数
	self.AimShootCameraSwitch = 0	--瞄准射击添加震屏开关
	self.AimCurrectCount = 0		--当前瞄准充能阶段
	self.AimingFrame = 0			--当前瞄准帧数
	self.AimCurrectChargeEffect = 0	--当前瞄准特效

	--瞄准实体Id
	self.AimCount = 1
	self.AimChargeEffect = {100216001,100216002} 	--蓄力+完成，充能次数+1个
	self.AimChargeTime = 45							--阶段蓄力总时间
	self.AimShootEffect = {100216003,100216004}
	self.AimShootMissile = {1002160001,1002160002}
	self.AimShootDelayTime = {2,2}
	self.AimShootDelayFrame = 0

	--音效临时处理
	self.C1Sound = 0
	self.SoundFrame = 0

	--临时参数
	self.MoveKey = 0
	self.CoreUiFrame = 0

	--仲魔临时参数
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

function Behavior1002:Update()

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

		--角色杂项判断(角色独立)
		self:Core()

		--通用角色参数开放
		self.RAP:SetEntityValuePart()

		--临时仲魔逻辑
		self:GetPartnerInfo()

	end
end

--角色个人判断
function Behavior1002:Core()

	--检查核心资源率
	self.RAP.CoreResRatio = BF.GetEntityAttrValueRatio(self.Me,1204)
	BF.AddEntitySign(self.Me,10020016,-1)

	--核心状态判断
	if BF.HasEntitySign(self.Me,10020000) then
		self.RAP.CoreUiFrame = self.RAP.RealFrame + 90
		if self.RAP.CoreResRatio == 0 then
			BF.RemoveEntitySign(self.Me,10020000)
			--if self.RAP.MyState == FES.Aim then
			--self:AimChangePart(true) --切换动作
			--end
		end
	end

	--核心UI动效判断 -- 核心资源充满
	if self.RAP.CtrlRole == self.Me and self.RAP.CoreResRatio == 10000 and not BF.HasEntitySign(self.Me,10020000) then
		BF.SetCoreEffectVisible(self.Me,"22092",true)
	else
		BF.SetCoreEffectVisible(self.Me,"22092",false)
	end
	--核心瞄准动效
	if self.RAP.CtrlRole == self.Me and BF.HasEntitySign(self.Me,10020000) and self.RAP.MyState == FES.Aim then
		BF.SetCoreEffectVisible(self.Me,"22093",true)
	else
		BF.SetCoreEffectVisible(self.Me,"22093",false)
	end
	--核心状态动效
	if self.RAP.CtrlRole == self.Me and BF.HasEntitySign(self.Me,10020000) then
		BF.SetCoreEffectVisible(self.Me,"22094",true)
	else
		BF.SetCoreEffectVisible(self.Me,"22094",false)
	end

	--角色在场逻辑
	if self.RAP.CtrlRole == self.Me then

		--核心UI显示判断
		if (BF.CheckPlayerInFight() or self.RAP.CoreUiFrame > self.RAP.RealFrame) then
			BF.SetCoreUIVisible(self.Me, true, 0.2)
		else
			BF.SetCoreUIVisible(self.Me, false, 0.5)
		end

		--核心按钮长按提示判断
		if ((self.RAP.CoreResRatio == 10000 and not BF.HasEntitySign(self.Me,10020000))
				or BF.HasEntitySign(self.Me,10020000)) and self.RAP.MyState ~= FES.Aim then
			BF.PlayFightUIEffect("20015","J")
		else
			BF.StopFightUIEffect("20015","J")
		end

		--强化攻击衔接判断
		if self.RAP.MyState == FES.Skill and BF.GetSkillSign(self.Me,10020013)
			and BF.HasEntitySign(self.Me,10020015) then
			BF.BreakSkill(self.Me)
			self.RAB.RoleCatchSkill:ActiveSkill(0,self.QTESkill[1],2,2,0,0,0,{0},"Immediately","ClearClick",true)
			--BF.CastSkillByTarget(self.Me,self.MainBehavior.FallAttack[2])
			--BF.ChangeEntityAttr(self.Me,1204,-90,1)
		end
		----核心攻击衔接判断
		--if self.RAP.MyState == FES.Skill and BF.GetSkillSign(self.Me,10020013)
		--and BF.HasEntitySign(self.Me,10020014) then
		--BF.BreakSkill(self.Me)
		--self.RAB.RoleCatchSkill:ActiveSkill(0,self.NormalSkill[4],2,2,0,0,0,{0},"Immediately","ClearClick",true)
		----BF.CastSkillByTarget(self.Me,self.MainBehavior.FallAttack[2])
		----BF.ChangeEntityAttr(self.Me,1204,-90,1)
		--end
		----强化攻击2衔接判断
		--if self.RAP.MyState == FES.Skill and BF.GetSkillSign(self.Me,10020013)
		--and BF.HasEntitySign(self.Me,10020016) then
		--BF.BreakSkill(self.Me)
		--self.RAB.RoleCatchSkill:ActiveSkill(0,self.DodgeAttack[1],2,2,0,0,0,{0},"Immediately","ClearClick",true)
		----BF.CastSkillByTarget(self.Me,self.MainBehavior.FallAttack[2])
		----BF.ChangeEntityAttr(self.Me,1204,-90,1)
		--end

		--强化、核心技能动效判断
		--if self.RAP.CoreResRatio == 10000 then
		--BF.SetSkillBehaviorConfig(self.Me, 1002010, "ReadyEffectPath", BehaviorFunctions.GetEffectPath(22060))
		if BF.HasEntitySign(self.Me,10020011) then
			BF.SetSkillBehaviorConfig(self.Me, 1002010, "ReadyEffectPath", BehaviorFunctions.GetEffectPath(22060))
		elseif not BF.HasEntitySign(self.Me,10020011) then
			BF.SetSkillBehaviorConfig(self.Me, 1002010, "ReadyEffectPath", BehaviorFunctions.GetEffectPath(22058))
		end

		----武器隐藏显示判断
		--if self.RAP.MyState == FES.Aim and BF.HasBuffKind(self.Me,1002901) then
		----BF.RemoveBuff(self.Me,1002901,5)
		--elseif self.RAP.MyState ~= FES.Aim and not BF.HasBuffKind(self.Me,1002901) then
		----BF.AddBuff(self.Me,self.Me,1002901,1) --隐藏瞄准武器
		--end

		--瞄准攻击流程
		self:AimStep()
	end
end

function Behavior1002:AimStep()

	--if BF.CheckKeyDown(FK.Dodge) and self.MoveKey == 0 then
	--BF.AddEntitySign(self.Me,10020000,-1) --瞄准实体标记
	--self.MoveKey = 1
	--elseif BF.CheckKeyDown(FK.Dodge) and self.MoveKey == 1 then
	--BF.RemoveEntitySign(self.Me,10020000) --瞄准实体标记
	--self.MoveKey = 0
	--end

	--BF.AddEntitySign(self.Me,10020000,-1) --瞄准实体标记

	--更新实体状态
	self.RAP.MyState = BF.GetEntityState(self.Me)
	--非瞄准状态判断
	if self.RAP.MyState ~= FES.Aim and self.AimNum ~= 0 then
		self:ClearAimInfo()
		--瞄准特效移除
		if BF.CheckEntity(self.AimCurrectChargeEffect) and self.AimCurrectChargeEffect ~= 0 then
			BF.RemoveEntity(self.AimCurrectChargeEffect)
			self.AimCurrectChargeEffect = 0
		end
	end

	--瞄准状态判断
	if self.RAP.MyState == FES.Aim then
		if BF.HasEntitySign(self.Me,10020000) then
			BF.SetAimLockTargetEnable(self.Me,true)
			BF.SetAimPartDecSpeed(self.Me, false)
		else
			BF.SetAimLockTargetEnable(self.Me,false)
			BF.SetAimPartDecSpeed(self.Me, true)
		end

		BF.SetMouseSensitivity(0.25,0.15,true) --设置瞄准滑动灵敏度,true代表移动端,false为PC端
		--核心UI显示时间刷新
		if self.RAP.CoreUiFrame > self.RAP.RealFrame then
			self.RAP.CoreUiFrame = self.RAP.RealFrame + 90
		end
		if BF.HasEntitySign(self.Me,10020000) then
			--伤害数字位置偏移
			BF.SetFontOffsetPos(2, -1.2, 0)
			BF.SetFontRangePos(2, -0.08, 0.02, -0.7, 0.15)
			BF.SwitchCoreUIType(self.Me,2)
			BF.SetCoreUIScale(self.Me, 0.85)
		end
		if not BF.HasEntitySign(self.Me,10020000) then
			BF.SwitchCoreUIType(self.Me,1)
			BF.SetCoreUIScale(self.Me, 0)
		end
	else
		BF.SetMouseSensitivity(0.35,0.25,true) --设置瞄准滑动灵敏度
		BF.SwitchCoreUIType(self.Me,1)
		BF.SetFontOffsetPos(2, 0, 0)
		BF.SetFontRangePos(2, -0.9, 0.9, 0.5, 1.2)
		BF.SetCoreUIScale(self.Me, 0.7)
	end

	--按钮/长按进入瞄准判断
	if BF.CheckEntityHeight(self.Me) == 0 and self.RAP.MyState ~= FES.Aim and self.RAP.MyState ~= FES.Jump and self.AimMode == 0
		and not (self.AimNum == 2 or self.AimNum == 3 and self.AimShootFrame >= self.RAP.RealFrame)
		and (BF.CanCastSkill(self.Me) or (BF.CheckEntityState(self.Me,FES.Skill) and self.RAP.CurrentSkillPriority < 2))
		and ((self.RAP.PressButton[1] == FK.Attack and self.RAP.PressButtonFrame[1] >= 15) 
			or self.RAP.ClickButton[1] == FK.AimMode) then

		--进入核心状态判断 - 核心持续时间
		if self.RAP.CoreResRatio == 10000 and not BF.HasEntitySign(self.Me,10020000) then
			BF.AddEntitySign(self.Me,10020000,12)
		end

		--瞄准切换部分
		self:AimChangePart()
		--BF.SetAnimatorLayerWeight(self.Me,1,nil,1,0.2) --设置动作层级权重，后三个参数：权重起始值、目标值、过度时间
		--BF.SetAnimatorLayerWeight(self.Me,2,nil,1,0.2)
		--尝试打断技能
		if self.RAP.MyState == FES.Skill then
			BF.BreakSkill(self.Me)
		end
		--判断瞄准模式，设置相关参数
		if self.RAP.PressButton[1] == FK.Attack and self.RAP.PressButtonFrame[1] >= 15 then
			self.AimMode = 1
			BF.SetEntityBineVisible(self.Me,"AimIK_R",false) --关闭右手瞄准IK
		elseif self.RAP.ClickButton[1] == FK.AimMode then
			self.AimMode = 2
			BF.SetEntityBineVisible(self.Me,"AimIK_R",true) --开启右手瞄准IK
			self.RAP.ClickButton[1] = 0
			self.RAP.ClickButtonFrame[1] = self.RAP.RealFrame
			BF.RemoveKeyPress(FK.AimMode)
		end

		--BF.SetAnimationTranslate(self.Me,"AimShoot","AimShoot",1) --设置瞄准射击动作
		--BF.SetAnimationTranslate(self.Me,"AimDown","AimDown",1) --设置瞄准放下动作
		BF.DoSetEntityState(self.Me,FES.Aim) --设置实体为瞄准状态
		BF.SetAimState(self.Me,FEAS.AimStart) --设置瞄准开始

		--判断目前镜头类型，设置瞄准状态、镜头切换时间
		if self.RAP.CameraType == 2 or self.RAP.CameraType == 3 then
			BF.SetCameraState(FE.CameraState.Aiming)
			if BF.CheckEntity(self.RAP.LockTarget) or BF.CheckEntity(self.RAP.AttackTarget) then
				BF.SetVCCameraBlend("**ANY CAMERA**","AimingCamera",0.3) --设置镜头过渡时间
				BF.SetVCCameraBlend("AimingCamera","**ANY CAMERA**",0.3)
			else
				BF.SetVCCameraBlend("**ANY CAMERA**","AimingCamera",0.3)
				BF.SetVCCameraBlend("AimingCamera","**ANY CAMERA**",0.3)
			end
			self.RAP.CameraType = 4
		elseif self.RAP.CameraType == 1 then
			BF.SetCameraState(FE.CameraState.Aiming)
			BF.SetVCCameraBlend("**ANY CAMERA**","AimingCamera",0.3)
			self.RAP.CameraType = 4
		end
		--开启瞄准UI总开关
		BF.SetAimUIVisble(true)
		--设置瞄准镜头参数、移动开关判断
		if self.AimMode ~= 0 then
			BF.CameraAimStart(self.Me,0.6,1.5,-0.3)
			BF.AimSetCanMove(self.Me,true)
			--BF.CameraAimStart(self.Me,0.5,1.5,0)
		end
		--设置辅助瞄准目标
		if BF.CheckEntity(self.RAP.LockTarget) then
			BF.SetAimCameraLockTarget(self.RAP.LockTarget)
		elseif BF.CheckEntity(self.RAP.AttackTarget) then
			BF.SetAimCameraLockTarget(self.RAP.AttackTarget)
		elseif BF.CheckEntity(self.RAP.AttackAltnTarget) then
			BF.SetAimCameraLockTarget(self.RAP.AttackAltnTarget)
		end
	end
	--BF.AddEntitySign(1,10000032,-1)

	--瞄准参数、资源设置
	if not BF.HasEntitySign(self.Me,10020000) and BF.HasEntitySign(1,10000032) then
		self.AimCount = 0
		self.AimChargeEffect = {100216001} --充能到完成特效
		self.AimChargeTime = 1	--阶段蓄力总时间
		self.AimShootEffect = {100216003,100216004}
		self.AimShootMissile = {1002160001,1002160002}
		self.AimShootDelayTime = {2,2}
		self.AimShootTime = 12	--射击帧数
		self.AimShootCount = 1	--射击次数
	elseif not BF.HasEntitySign(self.Me,10020000) then
		self.AimCount = 1
		self.AimChargeEffect = {100216001} --充能到完成特效
		self.AimChargeTime = 1	--阶段蓄力总时间
		self.AimShootEffect = {100216003,100216004}
		self.AimShootMissile = {1002160001,1002160002}
		self.AimShootDelayTime = {2,2}
		if self.AimMode == 1 then
			self.AimShootTime = 12	--射击帧数
		elseif self.AimMode == 2 then
			self.AimShootTime = 15	--射击帧数
		end
		self.AimShootCount = 1	--射击次数
	elseif BF.HasEntitySign(self.Me,10020000) then
		self.AimCount = 0
		self.AimChargeEffect = {100216001} --充能到完成特效
		self.AimChargeTime = 1	--阶段蓄力总时间
		self.AimShootEffect = {100216003,100216004}
		self.AimShootMissile = {1002160001,1002160002}
		self.AimShootDelayTime = {2,2}
		self.AimShootTime = {4,8}	--射击帧数
		self.AimShootCount = 2	--射击次数
	end

	--瞄准进入持续判断
	if self.AimMode ~= 0 and self.AimNum == 1 and self.AimUpFrame < self.RAP.RealFrame and BF.CheckEntityHeight(self.Me) == 0 then
		--瞄准切换部分
		self:AimChangePart()
		BF.SetAimState(self.Me,FEAS.Aiming)
	end
	--瞄准持续过程判断
	if self.AimMode ~= 0 and BF.CheckEntityHeight(self.Me) == 0 and not BF.HasEntitySign(self.Me,10020000)
		and ((self.AimNum == 2 and self.AimUpFrame < self.RAP.RealFrame)
			or (self.AimNum == 3 and self.AimShootFrame < self.RAP.RealFrame)) then

		----临时检查持续瞄准
		--if BF.CheckAimTarget(self.Me) then
		--BF.SetAimCameraLockTarget(BF.GetAimTargetInstanceId(self.Me))
		--end

		--瞄准切换部分
		self:AimChangePart()

		if not BF.HasEntitySign(self.Me,10020000) then
			if self.AimingFrame == 0 and self.AimCount ~= 0 then
				self.AimCurrectChargeEffect = BF.CreateEntity(self.AimChargeEffect[1],self.Me)
			end
			self.AimingFrame = self.AimingFrame + 1
			if self.AimCurrectCount < self.AimCount then
				if self.AimCount == 1 and self.AimingFrame == self.AimChargeTime * 30 then
					self.AimCurrectCount = self.AimCount
					--self.AimCurrectChargeEffect = BF.CreateEntity(self.AimChargeEffect[2],self.Me)
				elseif self.AimCount > 1 then
					for i = self.AimCount, 1, -1 do
						if self.AimingFrame == self.AimChargeTime[i] then
							self.AimCurrectCount = i
						end
					end
				end
			end
			BF.SetAimState(self.Me,FEAS.Aiming)
		elseif BF.HasEntitySign(self.Me,10020000) then
			BF.SetAimState(self.Me,FEAS.Aiming)
		end
	end

	----一般瞄准全局减速判断
	--local AimState = BF.GetAimState(self.Me)
	--if self.AimMode == 1 and (AimState == FEAS.AimStart or AimState == FEAS.Aiming) and not BF.HasBuffKind(self.Me,1002162)
	--and not BF.HasEntitySign(self.Me,10020000) then
	--BF.AddBuff(self.Me,self.Me,1002162,1)
	--elseif (self.AimMode ~= 1 or (self.AimMode == 1 and AimState ~= FEAS.AimStart and AimState ~= FEAS.Aiming)) and BF.HasBuffKind(self.Me,1002162)
	--and not BF.HasEntitySign(self.Me,10020000) then
	--BF.RemoveBuff(self.Me,1002162,1)
	--end
	----一般瞄准全局减速判断
	--local AimState = BF.GetAimState(self.Me)
	--if self.AimMode == 1 and (AimState == FEAS.AimStart or AimState == FEAS.Aiming or AimState == FEAS.AimShoot) and not BF.HasBuffKind(self.Me,1002162)
	--and BF.HasEntitySign(self.Me,10020000) then
	--BF.AddBuff(self.Me,self.Me,1002162,1)
	--elseif (self.AimMode ~= 1 or (self.AimMode == 1 and AimState ~= FEAS.AimStart and AimState ~= FEAS.Aiming and AimState ~= FEAS.AimShoot))
	--and BF.HasBuffKind(self.Me,1002162) and BF.HasEntitySign(self.Me,10020000) then
	--BF.RemoveBuff(self.Me,1002162,1)
	--end
	----核心瞄准全局减速判断
	--if self.AimMode == 2 and (AimState == FEAS.AimStart or AimState == FEAS.Aiming) and not BF.HasBuffKind(self.Me,1002044) then
	--BF.AddBuff(self.Me,self.Me,1002044,1)
	--elseif (self.AimMode ~= 2 or (self.AimMode == 2 and AimState ~= FEAS.AimStart and AimState ~= FEAS.Aiming)) and BF.HasBuffKind(self.Me,1002044) then
	--BF.RemoveBuff(self.Me,1002044,1)
	--end

	--长按瞄准射击判断
	if self.AimMode == 1 and BF.CheckEntityHeight(self.Me) == 0
		and ((not BF.HasEntitySign(self.Me,10020000) and self.AimNum == 2 and (self.RAP.PressButton[1] ~= FK.Attack
					or (self.RAP.PressButton[1] == FK.Attack and self.RAP.PressButtonFrame[1] < 3)))
			or (BF.HasEntitySign(self.Me,10020000) and (self.AimNum == 2 or (self.AimNum == 3 and self.AimShootFrame < self.RAP.RealFrame))
				and self.RAP.PressButton[1] == FK.Attack and self.RAP.PressButtonFrame[1] > 3 )) then

		--瞄准切换部分
		self:AimChangePart()

		BF.SetAimState(self.Me,FEAS.AimShoot) --射击
		if not BF.HasEntitySign(self.Me,10020000) and not BF.HasEntitySign(self.Me,600060) then
			BF.CreateEntity(self.AimShootEffect[self.AimCurrectCount+1],self.Me) --喷焰特效
			BF.CreateAimEntity(self.AimShootMissile[self.AimCurrectCount+1],self.Me) --子弹
		end
		self.RAP.ClickButton[1] = 0
		self.RAP.ClickButtonFrame[1] = self.RAP.RealFrame
		if BF.CheckEntity(self.AimCurrectChargeEffect) then
			BF.RemoveEntity(self.AimCurrectChargeEffect)
			self.AimCurrectChargeEffect = 0
		end
	end

	--点按瞄准射击判断
	if self.AimMode == 2 and BF.CheckEntityHeight(self.Me) == 0 and not BF.HasEntitySign(self.Me,10020000)
		and self.AimNum == 2 and self.RAP.PressButton[1] == FK.Attack then

		--瞄准切换部分
		self:AimChangePart()

		BF.SetAimState(self.Me,FEAS.AimShoot) --射击
		if not BF.HasEntitySign(self.Me,10020000) and not BF.HasEntitySign(self.Me,600060) then
			BF.CreateEntity(self.AimShootEffect[self.AimCurrectCount+1],self.Me) --喷焰特效
			BF.CreateAimEntity(self.AimShootMissile[self.AimCurrectCount+1],self.Me) --子弹
		end
		self.RAP.ClickButton[1] = 0
		self.RAP.ClickButtonFrame[1] = self.RAP.RealFrame
		if BF.CheckEntity(self.AimCurrectChargeEffect) then
			BF.RemoveEntity(self.AimCurrectChargeEffect)
			self.AimCurrectChargeEffect = 0
		end
	end
	
	--核心瞄准射击后衔接判断
	if self.RAP.MyState == FES.Aim and BF.HasEntitySign(self.Me,10020000) and BF.CheckEntityHeight(self.Me) == 0
		and (self.RAP.PressButton[1] ~= FK.Attack or (self.RAP.PressButton[1] == FK.Attack and self.RAP.PressButtonFrame[1] < 3)) then

		--瞄准切换部分
		self:AimChangePart()

		self.AimingFrame = 0
		--关闭瞄准UI总开关
		BF.SetAimUIVisble(false)

		--瞄准退出判断
		if self.AimMode == 1 and self.AimShootFrame - 4 < self.RAP.RealFrame then

			self:AimChangePart(true)
		end
	end
	--BehaviorFunctions.AddEntitySign(1,10000027,-1)
	--瞄准射击后衔接判断
	if self.RAP.MyState == FES.Aim and self.AimNum == 3 and not BF.HasEntitySign(self.Me,10020000) and BF.CheckEntityHeight(self.Me) == 0 then
		if BF.GetPlayingAnimationName(self.Me,1) == "Attack042" then
			self.AimNum = 2
			--瞄准切换部分
			self:AimChangePart()
		else
			self.AimingFrame = 0
			if self.AimMode == 1 then
				--关闭瞄准UI总开关
				BF.SetAimUIVisble(false)
			end
			--射击震屏判断
			if self.AimShootFrame - 12 < self.RAP.RealFrame then
				if self.AimCurrectCount == 0 and self.AimShootCameraSwitch == 0 then
					BF.AddBuff(self.Me,self.Me,1002163,1)
					self.AimShootCameraSwitch = 1
				end
				if self.AimCurrectCount == 1 and self.AimShootCameraSwitch == 0 then
					BF.AddBuff(self.Me,self.Me,1002164,1)
					self.AimShootCameraSwitch = 1
				end
				self.AimCurrectCount = 0
			end
			--瞄准退出判断
			if self.AimMode == 1 and self.AimShootFrame - 4 < self.RAP.RealFrame then
				BF.SetAnimatorLayerWeight(self.Me,1,nil,0,0)
				BF.SetAnimatorLayerWeight(self.Me,2,nil,0,0)
				BF.CameraAimEnd(self.Me) --退出瞄准镜头
				BF.SetCameraState(FE.CameraState.Operating) --设置操作镜头
				self.RAP.CameraType = 1
				BF.SetAimState(self.Me,FEAS.AimEnd)
				BF.AimStateEnd(self.Me) --退出瞄准模式
				self.AimMode = 0
				--移除当前瞄准特效
				if BF.CheckEntity(self.AimCurrectChargeEffect) then
					BF.RemoveEntity(self.AimCurrectChargeEffect)
					self.AimCurrectChargeEffect = 0
				end
				--elseif self.AimMode == 2 and self.AimShootFrame - 4 < self.RAP.RealFrame then
			end
		end
	end
	
	--点按退出瞄准判断
	if self.AimMode == 2 and BF.CheckEntityHeight(self.Me) == 0 and not BF.HasEntitySign(self.Me,10020000)
		and (self.AimNum == 2 or (self.AimNum == 3 and self.AimShootFrame < self.RAP.RealFrame)) and self.RAP.ClickButton[1] == FK.AimMode then

		BF.RemoveKeyPress(FK.AimMode)
		--瞄准切换部分
		self:AimChangePart()
		self.RAP.ClickButton[1] = 0
		self.RAP.ClickButtonFrame[1] = self.RAP.RealFrame
		self.AimingFrame = 0
		--关闭瞄准UI总开关
		BF.SetAimUIVisble(false)
		BF.SetAnimatorLayerWeight(self.Me,1,nil,0,0)
		BF.SetAnimatorLayerWeight(self.Me,2,nil,0,0)
		BF.CameraAimEnd(self.Me) --退出瞄准镜头
		BF.SetCameraState(FE.CameraState.Operating) --设置操作镜头
		self.RAP.CameraType = 1
		BF.SetAimState(self.Me,FEAS.AimEnd)
		BF.AimStateEnd(self.Me) --退出瞄准模式
		self.AimMode = 0
		--移除当前瞄准特效
		if BF.CheckEntity(self.AimCurrectChargeEffect) then
			BF.RemoveEntity(self.AimCurrectChargeEffect)
			self.AimCurrectChargeEffect = 0
		end
		--elseif self.AimMode == 2 and self.AimShootFrame - 4 < self.RAP.RealFrame then	
	end
end

--瞄准阶段判断
function Behavior1002:AimSwitchState(instanceId,State)
	if instanceId == self.Me then
		if State == FEAS.AimStart then
			self.AimNum = 1
			self.AimUpFrame = self.RAP.RealFrame + self.AimUpTime
			self.AimShootCameraSwitch = 0
		end
		if State == FEAS.Aiming then
			self.AimNum = 2
		end
		if State == FEAS.AimShoot then
			self.AimNum = 3
			if self.AimShootCount == 1 then
				self.AimShootFrame = self.RAP.RealFrame + self.AimShootTime
				--self.AimShootDelayFrame = self.AimShootDelayTime[self.AimCurrectCount+1] + self.RAP.RealFrame
			elseif self.AimShootCount == 2 then
				self.AimShootFrame = self.RAP.RealFrame + self.AimShootTime[2]
			end
		end
		if State == FEAS.AimDown then
		end
	end
end

--重写角色释放技能组合
function Behavior1002:RoleCatchSkill()
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
			if self.RAP.MyState == FES.Aim then
				self:ClearAimInfo()
				BF.ClearAllInput()
				BF.RemoveKeyPress(FK.Attack)
			end
			if BF.DoJump(self.Me) then
				self.RAB.RoleCatchSkill:ClearButtonPart(ClickButton,"ClearClick")
			end
			--大招释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.UltimateSkill and BF.CheckEntityHeight(self.Me) == 0 then
			if self.RAP.MyState == FES.Aim then
				self:ClearAimInfo()
			end
			if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.UltimateSkill[1],5,3,0,0,0,{0},"Immediately","ClearClick",true) then
				--BF.CastSkillCost(self.Me,self.UltimateSkill[1])
			end
			--闪避释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.Dodge and BF.CheckEntityHeight(self.Me) == 0 then
			if self.RAP.MyState == FES.Aim then
				self:ClearAimInfo()
			end
			if self.RAB.RoleCatchSkill:MoveSkill(ClickButton,3,3,0,0,0,{21},"ClearClick") then
				--BF.CastSkillCost(self.Me,self.MoveSkill[1])
			end
			----核心技能释放判断
			--elseif self.RAP.ClickButton[ClickButton] == FK.Partner and BF.CheckEntityHeight(self.Me) == 0 and self.RAP.CoreResRatio == 10000 then
			--if self.RAP.MyState == FES.Aim then
			--self:ClearAimInfo()
			--end
			--if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.CoreSkill[1],2,2,0,0,0,{0},"Immediately","ClearClick",true) then
			--BF.CastSkillCost(self.Me,self.CoreSkill[1])
			--end
			--普通技能释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.NormalSkill and BF.CheckEntityHeight(self.Me) == 0 then
			if self.RAP.MyState == FES.Aim then
				self:ClearAimInfo()
			end
			if BF.GetSkillCostValue(self.Me,FK.NormalSkill) >= 2 and BF.HasEntitySign(self.Me,10020011) then
				if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalSkill[2],2,2,0,0,0,{0},"Immediately","ClearClick",true,1.2) then
					BF.CastSkillCost(self.Me,self.NormalSkill[1])
					BF.RemoveEntitySign(self.Me,10020011)
					--BF.AddEntitySign(self.Me,10020010,2)
					BF.ChangeEntityAttr(self.Me,1204,80,1)
					BF.AddEntitySign(self.Me,10020015,0.8,true)

				end
			elseif BF.GetSkillCostValue(self.Me,FK.NormalSkill) >= 2 and not BF.HasEntitySign(self.Me,10020011) then
				if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalSkill[1],2,2,0,0,0,{0},"Immediately","ClearClick",true,1.2) then
					BF.CastSkillCost(self.Me,self.NormalSkill[1])
					BF.AddEntitySign(self.Me,10020010,2)
				end
			end
			--普攻长按释放判断
		elseif self.RAP.PressButton[PressButton] == FK.Attack and self.RAP.PressButtonFrame[PressButton] >= 7 and self.RAP.MyState ~= FES.Aim
			and BF.CheckEntityHeight(self.Me) >= 1.5 then
			self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.FallAttack[1],170,170,0,0,0,{0},"0","ClearPress",true)
			--普攻点按释放判断(地面)
		elseif self.RAP.ClickButton[ClickButton] == FK.Attack and BF.CheckEntityHeight(self.Me) == 0 and not BF.CheckKeyPress(FK.Attack) then
			--一般技能后释放判断
			if BF.HasEntitySign(self.Me,10020010) then
				if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalAttack[3],1,1,0,0,0,{0},"Immediately","ClearClick",true) then
					BF.RemoveEntitySign(self.Me,10020010)
				end
				----闪避反击释放判断
				--if BF.HasEntitySign(self.Me,10000000) then
				--if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.DodgeAttack[1],2,2,0,0,0,{0},"Immediately","ClearClick",true) then
				--BF.RemoveEntitySign(self.Me,10000000)
				--end
			else
				self.RAB.RoleCatchSkill:ContSkill(ClickButton,self.NormalAttack,1,1,10000002,0,0,{0},"Immediately","ClearAll",true,1.2)
			end
			--释放仲魔临时逻辑
		elseif self.RAP.ClickButton[ClickButton] == FK.Partner and self.partner then

			self:DoPartnerSkill()
		end
	end
end

--受击前判断
function Behavior1002:BeforeHit(attackInstanceId,hitInstanceId,hitType)

	self.RAP.MyState = BF.GetEntityState(self.Me)
	if self.RAP.MyState == FES.Aim and hitInstanceId == self.Me then
		self:ClearAimInfo()
		BF.DoSetEntityState(self.Me,FES.Idle) --设置待机状态，等切为受击状态
	end
end

--通用清除瞄准信息
function Behavior1002:ClearAimInfo()
	self.AimMode = 0			--瞄准模式
	self.AimCurrectCount = 0	--当前瞄准阶段
	self.AimingFrame = 0		--当前瞄准帧数
	self.AimShootCameraSwitch = 0 --瞄准射击添加震屏开关
	BF.CameraAimEnd(self.Me)	--退出瞄准状态镜头
	BF.SetCameraState(FE.CameraState.Operating)	--设置操作镜头
	self.RAP.CameraType = 1		--记录镜头类型
	BF.SetAimState(self.Me,FEAS.AimEnd)	--设置瞄准类型
	self.AimNum = 0				--瞄准阶段
	--移除当前瞄准特效
	if BF.CheckEntity(self.AimCurrectChargeEffect) then
		BF.RemoveEntity(self.AimCurrectChargeEffect)
		self.AimCurrectChargeEffect = 0
	end
	BF.SetAimUIVisble(false)
	BF.AimStateEnd(self.Me)	--退出任意瞄准状态
end

--首次命中判断
function Behavior1002:FirstCollide(attackInstanceId,hitInstanceId,InstanceId)
	local I = BF.GetEntityTemplateId(InstanceId)
	if attackInstanceId == self.Me then
		--普攻子弹--总2
		if I == 1002001001 then
			BF.AddSkillPoint(self.Me,1201,0.2)	--总0.2格
		end
		if I == 1002002001 or I == 1002002002 then
			BF.AddSkillPoint(self.Me,1201,0.15)	--总0.3格
		end
		if I == 1002003001 or I == 1002003002 or I == 1002003003 or I == 1002003004 then
			BF.AddSkillPoint(self.Me,1201,0.125)--总0.5格
		end
		if I == 1002004001 or I == 1002004002 then
			BF.AddSkillPoint(self.Me,1201,0.15)--总0.3格
		end
		if I == 1002005002 then
			BF.AddSkillPoint(self.Me,1201,0.7)--总0.7格
			local p = BF.GetSkillCostValue(self.Me,FK.NormalSkill)
			if p >= 2 then
				if BF.HasEntitySign(self.Me,10020011) then
					BF.RemoveEntitySign(self.Me,10020011)
					BF.StopSkillUIEffect("Effect/UI/22060.prefab","I")
					if BF.CheckBtnUseSkill(self.Me,FK.NormalSkill) then
						BF.PlaySkillUIEffect("Effect/UI/22060.prefab","I")
					end
				end
				BF.AddEntitySign(self.Me,10020011,2)	--技能强化实体标记
			end
		end
		--弹反子弹强制打断敌人技能
		if BF.CheckEntity(hitInstanceId) and I == 1002081001 then
			BF.BreakSkill(hitInstanceId)
		end
		--临时跳反踩踏子弹强制打断敌人技能
		if BF.CheckEntity(hitInstanceId) and I == 1001080001 then
			BF.BreakSkill(hitInstanceId)
		end
	end
end

--技能释放判断
function Behavior1002:CastSkill(instanceId,skillId,skillType)

	--主动释放判断
	if instanceId == self.Me and (skillId == 1002010 or skillId == 1002011 or 1002060) then
		self.CanyingPosDis = 0
		self.CanyingPosRot = 0
	end
	--QTE释放判断
	if instanceId == self.Me and skillId == 1002060 then
		self.CurrentSkillPriority = 2
		--BF.ChangeEntityAttr(self.Me,1204,90,1)	--总90
		BF.ChangeEntityAttr(self.Me,1005,2,1)	--总25
	end
	--核心释放判断
	if instanceId == self.Me and skillId == 1002040 then
		self.CurrentSkillPriority = 2
		--BF.ChangeEntityAttr(self.Me,1204,-90,1)
		BF.ChangeEntityAttr(self.Me,1005,20,1)  --总20
	end
	--闪避反击判断
	if instanceId == self.Me and skillId == 1002081 then
		BF.SetCameraParams(FightEnum.CameraState.ForceLocking) --重置强锁定镜头参数
		BF.ChangeEntityAttr(self.Me,1204,80,1) --核心资源
	end
end

--通用闪避成功判断
function Behavior1002:Dodge(attackInstanceId,hitInstanceId,limit)
	if hitInstanceId == self.Me then
		local p = BF.GetSkillCostValue(self.Me,FK.NormalSkill)
		if p >= 2 then
			if BF.HasEntitySign(self.Me,10020011) then
				BF.RemoveEntitySign(self.Me,10020011)
				BF.StopSkillUIEffect("Effect/UI/22060.prefab","I")
				if BF.CheckBtnUseSkill(self.Me,FK.NormalSkill) then
					BF.PlaySkillUIEffect("Effect/UI/22060.prefab","I")
				end
			end
			BF.AddEntitySign(self.Me,10020011,2)	--技能强化实体标记
		end
		--BF.AddSkillPoint(self.Me,1201,1)	--增加1格能量
	end
end

function Behavior1002:AddSkillSign(instanceId,sign)
	if instanceId == self.Me and sign == 1001998 then
		--BF.CastSkillByTarget(instanceId,1001999,targetInstanceId)
		self.RAB.RoleCatchSkill:ActiveSkill(0,1002999,5,3,0,0,0,{0},"Immediately","ClearClick",true)
		BehaviorFunctions.RemoveSkillEventActiveSign(self.Me,1001999)
	end
end

function Behavior1002:OnAnimEvent(instanceId,eventType,params,animationName)
	--左手武器显隐判断，BUFF隐藏双手
	if instanceId == self.Me and eventType == FEAET.LeftWeaponVisible then
		if params.visible then
			if BF.HasBuffKind(self.Me,1002900) then
				BF.RemoveBuff(self.Me,1002900,5)
			end
		else
			if not BF.HasBuffKind(self.Me,1002900) then
				BF.AddBuff(self.Me,self.Me,1002900,1)
			end
		end
	end
	if instanceId == self.Me and eventType == FEAET.AimShoot and animationName == "Attack042" then
		if params.Hand == 0 then --左手
			BF.CreateEntity(100204201,self.Me) --喷焰特效
			BF.CreateAimEntity(1002042001,self.Me,"AimShootL") --子弹
		else
			BF.CreateEntity(100204202,self.Me) --喷焰特效
			BF.CreateAimEntity(1002042002,self.Me,"AimShootR") --子弹
		end
		--射击震屏判断
		BF.AddBuff(self.Me,self.Me,1002045,1)
		BF.ChangeEntityAttr(self.Me,1204,-5,1)
		--BF.DoEntityAudioPlay(self.Me,"KekeR31M11_Atk042",true)
	end
end

--命中时判断
function Behavior1002:Collide(attackInstanceId,hitInstanceId,InstanceId)
	self.C1Sound = BehaviorFunctions.GetEntity(InstanceId)
	if self.C1Sound.entityId == 1002015002 and self.SoundFrame < self.RAP.RealFrame then
		--BehaviorFunctions.DoEntityAudioPlay(attackInstanceId,"kekeC1",false)
		self.SoundFrame = self.RAP.RealFrame + 30
	end
end

--伤害前判断
function Behavior1002:BeforeDamage(InstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal,attackType,partType,damageInfo,attackInstanceId)
	local I = BF.GetEntityTemplateId(InstanceId)
	if (I == 1002042001 or I ==1002042002) and attackInstanceId == self.Me and partType == 1 then
		damageInfo.damage = damageInfo.damage * 1.2
	end
end

--技能释放判断
function Behavior1002:CastSkill(instanceId,skillId,skillType)
	if instanceId == self.Me and (((skillType ~= 30 and skillType ~= 31) and not BF.CheckPlayerInFight()) or BF.CheckPlayerInFight()) then
		self.RAP.CoreUiFrame = self.RAP.RealFrame + 90
		--BF.ChangeEntityAttr(self.Me,1206,-250,1)
		--self.ChangeLockTargetFrame = 0 --闪避重置切换锁定目标间隔时间
	end
end

--属性变化判断
function Behavior1002:ChangeAttrValue(attrType,attrValue)
	if attrType == 1204 then
		self.RAP.CoreUiFrame = self.RAP.RealFrame + 90
	end
end

--瞄准切换部分判断
function Behavior1002:AimChangePart(AnimChange)

	if AnimChange == true then
		local n1 = BF.GetPlayingAnimationName(self.Me,1)
		local n2 = BF.GetPlayingAnimationName(self.Me,2)

		self.AimMode = 0
		self.AimCurrectCount = 0	--当前瞄准阶段
		self.AimingFrame = 0		--当前瞄准帧数
		self.AimShootCameraSwitch = 0 --瞄准射击添加震屏开关
		--if n1 == "Attack042" or n1 == "Attack041" then
		--if n1 == "Attack042" then
		local a = 0
		if BF.CheckAimTarget(self.Me) then
			BF.CameraAimEnd(self.Me,0.3) --退出瞄准镜头
			a = 1
		else
			BF.CameraAimEnd(self.Me) --退出瞄准镜头
		end
		BF.SetCameraState(FE.CameraState.Operating)	--设置操作镜头
		self.RAP.CameraType = 1		--记录镜头类型
		BF.SetAimState(self.Me,FEAS.AimEnd)	--设置瞄准类型
		self.AimNum = 0				--瞄准阶段
		BF.SetAimUIVisble(false)
		BF.AimStateEnd(self.Me)	--退出任意瞄准状态

		if a == 1 then
			BF.SetAnimatorLayerWeight(self.Me,1,nil,0,0)
			BF.SetAnimatorLayerWeight(self.Me,2,nil,0,0)
			self.RAB.RoleCatchSkill:ActiveSkill(0,self.CoreSkill[1],2,2,0,0,0,{0},"Immediately","ClearClick",true)
			BF.RemoveKeyPress(FK.Attack)
		end
	end
	--瞄准参数、资源设置
	if not BF.HasEntitySign(self.Me,10020000) and AnimChange ~= true then
		self.AimUpTime = 5	--抬手帧数
		BF.SetAnimationTranslate(self.Me,"AimUp","AimUp",1)		--设置瞄准抬手动作
		BF.SetAnimationTranslate(self.Me,"Aiming","Aiming",1)		--设置瞄准持续动作
		BF.SetAnimationTranslate(self.Me,"AimShoot","AimShoot",1)	--设置瞄准射击动作
		BF.SetAnimationTranslate(self.Me,"AimDown","AimDown",1)		--设置瞄准放下动作

		BF.SetAnimationTranslate(self.Me,"AimIdle","AimIdle",2)		--设置瞄准下身待机动作
		BF.SetAnimationTranslate(self.Me,"AimWalk","AimWalk",2)		--设置瞄准下身前走动作
		BF.SetAnimationTranslate(self.Me,"AimWalkBack","AimWalkBack",2)--设置瞄准下身后走动作
		BF.SetAnimationTranslate(self.Me,"AimWalkLeft","AimWalkLeft",2)	--设置瞄准下身左走动作
		BF.SetAnimationTranslate(self.Me,"AimWalkRight","AimWalkRight",2)--设置瞄准下身右走动作
		--if AnimChange == true then
		--local n1 = BF.GetPlayingAnimationName(self.Me,1)
		--local n2 = BF.GetPlayingAnimationName(self.Me,2)
		--if n1 == "Attack040" then
		--BF.PlayAnimation(self.Me,"AimUp",1)
		--elseif n1 == "Attack041" then
		--BF.PlayAnimation(self.Me,"Aiming",1)
		--elseif n1 == "Attack042" then
		--BF.PlayAnimation(self.Me,"AimShoot",1)
		--elseif n1 == "Attack043" then
		--BF.PlayAnimation(self.Me,"AimDown",1)
		--end

		--if n2 == "Attack044" then
		--BF.PlayAnimation(self.Me,"AimIdle",2)
		--elseif n2 == "Attack045" then
		--BF.PlayAnimation(self.Me,"AimWalk",2)
		--elseif n2 == "Attack046" then
		--BF.PlayAnimation(self.Me,"AimWalkBack",2)
		--elseif n2 == "Attack047" then
		--BF.PlayAnimation(self.Me,"AimWalkLeft",2)
		--elseif n2 == "Attack048" then
		--BF.PlayAnimation(self.Me,"AimWalkRight",2)
		--end
		--end
		if not BF.HasBuffKind(self.Me,1002165) then
			BF.AddBuff(self.Me,self.Me,1002165,1) --右手IK隐藏BUFF
		end
	elseif BF.HasEntitySign(self.Me,10020000) and AnimChange ~= true then
		self.AimUpTime = 5	--抬手帧数
		BF.SetAnimationTranslate(self.Me,"AimUp","Attack040",1)	--设置瞄准抬手动作
		BF.SetAnimationTranslate(self.Me,"Aiming","Attack041",1)	--设置瞄准持续动作
		BF.SetAnimationTranslate(self.Me,"AimShoot","Attack042",1)	--设置瞄准射击动作
		BF.SetAnimationTranslate(self.Me,"AimDown","Attack043",1)	--设置瞄准放下动作

		BF.SetAnimationTranslate(self.Me,"AimIdle","Attack044",2)		--设置瞄准下身待机动作
		BF.SetAnimationTranslate(self.Me,"AimWalk","Attack045",2)		--设置瞄准下身前走动作
		BF.SetAnimationTranslate(self.Me,"AimWalkBack","Attack046",2)--设置瞄准下身后走动作
		BF.SetAnimationTranslate(self.Me,"AimWalkLeft","Attack047",2)	--设置瞄准下身左走动作
		BF.SetAnimationTranslate(self.Me,"AimWalkRight","Attack048",2)--设置瞄准下身右走动作
		if BF.HasBuffKind(self.Me,1002165) then
			BF.RemoveBuff(self.Me,1002165,1) --右手IK隐藏BUFF
		end
	end
end

--实体标记移除时判断
function Behavior1002:RemoveEntitySign(instanceId,sign)
	if instanceId == self.Me and sign == 10020000 then
		self:AimChangePart(true)
	end
end

--获取仲魔信息
function Behavior1002:GetPartnerInfo()


	self.partnerPos = BehaviorFunctions.GetPositionOffsetBySelf(self.Me,2,280)	--战中技能释放位置
	self.partnerPos2 = BehaviorFunctions.GetPositionOffsetBySelf(self.Me,0,0)	--战前技能释放位置
	self.partner = BehaviorFunctions.GetPartnerInstanceId(self.Me)				--获取仲魔id



	--穿上时获取仲魔相关信息，卸下时重置
	if self.partner then
		self.partnerId = BehaviorFunctions.GetEntityTemplateId(self.partner)
		self.worldSkill = BehaviorFunctions.GetEntityValue(self.partner,"worldSkill")	--战前技能id
		self.fightSkill = BehaviorFunctions.GetEntityValue(self.partner,"fightSkill")	--战中技能id
	else
		self.partnerId = 0
		self.worldSkill = 0
		self.fightSkill = 0
	end


	--潜行类型仲魔获取钻地状态
	if self.partnerId == 610025 then
		self.hideState = BehaviorFunctions.GetEntityValue(self.partner,"hideState")
	end
end



--临时仲魔技能逻辑
function Behavior1002:DoPartnerSkill()
	if BehaviorFunctions.CheckPlayerInFight() then
		if self.partnerId == 62001 or self.partnerId == 610040 or self.partnerId == 600060 then
			if BF.CheckEntityHeight(self.Me) == 0 then
				if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.partnerAttack[1],2,2,0,0,0,{0},"Immediately","ClearClick",true) then

				end
			end
		else
			if self.hideState == 0 then
				if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.partnerAttack[2],2,2,0,0,0,{0},"Immediately","ClearClick",true) then
				end
			end
		end
	else
		if self.partnerId == 610040 or self.partnerId == 600060 then
			if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.partnerAttack[1],2,2,0,0,0,{0},"Immediately","ClearClick",true) then
			end

			--暗杀
		elseif self.partnerId == 62001 then
			--地面暗杀
			if BF.CheckEntityHeight(self.Me) == 0 then
				if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.partnerAttack[2],2,2,0,0,0,{0},"Immediately","ClearClick",true) then
				end

			end
			--钻地
		elseif self.partnerId == 610025 and self.hideState == 0 and BF.CheckEntityHeight(self.Me) == 0 then
			--if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.partnerAttack[2],2,2,0,0,0,{0},"Immediately","ClearClick",true) then
			if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.partnerAttack[2],2,2,0,0,0,{0},"Immediately","ClearClick",true) then

			end
			--BehaviorFunctions.CastSkillCost(self.partner,self.worldSkill)
			--end
		end
	end
end


