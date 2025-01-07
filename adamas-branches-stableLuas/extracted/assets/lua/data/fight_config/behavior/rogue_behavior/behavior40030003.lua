Behavior40030003 = BaseClass("Behavior40030003",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
local FEEAT = FightEnum.EAttackType

function Behavior40030003.GetGenerates()
end

function Behavior40030003.GetMagics()
	local generates = {}
	return generates
end

function Behavior40030003:Init()
	
end

--12/21更新，现在只判断交互了NPC就会开始判定，后续要改判定打赏行为
function Behavior40030003:WorldInteractClick(uniqueId,instanceId)

	local c = BF.GetCtrlEntity()
	if BehaviorFunctions.GetNpcType(instanceId) == FightEnum.EntityNpcTag.NPC then
		
		--随机值
		local r = BehaviorFunctions.Random(1,100)

		if BF.CheckEntity(c) and r <= 20 then
			BF.AddBuff(c,c,40030004)
		end
	end
end