Behavior1001 = BaseClass("Behavior1001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType

function Behavior1001.GetGenerates()
	local generates = {
		
	}
	return generates
end
function Behavior1001.GetOtherAsset()
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

function Behavior1001:Init()
	--变量声明
	self.Me = self.instanceId		--记录自己

	--普攻技能Id
	self.NormalAttack = {1001001,1001002,1001003,1001004,1001005}
	self.NormalSkill = {1001010}	--普通技能Id
	self.MoveSkill = {1001030,1001031}	--闪避技能Id
	self.FallAttack = {1001170,1001171,1001172}	--下落攻击Id
	self.AirAttack = {1001101,1001102,1001103}	--空中攻击Id
	self.LeapAttack = {1001160}	--起跳攻击Id
	--self.CoreSkill = {1001041,1001042,1001043}	--核心技能Id
	self.CoreSkill = {1001044}	--核心技能Id
	self.QTESkill = {1001994}	--QTE技能Id
	self.DodgeAttack = {1001070,1001071}	--闪避反击技能
	self.JumpAttack = {1001080,1001081,1001082}	--闪避反击技能
	self.UltimateSkill = {1001051,1001052}	--大招技能Id
	self.PartnerConnect = {1001999}	--佩从连携技能id
	self.PartnerCall = {1001061,1001062,1001063,1001064} --佩从召唤动作
	self.PartnerHenshin = {1001060} --佩从变身动作集合
	self.CatchSkill = {1001090}	--捕捉技能
	
	self.QTEtype = 4			--QTE类型：1切换角色放技能，2不切换角色下场放技能，3AI援助,4转镜切人
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
	--self.CoreNum = {0,0,0}
	--self.CoreNumFrame = {0,0,0}
	
	self.RAP.backgroundRes1 = 6.1 --每多少秒回复1点日相

	self.HitFlyCd = 300 	--击飞连携10秒Cd
	self.HitFlyCdFrmae = 0	--击飞连携当前冷却
	
	self.curHitFlyBullet = 0	--测试
	
	--*************************张永钢
	--角色语音类型变量
	self.RAP.VoiceAudio_Climb = {"Play_v_qingwu_0033"}
	self.RAP.VoiceAudio_Run = {"Play_v_qingwu_0035"}
	self.RAP.VoiceAudio_WallRun = {"Play_v_qingwu_0037"}
	self.RAP.VoiceAudio_Gliding = {"Play_v_qingwu_0039"}
	self.RAP.VoiceAudio_Dead = {"Play_v_qingwu_0068"}
	self.RAP.VoiceAudio_Hit = {"Play_v_qingwu_0062"}

	
	self.RAP.VoiceAudio_Looting = {"Play_v_qingwu_0041"}
	self.RAP.VoiceAudio_Stand1 = {"Play_v_qingwu_0043"}
	self.RAP.VoiceAudio_NormalATK = {"Play_v_qingwu_0045"}
	
	self.VoiceAudio_NormalSkill = {"Play_v_qingwu_0048"}
	
	self.RAP.VoiceAudio_QTESkill = {"Play_v_qingwu_0051"}
	self.RAP.VoiceAudio_CoreSkill = {"Play_v_qingwu_0054"}
	self.RAP.VoiceAudio_JumpATK = {"Play_v_qingwu_0057"}
	self.RAP.VoiceAudio_PartnerATK = {"Play_v_qingwu_0059"}
	self.RAP.VoiceAudio_LowHP = {"Play_v_qingwu_0065"}
	--*************************张永钢
	
	--QTE参数重写
	self.RAP.QTEDistance  = 4		--连携QTE距离
	self.RAP.QTEAngle = 135			--连携QTE角度
	self.RAP.QTECd = 5				--QTE冷却
end

function Behavior1001:LateInit()
	self.RAP:LateInit()
end


function Behavior1001:BeforeUpdate()
	--通用参数组合更新
	self.RAP:BeforeUpdate()

end

function Behavior1001:Update()

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
	end
end

--角色个人判断
function Behavior1001:Core()

	----临时PERK解锁核心被动。
	--if not BF.HasEntitySign(self.Me,10011001) then
		--BF.AddEntitySign(self.Me,10011001,-1)
	--end
	
	--Log(self.CoreNumFrame[1].."       "..self.CoreNumFrame[2].."       "..self.CoreNumFrame[3])
	----核心时间衰减判断
	--if self.CoreNum[1] ~= 0 and self.CoreNumFrame[1] < self.RAP.RealFrame then
		--self.CoreNum[1] = 0
		--BF.ChangeEntityAttr(self.Me,1204,-1,1)
		--self.CoreNumFrame[1] = 0
	--end
	--if self.CoreNum[2] ~= 0 and self.CoreNumFrame[2] < self.RAP.RealFrame then
		--self.CoreNum[2] = 0
		--BF.ChangeEntityAttr(self.Me,1204,-1,1)
		--self.CoreNumFrame[2] = 0
	--end
	--if self.CoreNum[3] ~= 0 and self.CoreNumFrame[3] < self.RAP.RealFrame then
		--self.CoreNum[3] = 0
		--BF.ChangeEntityAttr(self.Me,1204,-1,1)
		--self.CoreNumFrame[3] = 0
	--end
	
	--检查核心资源率
	self.RAP.CoreResRatio = BF.GetEntityAttrValueRatio(self.Me,1204)
	self.RAP.CoreRes = BF.GetEntityAttrVal(self.Me,1204)
	
	--核心UI动效判断 -- 核心资源充满
	if BF.HasEntitySign(self.Me,10011001) and self.RAP.CtrlRole == self.Me and self.RAP.CoreRes >= 3 then
		BF.SetCoreEffectVisible(self.Me,"UI_CoreUI1001_man",true)
	else
		BF.SetCoreEffectVisible(self.Me,"UI_CoreUI1001_man",false)
	end
	
	--核心火伤BUFF层数判断
	if BF.HasEntitySign(self.Me,10011001) and BF.HasBuffKind(self.Me,1001042) and BF.GetBuffCount(self.Me,1001042) > self.RAP.CoreRes then
		local c = BF.GetBuffCount(self.Me,1001042)
		for i = c, self.RAP.CoreRes+1, -1 do
			BF.RemoveBuff(self.Me,1001042)
		end
	elseif BF.HasEntitySign(self.Me,10011001) and (not BF.HasBuffKind(self.Me,1001042) or (BF.HasBuffKind(self.Me,1001042) 
				and BF.GetBuffCount(self.Me,1001042) < self.RAP.CoreRes)) then
		local c = BF.GetBuffCount(self.Me,1001042)
		for i = c, self.RAP.CoreRes-1, 1 do
			BF.AddBuff(self.Me,self.Me,1001042,1)
		end
	end
	
	--PERK叙慕处于后台时，每格炎印额外提升a%日相回复效率。
	--BF.AddEntitySign(self.Me,10011006,-1)
	if BF.HasEntitySign(self.Me,10011006) and not BF.CheckEntityForeground(self.Me) then
		local c = BF.GetBuffCount(self.Me,10011006)
		if c ~= self.RAP.CoreRes then
			for i = 1, 4 do
				if c < self.RAP.CoreRes then
					BF.AddBuff(self.Me,self.Me,10011006)
					c = BF.GetBuffCount(self.Me,10011006)
				elseif c > self.RAP.CoreRes then
					BF.RemoveBuff(self.Me,self.Me,10011006)
					c = BF.GetBuffCount(self.Me,10011006)
				else
					break
				end
			end
		end
	elseif BF.HasEntitySign(self.Me,10011006) and BF.CheckEntityForeground(self.Me) and BF.HasBuffKind(self.Me,10011006) then
		BF.RemoveBuffByKind(self.Me,10011006)
	end

	--角色在场逻辑
	if self.RAP.CtrlRole == self.Me then

		BF.SetCoreUIScale(self.Me, 1)
		--BF.SetCoreUIPosition(self.Me, 0, 0)
		
		--核心UI显示判断
		if (BF.CheckPlayerInFight() or self.RAP.CoreUiFrame > self.RAP.RealFrame) and BF.HasEntitySign(self.Me,10011001) then
			BF.SetCoreUIVisible(self.Me, true, 0.2)
		else
			BF.SetCoreUIVisible(self.Me, false, 0.5)
		end

		--核心按钮长按提示判断
		if self.RAP.CoreRes >= 3 and BF.HasEntitySign(self.Me,10011001) then
			BF.PlaySkillUIEffect("UIEffect/Prefab/UI_SkillPanel_changan.prefab","J")
			BF.SetPlayerCoreEffectVisible("20027", true)
			BF.SetPlayerCoreEffectVisible("20028", true)
		else
			BF.StopSkillUIEffect("UIEffect/Prefab/UI_SkillPanel_changan.prefab","J")
			BF.SetPlayerCoreEffectVisible("20027", false)
			BF.SetPlayerCoreEffectVisible("20028", false)
		end

		----技能强化动效判断
		--if BF.GetSkillCostValue(self.Me,FK.NormalSkill) >= 2 then
			--BF.SetSkillBehaviorConfig(self.Me, 1001010, "ReadyEffectPath", BehaviorFunctions.GetEffectPath(22096))
		--elseif BF.GetSkillCostValue(self.Me,FK.NormalSkill) == 1 then
			--BF.SetSkillBehaviorConfig(self.Me, 1001010, "ReadyEffectPath", BehaviorFunctions.GetEffectPath(22058))
		--end

		--全身隐藏显示判断
		if BF.GetSkillSign(self.Me,10010002) and not BF.HasBuffKind(self.Me,1001902) then
			BF.AddBuff(self.Me,self.Me,1001902,1)
		elseif not BF.GetSkillSign(self.Me,10010002) and BF.HasBuffKind(self.Me,1001902) then
			BF.RemoveBuff(self.Me,1001902,5)
		end
	end
end

--重写角色释放技能组合
function Behavior1001:RoleCatchSkill()
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
				BF.DoEntityAudioPlay(self.Me,"Play_v_qingwu_0051",true,FightEnum.SoundSignType.Language)	--播放角色QTE语音
			end
			--闪避释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.Dodge and BF.CheckEntityHeight(self.Me) == 0 then
			if self.RAB.RoleCatchSkill:MoveSkill(ClickButton,5,5,0,0,0,{21},"ClearClick") then
				BF.CastSkillCost(self.Me,self.MoveSkill[1],"ClearClick")
			end
			--普通技能释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.NormalSkill and BF.CheckEntityHeight(self.Me) == 0 then
			--and not BF.CheckKeyPress(FK.NormalSkill) then
			--if BF.GetSkillCostValue(self.Me,FK.NormalSkill) >= 3 then
			--if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalSkill[3],2,2,0,0,0,{0},"Immediately","ClearClick",true) then
			--BF.CastSkillCost(self.Me,self.NormalSkill[3])
			--BF.ChangeEntityAttr(self.Me,1204,90,1)	--总90
			--end
			--if BF.GetSkillCostValue(self.Me,FK.NormalSkill) >= 2 then
				--if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalSkill[2],2,2,0,0,0,{0},"Immediately","ClearClick",true) then
					--BF.CastSkillCost(self.Me,self.NormalSkill[1])
				--end
				--elseif BF.GetSkillCostValue(self.Me,FK.NormalSkill) == 1 then
			if BF.GetSkillCostValue(self.Me,FK.NormalSkill) >= 2 then
				if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalSkill[1],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
					BF.CastSkillCost(self.Me,self.NormalSkill[1])
					
					--*************************张永钢
					if BF.GetEntitySignSound(self.Me,FightEnum.SoundSignType.Language) == nil then
						--BF.DoEntityAudioPlay(self.Me,FightEnum.SoundEventMapKey.VoiceAudio_NormalSkill1,true,FightEnum.SoundSignType.Language)	--播放角色普通技能语音
					end
					--*************************张永钢
				end
			end
			--普攻长按释放判断(空中)
		elseif self.RAP.PressButton[PressButton] == FK.Attack and self.RAP.PressButtonFrame[PressButton] >= 7
			and BF.CheckEntityHeight(self.Me) >= 1 then
			self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.FallAttack[1],170,170,0,0,0,{0},"0","ClearPress",true,0,-1)
			--普攻长按释放判断(地面)
			--PERK解锁核心被动。
		elseif self.RAP.PressButton[PressButton] == FK.Attack and self.RAP.PressButtonFrame[PressButton] >= 12
			and BF.CheckEntityHeight(self.Me) == 0 and self.RAP.CoreRes >= 3 and BF.HasEntitySign(self.Me,10011001) then
			if self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.CoreSkill[1],2,2,0,0,0,{0},"Immediately","ClearPress",true,0,-1) then
				
				--*************************张永钢
				if BF.GetEntitySignSound(self.Me,FightEnum.SoundSignType.Language) == nil then
					--BF.DoEntityAudioPlay(self.Me,FightEnum.SoundEventMapKey.VoiceAudio_CoreSkill,true,FightEnum.SoundSignType.Language)	--播放角色核心技能语音
				end
				--*************************张永钢
				
				--BF.CastSkillCost(self.Me,1204)
				BF.SetCoreEffectVisible(self.Me,"22099",false)
				BF.SetCoreEffectVisible(self.Me,"22099",true)
				BF.ChangeEntityAttr(self.Me,1204,-300,1)	--总-3
			end
			--普攻点按释放判断(地面)
		elseif self.RAP.ClickButton[ClickButton] == FK.Attack and BF.CheckEntityHeight(self.Me) == 0 then
			----3点衍生释放判断
			--if BF.HasEntitySign(self.Me,10010010) then
			--if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalSkill[4],2,2,0,0,0,{0},"Immediately","ClearClick",true) then
			--BF.RemoveEntitySign(self.Me,10010010)
			--BF.ChangeEntityAttr(self.Me,1204,90,1)	--总90
			--end
			--闪避反击释放判断
			if BF.HasEntitySign(self.Me,10000000) then
				if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.DodgeAttack[1],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
					BF.RemoveEntitySign(self.Me,10000000)
				end
			else
				self.RAP.FrontDistance = 5
				self.RAP.MyFrontPos = BF.GetPositionOffsetBySelf(self.Me,self.RAP.FrontDistance,0)
				self.RAB.RoleCatchSkill:ContSkill(ClickButton,self.NormalAttack,1,1,10000002,0,0,{0},"Immediately","ClearClick",true,0,-1)
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
function Behavior1001:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	local I = BF.GetEntityTemplateId(instanceId)
	if attackInstanceId == self.Me then
		--普攻子弹--总2格--总50点核心-1/6
		if I == 1001001001 then
			--BF.AddSkillPoint(self.Me,1201,0.0471,FE.SkillPointSource.NormalAttack)
			--BF.ChangeEntityAttr(self.Me,1204,3,1)
			--BF.ChangeEntityAttr(self.Me,1201,471,1)
		end
		if I == 1001002001 or I == 1001002002 then
			--BF.AddSkillPoint(self.Me,1201,0.0563,FE.SkillPointSource.NormalAttack)
			--BF.ChangeEntityAttr(self.Me,1204,3,1)--总9
			--BF.ChangeEntityAttr(self.Me,1201,563,1)
		end
		if I == 1001003001 or I == 1001003002 then
			--BF.AddSkillPoint(self.Me,1201,0.044,FE.SkillPointSource.NormalAttack)
			--BF.ChangeEntityAttr(self.Me,1204,4,1)--总16
			--BF.ChangeEntityAttr(self.Me,1201,440,1)
		end
		if I == 1001004001 or I == 1001004002 or I == 1001004003 or I == 1001004004 then
			--BF.AddSkillPoint(self.Me,1201,0.0502,FE.SkillPointSource.NormalAttack)
			--BF.ChangeEntityAttr(self.Me,1204,4,1)--总12
			--BF.ChangeEntityAttr(self.Me,1201,502,1)
		end
		if I == 1001005001 then
			--BF.AddSkillPoint(self.Me,1201,0.044,FE.SkillPointSource.NormalAttack)
			--BF.ChangeEntityAttr(self.Me,1204,5,1)--总10
			--BF.ChangeEntityAttr(self.Me,1201,440,1)
		end
		if I == 1001005002 then
			--BF.AddSkillPoint(self.Me,1201,0.0563,FE.SkillPointSource.NormalAttack)
			--BF.ChangeEntityAttr(self.Me,1204,5,1)--总10
			--BF.ChangeEntityAttr(self.Me,1201,563,1)
		end
		--跳反子弹强制打断敌人技能
		if BF.CheckEntity(hitInstanceId) and I == 1001081001 then
			BF.BreakSkill(hitInstanceId)
		end
		--临时跳反踩踏子弹强制打断敌人技能
		if BF.CheckEntity(hitInstanceId) and I == 1001080001 then
			BF.BreakSkill(hitInstanceId)
		end
		if BF.HasEntitySign(self.Me,10011001) and BF.CheckEntity(hitInstanceId) and (I == 1001010001 or I == 1001010002) 
			and self.NormalSkillFrame > self.RAP.RealFrame then
			BF.ChangeEntityAttr(self.Me,1204,1,1)	--总1
			self.NormalSkillFrame = 0
		end
		
		--设置空中连携下砸相机
		if I == 1001998005 then
			if hitInstanceId and BF.CheckEntity(hitInstanceId) then
				BF.RemoveBuff(hitInstanceId,600000051)
				self.curHitFlyTarget = hitInstanceId
			end
			BF.SetCameraStateForce(FightEnum.CameraState.ForceLocking,true)	--切换升龙连携强锁
			BF.SetCameraParams(FightEnum.CameraState.ForceLocking,1001998005,false)	--设置强锁参数
		end
		

		--设置升龙相机
		if I == 1001998001 then
			BF.RemoveBuff(hitInstanceId,1614302)
			BF.SetVCCameraBlend("OperatingCamera","ForceLockingCamera",0)
			BF.SetCameraStateForce(FightEnum.CameraState.ForceLocking,true)	--切换升龙连携强锁
			BF.SetCameraParams(FightEnum.CameraState.ForceLocking,62303,false)	--设置强锁参数
			BF.RemoveAllLookAtTarget()
			BF.AddLookAtTarget(hitInstanceId,"HitCase")
			BF.SetBodyDamping(0.3,0.3,0.5)
		end

		
		--if instanceId == self.curHitFlyBullet then
			----把目标位置设置到指定位置
			--BehaviorFunctions.DoPreciseMove(hitInstanceId, self.Me, 0, 2, 0.5, 5)
		--end
	end
