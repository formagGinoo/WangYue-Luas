CreateRoleWindow = BaseClass("CreateRoleWindow", BaseWindow)

function CreateRoleWindow:__init()
	self:SetAsset("Prefabs/UI/CreateRole/CreateRoleWindow.prefab")
end

function CreateRoleWindow:__BindListener()
    self.Role1Btn_btn.onClick:AddListener(self:ToFunc("OnClickRole1"))
    self.Role2Btn_btn.onClick:AddListener(self:ToFunc("OnClickRole2"))
    self.MakeSureRole3DPanel.RightCancleBtn_btn.onClick:AddListener(self:ToFunc("OnClickCancleBtn"))
    self.MakeSureRole3DPanel.LeftCancleBtn_btn.onClick:AddListener(self:ToFunc("OnClickCancleBtn"))
    self.MakeSureRole3DPanel.RightConfirmBtn_btn.onClick:AddListener(self:ToFunc("OnClickConfirmBtn1"))
    self.MakeSureRole3DPanel.LeftConfirmBtn_btn.onClick:AddListener(self:ToFunc("OnClickConfirmBtn2"))

    UtilsUI.SetHideCallBack(self.MakeSureRole3DPanel.RightPart_out, self:ToFunc("CloseTips"))
    UtilsUI.SetHideCallBack(self.LockTips_out, self:ToFunc("CloseLockTips"))
end

function CreateRoleWindow:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function CreateRoleWindow:__Create()
    local modelView = Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.CreateRole)
    local canvas = modelView:GetTargetTransform("MakeSureRole3DPanel", true)
    CameraManager.Instance:SetCameraInheritPosition(false)
    self.cameraAnim = modelView:GetTargetTransform("Camera", true):GetComponent(Animator)
    self.Canvas3D = canvas
    self.MakeSureRole3DPanel = {}
    UtilsUI.GetContainerObject(self.Canvas3D, self.MakeSureRole3DPanel)
    Fight.Instance.modelViewMgr:ShowView(ModelViewConfig.ViewType.CreateRole)
    self:SetCameraView(1,true)
end

function CreateRoleWindow:__delete()
    BgmManager.Instance:SetBgmState("BgmType", self.bgmType)
    BgmManager.Instance:SetBgmState("GamePlayType", self.gamePlayType)
end

function CreateRoleWindow:__Show()
    self.bgmType = self.args.bgmType
    self.gamePlayType = self.args.gamePlayType
end

function CreateRoleWindow:SetCameraView(case)
    local role1Anim
    if case == 1 or case == 4 then
        self.TitlePart_anim:Play("UI_TitlePart-IN_PC")
        role1Anim = "Ceshen_return"
    else
        role1Anim = "Ceshen_end"
        self.TitlePart_anim:Play("UI_TitlePart_out_PC")
    end
    local cameraConfig = CreateRoleConfig.GetCameraConfig(case)
    if case > 3 then case = case - 3 end
    local role2Config = CreateRoleConfig.GetCameraConfig(case+3)
    local modelView = Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.CreateRole)
    modelView:PlayModelAnim("Role1", role1Anim, 0.5)
    --modelView:SetModelRotation("Role1", cameraConfig.model_rotation)

    modelView:PlayModelAnim("Role2", role2Config.action, 0.5)
    --modelView:SetModelRotation("Role2", role2Config.model_rotation)
end


function CreateRoleWindow:__ShowComplete()
    -- local cb = function()
    --     BehaviorFunctions.PlayBgmSound("Bgm_Mountain_Combat")
    -- end
    -- local gameWwise = SoundManager.Instance:GetGameWwise()
	-- gameWwise:LoadSoundBank("", -1, true, cb)
	
    --BehaviorFunctions.PlayBgmSound("Memory")
end

function CreateRoleWindow:__Hide()
	-- BehaviorFunctions.StopBgmSound()
end

function CreateRoleWindow:OnBack()
    
end

function CreateRoleWindow:OnClickChangeBtn()

end


function CreateRoleWindow:EnterMakeSurePanel(index)
    if index == 2 then
        UtilsUI.SetActive(self.LockTips,true)
        self.tipsTimer = LuaTimerManager.Instance:AddTimer(1, 1, function ()
            self.LockTips_anim:Play("UI_LockTips_out_PC")
            LuaTimerManager.Instance:RemoveTimer(self.tipsTimer)
        end)
        return
    end

    self.TitlePart_anim:Play("UI_TitlePart_out_PC")

    self.LockTips_anim:Play("UI_LockTips_out_PC")
    self:SetCameraView(2)
end

