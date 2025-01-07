WorldFailWindow = BaseClass("WorldFailWindow", BaseWindow)

function WorldFailWindow:__init()
    self:SetAsset("Prefabs/UI/FightResultFail/WorldFailWindow.prefab")
    self:SetCacheMode(UIDefine.CacheMode.hide)

    self.isDup = false
    self.countDownTime = 10
    self.reviveCountDown = nil
    self.controlNodes = {}
end

function WorldFailWindow:__BindListener()
    self.ReviveBtn_btn.onClick:AddListener(self:ToFunc("OnClick_Revive"))
    self.ChallengeBtn_btn.onClick:AddListener(self:ToFunc("OnClick_Challenge"))
    self.ExitBtn_btn.onClick:AddListener(self:ToFunc("OnClick_Exit"))
end

function WorldFailWindow:__Show()
    self.isDup = self.args[1]
    self.CountDown:SetActive(false)
    self.btnLayOut:SetActive(true)
    UtilsUI.SetActive(self.ReviveBtn, true)
    UtilsUI.SetActive(self.ChallengeBtn, false)
    UtilsUI.SetActive(self.ExitBtn, false)
end

function WorldFailWindow:__ShowComplete()
    -- if not self.blurBack then
    --     self.blurBack = BlurBack.New(self, {passEvent = UIDefine.BlurBackCaptureType.Scene})
    -- end
    -- self:SetActive(false)
    -- self.blurBack:Show({self:ToFunc("BlurComplete")})
    self:BlurComplete()
end

function WorldFailWindow:BlurComplete()

    self:UpdateBtn()
    self:UpdateCountTimer()
    self:BindEffectControl()
    -- self:SetActive(true)
end

function WorldFailWindow:UpdateBtn()
    if not self.isDup then
        return 
    end
    self:UseDupDefualtBtn()
    
    --读取systemDuplicate， 没有则显示默认的复活按钮
    local systemDuplicateId = mod.DuplicateCtrl:GetSystemDuplicateId()
    local systemDuplicateCfg = TaskDuplicateConfig.GetSystemDuplicateConfigById(systemDuplicateId)
    if not systemDuplicateCfg then
        --没有系统副本id
        return
    end

    if systemDuplicateCfg.revive_type == FightEnum.SystemDuplicateReviveType.ReviveBtn then
        UtilsUI.SetActive(self.ExitBtn, true)
        UtilsUI.SetActive(self.ReviveBtn, false)
        UtilsUI.SetActive(self.ChallengeBtn, true)
    elseif systemDuplicateCfg.revive_type == FightEnum.SystemDuplicateReviveType.Exit then
        UtilsUI.SetActive(self.ExitBtn, true)
        UtilsUI.SetActive(self.ReviveBtn, false)
        UtilsUI.SetActive(self.ChallengeBtn, false)
    end
end

function WorldFailWindow:UseDupDefualtBtn()
    --默认使用退出按钮和重新挑战按钮
    UtilsUI.SetActive(self.ExitBtn, true)
    UtilsUI.SetActive(self.ReviveBtn, false)
    UtilsUI.SetActive(self.ChallengeBtn, true)
end

function WorldFailWindow:UpdateCountTimer()
    if self.isDup then
        self.CountDown_txt.text = string.format(TI18N("%d秒后自动放弃"), self.countDownTime)
        self.CountDown:SetActive(true)
        self.reviveCountDown = LuaTimerManager.Instance:AddTimer(self.countDownTime, 1, self:ToFunc("OnCountDown"))
    end
end

function WorldFailWindow:BindEffectControl()
    if not self.controlNodes or not next(self.controlNodes) then
        UtilsUI.GetContainerObject(self.ControlNode.transform, self.controlNodes)
    end

    self.controlNodes.CloseNode_hcb.HideAction:AddListener(self:ToFunc("CloseFunc"))
end

function WorldFailWindow:OnCountDown()
    self.countDownTime = self.countDownTime - 1
    self.CountDown_txt.text = string.format(TI18N("%d秒后自动放弃"), self.countDownTime)

    if self.countDownTime == 0 then
        -- self.controlNodes.CloseNode:SetActive(false)
        self:OnClick_Exit()
    end
end

function WorldFailWindow:Revive()
    if self.isDup then
        --处于副本内点击复活时,执行复活点复活的逻辑
        self:OnClick_Challenge()
    else
        local transFunc = function ()
            local transportPoint = mod.WorldCtrl:GetNearByTransportPoint()
            -- 临时处理 后面改成走任务配置
            local transportPos = mod.WorldCtrl:GetTransportPos()
            local mapId = Fight.Instance:GetFightMap()
            local mapConfig = mod.WorldMapCtrl:GetMapConfig(mapId)
            --如果没有就近点则读取默认复活点
            if not transportPoint and not transportPos then
                local pos = mod.WorldMapCtrl:GetMapPositionConfigByPositionId(mapConfig.position_id, mapConfig.default_revive_pos[2], mapConfig.default_revive_pos[1])
                mod.WorldMapFacade:SendMsg("map_enter", mapId, pos.x, pos.y, pos.z)
                return
            elseif transportPos then
                mod.WorldMapFacade:SendMsg("map_enter", mapId, transportPos.x, transportPos.y, transportPos.z)
                return
            end

            mod.WorldMapCtrl:SendMapTransport(mapConfig.position_id, transportPoint)
        end
        LuaTimerManager.Instance:AddTimer(1, 0.1, transFunc)
    end
end

function WorldFailWindow:OnClick_Revive()
    self:Revive()
    self.btnLayOut:SetActive(false)
    self.close:SetActive(true)
end

function WorldFailWindow:OnClick_Challenge()
    --重新挑战逻辑
    if self.isDup then
        mod.DuplicateCtrl:ReChallengeDuplicate()
    end
    self.btnLayOut:SetActive(false)
    WindowManager.Instance:CloseWindow(self)
end

function WorldFailWindow:OnClick_Exit()
    --退出副本逻辑
    if self.isDup then
        mod.DuplicateCtrl:QuitDuplicate()
    end
    self.btnLayOut:SetActive(false)
    WindowManager.Instance:CloseWindow(self)
end

function WorldFailWindow:CloseFunc()
    --self:Revive()

    -- TODO 测试逻辑
    --LoadPanelManager.Instance:FakeLoading(1)

    WindowManager.Instance:CloseWindow(self)
end

function WorldFailWindow:__Hide()
    self.isDup = false
    self.countDownTime = 10
    if self.reviveCountDown then
        LuaTimerManager.Instance:RemoveTimer(self.reviveCountDown)
        self.reviveCountDown = nil
    end

    self.controlNodes.CloseNode_hcb.HideAction:RemoveAllListeners()
end

function WorldFailWindow:__delete()
    if self.reviveCountDown then
        LuaTimerManager.Instance:RemoveTimer(self.reviveCountDown)
        self.reviveCountDown = nil
    end
end