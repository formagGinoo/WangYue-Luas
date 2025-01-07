Behavior1008 = BaseClass("Behavior1008",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior1008.GetGenerates()
	local generates = {}
	return generates
end
function Behavior1008.GetOtherAsset()
	
	local generates = {}
	return generates
end

function Behavior1008:Init()
	--变量声明
	self.Me = self.instanceId	--记录自己

	--普攻技能Id
	self.NormalAttack = {1008001,1008002,1008003,1008004,1008005}
	self.NormalSkill = {1008010}  --普通技能Id
	self.MoveSkill = {1008030,1008031,1008032}	--闪避技能Id
	self.FallAttack = {1008170,1008171,1008172}	--下落攻击Id
	--self.AirAttack = {1008101,1008102,1008103}	--空中攻击Id
	self.PartnerConnect = {1008001}	--佩从连携技能id
	self.PartnerCall = {1008061,1008062,1008063,1008064} --佩从召唤动作
	self.PartnerHenshin = {1008060} --佩从变身动作集合
	--self.LeapAttack = {1008160}	--起跳攻击Id
	self.CoreSkill = {1008040,1008041,1008042}	--核心技能Id
	self.QTESkill = {1008001}	--QTE技能Id
	--self.DodgeAttack = {1008070}	--闪避反击技能
	self.JumpAttack = {1008080,1008081,1008082}	--跳跃反击技能
	self.UltimateSkill = {1008050,1008001}	--大招技能Id
	self.CatchSkill = {1008090}	--捕捉技能
	
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

	self.RAP.backgroundRes1 = 6.1 --每多少秒回复1点日相
	
	self.NormalSkillFrame = 0	--强化技能释放帧数
	self.CoreNum = {0,0,0}
	self.CoreNumFrame = {0,0,0}
	self.CanyingFrame = 0
	
	self.WindArea = 0
	
	--扇子相关参数
	self.Umbrella = {
		[1] = 0,
		[2]	= 0,
	}
	self.AtkTarget = 0 --扇子攻击目标
	self.AtkMode = 0 --扇子总运动模式
	self.FanAtkMode = {0,0}--具体扇子模式
	self.FanAtkTarget = {0,0} --扇子目标
	self.FanEffect = {0,0} --扇子特效
	self.FanMissile = {0,0} --扇子子弹
	
	--*************************张永钢
	--角色语音类型变量
	self.RAP.VoiceAudio_Climb = {"Play_v_yixiang_0033"}
	self.RAP.VoiceAudio_Run = {"Play_v_yixiang_0035"}
	self.RAP.VoiceAudio_WallRun = {"Play_v_yixiang_0037"}
	self.RAP.VoiceAudio_Gliding = {"Play_v_yixiang_0039"}
	self.RAP.VoiceAudio_Looting = {"Play_v_yixiang_0041"}
	self.RAP.VoiceAudio_Stand1 = {"Play_v_yixiang_0043"}
	self.RAP.VoiceAudio_NormalATK = {"Play_v_yixiang_0045"}
	
	self.VoiceAudio_NormalSkill = {"Play_v_yixiang_0048"}
	
	self.RAP.VoiceAudio_QTESkill = {"Play_v_yixiang_0051"}
	self.RAP.VoiceAudio_CoreSkill = {"Play_v_yixiang_0054"}
	self.RAP.VoiceAudio_JumpATK = {"Play_v_yixiang_0057"}
	self.RAP.VoiceAudio_PartnerATK = {"Play_v_yixiang_0059"}
	self.RAP.VoiceAudio_Hit = {"Play_v_yixiang_0062"}
	self.RAP.VoiceAudio_LowHP = {"Play_v_yixiang_0065"}
	self.RAP.VoiceAudio_Dead = {"Play_v_yixiang_0068"}
	--*************************张永钢
	
end

function Behavior1008:LateInit()
	self.RAP:LateInit()
end

function Behavior1008:BeforeUpdate()
	--通用参数组合更新
	self.RAP:BeforeUpdate()
end

function Behavior1008:Update()

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
		
		--扇子判断
		self:FanUpDate()--扇子总行为判断
		self:Fan(1)--扇子运行判断
		self:Fan(2)
		
		--角色相机逻辑外接
		self.RAB.RoleCameraParm:Update()
	end
end

--角色个人判断
function Behavior1008:Core()

	--检查核心资源率
	self.RAP.CoreResRatio = BF.GetEntityAttrValueRatio(self.Me,1204)
	self.RAP.CoreRes = BF.GetEntityAttrVal(self.Me,1204)
	
	----核心UI动效判断 -- 核心资源充满
	--if self.RAP.CtrlRole == self.Me and self.RAP.CoreRes >= 3 then
		--BF.SetCoreEffectVisible(self.Me,"22098",true)
	--else
		--BF.SetCoreEffectVisible(self.Me,"22098",false)
	--end
	
	--BF.AddEntitySign(self.Me,10081006,-1)
	--PERK被五行绝技击飞的怪物会进入缓慢下落状态，持续A秒，期间受到的木属性伤害增加B%。
	if BF.HasEntitySign(self.Me,10081006) then
		BF.AddSkillEventActiveSign(self.Me,100810062)
		BF.RemoveSkillEventActiveSign(self.Me,100810061)
	else
		BF.AddSkillEventActiveSign(self.Me,100810061)
		BF.RemoveSkillEventActiveSign(self.Me,100810062)
	end

	--PERK释放风场后，体力值恢复A点，全队角色滑翔速度增加B%，持续C秒。
	if BF.HasEntitySign(self.Me,10081001) and BF.GetSkillSign(self.Me,1008032) then
		BF.AddBuff(self.Me,1,10081001) --给场景怪加滑翔速度增加，场景怪代表player
		BF.ChangePlayerAttr(1642,BF.GetMagicValue(self.Me,10081007,1,1))--体力值恢复
	end
	
	--PERK木属性伤害提升A%。普攻可以造成木属性伤害。
	if BF.HasEntitySign(self.Me,10081002) and not BF.HasBuffKind(self.Me,10081002) then
		BF.AddBuff(self.Me,self.Me,10081002)
	end
	
	--PERK风场范围扩大a%，风场可以对周围敌人造成攻击力b%的持续伤害。
	if BF.HasEntitySign(self.Me,10081003) then
		BF.AddSkillEventActiveSign(self.Me,100803202)
		BF.RemoveSkillEventActiveSign(self.Me,100803201)
	else
		BF.AddSkillEventActiveSign(self.Me,100803201)
		BF.RemoveSkillEventActiveSign(self.Me,100803202)
	end
	
	--后台判断逻辑
	if not BF.CheckEntityForeground(self.Me) and not BF.HasBuffKind(self.Me,1008042) then
		if self.RAP.CoreResRatio < 7000 then
			BF.ChangeEntityAttr(self.Me,1204,0.56)
		end
	end
	
	--角色在场逻辑
	if self.RAP.CtrlRole == self.Me then
		--BF.AddEntitySign(self.Me,10081005,-1)

		--核心状态判断
		if BF.HasBuffKind(self.Me,1008042) then
			self.RAP.CoreUiFrame = self.RAP.RealFrame + 45
			BF.SwitchCoreUIType(self.Me,2)
			--核心重复收扇子/衔接/重复扔扇子动作回调
			if self.RAP.MyState == FES.Skill and self.RAP.CurrentSkill == 1008042 and BF.GetSkillSign(self.Me,10080420) then
				BF.BreakSkill(self.Me)
				BF.CastSkillBySelfPosition(self.Me,self.CoreSkill[2])
				self.RAP.CurrentSkillPriority = 2
			end	
		else
			BF.SwitchCoreUIType(self.Me,1)
		end
		
		--核心状态收扇子加核心值技能窗口
		if BF.GetSkillSign(self.Me,10080042) and BF.HasBuffKind(self.Me,1008042) then
			BF.ChangeEntityAttr(self.Me,1204,120,1)
			BF.RemoveEntitySign(self.Me,10080001) --移除核心值为0替换扇子子弹特效标记
		end

		--核心UI显示判断
		if (BF.CheckPlayerInFight() or self.RAP.CoreUiFrame > self.RAP.RealFrame) then
			BF.SetCoreUIVisible(self.Me, true, 0.2)
		else
			BF.SetCoreUIVisible(self.Me, false, 0.5)
		end
		
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
function Behavior1008:RoleCatchSkill()
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
					and BF.GetSkillConfigSign(self.Me) ~= 170 and BF.GetSkillConfigSign(self.Me) ~= 171))then
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
				--BF.DoEntityAudioPlay(self.Me,"Play_v_yixiang_0051",true,FightEnum.SoundSignType.Language)	--播放角色QTE语音
			end
		--闪避长按判断
		elseif self.RAP.PressButton[PressButton] == FK.Dodge and BF.GetSkillSign(self.Me,10080031) and BF.CheckEntityHeight(self.Me) == 0 then
			BF.BreakSkill(self.Me)
			self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.MoveSkill[3],2,2,0,0,0,{0},"Immediately","ClearPress",true)
		--闪避释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.Dodge and BF.CheckEntityHeight(self.Me) == 0 then
			if self.RAB.RoleCatchSkill:MoveSkill(ClickButton,3,3,0,0,0,{21},"ClearClick") then
				BF.CastSkillCost(self.Me,self.MoveSkill[1],"ClearClick")
			end
		--普通技能释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.NormalSkill and BF.CheckEntityHeight(self.Me) == 0 then
			--if BF.GetSkillCostValue(self.Me,FK.NormalSkill) >= 1 then
				if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalSkill[1],2,2,0,0,0,{0},"Immediately","ClearClick",true) then
					BF.CastSkillCost(self.Me,self.NormalSkill[1])
				
				----*************************张永钢
				--if BF.GetEntitySignSound(self.Me,FightEnum.SoundSignType.Language) == nil then
					--BF.DoEntityAudioPlay(self.Me,self.VoiceAudio_NormalSkill[1],true,FightEnum.SoundSignType.Language)	--播放角色普通技能语音
				--end
				----*************************张永钢
				
				end
				--self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalSkill[1],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1)
				--self.RAB.RoleCatchSkill:ContSkill(ClickButton,self.NormalSkill,2,2,10000002,0,0,{0},"Immediately","ClearClick",true)
			--end
		--普攻长按释放判断(空中)
		elseif self.RAP.PressButton[PressButton] == FK.Attack and self.RAP.PressButtonFrame[PressButton] >= 7
			and BF.CheckEntityHeight(self.Me) >= 1 then
			self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.FallAttack[1],170,170,0,0,0,{0},"0","ClearPress",true,0,-1)	
		--普攻长按释放判断(地面)
		elseif self.RAP.PressButton[PressButton] == FK.Attack and self.RAP.PressButtonFrame[PressButton] >= 9
			and BF.CheckEntityHeight(self.Me) == 0 and BF.GetEntityAttrValueRatio(self.Me,1204) == 10000 and not BF.HasBuffKind(self.Me,1008042) then
			if self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.CoreSkill[1],2,2,0,0,0,{0},"Immediately","ClearPress",true,0,-1) then
				BF.AddBuff(self.Me,self.Me,1008042) --施加核心状态Buff
				--BF.AddEntitySign(self.Me,10080001,999999)
				----*************************张永钢
				--BF.DoEntityAudioPlay(self.Me,self.RAP.VoiceAudio_CoreSkill[1],true,FightEnum.SoundSignType.Language)	--播放角色核心技能语音
				----*************************张永钢
			end
		--普攻点按释放判断(地面)
		elseif self.RAP.ClickButton[ClickButton] == FK.Attack and BF.CheckEntityHeight(self.Me) == 0 then
			--闪避反击释放判断
			if BF.HasEntitySign(self.Me,10000000) then
				if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.DodgeAttack[1],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
					BF.RemoveEntitySign(self.Me,10000000)
				end
			--核心状态重复接扇子，任意扇子存在都接
			--elseif BF.HasBuffKind(self.Me,1008042) and BF.HasEntitySign(self.Me,10080001) then
			elseif BF.HasBuffKind(self.Me,1008042) and (BF.CheckEntity(self.Umbrella[1]) or BF.CheckEntity(self.Umbrella[2]))then
				if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.CoreSkill[3],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
					--BF.RemoveEntitySign(self.Me,10080001)
				end
			--核心状态重复扔扇子，没扇子存在则扔
			elseif BF.HasBuffKind(self.Me,1008042) and not BF.CheckEntity(self.Umbrella[1]) and not BF.CheckEntity(self.Umbrella[2]) then
				if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.CoreSkill[2],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
					BF.AddEntitySign(self.Me,10080001,999999)
				end
			else
				self.RAP.FrontDistance = 5
				self.RAP.MyFrontPos = BF.GetPositionOffsetBySelf(self.Me,self.RAP.FrontDistance,0)
				self.RAB.RoleCatchSkill:ContSkill(ClickButton,self.NormalAttack,1,1,10000002,0,0,{0},"Immediately","ClearClick",true,1.5,-1)
				self.RAP.FrontDistance = 10
				self.RAP.MyFrontPos = BF.GetPositionOffsetBySelf(self.Me,self.RAP.FrontDistance,0)
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

