BargainMainWindowV2 = BaseClass("BargainMainWindowV2", BaseWindow)

local BargainTitleText = TI18N("<b><size=36>第</size></b><size=72>%d</size><size=48>/%d</size><b><size=36>轮</size></b>")
local BargainScore = "<color=%s>%d</color>"
local BargainSignedScore = "<color=%s>%+d</color>"
local BargainScoreContentTextShopAdv = TI18N("商店中商品降价<size=26><color=%s>%.2f%%</color></size>")
local BargainScoreContentTextShopDisAdv = TI18N("商店中商品涨价<size=26><color=%s>%.2f%%</color></size>")
local BargainScoreContentTextShopFlat = TI18N("商店中商品降价——")
local BargainScoreContentTextTradeAdv = TI18N("本次交易增幅<size=26><color=%s>%.2f%%</color></size>")
local BargainScoreContentTextTradeDisAdv = TI18N("本次交易减幅<size=26><color=%s>%.2f%%</color></size>")
local BargainScoreContentTextTradeFlat = TI18N("本次交易增幅——")
local BargainScoreContentTextBargain = TI18N("达到%.2f分交涉成功")

function BargainMainWindowV2:__init()
    self:SetAsset("Prefabs/UI/Bargain/V2/BargainMainWindowV2.prefab")
    self.baseSceneCanvasWidth = 20.65
    self.baseSceneCanvasHeight = 11.62
    self.baseAspect = self.baseSceneCanvasWidth / self.baseSceneCanvasHeight
end

function BargainMainWindowV2:__BindListener()
    self.PlayerUpChooseButton_btn.onClick:AddListener(self:ToFunc("OnClickUpBtn"))
    self.PlayerUnderChooseButton_btn.onClick:AddListener(self:ToFunc("OnClickUnderBtn"))

    self.TipsShowButton_btn.onClick:AddListener(self:ToFunc("OnClickShowTipsBtn"))
    self.TipsContainerButton_btn.onClick:AddListener(self:ToFunc("OnClickCloseTipsBtn"))
    UtilsUI.SetHideCallBack(self.TipsContainerButton_out, self:ToFunc("TipsCloseAnimCallBack"))
    
    UtilsUI.SetHideCallBack(self.BargainReadyFront_out, self:ToFunc("BargainFrontIsEnd"))
    UtilsUI.SetHideCallBack(self.NpcDialog_out, self:ToFunc("NpcDialogPlayInAnim"))
end

function BargainMainWindowV2:__BindEvent()
    
end

function BargainMainWindowV2:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function BargainMainWindowV2:__delete()


    if self.npcAnimState then
        self.npcAnimState:DeleteMe()
        self.npcAnimState = nil
    end

    if self.playerAnimState then
        self.playerAnimState:DeleteMe()
        self.playerAnimState = nil
    end

    if self.chooseTimer then
        self.chooseTimer:DeleteMe()
        self.chooseTimer = nil
    end

    if self.soundLoader then
        AssetMgrProxy.Instance:CacheLoader(self.soundLoader)
    end
end

function BargainMainWindowV2:__Show()
    self.bargainInfo = self.args.bargainInfo
    self.bargainModel = self.args.bargainModel
    self:InitData()
    self.bargainModel:SetCallback(self:ToFunc("StartRound"), self:ToFunc("EndRound"))
    
    self.playerAnimState = BargainAnimState.New(self.args.modelView, BargainEnum.Model.Player)
    self.npcAnimState = BargainAnimState.New(self.args.modelView, BargainEnum.Model.Npc)

    --加载对话音频
    self:LoadAllDialogSound()
end

function BargainMainWindowV2:__ShowComplete()
    self:SetActive(false)
    self.sceneCanvasTrans = self.args.modelView:GetTargetTransform("Canvas")
    self.sceneUiCont = UtilsUI.GetContainerObject(self.sceneCanvasTrans)
    if not self.blurBack then
        local blurNode = self.sceneCanvasTrans.gameObject
        local setting = { bindNode = blurNode, isSceneRt = true }
        self.blurBack = BlurBack.New(self, setting)
    end
    self.blurBack:Show({self:ToFunc("SceneView")})
