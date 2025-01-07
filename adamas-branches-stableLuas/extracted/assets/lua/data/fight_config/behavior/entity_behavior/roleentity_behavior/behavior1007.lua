Behavior1007 = BaseClass("Behavior1007",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType

function Behavior1007.GetGenerates()
	local generates = {
		100701,100702
	}
	return generates
end
function Behavior1007.GetOtherAsset()
	local generates = {
		BehaviorFunctions.GetEffectPath("22099"),
		BehaviorFunctions.GetEffectPath("22097"),
		BehaviorFunctions.GetEffectPath("22096"),
		BehaviorFunctions.GetUIEffectPath("UI_SkillPanel_jiuxu"),
		--BehaviorFunctions.GetEffectPath("22059"),
		--"Effect/UI/22060.prefab"
		"UIEffect/Prefab/UI_SkillPanel_changan.prefab",
	}
	return generates
end

function Behavior1007:Init()
	--变量声明
	self.Me = self.instanceId		--记录自己

	--普攻技能Id
	self.NormalAttack = {1007001,1007002,1007003,1007004,1007005}
	self.NormalSkill = {1007011,1007012}	--普通技能Id
	self.MoveSkill = {1007030,1007031}	--闪避技能Id
	self.FallAttack = {1007170,1007171,1007172}	--下落攻击Id
	--self.AirAttack = {1001101,1001102,1001103}	--空中攻击Id
	--self.LeapAttack = {1001160}	--起跳攻击Id
	self.CoreSkill = {1007040,1007041,1007042}	--核心技能Id
	self.QTESkill = {1001060}	--QTE技能Id
	--self.DodgeAttack = {1001070,1001071}	--闪避反击技能
	self.JumpAttack = {1007080,1007081}	--闪避反击技能
	self.UltimateSkill = {1007051}	--大招技能Id
	self.PartnerConnect = {1007999}	--佩从连携技能id
	self.PartnerCall = {1007061,1007062,1007063,1007064} --佩从召唤动作
	self.PartnerHenshin = {1007060} --佩从变身动作集合
	self.CatchSkill = {1007090}	--捕捉技能
	
	
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
	
	
	self.test = 0
	self.coreState = 0
	self.curSkillBtn = 0
	
	self.WeaponPos = 0 --武器坐标
	self.Umbrella = 0 --技能1扔的伞
	self.NormalSkillState = 0
	self.TargetPos = 0
	self.TargetOffset = 0,0,0
	
	self.XianHe = 0 --四只仙鹤
	self.XianHe2 = 0
	self.XianHe3 = 0
	self.XianHe4 = 0
	
	self.XH = 0 --四只仙鹤的坐标
	self.XH2 = 0
	self.XH3 = 0
	self.XH4 = 0
	
	self.H1 = 0.2 --仙鹤出生位置偏差值
	self.H2 = 0.7
	
	--PERK伞舞值积累效率乘数
	self.CorePERK = 0
	
	--核心上挑减能量用参数
	self.coretimestate = 0
	self.frame = 0
	
	--*************************张永钢
	--角色语音类型变量
	self.RAP.VoiceAudio_Climb = {"Play_v_zhuishi_0033"}
	self.RAP.VoiceAudio_Run = {"Play_v_zhuishi_0035"}
	self.RAP.VoiceAudio_WallRun = {"Play_v_zhuishi_0037"}
	self.RAP.VoiceAudio_Gliding = {"Play_v_zhuishi_0039"}
	self.RAP.VoiceAudio_Looting = {"Play_v_zhuishi_0041"}
	self.RAP.VoiceAudio_Stand1 = {"Play_v_zhuishi_0043"}
	self.RAP.VoiceAudio_NormalATK = {"Play_v_zhuishi_0045"}

	self.VoiceAudio_NormalSkill = {"Play_v_zhuishi_0048"}

	self.RAP.VoiceAudio_QTESkill = {"Play_v_zhuishi_0051"}
	self.RAP.VoiceAudio_CoreSkill = {"Play_v_zhuishi_0053"}
	self.RAP.VoiceAudio_JumpATK = {"Play_v_zhuishi_0055"}
	self.RAP.VoiceAudio_PartnerATK = {"Play_v_zhuishi_0057"}
	self.RAP.VoiceAudio_Hit = {"Play_v_zhuishi_0059"}
	self.RAP.VoiceAudio_LowHP = {"Play_v_zhuishi_0061"}
	self.RAP.VoiceAudio_Dead = {"Play_v_zhuishi_0062"}
	--*************************张永钢
end

function Behavior1007:LateInit()
	self.RAP:LateInit()
end

function Behavior1007:BeforeUpdate()
	--通用参数组合更新
	self.RAP:BeforeUpdate()
end

function Behavior1007:Update()
	
	--BF.AddEntitySign(self.Me,10071006,-1,false)
	
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

		
		self:CoreSkillRelease()
		
		--角色通用配从判断
		self.RAB.RolePartnerBase:Update()
		
		--角色相机逻辑外接
		self.RAB.RoleCameraParm:Update()
		
		--主动技能1，扔伞
		self:Attack011()
		self:SkillBtnChange()
		
		--核心能量消耗计时（上挑减能量用）
		self:CoreUITimeCount()
		
		
	end
end

--技能被打断
function Behavior1007:BreakSkill(instanceId,skillId,skillSign,skillType)
	
	--BF.AddEntitySign(self.Me,10071001,-1,false)
	--BF.AddEntitySign(self.Me,10071004,-1,false)
	--BF.AddEntitySign(self.Me,10071003,-1,false)
	--BF.AddEntitySign(self.Me,10071005,-1,false)
	
	if instanceId == self.Me then
		--核心技能40被打断，且有扔伞实体标记
		if skillId == 1007040 and not BF.HasEntitySign(self.Me,100700401) then
			BehaviorFunctions.RemoveKeyPress(FK.Attack)
			self.RAP.PressButton[1] = 0
			self.coreState = 0
			--核心动效暂停
			BehaviorFunctions.ShowCoreUIEffect(self.Me,"CoreUI1007_nengliang",true,0)
			if BF.HasEntitySign(self.Me,10070040) then
				self.WeaponPos = BF.GetWeaponPosition(self.Me,"wuqi_000") --获取武器坐标
			end
		end
		if skillId == 1007041 and BF.HasEntitySign(self.Me,10070041) then
			self.WeaponPos = BF.GetWeaponPosition(self.Me,"wuqi_000") --获取武器坐标
			BehaviorFunctions.RemoveKeyPress(FK.Attack)
			self.RAP.PressButton[1] = 0
			self.coreState = 0
			--核心动效暂停
			BehaviorFunctions.ShowCoreUIEffect(self.Me,"CoreUI1007_nengliang",true,0)
		end
		--普攻4\5或技能11被打断，且有扔伞实体标记
		if skillId == 1007004 and BF.HasEntitySign(self.Me,10070004) then
			self.WeaponPos = BF.GetWeaponPosition(self.Me,"wuqi_000") --获取武器坐标
		end
		if skillId == 1007005 and BF.HasEntitySign(self.Me,10070005) then
			self.WeaponPos = BF.GetWeaponPosition(self.Me,"wuqi_000") --获取武器坐标
		end
		if skillId == 1007011 and BF.HasEntitySign(self.Me,10070011) then
			self.WeaponPos = BF.GetWeaponPosition(self.Me,"wuqi_000") --获取武器坐标
		end
	end
end

--角色个人判断
function Behavior1007:Core()
	
	
	--PERK▲伞舞值积攒速度提升a%。
	if BF.HasEntitySign(self.Me,10071002) and not BF.HasEntitySign(self.Me,10071006) then
		local v = BF.GetMagicValue(self.Me,10071001,1,1)
		self.CorePERK = 1 + v/10000 --积累系数，目前所有加伞舞值的地方都乘了
	elseif BF.HasEntitySign(self.Me,10071006) then
		local v = BF.GetMagicValue(self.Me,10071005,1,1)
		self.CorePERK = 1 + v/10000 --积累系数，目前所有加伞舞值的地方都乘了
	else
		self.CorePERK = 1
	end
	
	--PERK▲法阵增伤效果提升至a%，并且给处于法阵的敌人每秒造成攻击力b%的火属性伤害。
	if BF.HasEntitySign(self.Me,10071004) then
		BF.AddSkillEventActiveSign(self.Me,100705102)
		BF.RemoveSkillEventActiveSign(self.Me,100705101)
	else
		BF.AddSkillEventActiveSign(self.Me,100705101)
		BF.RemoveSkillEventActiveSign(self.Me,100705102)
	end
	
	--PERK▲加快追识进入伞刃强化状态：伞舞值达到达到a%进度时即可进入红刃状态，并且闪刃旋转速度提高b%。
	if BF.HasEntitySign(self.Me,10071006) then
		BF.AddSkillEventActiveSign(self.Me,100706102)
		BF.RemoveSkillEventActiveSign(self.Me,100706101)
		local v1 = BF.GetMagicValue(self.Me,10071004,1,1)
		local v2 = BF.GetMagicValue(self.Me,10071004,2,1)
		BF.SwitchSetCorUIPercentDivide(self.Me,v1,v2)
	else
		BF.AddSkillEventActiveSign(self.Me,100706101)
		BF.RemoveSkillEventActiveSign(self.Me,100706102)	
		BF.SwitchSetCorUIPercentDivide(self.Me, 0.5,0.5)
	end
	
	
	
	--PERK▲追识在后台时，出战角色被控制状态下E技能也可以释放，会直接解除当前角色的控制效果并且切换追识上场。
	--BF.AddEntitySign(self.Me,10071001,-1)
	if BF.HasEntitySign(self.Me,10071001) then
		--if BF.HasBuffKind(self.RAP.CtrlRole,5001) and self.Me ~= self.RAP.CtrlRole and BF.CheckKeyDown(FK.NormalSkill) then
		if BF.HasBuffKind(BF.GetCtrlEntity(),5001)
			 and BF.GetCtrlEntity() ~= self.Me 
			and BF.CheckKeyDown(FK.NormalSkill) then
		    BF.RemoveBuffByKind(self.RAP.CtrlRole,5001)
			BF.RemoveBuffByKind(self.RAP.CtrlRole,50001)
			--BF.StopQTEUIEffect(qteId, "UI_QTE_bingdong", "QTEEffect") --等于畅支持
			--BF.AddBuff(self.Me,self.Me,1000039,1)--冰冻抗性
			BF.SetEntityComponentEnable(self.RAP.CtrlRole, CS.DynamicBones, true, true)
			--Bsdehavior1000001:ChangeRole(QTEIndex,Role1,Role2)
			local I = BF.GetEntityQTEIndex(self.Me)
			BF.CallBehaviorFuncByEntity(1,"ChangeRole",I,self.RAP.CtrlRole,self.Me)
			self.RAB.RoleCatchSkill:ActiveSkill(0,self.NormalSkill[1],3,3,0,0,0,{0},"Immediately","ClearClick",true,0,-1)
			self.NormalSkillState = 1
			BF.AddEntitySign(self.Me,1007010001,-1) --受困反击标志
			--PERK▲成功在被困状态下释放E技能，会补充a格日相。
			if BF.HasEntitySign(self.Me,10071005) then
				local v = BF.GetMagicValue(self.Me,10071003,1,1)
				BF.AddSkillPoint(self.Me,1201,v) --2格
			end			
		end
		if BF.HasBuffKind(BF.GetCtrlEntity(),5002) and self.Me ~= BF.GetCtrlEntity() and BF.CheckKeyDown(FK.NormalSkill) then
			BF.RemoveBuffByKind(self.Me,5002)
			--BF.StopQTEUIEffect(qteId, "UI_QTE_xuanyun", "QTEEffect")--等于畅支持
			BF.AddBuff(self.Me,self.Me,1000040,1)--眩晕抗性
			local I = BF.GetEntityQTEIndex(self.Me)
			BF.CallBehaviorFuncByEntity(1,"ChangeRole",I,self.RAP.CtrlRole,self.Me)
			self.RAB.RoleCatchSkill:ActiveSkill(0,self.NormalSkill[1],3,3,0,0,0,{0},"Immediately","ClearClick",true,0,-1)
			self.NormalSkillState = 1
			BF.AddEntitySign(self.Me,1007010001,-1) --受困反击标志
			--PERK▲成功在被困状态下释放E技能，会补充a格日相。
			if BF.HasEntitySign(self.Me,10071005) then
				BF.AddSkillPoint(self.Me,1201,1) --临时1格
			end
		end
		if BF.HasBuffKind(BF.GetCtrlEntity(),5003) and self.Me ~= BF.GetCtrlEntity() and BF.CheckKeyDown(FK.NormalSkill) then
			BF.RemoveBuffByKind(self.Me,5003)
			--BF.StopQTEUIEffect(qteId, "UI_QTE_meihuo", "QTEEffect")--等于畅支持
			BF.AddBuff(self.Me,self.Me,1000070,1)--魅惑抗性
			local I = BF.GetEntityQTEIndex(self.Me)
			BF.CallBehaviorFuncByEntity(1,"ChangeRole",I,BF.GetCtrlEntity(),self.Me)
			self.RAB.RoleCatchSkill:ActiveSkill(0,self.NormalSkill[1],3,3,0,0,0,{0},"Immediately","ClearClick",true,0,-1)
			self.NormalSkillState = 1
			BF.AddEntitySign(self.Me,1007010001,-1) --受困反击标志
			--PERK▲成功在被困状态下释放E技能，会补充a格日相。
			if BF.HasEntitySign(self.Me,10071005) then
				BF.AddSkillPoint(self.Me,1201,1) --临时1格
			end
		end
	end
	
	----PERK▲成功在被困状态下释放E技能，会补充a格日相。
	--if BF.HasEntitySign(self.Me,10071005) and BF.HasEntitySign(self.Me,1007010001) then
		----BF.ChangeEntityAttr(self.Me,1201,10000)
		--BF.AddSkillPoint(self.Me,1201,1) --临时1格
	--end
	
	--扔伞期间实体标记
	if BF.HasEntitySign(self.Me,10070004) then
		--连段衔接判断
		if self.RAP.MyState == FES.Skill and self.RAP.CurrentSkill == 1007005 then
			BF.RemoveEntitySign(self.Me,10070004)
		--扔伞期间被非衔接技能打断，则伞消失&播放消失特效
		elseif self.RAP.MyState ~= FES.Skill or (self.RAP.MyState == FES.Skill and self.RAP.CurrentSkill ~= 1007004) then
			BehaviorFunctions.WeaponPreciseTargetPointMove(self.Me,"wuqi_000",false,true,nil,0,999,0) --武器回手
			BF.CreateEntityByEntity(self.Me,10070000001,self.WeaponPos.x,self.WeaponPos.y,self.WeaponPos.z) --释放武器消失特效
			BF.RemoveEntitySign(self.Me,10070004)
		end
	end
	if BF.HasEntitySign(self.Me,10070006) then
		if self.RAP.MyState ~= FES.Skill or (self.RAP.MyState == FES.Skill and self.RAP.CurrentSkill ~= 1007005) then
			BehaviorFunctions.WeaponPreciseTargetPointMove(self.Me,"wuqi_000",false,true,nil,0,999,0) --武器回手
			BF.CreateEntityByEntity(self.Me,10070000001,self.WeaponPos.x,self.WeaponPos.y,self.WeaponPos.z) --释放武器消失特效
			BF.RemoveEntitySign(self.Me,10070006)
		end
	end
	if BF.HasEntitySign(self.Me,10070040) then
		--连段衔接判断
		if self.RAP.MyState == FES.Skill and (self.RAP.CurrentSkill == 1007041 or self.RAP.CurrentSkill == 1007042) then
			BF.RemoveEntitySign(self.Me,10070040)
			--扔伞期间被非衔接技能打断，则伞消失&播放消失特效
		elseif self.RAP.MyState ~= FES.Skill or 
			(self.RAP.MyState == FES.Skill and self.RAP.CurrentSkill ~= 1007040 ) then
			BehaviorFunctions.WeaponPreciseTargetPointMove(self.Me,"wuqi_000",false,true,nil,0,999,0) --武器回手
			BF.CreateEntityByEntity(self.Me,10070000001,self.WeaponPos.x,self.WeaponPos.y,self.WeaponPos.z) --释放武器消失特效
			BF.RemoveEntitySign(self.Me,10070040)
		end
	end
	if BF.HasEntitySign(self.Me,10070041) then
		--连段衔接判断
		if self.RAP.MyState == FES.Skill and self.RAP.CurrentSkill == 1007042 then
			BF.RemoveEntitySign(self.Me,10070041)
			--扔伞期间被非衔接技能打断，则伞消失&播放消失特效
		elseif self.RAP.MyState ~= FES.Skill or
			(self.RAP.MyState == FES.Skill and self.RAP.CurrentSkill ~= 1007041 and self.RAP.CurrentSkill ~= 1007040 ) then
			BehaviorFunctions.WeaponPreciseTargetPointMove(self.Me,"wuqi_000",false,true,nil,0,999,0) --武器回手
			BF.CreateEntityByEntity(self.Me,10070000001,self.WeaponPos.x,self.WeaponPos.y,self.WeaponPos.z) --释放武器消失特效
			BF.RemoveEntitySign(self.Me,10070041)
		end
	end
	
	--伞消失窗口判断
	if BF.GetSkillSign(self.Me,10070005) then
		self.WeaponPos = BF.GetWeaponPosition(self.Me,"wuqi_000") --获取武器坐标
		BF.CreateEntityByEntity(self.Me,10070000001,self.WeaponPos.x,self.WeaponPos.y-1,self.WeaponPos.z) --释放武器消失特效
		BF.RemoveEntitySign(self.Me,10070005)
	end
	
	
	
	--Log(self.CoreNumFrame[1].."       "..self.CoreNumFrame[2].."       "..self.CoreNumFrame[3])
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
	
	--检查核心资源率
	self.RAP.CoreResRatio = BF.GetEntityAttrValueRatio(self.Me,1204)
	self.RAP.CoreRes = BF.GetEntityAttrVal(self.Me,1204)
	
	-- --核心UI动效判断 -- 核心资源充满
	-- if self.RAP.CtrlRole == self.Me and self.RAP.CoreRes >= 3 then
	-- 	BF.SetCoreEffectVisible(self.Me,"22098",true)
	-- else
	-- 	BF.SetCoreEffectVisible(self.Me,"22098",false)
	-- end
	

	--角色在场逻辑
	if self.RAP.CtrlRole == self.Me then

		BF.SetCoreUIScale(self.Me, 1)
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
function Behavior1007:RoleCatchSkill()
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
				or (self.RAP.MyState == FES.Skill and BF.GetSkillConfigSign(self.Me) ~= 40 and BF.GetSkillConfigSign(self.Me) ~= 80 and BF.GetSkillConfigSign(self.Me) ~= 81))then
			if self.RAP.MyState == FES.Skill then
				BF.BreakSkill(self.Me)
			end
			if BF.DoJump(self.Me) then
				self.RAB.RoleCatchSkill:ClearButtonPart(ClickButton,"ClearClick")
			end
			--大招释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.UltimateSkill and BF.CheckEntityHeight(self.Me) == 0 then
			if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.UltimateSkill[1],5,5,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
				BF.CastSkillCost(self.Me,self.UltimateSkill[1])
				BF.DoEntityAudioPlay(self.Me,"Play_v_zhuishi_0051",true,FightEnum.SoundSignType.Language)	--播放角色QTE语音
			end
			--闪避释放判断
		elseif self.RAP.ClickButton[ClickButton] == FK.Dodge and BF.CheckEntityHeight(self.Me) == 0 then
			if self.RAB.RoleCatchSkill:MoveSkill(ClickButton,4,4,0,0,0,{21},"ClearClick") then
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
				--释放主动技能1
				if self.NormalSkillState == 0 then
					if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalSkill[1],31111,3,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
						BF.CastSkillCost(self.Me,self.NormalSkill[1])
						self.NormalSkillState = 1
						--*************************张永钢
						if BF.GetEntitySignSound(self.Me,FightEnum.SoundSignType.Language) == nil then
							--BF.DoEntityAudioPlay(self.Me,FightEnum.SoundEventMapKey.VoiceAudio_NormalSkill1,true,FightEnum.SoundSignType.Language)	--播放角色普通技能语音
						end
						--*************************张永钢
					end
					--BF.DoEntityAudioPlay(self.Me,FightEnum.SoundEventMapKey.VoiceAudio_NormalSkill4,true,FightEnum.SoundSignType.Language)	
				--释放主动技能2
				elseif self.NormalSkillState == 1 then
					if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalSkill[2],3,3,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
						BF.CastSkillCost(self.Me,self.NormalSkill[2])
						self.NormalSkillState = 0
					end
				end
			end
			--普攻长按释放判断(空中)
		elseif self.RAP.PressButton[PressButton] == FK.Attack and self.RAP.PressButtonFrame[PressButton] >= 7
			and BF.CheckEntityHeight(self.Me) >= 1 then
			self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.FallAttack[1],170,170,0,0,0,{0},"0","ClearPress",true,0,-1)
			--普攻长按释放判断(地面)
		elseif self.RAP.PressButton[PressButton] == FK.Attack and self.RAP.PressButtonFrame[PressButton] >= 8
			and BF.CheckEntityHeight(self.Me) == 0 and self.RAP.CoreRes >= 0 then
			--长按释放核心技能start
			if self.coreState == 0 then
				local i = BF.GetEntityAttrValueRatio(self.Me,1204)
				if i == 10000 then
					if self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.CoreSkill[1],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
						BF.SetCoreEffectVisible(self.Me,"22099",false)
						BF.SetCoreEffectVisible(self.Me,"22099",true)
						self.coreState = 1
						BehaviorFunctions.ShowCoreUIEffect(self.Me,"CoreUI1007_nengliang",true,0.833)
						BehaviorFunctions.ShowCoreUIEffect(self.Me, "CoreUI1007_shijian", true)
					end
				end
			end
			--继续长按、且有连段窗口时释放核心技能loop
			if (BF.HasEntitySign(self.Me,100700401) or BF.HasEntitySign(self.Me,100700411)) and self.coreState == 1 then	
				
				self.RAB.RoleCatchSkill:ActiveSkill(nil,self.CoreSkill[2],2,2,0,0,0,{0},"0","ClearClick",true,0,-1)
						
				--self.RAB.RoleCatchSkill:CatchSkillPart(self.CoreSkill[2],"Immediately",2,0,0,false0,-1)
				BF.RemoveEntitySign(self.Me,100700401)
				BF.RemoveEntitySign(self.Me,100700411)
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
				if not BF.CheckKeyPress(FK.Attack) then
					self.RAB.RoleCatchSkill:ContSkill(ClickButton,self.NormalAttack,1,1,10000002,0,0,{0},"Immediately","ClearClick",true,0,-1)
				end
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
function Behavior1007:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	local I = BF.GetEntityTemplateId(instanceId)
	if attackInstanceId == self.Me then
		--普攻子弹--总2格--总50点核心-1/6
		--if I == 1007001001 then
			--BF.AddSkillPoint(self.Me,1201,0.2,FE.SkillPointSource.NormalAttack)	--总0.2格
			----BF.ChangeEntityAttr(self.Me,1204,3,1)--总3
		--end
		--if I == 1007002001 or I == 1007002002 or I == 1007002003 then
			--BF.AddSkillPoint(self.Me,1201,0.1,FE.SkillPointSource.NormalAttack)	--总0.3格
			----BF.ChangeEntityAttr(self.Me,1204,3,1)--总9
		--end
		--if I == 1007003001 or I == 1007003002 or I == 1007003003 or I == 1007003004 then
			--BF.AddSkillPoint(self.Me,1201,0.125,FE.SkillPointSource.NormalAttack)	--总0.5格
			----BF.ChangeEntityAttr(self.Me,1204,4,1)--总16
		--end
		--if I == 1007004001 or I == 1007004002 or I == 1007004003 then
			--BF.AddSkillPoint(self.Me,1201,0.12,FE.SkillPointSource.NormalAttack)	--总0.36格
			----BF.ChangeEntityAttr(self.Me,1204,4,1)--总12
		--end
		--if I == 1007005001 or I == 1007005002 then
			--BF.AddSkillPoint(self.Me,1201,0.32,FE.SkillPointSource.NormalAttack)	--总0.64格
			----BF.ChangeEntityAttr(self.Me,1204,5,1)--总10
		--end
		--跳反子弹强制打断敌人技能
		if BF.CheckEntity(hitInstanceId) and I == 1007081001 then
			BF.BreakSkill(hitInstanceId)
		end
		--临时跳反踩踏子弹强制打断敌人技能
		if BF.CheckEntity(hitInstanceId) and I == 1001080001 then
			BF.BreakSkill(hitInstanceId)
		end
		--子弹命中时增加核心充能
		if BF.CheckEntity(hitInstanceId) and I == 1007001001 then
			BF.ChangeEntityAttr(self.Me,1204,0.0674*3*self.CorePERK,1)	--总3
		end
		
		
		
		if BF.CheckEntity(hitInstanceId) and (I == 1007002001 or I == 1007002002) then
			BF.ChangeEntityAttr(self.Me,1204,0.0277*3*self.CorePERK,1)	--总3
		end
		
		if BF.CheckEntity(hitInstanceId) and I == 1007002004 then
			BF.ChangeEntityAttr(self.Me,1204,0.0831*3*self.CorePERK,1)	--总3
		end
		
		if BF.CheckEntity(hitInstanceId) and I == 1007003001 then
			BF.ChangeEntityAttr(self.Me,1204,0.0646*3*self.CorePERK,1)	--总3
		end
		
		if BF.CheckEntity(hitInstanceId) and I == 1007004001 then
			BF.ChangeEntityAttr(self.Me,1204,0.0155*3*self.CorePERK,1)	--总3
		end
		
		if BF.CheckEntity(hitInstanceId) and I == 1007005001 then
			BF.ChangeEntityAttr(self.Me,1204,0.1108*3*self.CorePERK,1)	--总3
		end
		
		if BF.CheckEntity(hitInstanceId) and I == 1007012003 then
			BF.ChangeEntityAttr(self.Me,1204,0.155*3*self.CorePERK,1)	---总3
		end
		
		if BF.CheckEntity(hitInstanceId) and I == 1007042001 then --核心上挑减少核心充能
			if BF.GetEntityAttrVal(self.Me,1204) ~= 0 then
				BehaviorFunctions.ShowCoreUIEffect(self.Me,"CoreUI1007_nengliang",true,3)
				self.frame = BehaviorFunctions.GetFightFrame() + 5
				self.coretimestate = 1
			end
			
		end
	
	else 
		--if BF.CheckEntity(hitInstanceId) and I == 100701011001 then
			--BF.ChangeEntityAttr(self.Me,1204,0.0549,1)
		--end
		
		if BF.CheckEntity(hitInstanceId) and (I == 10070201101 or I == 10070301 or I == 10070401 or I == 10070501)  then
			BF.ChangeEntityAttr(self.Me,1204,0.0465*3*self.CorePERK,1)
		end
	end
