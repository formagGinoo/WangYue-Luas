Behavior1006 = BaseClass("Behavior1006",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType

function Behavior1006.GetGenerates()
	local generates = {}
	return generates
end
function Behavior1006.GetMagics()
	local generates = {}
	return generates
end

function Behavior1006.GetOtherAsset()
	local generates = {
		"Effect/UI/22156_qingmenyin.prefab",
		"Effect/UI/22157_qingmenyin.prefab"
		}
	return generates
end

function Behavior1006:Init()
	self.Me = self.instanceId		--记录自己
	
	--通用参数组合初始化、角色组合合集
	self.RoleAllParm = BehaviorFunctions.CreateBehavior("RoleAllParm",self)
	self.RoleAllBehavior = BehaviorFunctions.CreateBehavior("RoleAllBehavior",self)
	
	--组合缩写
	self.RAB = self.RoleAllBehavior
	self.RAP = self.RoleAllParm
	
	--普攻技能Id
	self.NormalAttack = {1006001,1006002,1006003,1006004,1006005}
	self.NormalSkill = {1006011,1006012,1006013}	--普通技能Id
	self.MoveSkill = {1006030,1006031}	--闪避技能Id
	self.FallAttack = {1006170,1006171,1006172}	--下落攻击Id
	--self.AirAttack = {1001101,1001102,1001103}	--空中攻击Id
	--self.LeapAttack = {1001160}	--起跳攻击Id
	--self.CoreSkill = {1001041,1001042,1001043}	--核心技能Id
	self.CoreSkill = {1006021,1006021}	--核心技能Id
	self.QTESkill = {1006021}	--QTE技能Id
	--self.DodgeAttack = {1001070,1001071}	--闪避反击技能
	self.JumpAttack = {1006080,1006081}	--闪避反击技能
	self.UltimateSkill = {1006051,1006052}	--大招技能Id
	self.PartnerConnect = {1006999}	--佩从连携技能id
	self.PartnerCall = {1006061,1006062,1006063,1006064} --佩从召唤动作
	self.PartnerHenshin = {1006060} --佩从变身动作集合
	self.CatchSkill = {1006090}	--捕捉技能
	self.RAP.backgroundRes1 = 6.1	--日相回复速度，X秒回复一格，单位：秒

	self.QTEtype = 1			--QTE类型：1切换角色放技能，2不切换角色下场放技能，3AI援助
	self.QTEPosRef = 1			--QTE出场坐标参考：1参考在场角色，2参考其他目标
	self.QTEChangeCD = 1		--QTE/切换角色冷却时间

	self.LockDistance = 15
	self.CancelLockDistance = 30
	self.RAP.jumpCamera = true


	self.NormalSkillFrame = 0	--强化技能释放帧数
	self.CoreNum = {0,0,0}
	self.CoreNumFrame = {0,0,0}

	
	--核心分支相关
	self.CoreBranch = false	--核心分支释放开关
	self.CoreFrame = 0
	self.CoreTime =	12	--核心状态持续时间
	self.CoreMode = false  --核心状态
	self.curSkillBtn = 0	--技能切换缓存id
	
	self.CoreState = 0
	
	self.RAP.FrontDistance = 4
	self.musicStop = false	--普攻连段音乐逻辑
	
	self.perkFrame = 0	--脉象2CD
	
	--*************************张永钢
	--角色语音类型变量
	self.RAP.VoiceAudio_Climb = {"Play_v_qingmenyin_0033"}
	self.RAP.VoiceAudio_Run = {"Play_v_qingmenyin_0035"}
	self.RAP.VoiceAudio_WallRun = {"Play_v_qingmenyin_0037"}
	self.RAP.VoiceAudio_Gliding = {"Play_v_qingmenyin_0039"}
	self.RAP.VoiceAudio_Looting = {"Play_v_qingmenyin_0041"}
	self.RAP.VoiceAudio_Stand1 = {"Play_v_qingmenyin_0043"}
	self.RAP.VoiceAudio_NormalATK = {"Play_v_qingmenyin_0045"}
	
	self.VoiceAudio_NormalSkill = {"Play_v_qingmenyin_0048","Play_v_qingmenyin_0051","Play_v_qingmenyin_0054"}
	
	self.RAP.VoiceAudio_QTESkill = {"Play_v_qingmenyin_0057"}
	self.RAP.VoiceAudio_CoreSkill = {"Play_v_qingmenyin_0059"}
	self.RAP.VoiceAudio_JumpATK = {"Play_v_qingmenyin_0061"}
	self.RAP.VoiceAudio_PartnerATK = {"Play_v_qingmenyin_0063"}
	self.RAP.VoiceAudio_Hit = {"Play_v_qingmenyin_0065"}
	self.RAP.VoiceAudio_LowHP = {"Play_v_qingmenyin_0067"}
	self.RAP.VoiceAudio_Dead = {"Play_v_qingmenyin_0068"}
	--*************************张永钢
	
	self.pulseVal = {
		
	{
		a = 1,
		b = 2,
	},	--一脉
		
	{
		a = 1
	},	--二脉
		
	}
	
	
end

function Behavior1006:LateInit()
	self.RAP:LateInit()
end

function Behavior1006:BeforeUpdate()
	--通用参数组合更新
	self.RAP:BeforeUpdate()
end

function Behavior1006:Update()

	--BehaviorFunctions.SetEntityValue(self.me,"Qingmenyin",self.me)
	--BF.AddEntitySign(self.Me,10061001,-1,false)
	--BF.AddEntitySign(self.Me,10061002,-1,false)
	--BF.AddEntitySign(self.Me,10061003,-1,false)
	--BF.AddEntitySign(self.Me,10061004,-1,false)
	--BF.AddEntitySign(self.Me,10061005,-1,false)
	--BF.AddEntitySign(self.Me,10061006,-1,false)
	
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
		self.RAB.RolePartnerBase:Update()

		self.targetPos = BF.GetPositionP(self.Me)
		
		self:SkillBtnChange()
		
		--角色相机逻辑外接
		self.RAB.RoleCameraParm:Update()
		
		--连击音乐判断
		self:ComboMusic()
		
		self.RoleList = BehaviorFunctions.GetCurFormationEntities()	--获取全队id
		
		
		--青门隐脉象1perk
		if BF.HasEntitySign(self.Me,10061001) then
			--添加加霸体buff的技能触发标记
			if not BF.CheckSkillEventActiveSign(self.Me,1006011006) then
				BF.AddSkillEventActiveSign(self.Me,1006011006)
			end
		end
		
		
		
	end
end


			
			
--重写角色释放技能组合
function Behavior1006:RoleCatchSkill()
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
				or (self.RAP.MyState == FES.Skill and BF.GetSkillConfigSign(self.Me) ~= 50 and BF.GetSkillConfigSign(self.Me) ~= 80 and BF.GetSkillConfigSign(self.Me) ~= 81 and BF.GetSkillConfigSign(self.Me) ~= 170 and BF.GetSkillConfigSign(self.Me) ~= 171)) then
			if self.RAP.MyState == FES.Skill then
				BF.BreakSkill(self.Me)
			end
			if BF.DoJump(self.Me) then
				self.RAB.RoleCatchSkill:ClearButtonPart(ClickButton,"ClearClick")
			end
			--大招释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.UltimateSkill and BF.CheckEntityHeight(self.Me) == 0 then
			if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.UltimateSkill[1],5,3,0,0,0,{0},"Immediately","ClearClick",true) then
				BF.CastSkillCost(self.Me,self.UltimateSkill[1])
				BF.DoEntityAudioPlay(self.Me,"Play_v_qingmenyin_0057",true,FightEnum.SoundSignType.Language)	--播放角色QTE语音
			end
			--闪避释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.Dodge and BF.CheckEntityHeight(self.Me) == 0 then
			if self.RAB.RoleCatchSkill:MoveSkill(ClickButton,3,3,0,0,0,{21},"ClearClick") then
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
			if BF.GetSkillCostValue(self.Me,FK.NormalSkill) >= 1 then
				--if self.RAB.RoleCatchSkill:ContSkill(ClickButton,self.NormalSkill,1,1,1006010,0,0,{0},"Immediately","ClearClick",true) then
					--if self.CoreMode == false then
						--BehaviorFunctions.CastSkillCost(self.Me,1006011)
						
					--end
				--end
				
				if BF.GetSkillCostValue(self.Me,FK.NormalSkill) >= 1 then
					if BF.GetSkillSign(self.Me,1006011) then
						if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalSkill[2],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
							BF.CastSkillCost(self.Me,self.NormalSkill[2])
							
							--*************************张永钢
							if BF.GetEntitySignSound(self.Me,FightEnum.SoundSignType.Language) == nil then
								--BF.DoEntityAudioPlay(self.Me,FightEnum.SoundEventMapKey.VoiceAudio_NormalSkill2,true,FightEnum.SoundSignType.Language)	--播放角色普通技能语音
							end
							--*************************张永钢
							
						end
					elseif BF.GetSkillSign(self.Me,1006012) then
						if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalSkill[3],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
							BF.CastSkillCost(self.Me,self.NormalSkill[3])
							
							--*************************张永钢
							if BF.GetEntitySignSound(self.Me,FightEnum.SoundSignType.Language) == nil then
								--BF.DoEntityAudioPlay(self.Me,FightEnum.SoundEventMapKey.VoiceAudio_NormalSkill3,true,FightEnum.SoundSignType.Language)	--播放角色普通技能语音
							end
							--*************************张永钢
							
						end
					else
						if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalSkill[1],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
							BF.CastSkillCost(self.Me,self.NormalSkill[1])
							
							--*************************张永钢
							if BF.GetEntitySignSound(self.Me,FightEnum.SoundSignType.Language) == nil then
								--BF.DoEntityAudioPlay(self.Me,FightEnum.SoundEventMapKey.VoiceAudio_NormalSkill1,true,FightEnum.SoundSignType.Language)	--播放角色普通技能语音
							end
							--*************************张永钢
						end
					end
				end
				
			end
			--普攻长按释放判断(空中)
		elseif self.RAP.PressButton[PressButton] == FK.Attack and self.RAP.PressButtonFrame[PressButton] >= 7 
			and BF.CheckEntityHeight(self.Me) >= 1 then
			self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.FallAttack[1],170,170,0,0,0,{0},"0","ClearPress",true,0,-1)
			--普攻长按释放判断(地面)
		elseif self.RAP.PressButton[PressButton] == FK.Attack and self.RAP.PressButtonFrame[PressButton] >= 7 then
			if self.RAP.CoreRes >= 3 and self.CoreMode == false then
				if self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.CoreSkill[1],4,4,0,0,0,{0},"Immediately","ClearPress",true,0,-1) then
					--BF.CastSkillCost(self.Me,1204)
				end
			else
				if BF.GetSkillSign(self.Me,1006013) == true then
					if self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.CoreSkill[2],4,4,0,0,0,{0},"Immediately","ClearPress",true,0,-1) then
					
					end
				end
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
			--if BF.HasEntitySign(self.Me,10000000) then
				--if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.DodgeAttack[1],2,2,0,0,0,{0},"Immediately","ClearClick",true) then
					--BF.RemoveEntitySign(self.Me,10000000)
				--end
			--else
			--技能1过程中不允许使用普攻打断

			--self.RAB.RoleCatchSkill:ContSkill(ClickButton,self.NormalAttack,1,1,10000002,0,0,{0},"Immediately","ClearClick",true,0,-1)
			
			if self.RAP.CoreRes < 3 then
				if not BF.GetSkillSign(self.Me,1006011) then
					self.RAB.RoleCatchSkill:ContSkill(ClickButton,self.NormalAttack,1,1,10000002,0,0,{0},"Immediately","ClearClick",true,0,-1)
				end
			else
				if (BF.GetSkill(self.Me) > self.NormalAttack[1] and BF.GetSkill(self.Me) < self.NormalAttack[5])
					or not BF.CheckKeyPress(FK.Attack) then
					if not BF.GetSkillSign(self.Me,1006011) then
						self.RAB.RoleCatchSkill:ContSkill(ClickButton,self.NormalAttack,1,1,10000002,0,0,{0},"Immediately","ClearClick",true,0,-1)
					end
				end
			end
			--end
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