--首次命中判断
function Behavior1008:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	local I = BF.GetEntityTemplateId(instanceId)
	if attackInstanceId == self.Me and not BF.HasBuffKind(self.Me,1008042) then
		--普攻子弹
		if I == 1008001001 then
			BF.AddSkillPoint(self.Me,1201,0.0825,FE.SkillPointSource.NormalAttack)
		end
		if I == 1008002001 or I == 1008002002 then
			BF.AddSkillPoint(self.Me,1201,0.0516,FE.SkillPointSource.NormalAttack)
		end
		if I == 1008003001 then
			BF.AddSkillPoint(self.Me,1201,0.0309,FE.SkillPointSource.NormalAttack)
			BF.ChangeEntityAttr(self.Me,1204,6)
		end
		if I == 1008003002 then
			BF.AddSkillPoint(self.Me,1201,0.0928,FE.SkillPointSource.NormalAttack)
		end
		if I == 1008004001 then
		end
		if I == 1008004002 then
			BF.AddSkillPoint(self.Me,1201,0.0413,FE.SkillPointSource.NormalAttack)
			BF.ChangeEntityAttr(self.Me,1204,6)
		end
		if I == 1008005001 or I == 1008005002 then
			BF.AddSkillPoint(self.Me,1201,0.0619,FE.SkillPointSource.NormalAttack)
		end
		if I == 1008005003 then
			BF.AddSkillPoint(self.Me,1201,0.0289,FE.SkillPointSource.NormalAttack)
			BF.ChangeEntityAttr(self.Me,1204,6)
		end
		if I == 1008010004 then
			BF.ChangeEntityAttr(self.Me,1204,7.2)
		end
		if I == 1008010003 then
			BF.ChangeEntityAttr(self.Me,1204,19.2)
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
	
	--扇子命中资源变化
	if attackInstanceId == self.Umbrella[1] or attackInstanceId == self.Umbrella[2] then
		if (I == 1008041001 or I == 1008041002) and self.RAP.CoreRes > 0 then
			BF.ChangeEntityAttr(self.Me,1204,-20)
		end
	end
