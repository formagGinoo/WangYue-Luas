StoryDialogPanelV2 = BaseClass("StoryDialogPanelV2", BasePanel, SystemView)

local Null = ""

local AutoConfig = {
    AutoPaly = false
}
local CtrlMode =
{
    Default = 1,
    Explore = 2,
}

local ExploreBarColor = 
{
    [StoryConfig.ExploreBarState.Default] = "#ffffff",
    [StoryConfig.ExploreBarState.Yellow] = "#f4cc43",
    [StoryConfig.ExploreBarState.Blue] = "#27feb0",
}

local unitTime;

function StoryDialogPanelV2:__init()
    self:SetAsset("Prefabs/UI/Story/StoryDialogWindow.prefab")
    self.optionMap = {}
    self.specialOptionMap = {}
    self.index2Option = {}
    self.key2Index = {}
    self.ctrlMode = CtrlMode.Default
end

function StoryDialogPanelV2:__CacheObject()
    self.dialogUI = self.gameObject:GetComponent(DialogUI)
    unitTime = self.dialogUI.unitTime
    
    --创建普通选项
    for i = 1, StoryConfig.MaxSelectCount, 1 do
        local optionInfo = self:PopUITmpObject("OptionButton",self.NormalOptions_rect)
        self.optionMap[i] = optionInfo
    end

    for i = 1, StoryConfig.MaxSelectCount, 1 do
        local objInfo = self:PopUITmpObject("SpecialBtn",self.SpecialOptions_rect)
        self.specialOptionMap[i] = objInfo
    end

    self.skipPos = self.SkipButton_rect.localPosition
    self.PhoenHeadPos = self.PhoneHead_rect.localPosition
    self.exploreBarWidth = self.ClueRoot_rect.sizeDelta.x

    self:AddSystemState(SystemStateConfig.StateType.Story)
end

function StoryDialogPanelV2:__BindListener()
    self.StateButton_btn.onClick:AddListener(self:ToFunc("OnClick_ChangePlayState"))
    self.ContentBG_btn.onClick:AddListener(self:ToFunc("OnClick_NextDialog"))
    self.SkipButton_btn.onClick:AddListener(self:ToFunc("OnClick_SkipDialog"))
    self.DefaultButton_btn.onClick:AddListener(self:ToFunc("OnClick_PlayPhoneDialog"))

    self.BackOffBtn_drag.onPointerDown = self:ToFunc("OnClick_BackOffBtn")
    self.AdvancePlay_drag.onPointerDown = self:ToFunc("OnClick_AdvancePlay")
    self.BackOffBtn_drag.onPointerUp = self:ToFunc("ExploreBtnUp")
    self.AdvancePlay_drag.onPointerUp = self:ToFunc("ExploreBtnUp")
    self.ExploreBack1_btn.onClick:AddListener(self:ToFunc("OnClick_SkipExplore"))
    self.CurPosSld_sld.onValueChanged:AddListener(self:ToFunc("PosChanged"))

    UtilsUI.SetInputImageChanger(self.PcIconA)
    UtilsUI.SetInputImageChanger(self.PcIconD)

    for i = 1, #self.optionMap do
        local option = self.optionMap[i]
        local select = function ()
            self:SelectOption(i)
        end
        option.OptionButton_btn.onClick:AddListener(select)
        option.OptionButton_drag.onPointerEnter = function ()
            self:EnterSelect(i)
        end
        option.OptionButton_drag.onPointerExit = function ()
            self:ExitSelect(i)
        end
    end

    for i = 1, StoryConfig.MaxSelectCount, 1 do
        local option = self.specialOptionMap[i]
        option.Button_btn.onClick:AddListener(function()
            option._uianim:PlayExitAnimator()
        end)
        UtilsUI.SetHideCallBack(option._uianim.HideNode, function()
            self:SelectOption(i)
        end)
    end

    local bgdragBehaviour = self.DropRange:AddComponent(UIDragBehaviour)
	bgdragBehaviour.onBeginDrag = self:ToFunc("BGBeginDrag")
	bgdragBehaviour.onDrag = self:ToFunc("BGDrag")
	bgdragBehaviour.onEndDrag = self:ToFunc("BGEndDrag")
	bgdragBehaviour.onPointerDown = self:ToFunc("BGDown")
	bgdragBehaviour.onPointerUp = self:ToFunc("BGUp")

    self.ExploreBg_drag.onBeginDrag = self:ToFunc("BGBeginDrag")
	self.ExploreBg_drag.onDrag = self:ToFunc("BGDrag")
	self.ExploreBg_drag.onEndDrag = self:ToFunc("BGEndDrag")
	self.ExploreBg_drag.onPointerDown = self:ToFunc("BGDown")
	self.ExploreBg_drag.onPointerUp = self:ToFunc("BGUp")
end

function StoryDialogPanelV2:__BindEvent()
    EventMgr.Instance:AddListener(EventName.UpdateOptionContent,self:ToFunc("UpdateOptionContent"))
    EventMgr.Instance:AddListener(EventName.ClipEnter,self:ToFunc("SetDialogContent"))
    EventMgr.Instance:AddListener(EventName.ClipPause,self:ToFunc("DialogClipPause"))
    EventMgr.Instance:AddListener(EventName.BulletEnterShare,self:ToFunc("BulletEnterShare"))
    EventMgr.Instance:AddListener(EventName.BulletExitShare,self:ToFunc("BulletExitShare"))
    EventMgr.Instance:AddListener(EventName.CloseSkipStoryKeyCode,self:ToFunc("CloseSkipStoryKeyCode"))
    EventMgr.Instance:AddListener(EventName.OpenSkipStoryKeyCode,self:ToFunc("OpenSkipStoryKeyCode"))
    EventMgr.Instance:AddListener(EventName.StoryPassEvent,self:ToFunc("PassEvent"))
    EventMgr.Instance:AddListener(EventName.ActionInputEnd,self:ToFunc("ActionInputEnd"))
    EventMgr.Instance:AddListener(EventName.ActionInput,self:ToFunc("ActionInput"))
