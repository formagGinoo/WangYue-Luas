Behavior1009 = BaseClass("Behavior1009",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType

function Behavior1009.GetGenerates()
	local generates = {
		
	}
	return generates
end
function Behavior1009.GetOtherAsset()
	local generates = {
		BehaviorFunctions.GetEffectPath("22099"),
		BehaviorFunctions.GetEffectPath("22098"),
		BehaviorFunctions.GetEffectPath("22097"),
		BehaviorFunctions.GetEffectPath("22096"),
		BehaviorFunctions.GetUIEffectPath("UI_SkillPanel_jiuxu"),
		--BehaviorFunctions.GetEffectPath("22059"),
		--"Effect/UI/22060.prefab"
		"UIEffect/Prefab/UI_SkillPanel_changan.prefab",
	}
	return generates
end

function Behavior1009:Init()
	--变量声明
	self.Me = self.instanceId		--记录自己

	--普攻技能Id
	self.NormalAttack = {1009001,1009002,1009003,1009004,1009005}
	self.WaterAttack = {1009901,1009902,1009903,1009904,1009905}
	self.NormalSkill = {1009010}	--普通技能Id
	self.MoveSkill = {1009030,1009031}	--闪避技能Id
	self.FallAttack = {1009170,1009171,1009172}	--下落攻击Id
	self.AirAttack = {1009101,1009102,1009103}	--空中攻击Id
	self.LeapAttack = {1009160}	--起跳攻击Id
	--self.CoreSkill = {1001041,1001042,1001043}	--核心技能Id
	self.CoreSkill = {1009040,1009041}	--核心技能Id
	self.QTESkill = {1009060}	--QTE技能Id
	self.DodgeAttack = {1009070,1009071}	--闪避反击技能
	self.JumpAttack = {1009080,1009081,1009082}	--闪避反击技能
	self.UltimateSkill = {1009050}	--大招技能Id
	self.PartnerConnect = {1009999}	--佩从连携技能id
	self.PartnerCall = {1009061,1009062,1009063,1009064} --佩从召唤动作
	self.PartnerHenshin = {1009060} --佩从变身动作集合
	self.CatchSkill = {1009090}	--捕捉技能
	
	
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
	
	--参数记录
	self.frame = 0
	self.WaterHitframe = 0  --水刀perk用参数
	self.WaterState = 0 --水刀阶段参数
	self.curHitFlyBullet = 0	--测试
	self.SheildBUffState = 0    --是否有护盾检测
	
end

function Behavior1009:LateInit()
	self.RAP:LateInit()
end

function Behavior1009:BeforeUpdate()
	--通用参数组合更新
	self.RAP:BeforeUpdate()
end

function Behavior1009:Update()

	--BF.AddEntitySign(self.Me,10091004,-1)
	--BF.AddEntitySign(self.Me,10091006,-1)
	--BF.AddBuff(self.Me,self.Me,1009010002)
		
	if BF.CheckEntity(self.Me) then

		--通用参数组合更新
		self.RAP:Update()
		--当前帧数
		self.frame = BF.GetFightFrame()

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
		
		self:SkillEvent()
		
	end
end

--角色个人判断
function Behavior1009:Core()
	
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
	
	--脉象2perk，15%治疗加成
	if BF.HasEntitySign(self.Me,10091002) and not BehaviorFunctions.HasBuffKind(self.Me,1009010003) then
		BF.AddBuff(self.Me,self.Me,1009010003)
	end
	
	
	--检查核心资源率
	self.RAP.CoreResRatio = BF.GetEntityAttrValueRatio(self.Me,1204)
	self.RAP.CoreRes = BF.GetEntityAttrVal(self.Me,1204)
	
	--核心UI动效判断 -- 核心资源充满
	if self.RAP.CtrlRole == self.Me and self.RAP.CoreRes >= 3 then
		BF.SetCoreEffectVisible(self.Me,"22098",true)
	else
		BF.SetCoreEffectVisible(self.Me,"22098",false)
	end

	--角色在场逻辑
	if self.RAP.CtrlRole == self.Me then

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
			BF.SetPlayerCoreEffectVisible("20027", true)
			BF.SetPlayerCoreEffectVisible("20028", true)
		else
			BF.StopSkillUIEffect("UIEffect/Prefab/UI_SkillPanel_changan.prefab","J")
			BF.SetPlayerCoreEffectVisible("20027", false)
			BF.SetPlayerCoreEffectVisible("20028", false)
		end
		
		--六脉护盾在场检测
		if self.SheildBUffState == 1 then
			if not BF.HasBuffKind(self.Me,1009010002) then
				--护盾消失或被打烂之后创建子弹
				local p = BF.GetPositionP(self.Me)
				--BF.CreateEntityByEntity(self.Me, 100901004 ,p.x,p.y,p.z)
				BF.CreateEntity(100901004,self.Me,p.x,p.y,p.z)
				self.SheildBUffState = 0
			end
		end
	end
end

--重写角色释放技能组合
function Behavior1009:RoleCatchSkill()
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
				if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.NormalSkill[1],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
					BF.CastSkillCost(self.Me,self.NormalSkill[1])

					
				end
			end
			--普攻长按释放判断(空中)
		elseif self.RAP.PressButton[PressButton] == FK.Attack and self.RAP.PressButtonFrame[PressButton] >= 7
			and BF.CheckEntityHeight(self.Me) >= 1 then
			self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.FallAttack[1],170,170,0,0,0,{0},"0","ClearPress",true,0,-1)
			--普攻长按释放判断(地面)
		elseif self.RAP.PressButton[PressButton] == FK.Attack and self.RAP.PressButtonFrame[PressButton] >= 10
			and BF.CheckEntityHeight(self.Me) == 0 and self.RAP.CoreRes >= 3 then
			if BF.HasEntitySign(self.Me,10091001) then
				--有perk一脉核心跳四下
				if self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.CoreSkill[1],2,2,0,0,0,{0},"Immediately","ClearPress",true,0,-1) then

				end
			else
				--无perk一脉核心跳三下					
				if self.RAB.RoleCatchSkill:ActiveSkill(PressButton,self.CoreSkill[2],2,2,0,0,0,{0},"Immediately","ClearPress",true,0,-1) then
				
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
			if not BF.HasBuffKind(self.Me,100901002) then
				self.RAB.RoleCatchSkill:ContSkill(ClickButton,self.NormalAttack,1,1,10000002,0,0,{0},"Immediately","ClearClick",true,1.2)
			else
				self.RAB.RoleCatchSkill:ContSkill(ClickButton,self.WaterAttack,1,1,10000002,0,0,{0},"Immediately","ClearClick",true,1.2)
			end
			if BF.HasEntitySign(self.Me,10000000) then
				if self.RAB.RoleCatchSkill:ActiveSkill(ClickButton,self.DodgeAttack[1],2,2,0,0,0,{0},"Immediately","ClearClick",true,0,-1) then
					BF.RemoveEntitySign(self.Me,10000000)
				end
			elseif (BF.GetSkill(self.Me) > self.NormalAttack[1] and BF.GetSkill(self.Me) < self.NormalAttack[5])
				or not BF.CheckKeyPress(FK.Attack) then
				--self.RAB.RoleCatchSkill:ContSkill(ClickButton,self.NormalAttack,1,1,10000002,0,0,{0},"Immediately","ClearClick",true,1.2)
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

