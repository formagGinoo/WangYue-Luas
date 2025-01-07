InputImageChangerManager = SingleClass("InputImageChangerManager")

function InputImageChangerManager:__init()
    self.changerListenerList = {}
    self.imagePath = "Textures/Icon/Atlas/ButtonIcon/"
    self.nowDevice = "KeyMouse"
end

function InputImageChangerManager:__delete()
    self.nowDevice = "KeyMouse"
    for _, v in pairs(self.changerListenerList) do
        v.changer.InputLuaAction:RemoveAllListeners()
    end
    TableUtils.ClearTable(self.changerListenerList)
end

InputImageChangerManager.DeviceType = 
{
    KeyMouse = "KeyMouse",
    PS = "PS",
    XBox = "XBox",
    Phone = "Phone",
    Other = "Other"
}

function InputImageChangerManager:GetNowDevice()
    return self.nowDevice
end

function InputImageChangerManager:SetNowDevice(deviceName)
    local deviceType;
    if Application.platform == RuntimePlatform.IPhonePlayer or Application.platform == RuntimePlatform.Android then
        deviceType = self.DeviceType.Phone
    elseif Application.platform == RuntimePlatform.WindowsEditor or Application.platform == RuntimePlatform.WindowsPlayer then
        if deviceName == "Keyboard" then
            deviceType = self.DeviceType.KeyMouse
        elseif deviceName == "Mouse" then
            deviceType = self.DeviceType.KeyMouse
        elseif deviceName == "Joystick" then
            deviceType = self.DeviceType.KeyMouse
        elseif deviceName == "DualShock4GamepadHID" then
            deviceType = self.DeviceType.PS
        elseif deviceName == "DualShock3GamepadHID" then
            deviceType = self.DeviceType.PS
        elseif deviceName == "DualSenseGamepadHID" then
            deviceType = self.DeviceType.PS
        elseif deviceName == "XInputControllerWindows" then    
            deviceType = self.DeviceType.XBox
        else
            deviceType = self.DeviceType.KeyMouse
            LogError(string.format("[%s]目前不支持按键提示呢，快找程序问问吧",deviceName))
        end
    else
        deviceType = self.DeviceType.KeyMouse
        LogError(string.format("[%s]目前不支持按键提示呢，快找程序问问吧",deviceName))

    end
    return deviceType
end

function InputImageChangerManager:AddChangerListener(inputImageChanger, gameObject, callback)
    local instanceId = inputImageChanger:GetInstanceID()
    if self.changerListenerList[instanceId] then
        return
    end
    self.changerListenerList[instanceId] = {changer = inputImageChanger, imgComp = nil}
    UtilsUI.SetActiveByScale(gameObject, false)
    local inputFunc = function(deviceName, key)
        self.nowDevice = self:SetNowDevice(deviceName)
        if self.nowDevice == InputImageChangerManager.DeviceType.Other then
            return
        end
        if key ~= "" then
            local goImage 
            if not self.changerListenerList[instanceId].imgComp then
                self.changerListenerList[instanceId].imgComp = gameObject:GetComponent(Image)
            end
            goImage = self.changerListenerList[instanceId].imgComp
            if goImage then
                key = string.gsub(key, "/", "")
                AtlasIconLoader.Load(gameObject, string.format("%s%s_%s.png",self.imagePath,self.nowDevice,key), function()
                    UtilsUI.SetActiveByScale(gameObject, true)
                    if callback then
                        callback()
                    end
                end)
            else
                LogError(string.format("[%s]没有加Image组件,快加加看吧",inputImageChanger.name))
            end
        else
            UtilsUI.SetActiveByScale(gameObject, false)
            if callback then
                callback()
            end
        end
    end
    inputImageChanger.InputLuaAction:RemoveAllListeners()
    inputImageChanger.InputLuaAction:AddListener(inputFunc)
end

function InputImageChangerManager:GetDeviceKeyByInputAction(inputAction)
    local result = {}
    for Device, Key in string.gmatch(inputAction, "/(%w+)/(%w+)") do
        table.insert(result, {device = Device, key = Key})
    end
    return result
end

function InputImageChangerManager:GetKeyByInputActionDevice(inputAction, device)
    local result = self:GetDeviceKeyByInputAction(inputAction)
    for k, v in pairs(result) do
        if device == "Mouse" then
           device = "Keyboard"
        end
        if device == v.device then
            return v.key
        end
    end
end