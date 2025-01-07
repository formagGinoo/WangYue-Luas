CurtainPanel = BaseClass("CurtainPanel", BaseView)
local _tinsert = table.insert
local TipsCfgData = Config.DataTips.data_tips

function CurtainPanel:__init()
	self:SetAsset("Prefabs/UI/Common/Curtain.prefab")
	self:SetParent(UIDefine.canvasRoot.transform)
	
	self.lastTime = -1
	self.tipsLastTime = -1 
	self.tipsDurTimer = nil
	self.tipsList = {}--存放所有的tips
end

function CurtainPanel:__CacheObject()
	self.darkImageR = self.DarkImage_img.color.r
	self.darkImageG = self.DarkImage_img.color.g
	self.darkImageB = self.DarkImage_img.color.b
	self.darkImageA = self.DarkImage_img.color.a
	
	self.lightImageR = self.LightImage_img.color.r
	self.lightImageG = self.LightImage_img.color.g
	self.lightImageB = self.LightImage_img.color.b
	self.lightImageA = self.LightImage_img.color.a
	self.canvas = self:Find(nil, Canvas)
	self.canvas.sortingOrder = 999999
end

function CurtainPanel:__Show()
	self:ResetTipsCanvas()
	self.canShow = true
	if self.isIn then
		self:FadeIn(self.isDark,self.inTime)
	end

	if InputManager.Instance then
		InputManager.Instance:SetCanInputState(false)
	end
end

function CurtainPanel:UpdateTipsList(tipsId, tipsUniqueId)
	self.tipsId = tipsId
	self.tipsUniqueId = tipsUniqueId
	if not self.tipsId then
		return
	end
	--做解析
	self:AnalyTips()
end

function CurtainPanel:AnalyTips()
	if self.tipsList then
		TableUtils.ClearTable(self.tipsList)
	end
	local tipsConfig = TipsCfgData[self.tipsId]
	local content = tipsConfig.content
	local contentSplit = StringHelper.Split(content, ";")
	for i, str in pairs(contentSplit) do
		if str ~= "" then
			local strKey, strValue = str:match("<(%w+)%s*=%s*(%d+%.?%d*)>")
			local prefix = str:match("^(.-)<")
			_tinsert(self.tipsList, {text = prefix, time = tonumber(strValue) })
		end
	end	
end

function CurtainPanel:FadeInTips(inTime)
	if not next(self.tipsList) then 
		return
	end
	
	local tipData = self.tipsList[1]
	--先淡入 
	self.tipsText_txt.text = tipData.text
	self.tipsFadeInTime = inTime
	self.tipsDurTime = tipData.time
	self.tipsLastTime = 0
end

function CurtainPanel:FadeOutTips(outTime)
	--淡出移除tips
	table.remove(self.tipsList, 1)
	self.tipsFadeOutTime = outTime
	self.tipsLastTime = 0
end

function CurtainPanel:ExitCurtain(outTime)
	if not self.tipsId then
		return
	end
	--仅限于有tipsId的情况，需要在淡入完成后计时关闭黑幕
	
	local tipsConfig = TipsCfgData[self.tipsId]
	CurtainManager.Instance:CurtainTipsEnd(tipsConfig.time or 0, outTime)
end

function CurtainPanel:TipsRun()
	if self.tipsFadeInTime then
		self.tipsLastTime = self.tipsLastTime + Time.deltaTime
		if self.tipsLastTime < self.tipsFadeInTime then
			local alphaValue = self.tipsLastTime/self.tipsFadeInTime
			self.tipsNode_canvas.alpha = alphaValue
		else
			--淡入结束
			self.tipsNode_canvas.alpha = 1
			self.tipsFadeInTime = nil
			self:StopTipTimer()
			self.tipsDurTimer = LuaTimerManager.Instance:AddTimer(1, self.tipsDurTime, function ()
				self:FadeOutTips(0.3)
			end)
		end 
	end
	
	if self.tipsFadeOutTime then
		self.tipsLastTime = self.tipsLastTime + Time.deltaTime
		if self.tipsLastTime < self.tipsFadeOutTime then
			local alphaValue = 1 - (self.tipsLastTime/self.tipsFadeOutTime)
			self.tipsNode_canvas.alpha = alphaValue
		else
			--淡出结束
			self.tipsNode_canvas.alpha = 0
			self.tipsFadeOutTime = nil
			self:FadeInTips(0.3)
		end
	end