end

--命中判断
function Behavior1008:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType)
	local I = BF.GetEntityTemplateId(instanceId)
	if attackInstanceId == self.Me then
		if I == 1008041001 or I == 1008041002 then
			BF.ChangeEntityAttr(self.Me,1204,-30)--总10
		end
	end
end

--技能释放判断
function Behavior1008:CastSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.Me and (((skillSign ~= 30 and skillSign ~= 31) and not BF.CheckPlayerInFight()) or BF.CheckPlayerInFight()) then
		self.RAP.CoreUiFrame = self.RAP.RealFrame + 90
		--BF.ChangeEntityAttr(self.Me,1206,-250,1)
		--self.ChangeLockTargetFrame = 0 --闪避重置切换锁定目标间隔时间
	end
	
end

--移除Buff判断
function Behavior1008:RemoveBuff(entityInstanceId, buffInstanceId,buffId)
	if entityInstanceId == self.Me and buffId == 1008042 then
		BF.ChangeEntityAttr(self.Me,1204,-300)
		BF.RemoveEntitySign(self.Me,10080001) --移除扔武器标记
	end
end

--属性变化判断
function Behavior1008:ChangeAttrValue(attrType,attrValue,changedValue)
	if attrType == 1204 then
		self.RAP.CoreUiFrame = self.RAP.RealFrame + 90
	end