--技能释放判断
function Behavior1009:CastSkill(instanceId,skillId,skillSign,skillType)
	
	if instanceId == self.Me then
		
		if skillId == 1009010 then
			BF.AddBuff(self.Me,self.Me,100901002)	--水刀buff
			--六脉放E加护盾
			if BF.HasEntitySign(self.Me,10091006) then
				BF.AddBuff(self.Me,self.Me,1009010002)
				self.SheildBUffState = 1
			end
			
		elseif skillId == 1009041 or skillId == 1009040 then
			BF.SetEntityAttr(self.Me,1204,0,1)--核心资源清零
			
		end
	
		if ((skillSign ~= 30 and skillSign ~= 31) and not BF.CheckPlayerInFight()) or BF.CheckPlayerInFight() then
			--self.RAP.CoreUiFrame = self.RAP.RealFrame + 90
		end
		
	end
end

--属性变化判断
function Behavior1009:ChangeAttrValue(attrType,attrValue,changedValue)
	if attrType == 1204 then
		self.RAP.CoreUiFrame = self.RAP.RealFrame + 90
		--if changedValue ~= 0 then
			--self:CorePart(changedValue)
		--end
	end
end

--通用闪避成功判断
function Behavior1009:Dodge(attackInstanceId,hitInstanceId,limit)
	if hitInstanceId == self.Me and limit == true then
		BF.ChangeEntityAttr(self.Me,1204,1,1)
		--BF.ChangeEntityAttr(self.Me,1204,75,1)
		--BF.AddEntitySign(hitInstanceId,10000000,90) --角色3秒内反击标记
	end
end

--跳跃反击着地回调
function Behavior1009:OnLand(instanceId)
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

