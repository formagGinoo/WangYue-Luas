RolePeriodPanel = BaseClass("RolePeriodPanel", BasePanel)

function RolePeriodPanel:__init()
    self:SetAsset("Prefabs/UI/Role/RolePeriod/RoleRightPartPeriodPanel.prefab")
    self.periodNodeMap = {}
    self.curRolePeriodInfoList = {}
end

function RolePeriodPanel:__delete()
    if self.activeItem then
        PoolManager.Instance:Push(PoolType.class, "CommonItem", self.activeItem)
    end
    
    for k, v in pairs(self.periodNodeMap) do
        GameObject.Destroy(v.gameObject)
    end
    if self.periodAssetLoader then
        AssetMgrProxy.Instance:CacheLoader(self.periodAssetLoader)
        self.periodAssetLoader = nil
    end
end

function RolePeriodPanel:__Create()
    self.periodAssetLoader = AssetMgrProxy.Instance:GetLoader("PeriodAssetLoader")
    --local curRole = self:GetCurRole()
    local modelView = self:GetModelView()
    --local roleCamera = RoleConfig.GetRoleCameraConfig(curRole, RoleConfig.PageCameraType.Period)
    local canvas = modelView:GetTargetTransform("RolePreiodCanvas")
    self.canvas = canvas
    UtilsUI.GetContainerObject(canvas, self)
end

function RolePeriodPanel:__CacheObject()
    --self:SetCacheMode(UIDefine.CacheMode.hide)
end

function RolePeriodPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.ChangeShowRole, self:ToFunc("ChangeShowRole"))
    EventMgr.Instance:AddListener(EventName.RoleInfoUpdate, self:ToFunc("RolePeriodActive"))
    EventMgr.Instance:AddListener(EventName.ShowRoleModelLoad, self:ToFunc("SetModelView"))
end

function RolePeriodPanel:__BindListener()
    self.BackCloseButton_btn.onClick:AddListener(self:ToFunc("CloseLeftTips"))
    self.LeftPartUnActiveButton_btn.onClick:AddListener(self:ToFunc("OnClickActiveButton"))
end

function RolePeriodPanel:__Show()
    self.uid = self.args.uid
    if self.uid then
        UtilsUI.SetActiveByScale(self.LeftPartUnActive,false)
        UtilsUI.SetActiveByScale(self.LeftPartActive,false)
    end
    UtilsUI.SetActive(self.ActivingMask, false)
    
    UtilsUI.SetActive(self.LeftPart, false)
    UtilsUI.SetHideCallBack(self.RoleRightPartPeriodPanel_out, function ()
        if not UtilsBase.IsNull(self.LeftPart) then
            UtilsUI.SetActive(self.LeftPart, false)
        end
    end)

    UtilsUI.SetActive(self.canvas, true)
    if not self.activeItem then
        self.activeItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem") or CommonItem.New()
    end

    self.curCameraType = RoleConfig.PageCameraType.Period
    self.curBlurType = RoleConfig.PageBlurType.Period

    self.isClose = false

    self:ChangeShowRole(self:GetCurRole())
    UnityUtils.SetAnchoredPosition(self.PeriodNode.transform, 0, 0)
    self.isOpenActivePage = false
end

function RolePeriodPanel:__ShowComplete()
    --self:ChangeShowRole(self:GetCurRole())
end

function RolePeriodPanel:__Hide()
    if self.isOpenActivePage then
        self.curCameraType = RoleConfig.PageCameraType.Period
        self.curBlurType = RoleConfig.PageBlurType.Period
        self.periodNodeMap[self.curShowRold].animator:Play("UI_PeriodV4_xuanzhong_out_PC")

        self:SwitchSelectPeriodItem(nil)
        UtilsUI.SetActive(self.LeftPart, false)
        UnityUtils.SetAnchoredPosition(self.PeriodNode.transform, 0, 0)

        self:OnCloseLeftTips(self.curSelectItem, self.curShowRold)
        self.curSelectItem = nil
        self.isOpenActivePage = false
    end

    self.isClose = true

    self.periodNodeMap[self.curShowRold].animator:Play("UI_PeriodV4_out_PC")

    EventMgr.Instance:RemoveListener(EventName.ChangeShowRole, self:ToFunc("ChangeShowRole"))
    EventMgr.Instance:RemoveListener(EventName.RoleInfoUpdate, self:ToFunc("RolePeriodActive"))
    EventMgr.Instance:RemoveListener(EventName.ShowRoleModelLoad, self:ToFunc("SetModelView"))
