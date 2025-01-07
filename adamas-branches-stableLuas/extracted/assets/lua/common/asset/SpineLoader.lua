-- 2D骨骼动画
SpineLoader = SpineLoader or BaseClass("SpineLoader")

local _ipairs = ipairs
local SkeletonAnimation = CS.Spine.Unity.SkeletonAnimation
local SkeletonGraphic = CS.Spine.Unity.SkeletonGraphic

--[[{
    parent,必选     挂载在哪一个父节点
    name,必选       加载的spine名
    callback,可选   加载完成回调
    queue,可选      加载完成播放队列
    timeScale,可选  时间缩放
    scale,可选      大小缩放
    position,可选   位置
    order,可选      层级
    flip,可选       反转
    rotation,可选   旋转
    isSceneElement,可选, 默认UI
}]]
function SpineLoader:__init(setting)
    if setting then
        self:Paser(setting)
    end
end

function SpineLoader:Paser(setting, forceUpdate)
    if self.name == setting.name and not forceUpdate then
        -- 不重复加载了
        return
    end

    self.parent = setting.parent.transform
    self.loadCallback = setting.callback
    self.name = tostring(setting.name)
    self.timeScale = setting.timeScale or 1
    self.showScale = setting.scale or 1
    self.position = setting.position
    self.order = setting.order or 0
    self.flip = setting.flip or false
    self.rotation = setting.rotation
    self.isSceneElement = setting.isSceneElement or false
    self.queue = setting.queue
end

function SpineLoader:__delete()
    -- 要在最后面
    self:DeleteAssetLoader()
end

function SpineLoader:DeleteAssetLoader()
    if self.assetLoader ~= nil then
        self.assetLoader:DeleteMe()
        self.assetLoader = nil
    end
    if self.gameObject then
        GameObject.Destroy(self.gameObject)
        self.gameObject = nil
    end
end

function SpineLoader:Load()
    self.modelPath = string.format(AssetConfig.spine_prefix_path, self.name)

    self:DeleteAssetLoader()
    
    self.assetLoader = AssetBatchLoader.New("SpineLoader")
    
    self.assetLoader:AddListener(self:ToFunc("LoadCallback"))
    local resList = {
        {path = self.modelPath, type = AssetType.Prefab}
    }
    self.assetLoader:LoadAll(resList)
end

function SpineLoader:Reload(setting, forceUpdate)
    if self.name == tostring(setting.name) then
        if self.loadCallback then
            self.loadCallback()
        end
        if not forceUpdate then
            return
        end
    end
    self:Paser(setting, forceUpdate)
    self:Load()
end

function SpineLoader:LoadCallback()
    self.gameObject = self.assetLoader:Pop(self.modelPath)
    UnityUtils.SetActive(self.gameObject, true)
    self.transform = self.gameObject.transform
    self.transform:SetParent(self.parent)

    if self.flip then
        UnityUtils.SetLocalScale(self.transform, -1 * self.showScale, 1 * self.showScale, 1 * self.showScale)
    else
        UnityUtils.SetLocalScale(self.transform, 1 * self.showScale, 1 * self.showScale, 1 * self.showScale)
    end
    self.transform.localRotation = Quaternion.identity
    if self.rotation then
        self.transform.localRotation = Quaternion.Euler(self.rotation)
    end

    if self.isSceneElement then
        if self.position then
            UnityUtils.SetLocalPosition(self.transform, self.position.x, self.position.y, self.position.z)
        else
            UnityUtils.SetLocalPosition(self.transform, 0, 0, 0)
        end
        self.script = self.gameOject:GetComponentInChildren(SkeletonAnimation)
        if self.order then
            local render = self.gameObject:GetComponent(MeshRenderer)
            if render then
                render.sortingOrder = self.order
            end
        end
    else
        if self.position then
            UnityUtils.SetAnchoredPosition(self.transform, self.position.x, self.position.y)
        else
            UnityUtils.SetAnchoredPosition(self.transform, 0, 0)
        end
        self.script = self.gameObject:GetComponentInChildren(SkeletonGraphic)
        if self.order then
            local cvs = self.transform:GetComponent(Canvas)
            if cvs then
                cvs.sortingOrder = self.order
            end
        end
    end

    if self.timeScale then
        self.script.timeScale = self.timeScale
    end 

    if self.script then
        self.script:SetAnimationCompleteCallback(self:ToFunc("OnPlayCompleteCall"))
    end

    self:FindAllAnimationInfo()

    if self.queue then
        self:PlayAnimationQueue(self.queue)
    end

    if self.loadCallback ~= nil then
        self.loadCallback(self.gameObject)
    end
    UnityUtils.SetActive(self.gameObject, true)
end

-- 获取所有animation信息
function SpineLoader:FindAllAnimationInfo()
    self.animationList = {}
    local skeletonData = self.script.Skeleton.Data
    local animations = skeletonData.Animations
    local animationCount = animations.Count
    animations:ForEach(function (animation)
        self.animationList[animation.Name] = {
            length = animation.Duration
        }
    end)

end

-- 播放动作完成回调
function SpineLoader:OnPlayCompleteCall(trackEntry)
    if self.playCallback then
        self.playCallback()
        self.playCallback = nil
    end
end

-- API
function SpineLoader:Show()
    if self.gameObject then
        UnityUtils.SetActive(self.gameObject, true)
    end
end

function SpineLoader:Hide()
    if self.gameObject then
        UnityUtils.SetActive(self.gameObject, false)
    end
end

function SpineLoader:SetParent(parent)
    self.parent = parent
    if self.transform then
        self.transform:SetParent(parent)
        self:SetLocalScale(self.showScale)
    end
end

function SpineLoader:SetLocalPosition(x, y, z)
    if self.transform then
        if self.isSceneElement then
            UnityUtils.SetLocalPosition(self.transform, x, y, z or 0)
        else
            UnityUtils.SetAnchoredPosition(self.transform, x, y)
        end
    end
end

function SpineLoader:SetLocalScale(x)
    self.showScale = x
    if self.transform then
        UnityUtils.SetLocalScale(self.transform, x, x, x)
    end
end

function SpineLoader:HasAnimation(animationName)
    return self.animationList[animationName]
end

function SpineLoader:SetAnimationCompleteCallback(callback)
    self.playCallback = callback
end

function SpineLoader:RemoveAnimationCompleteCallback()
    self.playCallback = nil
end

-- 播放单个动画
function SpineLoader:PlayAnimation(animName, isLoop, trackIndex)
    if not self.script then
        LogError("该Spine没有执行脚本")
        return
    end
    if self:HasAnimation(animName) then
        self.script:PlayAnimation(animName, isLoop or false, trackIndex or 0)
    else
        LogError("Spine 不存在动画 " .. animName)
    end
end

-- 列表顺序播放
-- queue = {
--   {animName, isLoop, trackIndex}
-- }
function SpineLoader:PlayAnimationQueue(queue)
    if not queue then
        return
    end
    if not self.script then
        LogError("该Spine没有执行脚本")
        return
    end
    for i, v in _ipairs(queue) do
        self.script:AddAnimation(v.animName, v.isLoop or false, v.trackIndex or 0)
    end
end

function SpineLoader:StopAnimation()
    if not self.script then
        LogError("该Spine没有执行脚本")
        return
    end
    self.script:ClearAllAnimation()
end

-- 冻结不动
function SpineLoader:Freeze()
    self.script.timeScale = 0
end

function SpineLoader:UnFreeze()
    self.script.timeScale = 1
end

-- API End
