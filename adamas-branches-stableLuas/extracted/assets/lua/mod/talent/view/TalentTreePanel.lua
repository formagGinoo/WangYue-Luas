TalentTreePanel = BaseClass("TalentTreePanel", BasePanel)

function TalentTreePanel:__init(parent)  
    self:SetAsset("Prefabs/UI/Talent/TalentTreePanel.prefab")
    self.parent = parent
    self.talentList = {}
    self.talentType = nil
    self.playerLv = nil
    self.selectTalent = nil
    self.scrollRect = nil
    self.talentTreeObjectList = {}
    self.talentTreeNodeList = {}
end

function TalentTreePanel:__BindListener()
    EventMgr.Instance:AddListener(EventName.ClickTalentItem, self:ToFunc("OnClick_TalentItem"))
    self.BgBtn_btn.onClick:AddListener(self:ToFunc("OnClick_CloseTipsBtn"))
    self.Viewport_btn.onClick:AddListener(self:ToFunc("OnClick_CloseTipsBtn"))
    EventMgr.Instance:AddListener(EventName.UpdateTalentData, self:ToFunc("UpGradeRefresh"))
end

function TalentTreePanel:__Create()

end

function TalentTreePanel:__delete()
    self.parent = nil
    self.talentList = nil
    self.talentType = nil
    self.playerLv = nil
    self.selectTalent = nil
    self.scrollRect = nil

    if self.TalentTips then
        self.TalentTips = nil
    end

    for k, treeNode in pairs(self.talentTreeNodeList) do
        PoolManager.Instance:Push(PoolType.class, "TalentTreeNode",treeNode)
    end
    TableUtils.ClearTable(self.talentTreeNodeList)
    EventMgr.Instance:RemoveListener(EventName.ClickTalentItem, self:ToFunc("OnClick_TalentItem"))
    EventMgr.Instance:RemoveListener(EventName.UpdateTalentData, self:ToFunc("UpGradeRefresh"))
end

function TalentTreePanel:__Hide()
    for _, treeObj in pairs(self.talentTreeObjectList) do
        treeObj.object:SetActive(false)
    end
    TableUtils.ClearTable(self.talentList)
end

function TalentTreePanel:__Show()
    self.talentType = self.args
    self.playerLv = mod.WorldLevelCtrl:GetAdventureInfo().lev
    self.scrollRect = self.TalentBody:GetComponent(ScrollRect)
    self.Content_rect.anchoredPosition = {x = 1000 , y = 0}
    self:GetTalentInfo(TalentConfig.GetTalentListByType(self.talentType))
    self:SetTittle()
    self:SetTalentTree()
    self.MiddleLine_canvas:DOFade(1, 2)
end

function TalentTreePanel:__ShowComplete()

end

function TalentTreePanel:SetTittle()
    self.TittleText_txt.text = TalentConfig.GetTalentTypeNameByType(self.talentType)
    self.HasNum_txt.text = mod.TalentCtrl:GetTalentLvByType(self.talentType)
    self.AllNum_txt.text = "/" .. TalentConfig.GetTalentMaxLvByType(self.talentType)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.AllNum.transform.parent)
end

function TalentTreePanel:SetTalentTree()
    for i, level in pairs(self.talentList) do
        local treeObj = self.talentTreeObjectList[i] or self:getTreeNodeItem()
        UnityUtils.SetLocalPosition(treeObj.objectTransform, 0, 0, 0)
        treeObj.object:SetActive(true)
        self.talentTreeObjectList[i] = treeObj

        local treeNode = PoolManager.Instance:Pop(PoolType.class, "TalentTreeNode")
        if not treeNode then
            treeNode = TalentTreeNode:New()
        end
        treeNode:InitTree(treeObj,self.playerLv,level.unlock_level,level.list)

        table.insert(self.talentTreeNodeList, treeNode)
    end
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.Content.transform)
end

function TalentTreePanel:UpGradeRefresh()
    self:SetTittle()
    for k, treeNode in pairs(self.talentTreeNodeList) do
        treeNode:RefreshTalentCanUpGrade()
    end
end

function TalentTreePanel:GetTalentInfo(talents)
    for _, v in pairs(talents) do
        if 0 == #self.talentList then
            table.insert(self.talentList, {unlock_level = v.unlock_level, list = {}})
        end

        for k, level in pairs(self.talentList) do
            if level.unlock_level == v.unlock_level then
                table.insert(level.list, v)
                break
            end
            if k == #self.talentList then
                table.insert(self.talentList, {unlock_level = v.unlock_level, list = {}})
            end
        end
    end

    table.sort(self.talentList, function(a, b)
        return a.unlock_level < b.unlock_level
    end)
end

function TalentTreePanel:OnClick_TalentItem(talentItem)
    if self.TalentTips and self.TalentTips.TalentInfoTipsPanel_Eixt.activeSelf == true then
        return
    end
    if self.selectTalent and self.selectTalent ~= talentItem  then
        self.selectTalent.isSelect = false
        self.selectTalent:SetSelectBox()
    end
    talentItem.isSelect = true
    talentItem:SetSelectBox()
    self.selectTalent = talentItem
    self:ShowInfoTips(talentItem.talentInfo,talentItem.isLock)
    self:MoveToCenter(talentItem)
end

function TalentTreePanel:ShowInfoTips(talentInfo,islock)
    UtilsUI.SetActive(self.BgBtn,true)
    self.Viewport_btn.interactable = true
    if self.parentWindow:GetPanel(TalentInfoTips) then
        self.TalentTips:SetInfo(talentInfo.talent_id, islock)
        --UtilsUI.SetActive(self.TalentInfoTips,true)
        return
    end
    self.TalentTips = self.parentWindow:OpenPanel(TalentInfoTips, {talentId = talentInfo.talent_id,isLock = islock, treePanel = self})
end

function TalentTreePanel:OnClick_CloseTipsBtn()
    
    if self.TalentTips then
        self.TalentTips:OnClick_CloseBtnWithAnim()
    end
    
    self:CloseSelectTips()
end

function TalentTreePanel:CloseSelectTips()
    UtilsUI.SetActive(self.BgBtn,false)
    self.Viewport_btn.interactable = false
    self.scrollRect.movementType = 1
    self.scrollRect.enabled = true

    if self.selectTalent then
        self.selectTalent.isSelect = false
        self.selectTalent:SetSelectBox()
        self.selectTalent = nil
    end
end

function TalentTreePanel:AfterCloseInfoTips()
    self.parentWindow:ClosePanel(TalentInfoTips)
    self.TalentTips = nil
end

function TalentTreePanel:MoveToCenter(talentItem) 
    local node = talentItem
    local centerPos = self.CenterPoint_rect.position
    local nodePos = node.object.transform.position
    local offect = centerPos - nodePos
    self.scrollRect.enabled = false
    self.scrollRect.movementType = 2
    offect.y = 0
    if offect.x > -0.3 then return end
    
    self.Content.transform:DOMoveX(self.Content_rect.position.x + offect.x,0.3)
end

function TalentTreePanel:getTreeNodeItem()
    local obj = self:PopUITmpObject("TalentTreeNode")
    obj.objectTransform:SetParent(self.Content.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    return obj
end
