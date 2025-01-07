--
-- Author: lizc
-- Date: 2021-08-19 11:09:38
-- 摄像机震屏
ShakeCameraAnim = BaseClass("ShakeCameraAnim", AnimBaseTween)

--参数：持续时间，力量，震动次数，随机性，淡出
--力量：实际就是震动的幅度,可以理解成相机施加的力的大小 使用Vector3可以选择每个轴向不同的强度
--震动：震动次数
--随机性：改变震动方向的随机值（大小：0~180）
--淡出：就是运动最后是否缓慢移动回到原本位置
function ShakeCameraAnim:__init(camera,time,strength,vibrato,randomness,fadeOut)
    self.camera = camera
    self.time = time
    self.strength = strength
    self.vibrato = vibrato or 10
    self.randomness = randomness or 90
    self.fadeOut = fadeOut or true
end

function ShakeCameraAnim:OnTween()
    local tween = self.camera:DOShakePosition(self.time,self.strength,self.vibrato,self.randomness,self.fadeOut)
    return tween
end

function ShakeCameraAnim.Create(root,animData,nodes,animNodes)
    local anim = ShakeCameraAnim.New(animData.time,animData.strength,animData.vibrato,animData.randomness,animData.fadeOut)
    return anim
end