end

function Behavior1007:CoreUITimeCount()
	if BehaviorFunctions.GetFightFrame() > self.frame and BF.GetEntityAttrVal(self.Me,1204) ~= 0
		and self.coretimestate == 1 then
		BehaviorFunctions.ShowCoreUIEffect(self.Me,"CoreUI1007_nengliang",true,0)
		self.coretimestate = 0
	end
end


--function Behavior1007:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType,camp)
	--local I = BF.GetEntityTemplateId(instanceId)
	--if BF.CheckEntity(hitInstanceId) and I == 100701011001 then
		--BF.ChangeEntityAttr(self.Me,1204,0.0549,1)
	--end
--end


--命中时判断
function Behavior1007:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType,camp)
	local I = BF.GetEntityTemplateId(instanceId)
	if attackInstanceId == self.Me then
		--部分子弹命中时增加少核心充能
		if BF.CheckEntity(hitInstanceId) and (I == 1007004001) then
			BF.ChangeEntityAttr(self.Me,1204,0.0155*3*self.CorePERK,1)	--总1
		end
	end
	if BF.CheckEntity(hitInstanceId) and I == 100701011001 then
		BF.ChangeEntityAttr(self.Me,1204,0.0183*3*self.CorePERK,1)
	end
end


--技能释放判断
function Behavior1007:CastSkill(instanceId,skillId,skillSign,skillType)
	
	if instanceId == self.Me and skillId == 1007011 then
		self.NormalSkillFrame = self.RAP.RealFrame + 35
		self.coreState = 0
	end
	
	if instanceId == self.Me and (((skillSign ~= 30 and skillSign ~= 31) and not BF.CheckPlayerInFight()) or BF.CheckPlayerInFight()) then
		self.RAP.CoreUiFrame = self.RAP.RealFrame + 90
		--BF.ChangeEntityAttr(self.Me,1206,-250,1)
		--self.ChangeLockTargetFrame = 0 --闪避重置切换锁定目标间隔时间
	end
	
	if instanceId == self.Me and skillId ~= 1007040 then
		if skillId ~= 1007041 and skillId ~= 1007042 then
			self.coreState = 0
		end
	end
	
	if instanceId == self.Me and skillId == 1007012 then
		--右一位置
		self.XH = BehaviorFunctions.GetPositionOffsetBySelf(self.Me,3.5,60)
		--右二位置
		self.XH2 = BehaviorFunctions.GetPositionOffsetBySelf(self.Me,2,30)
		--左一位置
		self.XH3 = BehaviorFunctions.GetPositionOffsetBySelf(self.Me,4,300)
		--左二位置
		self.XH4 = BehaviorFunctions.GetPositionOffsetBySelf(self.Me,2,330)
		--自身位置
		self.position = BehaviorFunctions.GetPositionOffsetBySelf(self.Me,0,0)
		--目标位置
		self:GetTarrgetPosition()
	end
	
