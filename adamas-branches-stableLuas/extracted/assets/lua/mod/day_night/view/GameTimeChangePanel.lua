GameTimeChangePanel = BaseClass("GameTimeChangePanel", BasePanel)

function GameTimeChangePanel:__init()
    self:SetAsset("Prefabs/UI/DayNight/GameTimeChangePanel.prefab")
end

function GameTimeChangePanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

local UnitAngle = -360
function GameTimeChangePanel:__Show()
    InputManager.Instance:SetCanInputState(false)
    self.startTime = self.args.startTime
    self.addTime = self.args.addTime
    self.time = 0
    self.callback = self.args.callBack
    self.startZ = self.startTime / (24 * 60) * UnitAngle
    UnityUtils.SetLocalEulerAngles(self.Icon_rect, 0, 0, self.startZ)
end

function GameTimeChangePanel:__Hide()
    if self.callback then
        self.callback()
    end
    InputManager.Instance:SetCanInputState(true)
end

function GameTimeChangePanel:__AfterExitAnim()
    PanelManager.Instance:ClosePanel(self)
end

local UnitTime = 5
function GameTimeChangePanel:Update()
    if not self.active then return end
    self.time = self.time + UnitTime
    if self.time > self.addTime then
        self.time = self.addTime
    end
    local z = (self.startTime + self.time) / (24 * 60) * UnitAngle
    UnityUtils.SetLocalEulerAngles(self.Icon_rect, 0, 0, z)
    if self.time == self.addTime then
        self:PlayExitAnim()
    end
end