end

--通用闪避成功判断
function Behavior1008:Dodge(attackInstanceId,hitInstanceId,limit)
	if hitInstanceId == self.Me then
		--闪避产生大招残影攻击
		if BF.HasBuffKind(self.Me,1008054) then
			BF.AddDelayCallByFrame(4, self, function() self:Canying(attackInstanceId) end)
			BF.AddDelayCallByFrame(11, self, function() self:Canying(attackInstanceId) end)
		end
	end
end

--动画帧事件判断
function Behavior1008:OnAnimEvent(instanceId,eventType,params)
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
end

--跳跃反击着地回调
function Behavior1008:OnLand(instanceId)
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
function Behavior1008:FinishSkill(instanceId,skillId,skillSign,skillType)
	--if instanceId == self.Me and skillId == 1001081 then
		--BF.SetCameraParams(FightEnum.CameraState.ForceLocking) --重置强锁定镜头参数
	--end
end

--帧事件创建实体判断
function Behavior1008:KeyFrameAddEntity(instanceId,entityId)
	if entityId == 1008032001 then
		if BF.CheckEntity(self.WindArea) then
			BF.RemoveEntity(self.WindArea)
			self.WindArea = 0
		end
		self.WindArea = instanceId
	end
end

--获取计算公式参数前
function Behavior1008:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)

	--PERK木属性伤害提升A%。普攻可以造成木属性伤害。
	if BF.HasEntitySign(self.Me,10081002) and ownerInstanceId == self.Me then
		if BF.AnalyseSkillType(BF.GetDamageParam(FE.DamageInfo.SkillType),FE.SkillType.NormalAttack) then
			BF.ChangeDamageParam(FE.DamageInfo.DmgElement,FE.ElementType.Wood) --修改为木属性
		end
	end
	
	--PERK「大招 - 技能名」伤害倍率提升a%。
	if BF.HasEntitySign(self.Me,10081004) and ownerInstanceId == self.Me then
		if BF.AnalyseSkillType(BF.GetDamageParam(FE.DamageInfo.SkillType),FE.SkillType.Unique) then
			BF.ChangeDamageParam(FE.DamageParam.SkillPercent,BF.GetMagicValue(self.Me,10081004,1,1))
		end
	end