end

function RolePeriodPanel:ChangeShowRole(roleId)
    local periodInfo = RoleConfig.GetRolePeriodInfo(roleId, 1)
    if periodInfo then
        --UnityUtils.SetAnchored3DPosition(self.RolePeriodPanel_rect, 0, 0, periodInfo.prefeb_height)
        local perfebPosition = periodInfo.perfeb_position
        UnityUtils.SetAnchored3DPosition(self.RolePeriodPanel_rect, perfebPosition.x, perfebPosition.y, perfebPosition.z)
        local perfebRotation = periodInfo.perfeb_rotation
        UnityUtils.SetLocalEulerAngles(self.RolePeriodPanel_rect, perfebRotation.x, perfebRotation.y, perfebRotation.z)
        local perfebScale = periodInfo.perfeb_scale
        UnityUtils.SetLocalScale(self.RolePeriodPanel_rect, perfebScale.x, perfebScale.y, perfebScale.z)
    end
    
    if self.curShowRold then
        if self.curShowRold == roleId then
            --self:SetModelView(roleId, self.curCameraType, self.curBlurType)
            return
        else
            if not UtilsBase.IsNull(self.periodNodeMap[self.curShowRold].animator) then
                self.periodNodeMap[self.curShowRold].animator:Play("UI_PeriodV4_out_PC")
            end
            UtilsUI.SetActive(self.periodNodeMap[self.curShowRold].gameObject, false)
        end
    end
    if self.isOpenActivePage then
        self.curCameraType = RoleConfig.PageCameraType.Period
        self.curBlurType = RoleConfig.PageBlurType.Period
        self.periodNodeMap[self.curShowRold].animator:Play("UI_PeriodV4_xuanzhong_out_PC")

        self:SwitchSelectPeriodItem(nil)
        UtilsUI.SetActive(self.LeftPart, false)
        UnityUtils.SetAnchoredPosition(self.PeriodNode.transform, 0, 0)
        self.isOpenActivePage = false

        self:OnCloseLeftTips(self.curSelectItem, self.curShowRold)
        self.curSelectItem = nil
    end
    self.curShowRold = roleId
    self:LoadPeriodNode(roleId, self.curCameraType, self.curBlurType)
    self:SetModelView(roleId, self.curCameraType, self.curBlurType)
end

function RolePeriodPanel:SetModelView(roleId, cameraType, blurType)
    cameraType = cameraType or self.curCameraType
    local modelView = self:GetModelView()
    
    local roleCamera = RoleConfig.GetRoleCameraConfig(roleId, cameraType or self.curCameraType)

    --UnityUtils.SetAnchored3DPosition(self.canvas.transform, roleCamera.camera_position.x, roleCamera.camera_position.y, roleCamera.camera_position.z - 2.15 - 2)

    modelView:BlendToNewCamera(roleCamera.camera_position, roleCamera.camera_rotation, 24.5)
    --
    modelView:SetModelRotation("RoleRoot", roleCamera.model_rotation)
    modelView:PlayModelAnim("RoleRoot", roleCamera.anim, 0.5)

    modelView:RecordCamera()

    local blurConfig = RoleConfig.GetRoleBlurConfig(roleId, blurType or self.curBlurType)
    self:GetModelView():SetDepthOfFieldBoken(true, blurConfig.focus_distance, blurConfig.focal_length, blurConfig.aperture)
end

--EventMgr.Instance:Fire(EventName.ShowRoleModelLoad, roleId)

function RolePeriodPanel:LoadPeriodNode(roleId)
    local periodInfo = RoleConfig.GetRolePeriodInfo(roleId, 1)
    if not periodInfo then
        LogError(string.format("角色Id %d 没有找到对应的脉象信息", roleId))
        return
    end
    if self.periodNodeMap[roleId] then
        self:InitPeriodNode(self.periodNodeMap[roleId], roleId)
        if not UtilsBase.IsNull(self.periodNodeMap[self.curShowRold].animator) then
            self.periodNodeMap[self.curShowRold].animator:Play("UI_PeriodV4_in_PC", 0, 0)
        end
        return
    end

    CurtainManager.Instance:EnterWait()

    self.curLoadPeriodPrefab = periodInfo.prefeb

    local resList = {{path = periodInfo.prefeb, type = AssetType.Prefab},}
    self.periodAssetLoader:AddListener(self:ToFunc("PeriodNodeCallback"))
    self.periodAssetLoader:LoadAll(resList)