end

function StoryDialogPanelV2:__delete()
    EventMgr.Instance:RemoveListener(EventName.UpdateOptionContent,self:ToFunc("UpdateOptionContent"))
    EventMgr.Instance:RemoveListener(EventName.ClipEnter,self:ToFunc("SetDialogContent"))
    EventMgr.Instance:RemoveListener(EventName.ClipPause,self:ToFunc("DialogClipPause"))
    EventMgr.Instance:RemoveListener(EventName.BulletEnterShare,self:ToFunc("BulletEnterShare"))
    EventMgr.Instance:RemoveListener(EventName.BulletExitShare,self:ToFunc("BulletExitShare"))
    EventMgr.Instance:RemoveListener(EventName.CloseSkipStoryKeyCode,self:ToFunc("CloseSkipStoryKeyCode"))
    EventMgr.Instance:RemoveListener(EventName.OpenSkipStoryKeyCode,self:ToFunc("OpenSkipStoryKeyCode"))
    EventMgr.Instance:RemoveListener(EventName.ActionInputEnd,self:ToFunc("ActionInputEnd"))
    EventMgr.Instance:RemoveListener(EventName.ActionInput,self:ToFunc("ActionInput"))
end

function StoryDialogPanelV2:__Show()
    self.AutoBG:SetActive(not AutoConfig.AutoPaly)
    self.PlayingBG:SetActive(AutoConfig.AutoPaly)
end

function StoryDialogPanelV2:__ShowComplete()
    if self.args then self.args() end
    self:InitSkipButton()
end

function StoryDialogPanelV2:StartStory(storyId)
    self.curId = nil
    self.storyId = storyId
    self.isPhoneStart = false
    self.isPlaying = false
    if self.active then
        self:InitSkipButton()
    end
end

function StoryDialogPanelV2:ShowDisplay()
    if StoryConfig.IsTipAside(self.storyId) then
        self.gameObject:SetActive(true)
    else
        LuaTimerManager.Instance:AddTimerByNextFrame(1,0,self:ToFunc("TryShowSystemView"))
        --self:TryShowSystemView()
    end
end

function StoryDialogPanelV2:HideDisplay(clearData)
    if clearData then
        self.curId = nil
        self.pauseId = nil
        self.storyId = nil
        self.oldExploreValue = nil
        self.lastExploreSound = nil
        self.isPhoneStart = nil
        self.isPlaying = nil
        self.exploreBtnDirty = nil
        self.curTime = nil
    end
    self.gameObject:SetActive(false)
    if self.reactionTimer then
        LuaTimerManager.Instance:RemoveTimer(self.reactionTimer)
        self.reactionTimer = nil
        UtilsUI.SetActive(self.ReactionPart, false)
    end
    if self.showTimer then
        LuaTimerManager.Instance:RemoveTimer(self.showTimer)
        self.soundBinder:StopSound()
        self.soundBinder = nil
        self.showTimer = nil
    end
    if self.typeTimer then 
        LuaTimerManager.Instance:RemoveTimer(self.typeTimer)
        self.typeTimer = nil
    end
end

function StoryDialogPanelV2:GetCurId()
    return self.curId or self.storyId
end

--显示内容
function StoryDialogPanelV2:InitSkipButton()
    self.delaySkip = StoryConfig.SkipWaitTime
    self.SkipText:SetActive(true)
    self.SkipText_txt.text = string.format(TI18N("%ds后可跳过"), self.delaySkip)
    self.SkipText:SetActive(true)
    self.SkipContent:SetActive(false)
    self.Phone:SetActive(false)
    self.ExplorePart:SetActive(false)
    self.RightTop:SetActive(true)

    LuaTimerManager.Instance:RemoveTimer(self.delaySkipTimer)
    self.delaySkipTimer = LuaTimerManager.Instance:AddTimer(StoryConfig.SkipWaitTime, 1, function ()
        self.delaySkip = self.delaySkip - 1
        if self.delaySkip == 0 then
            self.SkipText:SetActive(false)
            self.SkipContent:SetActive(true)
            self.SkipText:SetActive(false)
        else
            self.SkipText_txt.text = string.format(TI18N("%ds后可跳过"), self.delaySkip)
        end
    end)
    local config = StoryConfig.GetStoryConfig(self.storyId)
    if Story.IgnoreSkipConfig then
        if config.type == StoryConfig.DialogType.TipAside then
            UnityUtils.SetLocalPosition(self.SkipButton_rect, self.skipPos.x,self.skipPos.y - 60,self.skipPos.z)
        else
            UnityUtils.SetLocalPosition(self.SkipButton_rect, self.skipPos.x,self.skipPos.y,self.skipPos.z)
        end
    end

    self.StateButton:SetActive(config.type ~= StoryConfig.DialogType.Animation and config.child_type ~= StoryConfig.ChildType.TipPhone)

    self.ctrlMode = CtrlMode.Default

    if config.type== StoryConfig.DialogType.TipAside or config.type== StoryConfig.DialogType.Animation  then
        self:ShowPhone()
    end

    if config.type == StoryConfig.DialogType.Animation then
        if config.child_type == StoryConfig.ChildType.Explore then
            self.ctrlMode = CtrlMode.Explore
            self:ShowExploreContent()
        end
    end

    self:ShowSkipButton()
end

