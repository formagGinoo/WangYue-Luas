BargainCtrl = BaseClass("BargainCtrl", Controller)

local _tinsert = table.insert

function BargainCtrl:__init()
    self.bargainModel = BargainModel.New()

    self.bargainMap = {}
end

function BargainCtrl:__delete()
    self.bargainModel:DeleteMe()
end

function BargainCtrl:UpdateBargainList(list)
    for k, v in ipairs(list) do
        if self.bargainMap[v.negotiate_id] then
            self.bargainMap[v.negotiate_id].count = v.bargain_count
            self.bargainMap[v.negotiate_id].lastScore = v.latest_point
        else
            self.bargainMap = {count = v.bargain_count, lastScore = v.latest_point}
        end
    end
end

function BargainCtrl:GetBargainCount(negotiateId)
    local bargain = self.bargainMap[negotiateId]
    if bargain then
        return bargain.count
    end
    self.bargainMap[negotiateId] = {count = 0}
    return 0
end

function BargainCtrl:EnterBargainByNpcInstance(type, relateId, npcInstanceId)
    local npcId = BehaviorFunctions.GetEntityEcoId(npcInstanceId)
    if npcId then
        self:EnterBargainNpc(type, relateId, npcId, npcInstanceId)
    else
        LogError(npcInstanceId .. "没有EcoId")
    end
end

function BargainCtrl:EnterBargainNpc(type, relateId, npcId, npcInstanceId)
    self.npcInstanceId = npcInstanceId
    local curEntityId = BehaviorFunctions.GetCtrlEntity()
    local playerEntity = BehaviorFunctions.GetEntity(curEntityId)
    if playerEntity then
        self:EnterBargainPlayerNpc(type, relateId, playerEntity.masterId, npcId)
    else
        self:EnterBargainPlayerNpc(type, relateId, nil, npcId)
    end
end

function BargainCtrl:EnterBargainPlayerNpc(type, relateId, playerId, npcId)
    local negotiateId = nil
    local bargainInfo = nil
    if type == BargainEnum.Type.Shop then
        negotiateId = BargainConfig.GetNegotiateIdByShopId(relateId)
        if not negotiateId then
            LogError("没有从商店表中获取到交涉Id")
            return
        end
        bargainInfo = BargainConfig.GetBargainInfo(negotiateId, self:GetBargainCount(negotiateId))
        if bargainInfo.bargain_type ~= BargainEnum.Type.Shop then
            LogError("将要从对话入口打开讨价玩法, 但配置表中的bargain_type并未被定义为商店, negotiateId:%d", negotiateId)
            return
        end
    elseif type == BargainEnum.Type.Trade then
        negotiateId = mod.TradeCtrl:GetCurNegotiateIdByStoreId(relateId)
        bargainInfo = BargainConfig.GetBargainInfo(negotiateId, self:GetBargainCount(negotiateId))
        if bargainInfo.bargain_type ~= BargainEnum.Type.Trade then
            LogError("将要从回购入口打开讨价玩法, 但配置表中的bargain_type并未被定义为回购, negotiateId:%d", negotiateId)
            return
        end
    elseif type == BargainEnum.Type.Bargain then
        negotiateId = relateId -- 是交涉id
        bargainInfo = BargainConfig.GetBargainInfo(negotiateId, self:GetBargainCount(negotiateId))
        relateId = 0
        if bargainInfo.bargain_type ~= BargainEnum.Type.Bargain then
            LogError("将要从对话入口打开讨价玩法, 但配置表中的bargain_type并未被定义为交涉, negotiateId:%d", negotiateId)
            return
        end
    end

    self.curType = type
    self.curRelateId = relateId or 0
    self.curPlayerId = playerId
    self.curNpcId = npcId
    self.curNegotiateId = negotiateId
    self.curScore = 0
    self:Enter(bargainInfo, playerId, npcId)
end

