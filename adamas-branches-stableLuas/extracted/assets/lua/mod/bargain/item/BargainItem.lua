BargainItem = BaseClass("BargainItem", Module)

function BargainItem:__init()
    
end

function BargainItem:__delete()
    
end

function BargainItem:SetFace(uiContainer, playerChoice, npcChoice, bargainInfo, playerId, npcId)
    self.container = uiContainer
    self.bargainInfo = bargainInfo
    self.scoreInfo = BargainConfig.GetBargainScore(playerChoice, npcChoice)

    if playerChoice == BargainEnum.Choice.Up then
        UtilsUI.SetActive(uiContainer.PlayerUp, true)
        self.playerFace = UtilsUI.GetContainerObject(uiContainer.PlayerUp)
        self.playerFace.StateText_txt.text = string.format(TI18N("玩家%s"), self.bargainInfo.up_btn_desc)
    elseif playerChoice == BargainEnum.Choice.Under then
        UtilsUI.SetActive(uiContainer.PlayerUnder, true)
        self.playerFace = UtilsUI.GetContainerObject(uiContainer.PlayerUnder)
        self.playerFace.StateText_txt.text = string.format(TI18N("玩家%s"), self.bargainInfo.under_btn_desc)
    end
    self:SetNumText(self.playerFace.StateNum_txt, self.scoreInfo.player_score)

    if npcChoice == BargainEnum.Choice.Up then
        UtilsUI.SetActive(uiContainer.NpcUp, true)
        self.npcFace = UtilsUI.GetContainerObject(uiContainer.NpcUp)
        self.npcFace.StateText_txt.text = string.format("NPC%s", self.bargainInfo.up_btn_desc)
    elseif npcChoice == BargainEnum.Choice.Under then
        UtilsUI.SetActive(uiContainer.NpcUnder, true)
        self.npcFace = UtilsUI.GetContainerObject(uiContainer.NpcUnder)
        self.npcFace.StateText_txt.text = string.format("NPC%s", self.bargainInfo.under_btn_desc)
    end
    self:SetNumText(self.npcFace.StateNum_txt, self.scoreInfo.npc_score)

    self:SetIcon(playerId, npcId)
end

function BargainItem:SetNumText(txt, score)
    if score == 0 then
        txt.text = string.format("<color=%s>%d</color>", BargainConfig.Color.White, score)
    elseif score > 0 then
        txt.text = string.format("<color=%s>%d</color>", BargainConfig.Color.Green, score)
    else
        txt.text = string.format("<color=%s>%d</color>", BargainConfig.Color.Red, score)
    end
end

function BargainItem:SetIcon(playerId, npcId)
    SingleIconLoader.Load(self.container.GroupPlayerIcon, BargainConfig.GetPlayerIconByPlayerId(playerId))
    SingleIconLoader.Load(self.container.GroupNpcIcon, BargainConfig.GetNpcIconByNpcId(npcId))
end

function BargainItem:Select()
    UtilsUI.SetActive(self.container.Selected, true)
    UtilsUI.SetActive(self.container.GroupMask, false)
end

function BargainItem:PlayerSelect()
    UtilsUI.SetActive(self.container.GroupPlayerSmall, true)
end

function BargainItem:NpcSelect()
    UtilsUI.SetActive(self.container.GroupNpcSmall, true)
end

function BargainItem:Mask()
    UtilsUI.SetActive(self.container.Selected, false)
    UtilsUI.SetActive(self.container.GroupMask, true)
end

function BargainItem:Reset()
    UtilsUI.SetActive(self.container.Selected, false)
    UtilsUI.SetActive(self.container.GroupMask, false)

    UtilsUI.SetActive(self.container.GroupPlayerSmall, false)
    UtilsUI.SetActive(self.container.GroupNpcSmall, false)
end

function BargainItem:OnReset()
    self.container = nil
    self.bargainInfo = nil
    self.scoreInfo = nil
end