end

--属性变化判断
function Behavior1007:ChangeAttrValue(attrType,attrValue,changedValue)
	if attrType == 1204 then
		self.RAP.CoreUiFrame = self.RAP.RealFrame + 90
	end
end

--通用闪避成功判断
function Behavior1007:Dodge(attackInstanceId,hitInstanceId,limit)
	if hitInstanceId == self.Me and limit == true then
		BF.ChangeEntityAttr(self.Me,1204,1*self.CorePERK,1)
	end
end


function Behavior1007:AddSkillSign(instanceId,sign)
	if instanceId == self.Me and sign == 1001998 then
		--BF.CastSkillByTarget(instanceId,1001999,targetInstanceId)
		self.RAB.RoleCatchSkill:ActiveSkill(0,1001999,5,3,0,0,0,{0},"Immediately","ClearClick",true,0,-1)
		BehaviorFunctions.RemoveSkillEventActiveSign(self.Me,1001999)
	end
end

----判断核心长按及释放
function Behavior1007:CoreSkillRelease()
	if self.RAP.PressButton[1] == 0 and self.coreState == 1 and BF.CheckEntityHeight(self.Me) == 0 
		and (BF.HasEntitySign(self.Me,100700402) or self.RAP.CurrentSkill == 1007041) then
		
		self.RAB.RoleCatchSkill:ActiveSkill(nil,self.CoreSkill[3],3,3,0,0,0,{0},"Immediately","ClearClick",true,0,-1)
		BehaviorFunctions.ShowCoreUIEffect(self.Me,"CoreUI1007_nengliang",true,0)
		--self.RAB.RoleCatchSkill:CatchSkillPart(self.CoreSkill[3],"Immediately",2,0,0,true,0,-1)
		BehaviorFunctions.RemoveKeyPress(FK.Attack)
		self.coreState = 0
		self.coretimestate = 0
	end
