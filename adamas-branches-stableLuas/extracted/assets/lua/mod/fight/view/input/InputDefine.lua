InputDefine = InputDefine or {}
InputDefine.KeyEventPerformedFunc = 
{
	[FightEnum.KeyEventToAction[FightEnum.KeyEvent.MoveMode]] = function()
		if Fight.Instance and Fight.Instance.fightState == FightEnum.FightState.Fighting then
			local roleId = BehaviorFunctions.GetCtrlEntity()
			local mode = BehaviorFunctions.GetEntityMoveMode(roleId)
			if mode == FightEnum.EntityMoveMode.Walk then
				BehaviorFunctions.SetEntityMoveMode(roleId, FightEnum.EntityMoveMode.Run)
			elseif mode == FightEnum.EntityMoveMode.Run then
				BehaviorFunctions.SetEntityMoveMode(roleId, FightEnum.EntityMoveMode.Walk)
			end
		end
	end,
	[FightEnum.KeyEventToAction[FightEnum.KeyEvent.Interaction]] = function()
		EventMgr.Instance:Fire(EventName.WorldInteractKeyClick)
	end,
	[FightEnum.KeyEventToAction[FightEnum.KeyEvent.Map]] = function()
		local window = WindowManager.Instance:GetWindow("FightMainUIView")
        if not window then return end
        window:GetPanel(FightSystemPanel):OnClick_Map()
	end,
	[FightEnum.KeyEventToAction[FightEnum.KeyEvent.System]] = function()
		local window = WindowManager.Instance:GetWindow("FightMainUIView")
        if not window then return end
		local fightGrowNotice = window:GetPanel(FightGrowNotice)

		if fightGrowNotice and fightGrowNotice:IsHoldTips() then
			fightGrowNotice:OpenPhoneGrowNoticePanel()
			return
		end

        window:GetPanel(FightSystemPanel):OnClick_MainMenu()
	end,
	[FightEnum.KeyEventToAction[FightEnum.KeyEvent.Character]] = function()
		local window = WindowManager.Instance:GetWindow("FightMainUIView")
        if not window then return end
        window:GetPanel(FightSystemPanel):OnClick_OpenRole()
	end,
	[FightEnum.KeyEventToAction[FightEnum.KeyEvent.Team]] = function()
        local window = WindowManager.Instance:GetWindow("FightMainUIView")
        if not window then return end
        window:GetPanel(FightSystemPanel):OnClick_OpenFormation()
	end,
	[FightEnum.KeyEventToAction[FightEnum.KeyEvent.Backpack]] = function()
        local window = WindowManager.Instance:GetWindow("FightMainUIView")
        if not window then return end
        window:GetPanel(FightSystemPanel):OnClick_OpenBag()
	end,
	[FightEnum.KeyEventToAction[FightEnum.KeyEvent.Mission]] = function()
		local window = WindowManager.Instance:GetWindow("FightMainUIView")
        if not window then return end
        window:GetPanel(FightSystemPanel):OnClick_OpenTask()
	end,
	[FightEnum.KeyEventToAction[FightEnum.KeyEvent.Tutorial]] = function()
		local window = WindowManager.Instance:GetWindow("FightMainUIView")
        if not window then return end
        window:GetPanel(FightSystemPanel):OnClick_TeachBtn()
	end,
    [FightEnum.KeyEventToAction[FightEnum.KeyEvent.AutoPlay]] = function()

		Story.Instance:CallPanelFunc("OnClick_ChangePlayState")
	end,
	[FightEnum.KeyEventToAction[FightEnum.KeyEvent.Skip]] = function()
		Story.Instance:CallPanelFunc("OnClick_SkipDialog")
	end,
	[FightEnum.KeyEventToAction[FightEnum.KeyEvent.Next]] = function()
		Story.Instance:CallPanelFunc("OnClick_NextDialog")   
	end,
	[FightEnum.KeyEventToAction[FightEnum.KeyEvent.EscExplore]] = function()
		Story.Instance:CallPanelFunc("OnClick_SkipExplore")   
	end,
	[FightEnum.KeyEventToAction[FightEnum.KeyEvent.AimMode]] = function()
		InputManager.Instance.isAimMode = true
	end,

	-- 骇入部分
	[FightEnum.KeyEventToAction[FightEnum.KeyEvent.QuitHack]] = function()
		-- local player = Fight.Instance.playerManager:GetPlayer()
		-- local entity = player:GetCtrlEntityObject()
		-- -- 处于骇入模式 但没在骇入中的任何一个状态
		-- if entity.stateComponent:GetState() == FightEnum.EntityState.Hack and entity.stateComponent:GetHackingType() == nil then
		-- 	EventMgr.Instance:Fire(EventName.ExitHackingMode)
		-- end
		BehaviorFunctions.ExitHackingMode()
	end,

	[FightEnum.KeyEventToAction[FightEnum.KeyEvent.QuitBuild]] = function()
		local player = Fight.Instance.playerManager:GetPlayer()
        local entity = player:GetCtrlEntityObject()
		-- 处于骇入模式 但没在骇入中的任何一个状态
		if entity.stateComponent:GetState() == FightEnum.EntityState.Hack and entity.stateComponent:GetHackingType() == nil then
			EventMgr.Instance:Fire(EventName.ExitHackingMode)
		end
		
	end,
    [FightEnum.KeyEventToAction[FightEnum.KeyEvent.Activity]] = function()
        local window = WindowManager.Instance:GetWindow("FightMainUIView")
        if not window then return end
        window:GetPanel(FightSystemPanel):OnClick_OpenActivity()
    end,
    [FightEnum.KeyEventToAction[FightEnum.KeyEvent.Adventure]] = function()
        local window = WindowManager.Instance:GetWindow("FightMainUIView")
        if not window then return end
        window:GetPanel(FightSystemPanel):OnClick_OpenAdventure()
    end
}

InputDefine.ActionMap = 
{
	Player = "Player",
	UI = "UI",
	Drone = "Drone",
	Story = "Story",
	Hack = "Hack",
	Build = "Build",
	Photo = "Photo",
	PhotoTPS = "PhotoTPS",
	SelectMode = "SelectMode",
	Decoration = "Decoration"
}

InputDefine.AltShowCursorMap = 
{
	[InputDefine.ActionMap.Player] = true,
	[InputDefine.ActionMap.Photo] = true,
	[InputDefine.ActionMap.PhotoTPS] = true,
	[InputDefine.ActionMap.Drone] = true,
}