function Behavior1006:Core()

	--检查核心资源率
	self.RAP.CoreResRatio = BF.GetEntityAttrValueRatio(self.Me,1204)
	self.RAP.CoreRes = BF.GetEntityAttrVal(self.Me,1204)
	
	--角色在场逻辑
	if self.RAP.CtrlRole == self.Me then

		BF.SetCoreUIScale(self.Me, 1)
		--BF.SetCoreUIPosition(self.Me, 0, 0)

		--核心UI显示判断
		if (BF.CheckPlayerInFight() or self.RAP.CoreUiFrame > self.RAP.RealFrame ) then
			BF.SetCoreUIVisible(self.Me, true, 0.2)
		else
			if self.CoreMode == false then
				BF.SetCoreUIVisible(self.Me, false, 0.5)
			end
		end
		--全身隐藏显示判断
		if BF.GetSkillSign(self.Me,10010002) and not BF.HasBuffKind(self.Me,1001902) then
			BF.AddBuff(self.Me,self.Me,1001902,1)
		elseif not BF.GetSkillSign(self.Me,10010002) and BF.HasBuffKind(self.Me,1001902) then
			BF.RemoveBuff(self.Me,1001902,5)
		end
	end
	
	--核心时间衰减判断
	if self.CoreNum[1] ~= 0 and self.CoreNumFrame[1] < self.RAP.RealFrame then
		self.CoreNum[1] = 0
		BF.ChangeEntityAttr(self.Me,1204,-1,1)
		self.CoreNumFrame[1] = 0
	end
	if self.CoreNum[2] ~= 0 and self.CoreNumFrame[2] < self.RAP.RealFrame then
		self.CoreNum[2] = 0
		BF.ChangeEntityAttr(self.Me,1204,-1,1)
		self.CoreNumFrame[2] = 0
	end
	if self.CoreNum[3] ~= 0 and self.CoreNumFrame[3] < self.RAP.RealFrame then
		self.CoreNum[3] = 0
		BF.ChangeEntityAttr(self.Me,1204,-1,1)
		self.CoreNumFrame[3] = 0
	end


	----核心UI动效判断
	--if self.RAP.CtrlRole == self.Me and self.RAP.CoreRes >= 3 then
		--BF.SetCoreEffectVisible(self.Me,"22098",true)
	--else
		--BF.SetCoreEffectVisible(self.Me,"22098",false)
	--end
	
	
	--核心状态判断
	if self.CoreMode == true and self.CoreFrame < self.RAP.RealFrame then
		self.CoreBranch = false
		self.CoreMode = false
	end
	
