GmCtrl = BaseClass("GmCtrl",Controller)

function GmCtrl:__init()
	self.serverGmData = {}
	self.clientGmData = {}
	
	self.autoClone = false
	self.protocolDebug = false --是否打印网络回包

	self:InitClientGM()
end

function GmCtrl:InitClientGM()
	self:AddClientGm("跳过所有引导", "SkipAllGuide", {})
	self:AddClientGm("打开引导", "ForceGuide", {{"guideId", ""}, {"stage", 1}})
	self:AddClientGm("打印伤害日志", "ShowDamageLog",{})
	self:AddClientGm("激活/关闭键盘输入", "EnableKeyboard",{})
	self:AddClientGm("隐藏/显示特效", "HideEffect",{})
	self:AddClientGm("触发教学", "TriggerTeach",{{"teachId"}})
	self:AddClientGm("解锁所有教学", "UnlockAllTeach",{})
	self:AddClientGm("设置帧率30", "SetFarme_30",{})
	self:AddClientGm("设置帧率", "SetFarme",{{"farme", 60}})
	self:AddClientGm("是否显示鼠标", "DisPlayMouse",{})
	self:AddClientGm("是否自动复制号", "AutoClone",{})
	self:AddClientGm("开启好友系统", "OpenFriendSystem",{})
	self:AddClientGm("是否使用渲染帧", "ChangeUseRenderFrame",{})
	self:AddClientGm("是否开启NpcAiLOD", "ChangeNpcAiLOD",{})
	self:AddClientGm("请求肉鸽数据", "GMReqRogulelikeInfo",{})
	self:AddClientGm("发现肉鸽事件", "GMDiscoverRogulelikeEvent",{{"eventId", 1}})
	self:AddClientGm("完成肉鸽事件", "GMCompleteRogulelikeEvent",{{"areaId", ""}, {"eventId", 1}})
	self:AddClientGm("完成所有肉鸽事件", "GMCompleteAllRogulelikeEvent",{})
	self:AddClientGm("触发短信", "GMTriggerMessage",{{"messageId"}})
	self:AddClientGm("一键断网", "GMDisConnected",{})
	self:AddClientGm("一键联网", "GMConnected",{})
	self:AddClientGm("自定义创建测试账号", "GMCreateAdvancedAccount", {{"完成所有任务(并获得奖励)", 0}, {"开启所有系统", 0}, {"完成所有引导", 0}, {"完成所有图文教学(并领取奖励)", 0},})
	self:AddClientGm("设置天气当前时间", "GMSetDayTimeHourMinSec",{{"hour", ""}, {"min", 1}})
	self:AddClientGm("设置天气循环时间", "GMSetDayLoopTime",{{"hour", ""}, {"min", 1}})
	self:AddClientGm("开启/关闭音频事件Log", "GMSetSoundEventLog",{})
	self:AddClientGm("开启/关闭地图工具", "GMSetMapTool",{})
end

function GmCtrl:AddClientGm(desc, name, params)
	local data = {}
	data.gm_desc = desc
	data.gm_name = name
	data.args_desc_list = {}
	for i = 1, #params do
		local args = {}
		args.args_desc = params[i][1]
		args.args_default = params[i][2]
		table.insert(data.args_desc_list, args)
	end
	table.insert(self.clientGmData, data)
end

function GmCtrl:__delete()
	self.protocolDebug = false
end

function GmCtrl:__InitComplete()
end

function GmCtrl:OnGetGmData(data)
	self.serverGmData = data
	EventMgr.Instance:Fire(EventName.GetGMData, data)
end

function GmCtrl:RequestGmList()
	mod.GmFacade:SendMsg("gm_list")
end

function GmCtrl:ExecGmCommand(isClient, name, args)
	if isClient then
		if self[name] then
			self[name](self, args)
		end
	else
		mod.GmFacade:SendMsg("gm_exec", name, args)
	end
end

function GmCtrl:SkipAllGuide()
	local notFinishIdList = mod.GuideCtrl:GetNotFinishGuideIdList()
	for i = 1, #notFinishIdList do
		local data = Config.DataGuide.data_guide[notFinishIdList[i]]
		if data.finish_stage ~= 0 then
			Fight.Instance.clientFight.guideManager:SendFinishGuideId(data.id)
		end
	end
end

function GmCtrl:ForceGuide(args)
	local open = Fight.Instance.clientFight.guideManager:PlayGuideGroup(tonumber(args[1]), tonumber(args[2]), false, true)
	if open then
		GmManager.Instance:CloseGmPanel()
	end
end

function GmCtrl:ShowDamageLog()
	DebugConfig.ShowDamageLog = not DebugConfig.ShowDamageLog
	if DebugConfig.ShowDamageLog then
		Log("开启英雄伤害统计")
	else
		Log("关闭英雄伤害统计")
	end
end

function GmCtrl:EnableKeyboard()
	InputManager.EnableKeyboard = not InputManager.EnableKeyboard
end

function GmCtrl:HideEffect()
	ClientTransformComponent.HideEffect = not ClientTransformComponent.HideEffect
end

function GmCtrl:TriggerTeach(args)
	local teachId = tonumber(args[1])
	BehaviorFunctions.ShowGuideImageTips(teachId)
end

function GmCtrl:UnlockAllTeach()
	local DataTeachMain = Config.DataTeachMain.Find
	for _, cfg in pairs(DataTeachMain) do
		Fight.Instance.teachManager:AddTeachRecord(cfg.teach_id)
	end
end

function GmCtrl:SetFarme(args)
	Application.targetFrameRate = tonumber(args[1])
end

