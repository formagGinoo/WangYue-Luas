GOAPPerform = BaseClass("GOAPPerform", BaseView)



function GOAPPerform.Activity(show)
	if DebugClientInvoke.Cache.GOAPPerform then
		if DebugClientInvoke.Cache.GOAPPerformActivity then
			DebugClientInvoke.Cache.GOAPPerform:Hide()
			DebugClientInvoke.Cache.GOAPPerformActivity = false
		else
			DebugClientInvoke.Cache.GOAPPerform:Show()
			DebugClientInvoke.Cache.GOAPPerformActivity = true
		end
	else
		DebugClientInvoke.Cache.GOAPPerform = GOAPPerform.New()
		DebugClientInvoke.Cache.GOAPPerform:Show()
		DebugClientInvoke.Cache.GOAPPerformActivity = true
	end
end	


function GOAPPerform.ActivityAttrOnly(show)
	GOAPPerform.AttrOnly = true
	if DebugClientInvoke.Cache.GOAPPerform then
		if DebugClientInvoke.Cache.GOAPPerformActivity then
			DebugClientInvoke.Cache.GOAPPerform:Hide()
			DebugClientInvoke.Cache.GOAPPerformActivity = false
		else
			DebugClientInvoke.Cache.GOAPPerform:Show()
			DebugClientInvoke.Cache.GOAPPerformActivity = true
		end
	else
		DebugClientInvoke.Cache.GOAPPerform = GOAPPerform.New()
		DebugClientInvoke.Cache.GOAPPerform:Show()
		DebugClientInvoke.Cache.GOAPPerformActivity = true
	end
end

function GOAPPerform:__init()
	GOAPPerform.Instance = self
	self:SetAsset("Prefabs/UI/GOAPPerform/GOAPPerform.prefab")
	if GOAPPerform.AttrOnly then
		self:SetParent(UIDefine.canvasRoot.transform)
	end
	--self:SetParent(UIDefine.canvasRoot.transform)
	--GameObject.DontDestroyOnLoad(self.gameObject)
	self.actions = {}
	for i = 1, 20 do
		self.actions[i] = "事件 "..i
	end
	self.actionItems = {}
	self.lines = {}
end

function GOAPPerform:__Show()
	GameObject.DontDestroyOnLoad(self.transform.gameObject)
	
	--self.rtTemp = CustomUnityUtils.GetTextureTemporary(856, 480)
	--self.GameViewText_rimg.texture = self.rtTemp
	--Camera.main.targetTexture = self.GameViewRT_rimg.texture
	Camera.main.rect = Rect(0.33, 0, 0.68, 0.67)
	ctx.UICamera.rect = Rect(0.33, 0, 0.68, 0.67)
	--local mainCamera = CameraManager.Instance.mainCamera
	--local cameraData = ctx.UICamera.gameObject:GetComponent(Rendering.Universal.UniversalAdditionalCameraData)
	--cameraData.renderType = 1
	ctx.UICamera.allowHDR = true
	
	--self:InitActions(self.actions)
	--LuaTimerManager.Instance:AddTimer(0, 2,self:ToFunc("AddEvent"))
	self.eventIndex = 0
	self.eventScrollView = self.WorldStateScrollView.gameObject:GetComponent(CS.UnityEngine.UI.ScrollRect)
	self.polygon = self.Polygon.gameObject:GetComponent(CS.UIPolygon)
	--self:SetStaticAttr({70,30,60,20,80,50,90,30,50,70})
	if GOAPPerform.AttrOnly then
		self.BG.gameObject:SetActive(false)
		self.LeftDown.gameObject:SetActive(false)
		self.RightUp.gameObject:SetActive(false)
		self.Camera.gameObject:SetActive(false)
		Camera.main.rect = Rect(0, 0, 1, 1)
		ctx.UICamera.rect = Rect(0, 0, 1, 1)
		ctx.UICamera.allowHDR = true
	else
		--Camera.main.rect = Rect(0.33, 0, 0.68, 0.67)
		--ctx.UICamera.rect = Rect(0.33, 0, 0.68, 0.67)
		--local mainCamera = CameraManager.Instance.mainCamera
		--local cameraData = ctx.UICamera.gameObject:GetComponent(Rendering.Universal.UniversalAdditionalCameraData)
		--cameraData.renderType = 1
		ctx.UICamera.allowHDR = true
		self.transform.position = Vector3(0,-20000,0)
		self.BGAttr.gameObject:SetActive(false)
		self.Camera.gameObject:SetActive(true)
		self.BG.gameObject:SetActive(true)
	end