end

--主动技能创建伞、鹤实体
function Behavior1007:Attack011()
	--技能1创建伞实体
	if BehaviorFunctions.HasEntitySign(self.Me,100701011) then
		local P = BehaviorFunctions.GetPositionOffsetBySelf(self.Me,2,0)
		self.Umbrella = BehaviorFunctions.CreateEntity(100701,self.Me,P.x,P.y+1.21,P.z)
	end	
	
	--技能2创建第1只鹤实体
	if BehaviorFunctions.HasEntitySign(self.Me,1007012001) then
		--右一仙鹤
		self.XianHe2 = BehaviorFunctions.CreateEntity(100703,self.Me,self.XH2.x,self.position.y-1,self.XH2.z,self.TargetPos.x,self.TargetPos.y,self.TargetPos.z)
		BehaviorFunctions.SetUseParentTimeScale(self.XianHe2, false)--不使用创建者时间缩放
		BehaviorFunctions.RemoveEntitySign(self.Me,1007012001)
	end
	
	--技能2创建第2只鹤实体	
	if BehaviorFunctions.HasEntitySign(self.Me,1007012002) then
		--右二仙鹤
		self.XianHe = BehaviorFunctions.CreateEntity(100704,self.Me,self.XH.x,self.position.y-1,self.XH.z,self.TargetPos.x,self.TargetPos.y,self.TargetPos.z)
		BehaviorFunctions.SetUseParentTimeScale(self.XianHe, false)--不使用创建者时间缩放
		BehaviorFunctions.RemoveEntitySign(self.Me,1007012002)
	end
		
	--技能2创建第3只鹤实体	
	if BehaviorFunctions.HasEntitySign(self.Me,1007012003) then
		--左一仙鹤
		self.XianHe4 = BehaviorFunctions.CreateEntity(100702,self.Me,self.XH4.x,self.position.y-1,self.XH4.z,self.TargetPos.x,self.TargetPos.y,self.TargetPos.z)
		BehaviorFunctions.SetUseParentTimeScale(self.XianHe4, false)--不使用创建者时间缩放
		BehaviorFunctions.RemoveEntitySign(self.Me,1007012003)
	end
	
	--技能2创建第4只鹤实体
	if BehaviorFunctions.HasEntitySign(self.Me,1007012004) then
		--左二仙鹤
		self.XianHe3 = BehaviorFunctions.CreateEntity(100705,self.Me,self.XH3.x,self.position.y-1,self.XH3.z,self.TargetPos.x,self.TargetPos.y,self.TargetPos.z)
		BehaviorFunctions.SetUseParentTimeScale(self.XianHe3, false)--不使用创建者时间缩放
		BehaviorFunctions.RemoveEntitySign(self.Me,1007012004)
	end