end

--技能释放判断
function Behavior1001:CastSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.Me and skillId == 1001010 then
		self.NormalSkillFrame = self.RAP.RealFrame + 35
	end
	if instanceId == self.Me and (((skillSign ~= 30 and skillSign ~= 31) and not BF.CheckPlayerInFight()) or BF.CheckPlayerInFight()) then
		self.RAP.CoreUiFrame = self.RAP.RealFrame + 90
		--BF.ChangeEntityAttr(self.Me,1206,-250,1)
		--self.ChangeLockTargetFrame = 0 --闪避重置切换锁定目标间隔时间
	end
	
	--PERK释放「大招 - 技能名」后会回复a格日相。
	if instanceId == self.Me and skillId == 1001051 and BF.HasEntitySign(self.Me,10011005) then
		
		BF.AddSkillPoint(self.Me,1201,BF.GetMagicValue(self.Me,10011005,1,1))
	end
	
	--脉象4的QTE，技能放出来才算CD
	if instanceId == self.Me and skillId == 1001994 then
		self.HitFlyCdFrmae = self.RAP.RealFrame + self.HitFlyCd
	end
end

--属性变化判断
function Behavior1001:ChangeAttrValue(attrType,attrValue,changedValue)
	if attrType == 1204 then
		self.RAP.CoreUiFrame = self.RAP.RealFrame + 90
		--if changedValue ~= 0 then
			--self:CorePart(changedValue)
		--end
	end
