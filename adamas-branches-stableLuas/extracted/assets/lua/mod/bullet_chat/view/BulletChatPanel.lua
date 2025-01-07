BulletChatPanel = BaseClass("BulletChatPanel", BaseWindow)

local _tinsert = table.insert
local _tremove = table.remove
local DataMeme = Config.DataMeme.Find

local BulletMoveSpeed = 126
local BulletSpacing = 72
local InputLimit = 10
local BulletStatrPos = 10

function BulletChatPanel:__init()
    self:SetAsset("Prefabs/UI/BulletChat/BulletChatPanel.prefab")
end

function BulletChatPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function BulletChatPanel:__BindListener()
    self.BulletChatToggle_tog.onValueChanged:AddListener(self:ToFunc("OnClickBulletChatToggle"))
    self.OpenBulletChatBarrageButton_btn.onClick:AddListener(self:ToFunc("OnClickOpenBulletChatBarrageButton"))

    self.OpenMainContentButton_drag = self.OpenMainContentButton:GetComponent(UIDragBehaviour)
    self.OpenMainContentButton_drag.onPointerClick = self:ToFunc("OnClickOpenMainContentButton")

    self.CloseMainContentButton_drag = self.CloseMainContentButton:GetComponent(UIDragBehaviour)
    self.CloseMainContentButton_drag.onPointerClick = self:ToFunc("OnClickCloseMainContentButton")

    self.CloseInputContentButton_drag = self.CloseInputContentButton:GetComponent(UIDragBehaviour)
    self.CloseInputContentButton_drag.onPointerClick = self:ToFunc("OnClickCloseInputContentButton")

    self.FontButtons_btn.onClick:AddListener(self:ToFunc("OnClickFontButtons"))
    self.EmoteButtons_btn.onClick:AddListener(self:ToFunc("OnClickEmoteButtons"))
    self.CloseBulletChatBarrageOpenBackGroundButton_btn.onClick:AddListener(self:ToFunc("OnClickCloseBulletChatBarrageOpenBackGroundButton"))

    self.BulletChatInputField_input = self.BulletChatInputField:GetComponent(TMP_InputField)
    self.BulletChatInputField_input.onValueChanged:AddListener(self:ToFunc("OnInputFieldValueChange"))
    self.BulletChatInputField_input.onSelect:AddListener(self:ToFunc("OnInputFieldSelect"))
    self.BulletChatInputField_input.onDeselect:AddListener(self:ToFunc("OnInputFieldDeselect"))
    self.BulletChatInputField_input.characterLimit = InputLimit

    self.BulletChatInputField_drag = self.BulletChatInputField:GetComponent(UIDragBehaviour)
    self.BulletChatInputField_drag.onPointerEnter = self:ToFunc("OnMouseEnterBulletChatInputField")
    self.BulletChatInputField_drag.onPointerExit = self:ToFunc("OnMouseExitBulletChatInputField")

    self.FireBulletChatBarrageButton_btn.onClick:AddListener(self:ToFunc("OnClickFireBulletChatBarrageButton"))

    self.ShareButton_btn.onClick:AddListener(self:ToFunc("OnClickShareButton"))
end

function BulletChatPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.CheckBullet, self:ToFunc("CheckBullet"))
    EventMgr.Instance:AddListener(EventName.FireBulletSuccess, self:ToFunc("FireBulletSuccess"))
    EventMgr.Instance:AddListener(EventName.BulletPause, self:ToFunc("BulletPause"))
    EventMgr.Instance:AddListener(EventName.BulletRestore, self:ToFunc("BulletRestore"))
    EventMgr.Instance:AddListener(EventName.BulletEnterShare, self:ToFunc("BulletEnterShare"))
    EventMgr.Instance:AddListener(EventName.BulletExitShare, self:ToFunc("BulletExitShare"))
    
end

function BulletChatPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.CheckBullet, self:ToFunc("CheckBullet"))
    EventMgr.Instance:RemoveListener(EventName.FireBulletSuccess, self:ToFunc("FireBulletSuccess"))
    EventMgr.Instance:RemoveListener(EventName.BulletPause, self:ToFunc("BulletPause"))
    EventMgr.Instance:RemoveListener(EventName.BulletRestore, self:ToFunc("BulletRestore"))
    EventMgr.Instance:RemoveListener(EventName.BulletEnterShare, self:ToFunc("BulletEnterShare"))
    EventMgr.Instance:RemoveListener(EventName.BulletExitShare, self:ToFunc("BulletExitShare"))

    for k, v in pairs(self.waitTimerGroup) do
        mod.BulletChatCtrl:RemoveTimer(v)
    end

    for i = 1, #self.bulletTrackGroup, 1 do
        self.bulletTrackGroup[i].trackTween:Kill()
    end

    self:ClearMainAutoCloseTimer()
    self:ClearExtendAutoCloseTimer()
end

function BulletChatPanel:__Create()
    self.poolsTransform = self.Pools.transform
end

function BulletChatPanel:__Show()
    EventMgr.Instance:Fire(EventName.OpenSkipStoryKeyCode)
    self:InitFontColor()
    self:InitEmote()
    self:InitPools()
end

function BulletChatPanel:InitFontColor()
    self.colorsInfo = BulletChatConfig.GetColorConfig()
    self.colorItemList = {}

    for k, v in pairs(self.colorsInfo) do
        local color = v.color
        local imgPath = v.image
        
        local go = GameObject.Instantiate(self.ColorItem, self.FontColorScrollContent.transform)
        local cont = UtilsUI.GetContainerObject(go)
        cont.gameObject = go
        cont.transform = go.transform
        cont.id = v.id
        cont.color = color
        SingleIconLoader.Load(cont.ColorItemButton, imgPath)
        UtilsUI.SetActive(go, true)

        _tinsert(self.colorItemList, cont)
    end

    self.curSelectColor = {index = 1, color = self.colorItemList[1].color}
    UtilsUI.SetActive(self.colorItemList[1].ColorItemSelect, true)

    for i, v in ipairs(self.colorItemList) do
        local button = v.ColorItemButton_btn
        local color = v.color
        local index = i
        button.onClick:AddListener(function ()
            if self.curSelectColor.index == index then
                return
            end
            UtilsUI.SetActive(self.colorItemList[self.curSelectColor.index].ColorItemSelect, false)
            self.curSelectColor.index = index
            self.curSelectColor.color = color
            UtilsUI.SetActive(self.colorItemList[index].ColorItemSelect, true)
        end)
    end
end

function BulletChatPanel:InitEmote()
    local memeList = mod.FriendCtrl:GetMemeList()
    self.memeGroup = {}
    self.EmoteVerticalItemScrollList = {}
    for memeId, _ in pairs(memeList) do
        local memeInfo = FriendConfig.GetMemeInfoByMemeId(memeId)
        if not self.memeGroup[memeInfo.group] then
            self.memeGroup[memeInfo.group] = {}
        end

        _tinsert(self.memeGroup[memeInfo.group], memeId)
    end


    local i = 0
    for k, v in pairs(self.memeGroup) do
        local groupId = k
        local memeList = v
        local memeGroupInfo = FriendConfig.GetMemeGroudInfoByGroupId(groupId)
        local go = GameObject.Instantiate(self.EmoteHorizontalItem, self.EmoteHorizontalScrollContent_rect)
        local cont = UtilsUI.GetContainerObject(go)
        self.memeGroup[k].Item = cont

        SingleIconLoader.Load(cont.EmoteItemImg, memeGroupInfo.meme)
        UtilsUI.SetActive(go, true)
        cont.EmoteHorizontalItem_btn.onClick:AddListener(function ()
            if self.curShowEmoteGroup == groupId then
                return
            end
            if not self.EmoteVerticalItemScrollList[groupId] then
                self:InitEmoteVerticalItemScroll(groupId)
            end

            UtilsUI.SetActive(self.EmoteVerticalItemScrollList[self.curShowEmoteGroup].gameObject, false)
            UtilsUI.SetActive(self.memeGroup[self.curShowEmoteGroup].Item.ItemSelectBack, false)

            UtilsUI.SetActive(self.EmoteVerticalItemScrollList[groupId].gameObject, true)
            UtilsUI.SetActive(self.memeGroup[groupId].Item.ItemSelectBack, true)
            self.curShowEmoteGroup = groupId
        end)

        if i == 0 then
            self:InitEmoteVerticalItemScroll(groupId)
            self.curShowEmoteGroup = groupId
            UtilsUI.SetActive(self.EmoteVerticalItemScrollList[groupId].gameObject, true)
            UtilsUI.SetActive(self.memeGroup[groupId].Item.ItemSelectBack, true)
        end
        i = i + 1
    end