end

function BargainMainWindowV2:SceneView()
    -- 获取材质球灯光
    local lightDirTrans = self.args.modelView:GetTargetTransform("LightDir")
    if lightDirTrans then
        local lightDirComp = lightDirTrans:GetComponent(CS.StoryLightController)
        if lightDirComp then
            lightDirComp:GetRoleMat()
        else
            LogError("[砍价玩法] 未获取到场景灯光组件")
        end
    else
        LogError("[砍价玩法] 未获取到场景灯光GO")
    end

    LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, self:ToFunc("OpenSceneView"))
end

function BargainMainWindowV2:OpenSceneView()
    local cameraAspect = Camera.main.aspect
    if cameraAspect < self.baseAspect then
        local scale = self.baseAspect / cameraAspect
        UnityUtils.SetLocalScale(self.sceneCanvasTrans, scale, scale, scale)
    else
        local scale = cameraAspect / self.baseAspect 
        UnityUtils.SetLocalScale(self.sceneCanvasTrans, scale, scale, scale)
    end
    
    self:MoveCamera()

    self:InitModelOffset()

    -- 入场动画
    UtilsUI.SetActive(self.BargainRoot, false)
    UtilsUI.SetActive(self.BargainReady, true)
    UtilsUI.SetActive(self.sceneUiCont.BargainReady, true)
    UtilsUI.SetActive(self.sceneUiCont.BargainGame, false)

    local dialogInfo = BargainConfig.GetBargainDialog(self.subGroupId, 0)

    -- Npc出场动画
    self:SetModelAnim(BargainEnum.Model.Npc, BargainEnum.AnimState1.Show, BargainEnum.AnimState2.Start, dialogInfo)

    -- Player出场动画
    self:SetModelAnim(BargainEnum.Model.Player, BargainEnum.AnimState1.Show, BargainEnum.AnimState2.Start, dialogInfo)
end

function BargainMainWindowV2:MoveCamera()
    Fight.Instance.modelViewMgr:ShowView(ModelViewConfig.ViewType.Bargain)

    self.args.modelView:BlendToNewCamera({x = 0,y = 1.5,z = 3}, {x = 0,y = 180,z = 0})    
end

function BargainMainWindowV2:InitModelOffset()
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

function BargainMainWindowV2:BargainFrontIsEnd()
    self.bargainFrontIsReady = true
    self:GameStart()
end

function BargainMainWindowV2:GameStart()
    if not self.soundIsReady or not self.bargainFrontIsReady then
        return
    end
    local dialogInfo = BargainConfig.GetBargainDialog(self.subGroupId, 0)
    -- Npc出场动画
    self:SetModelAnim(BargainEnum.Model.Npc, BargainEnum.AnimState1.Show, BargainEnum.AnimState2.End, dialogInfo)

    -- Player出场动画
    self:SetModelAnim(BargainEnum.Model.Player, BargainEnum.AnimState1.Show, BargainEnum.AnimState2.End, dialogInfo)

    UtilsUI.SetActive(self.BargainReady, false)
    UtilsUI.SetActive(self.BargainRoot, true)
    UtilsUI.SetActive(self.sceneUiCont.BargainReady, false)
    UtilsUI.SetActive(self.sceneUiCont.BargainGame, true)
    self.bargainModel:NextRound()
end

function BargainMainWindowV2:OnClickUpBtn()
    self.chooseTimer:StopTimer()
    mod.BargainCtrl:PlayerChoice(BargainEnum.Choice.Up)
end

function BargainMainWindowV2:OnClickUnderBtn()
    self.chooseTimer:StopTimer()
    mod.BargainCtrl:PlayerChoice(BargainEnum.Choice.Under)
end

function BargainMainWindowV2:OnClickShowTipsBtn()
    UtilsUI.SetActive(self.TipsShowButton, false)
    UtilsUI.SetActive(self.TipsContainerButton, true)
    self.TipsContainerButton_anim:Play("UI_TipsContainerButton")
end

