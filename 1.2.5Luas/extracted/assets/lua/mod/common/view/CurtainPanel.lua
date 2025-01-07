CurtainPanel = BaseClass("CurtainPanel", BaseView)

function CurtainPanel:__init()
	self:SetAsset("Prefabs/UI/Common/Curtain.prefab")
	self:SetParent(UIDefine.canvasRoot.transform)
	
	self.lastTime = -1
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
	self.canvas.sortingOrder = 99
	self.timer = LuaTimerManager.Instance:AddTimer(0, 1/60,self:ToFunc("Update"))
end

function CurtainPanel:__Show()
	self.canShow = true
	if self.isIn then
		self:FadeIn(self.isDark,self.inTime)
	end
end

function CurtainPanel:Update()
	if self.lastTime < 0 then
		return
	end
	if self.isIn then
		self.lastTime = self.lastTime + Time.deltaTime
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
		end
	else
		self.lastTime = self.lastTime + Time.deltaTime
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
end

function CurtainPanel:__Hide()
	
end

function CurtainPanel:__delete()
	if self.timer then
		LuaTimerManager.Instance:RemoveTimer(self.timer)
		self.timer = nil
	end
end