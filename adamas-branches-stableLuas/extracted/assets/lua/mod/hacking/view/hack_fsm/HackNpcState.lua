HackNpcState = BaseClass("HackNpcState", HackBaseState)

function HackNpcState:__init()

end

function HackNpcState:Init(mainView, fight, fsm, state)
	self:BaseFunc("Init", mainView, fight, fsm, state)
	
	self.locationPoint = "HackPoint"
	self.hackingSelectedRange = 0.1 + 0.0001
end

function HackNpcState:OnEnter(id)
	self.instanceId = id
	
	self.hackComponent = self.hackManager:GetHackComponent(id)

	self.mainView:SafeSetAimEnable(true)
	self.mainView:UpdateHackEffect(true)
	self.mainView:UpdateOperateButton()
	
	self.hackingDistance = BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.HackingDistance)
end

function HackNpcState:Update()
	self.mainView:UpdateSelectedTarget(self.hackingSelectedRange, self.hackingDistance, self.locationPoint)
	
	local id, lastId = self.hackManager:GetSelectedId()
	UnityUtils.SetActive(self.mainView.MessagePanel, id == self.instanceId)
	
	if self.hackComponent:GetUpOperateState() == FightEnum.HackOperateState.Continue then
		if lastId ~= id and id == self.instanceId then
			UnityUtils.SetActive(self.mainView.HackMainWindow_MessagePanel_Talk_Exit, false)
			UnityUtils.SetActive(self.mainView.HackMainWindow_MessagePanel_Talk_Open, true)
		end
		UnityUtils.SetActive(self.mainView.MiniTalk, id ~= self.instanceId)
	end
	
	if self.hackComponent:GetDownOperateState() == FightEnum.HackOperateState.Continue then
		if lastId ~= id then
			-- 转换了目标
			if not id then
				-- 移出了目标
				self.mainView:HackPhoneOpenMiniPhoneCall()
			elseif id == self.instanceId then
				-- 指向目标
				self.mainView:HackPhoneOpenPhoneCall()
			end
		end
		--[[
		if lastId ~= id and id == self.instanceId then
			UnityUtils.SetActive(self.mainView.UI_HackMainWindow_MessagePanel_PhoneCall_out, false)
			UnityUtils.SetActive(self.mainView.UI_HackMainWindow_MessagePanel_PhoneCall_in, true)
			print(id, lastId)
		end
		UnityUtils.SetActive(self.mainView.MiniPhoneCall, id ~= self.instanceId)
]]
	end
end

function HackNpcState:OnLeave()
	self.mainView:SafeSetAimEnable(false)
	
	--UnityUtils.SetActive(self.mainView.MessagePanel, false)
	UnityUtils.SetActive(self.mainView.MiniPhoneCall, false)
	UnityUtils.SetActive(self.mainView.MiniTalk, false)
	
	if self.mainView.MessagePanel.activeInHierarchy then
		UnityUtils.SetActive(self.mainView.HackMainWindow_MessagePanel_Talk_Open, false)
		UnityUtils.SetActive(self.mainView.HackMainWindow_MessagePanel_Talk_Exit, true)
		UnityUtils.SetActive(self.mainView.UI_HackMainWindow_MessagePanel_PhoneCall_in, false)
		UnityUtils.SetActive(self.mainView.UI_HackMainWindow_MessagePanel_PhoneCall_out, true)
	else
		UnityUtils.SetActive(self.mainView.PhoneCall, false)
		UnityUtils.SetActive(self.mainView.Talk, false)
	end
	
	--self.mainView:UpdateHackEffect(false)
	self.hackManager:SetHackingId()
	
	self.instanceId = nil
	self.hackComponent = nil
end

function HackNpcState:CloseToNone()
	return false
end

function HackNpcState:OnCache()
end

function HackNpcState:__cache()
	self.fight.objectPool:Cache(HackUIFSM, self)
end

function HackNpcState:__delete()

end