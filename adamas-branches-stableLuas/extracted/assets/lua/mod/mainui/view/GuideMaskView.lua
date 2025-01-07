
GuideMaskView = BaseClass("GuideMaskView", BaseView)

local FRAME_OFFSET = 22

function GuideMaskView:__init()
    self:SetAsset("Prefabs/UI/Guide/UIGuideMask.prefab")
end

function GuideMaskView:__delete()
end

function GuideMaskView:__CacheObject()
end

function GuideMaskView:__BindListener()
end

function GuideMaskView:__Create()
    local canvas = self:Find(nil,Canvas)
    if canvas ~= nil then
        canvas.pixelPerfect = false
        canvas.overrideSorting = true
    end

	self.maskLocalPos = {} 
    self.maskController = self.BlackGround:GetComponent(GuideMaskController)
    self.maskController.GuideTarget = self.RectMask_rect
    self.guidePostEvent = self.RectMask:GetComponent(GuidePostEvent)
    local dragBehaviour = self.RectMask:AddComponent(UIDragBehaviour)

    dragBehaviour.onPointerDown = self:ToFunc("OnGuideDown")
    dragBehaviour.onPointerClick = self:ToFunc("OnGuideClick")
end

function GuideMaskView:__Show()
    if Fight.Instance then
        self.clientFight = Fight.Instance.clientFight
    end

    self.NpcName_txt.text = self.tipConfig.name
    self.NpcTalk_txt.text = self.tipConfig.content

    self.guidePostEvent.guidePass = self.tipConfig.guide_pass
    self.guidePostEvent.guideTargetEventObj = self.guideTargetEventObj

    local targetRect = self.guideTarget:GetComponent(RectTransform)
    local corners = {Vector3.zero, Vector3.zero, Vector3.zero, Vector3.zero}
    corners = Utils.GetWorldCorners(targetRect, corners)
    
	local uiCamera = ctx.UICamera
    for i = 0, 3 do 
		local spPoint = uiCamera:WorldToScreenPoint(corners[i]);
		spPoint = Vector2(spPoint.x, spPoint.y)
        local _, pos = RectTransformUtility.ScreenPointToLocalPointInRectangle(UIDefine.canvasRoot, spPoint, uiCamera)
		self.maskLocalPos[i] = pos
    end
    
    local centerX = self.maskLocalPos[0].x + (self.maskLocalPos[3].x - self.maskLocalPos[0].x) * 0.5
    local centerY = self.maskLocalPos[0].y + (self.maskLocalPos[1].y - self.maskLocalPos[0].y) * 0.5
    
	if self.tipConfig.offset_fix_type then
		UnityUtils.SetLocalPosition(self.NpcDialog_rect, self.tipConfig.offset_x, self.tipConfig.offset_y, 0)
	else
		UnityUtils.SetLocalPosition(self.NpcDialog_rect,centerX - self.tipConfig.offset_x, centerY - self.tipConfig.offset_y, 0)
	end
	
	UnityUtils.SetLocalPosition(self.RectMask_rect,centerX, centerY, 0)
	
    local origin_size = targetRect.sizeDelta
    CustomUnityUtils.SetSizeDelata(self.RectMask_rect, origin_size.x + FRAME_OFFSET, origin_size.y + FRAME_OFFSET)

    if self.tipConfig.time > 0 then
        self.tipsTimer = LuaTimerManager.Instance:AddTimer(1, self.tipConfig.time,self:ToFunc("HideComplete"))
    end

    self.yindao_canvas.alpha = 1
end

function GuideMaskView:OnGuideDown()
    if self.tipConfig.click_type == 1 then
        self:OnGuide()
        self.yindao_canvas.alpha = 0
    end
end

function GuideMaskView:OnGuideClick()
    if self.tipConfig.click_type ~= 1 then
        self:OnGuide()
    end

    self.yindao_canvas.alpha = 1
    self:Hide()
end


function GuideMaskView:OnGuide()
    if self.clientFight then
        EventMgr.Instance:Fire(EventName.KeyAutoUp, FightEnum.KeyEvent.GuideClick)
    end

    self:RemoveTimer()
end

function GuideMaskView:HideComplete()
    if self.clientFight then
        EventMgr.Instance:Fire(EventName.KeyAutoUp, FightEnum.KeyEvent.GuideTimeout)
    end
    self:RemoveTimer()
    self:Hide()
end

function GuideMaskView:ShowTips(Id)
    self.tipConfig = Config.DataTips.data_guide_tips[Id]
	if not self.tipConfig then
		LogError("guide_tips id nil : "..Id)
	end
    --assert(self.tipConfig, "guide_tips id nil : "..Id)

    local view =  UIDefine.canvasRoot:Find(self.tipConfig.view_name)
    if not view then
        LogError("ShowTips view null ".. Id)
        return
    end

    local path = UtilsBase.GetChildPath(view, self.tipConfig.view_target_name)
    self.guideTarget = view.transform:Find(path)
    self.guideTargetEventObj = nil
    if self.tipConfig.view_target_event then
        if self.tipConfig.view_target_event ~= self.tipConfig.view_target_name and 
            self.tipConfig.view_target_event ~= "" then
            -- path = UtilsBase.GetChildPath(view, self.tipConfig.view_target_event)
            self.guideTargetEventObj = self.guideTarget.transform:Find(self.tipConfig.view_target_event).gameObject
        end
    end 

    if not self.guideTarget then
        LogError("ShowTips target null ".. Id)
        return
    end
    
    self:Show()
end

function GuideMaskView:RemoveTimer()
    if self.tipsTimer then
        LuaTimerManager.Instance:RemoveTimer(self.tipsTimer)
        self.tipsTimer = nil
    end
end