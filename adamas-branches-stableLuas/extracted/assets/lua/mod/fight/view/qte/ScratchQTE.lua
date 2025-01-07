ScratchQTE = BaseClass("ScratchQTE", QTEBase)
---@class ScratchQTEParams
---@field instanceId
---@field prefab
---@field icon
---@field duration
---@field initX
---@field initY
---@field targetX
---@field targetY
---@field scratchType

local Vec3 = Vec3
local scratchType = {
    Line = 1,
    Panel = 2
}

local DragJudgeRadius = 20
local StopJudgeRadius = 30

function ScratchQTE:__init()
    self:SetAsset("Prefabs/UI/QTE/ScratchQTE.prefab")
    self.firstInit = true
    self.type = FightEnum.NewQTEType.Scratch
end

function ScratchQTE:__onCache()
    LuaTimerManager.Instance:RemoveTimer(self.hideTimer)
    self.hideTimer = nil
end

function ScratchQTE:__BindListener()
    ---@type CS.UIDragBehaviour
    local dragBehaviour = self.Button.transform:GetComponent(UIDragBehaviour)
    if not dragBehaviour then
        dragBehaviour = self.Button:AddComponent(UIDragBehaviour)
    end
    dragBehaviour.onPointerDown = function(data)
        self:OnPointerDown(data)
    end
    dragBehaviour.onDrag = function(data)
        self:OnDrag(data)
    end
    dragBehaviour.onPointerUp = function(data)
        self:OnPointerUp(data)
    end
end

function ScratchQTE:__Hide()

end

function ScratchQTE:__Show()
    if self.firstInit then
        self:SetParent(UIDefine.canvasRoot.transform)
        self.canvas = self:Find(nil, Canvas)
        self.canvas.overrideSorting = true
        self.firstInit = false
    end

    self:SetTopLayer(self.canvas)
    self.QTE_canvas.alpha = 1

    self.hadExit = false
    self.targetPos = Vec3.New(self.setting.targetX, self.setting.targetY, 0)
    if #self.setting.icon > 4 then
        SingleIconLoader.Load(self.Icon, self.setting.icon)
    end

    self:SetAnchorType(self.Start.transform, self.setting.anchorType)
    self:SetAnchorType(self.Target.transform, self.setting.anchorType)
    self:SetAnchorType(self.Center.transform, self.setting.anchorType)
    UnityUtils.SetAnchoredPosition(self.Start.transform, self.setting.initX, self.setting.initY)
    UnityUtils.SetAnchoredPosition(self.Center.transform, self.setting.initX, self.setting.initY)
    UnityUtils.SetAnchoredPosition(self.Target.transform, self.setting.targetX, self.setting.targetY)

    local position = self.Start.transform.position
    local targetPosition = self.Target.transform.position

    ---计算角度
    local target = Vec3.New(targetPosition.x - position.x, targetPosition.y - position.y, 0)
    local angle = Vec3.Angle(Vec3.right, target)
    if self.setting.initY > self.setting.targetY then
        if self.setting.initX < self.setting.targetX then
            angle = -angle
        else
            angle = 360 - angle
        end
    end
    UnityUtils.SetEulerAngles(self.Start.transform, 0, 0, angle)
    UnityUtils.SetEulerAngles(self.Center.transform, 0, 0, angle)

    self.scratchVector = Vec3.New(self.setting.targetX - self.setting.initX, self.setting.targetY - self.setting.initY, 0)
    self.maxScratchLength = self.scratchVector:Magnitude()

    self:CallEntityBehavior("EnterQTE", FightEnum.NewQTEType.Click, self.qteId)
end

function ScratchQTE:__ShowComplete()

end

function ScratchQTE:OnPointerDown(data)
    ---设置按钮按下状态
    if self.setting.scratchType == scratchType.Line then
        self.pointDown = Vec3.New(data.position.x, data.position.y, 0)
        self.startPoint = Vec3.New(self.Center.transform.anchoredPosition.x, self.Center.transform.anchoredPosition.y, 0)
        if self.tween then
            self.tween:Kill()
            self.tween = nil
        end
    end
