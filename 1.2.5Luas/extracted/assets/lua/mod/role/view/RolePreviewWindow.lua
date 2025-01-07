RolePreviewWindow = BaseClass("RolePreviewWindow", BaseWindow)
local Camera ={
    DetailCamera = 1
}

function RolePreviewWindow:__init()
    self:SetAsset("Prefabs/UI/RolePreview/RolePreviewWindow.prefab")
    self.index = 1
end

function RolePreviewWindow:__BindListener()
    self.CloseButton_btn.onClick:AddListener(self:ToFunc("OnClick_ColseWindow"))
    self.RoleButton1_btn.onClick:AddListener(self:ToFunc("OnClick_RoleOne"))
    self.RoleButton2_btn.onClick:AddListener(self:ToFunc("OnClick_RoleTwo"))
    self.NextButton_btn.onClick:AddListener(self:ToFunc("OnClick_ChangePreViewRole"))
    self.LastButton_btn.onClick:AddListener(self:ToFunc("OnClick_ChangePreViewRole"))
    self.ShowDetailButton_btn.onClick:AddListener(self:ToFunc("OnClick_ShowDetail"))
    local scrollbar = self.Scrollbar:GetComponent(Scrollbar)
    scrollbar.onValueChanged:AddListener(self:ToFunc("OnValueChanged_Camera"))
end

function RolePreviewWindow:__Create()
    EventMgr.Instance:Fire(EventName.ShowScenneObj, false)
    self.model3DView = Model3DView.New(self, self.DrapBG, "Prefabs/Scene/SceneRoleShow/SceneRoleShow.prefab")
    --self.model3DView:SetScenePosition(0, 1.5, 0)
    self.model3DView:SetCameraSetings(0, 1.25, 5, 4, -180, 0, 24.5)
end

function RolePreviewWindow:__Show()
    self.isFighting = self.args
    if self.isFighting then
        EventMgr.Instance:Fire(EventName.ShowFightDisplay, false)
    end
    if self.model3DView then
        self.model3DView:ShowCharacter(1001)
    end
    BehaviorFunctions.SetCameraState(FightEnum.CameraState.Operating)
end

function RolePreviewWindow:__Hide()
    if self.isFighting then
        EventMgr.Instance:Fire(EventName.ShowFightDisplay, true)
    end
    if self.model3DView then
        self.model3DView:DeleteMe()
    end
    EventMgr.Instance:Fire(EventName.ShowScenneObj, true)
end

function RolePreviewWindow:OnClick_ColseWindow()
    WindowManager.Instance:CloseWindow(RolePreviewWindow)
end

function RolePreviewWindow:OnClick_RoleOne()
    if self.index == 1 then
        return
    end
    self.index = 1
    self.model3DView:ShowCharacter(1001)
    self.SelectBG1:SetActive(true)
    self.SelectBG2:SetActive(false)
    self.Name1:SetActive(true)
    self.Name2:SetActive(false)
end

function RolePreviewWindow:OnClick_RoleTwo()
    if self.index == 2 then
        return
    end
    self.index = 2
    self.model3DView:ShowCharacter(1002)
    self.SelectBG1:SetActive(false)
    self.SelectBG2:SetActive(true)
    self.Name1:SetActive(false)
    self.Name2:SetActive(true)
end

function RolePreviewWindow:OnClick_ChangePreViewRole()
    if self.index == 1 then
        self:OnClick_RoleTwo()
    else
        self:OnClick_RoleOne()
    end
end

function RolePreviewWindow:OnClick_ShowDetail()
    self.ScrollPart:SetActive(not self.ScrollPart.activeSelf)
    local isShow = self.ScrollPart.activeSelf
    self.model3DView:ShowCustomCamera(Camera.DetailCamera, isShow)
    if isShow then
        self.Scrollbar:GetComponent(Scrollbar).value = 1
    end
end

function RolePreviewWindow:OnValueChanged_Camera(value)
    self.model3DView:SetCustomCameraSettings(Camera.DetailCamera, 0, value + 0.4, 2, 0, -180, 0)
end