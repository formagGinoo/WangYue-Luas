PartnerMainWindow = BaseClass("PartnerMainWindow", BaseWindow)

local previewScene = "Prefabs/Scene/SceneRoleShow/SceneRoleShow.prefab"
local partnerIndex = "PartnerRoot"

function PartnerMainWindow:__init()
    self:SetAsset("Prefabs/UI/Role/CommonMainWindow.prefab")
end

function PartnerMainWindow:__BindEvent()
    EventMgr.Instance:AddListener(EventName.PartnerInfoChange, self:ToFunc("PartnerInfoChange"))
end

function PartnerMainWindow:__BindListener()
    self:SetHideNode("CommonMainWindow_Exit")
    self:BindCloseBtn(self.CommonBack2_btn, self:ToFunc("HideCallback"), self:ToFunc("OnClick_Close"))
end

function PartnerMainWindow:__delete()
    EventMgr.Instance:RemoveListener(EventName.PartnerInfoChange, self:ToFunc("PartnerInfoChange"))
end

function PartnerMainWindow:__Hide()
    self:CacheCurrencyBar()
end

function PartnerMainWindow:__Show()
    self.uniqueId = self.args.uniqueId
    self.hideView = self.args.hideView
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
    self:GetModelView():LoadScene(previewScene, createCallBack)
end

function PartnerMainWindow:CreatePanel()
    local uniqueId = self.uniqueId
    local callback = function ()
        self:InitTag(uniqueId)
    end
    self:OpenPanel(CommonLeftTabPanel, {name = "佩从", name2 = "zhongmo", tabList = RoleConfig.PartnerPanelToggleInfo, callback = callback, notDelay = true})
end

function PartnerMainWindow:InitTag(uniqueId)
    self:GetPanel(CommonLeftTabPanel):SelectType(self.curTag or RoleConfig.PartnerPanelType.Info)
end


function PartnerMainWindow:PartnerInfoChange(oldData, newData)
    if oldData.unique_id ~= self:GetPartnerData().unique_id then
       return 
    end

    if oldData.lev ~= newData.lev then
        local attrTable = newData.property_list
        local oldAttrTable, newAttrTable = {}, {}
        for i = 1, #attrTable, 1 do
            local attr = attrTable[i]
            oldAttrTable[attr.key] = RoleConfig.GetPartnerAttr(oldData.template_id, oldData.lev, attr.key, attr.value)
            newAttrTable[attr.key] = RoleConfig.GetPartnerAttr(newData.template_id, newData.lev, attr.key, attr.value)
        end
        local config = {
            oldLev = oldData.lev,
            newLev = newData.lev,
            oldAttrTable = oldAttrTable,
            newAttrTable = newAttrTable,
        }
        self:AddTipCommand(BaseLevChangeTipPanel, config)
    end

    local oldLength = #oldData.skill_list
    local newLength = #newData.skill_list
    if newLength ~= oldLength then
        local index = newLength - oldLength
        for i = index, 1, -1 do
            local config = {
                skillId = newData.skill_list[index].key,
                id = newData.template_id,
                level = newData.skill_list[index].value
            }
            self:AddTipCommand(PartnerSkillUnlockPanel, config)
        end
    end

    for index, skill in pairs(newData.skill_list) do
        if oldData.skill_list[index] then
            if skill.value ~= oldData.skill_list[index].value then
                local config = {
                    skillId = newData.skill_list[index].key,
                    id = newData.template_id,
                    oldLev = oldData.skill_list[index].value,
                    level = newData.skill_list[index].value,
                    desc1 = TI18N("技能提升"),
                    desc2 = "tisheng"
                }
                self:AddTipCommand(PartnerSkillUnlockPanel, config)
            end
        end

    end

    for key, value in pairs(self.panelList) do
        if value.active and value.PartnerInfoChange then
            value:PartnerInfoChange()
        end
    end
    self:DoTipCommand()
end

function PartnerMainWindow:AddTipCommand(panel, config)
    if not self.commandList then
        self.commandList = {}
    end
    table.insert(self.commandList, {panel = panel, config = config})
end

function PartnerMainWindow:DoTipCommand()
    if self.commandList and #self.commandList > 0 then
        local tip = table.remove(self.commandList, 1)
        tip.config.callBack = self:ToFunc("DoTipCommand")
        PanelManager.Instance:OpenPanel(tip.panel, tip.config)
    end
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

function PartnerMainWindow:OnClick_Close()
    self:GetModelView():RecoverCamera()
    local partnerData = mod.BagCtrl:GetPartnerData(self.uniqueId)
    local cameraConfig = RoleConfig.GetPartnerCameraConfig(partnerData.template_id, RoleConfig.PartnerCameraType.Select)
    CustomUnityUtils.SetDepthOfFieldBoken(true, cameraConfig.camera_position.z - 2.7, 300, cameraConfig.aperture or 10)
    if self.hideView then
        Fight.Instance.modelViewMgr:HideView(ModelViewConfig.ViewType.Role)
    end
    for key, value in pairs(self.panelList) do
        if value.active and value.HideAnim then
            value:HideAnim()
        end
    end
end

function PartnerMainWindow:HideCallback()
    WindowManager.Instance:CloseWindow(self)
end