end

function ScratchQTE:OnDrag(data)
    if self.setting.scratchType == scratchType.Panel then
        UnityUtils.SetAnchoredPosition(self.Center.transform, self.Center.transform.anchoredPosition.x + data.delta.x * 1.15, self.Center.transform.anchoredPosition.y + data.delta.y * 1.15)
    elseif self.setting.scratchType == scratchType.Line then
        self.dragVector = Vec3.New(data.position.x - self.pointDown.x, data.position.y - self.pointDown.y, 0)
        local scratchLength = Vec3.Dot(self.scratchVector, self.dragVector) / self.maxScratchLength
        scratchLength = scratchLength > self.maxScratchLength and self.maxScratchLength or scratchLength
        local vector = Vec3.New(self.setting.targetX - self.startPoint.x, self.setting.targetY - self.startPoint.y, 0)
        vector:ClampMagnitude(scratchLength)
        UnityUtils.SetAnchoredPosition(self.Center.transform, self.startPoint.x + vector.x, self.startPoint.y + vector.y)
    end
    ---位置检测
    self:CheckHandleHit(DragJudgeRadius)
end

function ScratchQTE:OnPointerUp(data)
    ---设置按钮松开状态
    if not self:CheckHandleHit(StopJudgeRadius) then
        if self.setting.scratchType == scratchType.Panel then
            UnityUtils.SetAnchoredPosition(self.Center.transform, self.setting.initX, self.setting.initY)
        else
            self.tween = self.Center_rect:DOAnchorPos({ x = self.setting.initX, y = self.setting.initY }, 0.5)
        end
    end
end

function ScratchQTE:CheckHandleHit(radius)
    local distance = Vec3.SquareDistance(self.targetPos, self.Center.transform.anchoredPosition3D)
    if distance < radius * radius then
        self:OnExitQTE(true)
        return true
    end
    return false
end

function ScratchQTE:OnValueChanged_Slider(value)
    if value > 0.95 then
        self:OnExitQTE(true)
    end
end

function ScratchQTE:CallEntityBehavior(name, ...)
    Fight.Instance.entityManager:CallBehaviorFun(name, ...)
end

function ScratchQTE:OnExitQTE(isSuccess)
    if self.hadExit then
        return
    end
    self.hadExit = true
    self:CallEntityBehavior("ExitQTE", FightEnum.NewQTEType.Scratch, isSuccess, self.qteId)
    self:StopAllEffect()
    self.QTE_canvas:DOFade(0, 0.3)
    local exitFunc = function()
        BehaviorFunctions.fight.clientFight.qteManager:StopQTE(self.qteId)
    end
    LuaTimerManager.Instance:RemoveTimer(self.hideTimer)
    if not self.hideTimer then
        self.hideTimer = LuaTimerManager.Instance:AddTimer(1, 0.3, exitFunc)
    end
end

function ScratchQTE:SetAnchorType(transform, anchorType)
    if not transform or not anchorType then
        return
    end
    if anchorType == FightEnum.QTEAnchorType.LeftTop then
        UnityUtils.SetAnchorMinAndMax(transform, 0, 1, 0, 1)
    elseif anchorType == FightEnum.QTEAnchorType.LeftBottom then
        UnityUtils.SetAnchorMinAndMax(transform, 0, 0, 0, 0)
    elseif anchorType == FightEnum.QTEAnchorType.RightTop then
        UnityUtils.SetAnchorMinAndMax(transform, 1, 1, 1, 1)
    elseif anchorType == FightEnum.QTEAnchorType.RightBottom then
        UnityUtils.SetAnchorMinAndMax(transform, 1, 0, 1, 0)
    else
        UnityUtils.SetAnchorMinAndMax(transform, 0.5, 0.5, 0.5, 0.5)
    end
end