function BargainMainWindowV2:OnClickCloseTipsBtn()
    self.TipsContainerButton_anim:Play("UI_TipsContainerButton_out")
end

function BargainMainWindowV2:TipsCloseAnimCallBack()
    UtilsUI.SetActive(self.TipsShowButton, true)
    UtilsUI.SetActive(self.TipsContainerButton, false)
end

function BargainMainWindowV2:StartRound(curRound, playerChoice, npcChoice)
    local dialogInfo = nil

    -- 播放上一次选择的End
    if curRound == 1 then
        -- 第一轮播放展示动作的End
        dialogInfo = BargainConfig.GetBargainDialog(self.subGroupId, 0)
        -- Player部分
        self:SetModelAnim(BargainEnum.Model.Player, BargainEnum.AnimState1.None, BargainEnum.AnimState2.None, dialogInfo)

        -- Npc部分
        if npcChoice[curRound] then
            local npcLastChoice = npcChoice[curRound]
            dialogInfo = BargainConfig.GetBargainDialog(self.subGroupId, curRound)
            self.npcFirstChess = true

            if npcLastChoice == BargainEnum.Choice.Up then
                self:SetModelAnim(BargainEnum.Model.Npc, BargainEnum.AnimState1.Up, BargainEnum.AnimState2.Start, dialogInfo)
                if dialogInfo.npc_up_cv then
                    self:PlaySound(dialogInfo.npc_up_cv[2])
                end
            elseif npcLastChoice == BargainEnum.Choice.Under then
                self:SetModelAnim(BargainEnum.Model.Npc, BargainEnum.AnimState1.Under, BargainEnum.AnimState2.Start, dialogInfo)
                if dialogInfo.npc_under_cv then
                    self:PlaySound(dialogInfo.npc_under_cv[2])
                end
            end

        else
            self:SetModelAnim(BargainEnum.Model.Npc, BargainEnum.AnimState1.None, BargainEnum.AnimState2.None, dialogInfo)
        end
    else
        -- 播放上一次选择的End
        dialogInfo = BargainConfig.GetBargainDialog(self.subGroupId, curRound - 1)
        -- Player部分
        local playerLastChoice = playerChoice[curRound - 1]
        if playerLastChoice == BargainEnum.Choice.Up then
            self:SetModelAnim(BargainEnum.Model.Player, BargainEnum.AnimState1.Up, BargainEnum.AnimState2.End, dialogInfo)
        elseif playerLastChoice == BargainEnum.Choice.Under then
            self:SetModelAnim(BargainEnum.Model.Player, BargainEnum.AnimState1.Under, BargainEnum.AnimState2.End, dialogInfo)
        elseif playerLastChoice == BargainEnum.Choice.NoChoice then
            self:SetModelAnim(BargainEnum.Model.Player, BargainEnum.AnimState1.None, BargainEnum.AnimState2.None, dialogInfo)
        end

        -- Npc部分
        local npcLastChoice
        local npcAnimState2
        if npcChoice[curRound] then
            npcLastChoice = npcChoice[curRound]
            dialogInfo = BargainConfig.GetBargainDialog(self.subGroupId, curRound)
            npcAnimState2 = BargainEnum.AnimState2.Start
            self.npcFirstChess = true

            if npcLastChoice == BargainEnum.Choice.Up and dialogInfo.npc_up_cv then
                self:PlaySound(dialogInfo.npc_up_cv[2])
            elseif npcLastChoice == BargainEnum.Choice.Under and dialogInfo.npc_under_cv then
                self:PlaySound(dialogInfo.npc_under_cv[2])
            end
        else
            npcLastChoice = npcChoice[curRound - 1]
            npcAnimState2 = BargainEnum.AnimState2.End
            self.npcFirstChess = false
        end

        if npcLastChoice == BargainEnum.Choice.Up then
            self:SetModelAnim(BargainEnum.Model.Npc, BargainEnum.AnimState1.Up, npcAnimState2, dialogInfo)
        elseif npcLastChoice == BargainEnum.Choice.Under then
            self:SetModelAnim(BargainEnum.Model.Npc, BargainEnum.AnimState1.Under, npcAnimState2, dialogInfo)
        end
    end

    if self.lastShowTime then
        UtilsUI.SetActive(self[self.lastShowTime], false)
        self.lastShowTime = nil
    end

    dialogInfo = BargainConfig.GetBargainDialog(self.subGroupId, curRound)

    self:SetDialog(playerChoice[curRound], npcChoice[curRound], dialogInfo, true)
    self.BargainTitleText_txt.text = string.format(BargainTitleText, curRound, self.bargainInfo.total_rounds)
    if self.UI_BargainTitle_sao.activeSelf then
        UtilsUI.SetActive(self.UI_BargainTitle_sao, false)
    end
    UtilsUI.SetActive(self.UI_BargainTitle_sao, true)

    self.PlayerUpChooseText_txt.text = dialogInfo.player_up_dialog
    self.PlayerUnderChooseText_txt.text = dialogInfo.player_under_dialog

    UtilsUI.SetActive(self.ChooseButtons, true)
    self.chooseTimer:StartTimer()

    LayoutRebuilder.ForceRebuildLayoutImmediate(self.BargainScore.transform)
