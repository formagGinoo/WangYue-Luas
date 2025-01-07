TalentMainWindow = BaseClass("TalentMainWindow", BaseWindow)


function TalentMainWindow:__init()
	self:SetAsset("Prefabs/UI/Talent/TalentMainWindow.prefab")
end

function TalentMainWindow:__BindListener()
    self:SetHideNode("TalentMainWindow_Eixt")
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("Close_HideCallBack"),self:ToFunc("OnClick_Close"))    
end

function TalentMainWindow:__BindEvent()
    EventMgr.Instance:AddListener(EventName.UpdateTalentData, self:ToFunc("InitTalentsListNum"))
    EventMgr.Instance:AddListener(EventName.UpdateTalentData, self:ToFunc("UpdateTalentInfo"))
end

function TalentMainWindow:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function TalentMainWindow:__Create()
    -- 设置一下当前最高层级 供下面的item用的
    mod.TalentCtrl:SetCurWindowLayer()
end

function TalentMainWindow:__delete()
    EventMgr.Instance:RemoveListener(EventName.UpdateTalentData, self:ToFunc("InitTalentsListNum"))
    EventMgr.Instance:RemoveListener(EventName.UpdateTalentData, self:ToFunc("UpdateTalentInfo"))
end

function TalentMainWindow:__ShowComplete()

end

function TalentMainWindow:__Hide()
    self:CacheCurrencyBar()
end

function TalentMainWindow:__Show()
    self:InitCurrencyBar()
    self:UpdateData()
    self:SetEffectLayer()
end

function TalentMainWindow:SetEffectLayer()
    self.effectRenderer = self.Effect22108.transform:GetComponent(Renderer)
    self.effectRenderer.sortingOrder = WindowManager.Instance:GetCurOrderLayer() + 1
end

function TalentMainWindow:UpdateData()
    self:UpdateTalentInfo()
    self.typeLength = TalentConfig.GetTalentTypeLength()
    self:InitNode(self.typeLength)
    self:InitScroll(self.typeLength)
end

function TalentMainWindow:TitleActive(active, typeId)
    self.TalentTitle:SetActive(active)
    if typeId then
        self.nodeList[typeId].TypeNum:SetActive(active)
        self.nodeList[typeId].TypeName:SetActive(active)
    end
end

function TalentMainWindow:InitScroll(length)
    local nodeWidth =  self.TalentNode_rect.rect.width 
    local talentsWidth = self.Talents_rect.rect.width
    if not self.totalWidth then
        self.totalWidth = nodeWidth * length
    end
    if self.totalWidth > talentsWidth then
        local count = math.floor((self.totalWidth - talentsWidth)/ nodeWidth)
        self.Talents_rect.sizeDelta = Vector2(self.Talents_rect.sizeDelta.x + nodeWidth * count, self.Talents_rect.sizeDelta.y)
    end
end


function TalentMainWindow:UpdateTalentInfo()
    self.advanturLevel = TalentConfig.GetAdventureLevel()
    self.LevelNum_txt.text = self.advanturLevel
    self.PointNum_txt.text = TalentConfig.GetAllLevelNum()
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.LevelNum.transform.parent)
end

function TalentMainWindow:InitNode(length)
    local idList = TalentConfig.GetTalentTypeId()
    for _, typeId in pairs(idList) do
        local talentNode = GameObject.Instantiate(self.TalentNode,self.TalentNode.transform.parent)
        talentNode:SetActive(true)
        if not self.nodeList then
            self.nodeList = {}
        end
        self.nodeList[typeId] = UtilsUI.GetContainerObject(talentNode.transform)
        self:InitNodePosition(length, typeId)
        local talentTypeInfo = TalentConfig.GetTalentTypeInfo()
        self.nodeList[typeId].TypeName_txt.text = talentTypeInfo[typeId].name
        SingleIconLoader.Load(self.nodeList[typeId].CharacterBg, talentTypeInfo[typeId].icon or "")
        self:InitTalentsListNum(typeId)
        self.nodeList[typeId].NodeInfo_btn.onClick:AddListener(function()
            for k, v in pairs(self.nodeList) do
                if v.TalentNode_Open.activeSelf == true or v.TalentNode_Eixt_erduan.activeSelf == true then 
                    return
                end
            end

            if self.treePanelIsOpen == true then
                return
            end
            self.treePanelIsOpen = true
            local tween = self.nodeList[typeId].TalentNode_rect:DOMove({ x = self.TargetNode_rect.position.x, y = self.TargetNode_rect.position.y }, 0.7)
            tween:SetEase(Ease.OutQuart)
            for j = 1, length do
                if typeId ~= j then
                    UtilsUI.SetActive(self.nodeList[j].TalentNode_Eixt, true)
                end
            end
            self.typeId = typeId
            self:TitleActive(false, self.typeId)
            UtilsUI.SetActive(self.TalentMainWindow_Eixt_erduan, true)
            UtilsUI.SetActive(self.nodeList[typeId].TalentNode_Open_erduan, true)
            UtilsUI.SetActive(self.nodeList[typeId].CricleRotate_Loop, true)
            self.treePanel = self:OpenPanel(TalentTreePanel, typeId)
            
            self.nowNode = typeId
        end)
    end