end

--通用闪避成功判断
function Behavior1001:Dodge(attackInstanceId,hitInstanceId,limit)
	if BF.HasEntitySign(self.Me,10011001) and hitInstanceId == self.Me and limit == true then
		--BF.ChangeEntityAttr(self.Me,1204,1,1)
		--BF.ChangeEntityAttr(self.Me,1204,75,1)
		--BF.AddEntitySign(hitInstanceId,10000000,90) --角色3秒内反击标记
	end
end

--跳跃反击着地回调
function Behavior1001:OnLand(instanceId)
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

function Behavior1001:FinishSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.Me and skillId == 1001081 then
		BF.SetCameraParams(FightEnum.CameraState.ForceLocking) --重置强锁定镜头参数
	end
	
	if skillId == 1001999 and BehaviorFunctions.GetEntityTemplateId(instanceId) == 1001 then
		BehaviorFunctions.SetVCCameraBlend("OperatingCamera","ForceLocking",1)
		BehaviorFunctions.SetCameraStateForce(1,false)	--结束技能设置回操作
		BehaviorFunctions.CameraPosReduction(0.2,false,0.5)	--重置相机位置
		BehaviorFunctions.RemoveAllLookAtTarget()
		BehaviorFunctions.AddLookAtTarget(instanceId,"CameraTarget")
		BehaviorFunctions.RemoveEntitySign(instanceId,6000999)--移除连携状态不切相机
		if self.curHitFlyTarget and self.curHitFlyTarget ~= 0 and BF.CheckEntity(self.curHitFlyTarget) then
			BF.RemoveBuff(self.curHitFlyTarget,600000051)
			self.curHitFlyTarget = 0
		end
	end
