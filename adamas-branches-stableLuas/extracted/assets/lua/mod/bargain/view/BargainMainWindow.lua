BargainMainWindow = BaseClass("BargainMainWindow", BaseWindow)

function BargainMainWindow:__init()
    self:SetAsset("Prefabs/UI/Bargain/BargainMainWindow.prefab")
end

function BargainMainWindow:__BindListener()
    self.UpButton_btn.onClick:AddListener(self:ToFunc("OnClickUpBtn"))
    self.UnderButton_btn.onClick:AddListener(self:ToFunc("OnClickUnderBtn"))
end

function BargainMainWindow:__BindEvent()

end

function BargainMainWindow:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function BargainMainWindow:__delete()


    if self.faceList then
        for i, v in ipairs(self.faceList) do
            PoolManager.Instance:Push(PoolType.class, "BargainItem", v)
        end
    end

    if self.playerRtModel then
        self.playerRtModel:DeleteMe()
    end

    if self.npcRtModel then
        self.npcRtModel:DeleteMe()
    end

    if self.npcAnimState then
        self.npcAnimState:DeleteMe()
        self.npcAnimState = nil
    end

    if self.playerAnimState then
        self.playerAnimState:DeleteMe()
        self.playerAnimState = nil
    end
end

function BargainMainWindow:__Show()
    self.bargainInfo = self.args.bargainInfo
    self.bargainModel = self.args.bargainModel
    self:InitData()
    self:InitDialog()
    self.bargainModel:SetCallback(self:ToFunc("StartRound"), self:ToFunc("EndRound"))
    
    self.playerAnimState = BargainAnimState.New(self.args.modelView, BargainEnum.Model.Player)
    self.npcAnimState = BargainAnimState.New(self.args.modelView, BargainEnum.Model.Npc)
end

function BargainMainWindow:__ShowComplete()
    self:SetActive(false)
    if not self.blurBack then
        local blurNode = self.args.modelView:GetTargetTransform("Canvas").gameObject
        local setting = { bindNode = blurNode, isSceneRt = true }
        self.blurBack = BlurBack.New(self, setting)
    end
    self.blurBack:Show({self:ToFunc("EndSceneView")})
end

function BargainMainWindow:EndSceneView()
    LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function ()
        self:MoveCamera()

        self:InitModelOffset()

        -- 入场动画
        local dialogInfo = BargainConfig.GetBargainDialog(self.subGroupId, 0)
        self.npcAnimState:LoadAnim({dialogInfo.npc_show_anim[1], dialogInfo.npc_show_anim[2]})
        self.playerAnimState:LoadAnim({dialogInfo.player_show_anim[1], dialogInfo.player_show_anim[2]})

        LuaTimerManager.Instance:AddTimer(1, BargainConfig.EntryWaitTime, function ()
            self:ShowGame()
            self.bargainModel:NextRound()
        end)
    end)
end

function BargainMainWindow:ShowGame()
    local dialogInfo = BargainConfig.GetBargainDialog(self.subGroupId, 0)
    self.npcAnimState:LoadAnim({dialogInfo.npc_show_anim[3], "Stand1"})
    self.playerAnimState:LoadAnim({dialogInfo.player_show_anim[3], "Empty_Perform"})

end

function BargainMainWindow:MoveCamera()
    Fight.Instance.modelViewMgr:ShowView(ModelViewConfig.ViewType.Bargain)

    self.args.modelView:BlendToNewCamera({x = 0,y = 1.5,z = 3}, {x = 0,y = 180,z = 0})    
end