end

--获取技能窗口
function Behavior1007:SkillBtnChange()
	if BF.GetSkillSign(self.Me,1007011) then
		if self.curSkillBtn ~= 1007012 then
			BehaviorFunctions.SetFightUISkillBtnId(self.Me,FK.NormalSkill,1007012)
			--BF.PlaySkillUIEffect("Effect/UI/22156_qingmenyin.prefab", "I")
			self.curSkillBtn = 1007012
			BehaviorFunctions.SetSkillTriggerLimitTime(self.Me, FK.NormalSkill, 10)
		end
	elseif BF.GetSkillSign(self.Me,1007012) then
		if self.curSkillBtn ~= 1007011 then
			BehaviorFunctions.SetFightUISkillBtnId(self.Me,FK.NormalSkill,1007011)
			self.curSkillBtn = 1007011
			--BF.PlaySkillUIEffect("Effect/UI/22157_qingmenyin.prefab", "I")
		end
	end
end

--主动技能倒计时
function Behavior1007:SkillTriggerLimitTimeOver(instanceId, keyEvent)
	if instanceId == self.Me and keyEvent == FK.NormalSkill then
		BehaviorFunctions.SetFightUISkillBtnId(self.Me,FK.NormalSkill,1007011)
		self.curSkillBtn = 1007011
		--BF.PlaySkillUIEffect("Effect/UI/22157_qingmenyin.prefab", "I")
		self.NormalSkillState = 0
	end