end

function BargainMainWindowV2:EndRound(curRound, playerChoice, npcChoice)
    local dialogInfo = BargainConfig.GetBargainDialog(self.subGroupId, curRound)

    UtilsUI.SetActive(self.ChooseButtons, false)

    local curScore = self.bargainModel:CalculatedScore()
    if curScore == nil then
        LogError("当然回合有人未出牌, 分数计算有误")
    end

    self.scoreSum = self.scoreSum + curScore

    self:SetMatchInfoText(self.scoreSum)
    if playerChoice[curRound] == BargainEnum.Choice.Up then
        self:SetModelAnim(BargainEnum.Model.Player, BargainEnum.AnimState1.Up, BargainEnum.AnimState2.Start, dialogInfo)
        if dialogInfo.player_up_cv then
            self:PlaySound(dialogInfo.player_up_cv[2])
        end
    elseif playerChoice[curRound] == BargainEnum.Choice.Under then
        self:SetModelAnim(BargainEnum.Model.Player, BargainEnum.AnimState1.Under, BargainEnum.AnimState2.Start, dialogInfo)
        if dialogInfo.player_under_cv then
            self:PlaySound(dialogInfo.player_under_cv[2])
        end
    elseif playerChoice[curRound] == BargainEnum.Choice.NoChoice then
        -- 不出牌不播动画
        self:SetModelAnim(BargainEnum.Model.Player, BargainEnum.AnimState1.None, BargainEnum.AnimState2.None, dialogInfo)
    end

    if not self.npcFirstChess then
        if npcChoice[curRound] == BargainEnum.Choice.Up then
            self:SetModelAnim(BargainEnum.Model.Npc, BargainEnum.AnimState1.Up, BargainEnum.AnimState2.Start, dialogInfo)
            if dialogInfo.npc_up_cv then
                self:PlaySound(dialogInfo.npc_up_cv[2])
            end
        elseif npcChoice[curRound] == BargainEnum.Choice.Under then
            self:SetModelAnim(BargainEnum.Model.Npc, BargainEnum.AnimState1.Under, BargainEnum.AnimState2.Start, dialogInfo)
            if dialogInfo.npc_under_cv then
                self:PlaySound(dialogInfo.npc_under_cv[2])
            end
        end

        self:SetDialog(playerChoice[curRound], npcChoice[curRound], dialogInfo, false)
    else
        self:SetDialog(playerChoice[curRound], nil, dialogInfo, false)
    end

    UtilsUI.SetActive(self.ChooseButtons, false)

    local scoreInfo = BargainConfig.GetScoreInfo(playerChoice[curRound], npcChoice[curRound])
    if scoreInfo then
        self.lastShowTime = scoreInfo.effect
        local cont = UtilsUI.GetContainerObject(self[scoreInfo.effect])
        if scoreInfo.player_score > 0 then
            cont.ShowTimeScoreText_txt.text = string.format(BargainSignedScore, BargainConfig.Color.Green, scoreInfo.player_score)
        elseif scoreInfo.player_score == 0 then
            cont.ShowTimeScoreText_txt.text = string.format(BargainSignedScore, BargainConfig.Color.White, scoreInfo.player_score)
        else
            cont.ShowTimeScoreText_txt.text = string.format(BargainSignedScore, BargainConfig.Color.Red, scoreInfo.player_score)
        end
        UtilsUI.SetActive(cont.ShowTimeCrush, true)
        UtilsUI.SetActive(self[scoreInfo.effect], true)
