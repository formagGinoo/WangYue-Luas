Behavior40016001 = BaseClass("Behavior40016001",EntityBehaviorBase)
--钻地的移动速度提升a%，敌人发现范围减少a%
local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40016001.GetGenerates()
end

function Behavior40016001.GetMagics()
	local generates = {}
	return generates
end

function Behavior40016001:Init()
	self.Me = self.instanceId
	self.partner = 0
	self.ctrlRole = BehaviorFunctions.GetCtrlEntity()	--获取前台角色
end


function Behavior40016001:Update()	
	self.ctrlRole = BehaviorFunctions.GetCtrlEntity()	--获取前台角色
	if self.partner and self.partner ~= 0 then
		BehaviorFunctions.SetEntityValue(self.Me,"alertValue",self.customParam[2])		--开放警戒变量
	end
	--如果正在潜地
	if self.partner and self.partner ~= 0 and BF.HasEntitySign(self.Me,610025) and not self.inbuff then
		BehaviorFunctions.ChangeEntityAttr(self.partner,FightEnum.PlayerAttr.InputSpeedPerent,self.customParam[1])-- value是万分比
		self.inbuff = true
	end
end

--轮盘按钮回调
function Behavior40016001:AbilityWheelFreePartnerSkill(instanceId,abilityId,skillId)
	if BehaviorFunctions.CheckAbilityCanUse(abilityId) then
		if  BehaviorFunctions.CheckBtnUseSkill(self.ctrlRole,FightEnum.KeyEvent.PartnerSkill,true) then
			if skillId == 610025005 then
				self.partner = instanceId	--记录潜地ID
			end
		end
	end
end

function Behavior40016001:RemoveBuff(entityInstanceId, buffInstanceId,buffId)
	if buffId == 40016001 and entityInstanceId == self.Me and self.inbuff then
		BehaviorFunctions.ChangeEntityAttr(self.partner,FightEnum.PlayerAttr.InputSpeedPerent,-self.customParam[1])
	end
end