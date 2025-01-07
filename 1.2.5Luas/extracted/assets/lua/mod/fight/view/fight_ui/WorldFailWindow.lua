WorldFailWindow = BaseClass("WorldFailWindow", BaseWindow)

function WorldFailWindow:__init()
    self:SetAsset("Prefabs/UI/FightResultFail/WorldFailWindow.prefab")
    self:SetCacheMode(UIDefine.CacheMode.hide)

    self.isDup = false
    self.countDownTime = 10
    self.reviveCountDown = nil
    self.showCountDownTimer = nil
    self.controlNodes = {}
end

function WorldFailWindow:__BindListener()
    self.ReviveBtn_btn.onClick:AddListener(self:ToFunc("OnClick_Revive"))
end

function WorldFailWindow:__Show()
    self.isDup = self.args[1]
end

function WorldFailWindow:__ShowComplete()
    -- if not self.blurBack then
    --     self.blurBack = BlurBack.New(self, {passEvent = UIDefine.BlurBackCaptureType.Scene})
    -- end
    -- self:SetActive(false)
    -- self.blurBack:Show({self:ToFunc("BlurComplete")})
    self:BlurComplete()
end

function WorldFailWindow:BlurComplete()
    local countDownFunc = function()
        self.CountDown:SetActive(self.isDup)
        if self.isDup then
            self.reviveCountDown = LuaTimerManager.Instance:AddTimer(10, 1, self:ToFunc("OnCountDown"))
        end
    end
    self.showCountDownTimer = LuaTimerManager.Instance:AddTimer(1, 1, countDownFunc)

    self:BindEffectControl()
    -- self:SetActive(true)
end

function WorldFailWindow:BindEffectControl()
    if not self.controlNodes or not next(self.controlNodes) then
        UtilsUI.GetContainerObject(self.ControlNode.transform, self.controlNodes)
    end

    self.controlNodes.CloseNode_hcb.HideAction:AddListener(self:ToFunc("CloseFunc"))
end

function WorldFailWindow:OnCountDown()
    self.countDownTime = self.countDownTime - 1
    self.CountDown_txt.text = string.format("%d秒后自动放弃", self.countDownTime)

    if self.countDownTime == 0 then
        -- self.controlNodes.CloseNode:SetActive(false)
        self:CloseFunc()
    end
end

function WorldFailWindow:Revive()
    if self.isDup then
        local dupId, dupLevelId = mod.WorldMapCtrl:GetDuplicateInfo()
        mod.WorldMapFacade:SendMsg("duplicate_quit", dupLevelId)
    else
        local entityList = Fight.Instance.playerManager:GetPlayer():GetEntityList()
        for k, v in pairs(entityList) do
            v:Revive(true)
        end
    end
end

function WorldFailWindow:OnClick_Revive()
    self.close:SetActive(true)
end

function WorldFailWindow:CloseFunc()
    self:Revive()

    -- TODO 测试逻辑
    --LoadPanelManager.Instance:FakeLoading(1)

    WindowManager.Instance:CloseWindow(self)
end

function WorldFailWindow:__Hide()
    self.isDup = false
    self.countDownTime = 10
    if self.reviveCountDown then
        LuaTimerManager.Instance:RemoveTimer(self.reviveCountDown)
        self.reviveCountDown = nil
    end

    if self.showCountDownTimer then
        LuaTimerManager.Instance:RemoveTimer(self.showCountDownTimer)
        self.showCountDownTimer = nil
    end

    self.controlNodes.CloseNode_hcb.HideAction:RemoveAllListeners()
end

function WorldFailWindow:__delete()
    if self.reviveCountDown then
        LuaTimerManager.Instance:RemoveTimer(self.reviveCountDown)
        self.reviveCountDown = nil
    end

    if self.showCountDownTimer then
        LuaTimerManager.Instance:RemoveTimer(self.showCountDownTimer)
        self.showCountDownTimer = nil
    end
end