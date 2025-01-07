GuideMaskPanel = BaseClass("GuideMaskPanel", BasePanel)

local FRAME_OFFSET = 33
local FRAME_EFFECT_OFFSET = 22

--1、2:锚点对齐 3、4:轴偏移 5、6:箭头偏移 7:箭头旋转 8:箭头Y的额外偏移
local Quadrant2Dir = {
	[1] = {-0.31, -0.4, -0.5, -0.65, -0.5, 10, 0, 17},
	[2] = {0.31, -0.4, 0.5, -0.65, -0.5, 10, 0, 17},
	[3] = {0.31, 0.4, 0.5, 0.65, 0.5, -10, 180, -17},
	[4] = {-0.31, 0.4, -0.5, 0.65, 0.5, -10, 180, -17},
}

--1、2:锚点对齐 3、4:轴偏移 5:箭头旋转 6、7:箭头Y的额外偏移
local Quadrant2Arrow = {
	[1] = {0, 0.5, 0, -10, 180, 0, -17},
	[2] = {-0.5, 0, 10, 0, -90, 17, 0},
	[3] = {0, -0.5, 0, 10, 0, 0, 17},
	[4] = {0.5, 0, -10, 0, 90, -17, 0},
}

--1、2:锚点对齐 3、4:框偏移 5、6:位置偏移
local Quadrant2Head = {
	[1] = {0.46, 0.36, -0.5, -0.5},
	[2] = {-0.46, 0.36, 0.5, -0.5},
	[3] = {-0.46, -0.36, 0.5, 0.5},
	[4] = {0.46, -0.36, -0.5, 0.5},
}

local CharSize = {21.49, 27.42} --单个字体大小
local BgOffset = {45, 50} --底板除字部分的偏移（左右，上下）
local MaxCharNum = 10 --一行字的个数
local ArrowSize = {55, 44} --箭头大小


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
	EventMgr.Instance:RemoveListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
end

function GuideMaskPanel:__CacheObject()
end

function GuideMaskPanel:__BindListener()
	self.SkipBtn_btn.onClick:AddListener(self:ToFunc("OnSkip"))
	self.Mask_btn.onClick:AddListener(self:ToFunc("OnClickMask"))
	EventMgr.Instance:AddListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
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
	self.GuideSoundBinder = self.Guide:GetComponent(UISoundBinder)
	self.SkipBtn:SetActive(false)
	self.BlackMask_anim.enabled = false
	self.isShow = true
end

function GuideMaskPanel:OnActionInput(key, value)
	if not self.config then
		return
	end
    if key == FightEnum.ActionToKeyEvent[self.config.click_node] then
        self:OnGuideDelay()
	elseif self.config.end_condition == 2 and key == FightEnum.KeyEvent.Attack then
		self:OnGuideDelay()
    end
end

