PartnerInfoPanel = BaseClass("PartnerInfoPanel", BasePanel)

function PartnerInfoPanel:__init()
    self:SetAsset("Prefabs/UI/Partner/PartnerInfoPanel.prefab")
end

function PartnerInfoPanel:__Create()
    self.commonInfo = Fight.Instance.objectPool:Get(CommonPartnerInfo)
    self.commonInfo:Init(self.PartnerTips)
end

function PartnerInfoPanel:__delete()
    self.commonInfo:OnCache()
end

function PartnerInfoPanel:__BindListener()

end

function PartnerInfoPanel:__Hide()

end

function PartnerInfoPanel:__Show()
    self:PartnerInfoChange()
    self:SetCameraSetings()
end

function PartnerInfoPanel:PartnerInfoChange()
    local uniqueId = self:GetPartnerData().unique_id
    self.commonInfo:UpdateShow(uniqueId)
end

function PartnerInfoPanel:SetCameraSetings()
    local partner = self:GetPartnerData().template_id
    local cameraConfig = RoleConfig.GetPartnerCameraConfig(partner, RoleConfig.PartnerCameraType.Info)
    Fight.Instance.modelViewMgr:GetView():BlendToNewCamera(cameraConfig.camera_position, cameraConfig.camera_rotation, 24.5)
    Fight.Instance.modelViewMgr:GetView():SetModelRotation("PartnerRoot", cameraConfig.model_rotation)
    Fight.Instance.modelViewMgr:GetView():PlayModelAnim("PartnerRoot", cameraConfig.anim, 0.5)
    CustomUnityUtils.SetDepthOfFieldBoken(true, cameraConfig.camera_position.z - 2.7, 300, cameraConfig.aperture or 10)
end

function PartnerInfoPanel:GetPartnerData()
    return self.parentWindow:GetPartnerData()
end

function PartnerInfoPanel:HideAnim()
    self.PartnerInfoPanel_Exit:SetActive(true)
end