--[[
        if self.UI_BargainTitle_sao.activeSelf then
            UtilsUI.SetActive(self.UI_BargainTitle_sao, false)
        end
        UtilsUI.SetActive(self.UI_BargainTitle_sao, true)
        ]]
    end

    LayoutRebuilder.ForceRebuildLayoutImmediate(self.BargainScore.transform)
end

function BargainMainWindowV2:PlaySound(soundName)
    if self.curPlaySound then
        SoundManager.Instance:StopObjectSound(self.curPlaySound, self.BargainSoundNode)
    end
    
    SoundManager.Instance:PlayObjectSound(soundName, self.BargainSoundNode)
    self.curPlaySound = soundName
end

function BargainMainWindowV2:SetDialog(playerChoice, npcChoice, dialogInfo, isBegin)
    if playerChoice then
        UtilsUI.SetActive(self.PlayerDialog, true)
        if playerChoice == BargainEnum.Choice.Up then
            self.PlayerDialogText_txt.text = TI18N(dialogInfo.player_up_dialog)
            UtilsUI.SetActive(self.PlayerDialogUp, true)
            UtilsUI.SetActive(self.PlayerDialogUnder, false)
        elseif playerChoice == BargainEnum.Choice.Under then
            self.PlayerDialogText_txt.text = TI18N(dialogInfo.player_under_dialog)
            UtilsUI.SetActive(self.PlayerDialogUp, false)
            UtilsUI.SetActive(self.PlayerDialogUnder, true)
        elseif playerChoice == BargainEnum.Choice.NoChoice then
            self.PlayerDialogText_txt.text = "......"
            UtilsUI.SetActive(self.PlayerDialogUp, false)
            UtilsUI.SetActive(self.PlayerDialogUnder, false)
        end
    else
        UtilsUI.SetActive(self.PlayerDialog, false)
    end

    if npcChoice then
        local active = self.NpcDialog.activeSelf
        UtilsUI.SetActive(self.NpcDialog, true)
        if npcChoice == BargainEnum.Choice.Up then
            self.NpcDialogText_txt.text = TI18N(dialogInfo.npc_up_dialog)
            UtilsUI.SetActive(self.NpcDialogUp, true)
            UtilsUI.SetActive(self.NpcDialogUnder, false)
        elseif npcChoice == BargainEnum.Choice.Under then
            self.NpcDialogText_txt.text = TI18N(dialogInfo.npc_under_dialog)
            UtilsUI.SetActive(self.NpcDialogUp, false)
            UtilsUI.SetActive(self.NpcDialogUnder, true)
        end
        if active then
            self.NpcDialog_anim:Play("UI_NpcDialog_out")
        end

    elseif isBegin then
        UtilsUI.SetActive(self.NpcDialog, false)
    end
end

function BargainMainWindowV2:InitData()
    self:InitBargainTitle()
    self:InitTips()
    self:InitScoreTips()
    self:InitDialog()
    self:InitChooseTimer()
    self:InitBargainReady(self.args.playerId, self.args.npcId)
end

