GuideMaskPanel = BaseClass("GuideMaskPanel", BasePanel)

local FRAME_OFFSET = 33
local FRAME_EFFECT_OFFSET = 22

--1、2:锚点对齐 3、4：轴偏移 5、6：箭头偏移 7：箭头旋转
local Quadrant2Dir = {
	[1] = {-0.31, -0.4, -0.5, -0.65, -0.5, 10, 180, -17},
	[2] = {0.31, -0.4, 0.5, -0.65, -0.5, 10, 180, -17},
	[3] = {0.31, 0.4, 0.5, 0.65, 0.5, -10, 0, 17},
	[4] = {-0.31, 0.4, -0.5, 0.65, 0.5, -10, 0, 17},
}

local DefaultEffectSize = {
	x = 207,
	y = 200
}

local Quadrant2AnimName = {
	[1] = "GuideTextArea_zuo_Open",
	[2] = "GuideTextArea_you_Open",
	[3] = "GuideTextArea_you_Open",
	[4] = "GuideTextArea_zuo_Open",
}

function GuideMaskPanel:__init()
	self:SetAsset("Prefabs/UI/Guide/GuideMaskPanel.prefab")
	self.cacheMode = UIDefine.CacheMode.hide
	
	self.config = nil
	self.callback = nil
	self.skipCallback = nil
	
	self.isShow = false
	self.clickCount = 0
	
	self.targetHide = false
end

function GuideMaskPanel:__delete()
end

function GuideMaskPanel:__CacheObject()
end

function GuideMaskPanel:__BindListener()
	self.SkipBtn_btn.onClick:AddListener(self:ToFunc("OnSkip"))
	self.Mask_btn.onClick:AddListener(self:ToFunc("OnClickMask"))
end

function GuideMaskPanel:__Create()
	self.canvas = self:Find(nil,Canvas)
	if self.canvas ~= nil then
		self.canvas.pixelPerfect = false
		self.canvas.overrideSorting = true
		self.canvas.sortingOrder = 999
	end
	
	self.maskClickFunc = self.BlackMask:AddComponent(GuidePostEvent)
	self.maskClickFunc.onPointerDown = self:ToFunc("OnGuideDown")
	self.maskClickFunc.onPointerClick = self:ToFunc("OnGuideClick")
	--self.maskClickFunc.guidePass = true
	
	self.clickAreaClickFunc = self.ClickArea2:AddComponent(GuidePostEvent)
	self.clickAreaClickFunc.onPointerDown = self:ToFunc("OnGuideDown")
	self.clickAreaClickFunc.onPointerClick = self:ToFunc("OnGuideClick")
	self.clickAreaClickFunc.guidePass = true
	
	self.Arrow_rectTransform = self.Arrow.transform:GetComponent(RectTransform)
	self.effectUtil = self.Effect:GetComponent(EffectUtil)
end

function GuideMaskPanel:__Show()
	self:ToggleGuideMask(false)
	self.Guide:SetActive(false)
	self.SkipBtn:SetActive(false)
	self.BlackMask_anim.enabled = false
	self.isShow = true
end