end

function CurtainPanel:Update()
	if not self.active then
		return
	end
	self:TipsRun()
	if self.lastTime < 0 then
		return
	end
	if self.isIn then
		self.lastTime = self.lastTime + Global.deltaTime
		if self.lastTime < self.inTime then
			if self.isDark then
				self.darkImageA = self.lastTime / self.inTime
				CustomUnityUtils.SetImageColor(self.DarkImage_img,self.darkImageR,self.darkImageG,self.darkImageB,self.darkImageA)
			else
				self.lightImageA = self.lastTime / self.inTime
				CustomUnityUtils.SetImageColor(self.LightImage_img,self.lightImageR,self.lightImageG,self.lightImageB,self.lightImageA)
			end
		else
			if self.isDark then
				CustomUnityUtils.SetImageColor(self.DarkImage_img,self.darkImageR,self.darkImageG,self.darkImageB,1)
			else
				CustomUnityUtils.SetImageColor(self.LightImage_img,self.lightImageR,self.lightImageG,self.lightImageB,1)
			end
			self.lastTime = -1
			self:FadeInTips(0.3)
			self:ExitCurtain(0.3)
		end
	else
		self.lastTime = self.lastTime + Global.deltaTime
		if self.lastTime < self.outTime then
			if self.isDark then
				self.darkImageA = 1 - self.lastTime / self.outTime
				CustomUnityUtils.SetImageColor(self.DarkImage_img,self.darkImageR,self.darkImageG,self.darkImageB,self.darkImageA)
			else
				self.lightImageA = 1 - self.lastTime / self.outTime
				CustomUnityUtils.SetImageColor(self.LightImage_img,self.lightImageR,self.lightImageG,self.lightImageB,self.lightImageA)
			end
		else
			if self.isDark then
				CustomUnityUtils.SetImageColor(self.DarkImage_img,self.darkImageR,self.darkImageG,self.darkImageB,0)
			else
				CustomUnityUtils.SetImageColor(self.LightImage_img,self.lightImageR,self.lightImageG,self.lightImageB,0)
			end
			self.lastTime = -1
			self:Hide()
		end
	end
end

function CurtainPanel:FadeIn(isDark,inTime)
	self.isDark = isDark
	self.inTime = inTime
	self.lastTime = 0
	self.isIn = true
	if not self.canShow then return end
	--Log("CurtainPanel:FadeIn "..inTime)
	self.Light.gameObject:SetActive(not isDark)
	self.Dark.gameObject:SetActive(isDark)
	if inTime == 0 then
		CustomUnityUtils.SetImageColor(self.DarkImage_img,self.darkImageR,self.darkImageG,self.darkImageB,1)
		CustomUnityUtils.SetImageColor(self.LightImage_img,self.lightImageR,self.lightImageG,self.lightImageB,1)
	end
end

function CurtainPanel:FadeOut(outTime)
	--Log("CurtainPanel:FadeOut "..outTime)
	self.isIn = false
	self.outTime = outTime
	self.lastTime = 0
	self:ResetTipsCanvas()
	if outTime == 0 and self.active then
		self.Light.gameObject:SetActive(false)
		self.Dark.gameObject:SetActive(false)
	end
end

function CurtainPanel:ResetTipsCanvas()
	if self.tipsNode then
		self.tipsNode_canvas.alpha = 0
	end
	if self.tipsText then
		self.tipsText_txt.text = ""
	end
end

function CurtainPanel:__Hide()
	if InputManager.Instance then
		InputManager.Instance:SetCanInputState(true)
	end
end

function CurtainPanel:StopTipTimer()
	if self.tipsDurTimer then
		LuaTimerManager.Instance:RemoveTimer(self.tipsDurTimer)
		self.tipsDurTimer = nil
	end
end

function CurtainPanel:__delete()
	self:StopTipTimer()
end