end



function GOAPPerform:AddEvent(name)
	self.eventIndex = self.eventIndex + 1
	
	local name = name or "事件 "..self.eventIndex
	local item = self:PopUITmpObject("WorldStateItem",self.WorldStateScrollViewContent_rect)
	item.WorldStateName_txt.text = name
	item.objectTransform.localPosition = Vector3.zero
	LuaTimerManager.Instance:AddTimer(1, 0.01,function ()
			self.eventScrollView.verticalNormalizedPosition = 0
		end)
	
end

function GOAPPerform:SetStaticAttr(attrs)
	for i = 1, 10 do
		local x = attrs[i] * 0.8
		self["ScrollPoint"..i.."_rect"].localPosition = Vector3(x,0,0)
		self.polygon.arr[i-1] = attrs[i]
	end
	self.polygon.gameObject:SetActive(false)
	self.polygon.gameObject:SetActive(true)
end


function GOAPPerform:InitActions(actions,costs)
	self:PushAllUITmpObject("ActionItem",self.ActionItemCache_rect)
	for k, v in pairs(actions) do
		local item = self:PopUITmpObject("ActionItem",self.ActionScrollViewContent_rect)
		item.objectTransform.localPosition = Vector3.zero
		item.Name_txt.text = v
		item.Cost_txt.text = costs[k]
		self.actionItems[k] = item
	end
end

function GOAPPerform:SetSelectActions(title,actions)
	self.Title_txt.text = title
	for k, item in pairs(self.actionItems) do
		item.BGSelect.gameObject:SetActive(false)
		item.BGUnSelect.gameObject:SetActive(true)
	end
	for k, v in pairs(actions) do
		local item = self.actionItems[v]
		item.BGSelect.gameObject:SetActive(true)
		item.BGUnSelect.gameObject:SetActive(false)
	end
	for k, v in pairs(self.lines) do
		GameObject.Destroy(v)
	end
	LuaTimerManager.Instance:AddTimer(1, 0.01,function ()
			self:DrawLine(actions)
	end)
	
end

function GOAPPerform:DrawLine(actions)
	
	local count = #actions
	for k, v in pairs(actions) do
		local item = self.actionItems[v]
		local item2
		if k < count then
			item2 = self.actionItems[actions[k+1]]
			local position1 = item.objectTransform.position ---  Vector3(50,0,0)
			local position2 = item.objectTransform.position --+  Vector3(50,0,0)
			local position3 = item2.objectTransform.position ---  Vector3(50,0,0)
			local dis = Vector3.Distance(position2,position3)
			local line = GameObject.Instantiate(self.Line.gameObject)
			line.transform.parent = self.Lines.gameObject.transform
			local rect = line:GetComponent(RectTransform)
			local arrows = GameObject.Instantiate(self.Arrows.gameObject) 
			arrows.transform.parent = self.Lines.gameObject.transform
			rect.sizeDelta = Vector2(dis, 4)
			rect.position = (position2+position3)/2
			arrows:GetComponent(RectTransform).position = position3
			table.insert(self.lines,line.gameObject)
			table.insert(self.lines,arrows.gameObject)
			local angle = Vector2.SignedAngle(Vector2(position3.x,position3.y)-Vector2(position2.x,position2.y),Vector2.right)
			Log("angle "..angle)
			rect.rotation = Quaternion.Euler(0,0,180-angle)
			arrows:GetComponent(RectTransform).rotation = Quaternion.Euler(0,0,360-angle+30)
		end
	end
end

function GOAPPerform:__Hide()
	--self.rtTemp = CustomUnityUtils.GetTextureTemporary(856, 480)
	--self.GameViewText_rimg.texture = self.rtTemp
	--Camera.main.targetTexture = self.GameViewRT_rimg.texture
	Camera.main.rect = Rect(0, 0, 1, 1)
	ctx.UICamera.rect = Rect(0, 0, 1, 1)
end