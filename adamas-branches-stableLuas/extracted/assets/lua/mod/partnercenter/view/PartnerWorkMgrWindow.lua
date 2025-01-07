PartnerWorkMgrWindow = BaseClass("PartnerWorkMgrWindow", BaseWindow)
local _tinsert = table.insert

local modelRoot = "PartnerRoot"

local emptyCameraRotation = Vec3.New(0,180,0)

local addPartnerToWorkText = TI18N("上阵员工")
local removePartnerToWorkText = TI18N("下阵员工")
local switchPartnerToWorkText = TI18N("替换员工")


function PartnerWorkMgrWindow.OpenWindow(partnerUniqueId, indexMap)
    --加载场景
    Fight.Instance.modelViewMgr:LoadView(ModelViewConfig.ViewType.PartnerBag, function ()
        local partnerBagView = Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.PartnerBag)
        partnerBagView:LoadScene(ModelViewConfig.Scene.PartnerBag, function()
            Fight.Instance.modelViewMgr:ShowView(ModelViewConfig.ViewType.PartnerBag)
            partnerBagView:BlendToNewCamera(Vec3.zero, emptyCameraRotation)
            --打开界面UI
            WindowManager.Instance:OpenWindow(PartnerWorkMgrWindow, {uniqueId = partnerUniqueId, markIndexMap = indexMap})
            BehaviorFunctions.fight.clientFight.cameraManager:GetCurCamera().camera:SetActive(false)
        end)
    end)
end


function PartnerWorkMgrWindow:__init()
	self:SetAsset("Prefabs/UI/PartnerMgrCenter/PartnerWorkMgrWindow.prefab")
end

function PartnerWorkMgrWindow:__BindListener()
    self:BindCloseBtn(self.CommonBack1_btn)
    self.CtrlPartnerBtn_btn.onClick:AddListener(self:ToFunc("OnClickPartnerBtn"))
end

function PartnerWorkMgrWindow:__CacheObject()

end

function PartnerWorkMgrWindow:__Create()

end

function PartnerWorkMgrWindow:__delete()

end

function PartnerWorkMgrWindow:__ShowComplete()

end
function PartnerWorkMgrWindow:__Hide()

end

function PartnerWorkMgrWindow:__Show()
    if self.args then
        self.uniqueId = self.args.uniqueId
        self.markIndexMap = self.args.markIndexMap
    end
    self:OpenPanel(PartnerSelectPanel,{
        selectPartnerFunc = self:ToFunc("SelectPartner"),
        showPartnerFunc = self:ToFunc("ShowPartnerModel"),
        defaultSelectUniqueId = self.uniqueId,
        markIndexMap = self.markIndexMap,
        selectYellow = true,
    })
end

function PartnerWorkMgrWindow:__AfterExitAnim()
    self:CloseWin()
end

function PartnerWorkMgrWindow:CloseWin()
    BehaviorFunctions.fight.clientFight.cameraManager:GetCurCamera().camera:SetActive(true)
    Fight.Instance.modelViewMgr:HideView(ModelViewConfig.ViewType.PartnerBag)
    WindowManager.Instance:CloseWindow(self)
end

function PartnerWorkMgrWindow:SelectPartner(unique_id)
    self.curUniqueId = unique_id
    self.selectPartnerData = mod.BagCtrl:GetPartnerData(unique_id)
    self:UpdateModel(self.selectPartnerData)
    self:ResetPartnerCtrlPanel()
    local workInfoPanel = self:GetPanel(PartnerBagWorkPanel)
    if workInfoPanel then
        workInfoPanel:UpdateData(self.curUniqueId)
    else
        self:OpenPanel(PartnerBagWorkPanel, {uniqueId = self.curUniqueId, showBtn = false})
    end
end

function PartnerWorkMgrWindow:SetCameraSetings(partnerData)
    local partner = partnerData and partnerData.template_id or 0
    local cameraConfig = RoleConfig.GetPartnerCameraConfig(partner, RoleConfig.PartnerCameraType.PartnerBag)
    local partnerBagView = Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.PartnerBag)

    partnerBagView:BlendToNewCamera(cameraConfig.camera_position, cameraConfig.camera_rotation, 24.5)
    partnerBagView:SetModelRotation(modelRoot, cameraConfig.model_rotation)
    partnerBagView:PlayModelAnim(modelRoot, cameraConfig.anim, 0.5)
end

