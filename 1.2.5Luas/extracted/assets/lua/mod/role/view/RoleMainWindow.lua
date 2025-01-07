RoleMainWindow = BaseClass("RoleMainWindow", BaseWindow)

RoleMainWindow.BlackIn = 0.3
RoleMainWindow.BlackOut = 0.4

local DataHeroElement = Config.DataHeroElement.Find
local DataHeroMain = Config.DataHeroMain.Find
local cameraPos = { x = 0, y = 0, z = 0 }
local onSceneLoad = false

function RoleMainWindow:__init()
    self:SetAsset("Prefabs/UI/Role/RoleMainWindow.prefab")

    self.roleIdList = nil
    self.itemObjList = {}
    self.curSelectedRoleId = nil
    self.curSelectedPageType = nil
    self.curRoleData = {}
    self.pagePanelList = {}
end

function RoleMainWindow:__BindListener()
    self:SetHideNode("RoleMainWindowHideNode")
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("Close_HideCallBack"),self:ToFunc("OnBack"))
    self.BlackBgNode_hcb.HideAction:AddListener(function ()
        CurtainManager.Instance:FadeIn(true, RoleMainWindow.BlackIn)
    end)

    self.ShowModelButton_btn.onClick:AddListener(self:ToFunc("OnOpenShowModel"))
    self.HideModelButton_btn.onClick:AddListener(self:ToFunc("OnCloseShowModel"))
    self.ScrollBar_sld.onValueChanged:AddListener(self:ToFunc("OnValueChanged_Camera"))
    self.RoleListPanelButton_btn.onClick:AddListener(self:ToFunc("OnOpenRoleList"))
    
    EventMgr.Instance:AddListener(EventName.RoleInfoUpdate, self:ToFunc("UpdateItemData"))
    EventMgr.Instance:AddListener(EventName.ChangeShowRole, self:ToFunc("setRoleSelect"))

    self:BindRedPoint(RedPointName.RoleList, self.RoleListRedPoint)

    local modelRotation = { x = 0, y = 0, z = 0 }
    local dragBehaviour = self.ModelDrag:AddComponent(UIDragBehaviour)
    dragBehaviour.onDrag = function(data)
        local rotation = Fight.Instance.modelViewMgr:GetView():GetModelRotation("RoleRoot")
        if rotation then
            self.modelInitAngles = rotation.eulerAngles
            modelRotation.x = rotation.eulerAngles.x
            modelRotation.y = rotation.eulerAngles.y - data.delta.x * 0.5
            modelRotation.z = rotation.eulerAngles.z
            Fight.Instance.modelViewMgr:GetView():SetModelRotation("RoleRoot", modelRotation)
        end
    end
end

function RoleMainWindow:__CacheObject()

end

function RoleMainWindow:__Create()
	local callback = function()
		local args = self.args or {}
		local selectType = args._jump and args._jump[1]
		if selectType then
			selectType = tonumber(selectType)
			self.tabPanel:SelectType(selectType)
		end
	end
	
    --初始化tab页
    self.tabPanel = self:OpenPanel(CommonLeftTabPanel, { name = "脉者", name2 = "maizhe", tabList = RoleConfig.RoleMainToggleInfo, callback = callback})
    --初始化模型展示场景
    -- local config = RoleConfig.GetRoleCameraConfig(0, RoleConfig.PageCameraType.Attr)
    -- Fight.Instance.modelViewMgr:GetView():BlendToNewCamera(config.camera_position, config.camera_rotation, 24.5)
    -- Fight.Instance.modelViewMgr:GetView():SetModelRotation("RoleRoot", config.model_rotation)
    Fight.Instance.modelViewMgr:ShowView(ModelViewConfig.ViewType.Role)
end

function RoleMainWindow:__delete()
    EventMgr.Instance:RemoveListener(EventName.RoleInfoUpdate, self:ToFunc("UpdateItemData"))
    EventMgr.Instance:RemoveListener(EventName.ChangeShowRole, self:ToFunc("OnSelectRole"))
end