end

--获取战斗目标坐标
function Behavior1007:GetTarrgetPosition()
	if BF.CheckEntity(self.RAP.LockTarget) then
		self.TargetPos = BehaviorFunctions.GetPositionP(self.RAP.LockTarget)
	elseif BF.CheckEntity(self.RAP.LockAltnTarget) then
		self.TargetPos = BehaviorFunctions.GetPositionP(self.RAP.LockAltnTarget)
	elseif BF.CheckEntity(self.RAP.AttackTarget) then
		self.TargetPos = BehaviorFunctions.GetPositionP(self.RAP.AttackTarget)
	elseif BF.CheckEntity(self.RAP.AttackAltnTarget) then
		self.TargetPos = BehaviorFunctions.GetPositionP(self.RAP.AttackAltnTarget)
	else
		self.TargetPos = BehaviorFunctions.GetPositionOffsetBySelf(self.Me,15,0)
	end
end

--核心UI动效推出释放状态
function Behavior1007:CoreUI1007OnOut()
	BF.SetEntityAttr(self.Me,1204,0)	--总1
	local S = BehaviorFunctions.GetSkill(self.Me)
	if S == 1007040 or S == 1007041 then
		self.RAB.RoleCatchSkill:ActiveSkill(nil,self.CoreSkill[3],3,3,0,0,0,{0},"Immediately","ClearClick",true,0,-1)
		BehaviorFunctions.RemoveKeyPress(FK.Attack)
		self.RAP.PressButton[1] = 0
		self.coreState = 0
	end