function StoryDialogPanelV2:ShowSkipButton()
    local config = StoryConfig.GetStoryConfig(self.storyId)
    if not config then
        return
    end
    local baseShow = config.type ~= StoryConfig.DialogType.TipAside and not config.not_skip
    local selectShow = StoryConfig.GetStoryType(self:GetCurId()) ~= StoryConfig.DialogType.Select
    local gmShow = Story.IgnoreSkipConfig
    local exploreShow = config.child_type ~= StoryConfig.ChildType.Explore

    if (baseShow and selectShow or gmShow) and exploreShow then
        self.SkipButton:SetActive(true)
    else
        self.SkipButton:SetActive(false)
    end
end

local ExpBarType =
{
    Default = "Default",
    Yellow = "Yellow",
    Blue = "Blue",
}

function StoryDialogPanelV2:ShowExploreContent()
    self.ExplorePart:SetActive(true)
    self.RightTop:SetActive(false)
    self.ExploreBack1:SetActive(StoryConfig.GetExpolreConstantShow(self.storyId))
    local totalWidth = self.exploreBarWidth
    local duration = StoryController.Instance:GetDuration()
    local clueCount = StoryExploreMgr.Instance:GetClueCount()
    self:PushAllUITmpObject("ClueNode", self.Cache_rect)
    self.clueObjMap = self.clueObjMap or {}
    self.clueBgMap = self.clueBgMap or {}
    TableUtils.ClearTable(self.clueObjMap)
    TableUtils.ClearTable(self.clueBgMap)

    local clueData = StoryExploreMgr.Instance:GetClueData()

    local tempList = {}
    for id, data in pairs(clueData)  do
        table.insert(tempList, data)
    end
    table.sort(tempList, function (a, b)
        return a.startTime < b.startTime
    end)

    local lastPosX = 0
    for _, data in pairs(tempList) do
        local id = data.id
        local state = StoryExploreMgr.Instance:GetClueLockState(id)
        if state ~= StoryConfig.ClueState.NotFind then
            local obj = self:PopUITmpObject("ClueNode", self.ClueRoot_rect)
            UnityUtils.SetAnchoredPosition(obj._rect, 0, 0)
            local width = (data.duration / duration) * totalWidth
            local posx = (data.startTime / duration) * totalWidth
            UnityUtils.SetAnchoredPosition(obj.Body_rect, posx, 0)
            UnityUtils.SetSizeDelata(obj.Body_rect, width, obj.Body_rect.sizeDelta.y)
            if state == StoryConfig.ClueState.Locked then
                self:InitExpBarState(obj, ExpBarType.Yellow, true)
            else
                self:InitExpBarState(obj, ExpBarType.Blue, true)
            end
            local mask = obj.Mask:GetComponent(RectMask2D)
            mask.padding = Vector4(posx,  -10, totalWidth - (posx + width), -10)
            self.clueObjMap[id] = obj
            self:CreateExploreBar(lastPosX, posx)
            lastPosX = posx + width
        end
    end
    self:CreateExploreBar(lastPosX, totalWidth)
    
    self.ProgressText_txt.text = string.format("%s/%s", 0, clueCount)
end

local defultWidth = 4
function StoryDialogPanelV2:CreateExploreBar(startX, endX)
    local obj = self:PopUITmpObject("ClueNode", self.ClueRoot_rect)
    UnityUtils.SetAnchoredPosition(obj._rect, 0, 0)
    local totalWidth = self.exploreBarWidth
    local mask = obj.Mask:GetComponent(RectMask2D)
    local left = startX + defultWidth
    local right = totalWidth - endX + defultWidth
    if startX == 0 then
        left = -2
    end
    if endX == totalWidth then
        right = -2
    end
    mask.padding = Vector4(left,  -10, right, -10)
    self:InitExpBarState(obj, ExpBarType.Default, true)
    table.insert(self.clueBgMap, obj)
end

function StoryDialogPanelV2:UpdateProgress(clueId)
    local clueCount = StoryExploreMgr.Instance:GetClueCount()
    local curCount = StoryExploreMgr.Instance:GetUnLockCount()
    self.ProgressText_txt.text = string.format("%s/%s", curCount, clueCount)
    for id, obj in pairs(self.clueObjMap) do
        if id == clueId then
            local state = StoryExploreMgr.Instance:GetClueLockState(id)
            if state == StoryConfig.ClueState.Locked then
                self:InitExpBarState(obj, ExpBarType.Yellow)
            elseif state == StoryConfig.ClueState.Unlock then
                self:InitExpBarState(obj, ExpBarType.Blue)
                -- obj._anim:Play("UI_ClueNode_qiehuan_PC")
            end
        end
    end
    self:Update(true)
end

function StoryDialogPanelV2:ClueFullUnlock()
    self.ExploreBack1:SetActive(true)
end

function StoryDialogPanelV2:InitExpBarState(obj, type, reset)
    for k, v in pairs(ExpBarType) do
        if obj[v.."Point"] then
            obj[v.."Point"]:SetActive(false)
        end
        obj[v.."Pass"]:SetActive(false)
        obj[v.."BG"]:SetActive(false)
    end

    if obj[type.."Point"] then
        obj[type.."Point"]:SetActive(true)
    end
    obj[type.."Pass"]:SetActive(true)
    obj[type.."BG"]:SetActive(true)

    if reset then
        local rect = obj[type.."Pass_rect"]
        UnityUtils.SetSizeDelata(rect, 0, rect.sizeDelta.y)
    end
end