end

function TalentMainWindow:InitTalentsListNum(typeId)
    self.nodeList[typeId].HasNum_txt.text = mod.TalentCtrl:GetTalentLvByType(typeId)
    self.nodeList[typeId].AllNum_txt.text = "/".. TalentConfig.GetTalentMaxLvByType(typeId)
    self.nodeList[typeId].TypeNum:SetActive(false)
    LuaTimerManager.Instance:AddTimer(1, 0, function()
        self.nodeList[typeId].TypeNum:SetActive(true)
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.nodeList[typeId].HasNum.transform.parent)
    end)
    
end

function TalentMainWindow:InitNodePosition(length, i, useTween)
    if not self.totalWidth then
        self.totalWidth = self.TalentNode_rect.rect.width * length
    end
    local halfWidth = self.TalentNode_rect.rect.width / 2
    local startX = math.floor(-self.totalWidth / 2 + halfWidth)
    if useTween == true then
        local tween = self.nodeList[i].TalentNode_rect:DOAnchorPos({ x = startX + (i-1) * self.nodeList[i].TalentNode_rect.rect.width, y = 0 }, 1)
        tween:SetEase(Ease.OutQuart)
        return
    end
    self.nodeList[i].TalentNode_rect.anchoredPosition = Vector2(startX + (i-1) * self.nodeList[i].TalentNode_rect.rect.width, 0)
end


function TalentMainWindow:CacheCurrencyBar()
    self.CurrencyBar1:OnCache()
end

function TalentMainWindow:InitCurrencyBar()
    self.CurrencyBar1 = Fight.Instance.objectPool:Get(CurrencyBar)
    self.CurrencyBar1:init(self.GoldCurrencyBar, TalentConfig.CurrencyBarType)
end
function TalentMainWindow:OnClick_Close()
    if self.treePanelIsOpen == true then
        self.case = 2
        self.treePanel.MiddleLine_canvas:DOFade(0, 1)
        for i = 1, self.typeLength do
            UtilsUI.SetHideCallBack(self.nodeList[i].TalentNode_StartMove, self:ToFunc("StartMoveTalentNode_HideCallBack"))
            if self.nowNode == i then
                UtilsUI.SetActive(self.nodeList[i].TalentNode_Eixt_erduan, true)
            end
        end
        UtilsUI.SetActive(self.treePanel.TalentTreePanel_Eixt,true)
        UtilsUI.SetActive(self.TalentMainWindow_Open_erduan, true)
        UtilsUI.SetHideCallBack(self.treePanel.TalentTreePanel_Eixt, self:ToFunc("CloseTreePanel_HideCallBack"))
        return
    end
    self.case = 1
end

function TalentMainWindow:Close_HideCallBack()
    if self.case == 1 then 
        WindowManager.Instance:CloseWindow(self)
    else
        self:CloseTreePanel_HideCallBack()
    end
end

function TalentMainWindow:CloseTreePanel_HideCallBack()
    -- for i = 1, self.typeLength do
    --     UtilsUI.SetHideCallBack(self.nodeList[i].TalentNode_StartMove, self:ToFunc("StartMoveTalentNode_HideCallBack"))
    --     if self.nowNode == i then
    --         UtilsUI.SetActive(self.nodeList[i].TalentNode_Eixt_erduan, true)
    --     end
    -- end
    self:TitleActive(true, self.typeId)
end

function TalentMainWindow:StartMoveTalentNode_HideCallBack()
    self:ClosePanel(TalentTreePanel)
    self.treePanelIsOpen = false
    for i = 1, self.typeLength do
        if self.nowNode == i then
            -- 第三个以后返回加淡入淡出
            if i > 2 then
                self.nodeList[i].TalentNode_canvas:DOFade(0, 0.1)
                LuaTimerManager.Instance:AddTimer(1, 0.21, function()
                    self.nodeList[i].TalentNode_canvas:DOFade(1, 0.19)
                end)
            end
            self:InitNodePosition(self.typeLength, i, true)
        else
            UtilsUI.SetActive(self.nodeList[i].TalentNode_Open, true)
        end
    end
end