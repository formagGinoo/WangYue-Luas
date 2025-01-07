DebugServerInfo = BaseClass("DebugServerInfo", BaseView)

function DebugServerInfo:__init()
    self:SetAsset("Prefabs/UI/FightDebug/DebugServerInfo.prefab")
	self:SetParent(UIDefine.canvasRoot.transform)

end

function DebugServerInfo:__Show()
	self:ShowInfo()
	if not self.timer then
		self.timer = LuaTimerManager.Instance:AddTimer(0, 0.01,self:ToFunc("Update"))
	end
end

-- function DebugServerInfo:__CacheObject()
--     self:SetCacheMode(UIDefine.CacheMode.hide)
-- end

function DebugServerInfo:__ShowComplete()

end

function DebugServerInfo:__BindListener()

end

function DebugServerInfo:ShowInfo()
	self.AcountName_txt.text = "账号:" .. mod.LoginProxy.account
	self.ServerName_txt.text = "服务器:" .. mod.LoginProxy.targetServer.name
	self:SetVertion()
	
	self:SetPing()
	self:SetServerTime()
end

function DebugServerInfo:Update()
	self:SetPing()
	self:SetServerTime()
end

function DebugServerInfo:SetVertion()
	local localResPath = Application.persistentDataPath .. "/res/_svn_version.txt"
	local file = io.open(localResPath, "r")
	local versionDesc = ""
	local apkVersion = tonumber(ctx.ApkVersion)
	if file then
		local content = file:read("*a")
		file:close()
		local versionMap = StringHelper.Split(content, "#")
		local resVersion = versionMap[1] or ""
		local luaVersion = versionMap[2] or ""
		local configVersion = versionMap[3] or ""
		versionDesc = resVersion .. "_" .. luaVersion .. "_" .. configVersion
	end

	apkVersion = string.format("%.1f", apkVersion / 10)
	apkVersion = apkVersion.."_"..versionDesc
	self.ResVersion_txt.text = TI18N("版本号:") .. apkVersion
end
function DebugServerInfo:SetPing()
	self.Ping_txt.text = "Ping:" .. mod.LoginCtrl:GetPing()
end

function DebugServerInfo:SetServerTime()
	local serverTime = TimeUtils.GetCurTimestamp()
	local time = os.date("%Y-%m-%d %H:%M:%S", serverTime)
	self.ServerTime_txt.text = string.format("服务器时间:%s",time)
end