function StoryDialogPanelV2:Update(active)
    if not self.active then
        return
    end
    if self.storyId then
        local config = StoryConfig.GetStoryConfig(self.storyId)
        if config.type == StoryConfig.DialogType.Animation then
            if config.child_type == StoryConfig.ChildType.Explore then    
                local totalWidth = self.exploreBarWidth
                local curTime = StoryController.Instance:GetCurTime()
                -- if self.curTime == curTime and not active then
                --     return
                -- end
                -- self.curTime = curTime   
                local totalTime = StoryController.Instance:GetDuration()
                local minTime = StoryExploreMgr.Instance:GetMinTime()
                if curTime < minTime then
                    curTime = minTime
                    StoryController.Instance:SetSpeed(0)
                    StoryController.Instance:JumpToTime(curTime)
                elseif curTime > (totalTime - 1 / 60) then
                    curTime = (totalTime - 1 / 60)
                    StoryController.Instance:SetSpeed(0)
                    StoryController.Instance:JumpToTime(curTime)
                end
                local totalTime = StoryController.Instance:GetDuration()
                curTime = totalTime - curTime
                self.CurTime_txt.text = math.floor(curTime * 100) / 100
                local value = curTime / totalTime
                self.CurPosSld_sld.value = value
                for k, obj in pairs(self.clueObjMap) do
                    UnityUtils.SetLocalScale(obj.YellowPass_rect, value, 1, 1)
                    UnityUtils.SetLocalScale(obj.BluePass_rect, value, 1, 1)
                end
                for k, obj in pairs(self.clueBgMap) do
                    UnityUtils.SetLocalScale(obj.DefaultPass_rect, value, 1, 1)
                end
                local color = ExploreBarColor[StoryExploreMgr.Instance:GetExpBarState(curTime)]
                if self.oldColor ~= color then
                    self.oldColor = color
                    UtilsUI.SetImageColor(self.CurPos_img, color)
                    UtilsUI.SetImageColor(self.CurPosBg1_img, color)
                    UtilsUI.SetImageColor(self.CurPosBg2_img, color)
                    UtilsUI.SetTextColor(self.CurTime_txt, color)
                end
            end
        end
    end
    
    if self.RootNode.gameObject.activeSelf and not self.isPhoneStart  then
        if self.Phone.gameObject.activeSelf then
            self.isPhoneStart = true
            self:PhoneStart()
        end
    end

    if self.isPhoneStart and self.isPlaying  then
        self:DelayStopSound(0)
    end

end


function StoryDialogPanelV2:PosChanged(value)
    local totalTime = StoryController.Instance:GetDuration()
    local minTime = StoryExploreMgr.Instance:GetMinTime()
    local curTime = (1 - value) * totalTime
    if not self.exploreBtnDirty then
        StoryController.Instance:JumpToTime(curTime)
    end

    if curTime > (totalTime - 1 / 60) or curTime < (minTime + 1 / 60) then
        return
    end

    self.oldExploreValue = self.oldExploreValue or value
    local exploreSound
    if self.oldExploreValue > value then 
        exploreSound = "UIDetectForward"
    elseif self.oldExploreValue < value then
        exploreSound = "UIDetectBackward"
    else
        return
    end
    if not self.lastExploreSound or self.lastExploreSound ~= exploreSound then
        if self.lastExploreSound then
            SoundManager.Instance:StopUISound(self.lastExploreSound)
        end
        SoundManager.Instance:PlaySound(exploreSound)
        self.lastExploreSound = exploreSound
    end
    LuaTimerManager.Instance:RemoveTimer(self.exploreSoundTimer)
    self.exploreSoundTimer = LuaTimerManager.Instance:AddTimer(1, 0.1, function()
        SoundManager.Instance:StopUISound(exploreSound)
        self.exploreSoundTimer = nil
        self.lastExploreSound = nil
    end)
    self.oldExploreValue = value
end

function StoryDialogPanelV2:OnClick_BackOffBtn()
    if self.exploreBtnDirty then
        return
    end
    self.exploreBtnDirty = true
    self.BackOffSelect:SetActive(true)
    StoryController.Instance:SetSpeed(1)
    --SoundManager.Instance:PlaySound(self.exploreBtnDirty)
end

function StoryDialogPanelV2:OnClick_AdvancePlay()
    if self.exploreBtnDirty then
        return
    end
    self.exploreBtnDirty = true
    self.AdvancePlaySelect:SetActive(true)
    StoryController.Instance:SetSpeed(-1)
    --SoundManager.Instance:PlaySound(self.exploreBtnDirty)
end

function StoryDialogPanelV2:ExploreBtnUp()
    --SoundManager.Instance:StopUISound(self.exploreBtnDirty)
    self.exploreBtnDirty = false
    self.BackOffSelect:SetActive(false)
    self.AdvancePlaySelect:SetActive(false)
    StoryController.Instance:SetSpeed(0)
end

local SelectKeys = 
{
    [FightEnum.KeyEvent.Select1] = 1,
    [FightEnum.KeyEvent.Select2] = 2,
    [FightEnum.KeyEvent.Select3] = 3,
    [FightEnum.KeyEvent.Select4] = 4,
    [FightEnum.KeyEvent.Select5] = 5,
}

function StoryDialogPanelV2:ActionInputEnd(key)
    if key == FightEnum.KeyEvent.Advance then
        self:ExploreBtnUp()
    elseif key == FightEnum.KeyEvent.BackOff then
        self:ExploreBtnUp()
    end
end

function StoryDialogPanelV2:ActionInput(key)
    if key == FightEnum.KeyEvent.Advance then
        self:OnClick_AdvancePlay()
    elseif key == FightEnum.KeyEvent.BackOff then
        self:OnClick_BackOffBtn()
    elseif SelectKeys[key] then
        self:SelectOptionByKey(SelectKeys[key])
    end
end

