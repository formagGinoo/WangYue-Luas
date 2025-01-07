-- ----------------------------------------------------------
-- UI - 游戏登录
-- ----------------------------------------------------------
LoginWindow = BaseClass("LoginWindow",BaseWindow)
local DataLoading = Config.DataLoading.Find

function LoginWindow:__init()
	local defaultSvr = 1
	local gameContext = GameContext:GetInstance()
	if gameContext and gameContext.DefaultSvr then
		defaultSvr = tonumber(gameContext.DefaultSvr)
	end
	self.defaultSvr = defaultSvr

    self:SetAsset("Prefabs/UI/Login/LoginWindow.prefab")
    self:AddAsset(AssetConfig.loading_page_bg,AssetType.Prefab)
    self:AddAsset(AssetConfig.loading_logo,AssetType.Prefab)
    self:AddAsset(AssetConfig.login_spine,AssetType.Prefab)

	self.bgPath = string.format(AssetConfig.login_bg, ctx.RondomBGIndex)
	self:AddAsset(self.bgPath, AssetType.Object)
end

function LoginWindow:__delete()
	EventMgr.Instance:RemoveListener(EventName.LoginFail, self:ToFunc("LoginFail"))
end

function LoginWindow:__CacheObject()
    self.inputField = self:Find("InputCon/InputField", TMP_InputField)
    self.zoneCon = self:Find("ZoneCon").gameObject
	self.txtCurZoneName = UtilsUI.GetText(self:Find("TxtCurZoneName", nil, self.zoneCon.transform))
    self.btnEnterGame = self:Find("BtnEnterGame",Button)
    self.tipsTxt = UtilsUI.GetText(self:Find("Tips"))
    self.serverPanel = self.transform:Find("ServerPanel").gameObject
	self.btnServerTmp = self.transform:Find("BtnServerTmp")
	self.btnZoneCon = self:Find("ZoneCon",Button)
end

function LoginWindow:__BindListener()
    self.inputField.onEndEdit:AddListener(self:ToFunc("OnEndEdit"))
    self.btnEnterGame.onClick:AddListener(self:ToFunc("on_submit"))
    self.btnZoneCon.onClick:AddListener(self:ToFunc("OnOpenServerPanel"))

	self.Age_btn.onClick:AddListener(function ()
		PanelManager.Instance:OpenPanel(AgeTipPanel)
	end)

	self.Notice_btn.onClick:AddListener(function ()
		mod.AnnouncementCtrl:OpenAnnouncementWindow()
	end)

	EventMgr.Instance:AddListener(EventName.LoginFail, self:ToFunc("LoginFail"))
end

function LoginWindow:__Create()
    self.inputField.textComponent = UtilsUI.GetText(self:Find("InputCon/InputField/Text"))
end

function LoginWindow:__Show()
	local project_name = self.transform:Find("ImgProjectName")
	local ImgBg = self.transform:Find("ImgBg")
	local SpineBg = self.transform:Find("SpineBg")
	local logoGameObject = self:GetObject(AssetConfig.loading_logo)
	local bgGameObject = self:GetObject(AssetConfig.loading_page_bg)
	local spineGameObject = self:GetObject(AssetConfig.login_spine)
	

	UtilsUI.AddBigbg(project_name, logoGameObject)
	UtilsUI.AddBigbg(ImgBg, bgGameObject)
	spineGameObject.transform.parent = SpineBg

	self.selectServer = LoginDefine.ServerListConfig[self.defaultSvr]
	self:UpdateInfo()

	self.bgGameObject = bgGameObject
	self:SetLoginBgRes()
	ctx.LoadingPage:Hide()

	self:SetLoginBgm()
end