end

--首次命中判断
function Behavior1006:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	local I = BF.GetEntityTemplateId(instanceId)
	if attackInstanceId == self.Me then
		--跳反子弹强制打断敌人技能
		if BF.CheckEntity(hitInstanceId) and I == 1006081001 then
			BF.BreakSkill(hitInstanceId)
		end
		--临时跳反踩踏子弹强制打断敌人技能
		if BF.CheckEntity(hitInstanceId) and I == 1006080001 then
			BF.BreakSkill(hitInstanceId)
		end

		--PV连携特判
		--if self.RAP.PVMode == 1 then
			--if I == 1006012002 then
				--BehaviorFunctions.SetForceCameraAmplitudMultiple(2)	--设置强锁震屏参数
				--BehaviorFunctions.RemoveAllLookAtTarget()--清除所有看向点
				--BehaviorFunctions.SetCameraStateForce(FightEnum.CameraState.ForceLocking,true)	--切换连携强锁
				--BF.SetBodyDamping(0.165,0.5,1)
				--BehaviorFunctions.SetCameraParams(FightEnum.CameraState.ForceLocking,100601202,false)	--设置相机参数
				--BF.AddLookAtTarget(hitInstanceId,"HitCase")	--设置看向点为怪物
				--BF.SetLookAtTargetWeight(hitInstanceId,"HitCase",1)	--设置看向点权重
				--self.curLookAtTarget = hitInstanceId	--缓存看向点
			--end
		--end		
		
		if I == 1006011003 then
			--BF.DoPreciseMove(hitInstanceId, attackInstanceId, 0,-BF.CheckEntityHeight(self.Me),1, 4)
		
		end
		
		if I == 1006011002 then
			--BF.DoPreciseMove(hitInstanceId, attackInstanceId, 0,-BF.CheckEntityHeight(self.Me),-0.5, 4)

		end
		
		--判定为大招第一段,大招聚怪
		if I == 1006051001 then
			BF.DoPreciseMove(hitInstanceId, attackInstanceId, 0.5, 0, 0, 4)
		end
		
		--技能最后一段命中
		if I == 1006013005 then
			local x,y,z = BehaviorFunctions.GetEntityTransformPos(hitInstanceId,"HitCase")
			--local x,y,z = BF.GetPosition(self.flowerId)	--获得缓存的
			
			local bullet1 = BF.CreateEntity(1006013013,self.Me,x,y,z)
			BF.AddEntityEuler(bullet1,-75,60,-75)
			local bullet2 = BF.CreateEntity(1006013014,self.Me,x,y,z)
			BF.AddEntityEuler(bullet2,-150,60,-150)
			local bullet3 = BF.CreateEntity(1006013015,self.Me,x,y,z)
			BF.AddEntityEuler(bullet3,75,60,75)
			local bullet4 = BF.CreateEntity(1006013016,self.Me,x,y,z)
			BF.AddEntityEuler(bullet4,150,60,150)
			local bullet5 = BF.CreateEntity(1006013017,self.Me,x,y,z)
			BF.AddEntityEuler(bullet5,225,60,225)
			
			BF.SetAttackCheckList(bullet1, {})
			BF.SetAttackCheckList(bullet2, {})
			BF.SetAttackCheckList(bullet3, {})
			BF.SetAttackCheckList(bullet4, {})
			BF.SetAttackCheckList(bullet5, {})
			BF.AddDelayCallByFrame(3,BehaviorFunctions,BehaviorFunctions.SetAttackCheckList,bullet1,{hitInstanceId})
			BF.AddDelayCallByFrame(3,BehaviorFunctions,BehaviorFunctions.SetAttackCheckList,bullet2,{hitInstanceId})
			BF.AddDelayCallByFrame(3,BehaviorFunctions,BehaviorFunctions.SetAttackCheckList,bullet3,{hitInstanceId})
			BF.AddDelayCallByFrame(3,BehaviorFunctions,BehaviorFunctions.SetAttackCheckList,bullet4,{hitInstanceId})
			BF.AddDelayCallByFrame(3,BehaviorFunctions,BehaviorFunctions.SetAttackCheckList,bullet5,{hitInstanceId})
			
			if hitInstanceId then
				BF.SetEntityTrackTarget(bullet1,hitInstanceId)
				BF.SetEntityTrackTarget(bullet2,hitInstanceId)
				BF.SetEntityTrackTarget(bullet3,hitInstanceId)
				BF.SetEntityTrackTarget(bullet4,hitInstanceId)
				BF.SetEntityTrackTarget(bullet5,hitInstanceId)
			end
		end
		
		
		if I == 100601305 then
			--脉象5perk
			if BF.HasEntitySign(self.Me,10061005) then
				BF.DoMagic(self.Me,hitInstanceId,10061005,1,nil,nil,self.Me)
				for i,v in pairs(self.RoleList) do
					BF.DoMagic(self.Me,self.RoleList[i],10061007,1)	--治疗
				end
			end
		end
	end