function StoryDialogPanelV2:ShowPhone(data)
    
    local config
    if data then
        config = data
    else
        config = StoryConfig.GetStoryConfig(self.storyId)
    end
    local isShow = config.child_type == StoryConfig.ChildType.TipPhone
    or config.child_type == StoryConfig.ChildType.AnimationPhone
    or config.child_type == StoryConfig.ChildType.TipPhone2

    if not self.Phone.gameObject.activeSelf then
        self.Phone:SetActive(isShow)
        self.Aside:SetActive(not isShow)
    end

    if data then
        if not data.call_man_icon then
            --隐藏头像
            self.PhoneHead:SetActive(false)
        else
            self.PhoneHead:SetActive(true)
        end
    end
    
end

function StoryDialogPanelV2:OnClick_PlayPhoneDialog()

end

function StoryDialogPanelV2:PhoneStart()
    local config = StoryConfig.GetStoryConfig(self.storyId)
    if not config then
        return
    end
    local showPhoneContentNode = config.child_type == StoryConfig.ChildType.TipPhone
    self.PhoneContentNode:SetActive(showPhoneContentNode)
    local words= StringHelper.Split(config.call_man_icon,";")
    if words then
        self:ShowPhoneHead(config)
        self.DynamicEffect:SetActive(false)
        SingleIconLoader.Load(self.DefaultButton, config.call_icon)
        SingleIconLoader.Load(self.HeadIcon, words[2])
    end
    
    local ani =  self.Phone.transform:GetComponent("Animator")
    if config.child_type == StoryConfig.ChildType.TipPhone2  then
        self.PhoneRed:SetActive(false)
        ani.enabled = false
        ani.enabled = true
        self:DelayStopSound(0)
    else
        self.PhoneRed:SetActive(true)
        ani.enabled  =true
        self.AsideText:SetActive(false)
        self.PhoneContent:SetActive(false)
        if config.child_type == StoryConfig.ChildType.TipPhone then
            StoryController.Instance:SetSpeed(0)
        end
        self:DelayStopSound(2)
    end

end

function StoryDialogPanelV2:ShowPhoneHead(config)
    local isShow =(config.call_icon~=nil) and true or false
    local words= StringHelper.Split(config.call_man_icon,";")
    if words then
    self.DefaultButton:SetActive(isShow)
    self.PhoneRed:SetActive(isShow)
    self.HeadIcon:SetActive(true)
    self.PhoneGreen:SetActive(not isShow)
    self.PhoneNameText_txt.text=TI18N(words[1])
    local spellName=self:GetSpellByName(words[1])
    self.PhoneEngNameText_txt.text=TI18N(spellName)
    end
end

function StoryDialogPanelV2:DelayStopSound(delayTime)
    self.soundBinder = self.Phone.transform:GetComponent(UISoundBinder)
	if delayTime == 0 then
        self.soundBinder:StopSound()
        self.AsideText:SetActive(true)
        self.PhoneContent:SetActive(true)
        if StoryController.Instance.playableDirector then
            StoryController.Instance:SetSpeed(1)
        end
       
        self.isPlaying = true
	else
		local callback = function()
			if self.showTimer then
				LuaTimerManager.Instance:RemoveTimer(self.showTimer)
				self.showTimer = nil
			end
            self.soundBinder:StopSound()
            self.AsideText:SetActive(true)
            self.PhoneContent:SetActive(true)
            if StoryController.Instance.playableDirector then
                StoryController.Instance:SetSpeed(1)
            end
            self.isPlaying = true
		end
		if self.showTimer then
			LuaTimerManager.Instance:RemoveTimer(self.showTimer)
			self.showTimer = nil
		end
		self.showTimer = LuaTimerManager.Instance:AddTimer(1, delayTime, callback)
	end
end

function StoryDialogPanelV2:GetSpellByName(word)
    local HeroData= Config.DataHeroMain.Find
    for key, value in pairs(HeroData) do
        if value.name==word then
            return value.pinyin
        end
    end
    return "lige"--一个默认拼音
end

function StoryDialogPanelV2:UpdatePhoneContent()
    local config = StoryConfig.GetStoryConfig(self.curId)
    self:ShowPhone(config)
    local words= StringHelper.Split(config.call_man_icon,";")
    if words then
    self:ShowPhoneHead(config)
    self.DynamicEffect:SetActive(true)
    SingleIconLoader.Load(self.HeadIcon, words[2])
    end
end

function StoryDialogPanelV2:SetDialogContent(id,contentType)
	if self.curId == id then
		return
	end

    local reactionConfig = StoryConfig.CheckReaction(id)
    if reactionConfig then
        self:ShowReaction(reactionConfig)
    end

    self.curId = id
    self.pauseId = nil
    local config = StoryConfig.GetStoryConfig(id)
    if config.child_type== StoryConfig.ChildType.TipPhone
    or config.child_type== StoryConfig.ChildType.AnimationPhone
    or config.child_type== StoryConfig.ChildType.TipPhone2
     then
        if self.storyId~=self.curId then
            self:UpdatePhoneContent()
        end
    end
    local aside = self:ReplaceMark(config.aside or Null)
    self.AsideText_txt.text =  aside
    self.TipAsideText_txt.text = aside
    --Phoencontent
    self.PhoneContent_txt.text=aside

    local name = self:ReplaceMark(config.talk_name or Null)
    local content = self:ReplaceMark(config.talk_content or Null)
    self.TalkName_txt.text = name
    self.ContentText_txt.text = content

    if contentType == StoryConfig.ContentType.Content then
        self.ContentText_txt.maxVisibleCharacters = 0
        self.typeTimer = LuaTimerManager.Instance:AddTimer(0,unitTime*3,function()
            local visibleLength = self.ContentText_txt.maxVisibleCharacters
            if self.ContentText_txt.maxVisibleCharacters ~= visibleLength + 1 then
                self.ContentText_txt.maxVisibleCharacters = visibleLength + 1
                if visibleLength + 1 >= string.len(self.ContentText_txt.text) then
                    if self.isType then
                        self.isType = false;
                        self.ArrowsGrounp:SetActive(true);
                        LuaTimerManager.Instance:RemoveTimer(self.typeTimer)
                        self.typeTimer = nil
                    end
                elseif visibleLength + 1 <= string.len(self.ContentText_txt.text) then
                    if not self.isType then
                        self.isType = true;
                        self.ArrowsGrounp:SetActive(false);
                    end
                end
            end
        end)
        
    end



    self.Character_txt.text = name
    self.Abstract_txt.text = content
   
    if config.back_groud or config.back_text then
        self.BGNode:SetActive(true)
        self.BGContentText_txt.text = config.back_text or Null
        if config.back_groud then
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
    self.NormalOptions:SetActive(false)
    self.SpecialOptions:SetActive(false)
    self:ShowSkipButton()