function BargainMainWindow:InitModelOffset()
    local playerUiModelName = BargainConfig.GetUiModelByPlayerId(self.args.playerId)
    local npcUiModelName = BargainConfig.GetUiModelByNpcId(self.bargainInfo)

    if self.args.playerId then
        local offset = BargainConfig.GetModelOffsetByUiModel(playerUiModelName)
        local tf = self.args.modelView:GetTargetTransform("PlayerRoot"):GetChild(1)
        UnityUtils.SetLocalPosition(tf, offset.camera_position.x, offset.camera_position.y, offset.camera_position.z)
        UnityUtils.SetLocalEulerAngles(tf, offset.camera_rotation.x, offset.camera_rotation.y, offset.camera_rotation.z)
        UnityUtils.SetLocalScale(tf, offset.camera_scale.x, offset.camera_scale.y, offset.camera_scale.z)
    end

    if self.args.npcId then
        local offset = BargainConfig.GetModelOffsetByUiModel(npcUiModelName)
        local tf = self.args.modelView:GetTargetTransform("NpcRoot"):GetChild(1)
        UnityUtils.SetLocalPosition(tf, offset.camera_position.x, offset.camera_position.y, offset.camera_position.z)
        UnityUtils.SetLocalEulerAngles(tf, offset.camera_rotation.x, offset.camera_rotation.y, offset.camera_rotation.z)
        UnityUtils.SetLocalScale(tf, offset.camera_scale.x, offset.camera_scale.y, offset.camera_scale.z)
    end
    
end

function BargainMainWindow:OnClickUpBtn()
    mod.BargainCtrl:PlayerChoice(BargainEnum.Choice.Up)
end

function BargainMainWindow:OnClickUnderBtn()
    mod.BargainCtrl:PlayerChoice(BargainEnum.Choice.Under)
end

function BargainMainWindow:StartRound(curRound, playerChoice, npcChoice)
    for _, bargainItem in ipairs(self.faceList) do
        bargainItem:Reset()
    end
    local dialogInfo = BargainConfig.GetBargainDialog(self.subGroupId, curRound)

    self:SetFace(playerChoice, npcChoice)
    self:SetDialog(playerChoice, npcChoice, dialogInfo)

    self.PaceTitleNum_txt.text = string.format("%d/%d", curRound, self.bargainInfo.total_rounds)

    UtilsUI.SetActive(self.Buttons, true)

    if npcChoice then
        self.PaceStateText_txt.text = TI18N("玩家做选择")
        if npcChoice == BargainEnum.Choice.Up then
            self:SetModelAnim(BargainEnum.Model.Npc, BargainEnum.AnimState.Up, dialogInfo)
            self.faceList[self.faceEnum.PlayerUpNpcUp]:NpcSelect()
            self.faceList[self.faceEnum.PlayerUnderNpcUp]:NpcSelect()
        elseif npcChoice == BargainEnum.Choice.Under then
            self:SetModelAnim(BargainEnum.Model.Npc, BargainEnum.AnimState.Under, dialogInfo)
            self.faceList[self.faceEnum.PlayerUpNpcUnder]:NpcSelect()
            self.faceList[self.faceEnum.PlayerUnderNpcUnder]:NpcSelect()
        end
    else
        self.PaceStateText_txt.text = TI18N("双方做选择")
        self:SetModelAnim(BargainEnum.Model.Npc, BargainEnum.AnimState.UnderEnd, dialogInfo)
    end

    self:SetModelAnim(BargainEnum.Model.Player, BargainEnum.AnimState.UnderEnd, dialogInfo)

    UtilsUI.SetActive(self.MatchCurScoreNum, false)
    UtilsUI.SetActive(self.MatchCurIcon, false)
    UtilsUI.SetActive(self.MatchCurInfo, false)

    LayoutRebuilder.ForceRebuildLayoutImmediate(self.MatchScore.transform)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.MatchCurScore.transform)
end

