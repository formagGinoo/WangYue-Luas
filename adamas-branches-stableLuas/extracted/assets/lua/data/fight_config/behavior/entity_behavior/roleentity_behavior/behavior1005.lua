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
		"UIEffect/Prefab/UI_SkillPanel_changan.prefab",
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
	self.PartnerConnect = {1005999}	--佩从连携技能id
	self.PartnerCall = {1005061,1005062,1005063,1005064} --佩从召唤动作
	self.PartnerHenshin = {1005060} --佩从变身动作集合
	--self.LeapAttack = {1005160}	--起跳攻击Id
	self.CoreSkill = {1005040}	--核心技能Id
	self.QTESkill = {1005110}	--QTE技能Id
	--self.DodgeAttack = {1005070}	--闪避反击技能
	self.JumpAttack = {1005080,1005081,1005082}	--闪避反击技能
	self.UltimateSkill = {1005050,1005051}	--大招技能Id
	self.CatchSkill = {1005090}	--捕捉技能
	
	self.QTEtype = 5			--QTE类型：1切换角色放技能，2不切换角色下场放技能，3AI援助
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
	
	self.PERK4Frame = 0
	
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
	
	--QTE参数重写
	self.RAP.QTEDistance  = 4		--连携QTE距离
	self.RAP.QTEAngle = 135			--连携QTE角度
	self.RAP.QTECd = 5				--QTE冷却
	
end

function Behavior1005:LateInit()
	self.RAP:LateInit()
end

