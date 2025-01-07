StoryDialogPanel = BaseClass("StoryDialogPanel", BasePanel)

local AutoConfig = {
    AutoPaly = false
}

local DialogType = StoryConfig.DialogType
local DialogConfig = StoryConfig.DialogConfig

function StoryDialogPanel:__init()
    self.storyDialogManager = BehaviorFunctions.fight.storyDialogManager
    self:SetAsset("Prefabs/UI/Story/StoryDialogWindow.prefab")
    self.clientTimelineManager = BehaviorFunctions.fight.clientFight.clientTimelineManager
    self.bindingSetting = {}
    self.optionMap = {}
    self.dialogFileId = 0
    self.selectIndex = 0
end

function StoryDialogPanel:__delete()
    
end

function StoryDialogPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.hide)
    self.dialogUI = self.gameObject:GetComponent(DialogUI)
    self.dialogUI:SetAction(self:ToFunc("_SetDialogContent"), self:ToFunc("_DialogClipPause"))

    for i = 1, StoryConfig.MaxSelectCount, 1 do
        local optionInfo = self:PopUITmpObject("OptionButton",self.Options_rect)
        optionInfo.drapEvent = optionInfo.object:AddComponent(UIDragBehaviour)
        self.optionMap[i] = optionInfo
    end

    self.skipPos = self.SkipButton_rect.localPosition
end

function StoryDialogPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.ResumeByCloseWindow,self:ToFunc("ResumeByCloseWindow"))
    EventMgr.Instance:AddListener(EventName.PauseByOpenWindow,self:ToFunc("PauseByOpenWindow"))
end

function StoryDialogPanel:__BindListener()
    self.StateButton_btn.onClick:AddListener(self:ToFunc("OnClick_ChangePlayState"))
    self.ContentBG_btn.onClick:AddListener(self:ToFunc("OnClick_NextDialog"))
    self.SkipButton_btn.onClick:AddListener(self:ToFunc("OnClick_SkipDialog"))
    for i = 1, #self.optionMap do
        local function seletetCallBack()
            local selectId = StoryConfig.GetStoryOptions(self:GetCurId())[i][2]
            self.storyDialogManager:SelectCallBack(selectId)
            if selectId > 1000 then
                self.Options:SetActive(false)
                self:PlayDialog(selectId)
                return
            else
                self.isEnd = true
                if selectId ~= 0 then
                    self.storyDialogManager:BehaviorTrigger(selectId)
                end
                self:HidePanel()
            end
        end
        local option = self.optionMap[i]
        option.OptionButton_btn.onClick:AddListener(seletetCallBack)
        option.drapEvent.onPointerEnter = function ()
            self:EnterSelect(i)
        end
        option.drapEvent.onPointerExit = function ()
            self.optionMap[self.selectIndex].SelectBG:SetActive(false)
            self.optionMap[self.selectIndex].OptionBG:SetActive(true)
            self.optionMap[self.selectIndex].FunctionIcon_img.color = Color.white
            self.optionMap[self.selectIndex].OptionText_txt.color = Color.white
        end
    end
    local bgdragBehaviour = self.DropRange:AddComponent(UIDragBehaviour)
    local onbgBeginDrag = function(data)
		self:BGBeginDrag()
	end
	bgdragBehaviour.onBeginDrag = onbgBeginDrag
	local cbbgOnDrag = function(data)
		self:BGDrag(data)
	end
	bgdragBehaviour.onDrag = cbbgOnDrag

	local cbbgOnEndDrag = function(data)
		self:BGEndDrag()
	end
	bgdragBehaviour.onEndDrag = cbbgOnEndDrag
	
	local onbgDown = function(data)
		self:BGDown()
	end
	bgdragBehaviour.onPointerDown = onbgDown
	local onbgUp = function(data)
		self:BGUp()
	end
	bgdragBehaviour.onPointerUp = onbgUp
end

function StoryDialogPanel:__Hide()
    LuaTimerManager.Instance:RemoveTimer(self.delaySkipTimer)
end

function StoryDialogPanel:__Show()
    self.AutoBG:SetActive(not AutoConfig.AutoPaly)
    self.PlayingBG:SetActive(AutoConfig.AutoPaly)
    if AutoConfig.AutoPaly then
        self.StateText_txt.text = TI18N("播放中")
    else
        self.StateText_txt.text = TI18N("自动")
    end