function BargainMainWindow:EndRound(curRound, playerChoice, npcChoice)
    local dialogInfo = BargainConfig.GetBargainDialog(self.subGroupId, curRound)

    self:SetFace(playerChoice, npcChoice)
    self:SetDialog(playerChoice, npcChoice, dialogInfo)

    local curScore = self.bargainModel:CalculatedScore()
    if curScore == nil then
        LogError("当然回合有人未出牌, 分数计算有误")
    end

    self.scoreSum = self.scoreSum + curScore
    self.MatchSumScoreText_txt.text = self.scoreSum

    UtilsUI.SetActive(self.MatchCurInfo, true)
    UtilsUI.SetActive(self.MatchCurIcon, true)
    UtilsUI.SetActive(self.MatchCurScoreNum, true)

    self:SetMatchInfoText(self.scoreSum)

    if curScore == 0 then
        self.MatchCurScoreNum_txt.text = "0"
    elseif curScore > 0 then
        self.MatchCurScoreNum_txt.text = "+" .. curScore
    else
        self.MatchCurScoreNum_txt.text = curScore
    end
    
    if playerChoice == BargainEnum.Choice.Up and npcChoice == BargainEnum.Choice.Up then
        self.faceList[self.faceEnum.PlayerUpNpcUp]:Select()
        self.faceList[self.faceEnum.PlayerUpNpcUp]:NpcSelect()
        self.faceList[self.faceEnum.PlayerUpNpcUp]:PlayerSelect()
        self:SetModelAnim(BargainEnum.Model.Player, BargainEnum.AnimState.Up, dialogInfo)
        self:SetModelAnim(BargainEnum.Model.Npc, BargainEnum.AnimState.Up, dialogInfo)

    elseif playerChoice == BargainEnum.Choice.Up and npcChoice == BargainEnum.Choice.Under then
        self.faceList[self.faceEnum.PlayerUpNpcUnder]:Select()
        self.faceList[self.faceEnum.PlayerUpNpcUnder]:NpcSelect()
        self.faceList[self.faceEnum.PlayerUpNpcUnder]:PlayerSelect()
        self:SetModelAnim(BargainEnum.Model.Player, BargainEnum.AnimState.Up, dialogInfo)
        self:SetModelAnim(BargainEnum.Model.Npc, BargainEnum.AnimState.Under, dialogInfo)

    elseif playerChoice == BargainEnum.Choice.Under and npcChoice == BargainEnum.Choice.Up then
        self.faceList[self.faceEnum.PlayerUnderNpcUp]:Select()
        self.faceList[self.faceEnum.PlayerUnderNpcUp]:NpcSelect()
        self.faceList[self.faceEnum.PlayerUnderNpcUp]:PlayerSelect()
        self:SetModelAnim(BargainEnum.Model.Player, BargainEnum.AnimState.Under, dialogInfo)
        self:SetModelAnim(BargainEnum.Model.Npc, BargainEnum.AnimState.Up, dialogInfo)

    elseif playerChoice == BargainEnum.Choice.Under and npcChoice == BargainEnum.Choice.Under then
        self.faceList[self.faceEnum.PlayerUnderNpcUnder]:Select()
        self.faceList[self.faceEnum.PlayerUnderNpcUnder]:NpcSelect()
        self.faceList[self.faceEnum.PlayerUnderNpcUnder]:PlayerSelect()
        self:SetModelAnim(BargainEnum.Model.Player, BargainEnum.AnimState.Under, dialogInfo)
        self:SetModelAnim(BargainEnum.Model.Npc, BargainEnum.AnimState.Under, dialogInfo)
    end

    UtilsUI.SetActive(self.Buttons, false)

    UtilsUI.SetActive(self.MatchCurIcon, true)
    UtilsUI.SetActive(self.MatchCurInfo, true)
    UtilsUI.SetActive(self.MatchCurScoreNum, true)

    LayoutRebuilder.ForceRebuildLayoutImmediate(self.MatchScore.transform)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.MatchCurScore.transform)
end

function BargainMainWindow:SetFace(playerChoice, npcChoice)
    if playerChoice then
        if playerChoice == BargainEnum.Choice.Up then
            self.faceList[self.faceEnum.PlayerUnderNpcUp]:Mask()
            self.faceList[self.faceEnum.PlayerUnderNpcUnder]:Mask()
        elseif playerChoice == BargainEnum.Choice.Under then
            self.faceList[self.faceEnum.PlayerUpNpcUp]:Mask()
            self.faceList[self.faceEnum.PlayerUpNpcUnder]:Mask()
        end
    end

    if npcChoice then
        if npcChoice == BargainEnum.Choice.Up then
            self.faceList[self.faceEnum.PlayerUpNpcUnder]:Mask()
            self.faceList[self.faceEnum.PlayerUnderNpcUnder]:Mask()
        elseif npcChoice == BargainEnum.Choice.Under then
            self.faceList[self.faceEnum.PlayerUpNpcUp]:Mask()
            self.faceList[self.faceEnum.PlayerUnderNpcUp]:Mask()
        end
    end
