DebugMainView = BaseClass("DebugMainView",BaseView)

local RowSize = 44
local ColSize = 135
local ColNum = 6
local MinRowSize = 45
local MaxRowNum = 3
local CharColor = Color(1, 1, 1, 1)

function DebugMainView:__init(model)
	self:SetAsset("Prefabs/UI/FightDebug/DebugMainView.prefab")
	self.model = model
	
	self.frameStamp = 0
	self.timeStamp = 0
	
	self.itemList = {}
	self.itemCachePool = {}
end

function DebugMainView:__delete()
	if self.timer then
		LuaTimerManager.Instance:RemoveTimer(self.timer)
		self.timer = nil
	end
	
	PanelManager.Instance:ClosePanel(DebugDetailPanel)
	EventMgr.Instance:RemoveListener(EventName.CloseAllUI, self:ToFunc("CloseAllUI"))
end

function DebugMainView:__Create()
	self.timer = LuaTimerManager.Instance:AddTimer(0, 0.2,self:ToFunc("Update"))
	self.timer = LuaTimerManager.Instance:AddTimer(0, 0.0333,self:ToFunc("UpdateKey"))
	self.ParamInput1_input = self.ParamInput1:GetComponent(TMP_InputField)
	self.ParamInput2_input = self.ParamInput2:GetComponent(TMP_InputField)
	self.ParamInput3_input = self.ParamInput3:GetComponent(TMP_InputField)
end

function DebugMainView:CloseAllUI()
	-- PV专用
	if DebugClientInvoke.Cache.closeUI == true then
		UtilsUI.SetActiveByScale(self.gameObject,false)
		return
	else
		UtilsUI.SetActiveByScale(self.gameObject,true)
	end
end

function DebugMainView:UpdateKey()
	if Input.GetKeyUp(KeyCode.F7) then
		self.OutFPS:SetActive(not self.OutFPS.activeSelf)
	end
end

function DebugMainView:Update()
	local f = (Time.frameCount - self.frameStamp) / (Time.realtimeSinceStartup - self.timeStamp)
	self.FPSText_txt.text = tostring(math.floor(f))
	self.OutFPSText_txt.text = tostring(math.floor(f))
	self.timeStamp = Time.realtimeSinceStartup
	self.frameStamp = Time.frameCount
	
end

function DebugMainView:__BindListener()
	self.DetailBtn_btn.onClick:AddListener(self:ToFunc("ShowDetailPanel"))
	self.DebugBtn_btn.onClick:AddListener(self:ToFunc("ShowDebug"))
	EventMgr.Instance:AddListener(EventName.CloseAllUI, self:ToFunc("CloseAllUI"))
end

function DebugMainView:__Show()
	UtilsUI.SetActive(self.Detail, false)
	UtilsUI.SetActive(self.Scroll, false)
	UtilsUI.SetActive(self.ParamConfig, false)
end

function DebugMainView:__Hide()
end

function DebugMainView:ShowDebug()
	local active = not self.Detail.activeSelf
	UtilsUI.SetActive(self.Detail, active)
	UtilsUI.SetActive(self.Scroll, active)
	
	if active then
		self:RefreshScroll()
	end
	
	--TODO:设备信息
end

function DebugMainView:ShowDetailPanel()
	PanelManager.Instance:OpenPanel(DebugDetailPanel, self.model)
end

function DebugMainView:RefreshScroll()
	self:CacheItem()
	local config = self.model:GetQuickConfig()
	
	local count = 0
	for tag, idList in pairs(config) do
		for _, v in pairs(idList) do
			self:AddItem(tag, v, DebugConfig.GetDataConfig(tag, v))
			count = count + 1
		end
	end
	
	local row = math.ceil(count / ColNum)
	local contentSize = math.max(row * RowSize, MinRowSize)
	
	row = math.min(MaxRowNum, row)
	self.Scroll_rect.sizeDelta = Vector2(ColNum * ColSize, row * RowSize)
	self.Content_rect.sizeDelta = Vector2(0, contentSize)
	self.ParamConfig_rect.anchoredPosition = Vector2(0, -(row * RowSize))
end

function DebugMainView:GetItem(id, config)
	local item = table.remove(self.itemCachePool)
	if not item then
		item = {}
		item.gameObject = GameObject.Instantiate(self.Item)
		UtilsUI.SetActive(item.gameObject, true)

		item.transform = item.gameObject.transform
		UtilsUI.GetContainerObject(item.transform, item)
	end

	item.id = id
	item.config = config
	item.transform:SetParent(self.Content.transform)
	item.transform:ResetAttr()

	return item
end

function DebugMainView:CacheItem()
	for i = 1, #self.itemList do
		local v = self.itemList[i]
		v.transform:SetParent(self.CachePool.transform)
		table.insert(self.itemCachePool, v)
	end

	TableUtils.ClearTable(self.itemList)
end

function DebugMainView:AddItem(tag, id, config)
	local item = self:GetItem(id, config)
	
	item.Desc_txt.text = config.id_desc
	
	local hasParams = config.param_num > 0
	
	UtilsUI.SetActive(item.Icon, hasParams)
	
	item.SelectBtn_btn.onClick:RemoveAllListeners()
	item.SelectBtn_btn.onClick:AddListener(function()
			if not hasParams then
				UtilsUI.SetActive(self.ParamConfig, false)
				local set = DebugConfig.CallFunc(tag, config.gm_func)
				item.Desc_txt.color = set and Color(0, 1, 0, 1) or CharColor
			else
				UtilsUI.SetActive(self.ParamConfig, not self.ParamConfig.activeSelf)
				UtilsUI.SetActive(self.ParamInput1, config.param_num >= 1)
				UtilsUI.SetActive(self.ParamInput2, config.param_num >= 2)
				UtilsUI.SetActive(self.ParamInput3, config.param_num >= 3)

				self.ParamInput1_input.text = config.param1
				self.ParamInput2_input.text = config.param2
				self.ParamInput3_input.text = config.param3
				
				self.ConfirmBtn_btn.onClick:RemoveAllListeners()
				self.ConfirmBtn_btn.onClick:AddListener(function()
						local param1 = self.ParamInput1_input.text
						local param2 = self.ParamInput2_input.text
						local param3 = self.ParamInput3_input.text
						local set = DebugConfig.CallFunc(tag, config.gm_func, param1, param2, param3)
						UtilsUI.SetActive(self.ParamConfig, false)
						item.Desc_txt.color = set and Color(0, 1, 0, 1) or CharColor
					end)
			end
		end)
	
	table.insert(self.itemList, item)
end