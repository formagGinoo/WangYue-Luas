Behavior40027001 = BaseClass("Behavior40027001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40027001.GetGenerates()
end

function Behavior40027001.GetMagics()
	local generates = {}
	return generates
end

function Behavior40027001:Init()
	self.Me = self.instanceId
	BF.SetEntityValue(1,40027001,0)--世界“宠爱层数”用于给动物判断
end



function Behavior40027001:WorldInteractClick(uniqueId,instanceId)
	
	local c = BF.GetCtrlEntity()
	
	if BehaviorFunctions.GetNpcType(instanceId) == FightEnum.EntityNpcTag.Animal then
		--如果没有宠爱一生增益，世界“宠爱层数”设置为0
		if BF.GetBuffCount(c,40027003) == 0 then
			BF.SetEntityValue(1,40027001,0)
		end
		
		
		if BF.CheckEntity(c) then
			BF.AddBuff(c,c,40027003,self._level)
		end
	end
end

