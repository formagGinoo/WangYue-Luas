Behavior40030001 = BaseClass("Behavior40030001",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40030001.GetGenerates()
end

function Behavior40030001.GetMagics()
	local generates = {}
	return generates
end

function Behavior40030001:Init()
	
end

--12/21更新，现在只判断交互了NPC就会开始判定，后续要改判定打赏行为
function Behavior40030001:WorldInteractClick(uniqueId,instanceId)

	local c = BF.GetCtrlEntity()
	if BehaviorFunctions.GetNpcType(instanceId) == FightEnum.EntityNpcTag.NPC then
		
		--随机值
		local r = BehaviorFunctions.Random(1,100)

		if BF.CheckEntity(c) and r <= 10 then
			BF.AddBuff(c,c,40030004,self._level)
		end
	end
end