function GuideMaskPanel:UpdateGuidePanel()
	if self.config.end_condition == 3 or self.config.show_mask == 0 then
		self:ToggleGuideMask(false)
	end
	self.Guide:SetActive(true)
	self.GuideSoundBinder:PlayEnterSound()
		
	self.SkipBtn:SetActive(false)
	if not self.config.hide_frame then
		self.GuideMaskPanel_Open:SetActive(true)
	end
	
	self.BlackMask_canvas.alpha = 0
	if self.config.show_mask == 2 then
		self:PlayBlackMaskAnim(true, true)
	end
	
	UtilsUI.SetActive(self.BoxImage, not self.config.hide_frame)
	UtilsUI.SetActive(self.Arrow, not self.config.hide_arrow)

	--self.ClickArea:SetActive(self.config.end_condition == 1)
	self.ClickArea2_img.raycastTarget = self.config.end_condition == 1
	self.BlackMask_img.raycastTarget = self.config.end_condition == 2
	
	local areaQuadrant = self.config.quadrant == 0 and 1 or self.config.quadrant
	local arrowQuadrant = self.config.arrow_quadrant == 0 and 1 or self.config.arrow_quadrant
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

		local targetLossScale = UnityUtils.GetGlobalScale(targetRect)
		UnityUtils.SetLocalScale(self.ClickArea_rect,targetLossScale.x,targetLossScale.y,targetLossScale.z)

		local origin_size = targetRect.transform.rect.size
		local offset = self.config.click_area_offset or 0
		CustomUnityUtils.SetSizeDelata(self.ClickArea_rect, origin_size.x + FRAME_OFFSET, origin_size.y + FRAME_OFFSET)
		CustomUnityUtils.SetSizeDelata(self.ClickArea2_rect, origin_size.x + offset, origin_size.y + offset)
		
		local scaleX = (origin_size.x + FRAME_EFFECT_OFFSET) / DefaultEffectSize.x
		local scaleY = (origin_size.y + FRAME_EFFECT_OFFSET) / DefaultEffectSize.y
		--UnityUtils.SetLocalPosition(self.Effect_rect,centerX, centerY, 0)
		UnityUtils.SetLocalScale(self.Effect_rect, scaleX, scaleY, 1)
		self.effectUtil:SetSortingOrder(self.canvas.sortingOrder + 1)
		
		-- self.GuideTextArea_zuo_Open:SetActive(false)
		-- self.GuideTextArea_you_Open:SetActive(false)
		-- local animObjName = Quadrant2AnimName[areaQuadrant]
		-- self[animObjName]:SetActive(true)
	end

	local text = self.config.text
	if text ~= "" then
		local style = self.config.style or 1
		
		if style == 1 then
			self:ShowTextStyle(areaQuadrant, text)
		elseif style == 2 then
			self:UpdateArrow(arrowQuadrant)
			self:ShowHeadStyle(areaQuadrant, text)
		end
	else
		self.GuideTextArea:SetActive(false)
		self.GuideHeadArea:SetActive(false)
		self.Arrow:SetActive(false)
	end

	if self.config.time > 0 then
		self.tipsTimer = LuaTimerManager.Instance:AddTimer(1, self.config.time,self:ToFunc("OnGuide"))
	end

	self:Update()
	self.updateTimer = LuaTimerManager.Instance:AddTimer(0, 0.1, self:ToFunc("Update"))
end

function GuideMaskPanel:UpdateArrow(quadrant)
	local offsetArrow = Quadrant2Arrow[quadrant]
	local frameSize = self.ClickArea_rect.sizeDelta
	local framePos = self.ClickArea.transform.localPosition

	if self.config.hide_arrow then
		UtilsUI.SetActive(self.Arrow, false)
	else
		UtilsUI.SetActive(self.Arrow, true)
	end
	self.Arrow.transform.localRotation = Quaternion.Euler(Vector3(0, 0, offsetArrow[5]))
	local arrowX = framePos.x + (frameSize.x + ArrowSize[1]) * offsetArrow[1] + offsetArrow[3]
	local arrowY = framePos.y + (frameSize.y + ArrowSize[2]) * offsetArrow[2] + offsetArrow[4]
	UnityUtils.SetLocalPosition(self.Arrow.transform, arrowX + offsetArrow[6], arrowY + offsetArrow[7], 0)
end

function GuideMaskPanel:ShowTextStyle(quadrant, text)
	self.GuideText_txt.text = text
	self.GuideTextArea:SetActive(true)
	self.GuideHeadArea:SetActive(false)
	
	local len = math.ceil(string.len(text) / 3)
	local width = math.min(MaxCharNum, len) * CharSize[1] + BgOffset[1]
	local height = math.ceil(len / MaxCharNum) * CharSize[2] + BgOffset[2]

	local offsetDir = Quadrant2Dir[quadrant]
	local frameSize = self.ClickArea_rect.sizeDelta
	local framePos = self.ClickArea.transform.localPosition
	
	if self.config.hide_arrow then
		UtilsUI.SetActive(self.Arrow, false)
	else
		UtilsUI.SetActive(self.Arrow, true)
	end
	self.Arrow.transform.localRotation = Quaternion.Euler(Vector3(0, 0, offsetDir[7]))
	local anchorX = framePos.x
	local anchorY = framePos.y + (frameSize.y + ArrowSize[2]) * offsetDir[5] + offsetDir[6]
	UnityUtils.SetLocalPosition(self.Arrow.transform, anchorX, anchorY + offsetDir[8], 0)

	local x = anchorX + ArrowSize[1] * offsetDir[1] + width * offsetDir[3]
	local y = anchorY + ArrowSize[2] * offsetDir[2] + height * offsetDir[4]
	UnityUtils.SetLocalPosition(self.GuideTextArea.transform, x, y, 0)