end


--扇子扔收判断
function Behavior1008:Fan(Index)
	
	local ThrowFrameSign = {}
	local LeftRight = 0
	local Pos1 = {}
	local Bullet = 0
	local Effect = 0
	local SelfRot = {}
	local EntityRot = {}
	local MoveRot = {}
	local GetFanRot = {}
	local GetFanCtrlPos = {}
	local PartName = ""
	local RoundRadius = 0
	
	if Index == 1 then	--扇子编号
		ThrowFrameSign = {100804001,100804101}	--技能窗口
		LeftRight = FEAET.LeftWeaponVisible		--左手右手
		Bullet = 1008041002		--子弹Id
		Effect = 100804301		--扇子特效Id
		if BF.GetSkillSign(self.Me,ThrowFrameSign[1]) then
			Pos1 = {0.25,1.5,0.5}		--扇子创建位置偏差*3
			EntityRot = {-30,30,-45}	--外层朝向修正*3
		elseif BF.GetSkillSign(self.Me,ThrowFrameSign[2]) then
			Pos1 = {0.25,1.5,0.5}
			EntityRot = {-15,60,70}
		end
		SelfRot = {0,-30,0,0,0,0}	--内层旋转速度*3、朝向修正*3
		MoveRot = {30,60}			--扇子外层线速度、角速度
		GetFanRot = {5,-5,0,60}	--收扇子帧数、朝向修正*3
		GetFanCtrlPos = {0.5,0.3}	--收扇子坐标偏差
		PartName = "weapon_001"		--收扇子部位名
		RoundRadius = 3				--追踪角色环绕半径
	elseif Index == 2 then
		ThrowFrameSign = {100804002,100804102}
		LeftRight = FEAET.RightWeaponVisible
		Bullet = 1008041001
		Effect = 100804302
		if BF.GetSkillSign(self.Me,ThrowFrameSign[1]) then
			Pos1 = {-0.25,1.5,0.5}
			EntityRot = {-30,-45,45}
		elseif BF.GetSkillSign(self.Me,ThrowFrameSign[2]) then
			Pos1 = {-0.25,1.5,0.5}
			EntityRot = {-15,-60,70}
		end
		SelfRot = {0,-30,0,0,0,0}
		MoveRot = {30,60}
		GetFanRot = {11,15,35,70}
		GetFanCtrlPos = {0.5,0.3}
		PartName = "weapon_000"
		RoundRadius = 2
	end

	--核心扔扇子
	-----------------------------------------------
	if (BF.GetSkillSign(self.Me,ThrowFrameSign[1]) or BF.GetSkillSign(self.Me,ThrowFrameSign[2])) and self.Umbrella[Index] == 0 then

		--隐藏武器
		self:OnAnimEvent(self.Me,LeftRight,{visible = false})
		--记录自身位置、创建位置、创建扇子实体
		local P = BF.GetPositionP(self.Me)
		local P1 = BF.GetEntityPositionOffset(self.Me,Pos1[1],Pos1[2],Pos1[3])
		self.Umbrella[Index] = BF.CreateEntity(100801,self.Me,P1.x,P1.y,P1.z)
		BF.SetEntityAttackLevel(self.Umbrella[Index], BF.GetEntitySkillLevel(self.Me,1008040))
		
		--创建子弹、特效，挂载至扇子
		self.FanMissile[Index] = BF.CreateEntity(Bullet,self.Umbrella[Index])
		self.FanEffect[Index] = BF.CreateEntity(Effect,self.Umbrella[Index])
		BF.BindTransform(self.FanMissile[Index], "weapon", {x = 0, y = 0, z = 0}, self.Umbrella[Index])
		BF.BindTransform(self.FanEffect[Index], "weapon", {x = 0, y = 0, z = 0}, self.Umbrella[Index])

		--扇子自转速度 - 模型层扇子角度修正
		BF.SetEntitySelfRotateThrow(self.Umbrella[Index],SelfRot[1],SelfRot[2],SelfRot[3],SelfRot[4],SelfRot[5],SelfRot[6]) 
		--扇子、子弹、特效逻辑层初始朝向(-45,45,0)
		BF.CopyEntityRotate(self.Me, self.Umbrella[Index],EntityRot[1],EntityRot[2],EntityRot[3])
		BF.CopyEntityRotate(self.Umbrella[Index], self.FanMissile[Index],0,0,0)
		BF.CopyEntityRotate(self.Umbrella[Index], self.FanEffect[Index],0,0,0)
		--扇子设置线速度和角速度
		BF.SetEntityMoveTrackThrowSpeed(self.Umbrella[Index],MoveRot[1],MoveRot[2])

		--扇子目标判断
		if BF.CheckEntity(self.AtkTarget) then
			
		else
			self:FanTarget()
		end

		--目标存在
		if (self.AtkMode == 1 or self.AtkMode == 3) and BF.CheckEntity(self.AtkTarget) then
			BF.SetEntityMoveTrackThrow(self.Umbrella[Index],BF.fight.entityManager:GetEntity(self.AtkTarget),0.8,function()
					--local x = BF.RandomSelect(-10,-5,0,5)
					--local y = BF.Random(-10,-5,0,5,10)
					--local z = BF.RandomSelect(-30,-20,-10,10,20,30)
					
					if BF.CheckEntity(self.Umbrella[Index]) then
						--BF.CopyEntityRotate(self.Umbrella[Index], self.Umbrella[Index],0,0,0) --命中时角度调整
						--PERK▲核心状态下，扇子的速度增加a%
						if BF.HasEntitySign(self.Me,10081005) then
							local r = BF.RandomSelect(1008041002) --曲线
							BF.SetEntityMoveTrackThrowSpeed(self.Umbrella[Index],nil,nil,1008041001,r) --到达终点后设置速度和角速度曲线
						else
							local r = BF.RandomSelect(1008040002,1008040003) --曲线
							BF.SetEntityMoveTrackThrowSpeed(self.Umbrella[Index],nil,nil,1008040001,r) --到达终点后设置速度和角速度曲线
						end
					end
			end,true,0.2,15)
			self.FanAtkMode[Index] = 1
			self.FanAtkTarget[Index] = self.AtkTarget
		--目标不存在，地点投掷
		elseif self.AtkMode == 2 then
			BF.SetEntityMoveRoundThrow(self.Umbrella[Index],BF.fight.entityManager:GetEntity(self.Me),RoundRadius,20,Quat.Euler(0,0,0))
			self.FanAtkMode[Index] = 2
			self.FanAtkTarget[Index] = 0
		end
	end
	
	--收武器判断
	if BF.GetSkillSign(self.Me,100804200) and self.Umbrella[Index] ~= 0 then
		--曲线控制点在右前一点
		local ctrlPos = {ZRate = GetFanCtrlPos[1],XRate = GetFanCtrlPos[2]}
		local selfEntity = BF.fight.entityManager:GetEntity(self.Me)
		--一定帧数内把扇子模型矫正
		BF.SetEntitySelfRotateTargetThrow(self.Umbrella[Index],GetFanRot[1],GetFanRot[2],GetFanRot[3],GetFanRot[4])

		--从扇子当前位置向P点做曲线运动，一定帧数内做完
		BF.SetEntityMoveCurveThrow(self.Umbrella[Index],nil,ctrlPos,{Entity = selfEntity, PartName = PartName },nil,GetFanRot[1],function()
			if BF.CheckEntity(self.Umbrella[Index]) then
				BF.RemoveEntity(self.Umbrella[Index]) --到达目标后，销毁扇子
				self.Umbrella[Index] = 0 --清空扇子
			end
			self:OnAnimEvent(self.Me,LeftRight,{visible = true}) --显示武器	
		end)
	end
	
	--扇子攻击模式判断
	if self.AtkMode == 1 and self.Umbrella[Index] ~= 0 then
		if self.FanAtkMode[Index] ~= 1 then
			self.FanAtkMode[Index] = 1
			BF.SetEntityMoveTrackThrow(self.Umbrella[Index],BF.fight.entityManager:GetEntity(self.AtkTarget),0.8,function()
					--local x = BF.RandomSelect(-10,-5,0,5)
					--local y = BF.Random(-10,-5,0,5,10)
					--local z = BF.RandomSelect(-30,-20,-10,10,20,30)
					--BF.CopyEntityRotate(self.Umbrella[Index], self.Umbrella[Index],0,0,0) --命中时角度调整
					--PERK▲核心状态下，扇子的速度增加a%
					if BF.HasEntitySign(self.Me,10081005) then
						local r = BF.RandomSelect(1008041002) --曲线
						BF.SetEntityMoveTrackThrowSpeed(self.Umbrella[Index],nil,nil,1008041001,r) --到达终点后设置速度和角速度曲线
					else
						local r = BF.RandomSelect(1008040002,1008040003) --曲线
						BF.SetEntityMoveTrackThrowSpeed(self.Umbrella[Index],nil,nil,1008040001,r) --到达终点后设置速度和角速度曲线
					end
					--end)
				end,true,0.2,15)
			self.FanAtkTarget[Index] = self.AtkTarget
		end
		--换目标判断
		local t = self.FanAtkTarget[Index]
		if self.FanAtkMode[Index] == 1 and (t ~= self.FanAtkTarget[Index])then
			BF.SetEntityMoveTrackThrow(self.Umbrella[Index],BF.fight.entityManager:GetEntity(self.AtkTarget),0.8,function()
					--local x = BF.RandomSelect(-10,-5,0,5)
					--local y = BF.Random(-10,-5,0,5,10)
					--local z = BF.RandomSelect(-30,-20,-10,10,20,30)
					--BF.CopyEntityRotate(self.Umbrella[Index], self.Umbrella[Index],0,0,0) --命中时角度调整
					--PERK▲核心状态下，扇子的速度增加a%
					if BF.HasEntitySign(self.Me,10081005) then
						local r = BF.RandomSelect(1008041002) --曲线
						BF.SetEntityMoveTrackThrowSpeed(self.Umbrella[Index],nil,nil,1008041001,r) --到达终点后设置速度和角速度曲线
					else
						local r = BF.RandomSelect(1008040002,1008040003) --曲线
						BF.SetEntityMoveTrackThrowSpeed(self.Umbrella[Index],nil,nil,1008040001,r) --到达终点后设置速度和角速度曲线
					end
					--end)
				end,true,0.2,15)
			self.FanAtkTarget[Index] = self.AtkTarget
		end
	end

	--扇子追随模式判断
	if self.AtkMode == 2 and self.Umbrella[Index] ~= 0 then
		if self.FanAtkMode[Index] ~= 2 then
			BF.SetEntityMoveRoundThrow(self.Umbrella[Index],BF.fight.entityManager:GetEntity(self.Me),RoundRadius,20,Quat.Euler(0,0,0))
			BF.SetEntityMoveTrackThrowSpeed(self.Umbrella[Index],20,20) --扇子设置线速度和角速度
			self.FanAtkMode[Index] = 2
		end
	end	
