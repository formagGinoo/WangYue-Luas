HackBaseState = BaseClass("HackBaseState", PoolBaseClass)

function HackBaseState:__init()

end

function HackBaseState:Init(mainView, fight, fsm)
	self.mainView = mainView
	self.fight = fight
	self.fsm = fsm
	
	self.hackManager = self.fight.hackManager
end

function HackBaseState:CloseToNone()
	return false
end

function HackBaseState:OnEnter()
end

function HackBaseState:Update()
end

function HackBaseState:OnLeave()
end

function HackBaseState:OnSwitchEnd()
end

function HackBaseState:OnCache()
end

function HackBaseState:__cache()
end

function HackBaseState:__delete()

end