local CharSize = {21.49, 27.42}
local BgOffset = {45, 25}
local MaxCharNum = 10
local ArrowSize = {55, 44}
function GuideMaskPanel:UpdateGuidePanel()
	if self.config.end_condition == 3 or self.config.show_mask == 0 then
		self:ToggleGuideMask(false)
	end
	self.Guide:SetActive(true)
		
	self.SkipBtn:SetActive(false)
	if not self.config.hide_frame then
		self.GuideMaskPanel_Open:SetActive(true)
	end
	
	self.BlackMask_canvas.alpha = 0
	if self.config.show_mask == 2 then
		self:PlayBlackMaskAnim(true, true)
	end
	
	self.BoxImage:SetActive(not self.config.hide_frame)
	--self.ClickArea:SetActive(self.config.end_condition == 1)
	self.ClickArea2_img.raycastTarget = self.config.end_condition == 1
	self.BlackMask_img.raycastTarget = self.config.end_condition == 2
	
	local quadrant = self.config.quadrant == 0 and 1 or self.config.quadrant
	
	if self.guideTarget then
		self.clickAreaClickFunc.guideTargetEventObj = self.guideTarget.gameObject
		--self.maskClickFunc.guideTargetEventObj = self.guideTarget.gameObject
		
		local targetRect = self.guideTarget:GetComponent(RectTransform)
		local corners = {Vector3.zero, Vector3.zero, Vector3.zero, Vector3.zero}
		corners = UnityUtils.GetWorldCorners(targetRect, corners)
	
		local uiCamera = ctx.UICamera
		local maskLocalPos = {}
		for i = 0, 3 do
			local spPoint = uiCamera:WorldToScreenPoint(corners[i])
			spPoint = Vector2(spPoint.x, spPoint.y)
			local _, pos = RectTransformUtility.ScreenPointToLocalPointInRectangle(UIDefine.canvasRoot, spPoint, uiCamera)
			maskLocalPos[i] = pos
		end
	
		local centerX = maskLocalPos[0].x + (maskLocalPos[3].x - maskLocalPos[0].x) * 0.5
		local centerY = maskLocalPos[0].y + (maskLocalPos[1].y - maskLocalPos[0].y) * 0.5
		UnityUtils.SetLocalPosition(self.ClickArea_rect,centerX, centerY, 0)

		local origin_size = targetRect.transform.rect.size
		CustomUnityUtils.SetSizeDelata(self.ClickArea_rect, origin_size.x + FRAME_OFFSET, origin_size.y + FRAME_OFFSET)
		CustomUnityUtils.SetSizeDelata(self.ClickArea2_rect, origin_size.x, origin_size.y)
		
		local scaleX = (origin_size.x + FRAME_EFFECT_OFFSET) / DefaultEffectSize.x
		local scaleY = (origin_size.y + FRAME_EFFECT_OFFSET) / DefaultEffectSize.y
		--UnityUtils.SetLocalPosition(self.Effect_rect,centerX, centerY, 0)
		UnityUtils.SetLocalScale(self.Effect_rect, scaleX, scaleY, 1)
		self.effectUtil:SetSortingOrder(self.canvas.sortingOrder + 1)
		
		self.GuideTextArea_zuo_Open:SetActive(false)
		self.GuideTextArea_you_Open:SetActive(false)
		local animObjName = Quadrant2AnimName[quadrant]
		self[animObjName]:SetActive(true)
	end

	local text = self.config.text
	if text ~= "" then
		self.GuideTextArea:SetActive(true)
		self.GuideText_txt.text = text
		local len = math.ceil(string.len(text) / 3)
		local width = math.min(MaxCharNum, len) * CharSize[1] + BgOffset[1]
		local height = math.ceil(len / MaxCharNum) * CharSize[2] + BgOffset[2]

		local offsetDir = Quadrant2Dir[quadrant]
		local framePos = self.ClickArea.transform.localPosition
		local frameSize = self.ClickArea_rect.sizeDelta

		self.Arrow:SetActive(true)
		self.Arrow.transform.localRotation = Quaternion.Euler(Vector3(0, 0, offsetDir[7]))
		local arrowX = framePos.x
		local arrowY = framePos.y + frameSize.y * offsetDir[5] + ArrowSize[2] * offsetDir[5] + offsetDir[6]
		UnityUtils.SetLocalPosition(self.Arrow.transform, arrowX, arrowY + offsetDir[8], 0)
		
		local x = arrowX + ArrowSize[1] * offsetDir[1] + width * offsetDir[3]
		local y = arrowY + ArrowSize[2] * offsetDir[2] + height * offsetDir[4]
		UnityUtils.SetLocalPosition(self.GuideTextArea.transform, x, y, 0)
	else
		self.GuideTextArea:SetActive(false)
		self.Arrow:SetActive(false)
	end

	if self.config.time > 0 then
		self.tipsTimer = LuaTimerManager.Instance:AddTimer(1, self.config.time,self:ToFunc("OnGuide"))
	end

	self:Update()
	self.updateTimer = LuaTimerManager.Instance:AddTimer(0, 0.1, self:ToFunc("Update"))
end

