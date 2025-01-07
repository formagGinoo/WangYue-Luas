JumpToConfig = JumpToConfig or {}
local DataConfig = Config.DataUiSystemJump.Find

local JumpType = {
    OpenWindow = 1,
    OpenPanel = 2,
	SpecialFunc = 3,
}

JumpToConfig.Functions = {
    [JumpType.OpenWindow] = function (config, args)
        WindowManager.Instance:OpenWindowByName(config.ui_name, args)
    end,
	[JumpType.OpenPanel] = function (config, args)
		PanelManager.Instance:OpenPanelByName(config.ui_name, args)
	end,
	["RoleMainWindow"] = function(config, args)
		local roleId = args.roleId or mod.RoleCtrl:GetCurUseRole()
		RoleMainWindow.OpenWindow(roleId, args)
	end,
	["AdvMainWindow"] = function(config, args)
		args.type = args._jump and tonumber(args._jump[1])
		
		local window = WindowManager.Instance:GetWindow("AdvMainWindowV2")
		if window then
			window:SelectType(args.type)
		else
			WindowManager.Instance:OpenWindow(AdvMainWindowV2, args)
		end
	end,
	["BagWindow"] = function(config, args)
		local window = WindowManager.Instance:GetWindow("BagWindow")
		WindowManager.Instance:OpenWindow(BagWindow, args)
	end,

	["WorldMapWindow"] = function(config, args)
		local ecoId = args._jump and tonumber(args._jump[1])
		local mark = mod.WorldMapCtrl:GetEcosystemMark(ecoId)
		local markInsId = mark and mark.instanceId
		WindowManager.Instance:OpenWindow(WorldMapWindow, { mark = markInsId })
	end,
	["ActivityMainWindow"] = function(config, args)
		local window = WindowManager.Instance:GetWindow("ActivityMainWindow")
		WindowManager.Instance:OpenWindow(ActivityMainWindow, args)
	end,
	["AssetPurchaseMainWindow"] = function(config, args)
		local teach = function()
			local id = tonumber(args._jump[3])
			BehaviorFunctions.ShowGuideImageTips(id)
		end
		if args._jump[1] == " " or args._jump[2] == " " then
			teach()
			return 
		end
		
		local isShowAsset = mod.AssetPurchaseCtrl:CheckDeviceInAsset(tonumber(args._jump[1]), tonumber(args._jump[2]))
		if isShowAsset then
			if args.cb then
				args.cb()
			end
			mod.AssetPurchaseCtrl.JumpToAssetInfo(args._jump[1])
		else
			teach()
		end
	end,
}

--args表示panel初始化的数据
function JumpToConfig.DoJump(jumpId, extraArgs)
    local config = DataConfig[jumpId]
	if not config then
		return
	end
	
	if config.system_id ~= 0 and not Fight.Instance.conditionManager:CheckSystemOpen(config.system_id) then
		MsgBoxManager.Instance:ShowTips(TI18N("系统未开启"))
		return
	end
	
	local func
	local arg = {}
	if config.type == JumpType.OpenWindow then
		func = JumpToConfig.Functions[JumpType.OpenWindow]
	elseif config.type == JumpType.OpenPanel then
		func = JumpToConfig.Functions[JumpType.OpenPanel]
	elseif config.type == JumpType.SpecialFunc then
		func = JumpToConfig.Functions[config.ui_name]
	end
	
	for i = 1, 3 do
		if config["arg"..i] and config["arg"..i] ~= "" then
			table.insert(arg, config["arg"..i])
		end
	end
	
	local args = {}
	if next(arg) then
		args._jump = arg
	end
		
	if extraArgs then
		if type(extraArgs) == "table" then
			for k, v in pairs(extraArgs) do
				args[k] = v
			end
		else
			table.insert(args, extraArgs)
		end
	end
	
	if func then
		func(config, args)
	end
end

function JumpToConfig.GetTitle(jumpId)
	local config = DataConfig[jumpId]
	if config then
		local title = config.title1
		if config.title2 ~= "" then
			title = title..config.title2
		end
		
		return title
	end
	return ""
end

function JumpToConfig.HasJumpEvent(jumpId)
	local config = DataConfig[jumpId]
	if config then
		return config.ui_name ~= ""
	end
	
	return false
end