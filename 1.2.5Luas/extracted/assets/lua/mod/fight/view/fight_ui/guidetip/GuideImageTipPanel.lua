GuideImageTipPanel = BaseClass("GuideImageTipPanel", BasePanel)

local DataImageTips = Config.DataImageTips.Find

local addStep = 850 --tip的间隔
local switchInterval = 300 --tip切换阈值
local moveTime = 10 --切页动画帧数
local closeBtnShowTime = 6 --关闭按钮动画帧数

function GuideImageTipPanel:__init()
	self:SetAsset("Prefabs/UI/Guide/GuideImageTipPanel.prefab")
	
	self.tipIds = {}
	self.tipAmount = 1
	self.tipObjList = {}
	self.curTip = 1
	
	self.isShowCloseBtn = false
	
	--切换动画相关
	self.startPos = nil
	self.endPos = nil
	self.timeStep = 1
end

function GuideImageTipPanel:__delete()
end

function GuideImageTipPanel:__BindListener()
	self:SetHideNode("GuideImageTipPanel_Eixt")
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("HidePanel"))

	self.NextArrow_btn.onClick:AddListener(self:ToFunc("OnNextTip"))
	self.BackArrow_btn.onClick:AddListener(self:ToFunc("OnBackTip"))
	
	local dragBehaviour = self.DragArea:GetComponent(UIDragBehaviour)
	if not dragBehaviour then
		dragBehaviour = self.DragArea:AddComponent(UIDragBehaviour)
	end
	
	local onPointerDown = function(data)
		self.startPos = self.GuideTipGroup.transform.localPosition
	end
	dragBehaviour.onPointerDown = onPointerDown

	local onDrag = function(data)
		if not self.startPos then return end
		if self.curTip == 1 and data.delta.x > 0 then return end
		if self.curTip == self.tipAmount and data.delta.x < 0 then return end
		self.GuideTipGroup.transform.localPosition = self.GuideTipGroup.transform.localPosition + Vector3(data.delta.x, 0, 0)
	end
	dragBehaviour.onDrag = onDrag

	local onEndDrag = function(data)
		if not self.startPos then return end
		
		local curPos = self.GuideTipGroup.transform.localPosition
		if curPos.x - self.startPos.x <= -switchInterval and self.curTip < self.tipAmount then
			self:OnNextTip()
		elseif curPos.x - self.startPos.x >= switchInterval and self.curTip > 1 then
			self:OnBackTip()
		else
			self.endPos = self.startPos
			self.startPos = self.GuideTipGroup.transform.localPosition
			self.moveStep = 1
		end
		
	end
	dragBehaviour.onEndDrag = onEndDrag
end

function GuideImageTipPanel:__CacheObject()
	self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function GuideImageTipPanel:__Create()

end

function GuideImageTipPanel:__Hide()
	InputManager.Instance:MinusLayerCount()
	if self.updateTimer then
		LuaTimerManager.Instance:RemoveTimer(self.updateTimer)
		self.updateTimer = nil
	end
	for k, v in pairs(self.tipObjList) do
		if v.rtTemp then
	        RenderTexture.ReleaseTemporary(v.rtTemp)
	        v.rtTemp = nil
	    end
		if v.assetLoader ~= nil then
	        v.assetLoader:DeleteMe()
	        v.assetLoader = nil
	    end
		GameObject.Destroy(v.gameObject)
	end
	self.tipObjList = {}
	BehaviorFunctions.CancelJoystick()
	BehaviorFunctions.Resume()

	LuaTimerManager.Instance:AddTimerByNextFrame(1, 0.1, function ()
		BehaviorFunctions.fight.teachManager:CloseTeachShowInfo(TeachConfig.ShowType.ShowImgPanel)
    end)
	EventMgr.Instance:Fire(EventName.ShowCursor, false)
end

function GuideImageTipPanel:__Show()
	InputManager.Instance:AddLayerCount(InputManager.Instance.actionMapName, "UI")
	BehaviorFunctions.Pause()
	-- local firstTipId = self.args[1]

	local teachId = self.args[1]
	self:UpdateTipIdList(teachId)
	self.teachId = teachId
	BehaviorFunctions.fight.teachManager:GetTeachLookReward(teachId)

	self:InitGuideTip()
	self.closeCallback = self.args[2]
	
	if not self.updateTimer then
		self.updateTimer = LuaTimerManager.Instance:AddTimer(0, 0.01,self:ToFunc("Update"))
	end

	Fight.Instance.entityManager:CallBehaviorFun("OnGuideImageTips", teachId, true)
	Fight.Instance.taskManager:CallBehaviorFun("OnGuideImageTips", teachId, true)
	EventMgr.Instance:Fire(EventName.ShowCursor, true)
end

function GuideImageTipPanel:Update()
	if not self.CommonBack1 then
		return
	end
	if self.CommonBack1_canvas.alpha ~= 1 then
		self.closeBtnTimeStep = self.closeBtnTimeStep and self.closeBtnTimeStep + 1 or 1
		self.CommonBack1_canvas.alpha = self.closeBtnTimeStep / closeBtnShowTime
	end
	
	if self.startPos and self.endPos then
		self.GuideTipGroup.transform.localPosition = Vector3.Lerp(self.startPos, self.endPos, self.timeStep / moveTime)
		self.timeStep = self.timeStep + 1
		if self.timeStep >= moveTime + 1 then
			self.startPos = nil
			self.endPos = nil
			self.timeStep = 1
			return
		end
	end
end

function GuideImageTipPanel:UpdateTipIdList(teachId)
	local idMap = TeachConfig.GetTeachIdMap(teachId)
	if not idMap then return end
	for _, data in ipairs(idMap) do
		table.insert(self.tipIds, data.id)
	end
