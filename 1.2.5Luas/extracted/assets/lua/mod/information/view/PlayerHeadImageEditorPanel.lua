PlayerHeadImageEditorPanel = BaseClass("PlayerHeadImageEditorPanel", BasePanel)

function PlayerHeadImageEditorPanel:__init(parent)
    self.parent = parent
    self:SetAsset("Prefabs/UI/SystemMenu/PlayerHeadImageEditorPanel.prefab")
    self.headImageMap = {}
	self.selectId = 0
	self.usedId = 0
end

function PlayerHeadImageEditorPanel:__delete()
    if self.blurBack then
        self.blurBack:Destroy()
    end
    self.headImageMap = {}
	self.selectId = 0
	self.usedId = 0
end

function PlayerHeadImageEditorPanel:__BindListener()
    self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.CommonGrid_btn,self:ToFunc("Hide"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Hide"))

    self.ChangeButton_btn.onClick:AddListener(self:ToFunc("OnClick_ChangeHeadImage"))
end

function PlayerHeadImageEditorPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function PlayerHeadImageEditorPanel:__Show()
    self.gameObject:SetActive(false)
    self.usedId = mod.InformationCtrl:GetPlayerInfo().photo_id or 0
    self.selectId = self.usedId
    self:CreateHeadImageMap()
    self:ShowDetail()
    self.PlayerNameText_txt.text = mod.InformationCtrl:GetPlayerInfo().nick_name
end

function PlayerHeadImageEditorPanel:__ShowComplete()
     if not self.blurBack then
         local setting = { bindNode = self.BlurNode }
         self.blurBack = BlurBack.New(self, setting)
     end
     local callBack = function ()
         self.gameObject:SetActive(true)
     end
     self.blurBack:Show({callBack})
    self.gameObject:SetActive(true)
end

function PlayerHeadImageEditorPanel:CreateUIObject(id)
	local objectInfo = {}
	objectInfo.object = GameObject.Instantiate(self.HeadItemObj)
    local objectTransform = objectInfo.object.transform
    objectTransform.localScale = Vector3(1, 1, 1)
    objectInfo.SelectBox = objectTransform:Find("HeadItem/SelectBox")
    objectInfo.UsedBG = objectTransform:Find("HeadItem/BG/UsedBG")
    objectInfo.CurBG = objectTransform:Find("HeadItem/BG/CurBG")
    objectInfo.UsedObj = objectTransform:Find("HeadItem/UsedObj")
    objectInfo.HeadIcon = objectTransform:Find("HeadItem/UsedBG/HeadIcon")
    objectInfo.Button = objectTransform:Find("HeadItem"):GetComponent(Button)
    objectInfo.object:SetActive(true)
    objectInfo.isInit = false
	objectInfo.imageId = id
	return objectInfo
end

function PlayerHeadImageEditorPanel:CreateHeadImageMap()
    local roleIdList = mod.RoleCtrl:GetRoleIdList()
    for k, v in pairs(roleIdList) do
        self.headImageMap[v] = self:CreateUIObject(v)
        self.headImageMap[v].object.transform:SetParent(self.Content.transform)
        self.headImageMap[v].object.transform.localScale = Vector3(1, 1, 1)
		if v == self.usedId then
			self.headImageMap[v].object.transform:SetAsFirstSibling()
		end
        self:UpdateItem(v)
    end
end

function PlayerHeadImageEditorPanel:UpdateItem(id)
    local itemObjInfo = self.headImageMap[id]
    if not itemObjInfo.isInit then
        local path = RoleConfig.HeroBaseInfo[id].rhead_icon
        SingleIconLoader.Load(itemObjInfo.HeadIcon.gameObject, path)
        itemObjInfo.isInit = true
    end
    itemObjInfo.SelectBox:SetActive(self.selectId == itemObjInfo.imageId)
    itemObjInfo.UsedBG:SetActive(self.usedId == itemObjInfo.imageId)
    itemObjInfo.UsedObj:SetActive(self.usedId == itemObjInfo.imageId)
    itemObjInfo.CurBG:SetActive(self.selectId == itemObjInfo.imageId)
    itemObjInfo.Button.onClick:AddListener(function ()
        self:SelectItem(itemObjInfo.imageId)
    end)
end

function PlayerHeadImageEditorPanel:SelectItem(id)
    if id == self.selectId then return end
    local oldItemObjInfo = self.headImageMap[self.selectId]
    if oldItemObjInfo then
        oldItemObjInfo.SelectBox:SetActive(false)
        oldItemObjInfo.CurBG:SetActive(false)
    end
    local itemObjInfo =  self.headImageMap[id]
    itemObjInfo.SelectBox:SetActive(true)
    itemObjInfo.CurBG:SetActive(true)
    self.selectId = id
    self:ShowDetail()
end

function PlayerHeadImageEditorPanel:ShowDetail()
    local path = RoleConfig.HeroBaseInfo[self.selectId].rhead_icon
    SingleIconLoader.Load(self.PreviewHeadIcon, path)
    self.ChangeButton:SetActive(self.selectId ~= self.usedId)
end

function PlayerHeadImageEditorPanel:SetHeadImage(id)
    if id == self.usedId then return end
    local oldItemObjInfo = self.headImageMap[self.usedId]
    if oldItemObjInfo then
        oldItemObjInfo.UsedBG:SetActive(false)
        oldItemObjInfo.UsedObj:SetActive(false)
    end
    local itemObjInfo = self.headImageMap[id]
    itemObjInfo.UsedBG:SetActive(true)
    itemObjInfo.UsedObj:SetActive(true)
    self.usedId = id
end

function PlayerHeadImageEditorPanel:OnClick_ChangeHeadImage()
    mod.InformationCtrl:ModifyPlayerHeadImage(self.selectId)
    EventMgr.Instance:Fire(EventName.ModifyPlayerInfo)
    self.ChangeButton:SetActive(false)
    self:SetHeadImage(self.selectId)
end