-- 拖动翻页
-- 负责移动container的逻辑和触发翻页完成事件
-- 业务模块根据翻页事件来动态填充数据，一般是预先填充后一页的数据
-- 如果页数比较少，可以一次性创建完
-- @anthor huangyq

TabbedPanel = BaseClass("TabbedPanel")

function TabbedPanel:__init(panel, pageCount, perWidth, tweenTime)
    self.panel = panel
    self.container = panel.transform:Find("List").gameObject
    -- local scrollbar = panel.transform:Find("Scrollbar")
    self.scrollbar = panel.transform:GetComponent(ScrollRect)
    self.scrollbar.inertia = false
    self.scrollbar.elasticity = 0
    -- if scrollbar ~= nil then
    --     self.scrollbar = scrollbar:GetComponent(Scrollbar)
    -- end
    self.rectTransform = self.container:GetComponent(RectTransform)
    if tweenTime == nil then
        self.tweenTime = 0.6
    else
        self.tweenTime = tweenTime
    end

    self.width = self.rectTransform.rect.width
    self.height = self.rectTransform.rect.height

    self.pageCount = pageCount
    self.perWidth = perWidth
    self.currentPage = 1

    if not UtilsBase.IsNull(self.scrollbar) then
        self.scrollbar.onValueChanged:AddListener(function(value) self:OnValueChanged(value.x) end)
    end
    self.scrollbarValue = 0
    self.direction = LuaDirection.Left

    self.pageController  = self.panel:AddComponent(PageTabbedController)
    self.pageController.onEndDragEvent:AddListener(function() self:OnEndDragEvent() end)
    self.pageController.onDownEvent:AddListener(function() self:OnDownEvent() end)
    self.pageController.onUpEvent:AddListener(function() self:OnUpEvent() end)

    self.MoveEndEvent = EventLib.New()
    self.ltDescr = nil
end

function TabbedPanel:__delete()
    if self.ltDescr ~= nil then
        Tween.Instance:Cancel(self.ltDescr)
        self.ltDescr = nil
    end
    self.MoveEndEvent:DeleteMe()
    self.MoveEndEvent = nil
end

-- 如果总页数会变，就要重新修改这个值
function TabbedPanel:SetPageCount(pageCount)
    self.pageCount = pageCount
end

function TabbedPanel:OnValueChanged(value)
    local oldValue = self.scrollbarValue
    self.scrollbarValue = value
    if oldValue > value then
        self.direction = LuaDirection.Right
    elseif oldValue < value then
        self.direction = LuaDirection.Left
    end
end

function TabbedPanel:OnEndDragEvent()
    if self.scrollbarValue ~= 0 and self.scrollbarValue ~= 1 then
        if self.ltDescr ~= nil then
            Tween.Instance:Cancel(self.ltDescr)
            self.ltDescr = nil
        end
        self.ltDescr = Tween.Instance:MoveX(self.rectTransform, self:GetTargetValue(), self.tweenTime, function() self:OnMoveEnd() end, LeanTweenType.easeOutQuint).id
    end
end

function TabbedPanel:OnDownEvent()
    if self.ltDescr ~= nil then
        Tween.Instance:Cancel(self.ltDescr)
        self.ltDescr = nil
    end
end

function TabbedPanel:OnUpEvent()
    if self.scrollbarValue ~= 0 and self.scrollbarValue ~= 1 then
        if self.ltDescr ~= nil then
            Tween.Instance:Cancel(self.ltDescr)
            self.ltDescr = nil
        end
        self.ltDescr = Tween.Instance:MoveX(self.rectTransform, self:GetTargetValue(), self.tweenTime, function() self:OnMoveEnd() end, LeanTweenType.easeOutQuint).id
    end
end

function TabbedPanel:GetTargetValue()
    if self.pageCount <= 1 then
        self.currentPage = 1
        return 0
    end
    local aver = 1 / (self.pageCount - 1)
    local averPixel = self.perWidth
    if self.direction == LuaDirection.Left then
        local index = math.ceil(self.scrollbarValue / aver)
        self.currentPage = index + 1
        return 0 - index * averPixel
    else
        local index = math.ceil(self.scrollbarValue / aver)
        self.currentPage = index
        return 0 - (index - 1) * averPixel
    end
end

function TabbedPanel:OnMoveEnd()
    self.ltDescr = nil
    self.MoveEndEvent:Fire(self.currentPage, self.direction)
end

-- 翻到指定页
function TabbedPanel:TurnPage(pageIndex)
    if self.ltDescr ~= nil then
        Tween.Instance:Cancel(self.ltDescr)
        self.ltDescr = nil
    end
    self.currentPage = pageIndex
    local offsetX = 0 - (pageIndex - 1) * self.perWidth
    self.ltDescr = Tween.Instance:MoveX(self.rectTransform, offsetX, self.tweenTime, function() self:OnMoveEnd() end, LeanTweenType.easeOutQuint).id
end