function GmCtrl:DisPlayMouse()
	if not InputManager.Instance then
		return
	end
	if InputManager.Instance.disPlayMouse ~= nil then
		InputManager.Instance.disPlayMouse = not InputManager.Instance.disPlayMouse
	else
		InputManager.Instance.disPlayMouse = false
	end
	if InputManager.Instance.disPlayMouse == true then
		Cursor.lockState = CursorLockMode.None
		Cursor.visible = true
	else
		Cursor.lockState = CursorLockMode.Locked
		Cursor.visible = false
	end
end

function GmCtrl:AutoClone()
	self.autoClone = not self.autoClone
	if self.autoClone then 
		MsgBoxManager.Instance:ShowTips(TI18N("开启自动复制号"), 1)
	else
		MsgBoxManager.Instance:ShowTips(TI18N("关闭自动复制号"), 1)
	end
end

function GmCtrl:OpenFriendSystem()
	mod.SystemFacade:SendMsg("sys_open_add", 1801)
	MsgBoxManager.Instance:ShowTips(TI18N("好友系统已开启"))
end

function GmCtrl:ChangeUseRenderFrame()
	DebugConfig.UseRenderFrame = not DebugConfig.UseRenderFrame
	if DebugConfig.UseRenderFrame then 
		MsgBoxManager.Instance:ShowTips(TI18N("开始使用渲染帧"), 1)
	else
		MsgBoxManager.Instance:ShowTips(TI18N("停止使用渲染帧"), 1)
	end
end

function GmCtrl:ChangeNpcAiLOD()
	DebugConfig.NpcAiLOD = not DebugConfig.NpcAiLOD
	if DebugConfig.NpcAiLOD then
		MsgBoxManager.Instance:ShowTips(TI18N("开始使用NpcAiLOD"), 1)
	else
		MsgBoxManager.Instance:ShowTips(TI18N("停止使用NpcAiLOD"), 1)
	end
end

function GmCtrl:GMReqRogulelikeInfo()
	Fight.Instance.rouguelikeManager:ReqRogueInfo()
end

function GmCtrl:GMDiscoverRogulelikeEvent(args)
	Fight.Instance.rouguelikeManager:RogueDiscoverEvent(tonumber(args[1]))
end

function GmCtrl:GMCompleteRogulelikeEvent(args)
	Fight.Instance.rouguelikeManager:GMCompleteEvent(tonumber(args[1]), tonumber(args[2]))
end

function GmCtrl:GMCompleteAllRogulelikeEvent()
	Fight.Instance.rouguelikeManager:GMCompleteAllEvent()
end


function GmCtrl:GMTriggerMessage(args)
	local messageId = tonumber(args[1])
	BehaviorFunctions.StartMessage(messageId)
end

function GmCtrl:GMDisConnected()
	Network.Instance:Disconnect(5)
	MsgBoxManager.Instance:ShowTips(TI18N("断开网络链接"))
end

function GmCtrl:GMConnected()
	mod.LoginCtrl:TryReconnect()
end

function GmCtrl:GMCreateAdvancedAccount(args)
	local isCompleteTask = tonumber(args[1])
	local isOpenAllSystem = tonumber(args[2])
	local isCompleteGuide = tonumber(args[3])
	local isCompleteTeach = tonumber(args[4])

	Fight.Instance.tipQueueManger.isDisplay = true
	if isCompleteGuide and isCompleteGuide ~= 0 then
		self:SkipAllGuide()
	end

	if isCompleteTask and isCompleteTask ~= 0 then
		for taskId, v in pairs(Config.DataTask.data_task) do
			self:ExecGmCommand(false, "task_accept", {tostring(taskId)})
			self:ExecGmCommand(false, "task_finish", {tostring(taskId)})
		end
	end

	if isOpenAllSystem and isOpenAllSystem ~= 0 then
		self:ExecGmCommand(false, "adventure_add_exp", {"99999999999999999999999999999"})
	end

	if isCompleteTeach and isCompleteTeach ~= 0 then
		local DataTeachMain = Config.DataTeachMain.Find
		for _, cfg in pairs(DataTeachMain) do
			Fight.Instance.teachManager:AddTeachRecord(cfg.teach_id)
			mod.TeachFacade:SendMsg("teach_reward", cfg.teach_id)
		end
	end
	Fight.Instance.tipQueueManger.isDisplay = false
end

function GmCtrl:GMSetDayTimeHourMinSec(args)
	local hour = tonumber(args[1])
	local min = tonumber(args[2])
	Fight.Instance.clientFight.dayTimeManager:SetDayTimeHourMinSec(hour, min, 0)
end

function GmCtrl:GMSetDayLoopTime(args)
	local hour = tonumber(args[1])
	local min = tonumber(args[2])
	Fight.Instance.clientFight.dayTimeManager:SetDayLoopTime(hour, min)
end

function GmCtrl:SetProtocolDebug(isOpen)
	self.protocolDebug = isOpen
end

function GmCtrl:GMSetSoundEventLog()
	local state = PlayerPrefs.GetInt("SoundEventLog", 0)
	if state == 0 then
		PlayerPrefs.SetInt("SoundEventLog", 1)
		MsgBoxManager.Instance:ShowTips(TI18N("音频事件打印已开启"), 1)
	else
		PlayerPrefs.SetInt("SoundEventLog", 0)
		MsgBoxManager.Instance:ShowTips(TI18N("音频事件打印已关闭"), 1)
	end
	SoundManager.Instance:SetEventLogGmState()
end

function GmCtrl:GMSetMapTool()
	DebugConfig.MapToolOpen = not DebugConfig.MapToolOpen
	if DebugConfig.MapToolOpen then 
		MsgBoxManager.Instance:ShowTips(TI18N("地图工具已开启"), 1)
	else
		MsgBoxManager.Instance:ShowTips(TI18N("地图工具已关闭"), 1)
	end
end