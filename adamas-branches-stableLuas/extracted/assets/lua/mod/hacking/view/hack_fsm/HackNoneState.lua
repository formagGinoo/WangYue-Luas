HackNoneState = BaseClass("HackNoneState", HackBaseState)

function HackNoneState:__init()

end

function HackNoneState:Init(mainView, fight, fsm, state)
	self:BaseFunc("Init", mainView, fight, fsm, state)
	
	self.locationPoint = "HackPoint"
	self.hackingSelectedRange = 0.1 + 0.0001
end

function HackNoneState:OnEnter()
	--self.hackManager:UpdateSelectedId()
	
	self.mainView:SafeSetAimEnable(true)
	self.mainView:UpdateHackEffect(true)
	
	self.hackingDistance = BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.HackingDistance)
end

function HackNoneState:Update()
	self.mainView:UpdateSelectedTarget(self.hackingSelectedRange, self.hackingDistance, self.locationPoint)
end

function HackNoneState:OnLeave()
	self.mainView:SafeSetAimEnable(false)
	--UnityUtils.SetActive(self.mainView.MessagePanel, false)
	
	--self.mainView:UpdateHackEffect(false)
end

function HackNoneState:OnCache()
end

function HackNoneState:__cache()
	self.fight.objectPool:Cache(HackUIFSM, self)
end

function HackNoneState:__delete()

end