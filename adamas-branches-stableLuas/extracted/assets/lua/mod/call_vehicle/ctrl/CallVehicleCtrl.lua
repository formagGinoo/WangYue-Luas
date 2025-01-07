CallVehicleCtrl = BaseClass("CallVehicleCtrl",Controller)
--梦魇副本的ctrl
local _tinsert = table.insert
local CoolingTime = 60 --冷却时间

function CallVehicleCtrl:__init()
    self.time = CoolingTime
    self.vehicleUnlockList = {} --已经解锁的车辆的数据
    self.allVehicleUnlockList = {} --所有已经解锁的车辆数据(方便索引)
    self.lastVehicleId = nil --上次选择呼叫的车辆
end

--更新解锁车辆的数据
function CallVehicleCtrl:UpdateVehicleData(data)
    for order, id in ipairs(data.unlock_list) do
        self.allVehicleUnlockList[id] = id
        _tinsert(self.vehicleUnlockList, id)
    end
end

--获取解锁车辆的数据
function CallVehicleCtrl:GetVehicleUnlockList()
    return self.vehicleUnlockList
end

--根据id获取解锁车辆的数据
function CallVehicleCtrl:GetVehicleDataById(id)
    return self.allVehicleUnlockList[id]
end

--设置上次选择的车辆
function CallVehicleCtrl:SetLastVehicleId(id)
    self.lastVehicleId = id 
end

--获取上次选择的车辆
function CallVehicleCtrl:GetLastVehicleId()
    return self.lastVehicleId
end

function CallVehicleCtrl:LowUpdate()
    --每计时一次发出一次消息，刷新UI界面
    if self.openVehicleTime then
        self.time = self.time - Global.lowUpdateTime
        if self.time <= 0 then
            self:OpenVehicleTime(false)
        end
        EventMgr.Instance:Fire(EventName.CallVehicleTime)
    end
end

--计时开关
function CallVehicleCtrl:GetOpenVehicleTime()
    return self.openVehicleTime
end

--计时开关
function CallVehicleCtrl:OpenVehicleTime(isOpen)
    self.openVehicleTime = isOpen
    if not isOpen then
        self.time = CoolingTime
    end
end

--获取当前剩余时间
function CallVehicleCtrl:GetRemainVehicleTime()
    return self.time
end