function LoginWindow:SetLoginBgm()
	BgmManager.Instance:InitBgmState()
	BgmManager.Instance:SetBgmState("ActiveBGM", "TRUE")
	BgmManager.Instance:SetBgmState("BgmType", "System")
	BgmManager.Instance:SetBgmState("PlayerLife", "Alive")
	BgmManager.Instance:SetBgmState("GamePlayType", "Login")
	BgmManager.Instance:SetBgmState("TimeState", "default")
	SoundManager.Instance:PlayBgmSound("Bgm_Logic")
end

-- 这里是c#的请求ok了才会调用
function LoginWindow:RecvCallServerList()
	local ServerList = self.transform:GetComponent(ServerListDownLoad)
	local count = ServerList:GetServerCount()
	for i = 1, count do
		local name, host, port = ServerList:GetServerParamByIndex(i - 1)
        local serverConfig = { name = name, host = host, port = port }
        table.insert(LoginDefine.ServerListConfig, serverConfig)
	end

	local lastServerIdx = tonumber(self:GetPlayerPrefs("last_server_idx"))
	if lastServerIdx and lastServerIdx ~= 0 then
		self.defaultSvr = lastServerIdx
	end
	self.lastSelectServerId = lastServerIdx
	self.selectServer = LoginDefine.ServerListConfig[self.defaultSvr]
	self:UpdateInfo()
end

function LoginWindow:UpdateInfo()
	if not self.selectServer then return end

    self.txtCurZoneName.text = TI18N(self.selectServer.name)

    self.tipsTxt.text = TI18N("抵制不良游戏，拒绝盗版游戏。注意自我保护，谨防受骗上当。适度游戏益脑，沉迷游戏伤身。合理安排时间，享受健康生活。")

    self.lastAccount = self:GetPlayerPrefs("last_account")
	if self.lastAccount ~= "" then
		self.inputField.text = self.lastAccount
		self.hasInputSelfName = true
	else
		self.inputField.text = TI18N("请输入帐号")
		self.hasInputSelfName = false
	end

    local versionTxt = UtilsUI.GetText(self:Find("VerionText"))

	-- TODO 暂时展示版本信息
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
	--FIXME: 这里游戏内文本框显示不全
	versionTxt.text = TI18N("版本号:") .. apkVersion
end

function LoginWindow:OnEndEdit(temp)
	if temp == "" then
		self.inputField.text = TI18N("请输入帐号")
		-- self.inputField.textComponent.color = Color(199/255,249/255,1)
		self.hasInputSelfName = false
	else
		self.hasInputSelfName = true
	end
end

function LoginWindow:SetAccountByCookie()
	local lastAccount = self:GetPlayerPrefs("last_account")
	if lastAccount ~= "" and self.inputField ~= nil then
		self.inputField.text = lastAccount
	end
end

--点击登录按钮
function LoginWindow:on_submit()
	if not self.hasInputSelfName then
		LogError("请输入帐号")
		MsgBoxManager.Instance:ShowTips(TI18N("请输入帐号"))
		return
	end

	local account = string.gsub(self.inputField.text, "^[%s\n\r\t]*(.-)[%s\n\r\t]*$", "%1")
	account = string.gsub(account," ","")
	self:SavePlayerPrefs("last_account", account)
	self:SavePlayerPrefs("last_server_idx", self.lastSelectServerId)
	self.account = account

    self.btnEnterGame:SetNormalColor(Color(0.78,0.78, 0.78, 0.78))

	if DebugConfig.SkipQueryEntry  or ctx.Editor then
		mod.LoginCtrl:DoLogin(self.account,self.selectServer)
		return
	end
	local ServerList = self.transform:GetComponent(ServerListDownLoad)
	ServerList:StartQueryEntry(LoginDefine.QueryEntryURL, LoginDefine.QueryEntryKey)
	self.queryEntryTimer = LuaTimerManager.Instance:AddTimer(1, 5, function()
		self.queryEntryTimer = nil
		mod.LoginCtrl:DoLogin(self.account,self.selectServer)
	end)
end

-- 清除账号
function LoginWindow:clear_account_input()
	if self.inputField then
		self.inputField.text = ""
	end
	self:SavePlayerPrefs("last_account", "")