function BargainMainWindowV2:InitBargainTitle()
    self.BargainTitleText_txt.text = string.format(BargainTitleText, 1, self.bargainInfo.total_rounds)
    UtilsUI.SetActive(self.BargainTitleText, true)

    self.BargainScoreText_txt.text = string.format(BargainScore, BargainConfig.Color.White, 0)

    if self.bargainInfo.bargain_type == BargainEnum.Type.Shop then
        self.BargainScoreContentText_txt.text = BargainScoreContentTextShopFlat
    elseif self.bargainInfo.bargain_type == BargainEnum.Type.Trade then
        self.BargainScoreContentText_txt.text = BargainScoreContentTextTradeFlat
    elseif self.bargainInfo.bargain_type == BargainEnum.Type.Bargain then
        self.BargainScoreContentText_txt.text = string.format(BargainScoreContentTextBargain, self.bargainInfo.param)
    end

    UtilsUI.SetActive(self.BargainScore, true)
    UtilsUI.SetActive(self.BargainTitle, true)

    self.scoreSum = 0

    LayoutRebuilder.ForceRebuildLayoutImmediate(self.BargainScore.transform)
end

function BargainMainWindowV2:InitTips()
    self.TipsShowButtonText_txt.text = TI18N("提示")
    self.TipsTitle_txt.text = TI18N("提示")
    local characterInfo = BargainConfig.GetBargainNpcCharacterByBargainInfo(self.bargainInfo)
    self.TipsContentText_txt.text = TI18N(characterInfo.character_desc)

    UtilsUI.SetActive(self.TipsShowButton, false)
    UtilsUI.SetActive(self.TipsContainerButton, true)
    UtilsUI.SetActive(self.Tips, true)
end

function BargainMainWindowV2:InitScoreTips()
    self.ScoreTipsTitleNpcText_txt.text = TI18N("对方")
    self.ScoreTipsTitlePlayerText_txt.text = TI18N("我方")
    self.ScoreTipsTitleScoreText_txt.text = TI18N("得分")

    local scoreShowInfo = BargainConfig.GetBargainScoreShowInfo()

    for _, v in ipairs(scoreShowInfo) do
        local go = GameObject.Instantiate(self.ScoreTipsContent, self.ScoreTips.transform)
        local uiContainer = UtilsUI.GetContainerObject(go)
        if v.npcChoice == BargainEnum.Choice.Up then
            uiContainer.ScoreTipsTitleNpcText_txt.text = TI18N(string.format("<color=%s>%s</color>", BargainConfig.Color.Blue, self.bargainInfo.up_btn_desc))
        elseif v.npcChoice == BargainEnum.Choice.Under then
            uiContainer.ScoreTipsTitleNpcText_txt.text = TI18N(string.format("<color=%s>%s</color>", BargainConfig.Color.Red, self.bargainInfo.under_btn_desc))
        elseif v.npcChoice == BargainEnum.Choice.NoChoice then
            uiContainer.ScoreTipsTitleNpcText_txt.text = TI18N("未选择")
        end

        if v.playerChoice == BargainEnum.Choice.Up then
            uiContainer.ScoreTipsTitlePlayerText_txt.text = TI18N(string.format("<color=%s>%s</color>", BargainConfig.Color.Blue, self.bargainInfo.up_btn_desc))
        elseif v.playerChoice == BargainEnum.Choice.Under then
            uiContainer.ScoreTipsTitlePlayerText_txt.text = TI18N(string.format("<color=%s>%s</color>", BargainConfig.Color.Red, self.bargainInfo.under_btn_desc))
        elseif v.playerChoice == BargainEnum.Choice.NoChoice then
            uiContainer.ScoreTipsTitlePlayerText_txt.text = TI18N("未选择")
        end
        
        uiContainer.ScoreTipsTitleScoreText_txt.text = TI18N(v.playerScore)

        UtilsUI.SetActive(go, true)
    end

    UtilsUI.SetActive(self.ScoreTips, true)
end

function BargainMainWindowV2:InitDialog()
    self.subGroupId = BargainConfig.GetRandomSubGruodId(self.bargainInfo)
    UtilsUI.SetActive(self.Dialog, true)
end

function BargainMainWindowV2:InitChooseTimer()
    self.chooseTimer = BargainChooseTimer.New({self.PlayerUpChooseTimeSlider_sld, self.PlayerUnderChooseTimeSlider_sld})
end

function BargainMainWindowV2:InitBargainReady(playerId, npcId)
    self.BargainReadyNpcNameText_txt.text = TI18N(BargainConfig.GetNpcName(npcId))
    self.BargainReadyPlayerNameText_txt.text = mod.InformationCtrl:GetPlayerInfo().nick_name