function PartnerWorkMgrWindow:UpdateModel(partnerData)
    if not partnerData then      
        return
    end
    
    if partnerData and self.curShowPartnerTemplateId == partnerData.template_id then
        return
    end
    local onLoad = function()
        self.curShowPartnerTemplateId = partnerData.template_id
        self:SetCameraSetings(partnerData)
    end
    --加载模型
    self:GetModelView():LoadModel(modelRoot, partnerData.template_id, onLoad)
end

function PartnerWorkMgrWindow:ShowPartnerModel(isShow)
    self:GetModelView():ShowModel(modelRoot, isShow)
end

function PartnerWorkMgrWindow:GetModelView()
    return Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.PartnerBag)
end

function PartnerWorkMgrWindow:OnClickPartnerBtn()
    self:UpdataPartnerData()
    if self.partnerWorkConfig then
        self.SendPartnerList = {}
        --下阵月灵
        if self.nowPartners[self.curUniqueId] and self.uniqueId then
            for id, state in pairs(self.nowPartners) do
                if id ~= self.curUniqueId then
                    _tinsert(self.SendPartnerList, id)
                end
            end
            mod.PartnerCenterCtrl:SetAssetPartnerChangeList({self.curUniqueId})
        -- 替换月灵
        elseif not self.nowPartners[self.curUniqueId] and self.uniqueId then
            for id, state in pairs(self.nowPartners) do
                if id ~= self.uniqueId then
                    _tinsert(self.SendPartnerList, id)
                end
            end
            _tinsert(self.SendPartnerList, self.curUniqueId)
            mod.PartnerCenterCtrl:SetAssetPartnerChangeList({self.curUniqueId, self.uniqueId})
        --上阵月灵
        elseif not self.nowPartners[self.curUniqueId] and not self.uniqueId then
            self.CtrlPartnerText_txt.text = addPartnerToWorkText
            for id, state in pairs(self.nowPartners) do
                _tinsert(self.SendPartnerList, id)
            end
            _tinsert(self.SendPartnerList, self.curUniqueId)
            mod.PartnerCenterCtrl:SetAssetPartnerChangeList({self.curUniqueId})
        end

        if self.selectPartnerData.work_info.asset_id == 0 or self.curAssetId == self.selectPartnerData.work_info.asset_id then
            self:SetPartnerWorkInAsset()
        else
            MsgBoxManager.Instance:ShowTextMsgBox(
                string.format(TI18N("此月灵已经在资产【%s】中进行工作，是否替换？\n注意月灵变更工作会影响相关资源产出"),
                PartnerCenterConfig.GetAssetConfigById(self.curAssetId).name), self:ToFunc("SetPartnerWorkInAsset"),function() end)
        end
    end
end

function PartnerWorkMgrWindow:SetPartnerWorkInAsset()
    if self.curPartnerData and self.curPartnerData.hero_id ~= 0 then
        MsgBoxManager.Instance:ShowTips(string.format(TI18N("%s正在装备中"), Config.DataHeroMain.Find[self.curPartnerData.hero_id].name))
        return
    end
    mod.PartnerCenterCtrl:SetPartnerWorkInAsset(self.curAssetId, self.SendPartnerList)
    self:CloseWin()
end

function PartnerWorkMgrWindow:ResetPartnerCtrlPanel()
    self:UpdataPartnerData()
    UtilsUI.SetActive(self.CtrlPartner, self.partnerWorkConfig ~= nil)
    if self.nowPartners[self.curUniqueId] and self.uniqueId then
        self.CtrlPartnerText_txt.text = removePartnerToWorkText
    elseif not self.nowPartners[self.curUniqueId] and self.uniqueId then
        self.CtrlPartnerText_txt.text = switchPartnerToWorkText
    elseif not self.nowPartners[self.curUniqueId] and not self.uniqueId then
        self.CtrlPartnerText_txt.text = addPartnerToWorkText
    else
        UtilsUI.SetActive(self.CtrlPartner, false)
    end
end

function PartnerWorkMgrWindow:UpdataPartnerData()
    self.curAssetId = mod.AssetPurchaseCtrl:GetCurAssetId()
    self.curPartnerData = mod.BagCtrl:GetPartnerData(self.curUniqueId)
    self.partnerWorkConfig = PartnerBagConfig.GetPartnerWorkConfig(self.curPartnerData.template_id)
    local partners = mod.AssetPurchaseCtrl:GetAssetPartnerList(self.curAssetId)
    self.nowPartners = {}
    for k, id in pairs(partners) do
        self.nowPartners[id] = true
    end
end