function GuideMaskPanel:Update()
	if not self.config then
		return
	end
	
	if not self.guideTarget then
		return 
	end
	
	--需要保底，切换仲魔那里可以测试
	if not UtilsBase.IsNull(self.guideTarget.gameObject) then
		self.Guide:SetActive(self.guideTarget.gameObject.activeInHierarchy)
		if self.config.end_condition ~= 3 and self.config.show_mask ~= 0 then
			local active = self.guideTarget.gameObject.activeInHierarchy
			self:ToggleGuideMask(active)
			self.targetHide = not active
		end
	end
end

function GuideMaskPanel:OnSkip()
	if self.skipCallback then
		self.skipCallback()
	end
end

local SkipStageCount = 10
function GuideMaskPanel:OnClickMask()
	self.clickCount = self.clickCount + 1
	if self.config and self.config.show_mask == 1 then
		self:PlayBlackMaskAnim(true)
	end

	if self.clickCount >= SkipStageCount then
		self.SkipBtn:SetActive(self.skipCallback ~= nil)
	end
end

function GuideMaskPanel:AutoUp(eventData)
	if not self.config then
		return 
	end
	if self.config.end_condition == 1 then
		self.clickAreaClickFunc:OnPointerUp(eventData)
	end
end

function GuideMaskPanel:OnGuideDown(eventData)
	if self.config and self.config.click_type == 1 then
		self:OnGuideDelay(eventData)
	end
end

function GuideMaskPanel:OnGuideClick(eventData)
	if self.config and self.config.click_type == 2 then
		self:OnGuideDelay()
	end
end

function GuideMaskPanel:OnGuideDelay(eventData)
	self.dontShowMaskEffect = true
	self.lastEventData = eventData
	--延迟0.1s等按钮事件响应完
	self.finishTimer = LuaTimerManager.Instance:AddTimer(1, 0.1,self:ToFunc("OnGuide"))
end


function GuideMaskPanel:OnGuide()
	if self.lastEventData then
		self:AutoUp(self.lastEventData)
		self.lastEventData = nil
	end
	
	if self.callback then
		self.callback()
	end
end

function GuideMaskPanel:GuideFinish()
	if self.config and #self.config.scale_type > 0 then
		for _, v in pairs(self.config.scale_type) do
			self:SetPause(v, true)
		end
	end
	
	self.Guide:SetActive(false)
	self.SkipBtn:SetActive(false)
	self.GuideMaskPanel_Open:SetActive(false)
	self:RemoveTimer()
	--self:Hide()
	
	self.config = nil
	self.callback = nil
	self.dontShowMaskEffect = false
	self.targetHide = false
	
	self.clickAreaClickFunc.guideTargetEventObj = nil
	--self.maskClickFunc.guideTargetEventObj = nil
	self.guideTarget = nil
end

function GuideMaskPanel:GetWidget(view, widgetName)
	local data = StringHelper.Split(widgetName, "|")
	widgetName = data[1] or widgetName
	
	local widget = view[widgetName]
	if not widget then
		local path = UtilsBase.GetChildPath(view.transform, widgetName)
		path = path == "" and widgetName or path
		widget = view.transform:Find(path)

		if widget then
			local idx = data[2]
			if idx then
				widget = widget.transform:GetChild(tonumber(idx) - 1)
			end
		end
	end
	return widget
end

function GuideMaskPanel:ShowGuide(data, callback, repeatCallback)
	if data.window_name and data.window_name ~= "" then
		local window
		if data.window_name == "CanvasContainer" then
			window = PanelManager.Instance
		else
			window = WindowManager.Instance:GetWindow(data.window_name)
		end
		if not window then
			window = PanelManager.Instance:GetPanel(data.window_name)
			if not window then
				LogError("[GuideMaskPanel]错误的窗口获取：".. data.window_name)
				return
			end
		end
		
		local panel
		if data.panel_name and data.panel_name ~= "" then
			panel = window.panelList[data.panel_name]
			if not panel then
				LogError("[GuideMaskPanel]错误的界面获取：".. data.panel_name)
				return false
			end
		end
		
		local view = panel ~= nil and panel or window
		if not view.transform then
			repeatCallback()
			return
		end
		self.guideTarget = self:GetWidget(view, data.widget_name)

		if not self.guideTarget then
			LogError("[GuideMaskPanel]错误的控件获取：".. data.widget_name)
			return
		end
		
		if self.canvas and view.canvas.sortingOrder >= self.canvas.sortingOrder then
			self.canvas.sortingOrder = view.canvas.sortingOrder + 1
		end
	end
	
	if #data.scale_type > 0 then
		for _, v in pairs(data.scale_type) do
			self:SetPause(v)
		end
	end

	self.config = data
	self.callback = callback
	self.clickCount = 0
	
	self:UpdateGuidePanel()
