CommonLeftTabPanelV2 = BaseClass("CommonLeftTabPanelV2", BasePanel)


--初始化
function CommonLeftTabPanelV2:__init(parent)
    self:SetAsset("Prefabs/UI/Common/CommonLeftTabPanelV2.prefab")
    self.parent = parent
    self.curType = nil
    self.toggleList = {}
end

--添加监听器
function CommonLeftTabPanelV2:__BindListener()
	self:SetHideNode("CommonLeftTabPanelV2_out")
end

--缓存对象
function CommonLeftTabPanelV2:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function CommonLeftTabPanelV2:__Create()

end

function CommonLeftTabPanelV2:__delete()
    self.parent = nil
    self.curType = nil
end

function CommonLeftTabPanelV2:__Hide()

end

--[[
    参数:
    name 标题1
    name2 标题2
    tabList 选项列表
    defaultSelect 默认选中
    callback 初始完成回调

    --TODO 
    notDelay 不使用延时列表
    closeSound 关闭声音
]]

function CommonLeftTabPanelV2:__Show()
    self.Title1_txt.text = self.args.name
    self.Title2_txt.text = string.sub(self.args.name2, 1, 6) or ""
    self.defaultSelect = self.args.defaultSelect
    self.closeSound = self.args.closeSound
    self.uid = self.args.uid
    self.TypeList:GetComponent(LayoutDelayShow).enabled = not self.args.notDelay
	
    --公共栏是否靠右显示
    if self.args.isRight then
        self.TypeScroll_rect:SetParent(self.CommonRightPos_rect)
        UnityUtils.SetAnchoredPosition(self.TypeScroll_rect.transform, 0, 0, 0)
    end
    
    self:CreateTypeList(self.args.tabList)
    if self.args.callback then
        self.args.callback()
    end
end

--#region 创建切页
function CommonLeftTabPanelV2:CreateTypeList(tabList)
    self.typeObjList = {}
    local typeList = {}
    for k, v in pairs(tabList) do
        table.insert(typeList, v)
    end
    local sortFunc = function(a, b)
        return a.type < b.type
    end
    table.sort(typeList, sortFunc)

    for _, typeInfo in pairs(typeList) do
        ---检查系统是否开放
        local isOpen = true
        if typeInfo.systemId and not self.uid then
            isOpen = Fight.Instance and Fight.Instance.conditionManager:CheckSystemOpen(typeInfo.systemId)
        end
        if not typeInfo.systemId or isOpen then
            local typeObj = self:GetTypeObj()
            typeObj.callback = typeInfo.callback
            typeObj.checkredpoint = typeInfo.checkredpoint

            if type(typeInfo.icon) =="table" then
                SingleIconLoader.Load(typeObj.SIcon, typeInfo.icon[1])
                SingleIconLoader.Load(typeObj.UIcon, typeInfo.icon[2])
            elseif type(typeInfo.icon) =="string" and typeInfo.icon ~= "" then
                local cfg = SystemConfig.GetIconConfig(typeInfo.icon)
                SingleIconLoader.Load(typeObj.UIcon, cfg.icon1)
                SingleIconLoader.Load(typeObj.SIcon, cfg.icon2)
            end

            local onToggleFunc = function(isEnter)
                self:OnToggle_Type(typeInfo.type, isEnter)
            end

            local hideCb = function()
                if typeObj.SelectHide then
                    typeObj.Selected:SetActive(false)
                end
            end
            typeObj.SingleType_tog.onValueChanged:RemoveAllListeners()
            typeObj.SingleType_tog.onValueChanged:AddListener(onToggleFunc)
            -- typeObj.Selected_HideNode_hcb.HideAction:RemoveAllListeners()
            -- typeObj.Selected_HideNode_hcb.HideAction:AddListener(hideCb)
            typeObj.object:SetActive(true)

            typeObj.Selected_hcb.HideAction:AddListener(hideCb)
			
			self:InitRedPoint(typeInfo, typeObj)

            self.typeObjList[typeInfo.type] = typeObj
        end
    end
    if self.defaultSelect then
        self:SelectType(self.defaultSelect)
    end
    self:RefreshRedPoint()
end

function CommonLeftTabPanelV2:RefreshRedPoint()
    if self.uid then return end
    if not self.typeObjList then return end 
    for key, value in pairs(self.typeObjList) do
        if value.checkredpoint then
            local active = value.checkredpoint()
            UtilsUI.SetActive(value.RedPoint,active)
        else
            UtilsUI.SetActive(value.RedPoint,false)
        end
    end
end

-- TODO:映射表配置
function CommonLeftTabPanelV2:InitRedPoint(typeInfo, typeObj)
	-- if typeInfo.type == SystemConfig.AdventurePanelType.DailyActivity then
	-- 	self:BindRedPoint(RedPointName.DailyActivity, typeObj.RedPoint)
	-- 	EventMgr.Instance:Fire(EventName.RefreshRedPoint, RedPointName.DailyActivity)
	-- end
end

function CommonLeftTabPanelV2:GetTypeObj()
    local obj = self:PopUITmpObject("SingleType")
    if self.closeSound then
        obj.SingleType_sound.notActive = true
    else
        obj.SingleType_sound.notActive = false
    end
    obj.objectTransform:SetParent(self.TypeList.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)

    return obj
end

function CommonLeftTabPanelV2:SelectType(typeId)
    local typeObj = self.typeObjList[typeId]
    if typeObj then
        typeObj.SingleType_tog.isOn = true
    end
end

function CommonLeftTabPanelV2:OnToggle_Type(typeId, isEnter)
	if self.curType == typeId and isEnter == true then
		return
	end
    self.curType = typeId

    local typeObj = self.typeObjList[typeId]
    if not typeObj then
        return
    end

    if isEnter then
        typeObj.SelectHide = false
        typeObj.Selected:SetActive(true)
        typeObj.UnSelect:SetActive(false)
        typeObj.Selected_anim:Play("Selected_bagtype_click", 0, 0)
    else
        typeObj.SelectHide = true
        typeObj.Selected:SetActive(false)
        typeObj.UnSelect:SetActive(true)
        typeObj.Selected_anim:Play("Selected_bagtype_close", 0, 0)
    end

    typeObj.callback(self.parentWindow, typeObj.SingleType_tog.isOn)
end

function CommonLeftTabPanelV2:ReSelectType()
    self:OnToggle_Type(self.curType,true)
end

function CommonLeftTabPanelV2:GetCurSelectTabId()
    return self.curType
end

function CommonLeftTabPanelV2:ShowOption(typeId, isShow)
    local typeObj = self.typeObjList[typeId]
    if not typeObj then
        return
    end
    typeObj.object:SetActive(isShow or false)
    if not isShow then
        typeObj.SingleType_tog.isOn = false
    end
end

function CommonLeftTabPanelV2:OnClose()
    self.gameObject:GetComponent(Animator):Play("CommonLeftTabPanel_Eixt")
end