end

function StoryDialogPanel:PlayDialogByMgr(dialogId, uniqueId)
    self.originalId = dialogId
    self.delaySkip = StoryConfig.SkipWaitTime
    self.SkipText_txt.text = self.delaySkip
    LuaTimerManager.Instance:RemoveTimer(self.delaySkipTimer)
    self.delaySkipTimer = LuaTimerManager.Instance:AddTimer(StoryConfig.SkipWaitTime, 1, function ()
        self.delaySkip = self.delaySkip - 1
        if self.delaySkip == 0 then
            self.SkipText_txt.text = TI18N("跳过")
        else
            self.SkipText_txt.text = self.delaySkip
        end
    end)

    self:PlayDialog(dialogId, uniqueId)
    local config = StoryConfig.GetStoryConfig(self.originalId)
    if self.storyDialogManager.ignoreSkipConfig then
        if config.type == DialogType.TipAside then
            UnityUtils.SetLocalPosition(self.SkipButton_rect, self.skipPos.x,self.skipPos.y - 60,self.skipPos.z)
        else
            UnityUtils.SetLocalPosition(self.SkipButton_rect, self.skipPos.x,self.skipPos.y,self.skipPos.z)
        end
    end
end

function StoryDialogPanel:PlayDialog(dialogId, uniqueId)
    self.uniqueId = uniqueId or self.uniqueId
    self.dialogFileId = dialogId
    local config = StoryConfig.GetStoryConfig(dialogId)
    if not config then
        LogError(string.format("没有在配置表中找到[%s]的配置", tostring(dialogId)))
        return
    end

    self.gameObject:SetActive(true)
    self.isPlaying = true
    self.isEnd = false

    if config.type == DialogType.TipAside 
    or config.type == DialogType.Animation then
        self.StateButton:SetActive(false)
    else
        self.StateButton:SetActive(true)
    end
    self.dialogUI.content.maxVisibleCharacters = 0;
    self.storyDialogManager:GetTimelineFile(dialogId)
    self:ShowSkipButton()
end

function StoryDialogPanel:ShowSkipButton()
    local config = StoryConfig.GetStoryConfig(self.originalId)
    local baseShow = config.type ~= DialogType.TipAside and not config.not_skip
    local selectShow = StoryConfig.GetStoryType(self:GetCurId()) ~= DialogType.Select
    local gmShow = self.storyDialogManager.ignoreSkipConfig

    if baseShow and selectShow or gmShow then
        self.SkipButton:SetActive(true)
    else
        self.SkipButton:SetActive(false)
    end
end

function StoryDialogPanel:SetBindingSetting(setting)
    self.bindingSetting = setting
end

function StoryDialogPanel:_SetDialogContent(dialogId)
    local config = StoryConfig.GetStoryConfig(dialogId)
    if not config then return end
    self.startTime = self.playableDirector.time
    self.curId = dialogId
    self.cancelPause = false
    local aside = config.talk_content
    if config.talk_name ~="" then
        local name = "<color=#FFEBA2>"..config.talk_name.."：</color>"
        --TODO 有大量字符串拼接,可以改到前处理
        aside = name..aside
    end
    self.dialogUI.aside.text = aside
    self.dialogUI.tipAside.text = aside
    self.dialogUI.talkName.text = config.talk_name
    self.dialogUI.content.text = config.talk_content
    if config.back_groud ~= "" or config.back_text ~= "" then
        self.BGNode:SetActive(true)
        self.BGContentText_txt.text = config.back_text
        if config.back_groud ~= "" then
            self.BGContent:SetActive(true)
            local callback = function ()
                self.DefaultBG:SetActive(false)
            end
            SingleIconLoader.Load(self.BGContent, config.back_groud, callback)
        else
            self.DefaultBG:SetActive(true)
            self.BGContent:SetActive(false)
        end
    else
        self.BGNode:SetActive(false)
    end
    self.Options:SetActive(false)
    self.storyDialogManager:PassCallBack(dialogId)
    self:ShowSkipButton()
end