function Behavior1009:FinishSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.Me and skillId == 1009081 then
		BF.SetCameraParams(FightEnum.CameraState.ForceLocking) --重置强锁定镜头参数
	end
end

--关键帧监听
function Behavior1009:SkillFrameUpdate(instanceId,skillId,skillFrame)
	if instanceId == self.Me and skillId == 1009040 then
		if skillFrame == 9 then
			BehaviorFunctions.ShowCoreUIEffect(instanceId, "UI_CoreUI1009_1")-- 核心模式第一层
		elseif skillFrame == 25 then
			BehaviorFunctions.ShowCoreUIEffect(instanceId, "UI_CoreUI1009_2")-- 核心模式第二层
		elseif skillFrame == 47 then
			BehaviorFunctions.ShowCoreUIEffect(instanceId, "UI_CoreUI1009_3")-- 核心模式第三层
		elseif skillFrame == 68 then
			BehaviorFunctions.ShowCoreUIEffect(instanceId, "UI_CoreUI1009_4")-- 核心模式第四层
		elseif skillFrame == 87 then
			BehaviorFunctions.ShowCoreUIEffect(instanceId, "UI_CoreUI1009_out") --回到状态进度状态
		end
	elseif instanceId == self.Me and skillId == 1009041 then
		if skillFrame == 8 then
			BehaviorFunctions.ShowCoreUIEffect(instanceId, "UI_CoreUI1009_1")-- 核心模式第一层
		elseif skillFrame == 24 then
			BehaviorFunctions.ShowCoreUIEffect(instanceId, "UI_CoreUI1009_2")-- 核心模式第二层	
		elseif skillFrame == 46 then
			BehaviorFunctions.ShowCoreUIEffect(instanceId, "UI_CoreUI1009_3")-- 核心模式第三层
		elseif skillFrame == 67 then
			BehaviorFunctions.ShowCoreUIEffect(instanceId, "UI_CoreUI1009_out") --回到状态进度状态
		end
	end
	
end


function Behavior1009:BreakSkill(instanceId,skillId,skillType)
		if instanceId == self.Me and skillId == 1009040 or skillId == 1009041 then
			BehaviorFunctions.ShowCoreUIEffect(instanceId, "UI_CoreUI1009_out") --回到状态进度状态
		end
end


function Behavior1009:AddSkillSign(instanceId,sign)
	if instanceId == self.Me then 
		if sign == 1001998 then
		--BF.CastSkillByTarget(instanceId,1001999,targetInstanceId)
			self.RAB.RoleCatchSkill:ActiveSkill(0,1001999,5,3,0,0,0,{0},"Immediately","ClearClick",true,0,-1)
			BehaviorFunctions.RemoveSkillEventActiveSign(self.Me,1001999)
		end
	end
end


--加减技能帧事件，用于给祁玉加减水刀
function Behavior1009:SkillEvent()
	if not BF.HasBuffKind(self.Me,100901002) then
		if not BF.CheckSkillEventActiveSign(self.Me,10090101) then
			BF.AddSkillEventActiveSign(self.Me,10090101)
		end
		if BF.CheckSkillEventActiveSign(self.Me,10090102) then
			BF.RemoveSkillEventActiveSign(self.Me,10090102)
		end
	else
		if not BF.CheckSkillEventActiveSign(self.Me,10090102) then
			BF.AddSkillEventActiveSign(self.Me,10090102)
		end
		if BF.CheckSkillEventActiveSign(self.Me,10090101) then
			BF.RemoveSkillEventActiveSign(self.Me,10090101)
		end
	end
end