end

--角色切换下场判断
function Behavior1008:ChangeBackground(instanceId)
	if instanceId == self.Me and BF.HasBuffKind(self.Me,1008042) then
		for i = 1, 2 do
			if BF.CheckEntity(self.Umbrella[i]) then
				local P = BF.GetPositionP(self.Umbrella[i])
				local c = BF.CreateEntity(100804306,self.Me,P.x,P.y,P.z)
				BF.RemoveEntity(self.Umbrella[i]) --到达目标后，销毁扇子
			end
			self.Umbrella[i] = 0 --清空扇子
			self.FanAtkMode[i] = 0
			self.FanAtkTarget[i] = 0
		end
		--self.AtkMode = 0
		BF.RemoveEntitySign(self.Me,10080001)
		BF.ChangeEntityAttr(self.Me,1204,240) --核心状态切换下场增加满核心
	end
end

--角色死亡判断
function Behavior1008:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId == self.Me and BF.HasBuffKind(self.Me,1008042) then
		for i = 1, 2 do
			if BF.CheckEntity(self.Umbrella[i]) then
				local P = BF.GetPositionP(self.Umbrella[i])
				local c = BF.CreateEntity(100804306,self.Me,P.x,P.y,P.z)
				BF.RemoveEntity(self.Umbrella[i]) --到达目标后，销毁扇子
			end
			self.Umbrella[i] = 0 --清空扇子
			self.FanAtkMode[i] = 0
			self.FanAtkTarget[i] = 0
		end
		self.AtkMode = 0
		BF.RemoveEntitySign(self.Me,10080001)
		BF.ChangeEntityAttr(self.Me,1204,-240) --核心状态死亡移除所有核心资源
	end