end

function StoryDialogPanelV2:DialogClipPause(id)
	if self.pauseId == id then
		return
	end
    self.effectDirty = false
	self.pauseId = id
    local config = StoryConfig.GetStoryConfig(id)
	if not config then
		LogError("找不到剧情配置！"..id)
        return
	end
    if config.type == StoryConfig.DialogType.Select then
        StoryController.Instance:Pause()
        TableUtils.ClearTable(self.index2Option)
        TableUtils.ClearTable(self.key2Index)
        if config.child_type and config.child_type == StoryConfig.ChildType.SpecialSelect then
            self:ShowSpecialOptions()
        else
            self:ShowOptions()
        end
    end
    if ((config.type == StoryConfig.DialogType.Common
    or config.type == StoryConfig.DialogType.Specific)
    and AutoConfig.AutoPaly == false) then
        StoryController.Instance:Pause()
    end
end

function StoryDialogPanelV2:ShowOptions()
    self.NormalOptions:SetActive(true)
    local count = 0
    self.SpecialOptions:SetActive(false)
    for i = 1, StoryConfig.MaxSelectCount, 1 do
        local option = self.optionMap[i]
        local content, icon, sub, isLock = Story.Instance:GetOptionContent(i)
        count = count + 1
        if isLock or not content then
            option.object:SetActive(false)
            goto continue
        else
            option.object:SetActive(true)
            option.SubText:SetActive(false)
        end
        SingleIconLoader.Load(option.FunctionIcon, icon)
        option.OptionText_txt.text = self:ReplaceMark(content)
        if sub then
            option.SubText_txt.text = sub
            option.SubText:SetActive(true)
        end
        self.index2Option[i] = i
        self.key2Index[count] = i

        ::continue::
    end
    self:EnterSelect(0)
end