end

function BulletChatPanel:InitEmoteVerticalItemScroll(groupId)
    local go = GameObject.Instantiate(self.EmoteVerticalItemScroll, self.EmoteContent_rect)
    local cont = UtilsUI.GetContainerObject(go)
    cont.gameObject = go

    local memeList = self.memeGroup[groupId]

    for _, v in ipairs(memeList) do
        local memeId = v
        local memeInfo = FriendConfig.GetMemeInfoByMemeId(memeId)
        local memeGo = GameObject.Instantiate(cont.EmoteItem, cont.EmoteVerticalItemScrollContent_rect)
        local memeCont = UtilsUI.GetContainerObject(memeGo)
        SingleIconLoader.Load(memeCont.EmoteItemImg, memeInfo.meme)
        UtilsUI.SetActive(memeGo, true)
        memeCont.ItemBack_btn.onClick:AddListener(function ()
            --11111100 
            -- r g b 表示颜色 a 表示是否为图片
            if not self.fireBullteCoolTimer then
                mod.BulletChatCtrl:SendBullteChat(memeId, BulletChatEnum.EmoteColor)
            end
        end)
    end

    self.EmoteVerticalItemScrollList[groupId] = cont
end

function BulletChatPanel:InitPools()
    self.bulletChatItemPool = {}
end

function BulletChatPanel:InitBullet()
    self.bulletTrackGroup = {true, true, true, true, true}
    local curTime = mod.BulletChatCtrl:GetStoryTime()

    for i = 1, 5 do
        self.bulletTrackGroup[i] = {
            trackTrans = self["Track" .. i].transform,
            trackTween = DOTween.Sequence(),
            nextTime = curTime,
        }
        self.bulletTrackGroup[i].trackTween:SetEase(Ease.Linear)
    end

    self.bulletOverdueTime = Config.DataCommonCfg.Find["BulletChatOverdue"].int_val
    self.sceneWidth = self.Tracks_rect.rect.width

    self.waitTimerGroup = {}
    self.startWaitIndex = 0
end

function BulletChatPanel:__ShowComplete()
    self:InitBullet()
    self:StartBullet()

    local bulletChatToggleDefaultState = PlayerPrefs.GetInt("BulletChatToggle", 1)
    if bulletChatToggleDefaultState == 1 then
        self.BulletChatToggle_tog.isOn = true
    else
        self.BulletChatToggle_tog.isOn = false
    end

    self.InputFieldLimitText_txt.text = string.format("0/%d", InputLimit)

    self:OnClickOpenMainContentButton()
end

function BulletChatPanel:StartBullet()
    self:CheckBullet()
end

function BulletChatPanel:CheckBullet()
    local curTime = mod.BulletChatCtrl:GetStoryTime()

    for trackIndex, bulletTrack in ipairs(self.bulletTrackGroup) do
        if bulletTrack.nextTime < curTime then
            while true do
                local bullteInfo, isSelf = mod.BulletChatCtrl:TryGetBullte()
                if not bullteInfo then
                    --没有后置弹幕 也不必检查了
                    return
                end             
                if (curTime - bullteInfo.second) < self.bulletOverdueTime then
                    --没有超时
                    self:AddBullet(trackIndex, bullteInfo, curTime, isSelf)
                    break
                end
            end
        end
    end 
end