function Behavior1009:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	local I = BF.GetEntityTemplateId(instanceId)
	if BehaviorFunctions.CheckSkillEventActiveSign(self.Me,10090102) then
		--水普攻子弹命中时增加核心充能
		if BF.CheckEntity(hitInstanceId) and I == 1009001001 or I == 1009901001 then
			BF.ChangeEntityAttr(self.Me,1204,0.09,1)	
		end
	
		if BF.CheckEntity(hitInstanceId) and I == 1009002001 or I == 1009902001 then
			BF.ChangeEntityAttr(self.Me,1204,0.09,1)	
		end
		
		if BF.CheckEntity(hitInstanceId) and I == 1009003001 or I == 1009003002 then
			BF.ChangeEntityAttr(self.Me,1204,0.09,1)	
		end
		if BF.CheckEntity(hitInstanceId) and I == 1009903001 or I == 1009903002 then
			BF.ChangeEntityAttr(self.Me,1204,0.09,1)
		end
		
		if BF.CheckEntity(hitInstanceId) and I == 1009005003 or I == 1009905003 then
			BF.ChangeEntityAttr(self.Me,1204,0.09,1)	
		end
	end
	
	local T = BehaviorFunctions.GetCurFormationEntities()
	
	
	--区分有无脉象1,核心子弹治疗
	if BF.HasEntitySign(self.Me,10091001) then
		
		local L = BehaviorFunctions.GetEntitySkillLevel(self.Me,1009041)
			if BF.CheckEntity(hitInstanceId) then
				if I == 1009040001  then
					for i, v in ipairs(T) do
						BF.DoMagic(self.Me,T[i],1009040011,L)
					end
				elseif I == 1009040002 then
					for i, v in ipairs(T) do
						BF.DoMagic(self.Me,T[i],1009040021,L)
					end
				elseif I == 1009040003 then
					for i, v in ipairs(T) do
						BF.DoMagic(self.Me,T[i],1009040031,L)
					end
				elseif I == 1009040004 then
					for i, v in ipairs(T) do
						BF.DoMagic(self.Me,T[i],1009040041,L)
					end
				end
			end
	else
		local L = BehaviorFunctions.GetEntitySkillLevel(self.Me,1009040)
			if BF.CheckEntity(hitInstanceId) then
				if I == 1009040001  then
					for i, v in ipairs(T) do
						BF.DoMagic(self.Me,T[i],1009040011,L)
					end
				elseif I == 1009040002 then
					for i, v in ipairs(T) do
						BF.DoMagic(self.Me,T[i],1009040021,L)
					end
				elseif I == 1009040003 then
					for i, v in ipairs(T) do
						BF.DoMagic(self.Me,T[i],1009040031,L)
					end
				elseif I == 1009040004 then
					for i, v in ipairs(T) do
						BF.DoMagic(self.Me,T[i],1009040041,L)
					end
				end
			end
	end
end


--命中时判断
function Behavior1009:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType,camp)
	local I = BF.GetEntityTemplateId(instanceId)
	--脉象Perk5，大招每次命中回复0.5格日相
	if BF.CheckEntity(hitInstanceId) and I == 1009051001 then
		if BF.HasEntitySign(self.Me,10091005) then
			local v = BF.GetMagicValue(self.Me,10091001,1,1)
			BF.AddSkillPoint(self.Me,1201,v) --回复0.5个日相
		end
	end
	if BehaviorFunctions.CheckSkillEventActiveSign(self.Me,10090102) then
		--子弹命中时增加核心充能
		if BF.CheckEntity(hitInstanceId) and I == 1009004001 or I == 1009904001 then
			BF.ChangeEntityAttr(self.Me,1204,0.09,1)	--总1  0.1932
		end
	
		--子弹命中时增加核心充能
		if BF.CheckEntity(hitInstanceId) and I == 1009005001 or I == 1009905001 then
			BF.ChangeEntityAttr(self.Me,1204,0.09,1)	--总1  0.1932
		end
		
	end
end

function Behavior1009:AddSkillSign(instanceId,sign)
	--大招给全队治疗
	if instanceId == self.Me and sign == 100905001 then
		local l =  BehaviorFunctions.GetCurFormationEntities()
		local L = BehaviorFunctions.GetEntitySkillLevel(self.Me,1009050)
		for index, value in ipairs(l) do
			if BF.CheckEntity(value) then
				BF.DoMagic(self.Me,value,10090506,L)
			end
		end

	end
end

--获取治疗公式前
function Behavior1009:BeforeCalculateCure(healer,treatee,magicId)
	if healer == self.Me and magicId == 10090506 then
		--脉象4perk，增加10%大招治疗量
		if BF.HasEntitySign(self.Me,10091004) then
			local v = BF.GetMagicValue(self.Me,10091002,1,1)
			BF.ChangeCureParam(FE.CureParam.SkillPercent,v)	--加治疗
		end
	end
end

--脉象相关
function Behavior1009:AddEntitySign(instanceId,sign)
	if instanceId == self.Me then
		if sign == 10091004 then
			BF.DoMagic(self.Me,self.Me,10091002)--perk4参数

		end

		if sign == 10091005 then
			BF.DoMagic(self.Me,self.Me,10091001)--perk5参数
		end
		
	end
end


----给自己加护盾检测
--function Behavior1009:AddBuff(entityInstanceId, buffInstanceId,buffId)
	--if entityInstanceId == self.Me and buffId == 1009010002 and self.SheildBUffState == 0 then
		
	--end
--end




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
