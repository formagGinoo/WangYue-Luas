Behavior40027002 = BaseClass("Behavior40027002",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40027002.GetGenerates()
end

function Behavior40027002.GetMagics()
	local generates = {}
	return generates
end

function Behavior40027002:Init()
	self.Me = self.instanceId
	BF.SetEntityValue(1,40027002,0)--世界“宠爱层数”用于给动物判断
end



function Behavior40027002:WorldInteractClick(uniqueId,instanceId)
	
	local c = BF.GetCtrlEntity()
	
	if BehaviorFunctions.GetNpcType(instanceId) == FightEnum.EntityNpcTag.Animal then
		--如果没有宠爱一生增益，世界“宠爱层数”设置为0
		if BF.GetBuffCount(c,40027004) == 0 then
			BF.SetEntityValue(1,40027002,0)
		end
		
		
		if BF.CheckEntity(c) then
			BF.AddBuff(c,c,40027004)
		end
	end
end