function Behavior1005:BeforeUpdate()
	--通用参数组合更新
	self.RAP:BeforeUpdate()
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

		
		--角色通用佩从判断
		self.RAB.RolePartnerBase:Update()

		--角色相机逻辑外接
		self.RAB.RoleCameraParm:Update()
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
	
	--核心技能打断移除技能帧事件标记
	self.RAP.CurrentSkill = BF.GetSkill(self.Me)
	if self.RAP.CurrentSkill ~= 1005040 then
		BF.RemoveSkillEventActiveSign(self.Me,100504000)
		BF.RemoveSkillEventActiveSign(self.Me,100504001)
		BF.RemoveSkillEventActiveSign(self.Me,100504002)
		BF.RemoveSkillEventActiveSign(self.Me,100504003)
	end
	
	--BF.AddEntitySign(self.Me,10051001,-1)
	
	----核心UI动效判断 -- 核心资源充满
	--if self.RAP.CtrlRole == self.Me and self.RAP.CoreRes >= 3 then
		--BF.SetCoreEffectVisible(self.Me,"22098",true)
	--else
		--BF.SetCoreEffectVisible(self.Me,"22098",false)
	--end
	
	--PERK乾坤状态下义向获得a%土属性伤害加成。
	if BF.HasEntitySign(self.Me,10051002) and (BF.HasBuffKind(self.Me,1005054) or BF.HasBuffKind(self.Me,1005058)) 
		and not BF.HasBuffKind(self.Me,10051002) then
		BF.AddBuff(self.Me,self.Me,10051002,1)
	elseif not BF.HasBuffKind(self.Me,1005054) and not BF.HasBuffKind(self.Me,1005058) and BF.HasBuffKind(self.Me,10051002) then
		BF.RemoveBuff(self.Me,10051002)
	end
	
	--PERK乾坤状态下，义向的五行击破效率提升a%，大招持续时间+4秒。
	--BF.AddEntitySign(self.Me,10051006,-1)
	if BF.HasEntitySign(self.Me,10051006) then
		if (BF.HasBuffKind(self.Me,1005054) or BF.HasBuffKind(self.Me,1005058)) and not BF.HasBuffKind(self.Me,10051006) then
			BF.AddBuff(self.Me,self.Me,10051006,1)
		end
		BF.AddSkillEventActiveSign(self.Me,100505002)		--PERK大招BUFF持续时间帧事件标记
		BF.RemoveSkillEventActiveSign(self.Me,100505001)	--常规大招BUFF持续时间帧事件标记
		if not BF.HasBuffKind(self.Me,1005058) and not BF.HasBuffKind(self.Me,1005054) and BF.HasBuffKind(self.Me,10051006) then
			BF.RemoveBuff(self.Me,10051006)	--移除PERK五行击破效率
		end
	elseif not BF.HasEntitySign(self.Me,10051006) then
		BF.AddSkillEventActiveSign(self.Me,100505001)
		BF.RemoveSkillEventActiveSign(self.Me,100505002)
	end

	--角色在场逻辑
	if self.RAP.CtrlRole == self.Me then

		--技能-闪躲衔接技能-反击判断
		if self.RAP.CurrentSkill == self.NormalSkill[2] and BF.GetSkillSign(self.Me,10050011) then
			BF.BreakSkill(self.Me)
			self.RAB.RoleCatchSkill:ActiveSkill(0,self.NormalSkill[3],2,2,0,0,0,{0},"Immediately","ClearClick",true)
		end
		
		--BF.SetCoreUIScale(self.Me, 1)
		--BF.SetCoreUIPosition(self.Me, 0, 0)

		--核心UI显示判断
		if (BF.CheckPlayerInFight() or self.RAP.CoreUiFrame > self.RAP.RealFrame) then
			BF.SetCoreUIVisible(self.Me, true, 0.2)
		else
			BF.SetCoreUIVisible(self.Me, false, 0.5)
		end

		--核心按钮长按提示判断
		if self.RAP.CoreRes >= 3 then
			BF.PlaySkillUIEffect("UIEffect/Prefab/UI_SkillPanel_changan.prefab","J")
		else
			BF.StopSkillUIEffect("UIEffect/Prefab/UI_SkillPanel_changan.prefab","J")
		end

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
				BF.DoEntityAudioPlay(self.Me,"Play_v_yixiang_0051",true,FightEnum.SoundSignType.Language)	--播放角色QTE语音
			end
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
				
				--*************************张永钢
				if BF.GetEntitySignSound(self.Me,FightEnum.SoundSignType.Language) == nil then
					--BF.DoEntityAudioPlay(self.Me,FightEnum.SoundEventMapKey.VoiceAudio_NormalSkill1,true,FightEnum.SoundSignType.Language)	--播放角色普通技能语音
				end
				--*************************张永钢
				
				end
				--self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalSkill[1],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1)
				--self.RAB.RoleCatchSkill:ContSkill(ClickButton,self.NormalSkill,2,2,10000002,0,0,{0},"Immediately","ClearClick",true)
			--end
		--普攻长按释放判断(空中)
		elseif self.RAP.PressButton[PressButton] == FK.Attack and self.RAP.PressButtonFrame[PressButton] >= 7
			and BF.CheckEntityHeight(self.Me) >= 1 then
			self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.FallAttack[1],170,170,0,0,0,{0},"0","ClearPress",true,0,-1)	
		--普攻长按释放判断(地面)
		elseif self.RAP.PressButton[PressButton] == FK.Attack and self.RAP.PressButtonFrame[PressButton] >= 12
			and BF.CheckEntityHeight(self.Me) == 0 then
			if self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.CoreSkill[1],2,2,0,0,0,{0},"Immediately","ClearPress",true,0,-1) then
				if self.RAP.CoreRes == 3 then
					BF.AddSkillEventActiveSign(self.Me,100504003)
					BF.AddSkillEventActiveSign(self.Me,100504002)
					BF.AddSkillEventActiveSign(self.Me,100504001)
				elseif self.RAP.CoreRes >= 2 then
					BF.AddSkillEventActiveSign(self.Me,100504002)
					BF.AddSkillEventActiveSign(self.Me,100504001)
				elseif self.RAP.CoreRes >= 1 then
					BF.AddSkillEventActiveSign(self.Me,100504001)
				else
					BF.AddSkillEventActiveSign(self.Me,100504000)
				end
				BF.ChangeEntityAttr(self.Me,1204,-3,1)	--总-3
				--*************************张永钢
				--BF.DoEntityAudioPlay(self.Me,FightEnum.SoundEventMapKey.VoiceAudio_CoreSkill,true,FightEnum.SoundSignType.Language)	--播放角色核心技能语音
				--*************************张永钢

				--BF.CastSkillCost(self.Me,1204)
				--BF.SetCoreEffectVisible(self.Me,"22099",false)
				--BF.SetCoreEffectVisible(self.Me,"22099",true)
			end
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