end

function BargainMainWindow:SetDialog(playerChoice, npcChoice, dialogInfo)
    if playerChoice then
        UtilsUI.SetActive(self.PlayerDialogBox, true)
        if playerChoice == BargainEnum.Choice.Up then
            self.PlayerDialogText_txt.text = dialogInfo.player_up_dialog
        elseif playerChoice == BargainEnum.Choice.Under then
            self.PlayerDialogText_txt.text = dialogInfo.player_under_dialog
        end
    else
        UtilsUI.SetActive(self.PlayerDialogBox, false)
    end

    if npcChoice then
        UtilsUI.SetActive(self.NpcDialogBox, true)
        if npcChoice == BargainEnum.Choice.Up then
            self.NpcDialogText_txt.text = dialogInfo.npc_up_dialog
        elseif npcChoice == BargainEnum.Choice.Under then
            self.NpcDialogText_txt.text = dialogInfo.npc_under_dialog
        end
    else
        UtilsUI.SetActive(self.NpcDialogBox, false)
    end
end

function BargainMainWindow:InitData()
    self:InitMatchInformation()
    self:InitTips()
    self:InitFace()
end

function BargainMainWindow:InitDialog()
    self.subGroupId = BargainConfig.GetRandomSubGruodId(self.bargainInfo)

    self.UpButtonText_txt.text = self.bargainInfo.up_btn_desc
    self.UnderButtonText_txt.text = self.bargainInfo.under_btn_desc
end

function BargainMainWindow:InitMatchInformation()
    self.PaceTitleText_txt.text = TI18N("本局进度")
    self.PaceTitleNum_txt.text = string.format("%d/%d", 1, self.bargainInfo.total_rounds)
    UtilsUI.SetActive(self.PaceTitleText, true)

    self.PaceStateText_txt.text = ""

    self.MatchTitleText_txt.text = TI18N("总得分")
    self.scoreSum = 0
    self.MatchSumScoreText_txt.text = self.scoreSum
    UtilsUI.SetActive(self.MatchScore, true)

    self.MatchInfoText_txt.text = TI18N("本次交易增幅——")
    self.MatchCurInfo_txt.text = TI18N("本轮得分")
    UtilsUI.SetActive(self.MatchCurScore, true)
end

function BargainMainWindow:SetMatchInfoText(scoreSum)
    if self.bargainInfo.bargain_type == BargainEnum.Type.Shop then
        local discount = 1 + (scoreSum * self.bargainInfo.param / 10000)
        if not scoreSum or scoreSum == 0 then
            self.MatchInfoText_txt.text = TI18N("商店中商品降价——")
        elseif discount < 1 then
            self.MatchInfoText_txt.text = string.format(TI18N("商店中商品降价<color=%s>%.2f%%</color>"), 
            BargainConfig.Color.Green, 100 - discount * 100)
        else
            self.MatchInfoText_txt.text = string.format(TI18N("商店中商品涨价<color=%s>%.2f%%</color>"), 
            BargainConfig.Color.Red, discount * 100 - 100)
        end

    elseif self.bargainInfo.bargain_type == BargainEnum.Type.Trade then
        local discount = 1 + (scoreSum * self.bargainInfo.param / 10000)
        if not scoreSum or scoreSum == 0 then
            self.MatchInfoText_txt.text = TI18N("本次交易增幅——")
        elseif discount > 1 then
            self.MatchInfoText_txt.text = string.format(TI18N("本次交易增幅<color=%s>%.2f%%</color>"), 
            BargainConfig.Color.Green, discount * 100 - 100)
        else
            self.MatchInfoText_txt.text = string.format(TI18N("本次交易减幅<color=%s>%.2f%%</color>"), 
            BargainConfig.Color.Red, 100 - discount * 100)
        end
    end
end

function BargainMainWindow:InitTips()
    self.TipsTitleText_txt.text = TI18N("提示")
    local characterInfo = BargainConfig.GetBargainNpcCharacterByBargainInfo(self.bargainInfo)
    self.TipsDescText_txt.text = characterInfo.character_desc
end

