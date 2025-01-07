GmCtrl = BaseClass("GmCtrl",Controller)

function GmCtrl:__init()
	self.serverGmData = {}
	self.clientGmData = {}
	
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
	local value = PlayerPrefs.GetInt("GmCtrl_ShowDamageLog")
	if value ~= 0 then
		PlayerPrefs.SetInt("GmCtrl_ShowDamageLog", 0)
		Log("关闭英雄伤害统计")
	else
		PlayerPrefs.SetInt("GmCtrl_ShowDamageLog", 1)
		Log("开启英雄伤害统计")
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

function GmCtrl:SetFarme_30()
	Application.targetFrameRate = 30
end