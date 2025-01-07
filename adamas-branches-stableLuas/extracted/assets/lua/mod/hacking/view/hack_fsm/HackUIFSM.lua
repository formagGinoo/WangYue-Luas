HackUIFSM = BaseClass("HackUIFSM", FSM)

local HackType = FightEnum.HackingType
local HackUIState = HackingConfig.HackUIState

local HackNone = 10000
local BuildNone = 20000

function HackUIFSM:__init()

end

function HackUIFSM:Init(mainView)
	self.mainView = mainView
	self.fight = Fight.Instance
	
	self:InitStates()
end

function HackUIFSM:InitStates()
	local objectPool = self.fight.objectPool
	self:AddState(HackUIState.HackNone, objectPool:Get(HackNoneState))
	self:AddState(HackUIState.HackCamera, objectPool:Get(HackCameraState))
	self:AddState(HackUIState.HackNpc, objectPool:Get(HackNpcState))
	
	
	self:AddState(HackUIState.BuildNone, objectPool:Get(BuildNoneState))
	
	
	for k, v in pairs(self.states) do
		v:Init(self.mainView, self.fight, self)
	end

end

function HackUIFSM:IsHacking()
	return self.curState > HackUIState.HackNone and self.curState < HackUIState.BuildNone
end

function HackUIFSM:TrySwitchState(state, ...)
	if not state or not self.states[state] then
		return false
	end
	
	self:SwitchState(state, ...)
	return true
end

function HackUIFSM:CloseToNone()
	if not self.statesMachine then
		return false
	end
	
	return self.statesMachine:CloseToNone()
end

function HackUIFSM:Update()
	if not self.statesMachine then 
		return 
	end
	
	self.statesMachine:Update()
end

function HackUIFSM:OnLeave()
	if self.statesMachine then
		self.statesMachine:OnLeave()
	end
	
	self.curState = nil
end

function HackUIFSM:OnCache()
	self:CacheStates()
	self.fight.objectPool:Cache(HackUIFSM, self)
end

function HackUIFSM:__delete()

end