function StoryDialogPanel:_DialogClipPause(dialogId)
    local config = StoryConfig.GetStoryConfig(dialogId)
    if config.type == DialogType.Select then
        self.clientTimelineManager:PauseDialogTrack()
        if self.selectIndex ~= 0 then
            self.optionMap[self.selectIndex].SelectBG:SetActive(false)
            self.optionMap[self.selectIndex].OptionBG:SetActive(true)
            self:EnterSelect(0)
        end
        self.Options:SetActive(true)
        for i = 1, #self.optionMap do
            local selectId = config.options[i] and config.options[i][2]
            self.optionMap[i].object:SetActive(true)
            self.optionMap[i].OptionText_txt.text = config.options[i] and config.options[i][1] or ""
            if selectId and selectId < 1000 and selectId ~= 0 then
                local isActive = self.storyDialogManager:CheckBehaviorTrigger(selectId)
                self.optionMap[i].object:SetActive(isActive or false)
                local iconPath = StoryConfig.GetTriggerIcon(selectId)
                SingleIconLoader.Load(self.optionMap[i].FunctionIcon, iconPath)
            elseif selectId then
                SingleIconLoader.Load(self.optionMap[i].FunctionIcon, StoryConfig.DefalutOptionIcon)
            else
                self.optionMap[i].object:SetActive(false)
            end
        end
    end
    if (config.type == DialogType.Common
    or config.type == DialogType.Specific)
    and AutoConfig.AutoPaly == false then
        if not self.cancelPause then
            self.clientTimelineManager:PauseDialogTrack()
        end
    end
end

function StoryDialogPanel:_TimelineEnd()
    if self.isEnd then return end
    local config = StoryConfig.GetStoryConfig(self:GetCurId())
    if config and config.type ~= DialogType.Select then
        if config.next_id <= 1000 then
            self.isEnd = true
            self.clientTimelineManager:StopDialogTrack()
            if config.next_id ~= 0 then
                self.storyDialogManager:BehaviorTrigger(config.next_id)
            end
            self:HidePanel()
        elseif config.next_id > 1000 then
            self:PlayDialog(config.next_id)
        end
    end
end

function StoryDialogPanel:OnClick_ChangePlayState()
    AutoConfig.AutoPaly = not AutoConfig.AutoPaly
    self.AutoBG:SetActive(not AutoConfig.AutoPaly)
    self.PlayingBG:SetActive(AutoConfig.AutoPaly)
    if AutoConfig.AutoPaly then
        self.StateText_txt.text = TI18N("播放中")
    else
        self.StateText_txt.text = TI18N("自动")
    end
    if StoryConfig.GetStoryType(self:GetCurId()) ~= DialogType.Select then
        self.clientTimelineManager:ContinueDialogTrack()
    end
end

function StoryDialogPanel:OnClick_NextDialog()
    if not self.curId then return end
    if self.dialogUI.canNext == false then return end
    local type = StoryConfig.GetStoryType(self:GetCurId())
    if type == DialogType.TipAside 
    or type == DialogType.AnimationAside then return end
    local pauseTime = self.dialogUI.pauseTime
    if self.dialogUI.isType then
        local time = self.startTime + pauseTime
        if AutoConfig.AutoPaly == true then
            local addTime
            local typeTime = self.dialogUI.unitTime * #self.dialogUI.content.text
            if typeTime > pauseTime then
                addTime = pauseTime
            else
                addTime = typeTime
            end
            time = self.startTime + addTime
        end
        return
        self.clientTimelineManager:JumpToTime(time)--如果处于打字中则跳转到打字结束或者暂停位置
    elseif self.playableDirector.time < self.startTime + pauseTime and not self.cancelPause then
        self.cancelPause = true;
        self.clientTimelineManager:JumpToTime(self.startTime + pauseTime)--如果打字结束但未暂停则跳转到暂停位置并取消本次暂停
        self:OnClickEffect()
    else
        self:OnClickEffect()
    end
    if type ~= DialogType.Select then
        self.clientTimelineManager:ContinueDialogTrack()
    end
end

function StoryDialogPanel:OnClick_SkipDialog()
    if self.delaySkip > 0 and not self.storyDialogManager.ignoreSkipConfig then
        return
    end
    local config = StoryConfig.GetStoryConfig(self:GetCurId())
    if StoryConfig.GetGroupAbstract(config.group_id) then
        PanelManager.Instance:OpenPanel(StoryAbstractPanel,{groupId = config.group_id})
        return
    end
    local targetId, fileId = StoryConfig.GetNextSelectId(self:GetCurId(), self.originalId)
    self.isEnd = true
    if not fileId then
        self.isSkip = true
        self:HidePanel()
        return
    elseif fileId ~= self.dialogFileId then
        self:PlayDialog(fileId)
    else
        self.isEnd = false
    end
    local targetTime = self.dialogUI:GetPauseTimeById(targetId)
    self.clientTimelineManager:JumpToTime(targetTime)
