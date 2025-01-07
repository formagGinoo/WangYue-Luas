ActivityMainWindow = BaseClass("ActivityMainWindow", BaseWindow)

function ActivityMainWindow:__init()
	self:SetAsset("Prefabs/UI/Activity/ActivityMainWindow.prefab")
end

function ActivityMainWindow:__BindListener()
    --self:SetHideNode("ActivityMainWindow_Exit")
    self.CommonBack2_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
end

function ActivityMainWindow:__BindEvent()
    EventMgr.Instance:AddListener(EventName.ChangeLanguage,self:ToFunc("SetText"))
end

function ActivityMainWindow:__CacheObject()
end

function ActivityMainWindow:__Create()
   
end

function ActivityMainWindow:__delete()
    EventMgr.Instance:RemoveListener(EventName.ChangeLanguage,self:ToFunc("SetText"))

end

function ActivityMainWindow:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.TitleTxt_txt.text = TI18N("活动")
    local cb = function ()
        self:BlurShowCb()
    end
    self.blurBack:Show({cb})
end

function ActivityMainWindow:__Hide()
    
end

function ActivityMainWindow:Update()
    if not self.curType then return end
    --local curPanel = SystemConfig.AdventureTypeToPanel[self.curType]
    ---local panelClass = self:GetPanel(curPanel)
    --if panelClass and panelClass.Update then
    --    panelClass:Update()
    --end
end

function ActivityMainWindow:BlurShowCb()
    self:SetEffectLayer()
    self:CreateTypeList(mod.ActivityCtrl:GetActivityDataList())
	self:DefaultSelectType()
    if self.args and self.args.showCallback then
        self.args.showCallback()
    end
end

function ActivityMainWindow:__Show()
end

function ActivityMainWindow:SetEffectLayer()
    local layer = WindowManager.Instance:GetCurOrderLayer()
    --UtilsUI.SetEffectSortingOrder(self["22025"], layer + 1)
end

--#region 创建切页
function ActivityMainWindow:CreateTypeList(tabList)
    self.typeObjList = {}
    self.typeObjText = {}
    local typeList = {}
    for k, v in pairs(tabList) do
        table.insert(typeList, v)
    end
    local sortFunc = function(a, b)
        return a.priority > b.priority
    end
    table.sort(typeList, sortFunc)
    for _, typeInfo in pairs(typeList) do
        if not typeInfo.systemId then
            local typeObj = self:GetTypeObj()
            self:UpdateActivityItem(typeObj,typeInfo)
            self.typeObjList[typeInfo.actKey] = typeObj
            self.typeObjText[typeInfo.actKey] = typeInfo.name
        end
    end
    self:AddRedPointEvent()
    self:RefreshRedPoint()
end

function ActivityMainWindow:UpdateActivityItem(typeObj,typeInfo)
    typeObj.AcivityTitle_txt.text = TI18N(typeInfo.name)
    typeObj.callback = typeInfo.callback

    AtlasIconLoader.Load(typeObj.banner, typeInfo.banner)
    AtlasIconLoader.Load(typeObj.Icon, typeInfo.icon)

    self:BindRedPoint(typeInfo.actKey, typeObj.RedPoint)

    local onToggleFunc = function(isEnter)
        self:OnToggle_Type(typeInfo.actKey, isEnter)
    end

    typeObj.SingleType_tog.isOn = false
    typeObj.SingleType_tog.onValueChanged:RemoveAllListeners()
    typeObj.SingleType_tog.onValueChanged:AddListener(onToggleFunc)

    self:InitRedPoint(typeInfo, typeObj)
end

function ActivityMainWindow:DefaultSelectType()
	--界面跳转优先
	local defaultSelect = self.args and self.args.actKey or nil
	if not defaultSelect then
		--红点次之
		local dataList = {}
		for k, v in pairs(mod.ActivityCtrl:GetActivityDataList()) do
			table.insert(dataList, v)
		end
		table.sort(dataList, function(a, b)
			return a.priority > b.priority
		end)
        for _, typeInfo in ipairs (dataList) do
            if not defaultSelect then
                defaultSelect = RedPointMgr.Instance:GetRedPointState(typeInfo.actKey) and typeInfo.actKey or defaultSelect
            end
        end

		if not defaultSelect then
			--默认选中规则 todo
		end
	end
	self:SelectType(defaultSelect)
end

function ActivityMainWindow:InitRedPoint(typeInfo, typeObj)

    self:BindRedPoint(typeInfo.actKey, typeObj.RedPoint)
end

function ActivityMainWindow:GetTypeObj()
    local obj = self:PopUITmpObject("SingleType")
    obj.objectTransform:SetParent(self.TypeList.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
	UnityUtils.SetActive(obj.object,true)

    return obj
end

function ActivityMainWindow:SelectType(typeId)
    local typeObj = self.typeObjList[typeId]
    if typeObj then
        self.curType = typeId
        typeObj.SingleType_tog.isOn = true
    end
end

function ActivityMainWindow:OnToggle_Type(typeId, isEnter)
    self.curType = typeId
    local typeObj = self.typeObjList[typeId]
    if not typeObj then
        return
    end

    if isEnter then
        typeObj.mask:SetActive(false)
        --typeObj.AdvMain_SingleType_Click:SetActive(true) 点击动效todo
        typeObj.SingleType_anim:Play("UI_SingleType_in")
    else
        typeObj.mask:SetActive(true)        
        typeObj.SingleType_anim:Play("UI_SingleType_out")
    end

    typeObj.callback(self, typeObj.SingleType_tog.isOn)
end

function ActivityMainWindow:ReSelectType()
    self:OnToggle_Type(self.curType,true)
end

function ActivityMainWindow:GetCurSelectTabId()
    return self.curType
end

function ActivityMainWindow:ShowOption(typeId, isShow)
    local typeObj = self.typeObjList[typeId]
    if not typeObj then
        return
    end
    typeObj.object:SetActive(isShow or false)
    if not isShow then
        typeObj.SingleType_tog.isOn = false
    end
end

function ActivityMainWindow:__AfterExitAnim()
    WindowManager.Instance:CloseWindow(self)
end


function ActivityMainWindow:__TempShow()
    self:ReSelectType()
end

function ActivityMainWindow:SetText()
    self.TitleTxt_txt.text = TI18N("活动")
    for k, v in pairs(self.typeObjList) do
        v.TypeName_txt.text = TI18N(self.typeObjText[k])
    end
end

-- function ActivityMainWindow:ReSelectType()
--     self:SelectType(self.curType)
-- end