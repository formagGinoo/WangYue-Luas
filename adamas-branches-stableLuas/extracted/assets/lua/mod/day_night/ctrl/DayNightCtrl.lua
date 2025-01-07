DayNightCtrl = BaseClass("DayNightCtrl", Controller)

function DayNightCtrl:__init()
    self.curTime = 0
    --初始偏移值，就不让后端记录了
    self.offset = SystemConfig.GetCommonValue("PlayerInitialGameTime").int_val
end

function DayNightCtrl:UpdataTime(time)
    self.curTime = time + self.offset
end

function DayNightCtrl:SetTime(time, record)
    self.curTime = time
    if LoginCtrl.IsInGame() and record then
        local id, cmd = mod.DayNightFacade:SendMsg("client_inner_time", time - self.offset)
        mod.LoginCtrl:AddClientCmdEvent(id, cmd, function() end)
    end
end

function DayNightCtrl:GetTime()
    return self.curTime
end