CallVehicleWindow = BaseClass("CallVehicleWindow", BaseWindow)
--冒险界面梦魇入口
local _tinsert = table.insert
local modelTrans = "VehicleRoot" --模型挂点
local minNum = 5 --最小5个
local GrayColor = Color(123 / 255, 123 / 255, 123 / 255, 1)
local NormalColor = Color(255 / 255, 255 / 255, 255 / 255, 1)

function CallVehicleWindow:__init()
    self:SetAsset("Prefabs/UI/CallVehicle/CallVehicleWindow.prefab")
    self.selectVehicleId = nil --当前选择车的id
    self.vehicleData = {} --已经解锁车辆的数据
    
    --ui
    self.leftItemListUI = {}
end

function CallVehicleWindow:__Create()
    
end

function CallVehicleWindow:CreateScence()
    BehaviorFunctions.fight.clientFight.cameraManager:GetCurCamera().camera:SetActive(false)
    Fight.Instance.modelViewMgr:LoadView(ModelViewConfig.ViewType.Vehicle, function ()
        local vehicle = Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.Vehicle)
        vehicle:LoadScene(ModelViewConfig.Scene.Vehicle, function()
            Fight.Instance.modelViewMgr:ShowView(ModelViewConfig.ViewType.Vehicle)
            vehicle:BlendToNewCamera(CallVehicleConfig.CameraPos.Near.pos, CallVehicleConfig.CameraPos.Near.rot)
			self:UpdateModel()
        end)
    end)
end

function CallVehicleWindow:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function CallVehicleWindow:__BindListener()
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("OnClick_CloseBtn"))
    self.submitBtn_btn.onClick:AddListener(self:ToFunc("OnClickSubmitBtn"))
    EventMgr.Instance:AddListener(EventName.CallVehicleTime, self:ToFunc("UpdateBtnTimer"))

    local modelRotation = { x = 0, y = 0, z = 0 }
    local dragBehaviour = self.modelDrag:AddComponent(UIDragBehaviour)
    dragBehaviour.onDrag = function(data)
        local rotation = Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.Vehicle):GetModelRotation(modelTrans)
        if rotation then
            modelRotation.x = rotation.eulerAngles.x
            modelRotation.y = rotation.eulerAngles.y - data.delta.x * 0.5
            modelRotation.z = rotation.eulerAngles.z
            Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.Vehicle):SetModelRotation(modelTrans, modelRotation)
        end
    end
end

function CallVehicleWindow:__Show()
    --获取当前已经激活了的车辆
    self:UpdateData()
    --加载场景
    self:CreateScence()
    --更新左侧
    self:UpdateLeft()
    --更新右侧
    self:UpdateRight()
    --更新按钮
    self:UpdateBtnTimer()
end

function CallVehicleWindow:__Hide()
    
end

function CallVehicleWindow:__delete()
    BehaviorFunctions.fight.clientFight.cameraManager:GetCurCamera().camera:SetActive(true)
    Fight.Instance.modelViewMgr:HideView(ModelViewConfig.ViewType.Vehicle)
    if self.leftScrollView_recyceList then
        self.leftScrollView_recyceList:CleanAllCell()
    end
end

function CallVehicleWindow:UpdateModel()
    if not self.selectVehicleId then return end
    Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.Vehicle):LoadModel(modelTrans, self.selectVehicleId)
end

function CallVehicleWindow:UpdateData()
    self.vehicleData = {}
    local firstId 
    local vehicleUnlockList = mod.CallVehicleCtrl:GetVehicleUnlockList()
    for _, id in ipairs(vehicleUnlockList) do
        if not firstId then
            firstId = id
        end
        _tinsert(self.vehicleData, {id = id})
    end
    self.selectVehicleId = mod.CallVehicleCtrl:GetLastVehicleId() or firstId
end

function CallVehicleWindow:UpdateLeft()
    if self.leftScrollView_recyceList then
        local num = #self.vehicleData > minNum and #self.vehicleData or minNum
        self.leftScrollView_recyceList:SetLuaCallBack(self:ToFunc("OnLeftScroll"))
        self.leftScrollView_recyceList:SetCellNum(num)
    end
end

function CallVehicleWindow:OnLeftScroll(index, go)
    if not go then
        return
    end
    self.leftItemListUI[index] = go
    
    local data = self.vehicleData[index]
    if not data then
        return
    end
    
    local vehicleConfig = CallVehicleConfig.GetVehicleConfigById(data.id)
    local node = UtilsUI.GetContainerObject(go)
    node.select:SetActive(self.selectVehicleId == data.id)
    --车辆图标
    if vehicleConfig and vehicleConfig.vehicle_icon ~= "" then
        SingleIconLoader.Load(node.icon, vehicleConfig.vehicle_icon, function()
            node.icon:SetActive(true)
        end)
    end

    node.bg_btn.onClick:RemoveAllListeners()
    node.bg_btn.onClick:AddListener(function()
        self:OnClickLeftItem(index)
    end)
end

function CallVehicleWindow:OnClickLeftItem(index)
    local data = self.vehicleData[index]
    self.selectVehicleId = data.id
    
    for i, go in pairs(self.leftItemListUI) do
        local node = UtilsUI.GetContainerObject(go)
        node.select:SetActive(i == index)
    end
    --刷新模型
    self:UpdateModel()
    --更新右侧数据
    self:UpdateRight()
end

function CallVehicleWindow:UpdateRight()
    if not self.selectVehicleId then self.right:SetActive(false) return end
    self.right:SetActive(true)
    local vehicleConfig = CallVehicleConfig.GetVehicleConfigById(self.selectVehicleId)
    if vehicleConfig then
        --名字
        self.name_txt.text = vehicleConfig.car_name
        --描述文本
        self.desc_txt.text = vehicleConfig.content
    end
end

function CallVehicleWindow:UpdateBtnTimer()
    local openVehicleTime = mod.CallVehicleCtrl:GetOpenVehicleTime()
    if openVehicleTime then
        self.submitBtn_btn.enabled = false
        self.submitBtn_img.color = GrayColor
        local time = mod.CallVehicleCtrl:GetRemainVehicleTime()
        self.submitBtnText_txt.text = string.format("当前冷却时间剩余%.0f秒", time)
    else
        self.submitBtn_btn.enabled = true
        self.submitBtn_img.color = NormalColor
        self.submitBtnText_txt.text = TI18N("确定")
    end
end

function CallVehicleWindow:OnClickSubmitBtn()
    if not self.selectVehicleId then return end
    --先查询下地图有没有交通数据  
    local mapId = Fight.Instance:GetFightMap()
    if mapId ~= 10020005  then
        MsgBoxManager.Instance:ShowTips(TI18N("当前场景无法驾驶车辆"))
        return
    end
    
    --调用交通系统的接口
    local vehicleConfig = CallVehicleConfig.GetVehicleConfigById(self.selectVehicleId)
    local instanceId = BehaviorFunctions.SummonCar(vehicleConfig.entity_id)
    if instanceId then
        --成功后开始计时,保存这次使用的车辆id
        mod.CallVehicleCtrl:OpenVehicleTime(true)
        mod.CallVehicleCtrl:SetLastVehicleId(self.selectVehicleId)
        WindowManager.Instance:CloseWindow(self)
    else
        MsgBoxManager.Instance:ShowTips(TI18N("当前位置车辆无法到达"))
    end
end

function CallVehicleWindow:OnClick_CloseBtn()
    WindowManager.Instance:CloseWindow(self)
end