function BargainCtrl:Enter(bargainInfo, playerId, npcId)
    self.bgmType = BehaviorFunctions.GetBgmState("BgmType")
    self.gamePlayType = BehaviorFunctions.GetBgmState("GamePlayType")
    BehaviorFunctions.SetBgmState("BgmType", "System")
    BehaviorFunctions.SetBgmState("GamePlayType", "Bargain")
    self.bargainModel:SetBargain(bargainInfo)

    Fight.Instance.modelViewMgr:LoadView(ModelViewConfig.ViewType.Bargain, function ()
        Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.Bargain):LoadScene(ModelViewConfig.Scene.Bargain, function ()
            local view = Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.Bargain)
            local playerUiModel = BargainConfig.GetUiModelByPlayerId(self.curPlayerId)

            -- 加载玩家
            if playerUiModel then
                view:LoadModel("PlayerRoot", self.curPlayerId, function ()
                    view:ShowModelRoot("PlayerRoot", true)

                    local playerModel = view:GetModel("PlayerRoot")
                    local dynamicBonesComp = playerModel:GetComponent(CS.DynamicBones)
                    if dynamicBonesComp then
                        dynamicBonesComp.enabled = false
                    end

                    CustomUnityUtils.SetModelActive(playerModel, true)

                    -- LoadAnimation
                    local tf = view:GetTargetTransform("PlayerRoot"):GetChild(1)
                    local animator = tf:GetComponentInChildren(Animator)
                    local clips = animator.runtimeAnimatorController.animationClips

                    self.curPlayerModelClipMap = {}
                    for i = 0, clips.Length - 1, 1 do
                        local v = clips[i]
                        self.curPlayerModelClipMap[v.name] = {length = v.length}
                    end

                    if self.curNpcModelClipMap ~= nil then
                        WindowManager.Instance:OpenWindow(BargainMainWindowV2, 
                        {bargainInfo = bargainInfo, bargainModel = self.bargainModel, playerId = playerId, npcId = npcId, modelView = view})            
                    end

                end, playerUiModel)
            else
                self.curPlayerModelClipMap = false
                if self.curNpcModelClipMap ~= nil then
                    WindowManager.Instance:OpenWindow(BargainMainWindowV2, 
                    {bargainInfo = bargainInfo, bargainModel = self.bargainModel, playerId = playerId, npcId = npcId, modelView = view})            
                end
            end

            -- 加载Npc
            if bargainInfo.npc_ui_model then
                view:LoadModel("NpcRoot", npcId, function ()
                    view:ShowModelRoot("NpcRoot", true)

                    local npcModel = view:GetModel("NpcRoot")
                    local dynamicBonesComp = npcModel:GetComponent(CS.DynamicBones)
                    if dynamicBonesComp then
                        dynamicBonesComp.enabled = false
                    end

                    CustomUnityUtils.SetModelActive(npcModel, true)

                    -- LoadAnimation
                    local tf = view:GetTargetTransform("NpcRoot"):GetChild(1)
                    local animator = tf:GetComponentInChildren(Animator)
                    local clips = animator.runtimeAnimatorController.animationClips

                    self.curNpcModelClipMap = {}
                    for i = 0, clips.Length - 1, 1 do
                        local v = clips[i]
                        self.curNpcModelClipMap[v.name] = {length = v.length}
                    end

                    if self.curPlayerModelClipMap ~= nil then
                        WindowManager.Instance:OpenWindow(BargainMainWindowV2, 
                        {bargainInfo = bargainInfo, bargainModel = self.bargainModel, playerId = playerId, npcId = npcId, modelView = view})            
                    end

                end, bargainInfo.npc_ui_model)
            else
                self.curNpcModelClipMap = false
                if self.curPlayerModelClipMap ~= nil then
                    WindowManager.Instance:OpenWindow(BargainMainWindowV2, 
                    {bargainInfo = bargainInfo, bargainModel = self.bargainModel, playerId = playerId, npcId = npcId, modelView = view})            
                end
            end

            self.isPlay = true
        end)
    end)    