end

function Behavior1001:BreakSkill(instanceId,skillId,skillSign,skillType)
	if skillId == 1001999 and BehaviorFunctions.GetEntityTemplateId(instanceId) == 1001 then
		BehaviorFunctions.SetVCCameraBlend("OperatingCamera","ForceLocking",1)
		BehaviorFunctions.SetCameraStateForce(1,false)	--结束技能设置回操作
		BehaviorFunctions.CameraPosReduction(0.2,false,0.5)	--重置相机位置
		BehaviorFunctions.RemoveAllLookAtTarget()
		BehaviorFunctions.AddLookAtTarget(instanceId,"CameraTarget")
		BehaviorFunctions.RemoveEntitySign(instanceId,6000999)--移除连携状态不切相机
		if self.curHitFlyTarget and self.curHitFlyTarget ~= 0 and BF.CheckEntity(self.curHitFlyTarget) then
			BF.RemoveBuff(self.curHitFlyTarget,600000051)
			self.curHitFlyTarget = 0
		end
	end
end


function Behavior1001:AddSkillSign(instanceId,sign)
	if instanceId == self.Me then 
		if sign == 1001998 then
		--BF.CastSkillByTarget(instanceId,1001999,targetInstanceId)
			self.RAB.RoleCatchSkill:ActiveSkill(0,1001999,5,3,0,0,0,{0},"Immediately","ClearClick",true,0,-1)
			BehaviorFunctions.RemoveSkillEventActiveSign(self.Me,1001999)
		end
	end