end

function BargainMainWindowV2:SetMatchInfoText(scoreSum)
    if scoreSum > 0 then
        self.BargainScoreText_txt.text = string.format(BargainScore, BargainConfig.Color.Green, scoreSum)
    elseif scoreSum == 0 then
        self.BargainScoreText_txt.text = string.format(BargainScore, BargainConfig.Color.White, scoreSum)
    else
        self.BargainScoreText_txt.text = string.format(BargainScore, BargainConfig.Color.Red, scoreSum)
    end

    if self.bargainInfo.bargain_type == BargainEnum.Type.Shop then
        local discount = 1 + (scoreSum * self.bargainInfo.param / 10000)
        if not scoreSum or scoreSum == 0 then
            self.BargainScoreContentText_txt.text = BargainScoreContentTextShopFlat
        elseif discount < 1 then
            self.BargainScoreContentText_txt.text = string.format(BargainScoreContentTextShopAdv, 
            BargainConfig.Color.Green, 100 - discount * 100)
        else
            self.BargainScoreContentText_txt.text = string.format(BargainScoreContentTextShopDisAdv, 
            BargainConfig.Color.Red, discount * 100 - 100)
        end

    elseif self.bargainInfo.bargain_type == BargainEnum.Type.Trade then
        local discount = 1 + (scoreSum * self.bargainInfo.param / 10000)
        if not scoreSum or scoreSum == 0 then
            self.BargainScoreContentText_txt.text = BargainScoreContentTextTradeFlat
        elseif discount > 1 then
            self.BargainScoreContentText_txt.text = string.format(BargainScoreContentTextTradeAdv, 
            BargainConfig.Color.Green, discount * 100 - 100)
        else
            self.BargainScoreContentText_txt.text = string.format(BargainScoreContentTextTradeDisAdv, 
            BargainConfig.Color.Red, 100 - discount * 100)
        end
    elseif self.bargainInfo.bargain_type == BargainEnum.Type.Bargain then
        self.BargainScoreContentText_txt.text = string.format(BargainScoreContentTextBargain, self.bargainInfo.param)
    end
end

