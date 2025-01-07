AdvMainWindowV2 = BaseClass("AdvMainWindowV2", BaseWindow)

local AdvType = SystemConfig.AdventurePanelType

function AdvMainWindowV2:__init()
	self:SetAsset("Prefabs/UI/Fight/AdvMainWindowV2.prefab")
end

function AdvMainWindowV2:__BindListener()
    self:SetHideNode("AdvMainWindowV2_Exit")
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("OnClick_Close"),self:ToFunc("OnClick_CloseCallBack"))
end

function AdvMainWindowV2:__BindEvent()
    EventMgr.Instance:AddListener(EventName.ChangeLanguage,self:ToFunc("SetText"))
end

function AdvMainWindowV2:__CacheObject()
end

function AdvMainWindowV2:__Create()
   
end

function AdvMainWindowV2:__delete()
    EventMgr.Instance:RemoveListener(EventName.ChangeLanguage,self:ToFunc("SetText"))
    if self.blurBack then
        self.blurBack:Destroy()
    end
end

function AdvMainWindowV2:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show()
end

function AdvMainWindowV2:__Hide()
    
end

function AdvMainWindowV2:__Show()
    self:SetEffectLayer()
    self:CreateTypeList(SystemConfig.AdventureMainToggleInfo)
	self:DefaultSelectType()
    if self.args and self.args.showCallback then
        self.args.showCallback()
    end
end

function AdvMainWindowV2:SetEffectLayer()
    local layer = WindowManager.Instance:GetCurOrderLayer()
    UtilsUI.SetEffectSortingOrder(self["22025"], layer + 1)
end

--#region 创建切页
function AdvMainWindowV2:CreateTypeList(tabList)
    self.typeObjList = {}
    self.typeObjText = {}
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
        local isOpen = Fight.Instance.conditionManager:CheckSystemOpen(typeInfo.systemId)
        if not typeInfo.systemId or isOpen then
            local typeObj = self:GetTypeObj()
            typeObj.TypeName_txt.text = TI18N(typeInfo.name)
            typeObj.callback = typeInfo.callback

            local onToggleFunc = function(isEnter)
                self:OnToggle_Type(typeInfo.type, isEnter)
            end

            local hideCb = function()
                typeObj.Selected:SetActive(false)
            end
            typeObj.SingleType_tog.onValueChanged:RemoveAllListeners()
            typeObj.SingleType_tog.onValueChanged:AddListener(onToggleFunc)
            -- typeObj.Selected_HideNode_hcb.HideAction:RemoveAllListeners()
            -- typeObj.Selected_HideNode_hcb.HideAction:AddListener(hideCb)
            typeObj.object:SetActive(true)
			self:InitRedPoint(typeInfo, typeObj)

            self.typeObjList[typeInfo.type] = typeObj
            self.typeObjText[typeInfo.type] = typeInfo.name
        end
    end
end

function AdvMainWindowV2:DefaultSelectType()
	--界面跳转优先
	local defaultSelect = self.args and self.args.type
	if not defaultSelect then
		--红点次之
		local worldLevelState = RedPointMgr.Instance:GetRedPointState(RedPointName.WorldLev)
		local dailyActivityState = RedPointMgr.Instance:GetRedPointState(RedPointName.DailyActivity)
		if worldLevelState then
			defaultSelect = AdvType.WorldLevel
		elseif dailyActivityState then
			defaultSelect = AdvType.DailyActivity
		end
		
		if not defaultSelect then
			--默认选中规则
			local isLimit = mod.WorldLevelCtrl:CheckAdvLevLimit()
			local cur, historyMax = mod.WorldLevelCtrl:GetWorldLevel()
			local max = WorldLevelConfig.GetMaxLev()
			local dailyFull = mod.DailyActivityCtrl:IsFullActivation()
			--卡等级
            defaultSelect = AdvType.WorldLevel
			if isLimit and historyMax < max then
				defaultSelect = AdvType.WorldLevel
			--未卡等级/等级最高
			elseif (not isLimit or historyMax >= max) then
				--满活跃
				if dailyFull and Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.ShiMaiLieShou) then
					defaultSelect = AdvType.MercenaryTask
				--未满活跃
                elseif Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.DailyActive) then
					defaultSelect = AdvType.DailyActivity
				end
			end
		end
	end
	self:SelectType(defaultSelect)
end

function AdvMainWindowV2:InitRedPoint(typeInfo, typeObj)
	if typeInfo.type == AdvType.DailyActivity then
		self:BindRedPoint(RedPointName.DailyActivity, typeObj.RedPoint)
    elseif typeInfo.type == AdvType.WorldLevel then
        self:BindRedPoint(RedPointName.WorldLev, typeObj.RedPoint)
    elseif typeInfo.type == SystemConfig.AdventurePanelType.MercenaryTask then
        self:BindRedPoint(RedPointName.MercenaryRankReward, typeObj.RedPoint)
	end
end

function AdvMainWindowV2:GetTypeObj()
    local obj = self:PopUITmpObject("SingleType")
    obj.objectTransform:SetParent(self.TypeList.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)

    return obj
end

function AdvMainWindowV2:SelectType(typeId)
    local typeObj = self.typeObjList[typeId]
    if typeObj then
        self.curType = typeId
        typeObj.SingleType_tog.isOn = true
    end
end

function AdvMainWindowV2:OnToggle_Type(typeId, isEnter)
    self.curType = typeId
    local typeObj = self.typeObjList[typeId]
    if not typeObj then
        return
    end

    if isEnter then
        typeObj.SelectedImg:SetActive(true)
        typeObj.AdvMain_SingleType_Click:SetActive(true)
    else
        typeObj.SelectedImg:SetActive(false)
        typeObj.AdvMain_SingleType_Exit:SetActive(true)
    end

    typeObj.callback(self, typeObj.SingleType_tog.isOn)
end

function AdvMainWindowV2:ReSelectType()
    self:OnToggle_Type(self.curType,true)
end

function AdvMainWindowV2:GetCurSelectTabId()
    return self.curType
end

function AdvMainWindowV2:ShowOption(typeId, isShow)
    local typeObj = self.typeObjList[typeId]
    if not typeObj then
        return
    end
    typeObj.object:SetActive(isShow or false)
    if not isShow then
        typeObj.SingleType_tog.isOn = false
    end
end

function AdvMainWindowV2:OnClick_Close()
    self.AdvMainWindowV2_Exit:SetActive(true)
    self.showPanel:ShowCloseNode()
end

function AdvMainWindowV2:OnClick_CloseCallBack()
    WindowManager.Instance:CloseWindow(self)
end


function AdvMainWindowV2:__TempShow()
    self:ReSelectType()
end

function AdvMainWindowV2:SetText()
    for k, v in pairs(self.typeObjList) do
        v.TypeName_txt.text = TI18N(self.typeObjText[k])
    end
end

-- function AdvMainWindowV2:ReSelectType()
--     self:SelectType(self.curType)
-- end