end

--属性变化判断
function Behavior1006:ChangeAttrValue(attrType,attrValue,changedValue)
	if attrType == 1204 then
		self.RAP.CoreUiFrame = self.RAP.RealFrame + 90
		--if changedValue ~= 0 then
		--self:CorePart(changedValue)
		--end
	end
end

--通用闪避成功判断
function Behavior1006:Dodge(attackInstanceId,hitInstanceId,limit)
	if hitInstanceId == self.Me and limit == true then
		if self.CoreMode == false then
			BF.ChangeEntityAttr(self.Me,1204,1,1)
		end
		--BF.ChangeEntityAttr(self.Me,1204,75,1)
		--BF.AddEntitySign(hitInstanceId,10000000,90) --角色3秒内反击标记
		
		--perk2极限闪避后获得三层被动，冷却时间A秒
		if BF.HasEntitySign(self.Me,10061002) then
			if BF.CheckEntityInFormation(hitInstanceId) then
				if self.RAP.CoreRes < 3 and self.CoreMode == false and self.perkFrame < self.RAP.RealFrame then
					BF.ChangeEntityAttr(self.Me,1204,3,1)
					local val = BF.GetMagicValue(self.Me,10061002,1)	--获取冷却时间
					self.perkFrame = self.RAP.RealFrame + val * 30
				end
			end
		end
	end
