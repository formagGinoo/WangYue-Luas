RectSizedeltaAnim = BaseClass("RectSizedeltaAnim", AnimBaseTween)

function RectSizedeltaAnim:__init(rectTransform,toValue,time)
    self.rectTransform = rectTransform
    self.toValue = toValue
    self.time = time
end

function RectSizedeltaAnim:OnTween()
    local tween = self.rectTransform:DOSizeDelta(self.toValue,self.time)
    return tween
end

function RectSizedeltaAnim.Create(root,animData,nodes,animNodes)
    local rectTransform = AnimUtils.GetComponent(root,animData.path)
    local anim = RectSizedeltaAnim.New(rectTransform,animData.toValue,animData.time)
    return anim
end