function BulletChatPanel:AddBullet(trackIndex, bullteInfo, curTime, isSelf)
    local bulletTrack = self.bulletTrackGroup[trackIndex]
    local bulletItem = self:PopBulletChatItem()
    bulletItem.transform:SetParent(bulletTrack.trackTrans)
    UnityUtils.SetAnchoredPosition(bulletItem.transform, BulletStatrPos, 0)
    local bullteItemWidth
    if bullteInfo.type == BulletChatEnum.Type.Text then
        --文本弹幕
        bulletItem.BulletChatItemText_txt.text = bullteInfo.text
        local res, color = ColorUtility.TryParseHtmlString(bullteInfo.color)
        if res then
            bulletItem.BulletChatItemText_txt.color = color
        else
            LogError(string.format("颜色错误 %s", bullteInfo.color))
        end
        if isSelf then
            UtilsUI.SetActive(bulletItem.BoxText, true)
        end
        UtilsUI.SetActive(bulletItem.BulletChatItemText, true)
        LayoutRebuilder.ForceRebuildLayoutImmediate(bulletItem.BulletChatItemText_rect);
        bullteItemWidth = bulletItem.BulletChatItemText_rect.rect.width

    else
        --表情弹幕
        local memeInfo = FriendConfig.GetMemeInfoByMemeId(bullteInfo.memeId)
        SingleIconLoader.Load(bulletItem.BulletChatItemImg, memeInfo.meme)
        UtilsUI.SetActive(bulletItem.BulletChatItemImg, true)
        bullteItemWidth = bulletItem.BulletChatItemImg_rect.rect.width

        if isSelf then
            UtilsUI.SetActive(bulletItem.BoxIcon, true)
        end
    end
    local bulletItemMoveDis = (self.sceneWidth + bullteItemWidth + BulletStatrPos)
    local bulletItemMoveTime = bulletItemMoveDis / BulletMoveSpeed

    --设置移动
    local tween = bulletItem.transform:DOLocalMoveX(-(self.sceneWidth + bullteItemWidth), bulletItemMoveTime)
    bulletTrack.trackTween:Append(tween)
    tween:SetEase(Ease.Linear)

    local waitTime = (bullteItemWidth + BulletSpacing + BulletStatrPos) / BulletMoveSpeed

    bulletTrack.nextTime = curTime + waitTime

    local s1 = self.startWaitIndex
    self.startWaitIndex = self.startWaitIndex + 1
    self.waitTimerGroup[s1] = mod.BulletChatCtrl:AddTimer(1, waitTime, function ()
        EventMgr.Instance:Fire(EventName.CheckBullet)
        self.waitTimerGroup[s1] = nil
    end)

    local s2 = self.startWaitIndex
    self.startWaitIndex = self.startWaitIndex + 1
    self.waitTimerGroup[s2] = mod.BulletChatCtrl:AddTimer(1, bulletItemMoveTime + 1, function ()
        self:PushBulletChatItem(bulletItem)
        self.waitTimerGroup[s2] = nil
        tween:Kill()
    end)

    --LogInfo(string.format("轨道:%d 弹幕:%s 冷却时间:%f", trackIndex, bullteInfo.text, waitTime))
end

function BulletChatPanel:BulletPause()
    for index, bulletTrack in pairs(self.bulletTrackGroup) do
        --bulletTrack.trackTween:Pause()
        DOTween.PauseAll()
    end
end

function BulletChatPanel:BulletRestore()
    for index, bulletTrack in pairs(self.bulletTrackGroup) do
        --bulletTrack.trackTween:Play()
        DOTween.PlayAll()
    end
end

function BulletChatPanel:PushBulletChatItem(uiCont)
    _tinsert(self.bulletChatItemPool, uiCont)
    uiCont.transform:SetParent(self.poolsTransform)

    UtilsUI.SetActive(uiCont.BulletChatItemText, false)
    UtilsUI.SetActive(uiCont.BulletChatItemImg, false)
    UtilsUI.SetActive(uiCont.BoxText, false)
    UtilsUI.SetActive(uiCont.BoxIcon, false)
end

function BulletChatPanel:PopBulletChatItem()
    local length = #self.bulletChatItemPool
    if length < 1 then
        local go = GameObject.Instantiate(self.BulletChatItem, self.poolsTransform)
        local c = UtilsUI.GetContainerObject(go)
        c.gameObject = go
        c.transform = go.transform
        UtilsUI.SetActive(go, true)
        return c
    end

    local c = self.bulletChatItemPool[length]
    _tremove(self.bulletChatItemPool)
    return c
end

function BulletChatPanel:OnClickBulletChatToggle(isEnter)
    if isEnter then
        PlayerPrefs.SetInt("BulletChatToggle", 1)
        UtilsUI.SetActive(self.Tracks, true)
    else
        PlayerPrefs.SetInt("BulletChatToggle", 0)
        UtilsUI.SetActive(self.Tracks, false)
    end

    self:SetMainAutoCloseTimer()
end

function BulletChatPanel:OnClickOpenMainContentButton()
    self:SetMainContent(true)

    self:SetMainAutoCloseTimer()
end

