SetBirthdayPanel = BaseClass("SetBirthdayPanel", BasePanel)

local _tinsert = table.insert

function SetBirthdayPanel:__init()
    self:SetAsset("Prefabs/UI/Friend/SetBirthDayPanel.prefab")
    self.mouthList = {}
    self.dayList = {}
    self.dayMap = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
end

function SetBirthdayPanel:__BindListener()
    self:BindCloseBtn(self.Cancel_btn, self:ToFunc("OnClickCloseBtn"))
    self:BindCloseBtn(self.CommonBack1_btn, self:ToFunc("OnClickCloseBtn"))
    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClickSubmitBtn"))
end

function SetBirthdayPanel:__BindEvent()
    
end

function SetBirthdayPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function SetBirthdayPanel:__delete()

end

function SetBirthdayPanel:__Show()
    local setting = { bindNode = self.BlurNode }
    self:SetBlurBack(setting)
    self:Init()

    self.TitleText_txt.text = TI18N("设置生日")
    self.SubmitText_txt.text = TI18N("确认")
    self.CancelText_txt.text = TI18N("取消")
    self.MonthText_txt.text = TI18N("月")
    self.DayText_txt.text = TI18N("日")

    self.mouthDrag = self.MouthList:GetComponent(UIDragBehaviour)
    self.dayDrag = self.DayList:GetComponent(UIDragBehaviour)

    self.mouthDrag.onBeginDrag = self:ToFunc("MonthOnBeginDrag")
    self.mouthDrag.onDrag = self:ToFunc("MonthOnDrag")
    self.mouthDrag.onEndDrag = self:ToFunc("MonthOnEndDrag")
    self.dayDrag.onBeginDrag = self:ToFunc("DayOnBeginDrag")
    self.dayDrag.onDrag = self:ToFunc("DayOnDrag")
    self.dayDrag.onEndDrag = self:ToFunc("DayOnEndDrag")
end

function SetBirthdayPanel:__ShowComplete()
--     if not self.blurBack then
--         local setting = { bindNode = self.BlurNode }
--         self.blurBack = BlurBack.New(self, setting)
--     end
--    self.blurBack:Show()
end

function SetBirthdayPanel:Init()
    self.textItemRect = { width = self.TextItem_rect.rect.width, height = self.TextItem_rect.rect.height }

    for i = 1, 12 do
        local gameObject = GameObject.Instantiate(self.TextItem, self.MouthList.transform)
        local text = gameObject:GetComponent(TextMeshProUGUI)
        text.text = i
        text.alpha = 0.5
        _tinsert(self.mouthList, text)
        UtilsUI.SetActive(gameObject, true)
    end

    for i = 1, 31 do
        local gameObject = GameObject.Instantiate(self.TextItem, self.DayList.transform)
        local text = gameObject:GetComponent(TextMeshProUGUI)
        text.text = i
        text.alpha = 0.5
        _tinsert(self.dayList, text)
        UtilsUI.SetActive(gameObject, true)
    end

    UnityUtils.SetAnchoredPosition(self.MouthList_rect, 0, -self.textItemRect.height)
    UnityUtils.SetAnchoredPosition(self.DayList_rect, 0, -self.textItemRect.height)

    self.curMouthListYPos = -self.textItemRect.height
    self.curDayListYPos = -self.textItemRect.height

    self.curSelectMouth = 1
    self.curSelectDay = 1
    self.mouthList[self.curSelectMouth].alpha = 1
    self.dayList[self.curSelectDay].alpha = 1
end

function SetBirthdayPanel:MonthOnBeginDrag(eventData)
    self.mouthList[self.curSelectMouth].alpha = 0.5
end

function SetBirthdayPanel:MonthOnDrag(eventData)
    --CustomUnityUtils.TweenerTo
    self.curMouthListYPos = self.curMouthListYPos + eventData.delta.y
    UnityUtils.SetAnchoredPosition(self.MouthList_rect, 0, self.curMouthListYPos)
end

function SetBirthdayPanel:MonthOnEndDrag(eventData)
    self.curMouthListYPos = self:FindNearestMultiple(self.curMouthListYPos, self.textItemRect.height)
    self.curMouthListYPos = MathX.Clamp(self.curMouthListYPos, self.textItemRect.height * -1, self.textItemRect.height * (12 - 2))

    self.curSelectMouth = self.curMouthListYPos / self.textItemRect.height + 2
    
    UnityUtils.SetAnchoredPosition(self.MouthList_rect, 0, self.curMouthListYPos)
    self.mouthList[self.curSelectMouth].alpha = 1

    self:CheckDay(self.curSelectMouth)
end

function SetBirthdayPanel:CheckDay(curMouth)
    local days = self.dayMap[curMouth]
    
    for i = 30, days do
        UtilsUI.SetActive(self.dayList[i].gameObject, true)
    end

    for i = days + 1, 31 do
        UtilsUI.SetActive(self.dayList[i].gameObject, false)
    end

    if self.curSelectDay > days then
        self.curDayListYPos = self.textItemRect.height * (days - 2)
        UnityUtils.SetAnchoredPosition(self.DayList_rect, 0, self.curDayListYPos)
        self.dayList[self.curSelectDay].alpha = 0.5
        self.curSelectDay = self.curDayListYPos / self.textItemRect.height + 2
        self.dayList[self.curSelectDay].alpha = 1
    end
end

function SetBirthdayPanel:DayOnBeginDrag(eventData)
    --LogInfo("日 开始滑动")
    self.dayList[self.curSelectDay].alpha = 0.5
end

function SetBirthdayPanel:DayOnDrag(eventData)
    self.curDayListYPos = self.curDayListYPos + eventData.delta.y
    UnityUtils.SetAnchoredPosition(self.DayList_rect, 0, self.curDayListYPos)
end

function SetBirthdayPanel:DayOnEndDrag(eventData)
    self.curDayListYPos = self:FindNearestMultiple(self.curDayListYPos, self.textItemRect.height)
    self.curDayListYPos = MathX.Clamp(self.curDayListYPos, self.textItemRect.height * -1, self.textItemRect.height * (self.dayMap[self.curSelectMouth] - 2))

    self.curSelectDay = self.curDayListYPos / self.textItemRect.height + 2
    
    UnityUtils.SetAnchoredPosition(self.DayList_rect, 0, self.curDayListYPos)
    self.dayList[self.curSelectDay].alpha = 1

end

function SetBirthdayPanel:FindNearestMultiple(a, b)
    return math.floor(a / b + 0.5) * b
end

function SetBirthdayPanel:OnClickCloseBtn()
    EventMgr.Instance:Fire(EventName.SetBirthdayFinish)
    --self.parent:ClosePanel(SetBirthdayPanel)
end

function SetBirthdayPanel:OnClickSubmitBtn()
    local callBack = function ()
		EventMgr.Instance:Fire(EventName.SetBirthday,self.curSelectMouth, self.curSelectDay)
        --LogInfo(string.format("选中日期 月份：%d 日期：%d", self.curSelectMouth, self.curSelectDay))
        self:OnClickCloseBtn()
	end
    local string = string.format(TI18N("你确定将%d月%d日设置成你的生日吗？一经确认将不得再修改"), self.curSelectMouth, self.curSelectDay)
    MsgBoxManager.Instance:ShowTextMsgBox(string, callBack)
end