end

function GuideMaskPanel:ShowHeadStyle(quadrant, text)
	self.GuideHeadText_txt.text = text
	self.GuideTextArea:SetActive(false)
	self.GuideHeadArea:SetActive(false)
	self.GuideHead:SetActive(false)
	
	local image = self.config.image
	if image and image ~= "" then
		SingleIconLoader.Load(self.GuideHeadIcon, image, function()
				self.GuideHeadArea:SetActive(true)
				self.GuideHead:SetActive(true)
			end)
	end
	
	self.GuideHeadName_txt.text = self.config.title or ""
	
	local offsetDir = Quadrant2Head[quadrant]
	local areaSize = self.GuideHeadArea_rect.sizeDelta
	
	local screenW = UIDefine.canvasRoot.rect.width
	local screenH = UIDefine.canvasRoot.rect.height
	
	local x = screenW * offsetDir[1] + areaSize.x * offsetDir[3]
	local y = screenH * offsetDir[2] + areaSize.y * offsetDir[4]
	UnityUtils.SetLocalPosition(self.GuideHeadArea.transform, x, y, 0)
end

function GuideMaskPanel:Update()
	if not self.config then
		return
	end
	
	if not self.guideTarget then
		return 
	end
	
	if not UtilsBase.IsNull(self.guideTarget.gameObject) then
		local active = UtilsUI.IsActiveInHierarchy(self.guideTarget.gameObject)
		if self.curActive ~= active then
			self.curActive = active
			if active then
				if Fight.Instance.clientFight.guideManager.curClickNode then
					BehaviorFunctions.SetOnlyKeyInput(Fight.Instance.clientFight.guideManager.curClickNode, true)
				else
					BehaviorFunctions.SetOnlyKeyInput(nil, false)
				end
				Fight.Instance.clientFight.guideManager:DoGuideStage(Fight.Instance.clientFight.guideManager.guidingData.playStage)
			else
				BehaviorFunctions.SetOnlyKeyInput(nil, false)
			end
		end

		self.Guide:SetActive(active)
		if self.config.end_condition ~= 3 and self.config.show_mask ~= 0 then
			--local active = self.guideTarget.gameObject.activeInHierarchy
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
	if self.config and self.config.click_type == 2 and eventData.button == PointerEventData.InputButton.Left then
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
	
	if self.lastEventData then
		self:AutoUp(self.lastEventData)
		self.lastEventData = nil
	end
	
	self.Guide:SetActive(false)
	self.GuideSoundBinder:PlayExitSound()
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
		elseif data.window_name == "StoryDialogPanelV2" then
			window = Story.Instance.panel
		else
			window = WindowManager.Instance:GetWindow(data.window_name)
		end
		if not window then
			window = PanelManager.Instance:GetPanel(data.window_name)
			if not window then
				LogError("[GuideMaskPanel]错误的窗口获取：".. data.window_name)
				self:ActiveForceSkip()
				return false
			end
		end
		
		local panel
		if data.panel_name and data.panel_name ~= "" then
			panel = window.panelList[data.panel_name]
			if not panel then
				panel = PanelManager.Instance:GetPanelByName(data.panel_name)
				if not panel then
					LogError("[GuideMaskPanel]错误的界面获取：".. data.panel_name)
					self:ActiveForceSkip()
					return false
				end
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
			self:ActiveForceSkip()
			return false
		end
		
		local active = UtilsUI.IsActiveInHierarchy(self.guideTarget.gameObject)
		if not active then
			BehaviorFunctions.SetOnlyKeyInput(nil, false)
			self.curActive = false
		else
			self.curActive = true
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
	return true
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

function GuideMaskPanel:ActiveForceSkip()
	self.clickCount = SkipStageCount + 1
	self.SkipBtn:SetActive(true)
	MsgBoxManager.Instance:ShowTipsImmediate("引导错误，右上角点击跳过")
end