MainCtrl = BaseClass("MainCtrl",Controller)

function MainCtrl:__init()
end

function MainCtrl:__delete()
end

function MainCtrl:__InitComplete()
    self:InitMainPanel()
end

function MainCtrl:InitMainPanel()
    -- todo有正式新手指引后，修改初始化地方
    mod.MainProxy.guideMaskView = GuideMaskView.New()
    mod.MainProxy.guideMaskView:SetParent(UIDefine.canvasRoot.transform)
end

