FSM = BaseClass("FSM",PoolBaseClass)

function FSM:__init()
	self.states = {}
end

function FSM:Init()
	
end

function FSM:AddState(state,stateMachine)
	self.states[state] = stateMachine
end

function FSM:EnterState(state)
	self.curState = state
	self.statesMachine = self.states[self.curState] 
	self.statesMachine:OnEnter()
end

function FSM:SwitchState(state,...)
	local lastState = self.states[self.curState]
	if lastState and state ~= self.curState then
		lastState:OnLeave()
	end
	
	self.curState = state
	self.statesMachine = self.states[self.curState]
	self.statesMachine:OnEnter(...)

	if lastState and lastState ~= self.curState then
		lastState:OnSwitchEnd()
	end
end

function FSM:Update()
	if not self.statesMachine then return end
	self.statesMachine:Update()
end

function FSM:IsState(state)
	return self.curState == state
end

function FSM:GetState()
	return self.curState
end

function FSM:CacheStates()
	for k, v in pairs(self.states) do
		v:OnCache()
	end
	self.states = {}
end

function FSM:OnCache()

end

function FSM:__cache()
	self.states = {}
end

function FSM:__delete()
	for k,v in pairs(self.states) do
		v:DeleteMe()
	end
	self.states = nil
end