end

--获取计算公式参数前
function Behavior1007:BeforeGetDamageParam(ownerInstanceId,hitInstanceId, attackType, damageType, atkElementType, magicId, attackInstanceId)

	--PERK「大招 - 技能名」伤害倍率提升a%。
	if BF.HasEntitySign(self.Me,10071003) and ownerInstanceId == self.Me then
		if BF.AnalyseSkillType(BF.GetDamageParam(FE.DamageInfo.SkillType),FE.SkillType.Unique) then
			local v = BF.GetMagicValue(self.Me,10071002,1,1)
			BF.ChangeDamageParam(FE.DamageParam.SkillPercent,v)
		end
	end
end

--脉象相关
function Behavior1007:AddEntitySign(instanceId,sign)
	if instanceId == self.Me then
		if sign == 10071002 then
			BF.DoMagic(self.Me,self.Me,10071001)--perk2参数
			
		end
		
		if sign == 10071003 then
			BF.DoMagic(self.Me,self.Me,10071002)--perk3参数
		end
		
		if sign == 10071005 then
			BF.DoMagic(self.Me,self.Me,10071003)--perk5参数
		end
		
		if sign == 10071006 then
			BF.DoMagic(self.Me,self.Me,10071004)--perk6参数
			BF.DoMagic(self.Me,self.Me,10071005)--perk6参数
		end
	end
end