end

function RolePeriodPanel:PeriodNodeCallback()
    CurtainManager.Instance:ExitWait()

    if self.periodNodeMap[self.curShowRold] then
        LogError("脉象重复加载!!!!")
    end

    local go = self.periodAssetLoader:Pop(self.curLoadPeriodPrefab, self.PeriodNode.transform)
    local uiCont = UtilsUI.GetContainerObject(go)
    uiCont.gameObject = go
    uiCont.animator = go:GetComponent(Animator)
    
    self.periodNodeMap[self.curShowRold] = uiCont

    if not UtilsBase.IsNull(self.periodNodeMap[self.curShowRold].animator) then
        self.periodNodeMap[self.curShowRold].animator:Play("UI_PeriodV4_in_PC", 0, 0)
    end

    self:InitPeriodNode(self.periodNodeMap[self.curShowRold], self.curShowRold)
    local curRoleId = self.curShowRold
    UtilsUI.SetHideCallBack(self.periodNodeMap[curRoleId].PeriodV4_out, function ()
        if self.curShowRold then
            --说明是在打开脉象的时候换人

        else
            --这时候再关闭

        end
        if self.isClose then
            if self.periodNodeMap then
                UtilsUI.SetActive(self.periodNodeMap[self.curShowRold].gameObject, false)
            end
            UtilsUI.SetActive(self.canvas, false)
            self.curShowRold = nil 
        end
        --print("隐藏回调 隐藏节点:", curRoleId, "当前节点:", self.curShowRold)
    end)

    self.curLoadPeriodPrefab = nil
end

function RolePeriodPanel:InitPeriodNode(go, roleId)
    local roleData = self:GetCurRoleData()
    local curStart = roleData.star

    for i = 1, roleData.star do
        local periodInfo = RoleConfig.GetRolePeriodInfo(roleId, i)
        UtilsUI.SetActive(go["MidPeriod" .. i], true)
        local item = go["Period" .. i]
        item = UtilsUI.GetContainerObject(item)

        item.TagTextNum_txt.text = i

        UtilsUI.SetActive(item.Activation, true)
        UtilsUI.SetActive(item.UnActivation, false)
        UtilsUI.SetActive(item.Selected, false)
        UtilsUI.SetActive(item.ActivationSelect, false)
        UtilsUI.SetActive(item.UnActivationSelect, false)
        UtilsUI.SetActive(item.ActivationUnSelect, false)
        UtilsUI.SetActive(item.UnActivationUnSelect, false)

        SingleIconLoader.Load(item.ActiveIcon, periodInfo.icon3)
        SingleIconLoader.Load(item.UnActiveIcon, periodInfo.icon2)

        item.Activation_btn.onClick:RemoveAllListeners()
        item.Activation_btn.onClick:AddListener(function ()
            self:OnClickActivation(i)
        end)
        item.UnActivation_btn.onClick:RemoveAllListeners()
        item.UnActivation_btn.onClick:AddListener(function ()
            self:OnClickActivation(i)
        end)

        go["Period" .. i .. "Cont"] = item

        self.curRolePeriodInfoList[i] = periodInfo
    end

    for i = roleData.star + 1, RoleConfig.MaxStar do
        local periodInfo = RoleConfig.GetRolePeriodInfo(roleId, i)
        UtilsUI.SetActive(go["MidPeriod" .. i], false)
        local item = go["Period" .. i]
        item = UtilsUI.GetContainerObject(item)

        item.TagTextNum_txt.text = i

        UtilsUI.SetActive(item.UnActivation, true)
        UtilsUI.SetActive(item.Activation, false)
        UtilsUI.SetActive(item.Selected, false)
        UtilsUI.SetActive(item.ActivationSelect, false)
        UtilsUI.SetActive(item.UnActivationSelect, false)
        UtilsUI.SetActive(item.ActivationUnSelect, false)
        UtilsUI.SetActive(item.UnActivationUnSelect, false)

        SingleIconLoader.Load(item.ActiveIcon, periodInfo.icon3)
        SingleIconLoader.Load(item.UnActiveIcon, periodInfo.icon2)

        item.Activation_btn.onClick:RemoveAllListeners()
        item.Activation_btn.onClick:AddListener(function ()
            self:OnClickActivation(i)
        end)
        item.UnActivation_btn.onClick:RemoveAllListeners()
        item.UnActivation_btn.onClick:AddListener(function ()
            self:OnClickActivation(i)
        end)

        go["Period" .. i .. "Cont"] = item

        self.curRolePeriodInfoList[i] = periodInfo
    end

    if roleData.star > 0 then
        --UtilsUI.SetActive(self.periodNodeMap[self.curShowRold]["shu-AD"], true)
    end

    UtilsUI.SetActive(go.gameObject, true)