function RoleMainWindow:__ShowComplete()
    ----初始化角色列表
	local args = self.args or {}
    self.initRole = args.roleId or mod.RoleCtrl:GetCurUseRole()
    mod.RoleCtrl:ChangeShowRole(self.initRole)
    self:RefreshItemList()
    onSceneLoad = false
end

function RoleMainWindow:__Hide()
    CurtainManager.Instance:FadeOut(RoleMainWindow.BlackOut)
end

function RoleMainWindow:__TempShow()
    self.tabPanel:ReSelectType()
end

--# 角色列表
function RoleMainWindow:RefreshItemList()
    local roleIdList = mod.RoleCtrl:GetRoleIdList()
    local roleCount = 0
    for k, v in pairs(roleIdList) do
        roleCount = roleCount + 1
        table.insert(self.curRoleData, v)
    end

    local listNum = roleCount
    self.RoleItemList_recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
    self.RoleItemList_recyceList:SetCellNum(listNum)
end

function RoleMainWindow:RefreshItemCell(index, go)
    if not go then
        return
    end

    local roleItem
    local itemObj
    if self.itemObjList[index] then
        roleItem = self.itemObjList[index].roleItem
        itemObj = self.itemObjList[index].itemObj
    else
        roleItem = RoleItem.New()
        itemObj = go
        self.itemObjList[index] = {}
        self.itemObjList[index].roleItem = roleItem
        self.itemObjList[index].itemObj = itemObj
        self.itemObjList[index].isSelect = false
    end

    --if self.firstShow then
    --    roleItem.showNode = go.transform:Find("ItemRefreshNode_").gameObject
    --    go.transform:Find("ItemShowNode_").gameObject:SetActive(true)
    --else
    --    roleItem.showNode:SetActive(true)
    --end

    roleItem:InitItem(itemObj, self.curRoleData[index])
    --roleItem:Show()
    local onClickFunc = function()
        self:OnClick_SingleItem(self.itemObjList[index])
    end
    roleItem:SetBtnEvent(onClickFunc)
    if not self.curSelectItem and self.itemObjList[index].roleItem.roleId == self.initRole then
        self:OnClick_SingleItem(self.itemObjList[index])
    end
end

function RoleMainWindow:OnClick_SingleItem(singleItem, notFireEvent)
    if self.curSelectItem and next(self.curSelectItem) then
        self.curSelectItem.isSelect = false
        self.curSelectItem.roleItem:SetSelected_Normal(false)
    end

    singleItem.isSelect = not singleItem.isSelect
    singleItem.roleItem:SetSelected_Normal(singleItem.isSelect)
    self.curSelectItem = singleItem
    if not notFireEvent then
        mod.RoleCtrl:ChangeShowRole(singleItem.roleItem.roleId)
        EventMgr.Instance:Fire(EventName.ChangeShowRole, singleItem.roleItem.roleId)
    end
    self:OnSelectRole(singleItem.roleItem.roleId)
end

function RoleMainWindow:setRoleSelect(roleId)
    for index, item in pairs(self.itemObjList) do
        if item.roleItem.roleId == roleId then
            self:OnClick_SingleItem(self.itemObjList[index], true)
        end
    end
end

--#角色模型
function RoleMainWindow:OnSelectRole(roleId)
    if roleId == self.curRoleId then
        return
    end
    self.curRoleId = roleId
    SingleIconLoader.Load(self.ElementIcon, DataHeroElement[DataHeroMain[roleId].element].element_icon_big)
    self.ElementText_txt.text = "元素/" .. DataHeroElement[DataHeroMain[roleId].element].name
    
    if self.tabPanel then 
        self.tabPanel:RefreshRedPoint()
    end

    Fight.Instance.modelViewMgr:GetView():LoadModel("RoleRoot", roleId, function()
        EventMgr.Instance:Fire(EventName.ShowRoleModelLoad, roleId)
        if self.onEnlargeModel then
            self:SetIsCanEnlarge(true)
        end
    end)
end

function RoleMainWindow:SetIsCanEnlarge(isCan)
    self.ShowModelButton:SetActive(isCan)
    self.HideModelButton:SetActive(false)
    self.ModelDetailControl:SetActive(false)
    self.onEnlargeModel = false
    self.ScrollBar_sld.value = 1