function BargainMainWindow:InitFace()
    local bargainItem1Container = UtilsUI.GetContainerObject(self.BargainItem1)
    local bargainItem2Container = UtilsUI.GetContainerObject(self.BargainItem2)
    local bargainItem3Container = UtilsUI.GetContainerObject(self.BargainItem3)
    local bargainItem4Container = UtilsUI.GetContainerObject(self.BargainItem4)

    self.faceEnum = 
    {
        PlayerUpNpcUp = 1,
        PlayerUpNpcUnder = 2,
        PlayerUnderNpcUp = 3,
        PlayerUnderNpcUnder = 4,
    }
    
    self.faceList = {true, true, true, true}
    self.faceList[self.faceEnum.PlayerUpNpcUp] = PoolManager.Instance:Pop(PoolType.class, "BargainItem") or BargainItem.New()
    self.faceList[self.faceEnum.PlayerUpNpcUp]:SetFace(bargainItem1Container, BargainEnum.Choice.Up, BargainEnum.Choice.Up, self.bargainInfo, self.args.playerId, self.args.npcId)
    bargainItem1Container.GroupTitle_txt.text = TI18N("组1")

    self.faceList[self.faceEnum.PlayerUpNpcUnder] = PoolManager.Instance:Pop(PoolType.class, "BargainItem") or BargainItem.New()
    self.faceList[self.faceEnum.PlayerUpNpcUnder]:SetFace(bargainItem2Container, BargainEnum.Choice.Up, BargainEnum.Choice.Under, self.bargainInfo, self.args.playerId, self.args.npcId)
    bargainItem2Container.GroupTitle_txt.text = TI18N("组2")

    self.faceList[self.faceEnum.PlayerUnderNpcUp] = PoolManager.Instance:Pop(PoolType.class, "BargainItem") or BargainItem.New()
    self.faceList[self.faceEnum.PlayerUnderNpcUp]:SetFace(bargainItem3Container, BargainEnum.Choice.Under, BargainEnum.Choice.Up, self.bargainInfo, self.args.playerId, self.args.npcId)
    bargainItem3Container.GroupTitle_txt.text = TI18N("组3")

    self.faceList[self.faceEnum.PlayerUnderNpcUnder] = PoolManager.Instance:Pop(PoolType.class, "BargainItem") or BargainItem.New()
    self.faceList[self.faceEnum.PlayerUnderNpcUnder]:SetFace(bargainItem4Container, BargainEnum.Choice.Under, BargainEnum.Choice.Under, self.bargainInfo, self.args.playerId, self.args.npcId)
    bargainItem4Container.GroupTitle_txt.text = TI18N("组4")


end

function BargainMainWindow:SetModelAnim(model, animState, dialogInfo)
    if model == BargainEnum.Model.Npc then
        if animState == BargainEnum.AnimState.Up then
            self.npcAnimState:LoadAnim({dialogInfo.npc_up_anim[1], dialogInfo.npc_up_anim[2]})
        elseif animState == BargainEnum.AnimState.UpEnd then
            self.npcAnimState:LoadAnim({dialogInfo.npc_up_anim[3], "Stand1"})
        elseif animState == BargainEnum.AnimState.Under then
            self.npcAnimState:LoadAnim({dialogInfo.npc_under_anim[1], dialogInfo.npc_under_anim[2]})
        elseif animState == BargainEnum.AnimState.UnderEnd then
            self.npcAnimState:LoadAnim({dialogInfo.npc_under_anim[3], "Stand1"})
        end
    elseif model == BargainEnum.Model.Player then
        if animState == BargainEnum.AnimState.Up then
            self.playerAnimState:LoadAnim({dialogInfo.player_up_anim[1], dialogInfo.player_up_anim[2]})
        elseif animState == BargainEnum.AnimState.UpEnd then
            self.playerAnimState:LoadAnim({dialogInfo.player_up_anim[3], "Empty_Perform"})
        elseif animState == BargainEnum.AnimState.Under then
            self.playerAnimState:LoadAnim({dialogInfo.player_under_anim[1], dialogInfo.player_under_anim[2]})
        elseif animState == BargainEnum.AnimState.UnderEnd then
            self.playerAnimState:LoadAnim({dialogInfo.player_under_anim[3], "Empty_Perform"})
        end
    end
end