end

function BargainCtrl:ExitBargain()
    if self.isPlay then
        Fight.Instance.modelViewMgr:HideView(ModelViewConfig.ViewType.Bargain)
        WindowManager.Instance:CloseWindow(BargainMainWindowV2)

        --第一个参数交涉类型，第二个参数交涉Id，第三个参数结束时分数，第四个参数讨价还价结果
        EventMgr.Instance:Fire(EventName.BargainEnd, self.curType, self.curNegotiateId, self.bargainEndScore, self.curBargainResultType)
        self.bargainModel:Reset()
        self.curType = nil
        self.curRelateId = nil
        self.curPlayerId = nil
        self.curNpcId = nil
        self.curNegotiateId = nil

        self.curPlayerModelClipMap = nil
        self.curNpcModelClipMap = nil
        
        BehaviorFunctions.SetBgmState("BgmType", self.bgmType)
        BehaviorFunctions.SetBgmState("GamePlayType", self.gamePlayType)
        self.bgmType = nil
        self.gamePlayType = nil
        
        --print(string.format("结束讨价 Npc实例Id:%d", self.npcInstanceId))
        Fight.Instance.entityManager:CallBehaviorFun("BaraginOnExit", self.npcInstanceId, self.bargainEndScore, self.curBargainResultType)

        self.bargainEndScore = nil
        self.npcInstanceId = nil
        self.curBargainResultType = nil
    end
end

function BargainCtrl:GetPlayerAnimationClipLength(clipName)
    if self.curPlayerModelClipMap and self.curPlayerModelClipMap[clipName] then
        return self.curPlayerModelClipMap[clipName].length
    end
    return nil
end

function BargainCtrl:GetNpcAnimationClipLength(clipName)
    if self.curNpcModelClipMap and self.curNpcModelClipMap[clipName] then
        return self.curNpcModelClipMap[clipName].length
    end
    return nil
end

function BargainCtrl:PlayerChoice(choice)
    if self.bargainModel:PlayerChoice(choice) then
        self.curScore = self.curScore + self.bargainModel:CalculatedScore()
        LuaTimerManager.Instance:AddTimer(1, 3, function ()
            local flag = self.bargainModel:NextRound()
            if not flag then
                -- 游戏结束
                local playerChoice, npcChoice = self.bargainModel:GetChoice()

                CurtainManager.Instance:EnterWait()
                self.waitServer = true
                local id, cmd = mod.BargainFacade:SendMsg("bargain_check_seq", self.curType, self.curRelateId, self.curNegotiateId, playerChoice, npcChoice, self.curScore)
                --LogInfo("[砍价玩法]向服务器发送序列")
                --LogInfo(string.format("Type:%d, RelateId:%d, NegotiateId:%d, Score:%d", self.curType, self.curRelateId, self.curNegotiateId, self.curScore))
                --LogTable("PlayerChoice", playerChoice)
                --LogTable("NpcChoice", npcChoice)

                mod.LoginCtrl:AddClientCmdEvent(id, cmd, function()
                    --LogInfo("[砍价玩法]收到服务器通用回包")
                    if self.waitServer then
                        CurtainManager.Instance:ExitWait()
                        self.waitServer = nil
                    end
                end)
                
            end
        end)
    end
end

function BargainCtrl:RecyBargainScore(score, roundCount, negotiateId)
    --LogInfo("[砍价玩法]收到服务器分数回应")
    if self.isPlay then
        if self.waitServer then
            CurtainManager.Instance:ExitWait()
            self.waitServer = nil
        end
        self.bargainEndScore = score
        PanelManager.Instance:OpenPanel(BargainScorePanel, {negotiateId = self.curNegotiateId, negotiateCount = roundCount, score = score})
    end
end

function BargainCtrl:SetCurBaraginResultType(type)
    if self.isPlay then
        self.curBargainResultType = type
    else
        LogError("【讨价还价】对局未开始，但是要设置结局")
    end
end