end

-- 打开侧边页
function RolePeriodPanel:OnClickActivation(index)
    if self.isActivating then
        return
    end

    local periodInfo = self.curRolePeriodInfoList[index]

    self.PeriodTitleText_txt.text = periodInfo.name
    self.PeriodSmallText_txt.text = string.format(TI18N("脉象·第%d层"), index)
    SingleIconLoader.Load(self.PeriodTitleIcon, periodInfo.icon)
    self.PeriodContentText_txt.text = TI18N(periodInfo.desc)

    local roleData = self:GetCurRoleData()
    local roleStar = roleData.star
    if roleStar >= index then
        --已激活
        UtilsUI.SetActive(self.LeftPartActiveParent, true)
        UtilsUI.SetActive(self.LeftPartUnActiveParent, false)
        UtilsUI.SetActive(self.LeftPartActive, true)
    elseif roleStar == index - 1 then
        if roleData.isRobot then
            UtilsUI.SetActive(self.LeftPartUnActiveParent, false)
            UtilsUI.SetActive(self.LeftPartActiveParent, false)
        else
            --下一个需要激活的
            UtilsUI.SetActive(self.LeftPartActiveParent, false)
            UtilsUI.SetActive(self.LeftPartUnActiveParent, true)
            UtilsUI.SetActive(self.LeftPartActive, false)
            UtilsUI.SetActive(self.LeftPartUnActive, true)
            UtilsUI.SetActive(self.LeftPartUnActiveButtonNoItem, false)
        end
    else
        if roleData.isRobot then
            UtilsUI.SetActive(self.LeftPartUnActiveParent, false)
            UtilsUI.SetActive(self.LeftPartActiveParent, true)
        else
            --跨激活
            UtilsUI.SetActive(self.LeftPartActiveParent, false)
            UtilsUI.SetActive(self.LeftPartUnActiveParent, true)
            UtilsUI.SetActive(self.LeftPartActive, false)
            UtilsUI.SetActive(self.LeftPartUnActive, false)
            UtilsUI.SetActive(self.LeftPartUnActiveButtonNoItem, true)
            self.LeftPartUnActiveButtonNoItemText_txt.text = string.format(TI18N("需先激活脉象第%d层"), index - 1)
        end
    end

    if self.uid then
        UtilsUI.SetActive(self.LeftPartUnActiveParent, false)
    end

    if self.curUpItem ~= periodInfo.item then
        self:LoadCommonItem(periodInfo.item, self.ActiveItem, self.activeItem)
        self.curUpItem = periodInfo.item
    end

    local itemNum = mod.BagCtrl:GetItemCountById(periodInfo.item)
    
    if itemNum < periodInfo.num then
        self.activeItem.node.Num_txt.text = string.format("<color=#F0513C>%d</color>/%d", itemNum, periodInfo.num)
    else
        self.activeItem.node.Num_txt.text = string.format("%d/%d", itemNum, periodInfo.num)
    end
    
    UtilsUI.SetActive(self.LeftPart, true)
    self.LeftPart_anim:Play("UI_RoleRightPartPeriodPanel_in")
    
    self:OnOpenLeftTips(self.curSelectItem, index, self:GetCurRole())

    self.curSelectItem = index

    self.curCameraType = RoleConfig.PageCameraType.PeriodDetails
    self.curBlurType = RoleConfig.PageBlurType.PeriodDetails

    if not self.isOpenActivePage then
        --点开详情不播动作
        --self:ChangeShowRole(self:GetCurRole())
    end

    --UnityUtils.SetAnchoredPosition(self.PeriodNode.transform, -230, 0)
    if not UtilsBase.IsNull(self.periodNodeMap[self.curShowRold].animator) then
        self.periodNodeMap[self.curShowRold].animator:Play("UI_PeriodV4_xuanzhong_in_PC")
    end

    self:SwitchSelectPeriodItem(index)
    self.isOpenActivePage = true
