PlayerHeadImageEditorPanel = BaseClass("PlayerHeadImageEditorPanel", BasePanel)

PlayerHeadImageEditorPanel.ShowType = 
{
    HeadIcon = 1,
    Frame = 2
}

function PlayerHeadImageEditorPanel:__init(parent)
    self.parent = parent
    self:SetAsset("Prefabs/UI/SystemMenu/PlayerHeadImageEditorPanel.prefab")
    self.headImageMap = {}
    --self.objectList = {}
	self.selectId = 0
	self.usedId = 0
end

function PlayerHeadImageEditorPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function PlayerHeadImageEditorPanel:__delete()
    self.headImageMap = {}
    self.objectList = {}
	self.selectId = 0
	self.usedId = 0
end

function PlayerHeadImageEditorPanel:__BindListener()
     
    self:BindCloseBtn(self.CommonGrid_btn,self:ToFunc("Hide"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Hide"))

    self.ChangeButton_btn.onClick:AddListener(self:ToFunc("OnClick_ChangeHeadImage"))
    self.HeadIconBtn_btn.onClick:AddListener(self:ToFunc("OnClick_HeadImage"))
    self.FrameBtn_btn.onClick:AddListener(self:ToFunc("OnClick_FrameImage"))
end

function PlayerHeadImageEditorPanel:__Hide()
    InputManager.Instance:MinusLayerCount("UI")
    PanelManager.Instance:ClosePanel(self)
end

function PlayerHeadImageEditorPanel:__Show() 
    InputManager.Instance:AddLayerCount("UI")
    local setting = { bindNode = self.BlurNode }
    local callBack = function ()
        self.gameObject:SetActive(true)
    end
    self:SetBlurBack(setting,callBack)
    self.TitleText_txt.text = TI18N("更换头像")
    self.gameObject:SetActive(false)
    self.type = InformationConfig.HeadIconType.Avatar
    self.usedId = mod.InformationCtrl:GetPlayerInfo().avatar_id or 0
    self.selectId = self.usedId
    self:CreateHeadImageMap()
    self:ShowDetail()
    self.NameText_txt.text = mod.InformationCtrl:GetPlayerInfo().nick_name
end

function PlayerHeadImageEditorPanel:__ShowComplete()
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
    self:ClearAll()
    local roleIdList
    if self.type == InformationConfig.HeadIconType.Avatar then
        roleIdList = mod.InformationCtrl:GetHeadIconList() -- mod.RoleCtrl:GetRoleIdList()
    elseif self.type == InformationConfig.HeadIconType.Frame then
        roleIdList = mod.InformationCtrl:GetFrameList()
    end
    for k, v in pairs(roleIdList) do
        if self.headImageMap[v] == nil then
            self.headImageMap[v] = self:CreateUIObject(v)
            --(self.objectList,self.headImageMap[v].object)
            self.headImageMap[v].object.transform:SetParent(self.Content.transform)
            self.headImageMap[v].object.transform.localScale = Vector3(1, 1, 1)
        end
        UtilsUI.SetActive(self.headImageMap[v].object,true)
		-- if v == self.usedId then
		-- 	self.headImageMap[v].object.transform:SetAsFirstSibling()
		-- end
        self:UpdateItem(v)
    end
end

function PlayerHeadImageEditorPanel:UpdateItem(id)
    local itemObjInfo = self.headImageMap[id]
    if not itemObjInfo.isInit then
        local path 
        if self.type == InformationConfig.HeadIconType.Avatar then
            path = RoleConfig.HeroBaseInfo[id].rhead_icon
        elseif self.type == InformationConfig.HeadIconType.Frame then
            path = InformationConfig.GetFrameIcon(id)
        end
            
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
    if self.type == InformationConfig.HeadIconType.Avatar then
        local path = RoleConfig.HeroBaseInfo[self.selectId].rhead_icon
        SingleIconLoader.Load(self.PreviewHeadIcon, path)
    else
        local config = InformationConfig.GetFrameConfig(self.selectId)
        SingleIconLoader.Load(self.PreviewFrameIcon, config.icon)
        self.NameText_txt.text = config.title
    end
    
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
    mod.InformationCtrl:ModifyPlayerHeadImage(self.selectId,self.type)
    --EventMgr.Instance:Fire(EventName.ModifyPlayerInfo)
    self.ChangeButton:SetActive(false)
    self:SetHeadImage(self.selectId)
end

function PlayerHeadImageEditorPanel:OnClick_HeadImage()
    --self:ClearAll()
    self.HeadIconTxt_txt.color = Color(0.29,0.31,0.35)
    self.FrameTxt_txt.color = Color(0.71,0.72,0.75)
    UtilsUI.SetActive(self.Frame,false)
    UtilsUI.SetActive(self.HeadIcon,true)
    self.type = InformationConfig.HeadIconType.Avatar
    self.usedId = mod.InformationCtrl:GetPlayerInfo().avatar_id or 0
    self.selectId = self.usedId
    UtilsUI.SetActive(self.PreviewFrameIcon,false)
    self.NameText_txt.text = mod.InformationCtrl:GetPlayerInfo().nick_name
    self:CreateHeadImageMap()
    self:ShowDetail()
end

function PlayerHeadImageEditorPanel:OnClick_FrameImage()
    --self:ClearAll()
    self.FrameTxt_txt.color = Color(0.29,0.31,0.35)
    self.HeadIconTxt_txt.color = Color(0.71,0.72,0.75)
    UtilsUI.SetActive(self.Frame,true)
    UtilsUI.SetActive(self.HeadIcon,false)
    self.type = InformationConfig.HeadIconType.Frame
    self.usedId = mod.InformationCtrl:GetPlayerInfo().frame_id or 1001
    self.selectId = self.usedId
    UtilsUI.SetActive(self.PreviewFrameIcon,true)
    self:CreateHeadImageMap()
    self:ShowDetail()
end

function PlayerHeadImageEditorPanel:ClearAll()
    if not self.headImageMap or not next(self.headImageMap) then return end
    for k, v in pairs(self.headImageMap) do
        UtilsUI.SetActive(v.object,false)
    end
end