end

function LoginWindow:SavePlayerPrefs(key, val)
	PlayerPrefs.SetString(key, tostring(val))
	PlayerPrefs.Save()
end

function LoginWindow:GetPlayerPrefs(key)
	return PlayerPrefs.GetString(key)
end

function LoginWindow:OnOpenServerPanel()
	-- 暂时先开启服务器可选
	-- if not IS_DEBUG then
	-- 	return
	-- end

	-- if not ctx.Editor then -- 仅编辑器下可选服务器
	-- 	return
	-- end

	-- self.serverPanel:SetActive(true)

	-- if not self.bInitServerPanel then
	-- 	local parent = self.transform:Find("ServerPanel/ServerList/Content")
	-- 	local serverCount = 0

	-- 	for idx, cfg in ipairs(LoginDefine.ServerListConfig) do
	--         local item = GameObject.Instantiate(self.btnServerTmp)
	--         local trans = item.transform
	--         UtilsUI.GetText(trans:Find("Text")).text = cfg.name
	--         item.gameObject:SetActive(true)
	--         trans:SetParent(parent)
	--         trans.localScale = Vector3.one

	--         local onSelect = function()
	--         	self:SelectServer(cfg, idx)
	--         end
	--         item:GetComponent(Button).onClick:AddListener(onSelect)
	-- 		serverCount = serverCount + 1
	-- 	end

    --     UnityUtils.SetSizeDelata(parent.transform, parent.rect.width,(self.btnServerTmp.rect.height + 10) * serverCount)
	-- 	self.bInitServerPanel = true
	-- end

	self:OpenPanel(ServerSelectPanel, {selectIndex = self.lastSelectServerId})
end

function LoginWindow:SelectServer(serverInfo, idx)
	self.txtCurZoneName.text = TI18N(serverInfo.name)
	self.selectServer = serverInfo
	self.serverPanel:SetActive(false)

	self.lastSelectServerId = idx
end

function LoginWindow:LoginFail()
	self.btnEnterGame:SetNormalColor(Color(1, 1, 1, 1))
end

function LoginWindow:SetLoginBgRes()
	local bgTrans = self.bgGameObject.transform:Find("container/LoadingPageBg")
	local image = bgTrans:GetComponent(Image)
	local bg = self:GetObject(self.bgPath)
	local UseLocalRes = AssetBatchLoader.UseLocalRes and ctx.Editor
	local autoReleaser
	if not UseLocalRes then
		autoReleaser = self.gameObject:GetComponent(IconAutoReleaser)
		if autoReleaser == nil then
			autoReleaser = self.gameObject:AddComponent(IconAutoReleaser)
		end
		if autoReleaser.path ~= nil and autoReleaser.path ~= "" and not UtilsBase.IsNull(autoReleaser.path) then
			AssetMgrProxy.Instance:DecreaseReferenceCount(autoReleaser.path)
			image.sprite = nil
		end
		autoReleaser.path = self.bgPath
		AssetMgrProxy.Instance:IncreaseReferenceCount(self.bgPath)
		--local s = Sprite.Create(bg, Rect(0, 0, bg.width, bg.height), Vector2.zero)
		--image.sprite = s
		image.sprite = bg
		image.color = Color.white

	else
		local t2d = bg
		local sprite = CS.EditorAssetLoad.CastToSprite(t2d)
		image.sprite = sprite
		image.color = Color.white
	end
end

function LoginWindow:RecvCallQueryEntry(data)
	if self.queryEntryTimer then
		LuaTimerManager.Instance:RemoveTimer(self.queryEntryTimer)
		self.queryEntryTimer = nil
	end

	if data.open_status == 1 then
		local msg = MsgBoxManager.Instance:ShowTextMsgBox(data.content)
		msg:HideCloseBtn()
	else
		mod.LoginCtrl:DoLogin(self.account,self.selectServer)
	end
end