function CreateRoleWindow:OnClickRole1()
    self:EnterMakeSurePanel(1)
    self.cameraAnim:Play("Camera01_female")
    UtilsUI.SetActive(self.Role1Btn,false)
    UtilsUI.SetActive(self.Role2Btn,false)
    self.chooseRoleTimer = LuaTimerManager.Instance:AddTimer(1, 1.3, function ()
        LuaTimerManager.Instance:RemoveTimer(self.closeTimer)
        self.chooseRoleTimer = nil
        UtilsUI.SetActive(self.MakeSureRole3DPanel.RightPart,true)
    end)
end

function CreateRoleWindow:OnClickRole2()
    self:EnterMakeSurePanel(2)
end

function CreateRoleWindow:OnClickConfirmBtn1()
    --self:SetCameraView(3)
    self.MakeSureRole3DPanel.RightPart_anim:Play("UI_MakeSureRole3DPanel_RightPart_out_PC")
    mod.InformationCtrl:SetSex(1)
    self.closeTimer = LuaTimerManager.Instance:AddTimer(1, 1, function ()
        LuaTimerManager.Instance:RemoveTimer(self.closeTimer)
        self.closeTimer = nil
        Fight.Instance.modelViewMgr:HideView(ModelViewConfig.ViewType.CreateRole)
        WindowManager.Instance:CloseWindow(self)
        CameraManager.Instance:SetCameraInheritPosition(true)
    end)
end

function CreateRoleWindow:OnClickConfirmBtn2()
    --self:SetCameraView(6)
    mod.InformationCtrl:SetSex(2)
    self.closeTimer = LuaTimerManager.Instance:AddTimer(1, 1, function ()
        LuaTimerManager.Instance:RemoveTimer(self.closeTimer)
        Fight.Instance.modelViewMgr:HideView(ModelViewConfig.ViewType.CreateRole)
        WindowManager.Instance:CloseWindow(self)
    end)
end

function CreateRoleWindow:OnClickCancleBtn()
    self:SetCameraView(1)
    self.cameraAnim:Play("Camera02_female")
    UtilsUI.SetActive(self.Role1Btn,true)
    UtilsUI.SetActive(self.Role2Btn,true)
    self.MakeSureRole3DPanel.RightPart_anim:Play("UI_MakeSureRole3DPanel_RightPart_out_PC")
end

function CreateRoleWindow:CloseTips()
    UtilsUI.SetActive(self.MakeSureRole3DPanel.RightPart,false)
end

function CreateRoleWindow:CloseLockTips()
    UtilsUI.SetActive(self.LockTips,false)
end

--打开Ui前,先加载场景
function CreateRoleWindow.OpenWindow(params)
    local bgmType = BgmManager.Instance:GetBgmState("BgmType")
    local gamePlayType = BgmManager.Instance:GetBgmState("GamePlayType")
    BgmManager.Instance:SetBgmState("BgmType", "System")
    BgmManager.Instance:SetBgmState("GamePlayType", "ChooseGender")

    Fight.Instance.modelViewMgr:LoadView(ModelViewConfig.ViewType.CreateRole, function ()
        Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.CreateRole):LoadScene(ModelViewConfig.Scene.CreateRole, function ()
            local view = Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.CreateRole)
            local playerUiModel1 = CreateRoleConfig.GetModelUi(1)
            local playerUiModel2 = CreateRoleConfig.GetModelUi(4)
            
            view:LoadModel("Role1", 1001001, function ()
                local config = CreateRoleConfig.GetCameraConfig(1)
                view:ShowModelRoot("Role1", true)
                view:PlayModelAnim("Role1", "Ceshen_return", 0.5)

                Fight.Instance.modelViewMgr:ShowView(ModelViewConfig.ViewType.CreateRole)
                WindowManager.Instance:OpenWindow(CreateRoleWindow,{bgmType = bgmType,gamePlayType = gamePlayType})
                --view:SetModelRotation("Role1", config.model_rotation)
            end, playerUiModel1)

            view:LoadModel("Role2", 1001006, function ()
                local config = CreateRoleConfig.GetCameraConfig(4)
                view:ShowModelRoot("Role2", true)
                view:PlayModelAnim("Role2", config.action, 0)
                --view:SetModelRotation("Role2", config.model_rotation)
            end, playerUiModel2)

            --local gameWwise = SoundManager.Instance:GetGameWwise()
	        --gameWwise:LoadSoundBank("Bgm_ChooseGender", -1, true, function()
            
            --end)
        
            local config = CreateRoleConfig.GetCameraConfig(1)
            Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.CreateRole):BlendToNewCamera(config.camera_position, config.camera_rotation, 24.5)
        end)
    end)
end