end

--受击前
function Behavior1001:Hit(attackInstanceId,hitInstanceId,hitType,camp)
	--受击QTE回调
	--PERK解锁叙慕的空中连携能力。
	if attackInstanceId == self.RAP.CtrlRole and attackInstanceId ~= self.Me then
		if BF.HasEntitySign(self.Me,10011004) and self.HitFlyCdFrmae < self.RAP.RealFrame then
			if BF.GetHitType(hitInstanceId) == FightEnum.EntityHitState.HitFlyUp or BehaviorFunctions.GetHitType(hitInstanceId) == FightEnum.EntityHitState.HitFlyFall then
				if not BF.HasEntitySign(self.Me,10000006)  then
					--BF.AddEntitySign(1,10000006,-1,false)
					BF.AddEntitySign(self.Me,10000006,-1,false)
					BF.SetEntityValue(1,"curConnectTarget",hitInstanceId)
					--self.HitFlyCdFrmae = self.RAP.RealFrame + self.HitFlyCd
				end
			end
		end
	end
end

--伤害计算前
function Behavior1001:BeforeCalculateDamage(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)
	--PERK「大招- 技能名」的总伤害倍率提升a%
	if BF.HasEntitySign(self.Me,10011003) and ownerInstanceId == self.Me then
		if BF.AnalyseSkillType(BF.GetDamageParam(FE.DamageInfo.SkillType),FE.SkillType.Unique) then
			BF.ChangeDamageParam(FE.DamageParam.SkillPercent,BF.GetMagicValue(self.Me,10011003,1,1))
		end
	end
