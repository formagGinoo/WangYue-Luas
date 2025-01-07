BargainChooseTimer = BaseClass("BargainChooseTimer", Module)

function BargainChooseTimer:__init(sliderList)
    self.sliderList = sliderList
    self.timerSpeed = 1/60
    self.maxTime = BargainConfig.GetBargainChooseCountTime()

    for _, slider in ipairs(self.sliderList) do
        slider.maxValue = self.maxTime
        slider.minValue = 0
    end
end

function BargainChooseTimer:__delete()
    
end

function BargainChooseTimer:StartTimer()
    if self.timer then
        LogError("回合计时器还未停止")
        LuaTimerManager.Instance:RemoveTimer(self.timer)
    end
    self.curTime = self.maxTime

    for _, slider in ipairs(self.sliderList) do
        slider.value = self.maxTime
    end

    self.timer = LuaTimerManager.Instance:AddTimer(0, self.timerSpeed, self:ToFunc("Update"))
end

function BargainChooseTimer:StopTimer()
    if not self.timer then
        LogError("回合计时器未开启")
        return
    end
    LuaTimerManager.Instance:RemoveTimer(self.timer)
    self.timer = nil
end

function BargainChooseTimer:Update()
    self.curTime = self.curTime - self.timerSpeed
    for _, slider in ipairs(self.sliderList) do
        slider.value = self.curTime
    end

    if self.curTime <= 0 then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
        self.timer = nil
        mod.BargainCtrl:PlayerChoice(BargainEnum.Choice.NoChoice)
    end
end