---@class Controller
Controller = BaseClass("Controller",Module)

function Controller:__init()
	self:__InitCtrl()

	self.fight = nil
	EventMgr.Instance:AddListener(EventName.StartFight, function() self.fight = Fight.Instance end)
	EventMgr.Instance:AddListener(EventName.ExitFight, function() self.fight = nil end)
end

function Controller:__delete()
	EventMgr.Instance:RemoveListener(EventName.StartFight, function() self.fight = Fight.Instance end)
	EventMgr.Instance:RemoveListener(EventName.ExitFight, function() self.fight = nil end)
end

function Controller:__InitCtrl() end
function Controller:__InitComplete() end
--function Controller:__Clear() end