end

--技能窗口接收
function Behavior1006:AddSkillSign(instanceId,sign)
	if instanceId == self.Me then
		if sign == 1006010 then
			
		end
		
		--进入核心判断
		if sign == 1006020 and self.CoreMode == false then
			BF.SetCoreEffectVisible(self.Me,"22099",false)
			BF.SetCoreEffectVisible(self.Me,"22099",true)
			BF.ChangeEntityAttr(self.Me,1204,-3,1)	--总-3
			self.CoreMode = true	--开启核心模式
			BehaviorFunctions.ShowCoreUIEffect(self.Me, 1)
			self.CoreFrame = self.RAP.RealFrame + self.CoreTime * 30	--核心模式计时
			--青门隐脉象2
			if BF.HasEntitySign(self.Me,10061002) then
				for i,v in pairs(self.RoleList) do
					BF.DoMagic(self.Me,self.RoleList[i],1006020,1)	--减伤buff
				end
			else
				BF.DoMagic(self.Me,self.Me,1006020,1)
			end
		end
		
		
		if sign == 1006022 then
			BF.DoSetPositionP(instanceId,self.targetPos)
			--BF.CastSkillByTarget()
		end
		
		--if sign == 10000012 then
			--BehaviorFunctions.SetFightPanelVisible("-1")--移除UI隐藏
		--end
		
		----大招治疗开始生效
		--if sign == 100605101 then
			----给全队加上光环buff
			--for i,v in pairs(self.RoleList) do 
				--BF.DoMagic(self.Me,self.RoleList[i],1000094,1)	--大招光环buff
			--end
			--self.cureArea = true
		--end
		
		--核心治疗窗口
		if sign == 1000091 then
			--给全队上核心治疗
			--给全队加上光环buff
			local skillLevel = BF.GetEntitySkillLevel(self.Me,1006021)	--获取核心技能等级
			for i,v in pairs(self.RoleList) do
				BF.DoMagic(self.Me,self.RoleList[i],1006021002,skillLevel)	--核心治疗
			end
		end
	end
