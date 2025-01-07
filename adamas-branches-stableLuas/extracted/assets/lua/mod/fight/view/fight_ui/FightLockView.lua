FightLockView = BaseClass("FightLockView",ExtendView)
FightLockView.MODULE = FightFacade

function FightLockView:__init()
	self.visible = true
	self.uivisible = true
end

function FightLockView:__Show()

end

function FightLockView:__CacheObject()
	self.lockGO = self:Find("main_/Other_/LockEffect").gameObject
	self.lockGO:SetActive(false)
end

function FightLockView:__BindListener()
	EventMgr.Instance:AddListener(EventName.SetLockTarget, self:ToFunc("SetLockTarget"))
	EventMgr.Instance:AddListener(EventName.SetLockTargetUI, self:ToFunc("SetLockTargetUI"))
	EventMgr.Instance:AddListener(EventName.SetLockPointVisible, self:ToFunc("SetLockPointVisible"))
end

function FightLockView:__Hide()
	--self.target = nil
	self.lockGO:SetActive(false)
end

local pos
local sp
function FightLockView:Update()
	if not self.visible then
		return
	end
	
	if not UtilsBase.IsNull(self.target) then
		pos = self.target.position
		sp = UtilsBase.WorldToUIPointBase(pos.x, pos.y, pos.z)
		self.lockGO:SetActive(sp.z > 0)
		if sp.z > 0 then
			UnityUtils.SetLocalPosition(self.lockGO.transform, 
				sp.x, sp.y , 0)
		end
		--self.lockGO.transform.position = sp
	end
end

function FightLockView:SetLockTargetUI(active)
	self.uivisible = active
end

function FightLockView:SetLockTarget(target, uiLockTarget)
	self.target = uiLockTarget or target
	
	if not self.visible then
		return
	end
	local visible = self.target ~= nil and self.uivisible == true
	self.lockGO:SetActive(visible)
end

function FightLockView:SetLockPointVisible(visible)
	self.visible = visible
	if not visible then
		self.lockGO:SetActive(visible)
	end
end

function FightLockView:__delete()
	self.target = nil
	self.visible = true

	EventMgr.Instance:RemoveListener(EventName.SetLockTarget, self:ToFunc("SetLockTarget"))
	EventMgr.Instance:RemoveListener(EventName.SetLockPointVisible, self:ToFunc("SetLockPointVisible"))
end

