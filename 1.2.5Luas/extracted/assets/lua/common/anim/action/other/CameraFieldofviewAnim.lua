CameraFieldofviewAnim = BaseClass("CameraFieldofviewAnim", AnimBaseTween)

function CameraFieldofviewAnim:__init(camera,toValue,time)
    self.camera = camera
    self.toValue = toValue
    self.time = time
end

function CameraFieldofviewAnim:OnTween()
    local tween = self.camera:DOFieldOfView(self.toValue,self.time)
    return tween
end

function CameraFieldofviewAnim.Create(root,animData,nodes,animNodes)
    local camera = AnimUtils.GetComponent(root,animData.path)
    local anim = CameraFieldofviewAnim.New(camera,animData.toValue,animData.time)
    return anim
end