IdentityWindow = BaseClass("IdentityWindow", BaseWindow)

local ShowConfig = Config.DataIdentityCommon.Find

function IdentityWindow:__init()
	self:SetAsset("Prefabs/UI/Identity/IdentityWindow.prefab")
end

function IdentityWindow:__BindListener()
    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("OnBack"))
    self.ChangeBtn_btn.onClick:AddListener(self:ToFunc("OnClickChangeBtn"))

    EventMgr.Instance:AddListener(EventName.IdentityChange,self:ToFunc("UpdataIdentityInfo"))

    self:BindRedPoint(RedPointName.Identity,self.RewardRedPoint)
end

function IdentityWindow:__CacheObject()

end

function IdentityWindow:__Create()

end

function IdentityWindow:__delete()
    self.CommonBack1_btn.onClick:RemoveAllListeners()
    self.ChangeBtn_btn.onClick:RemoveAllListeners()
    EventMgr.Instance:RemoveListener(EventName.IdentityChange,self:ToFunc("UpdataIdentityInfo"))
end

function IdentityWindow:__Show()
    self.AttrInfo = mod.IdentityCtrl:GetIdentityAttrInfo()
    self.AttrInfo[10] = self.AttrInfo[10] or 0
    self.AttrInfo[11] = self.AttrInfo[11] or 0
    self.AttrInfo[12] = self.AttrInfo[12] or 0
end

function IdentityWindow:__ShowComplete()
    self.showIdentityInfo = mod.IdentityCtrl:GetNowIdentity()
    self.AttrMaxValue = ShowConfig.UiAttrInitialMax.int
    self:InitInfoPart()
end

function IdentityWindow:__Hide()
    
end

function IdentityWindow:InitInfoPart()
    self:UpdataIdentityInfo()

    self.Attr1Val_txt.text = self.AttrInfo[10]
    if self.AttrInfo[10] > self.AttrMaxValue then self.AttrMaxValue = self.AttrInfo[10] end
    self.Attr1Name_txt.text = TI18N(IdentityConfig.GetIdentityAttrConfig(10).name)

    self.Attr2Val_txt.text = self.AttrInfo[11]
    if self.AttrInfo[11] > self.AttrMaxValue then self.AttrMaxValue = self.AttrInfo[11] end
    self.Attr2Name_txt.text = TI18N(IdentityConfig.GetIdentityAttrConfig(11).name)

    self.Attr3Val_txt.text = self.AttrInfo[12]
    if self.AttrInfo[12] > self.AttrMaxValue then self.AttrMaxValue = self.AttrInfo[12] end
    self.Attr3Name_txt.text = TI18N(IdentityConfig.GetIdentityAttrConfig(12).name)

    local scale = 0.7 * (self.AttrInfo[10]/self.AttrMaxValue) + 0.3
    UnityUtils.SetLocalScale(self.Attr1ValImg.transform, scale, scale, scale)
    scale = 0.7 * (self.AttrInfo[11]/self.AttrMaxValue) + 0.3
    UnityUtils.SetLocalScale(self.Attr2ValImg.transform, scale, scale, scale)
    scale = 0.7 * (self.AttrInfo[12]/self.AttrMaxValue) + 0.3
    UnityUtils.SetLocalScale(self.Attr3ValImg.transform, scale, scale, scale)
end

function IdentityWindow:UpdataIdentityInfo()
    if self.showIdentityInfo and self.showIdentityInfo.id > 0 then
        self.CurIdentity_txt.text = IdentityConfig.GetIdentityTitleConfig(self.showIdentityInfo.id,self.showIdentityInfo.lv).name
    else
        self.CurIdentity_txt.text = TI18N("暂无佩戴")
    end 
end

function IdentityWindow:OnBack()
    Fight.Instance.modelViewMgr:HideView(ModelViewConfig.ViewType.Identity)
    WindowManager.Instance:CloseWindow(self)
end

function IdentityWindow:OnClickChangeBtn()
    PanelManager.Instance:OpenPanel(IdentityShowPanel)
end

function IdentityWindow:SetStaticText()
    self.Title_txt.text = TI18N("道途")
    self.Title_txt.text = "daotu"
    self.CurTitle_txt.text = TI18N("当前身份")
end

--打开Ui前,先加载场景
function IdentityWindow.OpenWindow()
    Fight.Instance.modelViewMgr:LoadView(ModelViewConfig.ViewType.Identity, function ()
        Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.Identity):LoadScene(ModelViewConfig.Scene.Identity, function ()
            local view = Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.Identity)
            local playerUiModel = ShowConfig.UiModelId.name
            Fight.Instance.modelViewMgr:ShowView(ModelViewConfig.ViewType.Identity)

            view:LoadModel("RoleRoot", 1001001, function ()
                view:ShowModelRoot("RoleRoot", true)
                Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.Identity):PlayModelAnim("RoleRoot", "Stand2", 0.5)
            end, playerUiModel)

            WindowManager.Instance:OpenWindow(IdentityWindow)

            local config = IdentityConfig.CamareConfig
            Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.Identity):BlendToNewCamera(config.camera_position, config.camera_rotation, 24.5)
            
        end)
    end)  
end