function BulletChatPanel:OnClickCloseMainContentButton()
    self:SetMainContent(false)

    self:ClearMainAutoCloseTimer()
end

function BulletChatPanel:OnClickOpenBulletChatBarrageButton()
    self:SetMainContent(false)
    self:SetBulletChatBarrage(true)

    self:SetMainAutoCloseTimer()
end

function BulletChatPanel:OnClickCloseInputContentButton()
    self:SetBulletChatBarrage(false)

    self:ClearMainAutoCloseTimer()
    self:ClearExtendAutoCloseTimer()
end

function BulletChatPanel:OnClickFontButtons()
    self:SetBulletChatBarrage(true, true, true)

    self:SetExtendAutoCloseTimer()
end

function BulletChatPanel:OnClickEmoteButtons()
    self:SetBulletChatBarrage(true, true, false)

    self:SetExtendAutoCloseTimer()
end

function BulletChatPanel:OnInputFieldValueChange(str)
    local len = UtilsBase.utf8len(str)
    self.InputFieldLimitText_txt.text = string.format("%d/%d", len, InputLimit)
    if not self.fireBullteCoolTimer then
        if len < 1 then
            UtilsUI.SetActive(self.FireBulletChatBarrageButton, false)
            UtilsUI.SetActive(self.UnableFireBulletChatBarrageButton, true)
        else
            UtilsUI.SetActive(self.FireBulletChatBarrageButton, true)
            UtilsUI.SetActive(self.UnableFireBulletChatBarrageButton, false)
        end
    end
end

function BulletChatPanel:OnInputFieldSelect(str)
    --LogInfo("开始输入")
    EventMgr.Instance:Fire(EventName.CloseSkipStoryKeyCode)
end

function BulletChatPanel:OnInputFieldDeselect(str)
    --LogInfo("结束输入")
    EventMgr.Instance:Fire(EventName.OpenSkipStoryKeyCode)
end

function BulletChatPanel:OnClickFireBulletChatBarrageButton()
    if not self.fireBullteCoolTimer then
        local str = self.BulletChatInputField_input.text
        if str == "" then
            return
        end
        local result = mod.BulletChatCtrl:SendBullteChat(str, BulletChatConfig.ColorStringConvertColorInt(self.curSelectColor.color))
        self.BulletChatInputField_input.text = ""
    end
end

function BulletChatPanel:OnClickCloseBulletChatBarrageOpenBackGroundButton()
    self:CloseBulletExtendPanel()
end

function BulletChatPanel:OnClickShareButton()
    mod.BulletChatCtrl:OnOpenSharePanel()
end

function BulletChatPanel:FireBulletSuccess()
    UtilsUI.SetActive(self.FireBulletChatBarrageButton, false)
        UtilsUI.SetActive(self.UnableFireBulletChatBarrageButton, true)

        local i = mod.BulletChatCtrl.bulletChatInterval
        self.UnableFireBulletChatBarrageButtonText_txt.text = string.format(TI18N("%d秒"), i)
        
        self.fireBullteCoolTimer = mod.BulletChatCtrl:AddTimer(0, 1, function ()
            if mod.BulletChatCtrl:IsPause() then
                return
            end
            i = i - 1
            if i == 0 then
                self.UnableFireBulletChatBarrageButtonText_txt.text = TI18N("发送")

                local str = self.BulletChatInputField_input.text
                if str ~= "" then
                    UtilsUI.SetActive(self.FireBulletChatBarrageButton, true)
                    UtilsUI.SetActive(self.UnableFireBulletChatBarrageButton, false)
                end
                mod.BulletChatCtrl:RemoveTimer(self.fireBullteCoolTimer)
                self.fireBullteCoolTimer = nil
            else
                self.UnableFireBulletChatBarrageButtonText_txt.text = string.format(TI18N("%d秒"), i)
            end
        end)
end

function BulletChatPanel:SetMainContent(isOpen)
    if isOpen then
        UtilsUI.SetActive(self.MainContent, true)
        UtilsUI.SetActive(self.OpenMainContentButton, false)
    else
        UtilsUI.SetActive(self.MainContent, false)
        UtilsUI.SetActive(self.OpenMainContentButton, true)
    end
end

