ScaleAnim = BaseClass("ScaleAnim",AnimBaseTween)

function ScaleAnim:__init(transform,toValue,time)
    self.transform = transform
    self.toValue = toValue
    self.time = time
end

function ScaleAnim:OnTween()
    local tween = self.transform:DOScale(self.toValue,self.time)
    return tween
end

function ScaleAnim.Create(root,animData,nodes,animNodes)
    local transform = AnimUtils.GetComponent(root,animData.path)
    local anim = ScaleAnim.New(transform,animData.toValue,animData.time)
    return anim
end