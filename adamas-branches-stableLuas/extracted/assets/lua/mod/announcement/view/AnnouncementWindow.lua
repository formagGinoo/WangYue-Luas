AnnouncementWindow = BaseClass("AnnouncementWindow", BaseWindow)

function AnnouncementWindow:__init()  
    self:SetAsset("Prefabs/UI/Announcement/AnnouncementWindow.prefab")
    self.selectAnnouncement = nil
    self.showType = 0
    self.announcementObjList = {}
    self.announcementList = {}
end

function AnnouncementWindow:__BindListener()
    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("OnClickClose"))
    self.Lab1Btn_btn.onClick:AddListener(self:ToFunc("ChangeToLab1"))
    self.Lab2Btn_btn.onClick:AddListener(self:ToFunc("ChangeToLab2"))

    if Fight.Instance then
        self:BindRedPoint(RedPointName.AnnouncementGameLab, self.RedPoint1)
        self:BindRedPoint(RedPointName.AnnouncementActiveLab, self.RedPoint2)
    end
end

function AnnouncementWindow:__Create()
end

function AnnouncementWindow:__delete()
    for k, v in pairs(self.announcementObjList) do
		PoolManager.Instance:Push(PoolType.class, "CommonAnnouncement", v.commonAnnouncement)
	end
    self.selectAnnouncement = nil
    self.announcementObjList = {}
end

function AnnouncementWindow:__Hide()
end

function AnnouncementWindow:__Show()
    local setting = {passEvent = UIDefine.BlurBackCaptureType.UI}
    self:SetBlurBack(setting)
    self.announcementCtrl = mod.AnnouncementCtrl
    self.rectView = self.AnnouncementInfo:GetComponent(ScrollRect)
    self.labType = 1
    local list = self.announcementCtrl:GetannouncementList(AnnouncementCtrl.TagType.gameTag)
    if not list or #list < 1 then 
        UtilsUI.SetActive(self.TopLab1,false)
        UtilsUI.SetActive(self.TopLine,false)
        self.labType = 2
    else
        list = self.announcementCtrl:GetannouncementList(AnnouncementCtrl.TagType.activityTag)
        if not list or #list < 1 then 
            UtilsUI.SetActive(self.TopLab2,false)
            UtilsUI.SetActive(self.TopLine,false)
        end
    end

    self:UpdateTabRedState()
end

-- 这里是在游戏外（登录页）
function AnnouncementWindow:UpdateTabRedState()
    self.back:SetActive(false)
    if Fight.Instance then return end
    local activeRed = self.announcementCtrl:CheckActiveLabRedPoint()
    local gameRed = self.announcementCtrl:CheckGameLabRedPoint()

    self.RedPoint1:SetActive(activeRed)
    self.RedPoint2:SetActive(gameRed)
    -- self.back:SetActive(true)
end

function AnnouncementWindow:__ShowComplete()
    self:InitLab()
end

function AnnouncementWindow:InitLab()
    if self.labType == 1 then 
        self:ChangeToLab1()
    else
        self:ChangeToLab2()
    end
end

function AnnouncementWindow:RefreshAnnouncementList()
    self.refreshAll = true

    local listNum = #self.announcementList
    self.AnnouncementScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshAnnouncementCell"))
    self.AnnouncementScroll_recyceList:SetCellNum(listNum)
end

function AnnouncementWindow:RefreshAnnouncementCell(index,go)
    if not go then
        return
    end

    local commonAnnouncement
    local announcementObj
    if self.announcementObjList[index] then
        commonAnnouncement = self.announcementObjList[index].commonAnnouncement
        announcementObj = self.announcementObjList[index].announcementObj
    else
        local uiContainer = {}
        uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
        commonAnnouncement = PoolManager.Instance:Pop(PoolType.class, "CommonAnnouncement")
        if not commonAnnouncement then
            commonAnnouncement = CommonAnnouncement.New()
        end
        announcementObj = uiContainer.CommonAnnouncement
        self.announcementObjList[index] = {}
        self.announcementObjList[index].commonAnnouncement = commonAnnouncement
        self.announcementObjList[index].announcementObj = announcementObj
        self.announcementObjList[index].isSelect = false
    end

    commonAnnouncement:InitAnnouncement(announcementObj,self.announcementList[index],self.disCount,true)
    local onClickFunc = function()
        self:OnClick_SingleGood(self.announcementObjList[index].commonAnnouncement)
    end
    commonAnnouncement:SetBtnEvent(false,onClickFunc)

    if self.refreshAll and index == 1 then 
        self.refreshAll = false
        self:OnClick_SingleGood(commonAnnouncement)
    end

    if not self.announcementList[index] or not next(self.announcementList[index]) then
        return 
    end
end

function AnnouncementWindow:OnClick_SingleGood(singleAnnouncement)
    self.rectView.normalizedPosition = Vector2(0,1)
    if self.selectAnnouncement and self.selectAnnouncement ~= singleAnnouncement then
        self.selectAnnouncement.isSelect = false
        self.selectAnnouncement:SetSelectBox()
    end
    if singleAnnouncement.isRed == true then
        -- mod.AnnouncementFacade:SendMsg("noticeboard_redpoint",singleAnnouncement.announcementInfo.id)
        self.announcementCtrl:AddAnnouncementsReadId(singleAnnouncement.announcementInfo.id)
        singleAnnouncement.isRed = false
        singleAnnouncement:SetRedPoint()

        self:UpdateTabRedState()
    end
    singleAnnouncement.isSelect = true
    singleAnnouncement:SetSelectBox()
    singleAnnouncement:OnClick()
    self.selectAnnouncement = singleAnnouncement

    self:ShowAnnouncementInfo(singleAnnouncement.announcementInfo)
end

function AnnouncementWindow:ShowAnnouncementInfo(announcementInfo)
    self.AnnouncementTitle_txt.text = announcementInfo.title
    if announcementInfo.banner and announcementInfo.banner ~= ""then
        UtilsUI.SetActive(self.Image,true)
        SingleIconLoader.Load(self.Image,announcementInfo.banner)
    else
        UtilsUI.SetActive(self.Image,false)
    end
    self.MainText_txt.text = announcementInfo.content
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.MainText.transform)
end

function AnnouncementWindow:ChangeToLab1()
    self:ChangeType(1)
    UtilsUI.SetActive(self.Lab1Select,true)
    UtilsUI.SetActive(self.Lab2Select,false)
end

function AnnouncementWindow:ChangeToLab2()
    self:ChangeType(2)
    UtilsUI.SetActive(self.Lab1Select,false)
    UtilsUI.SetActive(self.Lab2Select,true)
end

function AnnouncementWindow:ChangeType(type)
    if self.showType == type then return end
    self.showType = type
    self.labType = type
    self.announcementList = self.announcementCtrl:GetannouncementList(type)
    self:AnnouncementListUpdate()
    
end

function AnnouncementWindow:AnnouncementListUpdate()
    if self.selectAnnouncement then
        self.selectAnnouncement.isSelect = false
        self.selectAnnouncement:SetSelectBox()
        self.selectAnnouncement = nil
    end
    self:RefreshAnnouncementList()
end

function AnnouncementWindow:OnClickClose()
    WindowManager.Instance:CloseWindow(self)
end