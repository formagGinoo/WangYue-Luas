InputImageChangerManager = SingleClass("InputImageChangerManager")

function InputImageChangerManager:__init()
    self.nowDevice = nil
    self.changerListenerList = {}
end

function InputImageChangerManager:__delete()

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

function InputImageChangerManager:SetNowDevice(context)
    local deviceName = context.control.device.name
    local deviceType;
    if Application.platform == RuntimePlatform.IPhonePlayer or Application.platform == RuntimePlatform.Android then
        deviceType = self.DeviceType.Phone
    elseif Application.platform == RuntimePlatform.WindowsEditor or Application.platform == RuntimePlatform.WindowsPlayer then
        if deviceName == "Keyboard" then
            deviceType = self.DeviceType.KeyMouse
        elseif deviceName == "Mouse" then
            deviceType = self.DeviceType.KeyMouse
        elseif deviceName == "Gamepad" then
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
            deviceType = self.DeviceType.Other
        end
    else
        deviceType = self.DeviceType.Other
    end
    return deviceType
end

function InputImageChangerManager:AddChangerListener(inputImageChanger, gameObject, callback)
    for _, changer in pairs(self.changerListenerList) do
        if inputImageChanger == changer then
            return
        end
    end
    table.insert(self.changerListenerList, inputImageChanger)
    -- SingleIconLoader.Load(gameObject, "Textures/Icon/Single/ItemIcon/6.png")
    local text = gameObject:GetComponent(TextMeshProUGUI)
    text.text = " "
    inputImageChanger.InputLuaAction:RemoveAllListeners()
    inputImageChanger.InputLuaAction:AddListener(function(context, nowAction, action)
        -- if self.nowDevice == self:SetNowDevice(context) and self.nowDevice ~= nil then
        --     return
        -- end
        local deviceName = context.control.device.name
        local inputAction = tostring(action)
        local key = self:GetKeyByInputActionDevice(inputAction, deviceName)

        self.nowDevice = self:SetNowDevice(context)
        -- SingleIconLoader.Load(gameObject, "Textures/Icon/Single/ItemIcon/2002".. self.nowDevice ..".png")
        if key ~= nil then
            text.text = self.nowDevice .. key
        else
            text.text = " "
        end

        if callback ~= nil then
            callback()
        end
    end)
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