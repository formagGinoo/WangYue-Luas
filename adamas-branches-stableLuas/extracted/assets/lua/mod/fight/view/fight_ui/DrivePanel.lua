DrivePanel = BaseClass("DrivePanel", BasePanel, SystemView)

function DrivePanel:__init(parent)
    self:SetAsset("Prefabs/UI/Fight/DrivePanel.prefab")
    self.mainView = parent
end

function DrivePanel:__BaseShow()
    self:SetParent(self.mainView.PanelParent.transform)
	--UtilsUI.SetActiveByPosition(self.gameObject, false)
end
function DrivePanel:__BindListener()
    --self:SetHideNode("CommonBack2_")
    EventMgr.Instance:AddListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
    EventMgr.Instance:AddListener(EventName.ActionInputEnd, self:ToFunc("OnActionInputEnd"))
    --这里注册下按钮
    self:BindDriveCarButtonEvent(self.AccelerateNode, FightEnum.KeyEvent.Drone_Boost)
    self:BindDriveCarButtonEvent(self.BrakeNode, FightEnum.KeyEvent.Drone_Brake)
    self:BindDriveCarButtonEvent(self.GetOffCarNode, FightEnum.KeyEvent.Drone_Down)


    
    UtilsUI.SetActive(self.ModeDes, false)
    local func = function()
        UtilsUI.SetActive(self.ModeDes, not self.ModeDes.activeSelf)
    end
    
    self.ModeNode_btn.onClick:RemoveAllListeners()
    self.ModeNode_btn.onClick:AddListener(func)

    local trafficMode = BehaviorFunctions.GetTrafficMode()
    if trafficMode == FightEnum.TrafficMode.Normal then
        UtilsUI.SetActive(self.Mode1, true)
        UtilsUI.SetActive(self.Mode2, false)
        self.ModeTxt_txt.text = TI18N("处于都市自由模式时，请注意遵守交通规则")
    else
        UtilsUI.SetActive(self.Mode2, true)
        UtilsUI.SetActive(self.Mode1, false)
        self.ModeTxt_txt.text = TI18N("处于安全竞速模式时不会触发交通违法")
    end
end

function DrivePanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
    EventMgr.Instance:RemoveListener(EventName.ActionInputEnd, self:ToFunc("OnActionInputEnd"))
end

--缓存对象
function DrivePanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
    self:AddSystemState(SystemStateConfig.StateType.Car)
end

function DrivePanel:__Create()
end

function DrivePanel:SetDroneId(droneInstanceId)
    self.droneInstanceId = droneInstanceId
end

function DrivePanel:__Hide()
end

function DrivePanel:__Show()
end

function DrivePanel:__ShowComplete()
    --self.mainView:AddLoadDoneCount()
end

function DrivePanel:BindDriveCarButtonEvent(gameObject, key)
    local pointer = gameObject:GetComponent(UIDragBehaviour)
    if pointer then
        pointer.onPointerDown = nil
        pointer.onPointerUp = nil
    else
        pointer = gameObject:AddComponent(UIDragBehaviour)
    end

    local down = function (data)
        if InputManager.Instance then
            InputManager.Instance:KeyDown(key)
        end
    end

    local up = function (data)
        if InputManager.Instance then
            InputManager.Instance:KeyUp(key)
        end
    end

    pointer.onPointerDown = down--{"+=", down}
    pointer.onPointerUp = up--{"+=", up}
end


function DrivePanel:Close_HideCallBack()
    local curInstanceId = BehaviorFunctions.GetCtrlEntity()
    local droneInstanceId = Fight.Instance.entityManager:GetTrafficCtrlEntity(curInstanceId)
    Fight.Instance.entityManager:CallBehaviorFun("OnStopDrive", droneInstanceId)
    self.tcaaInvoke = nil
end

function DrivePanel:OnActionInput(key, value)
    if key == FightEnum.KeyEvent.Drone_Down then
        UtilsUI.SetActive(self.GetOffCarEffect, true)
        self:Close_HideCallBack()
    elseif key == FightEnum.KeyEvent.Drone_Brake then
        UtilsUI.SetActive(self.BrakeEffect, true)
    elseif key == FightEnum.KeyEvent.Drone_Boost then
        UtilsUI.SetActive(self.AccelerateEffect, true)
    elseif key == FightEnum.KeyEvent.UI_OpenMap then
        --打开地图
        WindowManager.Instance:OpenWindow(WorldMapWindow)
    elseif key == FightEnum.KeyEvent.UI_OpenTask then
        --打开任务
        WindowManager.Instance:OpenWindow(TaskMainWindow)
    end
end

function DrivePanel:OnActionInputEnd(key, value)
    
    if key == FightEnum.KeyEvent.Drone_Down then
        UtilsUI.SetActive(self.GetOffCarEffect, false)
    elseif key == FightEnum.KeyEvent.Drone_Brake then
        UtilsUI.SetActive(self.BrakeEffect, false)
    elseif key == FightEnum.KeyEvent.Drone_Boost then
        UtilsUI.SetActive(self.AccelerateEffect, false)
    end
end


function DrivePanel:Update()
    do
        return
    end
    local ctrlEntity = BehaviorFunctions.GetTrafficCtrlEntity()
    if not ctrlEntity then
        self.tcaaInvoke = nil
    elseif not self.tcaaInvoke then
        self.tcaaInvoke = ctrlEntity.clientTransformComponent.gameObject:GetComponent(TCCAInvoke)
    end
    

    if self.tcaaInvoke then
        local speed = self.tcaaInvoke:GetForwardVelocity()
        local accValue = self.tcaaInvoke:GetForwardAC()
        local formattedValue = string.format("%.1f", speed)
        UtilsUI.SetActive(self.ModeDes, true)
        self.ModeTxt_txt.text = formattedValue *3.6 .. "  km/h " ..  string.format("\n%.1f", accValue).." m/s^2"
    end
end


--#endregion