end

--获取技能窗口
function Behavior1006:SkillBtnChange()
	if BF.GetSkillSign(self.Me,1006011) then
		if self.curSkillBtn ~= 1006012 then
			BehaviorFunctions.SetFightUISkillBtnId(self.Me,FK.NormalSkill,1006012)
			BF.PlaySkillUIEffect("Effect/UI/22156_qingmenyin.prefab", "I")
			self.curSkillBtn = 1006012
		end
	elseif BF.GetSkillSign(self.Me,1006012) then
		if self.curSkillBtn ~= 1006013 then
			BehaviorFunctions.SetFightUISkillBtnId(self.Me,FK.NormalSkill,1006013)
			self.curSkillBtn = 1006013
			BF.PlaySkillUIEffect("Effect/UI/22157_qingmenyin.prefab", "I")
		end
	else
		if self.curSkillBtn ~= 1006011 then
			BehaviorFunctions.SetFightUISkillBtnId(self.Me,FK.NormalSkill,1006011)
			self.curSkillBtn = 1006011
		end
	end
end

--技能释放判断
function Behavior1006:CastSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.Me then
		if skillId == 1006010 then
			self.NormalSkillFrame = self.RAP.RealFrame + 35
		end
		
		if (((skillSign ~= 30 and skillSign ~= 31) and not BF.CheckPlayerInFight()) or BF.CheckPlayerInFight()) then
			self.RAP.CoreUiFrame = self.RAP.RealFrame + 90
			--BF.ChangeEntityAttr(self.Me,1206,-250,1)
			--self.ChangeLockTargetFrame = 0 --闪避重置切换锁定目标间隔时间
		end
		
		if skillSign == 10 and self.CoreMode == false then
			BF.ChangeEntityAttr(self.Me,1204,1,1)
		end

		if skillId == 1006011 then
			self.CoreState = 1
		elseif skillId == 1006012 then
			self.CoreState = 2
		elseif skillId == 1006013 then
			self.CoreState = 3
		else
			self.CoreState = 0
		end
		
		if instanceId == self.Me and (((skillSign ~= 30 and skillSign ~= 31) and not BF.CheckPlayerInFight()) or BF.CheckPlayerInFight()) then
			self.RAP.CoreUiFrame = self.RAP.RealFrame + 90
			--BF.ChangeEntityAttr(self.Me,1206,-250,1)
			--self.ChangeLockTargetFrame = 0 --闪避重置切换锁定目标间隔时间
		end
		
		if skillId == 1006081 then
			BF.SetCameraParams(FE.CameraState.ForceLocking,10000006,false)
		end
	end
