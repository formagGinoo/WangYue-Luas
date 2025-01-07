FightResultFail = BaseClass("FightResultFail",BaseView)
FightResultFail.MODULE = FightFacade
function FightResultFail:__init()
	self:SetAsset("Prefabs/UI/FightResultFail/FightResultFail.prefab")
end

function FightResultFail:__delete()
end


function FightResultFail:__Create()

end


function FightResultFail:__BindListener()
	self:Find("bg",Button).onClick:AddListener(self:ToFunc("Exit"))
end

function FightResultFail:Exit()
	local animator = self:Find(nil, Animator)
	animator:SetBool("IsExit", true)
	self["20021"]:SetActive(false)

	local exitFunc = function ()
		Fight.Instance:SetFightState(FightEnum.FightState.Exit)
		self:Hide()
	end

	if not self.timer then
		self.timer = LuaTimerManager.Instance:AddTimer(1, 0.3, exitFunc, 1)
	end
end

function FightResultFail:__Show()
	EventMgr.Instance:Fire(EventName.ActiveView, FightEnum.UIActiveType.Main, false)
	self["20021"]:SetActive(true)
end

function FightResultFail:__Hide()
	if self.timer then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
        self.timer = nil
    end
end