end

function RolePeriodPanel:SwitchSelectPeriodItem(index)
    local periodNode = self.periodNodeMap[self.curShowRold]

    if self.curSelectItemIndex then
        local uiCont = UtilsUI.GetContainerObject(periodNode["Period" .. self.curSelectItemIndex])
        UtilsUI.SetActive(uiCont.Selected, false)
        UtilsUI.SetActive(uiCont.ActivationSelect, false)
        UtilsUI.SetActive(uiCont.UnActivationSelect, false)
        UtilsUI.SetActive(uiCont.ActivationUnSelect, true)
        UtilsUI.SetActive(uiCont.UnActivationUnSelect, true)
    end

    if index then
        local uiCont = UtilsUI.GetContainerObject(periodNode["Period" .. index])        
        UtilsUI.SetActive(uiCont.Selected, true)
        UtilsUI.SetActive(uiCont.ActivationSelect, true)
        UtilsUI.SetActive(uiCont.UnActivationSelect, true)
        UtilsUI.SetActive(uiCont.ActivationUnSelect, false)
        UtilsUI.SetActive(uiCont.UnActivationUnSelect, false)
        local star = self:GetCurRoleData().star
        if index > star then
            UtilsUI.SetActive(uiCont.UnActiveSelected, true)
            UtilsUI.SetActive(uiCont.ActiveSelected, false)
        else
            UtilsUI.SetActive(uiCont.UnActiveSelected, false)
            UtilsUI.SetActive(uiCont.ActiveSelected, true)
        end
    else
        for i = 1, RoleConfig.MaxStar, 1 do
            local uiCont = UtilsUI.GetContainerObject(periodNode["Period" .. i])   
            UtilsUI.SetActive(uiCont.ActivationUnSelect, false)
            UtilsUI.SetActive(uiCont.UnActivationUnSelect, false)
        end
        
    end

    self.curSelectItemIndex = index
end

function RolePeriodPanel:LoadCommonItem(itemId, go, commonItem)
    local itemInfo = {template_id = itemId, count = "0/0", scale = 1}
    commonItem:InitItem(go, itemInfo, true)
end

--关闭侧边页
function RolePeriodPanel:CloseLeftTips()
    if (not self.isOpenActivePage) or self.isActivating then
        return
    end
    self.curCameraType = RoleConfig.PageCameraType.Period
    self.curBlurType = RoleConfig.PageBlurType.Period

    self:OnCloseLeftTips(self.curSelectItem, self:GetCurRole())

    self.curSelectItem = nil

    --点开详情不播动作
    --self:ChangeShowRole(self:GetCurRole())
    
    self:SwitchSelectPeriodItem(nil)
    --UtilsUI.SetActive(self.LeftPart, false)
    self.LeftPart_anim:Play("UI_RoleRightPartPeriodPanel_out")
    --UnityUtils.SetAnchoredPosition(self.PeriodNode.transform, 0, 0)
    if not UtilsBase.IsNull(self.periodNodeMap[self.curShowRold].animator) then
        self.periodNodeMap[self.curShowRold].animator:Play("UI_PeriodV4_xuanzhong_out_PC")
    end
    self.isOpenActivePage = false
end

function RolePeriodPanel:OnOpenLeftTips(lastItemId, curItemId, roleId)
    if roleId and curItemId then
        local periodNodeList = self.periodNodeMap[roleId]
        if self.curSelectItem ~= curItemId then
            if lastItemId then
                local itemCont = periodNodeList["Period" .. lastItemId .. "Cont"]
                itemCont.Activation_anim:Play("UI_PeriodV4_Activation_quxiao")
                itemCont.UnActivation_anim:Play("UI_PeriodV4_UnActivation_quxiao")
            end
            local itemCont = periodNodeList["Period" .. curItemId .. "Cont"]
            itemCont.Activation_anim:Play("UI_PeriodV4_Activation_xuanzhong")
            itemCont.UnActivation_anim:Play("UI_PeriodV4_UnActivation_xuanzhong")
            self.curSelectItem = curItemId
        end
    end
    
