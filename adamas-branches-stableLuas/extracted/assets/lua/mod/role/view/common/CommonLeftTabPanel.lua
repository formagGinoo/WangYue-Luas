CommonLeftTabPanel = BaseClass("CommonLeftTabPanel", BasePanel)


--初始化
function CommonLeftTabPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Common/CommonLeftTabPanel.prefab")
    self.parent = parent
    self.curType = nil
    self.toggleList = {}
end

--添加监听器
function CommonLeftTabPanel:__BindListener()
	self:SetHideNode("CommonLeftTabPanel_out")
end

--缓存对象
function CommonLeftTabPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function CommonLeftTabPanel:__Create()

end

function CommonLeftTabPanel:__delete()
    self.parent = nil
    self.curType = nil
end

function CommonLeftTabPanel:__Hide()

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

function CommonLeftTabPanel:__Show()
    self.Title1_txt.text = self.args.name
    self.Title2_txt.text = self.args.name2
    self.defaultSelect = self.args.defaultSelect
    self.closeSound = self.args.closeSound
    self.uid = self.args.uid
    --self.TypeList:GetComponent(LayoutDelayShow).enabled = not self.args.notDelay
	
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
function CommonLeftTabPanel:CreateTypeList(tabList)
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
            typeObj.TypeName_txt.text = typeInfo.name
            typeObj.TypeName2_txt.text = typeInfo.name
            typeObj.callback = typeInfo.callback
            typeObj.checkredpoint = typeInfo.checkredpoint

            if type(typeInfo.icon) =="table" then
                SingleIconLoader.Load(typeObj.UIcon, typeInfo.icon[2])
            elseif type(typeInfo.icon) =="string" and typeInfo.icon ~= "" then
                local cfg = SystemConfig.GetIconConfig(typeInfo.icon)
                SingleIconLoader.Load(typeObj.UIcon, cfg.icon1)
            end

            local onToggleFunc = function(isEnter)
                self:OnToggle_Type(typeInfo.type, isEnter)
            end
            
            typeObj.SingleType_tog.onValueChanged:RemoveAllListeners()
            typeObj.SingleType_tog.onValueChanged:AddListener(onToggleFunc)
            -- typeObj.Selected_HideNode_hcb.HideAction:RemoveAllListeners()
            -- typeObj.Selected_HideNode_hcb.HideAction:AddListener(hideCb)
            typeObj.object:SetActive(true)
			
			self:InitRedPoint(typeInfo, typeObj)

            self.typeObjList[typeInfo.type] = typeObj
        end
    end
    
    if self.defaultSelect then
        self:SelectType(self.defaultSelect)
    elseif typeList[1] then            -- 设置第一个元素为默认值, 进入界面时不播放动画
        local typeObj = self.typeObjList[typeList[1].type]
        if typeObj then
            self.curType = typeList[1].type
            
            typeObj.Selected:SetActive(true)
            typeObj.UnSelect:SetActive(false)

            typeObj.SingleType_tog.isOn = true
            typeObj.callback(self.parentWindow, typeObj.SingleType_tog.isOn)
        end
    end
    
    self:RefreshRedPoint()
end

function CommonLeftTabPanel:RefreshRedPoint()
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
function CommonLeftTabPanel:InitRedPoint(typeInfo, typeObj)
	-- if typeInfo.type == SystemConfig.AdventurePanelType.DailyActivity then
	-- 	self:BindRedPoint(RedPointName.DailyActivity, typeObj.RedPoint)
	-- 	EventMgr.Instance:Fire(EventName.RefreshRedPoint, RedPointName.DailyActivity)
	-- end
end

function CommonLeftTabPanel:GetTypeObj()
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

function CommonLeftTabPanel:SelectType(typeId)
    local typeObj = self.typeObjList[tonumber(typeId)]
    if typeObj then
        typeObj.SingleType_tog.isOn = true
    end
end

function CommonLeftTabPanel:OnToggle_Type(typeId, isEnter)
	if self.curType == typeId and isEnter == true then
		return
	end
    self.curType = typeId

    local typeObj = self.typeObjList[typeId]
    if not typeObj then
        return
    end

    if isEnter then
        typeObj.Selected:SetActive(true)
        typeObj.UnSelect:SetActive(false)
        typeObj.Selected_uianim:PlayEnterAnimator()
        
    else
        typeObj.Selected_uianim:PlayExitAnimator()
        typeObj.Selected_out_hcb.HideAction:AddListener(function()
            typeObj.Selected:SetActive(false)
            typeObj.UnSelect:SetActive(true)
            typeObj.Selected_out_hcb.HideAction:RemoveAllListeners()
        end)
    end

    typeObj.callback(self.parentWindow, typeObj.SingleType_tog.isOn)
end

function CommonLeftTabPanel:ReSelectType()
    self:OnToggle_Type(self.curType,true)
end

function CommonLeftTabPanel:GetCurSelectTabId()
    return self.curType
end

function CommonLeftTabPanel:ShowOption(typeId, isShow)
    local typeObj = self.typeObjList[typeId]
    if not typeObj then
        return
    end
    typeObj.object:SetActive(isShow or false)
    if not isShow then
        typeObj.SingleType_tog.isOn = false
    end
end

function CommonLeftTabPanel:OnClose()
    self.gameObject:GetComponent(Animator):Play("CommonLeftTabPanel_Eixt")
end