function StoryDialogPanelV2:ShowSpecialOptions()
    self.ContentBody:SetActive(false)
    local uiCamera = ctx.UICamera
    uiCamera.orthographic = false
    uiCamera.fieldOfView  = 25
    uiCamera.nearClipPlane = 0.01

    local config = StoryConfig.GetStoryConfig(self:GetCurId())
    local pos
    if config.options_pos then
        pos = "Pos".. config.options_pos .."_rect"
    end

    pos = pos and self[pos] or self.Default_rect
    self.SpecialOptions_rect:SetParent(pos, false)
    UnityUtils.SetLocalPosition(self.SpecialOptions_rect, 0, 0, 0)
    -- UnityUtils.SetLocalEulerAngles(self.SpecialOptions_rect, 0, 0, 0)
    local len = #config.options
    self.SpecialOptions:SetActive(true)
    self.NormalOptions:SetActive(false)
    local options = {}
    for i = 1, StoryConfig.MaxSelectCount, 1 do
        local content, _, _, isLock, tip, condition = Story.Instance:GetOptionContent(i)
        if content then
            local option = 
            {
                index = i,
                content = tip or content,
                isLock = isLock,
                condition = condition
            }
            table.insert(options, option)
        end
    end

    table.sort(options, function (a, b)
        if a.condition and b.condition then
            if a.isLock and b.isLock then
            elseif a.isLock then
                return true
            elseif b.isLock then
                return false
            else
                return a.index < b.index
            end
        elseif a.condition then
            return true
        elseif b.condition then
            return false
        else
            return a.index < b.index
        end
    end)

    local count = 0
    for i = 1, StoryConfig.MaxSelectCount, 1 do
        local obj = self.specialOptionMap[i]
        obj.object:SetActive(i <= #options)
        if i <= #options then
            obj.Context_txt.text = options[i].content
            obj.BackContext_txt.text = options[i].content
            obj.LockedMask:SetActive(options[i].condition and options[i].isLock)
            obj.Locked:SetActive(options[i].condition and options[i].isLock)
            obj.Unlock:SetActive(options[i].condition and not options[i].isLock)
            if options[i].condition and options[i].isLock then
                UtilsUI.SetTextColor(obj.Context_txt, "#5a5a5a")
            else
                UtilsUI.SetTextColor(obj.Context_txt, "#FFFFFF")
            end
            if not options[i].isLock then
                count = count + 1
                obj.Icon_txt.text = count
                obj.BackIcon_txt.text = count
                self.index2Option[i] = options[i].index
                self.key2Index[count] = i
            end
            obj.Icon:SetActive(not options[i].isLock)
            obj.BackIcon:SetActive(not options[i].isLock)
            obj.Box:SetActive(not options[i].isLock)
            local width = obj.Context_txt.preferredWidth
            UnityUtils.SetSizeDelata(obj.LockedMask_rect, width + 190, 88)
            UnityUtils.SetSizeDelata(obj.Button_rect, width + 190, 88)
        end
    end
end

function StoryDialogPanelV2:UpdateOptionContent(triggerId, content, sub)
    local config = StoryConfig.GetStoryConfig(self:GetCurId())
        if config.type == StoryConfig.DialogType.Select then
            for i = 1, #config.options, 1 do
                if config.options[i][2] == triggerId then
                    if not content and not sub then
                        content, sub = Story.Instance:GetBehaviorTriggerContext(triggerId, config.options[i][1])
                    end

                    local objInfo = self.optionMap[i]

                    if content then
                        objInfo.OptionText_txt.text = content
                    end
                    if sub then
                        objInfo.SubText_txt.text = sub
                    end
                    return
                end
            end
            LogError("错误的triggerId ".. triggerId)
        end
end

function StoryDialogPanelV2:ReplaceMark(content)
    local newStr = content
    if string.find(content, "<nick_name>") then
        local name = mod.InformationCtrl:GetPlayerInfo() and mod.InformationCtrl:GetPlayerInfo().nick_name
        newStr = string.gsub(newStr, "<nick_name>", name or "<nick_name>")
    end

    return newStr
end

--交互逻辑
function StoryDialogPanelV2:OnClick_ChangePlayState()
    AutoConfig.AutoPaly = not AutoConfig.AutoPaly
    --self.AutoPlayIcon:SetActive(not AutoConfig.AutoPaly)
    self.AutoBG:SetActive(not AutoConfig.AutoPaly)
    self.PlayingBG:SetActive(AutoConfig.AutoPaly)
    -- if AutoConfig.AutoPaly then
    --     self.StateText_txt.text = TI18N("播放中")
    -- else
    --     self.StateText_txt.text = TI18N("自动")
    -- end
    if StoryConfig.GetStoryType(self:GetCurId()) ~= StoryConfig.DialogType.Select then
        StoryController.Instance:Resume()
    end
end

function StoryDialogPanelV2:CloseSkipStoryKeyCode()
    self.isCloseSkipStoryKeyCode = true
end

function StoryDialogPanelV2:OpenSkipStoryKeyCode()
    self.isCloseSkipStoryKeyCode = false
end

function StoryDialogPanelV2:OnClick_SkipDialog()
    if self.isCloseSkipStoryKeyCode then
        return
    end

    if self.delaySkip > 0 and not Story.IgnoreSkipConfig then
        return
    end

    Story.Instance:SkipStory(self:GetCurId())
end

function StoryDialogPanelV2:OnClick_SkipExplore()
    local config = StoryConfig.GetStoryConfig(self.storyId)
    if config.child_type == StoryConfig.ChildType.Explore then
        MsgBoxManager.Instance:ShowTextMsgBox(TI18N("确定要退出调查模式吗？"), function ()
            Story.Instance:SkipStory(self:GetCurId())
        end)
        return
    end
end

function StoryDialogPanelV2:OnClick_NextDialog()
    local type = StoryConfig.GetStoryType(self:GetCurId())
    local config = StoryConfig.GetStoryConfig(self:GetCurId())
    if type == StoryConfig.DialogType.TipAside
    or type == StoryConfig.DialogType.Animation then return end

    local startTime = StoryController.Instance:GetStartTimeById(self:GetCurId())
    local pauseTime = StoryController.Instance:GetPauseTimeById(self:GetCurId())
    local curTime = StoryController.Instance:GetCurTime()

    --锁定选项时不允许下一句
    if StoryController.Instance:GetLockState() then
        if StoryController.Instance:GetPalyState() then
            return
        end
    end
    
    if self.isType then
        self.ContentText_txt.maxVisibleCharacters = string.len(self.ContentText_txt.text)
        --StoryController.Instance:JumpToTime(startTime + typeTime)
        return
    else
        local nextId = config.next_id
        local tagetConfig = StoryConfig.GetStoryConfig(nextId)
        --同组则跳转到下一句开始
        if nextId and nextId > 1000 and tagetConfig.group_id == config.group_id then
			self.nextId = nextId
            self:OnClickEffect()
        elseif curTime < pauseTime then
            StoryController.Instance:JumpToTime(pauseTime)
            if type ~= StoryConfig.DialogType.Select then
                self.pauseId = self:GetCurId()
            end
        elseif type ~= StoryConfig.DialogType.Select then
            StoryController.Instance:Resume()
        end
    end
end

function StoryDialogPanelV2:JumpToNextDialogStart()
    local type = StoryConfig.GetStoryType(self:GetCurId())
    if type ~= StoryConfig.DialogType.Select then
        StoryController.Instance:Resume()
    end
    self.ArrowsGrounp_out_hcb.HideAction:RemoveAllListeners()
    self.ArrowsGrounp_Click:SetActive(false)
    self.effectDirty = false
    --self.ContentBG_btn.enabled = true
	if not self.nextId or not self.storyId then
		return
	end
	local nextId = self.nextId
	local targetTime
	if StoryConfig.IsNewFile(self.storyId, nextId) then
		StoryController.Instance:TryPlayStory(nextId)
	end
    targetTime = StoryController.Instance:GetStartTimeById(nextId)
	StoryController.Instance:JumpToTime(targetTime)
end

function StoryDialogPanelV2:OnClickEffect()
    if StoryConfig.GetStoryType(self:GetCurId()) == StoryConfig.DialogType.Select then
        return
    end
    if self.effectDirty then return end
    self.effectDirty = true
    UtilsUI.SetHideCallBack(self.ArrowsGrounp_out, self:ToFunc("JumpToNextDialogStart"))
    --self.ContentBG_btn.enabled = false
    self.ArrowsGrounp_Click:SetActive(false)
    self.ArrowsGrounp_Click:SetActive(true)
    self.ArrowsGrounp_Click_sound:PlayButtonSound()
end

function StoryDialogPanelV2:EnterSelect(index)
    if self.selectIndex and self.selectIndex ~= 0 then
        self.optionMap[self.selectIndex].SelectBG:SetActive(false)
        --self.optionMap[self.selectIndex].OptionBG:SetActive(true)
        --self.optionMap[self.selectIndex].Effect:SetActive(false)
        --self.optionMap[self.selectIndex].FunctionIcon_img.color = Color.white
        --self.optionMap[self.selectIndex].OptionText_txt.color = Color.white
    end
    self.selectIndex = index
    if index ~= 0 then
        self.optionMap[index].SelectBG:SetActive(true)
        --self.optionMap[index].OptionBG:SetActive(false)
        --self.optionMap[index].Effect:SetActive(true)
        --UtilsUI.SetImageColor(self.optionMap[index].FunctionIcon_img, "#30373D")
        --UtilsUI.SetTextColor(self.optionMap[index].OptionText_txt, "#2C3339")
    end
end

function StoryDialogPanelV2:ExitSelect(index)
    self.optionMap[index].SelectBG:SetActive(false)
    self.optionMap[index].OptionBG:SetActive(true)
    --self.optionMap[index].FunctionIcon_img.color = Color.white
    --self.optionMap[index].OptionText_txt.color = Color.white
end

function StoryDialogPanelV2:BGBeginDrag()
    FightMainUIView.bgInput.x = 0
	FightMainUIView.bgInput.y = 0
end

function StoryDialogPanelV2:BGDrag(data)
    FightMainUIView.bgInput.x = data.delta.x
	FightMainUIView.bgInput.y = data.delta.y
    self.draging = true
end

function StoryDialogPanelV2:BGEndDrag()
    FightMainUIView.bgInput.x = 0
	FightMainUIView.bgInput.y = 0
end

function StoryDialogPanelV2:BGDown()
    self.draging = false
	InputManager.Instance:KeyDown(FightEnum.KeyEvent.ScreenPress)
end

function StoryDialogPanelV2:BGUp()
	InputManager.Instance:KeyUp(FightEnum.KeyEvent.ScreenPress)
    if self.ctrlMode == CtrlMode.Default then
        if not self.draging then
            self:OnClick_NextDialog()
        end
    end
end

function StoryDialogPanelV2:SelectOptionByKey(key)
    local index = self.key2Index[key]
    if index then
        local config = StoryConfig.GetStoryConfig(self:GetCurId())
        if config.options then
            if config.child_type and config.child_type == StoryConfig.ChildType.SpecialSelect then
                local option = self.specialOptionMap[index]
                option._uianim:PlayExitAnimator()
            else
                self:SelectOption(index)
            end
        end
    end
end

function StoryDialogPanelV2:SelectOption(index)
    if not self.index2Option[index] then
        return
    end
    local select = self.index2Option[index]
    local config = StoryConfig.GetStoryConfig(self:GetCurId())
    if config.options then
        if config.child_type and config.child_type == StoryConfig.ChildType.SpecialSelect then
            self.ContentBody:SetActive(true)
            local uiCamera = ctx.UICamera
            uiCamera.orthographic = true
            uiCamera.nearClipPlane = -10
            Story.Instance:SelectOption(select)
        else
            Story.Instance:SelectOption(select)
        end
    end
end

function StoryDialogPanelV2:BulletEnterShare()
    UtilsUI.SetActive(self.gameObject, false)
end

function StoryDialogPanelV2:BulletExitShare()
    UtilsUI.SetActive(self.gameObject, true)
end

function StoryDialogPanelV2:ShowReaction(reactionConfig)
    SoundManager.Instance:PlaySound("UIDialogReaction")
    if not self.reactionAnim then
        self.reactionAnim = self.ReactionPart:GetComponent(Animator)
    end
    CustomUnityUtils.SetScreenBlur(true, 2, 2)
    UtilsUI.SetActive(self.ReactionPart, true)
    self.ReactionName1_txt.text = reactionConfig.pinyin
    self.ReactionName2_txt.text = reactionConfig.name
    self.BottomText_txt.text = reactionConfig.desc
    for i = 1, 3, 1 do
        if i == reactionConfig.type then
            UtilsUI.SetActive(self["Bottom"..i],true)
            UtilsUI.SetActive(self["Icon"..i],true)
        else
            UtilsUI.SetActive(self["Bottom"..i],false)
            UtilsUI.SetActive(self["Icon"..i],false)
        end
    end
    if reactionConfig.type == 1 then
        -- self.reactionAnim:Play("UI_ReactionPart_shang_PC")
    elseif reactionConfig.type == 2 then
        -- self.reactionAnim:Play("UI_ReactionPart_ping_PC")
    elseif reactionConfig.type == 3 then
        -- self.reactionAnim:Play("UI_ReactionPart_xia_PC")
    else
        UtilsUI.SetActive(self["Bottom2"],true)
        -- self.reactionAnim:Play("UI_ReactionPart_wu_PC")
    end
    
    if self.reactionTimer then
        LuaTimerManager.Instance:RemoveTimer(self.reactionTimer)
        self.reactionTimer = nil
    end
    self.reactionTimer = LuaTimerManager.Instance:AddTimer(0,Config.DataCommonCfg.Find["ReactionShowTime"].int_val,self:ToFunc("CloseReaction"))
end

function StoryDialogPanelV2:CloseReaction()
    LuaTimerManager.Instance:RemoveTimer(self.reactionTimer)
    self.reactionTimer = nil
    UtilsUI.SetActive(self.ReactionPart, false)
    LuaTimerManager.Instance:RemoveTimer(self.reactionTimer)
    CustomUnityUtils.SetScreenBlur(false, 2, 2)
end

function StoryDialogPanelV2:PassEvent(storyId)
    if storyId == Config.DataCommonCfg.Find["RenameTimeline"].int_val then
        StoryController.Instance:SetSpeed(0)
        PanelManager.Instance:OpenPanel(PlayerSetNamePanel)
    end
end