end


--普攻3连击音乐判断
function Behavior1006:ComboMusic()
	--判断是否正在连击流程
	if BF.HasEntitySign(self.Me,1006003) then
		--如果普攻断掉了
		if BF.GetSkillSign(self.Me,1006003) ~= true then
			--判断还没暂停过
			if self.musicStop == false then
				BehaviorFunctions.DoEntityAudioStop(self.Me, "QingmenyinR31M11_Atk003_Music",0.5,0.5)
				self.musicStop = true	--标记为已经暂停了
				BF.RemoveEntitySign(self.Me,1006003)	--移除正在释放普攻连击的标记
			end
		--如果普攻没断正常播
		else
			self.musicStop = false
		end
	else
		self.musicStop = false
	end
	
end

----更换治疗子弹阵营
--function Behavior1006:KeyFrameAddEntity(instanceId,entityId)
	--if entityId == 1006051011 then
		--BehaviorFunctions.ChangeCamp(instanceId,2)
	--end
--end



function Behavior1006:BreakSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.Me then
		if skillId == 1006012 and self.RAP.PVMode == 1 then
			if self.curLookAtTarget and self.curLookAtTarget ~= 0 then
				if BF.CheckEntity(self.curLookAtTarget) then
					BF.RemoveLookAtTarget(self.curLookAtTarget,"HitCase")	--移除看向点
				end
			end
			--BehaviorFunctions.SetVCCameraBlend("ForceLockingCamera","OperatingCamera",0.5)
			BehaviorFunctions.SetCameraStateForce(1,false)	--设置操作相机并解锁
		end	
		
		if skillId == 1006081 then
			BF.SetCameraParams(FE.CameraState.ForceLocking) --重置强锁定镜头参数
		end	
	end
