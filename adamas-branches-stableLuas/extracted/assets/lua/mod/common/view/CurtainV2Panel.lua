CurtainV2Panel = BaseClass("CurtainV2Panel", BaseView)

function CurtainV2Panel:__init()
	self:SetAsset("Prefabs/UI/Common/CurtainV2.prefab")
	self:SetParent(UIDefine.canvasRoot.transform)
end

function CurtainV2Panel:__CacheObject()
	self.canvas = self:Find(nil, Canvas)
	self.canvas.sortingOrder = 99
end

function CurtainV2Panel:__Show()
    self:SetAlpha()
end

function CurtainV2Panel:HideDisplay()
    self.isHide = true
    self.gameObject:SetActive(false)
end

function CurtainV2Panel:SetAlpha(value)
    if self.isHide then
        self.gameObject:SetActive(true)
        self.isHide = false
    end

    self.tagetAlpha = value or self.tagetAlpha
    if self.active then
        self.Light_canvas.alpha = self.tagetAlpha
    end
end

function CurtainV2Panel:__Hide()
	
end

function CurtainV2Panel:__delete()

end