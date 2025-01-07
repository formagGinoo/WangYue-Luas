RolePartnerBase = BaseClass("RolePartnerBase",EntityBehaviorBase)

local BF = BehaviorFunctions
local FE = FightEnum
local FK = FightEnum.KeyEvent
local FEMSS = FightEnum.EntityMoveSubState
local FESS = FightEnum.EntitySwimState
local FES = FightEnum.EntityState
local FECS = FightEnum.EntityClimbState
local FEAET = FightEnum.AnimEventType
local FEET = FightEnum.ElementType
local FEPA = FightEnum.PlayerAttr
local EACAT = EntityAttrsConfig.AttrType

--佩从集合
function RolePartnerBase:Init()
	
	self.Me = self.instanceId	--记录自己
	--通用参数组合初始化

	self.RAB = self.ParentBehavior
	self.RAP = self.MainBehavior.RoleAllParm
	self.curButtonPress = 0	--长按按钮
	--self.partnerAttack = {}
	self.skillType = 1	--默认为召唤型佩从
	self.switchType = 0	--默认不切换技能
	self.hideState = 0	--不处于钻地
	self.curRolePerform = 1		--默认表演
	self.diyueHand = "Bip001 R Hand"	--默认绑右手
	self.keyPressFrame = 0
	self.partnerShow = false
end

function RolePartnerBase:Update()
	
	self.partner = BF.GetPartnerInstanceId(self.Me)		--获取仲魔id
	
	--潜行类型仲魔获取钻地状态
	if self.partner and self.partnerId == 610025 then
		self.hideState = BF.GetEntityValue(self.partner,"hideState")
	end

	--穿上时获取仲魔相关信息，卸下时重置
	if self.partner then
		self.partnerId = BF.GetEntityTemplateId(self.partner)	--获取实体id
		self.curRolePerform = BF.GetEntityValue(self.partner,"curRolePerform")	--获取佩从表演类型
		self.partnerType = BF.GetEntityValue(self.partner,"partnerType")	--获取佩从类型
		self.showType = BF.GetEntityValue(self.partner,"showType")	--获取当前技能类型
		--self.Frozen = BehaviorFunctions.GetEntityValue(self.Me,"Frozen")	--获取角色冰冻状态
	else
		self.partnerId = 0
	end
	
	--缓存缔约挂点
	if self.curRolePerform == 2 or self.curRolePerform == 4 then
		self.diyueHand = "Bip001 L Hand"	--后召唤用左手
	else
		self.diyueHand = "Bip001 R Hand"	--其他情况用左手
	end
	
	
	
	BF.SetEntityValue(self.Me,"diyueHand",self.diyueHand)
end

--佩从技能释放
function RolePartnerBase:PartnerSkill(ClickType)
	--不在钻地中且不处于暗杀状态下
	if self.hideState ~= 1 and not BF.HasEntitySign(self.Me,62001001) then
		--角色佩从技能必须在地面释放
		if BF.CheckEntityHeight(self.Me) == 0 then
			if self.curRolePerform ~= 0 then
				--如果进来的没有用通用AI，默认使用后动作
				if not self.curRolePerform then
					self.curRolePerform = 2
				end
				--判断当前佩从技能槽的技能类型
				if self.showType == 3 then
				--召唤在场攻击
					if BF.CheckBtnUseSkill(self.partner,FK.Partner) then
						if self.RAB.RoleCatchSkill:ActiveSkill(ClickType,self.MainBehavior.PartnerCall[self.curRolePerform],4,4,0,0,0,{0},"Immediately","ClearClick",true) then
							--BF.DoEntityAudioPlay(self.Me,FightEnum.SoundEventMapKey.VoiceAudio_PartnerATK,true,FightEnum.SoundSignType.Language)	--播放角色配从技能语音
							self.RAB.RoleClickButtonCache:ClearPressButtonRecord(FK.Partner)	--释放结束清除长按判断
						end
					end
				--召唤出场动作
				elseif self.showType == 2 then	
					if self.RAB.RoleCatchSkill:ActiveSkill(ClickType,self.MainBehavior.PartnerCall[self.curRolePerform],4,4,0,0,0,{0},"Immediately","ClearClick",true) then
						self.curButtonPress = ClickType
						self.RAB.RoleClickButtonCache:ClearPressButtonRecord(FK.Partner)	--释放结束清除长按判断
						--BF.DoEntityAudioPlay(self.Me,FightEnum.SoundEventMapKey.VoiceAudio_PartnerATK,true,FightEnum.SoundSignType.Language)	--播放角色配从技能语音
					end
				--变身类型
				elseif self.showType == 1 then
					if self.RAB.RoleCatchSkill:ActiveSkill(ClickType,self.MainBehavior.PartnerHenshin[1],4,4,0,0,0,{0},"Immediately","ClearClick",true) then
						-- BF.DoEntityAudioPlay(self.Me,FightEnum.SoundEventMapKey.VoiceAudio_PartnerATK,true,FightEnum.SoundSignType.Language)	--播放角色配从技能语音
					end
				--附身类型
				elseif self.showType == 4 or self.partnerType == 4 then
					if self.RAB.RoleCatchSkill:ActiveSkill(ClickType,self.MainBehavior.PartnerCall[self.curRolePerform],4,4,0,0,0,{0},"Immediately","ClearClick",true) then
						self.curButtonPress = ClickType
						self.RAB.RoleClickButtonCache:ClearPressButtonRecord(FK.Partner)	--释放结束清除长按判断
						--BF.DoEntityAudioPlay(self.Me,FightEnum.SoundEventMapKey.VoiceAudio_PartnerATK,true,FightEnum.SoundSignType.Language)	--播放角色配从技能语音
					end
				--单次召唤
				--elseif self.showType == 0 then
					--if self.RAB.RoleCatchSkill:ActiveSkill(ClickType,self.MainBehavior.PartnerCall[self.curRolePerform],4,4,0,0,0,{0},"Immediately","ClearClick",true) then
						---- BF.DoEntityAudioPlay(self.Me,FightEnum.SoundEventMapKey.VoiceAudio_PartnerATK,true,FightEnum.SoundSignType.Language)	--播放角色配从技能语音
					--end
				end
			end
		end
		
		--特判
		--if self.partnerId == 600050 then
			--if self.RAB.RoleCatchSkill:ActiveSkill(ClickType,1002998,4,4,0,0,0,{0},"Immediately","ClearClick",true) then
				--BF.CastSkillBySelfPosition(self.Me,1002998)
			--end
		--end
	end
end


--点按检查
function RolePartnerBase:KeyInput(key, status)
	if self.partnerType == 2 then
		if key == FK.Partner and status == FightEnum.KeyInputStatus.Down then
			--按下的时候如果佩从不在场
			if self.partner and not BF.CheckPartnerShow(self.Me) then
				self.partnerShow = false
			elseif self.partner and BF.CheckPartnerShow(self.Me) then
				self.partnerShow = true
				self.keyPressFrame = self.RAP.RealFrame	--记录按键时间
			end
		end
		
		if key == FK.Partner and status == FightEnum.KeyInputStatus.Up then
			--如果现在的佩从是召唤佩从处于在场状态，没有在退场，并且是召唤类型的佩从，点按召回(三帧内)
			if self.partner and self.partnerShow and self.keyPressFrame + 3 >= self.RAP.RealFrame then
				if BF.CheckPartnerShow(self.Me) and not BF.HasEntitySign(self.partner,600002) then
					BF.AddEntitySign(self.partner,600000020,-1,false)	--佩从退场标记
				end
			end
		end
	end
end