end

function RoleMainWindow:OnOpenShowModel()
    if self.tabPanel:GetCurSelectTabId() == RoleConfig.PageType.Attribute then
        local cameraType = RoleConfig.PageCameraType.Enlarge
        self.ScrollBar_sld.value = 1
        self.ModelDetailControl:SetActive(true)
        self.onEnlargeModel = true
        local config = RoleConfig.GetRoleCameraConfig(self.curRoleId or 0, cameraType)
        Fight.Instance.modelViewMgr:GetView():BlendToNewCamera(config.camera_position, config.camera_rotation, 24.5)
        self.ShowModelButton:SetActive(false)
        self.HideModelButton:SetActive(true)
        local blurConfig = RoleConfig.GetRoleBlurConfig(self.curRoleId, RoleConfig.PageBlurType.Enlarge)
        Fight.Instance.modelViewMgr:GetView():SetDepthOfFieldBoken(true, blurConfig.focus_distance, blurConfig.focal_length, blurConfig.aperture)
    end
end

function RoleMainWindow:OnCloseShowModel()
    if self.tabPanel:GetCurSelectTabId() == RoleConfig.PageType.Attribute then
        local cameraType = RoleConfig.PageCameraType.Attr
        self.ModelDetailControl:SetActive(false)
        self.onEnlargeModel = false
        local config = RoleConfig.GetRoleCameraConfig(self.curRoleId or 0, cameraType)
        Fight.Instance.modelViewMgr:GetView():BlendToNewCamera(config.camera_position, config.camera_rotation, 24.5)
        self.ShowModelButton:SetActive(true)
        self.HideModelButton:SetActive(false)
        local blurConfig = RoleConfig.GetRoleBlurConfig(self.curRoleId, RoleConfig.PageBlurType.Attr)
        Fight.Instance.modelViewMgr:GetView():SetDepthOfFieldBoken(true, blurConfig.focus_distance, blurConfig.focal_length, blurConfig.aperture)
    end
end

function RoleMainWindow:OnValueChanged_Camera(value)
    local cameraType
    if self.onEnlargeModel then
        cameraType = RoleConfig.PageCameraType.Enlarge
    else
        cameraType = RoleConfig.PageCameraType.Attr
    end
    local config = RoleConfig.GetRoleCameraConfig(self.curRoleId or 0, cameraType)
    cameraPos.x = config.camera_position.x
    cameraPos.y = config.camera_position.y - 0.8 * (1 - value)
    cameraPos.z = config.camera_position.z
    Fight.Instance.modelViewMgr:GetView():SetCameraSettings(cameraPos, config.camera_rotation, 24.5)
end

--#返回
function RoleMainWindow:OnBack()
    for _, panel in pairs(self.panelList) do
        if panel["OnClose"] then
            panel:OnClose()
        end
    end
end

function RoleMainWindow:Close_HideCallBack()
    Fight.Instance.modelViewMgr:HideView(ModelViewConfig.ViewType.Role)
    WindowManager.Instance:CloseWindow(RoleMainWindow)
end

function RoleMainWindow:OnOpenRoleList()
    self.tabPanel:SelectType(RoleConfig.PageType.Attribute)
    WindowManager.Instance:OpenWindow(RoleListWindow, { roleId = self.curRoleId })
end

--打开Ui前,先加载场景
function RoleMainWindow.OpenWindow(roleId, args)
    if onSceneLoad then
        return
    end
    onSceneLoad = true
    Fight.Instance.modelViewMgr:GetView():LoadScene("Prefabs/Scene/SceneRoleShow/SceneRoleShow.prefab", function()
        Fight.Instance.modelViewMgr:GetView():SetScenePosition(0, 0, 0)

        Fight.Instance.modelViewMgr:GetView():LoadModel("RoleRoot", roleId, function()
			args = args or {}
			args.roleId = roleId
            WindowManager.Instance:OpenWindow(RoleMainWindow,args)
        end)
    end)
end

function RoleMainWindow:ShieldDrag(isDrag)
    UtilsUI.SetActive(self.ModelDrag, isDrag or false)
end