--大招残影逻辑汇总
function Behavior1005:Canying(Target)
	
	local r = BF.RandomSelect(1) --随机残影
	local pMe = BF.GetPositionP(self.Me)
	local phI = BF.GetPositionP(Target)
	--local x = BF.CheckPosHeight(phI)

	--阵法1
	if r == 1 then
		
		local p = BF.GetDoppelgangerPosByTarget(self.Me,Target, 2.5, 15, nil, 1.5, 1, 15, false, true)
		local c = 1005050099
		local s = BF.RandomSelect(1005050001)
		local m = 0
		local h = BF.CheckPosHeight(p[1])
		if h ~= nil then
			m = BF.CreateEntity(c, self.Me, p[1].x, p[1].y-h, p[1].z,phI.x, p[1].y-h, phI.z)
			BF.BindWeapon(m,BF.GetRoleWeaponId(self.Me))
		else
			m = BF.CreateEntity(c, self.Me, p[1].x, p[1].y, p[1].z,phI.x, p[1].y, phI.z)
			BF.BindWeapon(m,BF.GetRoleWeaponId(self.Me))
		end

		BF.CastSkillByTarget(m,1005050099,Target)
		BF.DoLookAtPositionImmediately(m,phI.x,p[1].y,phI.z,true)
		BF.CastSkillByTarget(m,s,Target)
		--BF.AddDelayCallByFrame(4, self, function() BF.DoLookAtPositionImmediately(m,phI.x,p2.y,phI.z,true) end)
		--BF.AddDelayCallByFrame(4, self, function() BF.CastSkillByTarget(m,s,Target) end)
	end

	--阵法2
	if r == 2 then
		local r1 = BF.RandomSelect(90,120,150,180,210,240,270)
		local p2 = BF.GetPositionOffsetP(phI,pMe,2.5,r1)
		p2.y = p2.y + 2
		local c = 1005050099
		local s = BF.RandomSelect(1005050001)
		local m = 0
		local h = BF.CheckPosHeight(p2)
		if h ~= nil then
			m = BF.CreateEntity(c, self.Me, p2.x, p2.y-h, p2.z,phI.x, p2.y - BF.CheckPosHeight(p2), phI.z)
			BF.BindWeapon(m,BF.GetRoleWeaponId(self.Me))
		else
			m = BF.CreateEntity(c, self.Me, p2.x, p2.y, p2.z,phI.x, p2.y, phI.z)
			BF.BindWeapon(m,BF.GetRoleWeaponId(self.Me))
		end
		BF.CastSkillByTarget(m,1005050099,Target)
		BF.DoLookAtPositionImmediately(m,phI.x,p2.y,phI.z,true)
		BF.CastSkillByTarget(m,s,Target)
		--BF.AddDelayCallByFrame(4, self, function() BF.DoLookAtPositionImmediately(m,phI.x,p2.y,phI.z,true) end)
		--BF.AddDelayCallByFrame(4, self, function() BF.CastSkillByTarget(m,s,Target) end)
	end

	--阵法3
	if r == 3 then
		local r1 = BF.RandomSelect(90,120,150,180,210,240,270)
		local p2 = BF.GetPositionOffsetP(phI,pMe,2.5,r1)
		local c = 1005050099
		local s = BF.RandomSelect(1005050002)
		local m = 0
		local h = BF.CheckPosHeight(p2)
		if h ~= nil then
			m = BF.CreateEntity(c, self.Me, p2.x, p2.y-h, p2.z,phI.x, p2.y - BF.CheckPosHeight(p2), phI.z)
			BF.BindWeapon(m,BF.GetRoleWeaponId(self.Me))
		else
			m = BF.CreateEntity(c, self.Me, p2.x, p2.y, p2.z,phI.x, p2.y, phI.z)
			BF.BindWeapon(m,BF.GetRoleWeaponId(self.Me))
		end
		BF.CastSkillByTarget(m,1005050099,Target)
		BF.DoLookAtPositionImmediately(m,phI.x,p2.y,phI.z,true)
		BF.CastSkillByTarget(m,s,Target)
	end

	--阵法4
	if r == 4 then
		local r1 = BF.RandomSelect(90,120,150,180,210,240,270)
		local p2 = BF.GetPositionOffsetP(phI,pMe,2.5,r1)
		local c = 1005050099
		local s = BF.RandomSelect(1005050003)
		local m = 0
		local h = BF.CheckPosHeight(p2)
		if h ~= nil then
			m = BF.CreateEntity(c, self.Me, p2.x, p2.y-h, p2.z,phI.x, p2.y - BF.CheckPosHeight(p2), phI.z)
			BF.BindWeapon(m,BF.GetRoleWeaponId(self.Me))
		else
			m = BF.CreateEntity(c, self.Me, p2.x, p2.y, p2.z,phI.x, p2.y, phI.z)
			BF.BindWeapon(m,BF.GetRoleWeaponId(self.Me))
		end
		BF.CastSkillByTarget(m,1005050099,Target)
		BF.DoLookAtPositionImmediately(m,phI.x,p2.y,phI.z,true)
		BF.CastSkillByTarget(m,s,Target)
	end

	self.CanyingFrame = self.RAP.RealFrame + 15
	