end

function RolePeriodPanel:OnCloseLeftTips(itemId, roleId)
    UnityUtils.SetLocalEulerAngles(self.PeriodNode_rect, 0, 0, 0)
    if roleId then
        local periodNodeList = self.periodNodeMap[roleId]
        local itemCont = periodNodeList["Period" .. itemId .. "Cont"]
        itemCont.Activation_anim:Play("UI_PeriodV4_Activation_quxiao")
        itemCont.UnActivation_anim:Play("UI_PeriodV4_UnActivation_quxiao")
    end
    self.curSelectItem = nil
end

function RolePeriodPanel:OnClickActiveButton()
    if self.isActivating then
        return
    end

    if self.curSelectItemIndex then
        local periodInfo = self.curRolePeriodInfoList[self.curSelectItemIndex]

        if BehaviorFunctions.CheckPlayerInFight() then
            MsgBoxManager.Instance:ShowTips(TI18N("战斗中无法操作"))
            return
        end

        local isDup = mod.WorldMapCtrl:CheckIsDup()
        if isDup then
            MsgBoxManager.Instance:ShowTips(TI18N("副本中无法操作"))
            return
        end

        local itemNum = mod.BagCtrl:GetItemCountById(periodInfo.item)
        if itemNum < periodInfo.num then
            MsgBoxManager.Instance:ShowTips(TI18N("道具不足"))
            return
        end

        -- 激活脉象
        mod.RoleCtrl:RoleStarUp(self.curShowRold)

    else
        LogError("没有选中要激活的脉象")
    end
    
end

--收到激活脉象的回包
function RolePeriodPanel:RolePeriodActive(idx, roleData, oldData)
    if roleData.star == 0 or roleData.star == oldData.star then
        return
    end
    --self:CloseLeftTips()
    self:OnClickActivation(roleData.star)

    self.isActivating = true
    UtilsUI.SetActive(self.ActivingMask, true)

    local roleId = roleData.id
    local periodIndex = roleData.star

    if self.curShowRold == roleId then
        self:OnClickActivation(self.curSelectItemIndex)
    end
    --脉象激活效果

    local periodNode = self.periodNodeMap[roleId]

    if periodNode then
        UtilsUI.SetActive(periodNode["MidPeriod" .. periodIndex], true)
        local node = periodNode["Period" .. periodIndex]
        local periodItemCont = UtilsUI.GetContainerObject(node)
        --UtilsUI.SetActive(periodItemCont.XuMuPeriodItemV2_jihuoing, true)

        --
        UtilsUI.SetActive(periodItemCont.Activation, true)
        periodItemCont.Activation_anim:Play("UI_PeriodV4_Activation_xuanzhong", -1, 1)
        periodItemCont.UnActivation_anim.enabled = false
        periodItemCont.Activation_anim.enabled = false

        --local animator = node:GetComponent(Animator)
        --animator:Play("UI_PeriodV4_PC_jihuoing", 1)

        UtilsUI.SetActive(periodItemCont.Period_jihuo, true)

        UtilsUI.SetHideCallBack(periodItemCont.Period_out, function ()
            UtilsUI.SetHideCallBack(periodItemCont.Period_out, nil)
            self.isActivating = false
            UtilsUI.SetActive(self.ActivingMask, false)
            UtilsUI.SetActive(periodItemCont.UnActivation, false)
            periodItemCont.UnActivation_anim.enabled = true
            periodItemCont.Activation_anim.enabled = true
        end)
    else
        LogError("界面未加载完成")
        self.isActivating = false
        UtilsUI.SetActive(self.ActivingMask, false)
    end
end

function RolePeriodPanel:GetCurRole()
    return mod.RoleCtrl:GetCurUISelectRole()
end

function RolePeriodPanel:GetCurRoleData()
    return mod.RoleCtrl:GetRoleData(self:GetCurRole(),self.uid)
end

function RolePeriodPanel:GetModelView()
    return Fight.Instance.modelViewMgr:GetView()
end