function BargainMainWindowV2:SetModelAnim(model, animState1, animState2, dialogInfo)
    local animPerformLayer = nil
    local animFaceLayer = nil
    local animLipLayer = nil
    local animInfo = nil
    local animState = nil
    if model == BargainEnum.Model.Npc then
        if animState1 == BargainEnum.AnimState1.Show then
            animInfo = BargainConfig.GetDialogAnim(dialogInfo.npc_show_anim)
        elseif animState1 == BargainEnum.AnimState1.Up then
            animInfo = BargainConfig.GetDialogAnim(dialogInfo.npc_up_anim)
        elseif animState1 == BargainEnum.AnimState1.Under then
            animInfo = BargainConfig.GetDialogAnim(dialogInfo.npc_under_anim)
        end

        if animState2 == BargainEnum.AnimState2.Start then
            animPerformLayer = {animInfo.perfrom_layer[1], animInfo.perfrom_layer[2]}
            animFaceLayer = {animInfo.face_layer[1], animInfo.face_layer[2]}
            animLipLayer = {animInfo.lip_layer[1], animInfo.lip_layer[2]}
        elseif animState2 == BargainEnum.AnimState2.End then
            animPerformLayer = {animInfo.perfrom_layer[3], "Stand1"}
            animFaceLayer = {animInfo.face_layer[3], "Empty_Face"}
            animLipLayer = {animInfo.lip_layer[3], "Empty_Lip"}
        elseif animState2 == BargainEnum.AnimState2.None then
            animPerformLayer = {"Stand1"}
            animFaceLayer = {"Empty_Face"}
            animLipLayer = {"Empty_Lip"}
        end
        animState = self.npcAnimState

    elseif model == BargainEnum.Model.Player then
        if animState1 == BargainEnum.AnimState1.Show then
            animInfo = BargainConfig.GetDialogAnim(dialogInfo.player_show_anim)
        elseif animState1 == BargainEnum.AnimState1.Up then
            animInfo = BargainConfig.GetDialogAnim(dialogInfo.player_up_anim)
        elseif animState1 == BargainEnum.AnimState1.Under then
            animInfo = BargainConfig.GetDialogAnim(dialogInfo.player_under_anim)
        end

        if animState2 == BargainEnum.AnimState2.Start then
            animPerformLayer = {animInfo.perfrom_layer[1], animInfo.perfrom_layer[2]}
            animFaceLayer = {animInfo.face_layer[1], animInfo.face_layer[2]}
            animLipLayer = {animInfo.lip_layer[1], animInfo.lip_layer[2]}
        elseif animState2 == BargainEnum.AnimState2.End then
            animPerformLayer = {animInfo.perfrom_layer[3], "Empty_Perform"}
            animFaceLayer = {animInfo.face_layer[3], "Empty_Face"}
            animLipLayer = {animInfo.lip_layer[3], "Empty_Lip"}
        elseif animState2 == BargainEnum.AnimState2.None then
            animPerformLayer = {"Empty_Perform"}
            animFaceLayer = {"Empty_Face"}
            animLipLayer = {"Empty_Lip"}
        end
        animState = self.playerAnimState

    end

    local animParam = BargainAnimState.CreateParam()
    BargainAnimState.ParamAddAnims(animParam, "Perform Layer", animPerformLayer)
    BargainAnimState.ParamAddAnims(animParam, "Face Layer", animFaceLayer)
    BargainAnimState.ParamAddAnims(animParam, "Lip Layer", animLipLayer)
    BargainAnimState.SetMainAnim(animParam, 1)

    -- 对口型 设置嘴部动作的延迟
    if animState2 == BargainEnum.AnimState2.Start then
        if model == BargainEnum.Model.Npc then
            if animState1 == BargainEnum.AnimState1.Up then
                if dialogInfo.npc_up_talktime and dialogInfo.npc_up_talktime ~= 0 then
                    BargainAnimState.SetLayerDelay(animParam, "Lip Layer", dialogInfo.npc_up_talktime, "Talk_Loop")
                end
            elseif animState1 == BargainEnum.AnimState1.Under then
                if dialogInfo.npc_under_talktime and dialogInfo.npc_under_talktime ~= 0 then
                    BargainAnimState.SetLayerDelay(animParam, "Lip Layer", dialogInfo.npc_under_talktime, "Talk_Loop")
                end
            end
        elseif model == BargainEnum.Model.Player then
            if animState1 == BargainEnum.AnimState1.Up then
                if dialogInfo.player_up_talktime and dialogInfo.player_up_talktime ~= 0 then
                    BargainAnimState.SetLayerDelay(animParam, "Lip Layer", dialogInfo.player_up_talktime, "Talk_Loop")
                end
            elseif animState1 == BargainEnum.AnimState1.Under then
                if dialogInfo.player_under_talktime and dialogInfo.player_under_talktime ~= 0 then
                    BargainAnimState.SetLayerDelay(animParam, "Lip Layer", dialogInfo.player_under_talktime, "Talk_Loop")
                end
            end
        end
    end

    animState:LoadAnimV2(animParam)
end

function BargainMainWindowV2:NpcDialogPlayInAnim()
    self.NpcDialog_anim:Play("UI_NpcDialog_in")
end

function BargainMainWindowV2:LoadAllDialogSound()
    local dialogSoundBankLoadList = BargainConfig.GetBargainSoundBank(self.subGroupId)
    local resList = {}
    for bankName, _ in pairs(dialogSoundBankLoadList) do
        table.insert(resList, {path = bankName, isSoundBank = true})
    end
    if #resList == 0 then
        self.soundIsReady = true
    else
        self.soundIsReady = false
        local cb = function()
            self.soundIsReady = true
            self:GameStart()
        end
        self.soundLoader = AssetMgrProxy.Instance:GetLoader("self.soundLoader")
        self.soundLoader:AddListener(cb)
        self.soundLoader:LoadAll(resList)
    end
end