end


--首次命中判断
function Behavior1005:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	local I = BF.GetEntityTemplateId(instanceId)
	if attackInstanceId == self.Me then
		--普攻子弹
		if I == 1005001001 then
			--BF.AddSkillPoint(self.Me,1201,0.114,FE.SkillPointSource.NormalAttack)
		end
		if I == 1005002001 or I == 1005002002 then
			--BF.AddSkillPoint(self.Me,1201,0.0665,FE.SkillPointSource.NormalAttack)
		end
		if I == 1005003001 then
			--BF.AddSkillPoint(self.Me,1201,0.0475,FE.SkillPointSource.NormalAttack)
		end
		if I == 1005003002 then
			--BF.AddSkillPoint(self.Me,1201,0.152,FE.SkillPointSource.NormalAttack)
		end
		if I == 1005004001 then
			--BF.AddSkillPoint(self.Me,1201,0.1188,FE.SkillPointSource.NormalAttack)
		end
		if I == 1005004002 then
			--BF.AddSkillPoint(self.Me,1201,0.171,FE.SkillPointSource.NormalAttack)
		end
		if I == 1005005001 or I == 1005005002 then
			--BF.AddSkillPoint(self.Me,1201,0.095,FE.SkillPointSource.NormalAttack)
		end
		if I == 1005005003 then
			--BF.AddSkillPoint(self.Me,1201,0.19,FE.SkillPointSource.NormalAttack)
		end
		----跳反子弹强制打断敌人技能
		--if BF.CheckEntity(hitInstanceId) and I == 1001081001 then
			--BF.BreakSkill(hitInstanceId)
		--end
		--临时跳反踩踏子弹强制打断敌人技能
		if BF.CheckEntity(hitInstanceId) and I == 1000000019 then
			BF.BreakSkill(hitInstanceId)
		end
		if BF.CheckEntity(hitInstanceId) and (I == 1005010001 or I == 1005010002)
			and self.NormalSkillFrame > self.RAP.RealFrame then
			BF.ChangeEntityAttr(self.Me,1204,1,1)	--总1
			self.NormalSkillFrame = 0
		end
		
		--下砸子弹
		if I == 1005063001 then
			BF.SetCameraStateForce(FE.CameraState.ForceLocking,true)
			BF.SetCameraParams(FE.CameraState.ForceLocking,100506302)
		end
	end
	
	--PERK成功闪避或者反击后，可以召唤一个分身攻击敌人。
	if BF.HasEntitySign(self.Me,10051004) and attackInstanceId == self.Me and I == 1005012001 
		and BF.CheckEntity(hitInstanceId) then
		--反击命中产生残影
		BF.AddDelayCallByFrame(5, self, function() self:Canying(hitInstanceId) end)
	end

	--攻击命中产生大招残影
	if (BF.HasBuffKind(self.Me,1005054) or BF.HasBuffKind(self.Me,1005058)) and BF.CheckEntity(hitInstanceId)
		and attackInstanceId == self.Me and self.CanyingFrame <= self.RAP.RealFrame then
		--普攻1234命中产生残影
		if I == 1005001001 or I == 1005002002 or I == 1005003002 or I == 1005004002 then
			BF.AddDelayCallByFrame(2, self, function() self:Canying(hitInstanceId) end)
		end
		
		--普攻5技能命中产生残影
		if I == 1005010002 or I == 1005005003 then
			
			BF.AddDelayCallByFrame(4, self, function() self:Canying(hitInstanceId) end)
			BF.AddDelayCallByFrame(11, self, function() self:Canying(hitInstanceId) end)
		end
		
		--躲避反击命中产生残影
		if I == 1005012002 then
			--攻击命中产生残影
			BF.AddDelayCallByFrame(10, self, function() self:Canying(hitInstanceId) end)
			BF.AddDelayCallByFrame(17, self, function() self:Canying(hitInstanceId) end)
			BF.AddDelayCallByFrame(24, self, function() self:Canying(hitInstanceId) end)
		end
		
		--大招命中产生残影
		if I == 1005050050 then
			--攻击命中产生残影
			BF.AddDelayCallByFrame(17, self, function() self:Canying(hitInstanceId) end)
			BF.AddDelayCallByFrame(24, self, function() self:Canying(hitInstanceId) end)
			BF.AddDelayCallByFrame(31, self, function() self:Canying(hitInstanceId) end)
		end
	end