end

local tagTip = "<size=36>%d</size>/%d"
function GuideImageTipPanel:InitGuideTip()
	self.transform:GetComponent(RectTransform).sizeDelta = Vector2(0, 0)
	self.tipAmount = #self.tipIds
	for k, v in pairs(self.tipIds) do
		local tipData = DataImageTips[v]
		local tipObj = self:CreateBaseGuideTipObj(tipData)
		local posX = addStep * (k - 1)
		
		tipObj.transform.localPosition = Vector3(posX, self.GuideTip.transform.localPosition.y, 0)
		
		if tipData.res_type == 1 then
			SingleIconLoader.Load(tipObj.PicImage, tipData.img)
			tipObj.VideoContent:SetActive(false)
		else
			tipObj.PicImage:SetActive(false)
			self:CreateVideo(tipObj, tipData.video)
		end

		tipObj.TxtTitle_txt.text = tipData.topic
		tipObj.TxtContent_txt.text = tipData.content
		tipObj.TxtTag_txt.text = string.format(tagTip, k, self.tipAmount)
		tipObj.TxtTag:SetActive(self.tipAmount > 1)

		self.tipObjList[v] = tipObj
	end
	
	self.CommonBack1:SetActive(false)
	self:OnChangeTag()
end

function GuideImageTipPanel:CreateBaseGuideTipObj(tipData)
	local tipObj = {}
	tipObj.gameObject = GameObject.Instantiate(self.GuideTip)
	tipObj.transform = tipObj.gameObject.transform
	
	tipObj.transform:SetParent(self.GuideTipGroup.transform)
	tipObj.transform.localScale = Vector3(1, 1, 1)
	
	UtilsUI.GetContainerObject(tipObj.transform, tipObj)
	tipObj.data = tipData
	
	tipObj.gameObject:SetActive(true)
	return tipObj
end

function GuideImageTipPanel:OnChangeTag()
	local tipData = DataImageTips[self.tipIds[self.curTip]]
	self:TryShowArrow()
	self:TryShowCloseBtn(tipData.show_close_button, tipData.close_delay_time)
	
	self.startPos = self.GuideTipGroup.transform.localPosition
	self.endPos = Vector3((self.curTip - 1) * -addStep, self.startPos.y, 0)
	self.moveStep = 1
end

function GuideImageTipPanel:TryShowArrow()
	self.NextArrow:SetActive(self.curTip < self.tipAmount)
	self.BackArrow:SetActive(self.curTip > 1)
end

function GuideImageTipPanel:TryShowCloseBtn(show, delayTime)
	if self.isShowCloseBtn then return end
	if not self.CommonBack1 then return end
	if show then
		if delayTime == 0 then
			self.CommonBack1:SetActive(true)
			self.isShowCloseBtn = true
		else
			local callback = function()
				if self.showTimer then
					LuaTimerManager.Instance:RemoveTimer(self.showTimer)
					self.showTimer = nil
				end
				
				self.CommonBack1:SetActive(true)
				self.CommonBack1_canvas.alpha = 0
				self.isShowCloseBtn = true
			end
			if self.showTimer then
				LuaTimerManager.Instance:RemoveTimer(self.showTimer)
				self.showTimer = nil
			end
			self.showTimer = LuaTimerManager.Instance:AddTimer(1, delayTime, callback)
		end
	else
		self.CommonBack1:SetActive(false)
	end
end

function GuideImageTipPanel:OnNextTip()
	if self.curTip == self.tipAmount then return end
	self.curTip = self.curTip + 1
	self:OnChangeTag()
end

function GuideImageTipPanel:OnBackTip()
	if self.curTip == 1 then return end
	self.curTip = self.curTip - 1
	self:OnChangeTag()
end

function GuideImageTipPanel:HidePanel()
	if self.closeCallback then
		self.closeCallback()
	end
	
	Fight.Instance.entityManager:CallBehaviorFun("OnGuideImageTips", self.teachId, false)
	Fight.Instance.taskManager:CallBehaviorFun("OnGuideImageTips", self.teachId, false)
	PanelManager.Instance:ClosePanel(self)
end

function GuideImageTipPanel:OnClose()
	self.GuideImageTipPanel_Eixt:SetActive(true)
end

local ScreenFactor = math.max(Screen.width / 1280, Screen.height / 720)
function GuideImageTipPanel:CreateVideo(tipObj, videoName)
    local videoPath = "Prefabs/UI/Video/"..videoName
    local resList = {
        {path = videoPath, type = AssetType.Prefab},
    }   

    local callback = function()
    	tipObj.RawImage = tipObj.assetLoader:Pop(videoPath)
    	tipObj.RawImage.transform:SetParent(tipObj.VideoContent.transform)
    	tipObj.RawImage.transform:ResetAttr()
    	tipObj.RawImage_rimg = tipObj.RawImage:GetComponent(RawImage)
	    local rect = tipObj.RawImage_rimg.rectTransform.rect
	    local factor = math.min(ScreenFactor, 2)
	    tipObj.rtTemp = CustomUnityUtils.GetTextureTemporary(math.floor(rect.width * factor), math.floor(rect.height * factor))
	    tipObj.RawImage_rimg.texture = tipObj.rtTemp 
	    tipObj.vedioPlayer = tipObj.RawImage:GetComponent(CS.UnityEngine.Video.VideoPlayer)
	    tipObj.vedioPlayer.targetTexture = tipObj.rtTemp 
    end
    tipObj.assetLoader = AssetBatchLoader.New("CreateVideo"..videoName)
    tipObj.assetLoader:AddListener(callback)
    tipObj.assetLoader:LoadAll(resList)
end

