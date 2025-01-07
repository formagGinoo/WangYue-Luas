PartnerMainWindow = BaseClass("PartnerMainWindow", BaseWindow)

local previewScene = "Prefabs/Scene/SceneUI_01/SceneUI_01.prefab"
local partnerIndex = "PartnerRoot"
local onSceneLoad = false

function PartnerMainWindow:__init()
    self:SetAsset("Prefabs/UI/Role/CommonMainWindow.prefab")
end

function PartnerMainWindow:__BindEvent()
    EventMgr.Instance:AddListener(EventName.PartnerInfoChange, self:ToFunc("PartnerInfoChange"))
end

function PartnerMainWindow:__BindListener()
    self:SetHideNode("CommonMainWindow_Exit")
    --self:BindCloseBtn(self.CommonBack2_btn, self:ToFunc("HideCallback"), self:ToFunc("OnClick_Close"))
    self.CommonBack2_btn.onClick:AddListener(self:ToFunc("Close"))
end

function PartnerMainWindow:__delete()
    EventMgr.Instance:RemoveListener(EventName.PartnerInfoChange, self:ToFunc("PartnerInfoChange"))
end

function PartnerMainWindow:__Hide()
    self:CacheCurrencyBar()
    local window = WindowManager.Instance:GetWindow("RoleMainWindow")
    if not window then return end
    local panel = window:GetPanel(RolePartnerPanel)
    UtilsUI.SetActive(panel.RolePartner3D, true)
    panel:PlayEnterAnim(1)
    panel.RolePartnerSetting3D:PlayEnterAnimator(1)
end

function PartnerMainWindow:__Show()
    self.uniqueId = self.args.uniqueId
    self.hideView = self.args.hideView
    self.noLoadScene = self.args.noLoadScene
    self.defaultParm = self.args.defaultParm
    self.curTag =  self.args.initTag or RoleConfig.PartnerPanelType.Info
    self:CreateModelView(self.uniqueId)
    self:initCurrencyBar()
end

function PartnerMainWindow:CreateModelView(uniqueId)
    local count = 1

    local createCallBack = function ()
        count = count - 1
        if count == 0 then
            self:CreatePanel()
        end
    end

    self:GetModelView():RecordCamera()
    if self.hideView then
        count = count + 1
        local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
        self:GetModelView():LoadModel(partnerIndex, partnerData.template_id, createCallBack)
    end
    if not self.noLoadScene then
        self:GetModelView():LoadScene(previewScene, createCallBack)
    else
        createCallBack()
    end
end

function PartnerMainWindow:CreatePanel()
    if not self.noLoadScene then
        Fight.Instance.modelViewMgr:ShowView(ModelViewConfig.ViewType.Role)
    end
    local uniqueId = self.uniqueId
    local callback = function ()
        self:InitTag(uniqueId)
    end
    self:OpenPanel(CommonLeftTabPanel, {name = TI18N("月灵"), name2 = "p e i c o n g", tabList = RoleConfig.PartnerPanelToggleInfo, callback = callback, notDelay = true})
end

function PartnerMainWindow:InitTag(uniqueId)
    self:GetPanel(CommonLeftTabPanel):SelectType(self.curTag or RoleConfig.PartnerPanelType.Info)
    local partnerData = self:GetPartnerData()
    if not partnerData.panel_list or #partnerData.panel_list < 1 then
        self:GetPanel(CommonLeftTabPanel):ShowOption(RoleConfig.PartnerPanelType.EXSkill, false)
    else
        self:GetPanel(CommonLeftTabPanel):ShowOption(RoleConfig.PartnerPanelType.EXSkill, true)
    end
end


function PartnerMainWindow:PartnerInfoChange(oldData, newData)
    if oldData.unique_id ~= self:GetPartnerData().unique_id then
       return 
    end

    if not newData.panel_list or #newData.panel_list < 1 then
        self:GetPanel(CommonLeftTabPanel):ShowOption(RoleConfig.PartnerPanelType.EXSkill, false)
    else
        self:GetPanel(CommonLeftTabPanel):ShowOption(RoleConfig.PartnerPanelType.EXSkill, true)
    end

    if oldData.lev ~= newData.lev then
        local planId = RoleConfig.GetPartnerLevPlan(newData.template_id).plan
        local attrTable = RoleConfig.GetPartnerPlanByIdAndLev(planId, oldData.lev).lev_attr
        local oldAttrTable, newAttrTable = {}, {}
        for i = 1, #attrTable, 1 do
            local attr = attrTable[i]
            oldAttrTable[attr[1]] = RoleConfig.GetPartnerAttr(oldData.template_id, oldData.lev, attr[1], attr[2])
            newAttrTable[attr[1]] = RoleConfig.GetPartnerAttr(newData.template_id, newData.lev, attr[1], attr[2])
        end

        local partnerSkillsInfo = RoleConfig.GetPartnerAllSkillsFromOldToNewLev(newData.template_id, oldData.lev, newData.lev)
        local config = {
            oldLev = oldData.lev,
            newLev = newData.lev,
            oldAttrTable = oldAttrTable,
            newAttrTable = newAttrTable,
            partnerSkillsInfo = partnerSkillsInfo
        }
        self:AddTipCommand(BaseLevChangeTipPanel, config)
    end


    for key, value in pairs(self.panelList) do
        if value.active and value.PartnerInfoChange then
            value:PartnerInfoChange()
        end
    end
end

function PartnerMainWindow:AddTipCommand(panel, config)
    EventMgr.Instance:Fire(EventName.AddSystemContent, panel, {args = config})
end



function PartnerMainWindow:GetModelView()
    return Fight.Instance.modelViewMgr:GetView()
end

-- 初始化货币栏
function PartnerMainWindow:initCurrencyBar()
    self.CurrencyBar1 = Fight.Instance.objectPool:Get(CurrencyBar)
    self.CurrencyBar1:init(self.GoldCurrencyBar, 2)
end

-- 移除货币栏
function PartnerMainWindow:CacheCurrencyBar()
    self.CurrencyBar1:OnCache()
end


function PartnerMainWindow:GetPartnerData()
    return mod.BagCtrl:GetPartnerData(self.uniqueId)
end

function PartnerMainWindow:GetAndClearDefaultParm()
    local parm = self.defaultParm
    self.defaultParm = nil
    return parm
end

function PartnerMainWindow:__BeforeExitAnim()
    self:GetModelView():RecoverCamera()
    self:GetModelView():RecoverBlur()
    if self.hideView then
        Fight.Instance.modelViewMgr:HideView(ModelViewConfig.ViewType.Role)
    end
    for key, value in pairs(self.panelList) do
        if value.active and value.HideAnim then
            value:HideAnim()
        end
    end
end

function PartnerMainWindow:__AfterExitAnim()
    WindowManager.Instance:CloseWindow(self)
end

function PartnerMainWindow:Close()
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

function PartnerMainWindow.OpenWindow(partnerUniqueId, initTag)
    local onLoad = function ()
        WindowManager.Instance:OpenWindow(PartnerMainWindow, { uniqueId = partnerUniqueId, initTag = initTag, hideView = true })
    end
    Fight.Instance.modelViewMgr:GetView():LoadScene(previewScene, onLoad)
    --WindowManager.Instance:OpenWindow(PartnerMainWindow, { uniqueId = partnerUniqueId, initTag = initTag, hideView = true })
end