end

--脉象相关
function Behavior1001:AddEntitySign(instanceId,sign)
	if instanceId == self.Me then
		if sign == 10011003 then
			BF.DoMagic(self.Me,self.Me,10011003)	--perk3参数
		end

		if sign == 10011005 then
			BF.DoMagic(self.Me,self.Me,10011005)	--perk5参数
		end
	end
end

----帧事件实体
--function Behavior1001:KeyFrameAddEntity(instanceId,entityId)
	----击飞子弹
	--if entityId == 1001998001 then
		--self.curHitFlyBullet = instanceId
	--end
--end



----核心数量计算判断
--function Behavior1001:CorePart(value)
	--local a = math.abs(value)
	
	--for c = 1,a,1 do
		--local k = 1
		--for i = 1, 3, 1 do
			----Log(i.."    "..value)
			--if i <= 3 then
				--if self.CoreNumFrame[k] <= self.CoreNumFrame[i] then
					--if value > 0 then
						--if self.CoreNumFrame[k] == 0 then
							--self.CoreNum[k] = 1
							--self.CoreNumFrame[k] = self.RAP.RealFrame + 600
							--break
						--end
					--elseif value < 0 then
						--if self.CoreNumFrame[i] == 0 then
							--break
						--end
					--end
				--else
					--k = i
				--end
			--end
			--if i == 3 and value > 0 then
				--self.CoreNum[k] = 1
				--self.CoreNumFrame[k] = self.RAP.RealFrame + 600
			--elseif i == 3 and value < 0 then
				--self.CoreNum[k] = 0
				--self.CoreNumFrame[k] = 0
			--end
		--end
	--end
--end
