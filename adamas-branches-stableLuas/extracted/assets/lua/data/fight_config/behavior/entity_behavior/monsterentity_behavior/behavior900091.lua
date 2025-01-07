Behavior900091 = BaseClass("Behavior900091",EntityBehaviorBase)
--资源预加载
local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType

function Behavior900091.GetGenerates()
	local generates = {}
	return generates
end


function Behavior900091:Init()
	self.me = self.instanceId
end

function Behavior900091:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	local rolePos = BehaviorFunctions.GetPositionP(self.role)
	local myPos = BehaviorFunctions.GetPositionP(self.me)
	local heightD = math.abs(rolePos.y - myPos.y)
	local distance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.role)


	local distance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.role)
	--店长跟着玩家
	if distance > 4 then
		BehaviorFunctions.SetPathFollowEntity(self.me,self.role)
		if BehaviorFunctions.GetEntityState(self.me) ~= FightEnum.EntityState.Move then
			BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)
		end
	elseif distance <= 4 then
		BehaviorFunctions.StopMove(self.me)
		BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.role)
	end
end


