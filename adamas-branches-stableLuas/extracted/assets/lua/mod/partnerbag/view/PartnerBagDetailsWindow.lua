PartnerBagDetailsWindow = BaseClass("PartnerBagDetailsWindow", BaseWindow)

local modelRoot = "PartnerRoot"

--预留参数 
--@partnerUniqueId 月灵unique_id
--@initTag 月灵详情界面选择的左边标签
--@hideView 是否隐藏相机
function PartnerBagDetailsWindow.OpenWindow(partnerUniqueId, initTag, hideView,AssetID)
    --加载场景
    Fight.Instance.modelViewMgr:LoadView(ModelViewConfig.ViewType.PartnerBag, function ()
        local partnerBagView = Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.PartnerBag)
        partnerBagView:LoadScene(ModelViewConfig.Scene.PartnerBag, function()
            BehaviorFunctions.fight.clientFight.cameraManager:GetCurCamera().camera:SetActive(false)
            Fight.Instance.modelViewMgr:ShowView(ModelViewConfig.ViewType.PartnerBag)
        end)
    end)
    --打开界面UI
    WindowManager.Instance:OpenWindow(PartnerBagDetailsWindow, {unique_id = partnerUniqueId, initTag = initTag, hideView = hideView,AssetID=AssetID})
end

function PartnerBagDetailsWindow:__init()
    self:SetAsset("Prefabs/UI/Role/CommonMainWindow.prefab")
end

function PartnerBagDetailsWindow:__BindEvent()
    
end

function PartnerBagDetailsWindow:__BindListener()
    self:SetHideNode("CommonMainWindow_Exit")
    self.CommonBack2_btn.onClick:AddListener(self:ToFunc("Close"))
    EventMgr.Instance:AddListener(EventName.PartnerInfoChange, self:ToFunc("PartnerInfoChange"))
    EventMgr.Instance:AddListener(EventName.FormationRoleSubmit, self:ToFunc("OnFormationRoleSubmit"))
    EventMgr.Instance:AddListener(EventName.TipHideEvent, self:ToFunc("TipHideEvent"))
end

function PartnerBagDetailsWindow:__Show()
    self.uniqueId = self.args.unique_id
    self.hideView = self.args.hideView
    self.AssetID =  self.args.AssetID or 0
    self.curTag =  self.args.initTag or PartnerBagConfig.PartnerBagPanelType.Attr
    self:CreateModelView(self.uniqueId)
    self:initCurrencyBar()
end

function PartnerBagDetailsWindow:__Hide()
    self:CacheCurrencyBar()
end

function PartnerBagDetailsWindow:__delete()
    EventMgr.Instance:RemoveListener(EventName.PartnerInfoChange, self:ToFunc("PartnerInfoChange"))
    EventMgr.Instance:RemoveListener(EventName.FormationRoleSubmit, self:ToFunc("OnFormationRoleSubmit"))
    EventMgr.Instance:RemoveListener(EventName.TipHideEvent, self:ToFunc("TipHideEvent"))
end

function PartnerBagDetailsWindow:SetCameraSetings(partnerData)
    
    
    local partner = partnerData and partnerData.template_id or 0
    local cameraConfig = RoleConfig.GetPartnerCameraConfig(partner, RoleConfig.PartnerCameraType.PartnerBag)
    local partnerBagView = self:GetModelView()

    partnerBagView:BlendToNewCamera(cameraConfig.camera_position, cameraConfig.camera_rotation, 24.5)
    partnerBagView:SetModelRotation(modelRoot, cameraConfig.model_rotation)
    partnerBagView:PlayModelAnim(modelRoot, cameraConfig.anim, 0.5)

    --local blurConfig = RoleConfig.GetPartnerBlurConfig(partner, RoleConfig.PartnerCameraType.PartnerBag)
    --partnerBagView:SetDepthOfFieldBoken(true, blurConfig.focus_distance, blurConfig.focal_length, blurConfig.aperture)
end

function PartnerBagDetailsWindow:GetModelView()
    return Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.PartnerBag)
end

-- 初始化货币栏
function PartnerBagDetailsWindow:initCurrencyBar()
    self.CurrencyBar1 = Fight.Instance.objectPool:Get(CurrencyBar)
    self.CurrencyBar1:init(self.GoldCurrencyBar, 2)
end

-- 移除货币栏
function PartnerBagDetailsWindow:CacheCurrencyBar()
    self.CurrencyBar1:OnCache()
end

