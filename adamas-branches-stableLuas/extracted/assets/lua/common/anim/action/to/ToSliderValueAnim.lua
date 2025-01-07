-- 控制slider的value
-- Author: lizc
-- Date: 2021-08-17 19:38:59
--
ToSliderValueAnim = BaseClass("ToSliderValueAnim", AnimBaseTween)

function ToSliderValueAnim:__init(object, toValue, time)
    self.object = object
    self.toValue = toValue
    self.time = time
end

function ToSliderValueAnim:OnTween()
    local tween = self.object:DOValue(self.toValue,self.time)
    return tween
end

function ToSliderValueAnim.Create(root,animData,nodes,animNodes)
    local component = AnimUtils.GetComponent(root,animData.path,animData.component)
    local anim = ToSliderValueAnim.New(component,animData.toValue,animData.time)
    return anim
end