end

--躲避前判断
function Behavior1005:BeforeParry(attackInstanceId,hitInstanceId,InstanceIdId,attackType)
	if hitInstanceId == self.Me and (attackType == FEEAT.General or attackType == FEEAT.Special or attackType == FEEAT.Low) then
		BF.AddEntitySign(self.Me,"ParrySuccess",30,false) --此次子弹命中被忽略
		BF.BreakSkill(self.Me)
		self.RAB.RoleCatchSkill:ActiveSkill(0,self.NormalSkill[2],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1)
		
		--躲避产生大招残影攻击
		if (BF.HasBuffKind(self.Me,1005054) or BF.HasBuffKind(self.Me,1005058)) and BF.CheckEntity(attackInstanceId) then
			BF.AddDelayCallByFrame(7, self, function() self:Canying(attackInstanceId) end)
			BF.AddDelayCallByFrame(14, self, function() self:Canying(attackInstanceId) end)
		end
	end
end

--命中判断
function Behavior1005:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType)
	
end

--技能释放判断
function Behavior1005:CastSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.Me and skillId == 1005010 then
		self.NormalSkillFrame = self.RAP.RealFrame + 35
	end
	if instanceId == self.Me and skillId == 1005012 then
		BF.ChangeEntityAttr(self.Me,1204,1,1)
	end
	if instanceId == self.Me and (((skillSign ~= 30 and skillSign ~= 31) and not BF.CheckPlayerInFight()) or BF.CheckPlayerInFight()) then
		self.RAP.CoreUiFrame = self.RAP.RealFrame + 90
		--BF.ChangeEntityAttr(self.Me,1206,-250,1)
		--self.ChangeLockTargetFrame = 0 --闪避重置切换锁定目标间隔时间
	end
	--PERK成功闪避或者反击后，可以召唤一个分身攻击敌人。在反击后，还可以额外回复一格日相。
	if BF.HasEntitySign(self.Me,10051004) and instanceId == self.Me and skillId == 1005012 then
		BF.AddSkillPoint(self.Me,1201,1)
	end
end

--属性变化判断
function Behavior1005:ChangeAttrValue(attrType,attrValue,changedValue)
	if attrType == 1204 then
		self.RAP.CoreUiFrame = self.RAP.RealFrame + 90
	end
end

--通用闪避成功判断
function Behavior1005:Dodge(attackInstanceId,hitInstanceId,limit)
	if hitInstanceId == self.Me and BF.CheckEntity(attackInstanceId) then
		--闪避产生大招残影攻击
		if (BF.HasBuffKind(self.Me,1005054) or BF.HasBuffKind(self.Me,1005058)) then
			BF.AddDelayCallByFrame(4, self, function() self:Canying(attackInstanceId) end)
			BF.AddDelayCallByFrame(11, self, function() self:Canying(attackInstanceId) end)
		end
		--PERK成功闪避或者反击后，可以召唤一个分身攻击敌人。
		if BF.HasEntitySign(self.Me,10051004) and self.PERK4Frame < self.RAP.RealFrame then
			BF.AddDelayCallByFrame(5, self, function() self:Canying(attackInstanceId) end)
			self.PERK4Frame = self.RAP.RealFrame + 15
		end
	end
end

--动画帧事件判断
--function Behavior1005:OnAnimEvent(instanceId,eventType,params)
	----右手武器显隐判断
	--if instanceId == self.Me and eventType == FEAET.RightWeaponVisible then
		--if params.visible then
			--if BF.HasBuffKind(self.Me,1000073) then
				--BF.RemoveBuff(self.Me,1000073,5)
			--end
		--else
			--if not BF.HasBuffKind(self.Me,1000073) then
				--BF.AddBuff(self.Me,self.Me,1000073,1)
			--end
		--end
	--end
--end

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
function Behavior1005:FinishSkill(instanceId,skillId,skillSign,skillType)
	--if instanceId == self.Me and skillId == 1001081 then
		--BF.SetCameraParams(FightEnum.CameraState.ForceLocking) --重置强锁定镜头参数
	--end
end