end



function Behavior1006:FinishSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.Me then
		if skillId == 1006012 and self.RAP.PVMode == 1 then
			if self.curLookAtTarget and self.curLookAtTarget ~= 0 then
				if BF.CheckEntity(self.curLookAtTarget) then
					BF.RemoveLookAtTarget(self.curLookAtTarget,"HitCase")	--移除看向点
				end
			end
			--BehaviorFunctions.SetVCCameraBlend("ForceLockingCamera","OperatingCamera",0.5)
			BehaviorFunctions.SetCameraStateForce(1,false)	--设置操作相机并解锁
		end
		
		if skillId == 1006081 then
			BF.SetCameraParams(FE.CameraState.ForceLocking) --重置强锁定镜头参数
		end
	end
end

function Behavior1006:KeyFrameAddEntity(instanceId,entityId)
	if entityId == 100601304 then
		self.flowerId = instanceId	--缓存花朵ID
	end
end

--获取计算公式参数前
function Behavior1006:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)
	if ownerInstanceId == self.Me then
		--脉象3perk
		if BF.HasEntitySign(self.Me,10061003) then
			if BF.AnalyseSkillType(BF.GetDamageParam(FE.DamageInfo.SkillType),FE.SkillType.Skill) then
				local val1 = BF.GetEntityAttrVal(self.Me,34)	--获取当前治疗加成
				local val2 = BF.GetMagicValue(self.Me,10061003,1,1)	--获取转换率，50
				BF.ChangeDamageParam(FE.DamageParam.TempCrit,val2 * 100 * val1)	--每1%治疗加0.5%暴击率
			--	BF.ChangeDamageParam(FE.DamageParam.CritDmgPercent,val1 * 0.3)	--每1点治疗加0.3暴击加成
			end
		end
		
		--脉象6加爆伤
		if BF.HasEntitySign(self.Me,10061006) then
			if BF.GetBuffCount(self.Me,10061008) > 0 then
				if BF.AnalyseSkillType(BF.GetDamageParam(FE.DamageInfo.SkillType),FE.SkillType.Skill) then
					local val1 = BF.GetMagicValue(self.Me,10061006,1,1)
					BF.ChangeDamageParam(FE.DamageParam.CritDmgPercent,val1)	--3秒内，E爆伤增加120%
				end
			end
		end
	end
end

--获取治疗公式前
function Behavior1006:BeforeCalculateCure(healer,treatee,magicId)
	if healer == self.Me then
		--脉象4perk，大招增加10%治疗量
		if BF.HasEntitySign(self.Me,10061004) then
			--治疗子弹
			if magicId == 1006051001 then
				local val1 = BF.GetMagicValue(self.Me,10061004,1,1)
				local val2 = BF.GetMagicValue(self.Me,10061004,2,1)
				BF.ChangeCureParam(FE.CureParam.SkillPercent, val2)	--加治疗
				BF.AddSkillPoint(self.Me,1201,val1)	--恢复一格日相
			end
		end
	end
end


--治疗结束
function Behavior1006:AfterCure(healer,treatee,magicId,cure)
	if BF.HasEntitySign(self.Me,10061006) then
		if healer == self.Me and BF.CheckEntityInFormation(treatee) then
			if self.CoreMode == true then
				BF.DoMagic(self.Me,self.Me,10061008)
			end
		end
	end
end

--脉象相关
function Behavior1006:AddEntitySign(instanceId,sign)
	if instanceId == self.Me then
		if sign == 10061002 then
			BF.DoMagic(self.Me,self.Me,10061002)	--perk2参数
		end
		
		if sign == 10061003 then
			BF.DoMagic(self.Me,self.Me,10061003)	--perk3参数
		end
		
		if sign == 10061004 then
			BF.DoMagic(self.Me,self.Me,10061004)	--perk4参数
		end
		
		if sign == 10061006 then
			BF.DoMagic(self.Me,self.Me,10061006)	--perk6参数
		end
	end
end