function BulletChatPanel:SetBulletChatBarrage(isOpen, isOpenExtend, isOpenColor)
    self:SetFontColorSetting(false)
    self:SetEmoteSetting(false)

    if not isOpen then
        UtilsUI.SetActive(self.InputContent, false)
        UtilsUI.SetActive(self.BulletChatBarrage, false)
        UtilsUI.SetActive(self.BulletChatBarrageOpenBackGround, false)
        UtilsUI.SetActive(self.OpenMainContentButton, true)
        self.openExtend = false
        return
    end
    UtilsUI.SetActive(self.InputContent, true)
    UtilsUI.SetActive(self.BulletChatBarrage, true)
    UtilsUI.SetActive(self.OpenMainContentButton, false)

    if not isOpenExtend then
        UtilsUI.SetActive(self.BulletChatBarrageOpenBackGround, false)
        local pos = self.BulletChatBarrageClosePos_rect.anchoredPosition
        UnityUtils.SetAnchoredPosition(self.BulletChatBarrage_rect, pos.x, pos.y)
        self.openExtend = false
        return
    end
    self.openExtend = true

    UtilsUI.SetActive(self.BulletChatBarrageOpenBackGround, true)
    local pos = self.BulletChatBarrageOpenPos_rect.anchoredPosition
    UnityUtils.SetAnchoredPosition(self.BulletChatBarrage_rect, pos.x, pos.y)

    if isOpenColor then
        UtilsUI.SetActive(self.FontColorContent, true)
        UtilsUI.SetActive(self.EmoteContent, false)
        self:SetFontColorSetting(true)
        self:SetEmoteSetting(false)
    else
        UtilsUI.SetActive(self.FontColorContent, false)
        UtilsUI.SetActive(self.EmoteContent, true)
        self:SetFontColorSetting(false)
        self:SetEmoteSetting(true)
    end
end

function BulletChatPanel:SetFontColorSetting(isOpen)
    if isOpen then
        UtilsUI.SetActive(self.FontOnOpenImg, true)
    else
        UtilsUI.SetActive(self.FontOnOpenImg, false)
    end
end

function BulletChatPanel:SetEmoteSetting(isOpen)
    if isOpen then
        UtilsUI.SetActive(self.EmoteOnOpenImg, true)
    else
        UtilsUI.SetActive(self.EmoteOnOpenImg, false)
    end
end

function BulletChatPanel:CloseBulletExtendPanel()
    self:SetMainContent(false)
    self:SetBulletChatBarrage(true)

    self:SetMainAutoCloseTimer()
end

function BulletChatPanel:CloseMainBulletPanel()
    self:SetMainContent(false)
    self:SetBulletChatBarrage(false)
end

function BulletChatPanel:OnMouseEnterBulletChatInputField(data)
    self:ClearExtendAutoCloseTimer()
    self:ClearMainAutoCloseTimer()
end

function BulletChatPanel:OnMouseExitBulletChatInputField(data)
    if self.openExtend then
        self:SetExtendAutoCloseTimer()
    else
        self:SetMainAutoCloseTimer()
    end
end

function BulletChatPanel:SetMainAutoCloseTimer()
    self:ClearMainAutoCloseTimer()
    self.autoCloseMainPanelTimer = mod.BulletChatCtrl:AddTimer(1, 5, self:ToFunc("CloseMainBulletPanel"))

    self:ClearExtendAutoCloseTimer()
end

function BulletChatPanel:ClearMainAutoCloseTimer()
    if self.autoCloseMainPanelTimer then
        mod.BulletChatCtrl:RemoveTimer(self.autoCloseMainPanelTimer)
        self.autoCloseMainPanelTimer = nil
    end
end

function BulletChatPanel:SetExtendAutoCloseTimer()
    self:ClearMainAutoCloseTimer()

    self:ClearExtendAutoCloseTimer()
    self.autoCloseBulletExtendTimer = mod.BulletChatCtrl:AddTimer(1, 5, self:ToFunc("CloseBulletExtendPanel"))
end

function BulletChatPanel:ClearExtendAutoCloseTimer()
    if self.autoCloseBulletExtendTimer then
        mod.BulletChatCtrl:RemoveTimer(self.autoCloseBulletExtendTimer)
        self.autoCloseBulletExtendTimer = nil
    end
end

function BulletChatPanel:BulletEnterShare()
    self:OnClickCloseMainContentButton()
end

function BulletChatPanel:BulletExitShare()
    self:OnClickOpenMainContentButton()
end