--获取计算公式参数前
function Behavior1005:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)
	
	--PERK分身伤害提升a%，普攻变为土属性攻击伤害。
	if attackInstanceId ~= 0 then
		local I = BF.GetEntityTemplateId(attackInstanceId)
		if BF.HasEntitySign(self.Me,10051001) and ownerInstanceId == self.Me and (I == 1005050001 or I == 1005050002 or I == 1005050003
				or I == 1005050004 or I == 1005050005) then	
			BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,BF.GetMagicValue(self.Me,10051001,1,1)) --修改伤害加成
		end
	end
	--PERK分身伤害提升a%，普攻变为土属性攻击伤害。
	if BF.HasEntitySign(self.Me,10051001) and ownerInstanceId == self.Me then
		if BF.AnalyseSkillType(BF.GetDamageParam(FE.DamageInfo.SkillType),FE.SkillType.NormalAttack) then
			BF.ChangeDamageParam(FE.DamageInfo.DmgElement,FE.ElementType.Earth) --修改为土属性
		end
	end
	
	--PERK「e - 技能名」伤害倍率提升a%。
	if BF.HasEntitySign(self.Me,10051003) and ownerInstanceId == self.Me then
		if BF.AnalyseSkillType(BF.GetDamageParam(FE.DamageInfo.SkillType),FE.SkillType.Skill) then
			BF.ChangeDamageParam(FE.DamageParam.SkillPercent,BF.GetMagicValue(self.Me,10051003,1,1))
		end
	end
	
	--PERK核心伤害+a%。
	if BF.HasEntitySign(self.Me,10051005) and ownerInstanceId == self.Me then
		if BF.AnalyseSkillType(BF.GetDamageParam(FE.DamageInfo.SkillType),FE.SkillType.Core) then
			BF.ChangeDamageParam(FE.DamageParam.DmgAtkPercent,BF.GetMagicValue(self.Me,10051005,1,1))
		end
	end
end



function Behavior1005:SkillFrameUpdate(instanceId,skillId,skillFrame)
	if instanceId == self.Me then
		--临时QTE逻辑
		if skillId == 1005063 then
			local target = BF.GetEntityValue(1,"curConnectTarget")
			if skillFrame == 0 then

			end
			
			--精准位移
			if skillFrame == 11 then
				if target and BF.CheckEntity(target) then
					local pos = BF.GetPositionP(target)
					local height = BF.CheckEntityHeight(target)
					--pos.z = pos.z
					height = height < 0 and 0 or height
					pos.y = pos.y - height
					BF.DoPreciseMoveToPosition(self.Me, pos.x, pos.y, pos.z, 13)
				end
				--BF.SetCameraStateForce(FightEnum.CameraState.ForceLocking,false)
				--BF.SetCameraParams(FightEnum.CameraState.ForceLocking,100506302,false)	--设置强锁参数
				--local pos = BF.GetPositionP(self.Me)
				--local height = BF.CheckEntityHeight(self.Me)
					--pos.z = pos.z + 1
				--pos.y = pos.y - height
				--BF.DoPreciseMoveToPosition(self.Me, pos.x, pos.y, pos.z, 4)
			end
			
			if skillFrame == 16 then
				if not BehaviorFunctions.HasEntitySign(1,10000007) then
					BehaviorFunctions.SetBodyDamping(0.2,0.2,0.2)
					BF.SetVCCameraBlend("ForceLockingCamera","OperatingCamera",0.1)
					BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.Operating,false)	--设置弱锁
					BehaviorFunctions.CameraPosReduction(0.1,false,0.2)	--重置相机位置
				else
					BehaviorFunctions.SetCameraStateForce(2,false)
				end

				--BehaviorFunctions.CameraPosReduction(0.3,false,1)	--重置相机位置
				if target and target ~= 0 and BehaviorFunctions.CheckEntity(target) then
						BehaviorFunctions.RemoveLookAtTarget(target,"HitCase")
						--BehaviorFunctions.SetBodyDamping(0.5,0.5,0.5)
				else
					--BehaviorFunctions.SetBodyDamping(0.2,0.2,0.2)
				end
			end
		end
	end
end

--脉象相关
function Behavior1005:AddEntitySign(instanceId,sign)
	if instanceId == self.Me then
		if sign == 10051001 then
			BF.DoMagic(self.Me,self.Me,10051001)	--perk1参数
		end

		if sign == 10051003 then
			BF.DoMagic(self.Me,self.Me,10051003)	--perk3参数
		end

		if sign == 10051005 then
			BF.DoMagic(self.Me,self.Me,10051005)	--perk5参数
		end
	end
end