end


--扇子每帧判断
function Behavior1008:FanUpDate()
	
	if BF.HasBuffKind(self.Me,1008042) then
		
		--收武器判断
		if BF.GetSkillSign(self.Me,100804200) then
			self.AtkMode = 3
		elseif self.AtkMode == 3 and self.RAP.CurrentSkill ~= 1008042 then
			self.AtkMode = 0
		end
		
		--扇子风能/一般特效、子弹判断
		if self.RAP.CoreRes == 0 and not BF.HasEntitySign(self.Me,10080001) then
			BF.AddEntitySign(self.Me,10080001,999999)
			if BF.CheckEntity(self.Umbrella[1]) then
				if BF.CheckEntity(self.FanEffect[1]) then
					BF.RemoveEntity(self.FanEffect[1])
					self.FanEffect[1] = BF.CreateEntity(100804303,self.Umbrella[1])
					BF.BindTransform(self.FanEffect[1], "weapon", {x = 0, y = 0, z = 0}, self.Umbrella[1])
					BF.CopyEntityRotate(self.Umbrella[1], self.FanEffect[1])
				end
				if BF.CheckEntity(self.FanMissile[1]) then
					BF.RemoveEntity(self.FanMissile[1])
					self.FanMissile[1] = BF.CreateEntity(1008041003,self.Umbrella[1])
					BF.BindTransform(self.FanMissile[1], "weapon", {x = 0, y = 0, z = 0}, self.Umbrella[1])
					BF.CopyEntityRotate(self.Umbrella[1], self.FanMissile[1])
				end
			end
			if BF.CheckEntity(self.Umbrella[2]) then
				if BF.CheckEntity(self.FanEffect[2]) then
					BF.RemoveEntity(self.FanEffect[2])
					self.FanEffect[2] = BF.CreateEntity(100804304,self.Umbrella[2])
					BF.BindTransform(self.FanEffect[2], "weapon", {x = 0, y = 0, z = 0}, self.Umbrella[2])
					BF.CopyEntityRotate(self.Umbrella[2], self.FanEffect[2])
				end
				if BF.CheckEntity(self.FanMissile[2]) then
					BF.RemoveEntity(self.FanMissile[2])
					self.FanMissile[2] = BF.CreateEntity(1008041004,self.Umbrella[2])
					BF.BindTransform(self.FanMissile[2], "weapon", {x = 0, y = 0, z = 0}, self.Umbrella[2])
					BF.CopyEntityRotate(self.Umbrella[2], self.FanMissile[2])
				end
			end
		end
		
		--攻击模式判断
		if self.AtkMode ~= 3 then
			--攻击目标死亡
			if self.AtkMode == 1 and not BF.CheckEntity(self.AtkTarget) then
				self.AtkTarget = 0
				self.AtkMode = 2
				self.FanAtkTarget[1] = 0
				self.FanAtkTarget[2] = 0
			end
			
			--攻击目标获取判断
			if self:FanTarget() == true then
				self.AtkMode = 1
			else
				self.AtkMode = 2
			end
			--距离过远重置扇子目标
			if self.AtkMode == 1 and BF.CheckEntity(self.AtkTarget) and BF.GetDistanceFromTarget(self.Me,self.AtkTarget,true) > self.LockDistance then
				self.AtkTarget = 0
				self.AtkMode = 2
			end
		end
	elseif not BF.HasBuffKind(self.Me,1008042) then
		for i = 1, 2 do
			if BF.CheckEntity(self.Umbrella[i]) then
				local P = BF.GetPositionP(self.Umbrella[i])
				local c = BF.CreateEntity(100804306,self.Me,P.x,P.y,P.z)
				BF.RemoveEntity(self.Umbrella[i]) --到达目标后，销毁扇子
			end
			self.Umbrella[i] = 0 --清空扇子
			self.FanAtkMode[i] = 0
			self.FanAtkTarget[i] = 0
		end
		self.AtkMode = 0
		BF.RemoveEntitySign(self.Me,10080001)
	end
