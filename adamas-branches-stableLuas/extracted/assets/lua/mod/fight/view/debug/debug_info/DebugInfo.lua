DebugInfo = BaseClass("DebugInfo",BaseView)

function DebugInfo:__init()
	self:SetAsset("Prefabs/UI/FightDebug/DebugInfo.prefab")
	self:SetParent(UIDefine.canvasRoot.transform)
end

function DebugInfo:__Show()
	if not self.timer then
		self.timer = LuaTimerManager.Instance:AddTimer(0, 0.2,self:ToFunc("Update"))
		self.frameStamp = 0
		self.timeStamp = 0
		self.frameUpdate = 0
		self.updateShowDeltaTime = 0
		self.fps = 0
	end
end

function DebugInfo:__Hide()
	self:RemoveTimer()
end

function DebugInfo:Update()
	local f = (Time.frameCount - self.frameStamp) / (Time.realtimeSinceStartup - self.timeStamp)
	self.fpsText.text = tostring(math.floor(f))
	self.timeStamp = Time.realtimeSinceStartup
	self.frameStamp = Time.frameCount
	
	local luaM = collectgarbage("count") / 1024
	self.luaMText.text = string.format("%.2f", luaM).." M"
end

function DebugInfo:__CacheObject()
	local canvas = self.gameObject:GetComponent(Canvas)
	if canvas ~= nil then
		canvas.pixelPerfect = false
		canvas.overrideSorting = true
	end
	self.fpsText = UtilsUI.GetText(self:Find("FPS/FPS"))
	self.csMText = UtilsUI.GetText(self:Find("CSInfo/CSMemory"))
	self.luaMText = UtilsUI.GetText(self:Find("LuaInfo/LuaMemory"))
	
end

function DebugInfo:RemoveTimer()
	if self.timer then
		LuaTimerManager.Instance:RemoveTimer(self.timer)
		self.timer = nil
	end
end

function DebugInfo:__delete()
	self:RemoveTimer()
end

function DebugInfo:__Create()
end