end

local EnemyScaleMagicId = 1000100
local RoleScaleMagicId = 1000101
function GuideMaskPanel:SetPause(scaleType, isEnd)
	if isEnd then
		if scaleType == 1 then
			local instanceId = BehaviorFunctions.GetCtrlEntity()
			BehaviorFunctions.RemoveBuff(instanceId, RoleScaleMagicId)
		elseif scaleType == 2 then
			BehaviorFunctions.RemoveBuff(1, EnemyScaleMagicId)
		elseif scaleType == 3 then
		end
		
		return
	end
	if scaleType == 1 then
		local instanceId = BehaviorFunctions.GetCtrlEntity()
		BehaviorFunctions.AddBuff(1, instanceId, RoleScaleMagicId)
	elseif scaleType == 2 then
		BehaviorFunctions.AddBuff(1, 1, EnemyScaleMagicId)
	elseif scaleType == 3 then
	end
end

function GuideMaskPanel:ToggleGuideMask(enable)
	if self.Mask then
		self.Mask:SetActive(enable)
	end
	
	if not enable then
		self.SkipBtn:SetActive(false)
	end
end

function GuideMaskPanel:SetSkipCallback(skipCallback)
	self.skipCallback = skipCallback
end

function GuideMaskPanel:RemoveTimer()
	if self.tipsTimer then
		LuaTimerManager.Instance:RemoveTimer(self.tipsTimer)
		self.tipsTimer = nil
	end
	
	if self.finishTimer then
		LuaTimerManager.Instance:RemoveTimer(self.finishTimer)
		self.finishTimer = nil
	end
	
	
	if self.updateTimer then
		LuaTimerManager.Instance:RemoveTimer(self.updateTimer)
		self.updateTimer = nil
	end
	
	self:RemoveBlackMaskTimer()
end

local BlackFrame = 10
local StayTime = 0.5
function GuideMaskPanel:PlayBlackMaskAnim(toBlack, single)
	if self.blackMaskTimer then
		return 
	end
	
	if not self.GuideMaskPanel_Open.activeSelf then
		return 
	end
	
	local delayFunc = function()
		self:RemoveBlackMaskTimer()
		if not self.dontShowMaskEffect then
			if toBlack then
				self.GuideMaskPanel_Open:SetActive(false)
				self.GuideMaskPanel_Open:SetActive(true)
			end
			
			self.BlackMask_canvas.alpha = toBlack and 0 or 1
			self.curBlackTime = 0

			local animFunc = function()
				self:OnBlackMaskAnim(toBlack, single)
			end
			self.blackMaskTimer = LuaTimerManager.Instance:AddTimer(BlackFrame, 0.0333, animFunc)
		end
	end
	
	if toBlack then
		self.blackMaskTimer = LuaTimerManager.Instance:AddTimer(1, 0.01, delayFunc)
	else
		delayFunc()
	end
end

function GuideMaskPanel:OnBlackMaskAnim(toBlack, single)
	local percent = toBlack and self.curBlackTime / BlackFrame or (BlackFrame - self.curBlackTime) / BlackFrame
	self.BlackMask_canvas.alpha = percent
	self.curBlackTime = self.curBlackTime + 1
	if self.curBlackTime >= BlackFrame then
		self:RemoveBlackMaskTimer()
		if toBlack and (single == nil or not single) then
			local animFunc = function()
				self:RemoveBlackMaskTimer()
				self:PlayBlackMaskAnim(false)
			end
			self.blackMaskTimer = LuaTimerManager.Instance:AddTimer(1, StayTime, animFunc)
		end
	end

end

function GuideMaskPanel:RemoveBlackMaskTimer()
	if self.blackMaskTimer then
		LuaTimerManager.Instance:RemoveTimer(self.blackMaskTimer)
		self.blackMaskTimer = nil
	end
end