function PartnerBagDetailsWindow:CreateModelView(uniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    
    local createCallBack = function ()
        self:SetCameraSetings(partnerData)
        self:CreatePanel()
    end
    --先判断是否已经加载过模型了
    self.isLoad =false --self:GetModelView():GetModel(modelRoot)
    if isLoad then
        if partnerData~=nil then
            self:GetModelView():LoadModel(modelRoot, partnerData.template_id)
        end
    else
        --加载模型
        if partnerData~=nil then
            self:GetModelView():LoadModel(modelRoot, partnerData.template_id, createCallBack)
        else
            createCallBack()
        end
        self.isLoad=true
    end
end

function PartnerBagDetailsWindow:CreatePanel()
    local uniqueId = self.uniqueId
    local callback = function ()
        self:InitTag(uniqueId)
    end
    self:OpenPanel(CommonLeftTabPanel, {name = TI18N("月灵"), name2 = "y u e l i n g", tabList = PartnerBagConfig.PartnerDetailsToggleInfo, callback = callback, notDelay = true})
end

function PartnerBagDetailsWindow:InitTag(uniqueId)
    --佩丛生产功能是否已经开放
    local isShowWork = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.PartnerWork)
    if isShowWork then
        local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
        local partnerWorkCfg = PartnerBagConfig.GetPartnerWorkConfig(partnerData.template_id)
        --读表判断该佩丛是否有生产功能
        if not partnerWorkCfg then
            isShowWork = false
        end
    end

    if not isShowWork then
        self.curTag = self.curTag == PartnerBagConfig.PartnerBagPanelType.Work and PartnerBagConfig.PartnerBagPanelType.Attr or self.curTag
        self:GetPanel(CommonLeftTabPanel):ShowOption(PartnerBagConfig.PartnerBagPanelType.Work, false)
    end
    self:GetPanel(CommonLeftTabPanel):SelectType(self.curTag)
end

function PartnerBagDetailsWindow:AddTipCommand(panel, config)
    EventMgr.Instance:Fire(EventName.AddSystemContent, panel, {args = config})
end

function PartnerBagDetailsWindow:OnFormationRoleSubmit(roleId)
   --打开 角色-月灵界面 + 选中该角色 + 打开替换月灵弹窗 + 选中该月灵
    RoleMainWindow.OpenWindow(roleId, {_jump = {[1] = RoleConfig.PageType.ZhongMo, [2] = self.uniqueId},[3]=self.AssetID})
end

function PartnerBagDetailsWindow:UpdateRoleList(...)
    self:CallPanelFunc("UpdateRoleList", ...)
end

function PartnerBagDetailsWindow:RefreshItemList(...)
    self:CallPanelFunc("RefreshItemList", ...)
end

function PartnerBagDetailsWindow:PartnerInfoChange(...)
    self:CallPanelFunc("PartnerInfoChange", ...)
end

function PartnerBagDetailsWindow:TipHideEvent(...)
    self:CallPanelFunc("TipHideEvent", ...)
end

function PartnerBagDetailsWindow:ShowCurView()
    BehaviorFunctions.fight.clientFight.cameraManager:GetCurCamera().camera:SetActive(false)
    Fight.Instance.modelViewMgr:ShowView(ModelViewConfig.ViewType.PartnerBag)
end

function PartnerBagDetailsWindow:HideCurView()
    BehaviorFunctions.fight.clientFight.cameraManager:GetCurCamera().camera:SetActive(true)
    Fight.Instance.modelViewMgr:HideView(ModelViewConfig.ViewType.PartnerBag)
end

function PartnerBagDetailsWindow:ShowCurModelRoot()
    local curModelRoot = self:GetModelView():GetModel(modelRoot)
    if curModelRoot then
        UtilsUI.SetActive(curModelRoot, true)
    end
end

function PartnerBagDetailsWindow:HideCurModelRoot()
    local curModelRoot = self:GetModelView():GetModel(modelRoot)
    if curModelRoot then
        UtilsUI.SetActive(curModelRoot, false)
    end
end

function PartnerBagDetailsWindow:__BeforeExitAnim()
    --self:GetModelView():RecoverCamera()
    --self:GetModelView():RecoverBlur()
    if self.hideView then
        self:HideCurView()
    end
    for key, value in pairs(self.panelList) do
        if value.active and value.HideAnim then
            value:HideAnim()
        end
    end
end

function PartnerBagDetailsWindow:__AfterExitAnim()
    WindowManager.Instance:CloseWindow(self)
end

function PartnerBagDetailsWindow:Close()
    local count = 1
    local func = function(res)
        if res then
            count = count - 1
            if count == 0 then
                self:PlayExitAnim()
            end
        end
    end
    for k, panel in pairs(self.panelList) do
        if panel.active and panel.TryExit then
            count = count + 1
            panel:TryExit(func)
        end
    end
    func(true)
end
