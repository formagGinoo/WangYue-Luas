MakeSureRolePanel = BaseClass("MakeSureRolePanel", BaseWindow)

function MakeSureRolePanel:__init()
	self:SetAsset("Prefabs/UI/CreateRole/MakeSureRolePanel.prefab")
end

function MakeSureRolePanel:__BindListener()
    
end

function MakeSureRolePanel:__CacheObject()

end

function MakeSureRolePanel:__Create()
    
end

function MakeSureRolePanel:__delete()

end

function MakeSureRolePanel:__Show()

end

function MakeSureRolePanel:__ShowComplete()

end

function MakeSureRolePanel:__Hide()
    
end


function MakeSureRolePanel:SetCameraView(roleIndex, case, notTransition)
    local cameraConfig = RoleConfig.GetRoleCameraConfig(roleIndex, case)
    local root = "RoleRoot" .. roleIndex
    
    self:GetModelView():SetCameraSettings(cameraConfig.camera_position, cameraConfig.camera_rotation, 24.5)
    
    self:GetModelView():PlayModelAnim(root, cameraConfig.anim, 0.5)
    self:GetModelView():SetModelRotation(root,  cameraConfig.model_rotation)
end

function MakeSureRolePanel:OnBack()
    
end

function MakeSureRolePanel:OnClickConfirmBtn()

end

