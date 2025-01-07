TalentTreeNode = BaseClass("TalentTreeNode", PoolBaseClass)

function TalentTreeNode:__init()
	self.parent = nil
	self.object = nil
    self.talentObjList = {}
    self.talentItemList = {}
	self.node = {}
end

function TalentTreeNode:OnReset()
    self.parent = nil
    self.object = nil
    TableUtils.ClearTable(self.talentObjList)

    for k, item in pairs(self.talentItemList) do
        PoolManager.Instance:Push(PoolType.class, "TalentItem", item)
    end
    TableUtils.ClearTable(self.talentItemList)
    TableUtils.ClearTable(self.node)
end

function TalentTreeNode:__delete()

end

function TalentTreeNode:InitTree(object, playerLv, unlockLv, talentList)
	self.node = object
	
    self.playerLv = playerLv
    self.unlockLv = unlockLv
    self.isLock = self.unlockLv > self.playerLv
    self.count = #talentList
    self.talentList = talentList

    self:SetLv()
    self:SetTree()
end

local lockColor = Color(0.463,0.463,0.494)
local unLockColor = Color(0.235,0.235,0.262)
function TalentTreeNode:SetLv()
    if self.isLock then
        self.node.LevelTxt_txt.color = lockColor
        self.node.LevelNum_txt.color = lockColor
    else
        self.node.LevelTxt_txt.color = unLockColor
        self.node.LevelNum_txt.color = unLockColor
    end
    UtilsUI.SetActive(self.node.Lock ,self.isLock)
	self.node.LevelNum_txt.text = self.unlockLv
end

function  TalentTreeNode:SetTree()
    for i = 1, 6 do
        UtilsUI.SetActive(self.node["Item"..i], i == self.count)
    end
    if self.count > 3 then
        UtilsUI.SetActive(self.node.Item3, true)
    end
    for index, value in ipairs(self.talentList) do
        local talentItem
        local talentObj
        if self.talentObjList[index] then
            talentItem = self.talentObjList[index].talentItem
            talentObj = self.talentObjList[index].talentObj
        else
            talentItem = PoolManager.Instance:Pop(PoolType.class, "TalentItem")
            if not talentItem then
                talentItem = TalentItem:New()
            end
            if self.count <= 3 or index >= 4 then
                talentObj = self.node["TalentItem" .. self.count .. "_" .. index].gameObject
            else
                talentObj = self.node["TalentItem3" .. "_" .. index ].gameObject
            end
            self.talentObjList[index] = {}
            self.talentObjList[index].talentItem = talentItem
            self.talentObjList[index].talentObj = talentObj
            self.talentObjList[index].isSelect = false
        end
        table.insert(self.talentItemList, talentItem)
        talentItem:InitTalentItem(talentObj,value.talent_id,self.isLock)
        local onClickFunc = function()
            self:OnClick_TalentItem(self.talentObjList[index].talentItem)
        end
        talentItem:SetBtnEvent(false,onClickFunc)
    end
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.node.Item1.transform.parent)
end

function TalentTreeNode:RefreshTalentCanUpGrade()
    for k, item in pairs(self.talentItemList) do
        item:SetCanUpgrade()
    end
end

function TalentTreeNode:OnClick_TalentItem(talentItem)
    EventMgr.Instance:Fire(EventName.ClickTalentItem, talentItem)
end