end


--扇子目标判断
function Behavior1008:FanTarget()
	
	if BF.CheckEntity(self.RAP.LockTarget) and BF.GetDistanceFromTarget(self.Me,self.RAP.LockTarget,true) <= self.LockDistance then
		self.AtkTarget = self.RAP.LockTarget
	elseif BF.CheckEntity(self.RAP.AttackTarget) and BF.GetDistanceFromTarget(self.Me,self.RAP.AttackTarget,true) <= self.LockDistance then
		self.AtkTarget = self.RAP.AttackTarget
	elseif BF.CheckEntity(self.RAP.AttackAltnTarget) and BF.GetDistanceFromTarget(self.Me,self.RAP.AttackAltnTarget,true) <= self.LockDistance then
		self.AtkTarget = self.RAP.AttackAltnTarget
	else
		self.AtkTarget = 0
	end
	if self.AtkTarget ~= 0 then
		return true
	else
		return false
	end
end


--脉象相关
function Behavior1008:AddEntitySign(instanceId,sign)
	if instanceId == self.Me then
		if sign == 10081001 then
			BF.DoMagic(self.Me,self.Me,10081007)	--perk1参数
		end

		if sign == 10081004 then
			BF.DoMagic(self.Me,self.Me,10081004)	--perk3参数
		end
	end
end