end

function StoryDialogPanel:SkipDialogByCommand()
    self.isEnd = true
    self.isSkip = true
    self:HidePanel()
end

function StoryDialogPanel:EnterSelect(index)
    if self.selectIndex ~= 0 then
        self.optionMap[self.selectIndex].Effect:SetActive(false)
        self.optionMap[self.selectIndex].FunctionIcon_img.color = Color.white
        self.optionMap[self.selectIndex].OptionText_txt.color = Color.white
    end
    self.selectIndex = index
    if index ~= 0 then
        self.optionMap[index].SelectBG:SetActive(true)
        self.optionMap[index].OptionBG:SetActive(false)
        self.optionMap[index].Effect:SetActive(true)
        UtilsUI.SetImageColor(self.optionMap[index].FunctionIcon_img, "#30373D")
        UtilsUI.SetTextColor(self.optionMap[index].OptionText_txt, "#2C3339")
    end
end

function StoryDialogPanel:OnClickEffect()
    if StoryConfig.GetStoryType(self:GetCurId()) == DialogType.Select then
        return
    end
    self.ArrowsGrounp_Click:SetActive(true)
    self.ArrowsGrounp_Click_sound:PlayButtonSound()
end

function StoryDialogPanel:BGBeginDrag()
    self:GetMainView().bgInput.x = 0
	self:GetMainView().bgInput.y = 0
end

function StoryDialogPanel:BGDrag(data)
    self:GetMainView().bgInput.x = data.delta.x
	self:GetMainView().bgInput.y = data.delta.y
    self.draging = true
end

function StoryDialogPanel:BGEndDrag()
    self:GetMainView().bgInput.x = 0
	self:GetMainView().bgInput.y = 0
end

function StoryDialogPanel:BGDown()
    self.draging = false
	Fight.Instance.clientFight.inputManager:KeyDown(FightEnum.KeyEvent.ScreenPress)
end

function StoryDialogPanel:BGUp()
	Fight.Instance.clientFight.inputManager:KeyUp(FightEnum.KeyEvent.ScreenPress)
    if not self.draging then
        self:OnClick_NextDialog()
    end
end

function StoryDialogPanel:PlayTimeline(obj, firstShow)
    self.playableDirector = self.clientTimelineManager:LoadDialogTrack(obj, self.dialogUI, true, self.bindingSetting)
    self.startTime = 0
    if firstShow then
        CustomUnityUtils.SetPlayableEndEvent(self.playableDirector, self:ToFunc("_TimelineEnd"))
    end
end

function StoryDialogPanel:PauseByOpenWindow()
    if self.isPlaying then
        self.gameObject:SetActive(false)
        --暂停对话
        if StoryConfig.GetStoryType(self:GetCurId()) ~= DialogType.Select then
            self.clientTimelineManager:PauseDialogTrack()
        end
    end
end

function StoryDialogPanel:ResumeByCloseWindow()
    if self.isPlaying then
        self.gameObject:SetActive(true)
        if StoryConfig.GetStoryType(self:GetCurId()) ~= DialogType.Select then
            self.clientTimelineManager:ContinueDialogTrack()
        end
    end
end

function StoryDialogPanel:HidePanel()
    LuaTimerManager.Instance:RemoveTimer(self.delaySkipTimer)
    self.isPlaying = false
    self.gameObject:SetActive(false)
    self.BGNode:SetActive(false)
    self.isHide = true
    self.dialogFileId = 0
    self.curId = nil
    self.bindingSetting = {}
    self.RootNode:SetActive(false)
    self.storyDialogManager:DialogEnd(self.isSkip, self.uniqueId)
    self.isSkip = false
end

function StoryDialogPanel:GetCurId()
    return self.curId or self.dialogFileId
end

function StoryDialogPanel:GetMainView()
    if self.fightMainUIView then
        return self.fightMainUIView
    else
        self.fightMainUIView = WindowManager.Instance:GetWindow("FightMainUIView")
        return self.fightMainUIView
    end
end
