ActivitySignInPanel = BaseClass("ActivitySignInPanel", BasePanel)

function ActivitySignInPanel:__init()
    self:SetAsset("Prefabs/UI/Activity/ActivitySignInPanel.prefab")
	
	self.activationNodes = {}
	self.itemObjs = {}
end

function ActivitySignInPanel:__delete()

	for _, obj in pairs(self.itemObjs) do		
        ItemManager.Instance:PushItemToPool(obj)
	end
	self.itemObjs = {}
end

function ActivitySignInPanel:__BindListener()
	--self:SetHideNode("ActivitySignInPanel_Exit")
	--UtilsUI.SetHideCallBack(self.ActivitySignInPanel_Exit, self:ToFunc("Close_CallBack"))

end

function ActivitySignInPanel:__Create()
	if self.MissionGroup_recyceList then
		self.MissionGroup_recyceList:SetLuaCallBack(self:ToFunc("OnMissionScroll"))
		self.MissionGroup_recyceList:SetCellNum(#self.info.task_list)
	end
end

function ActivitySignInPanel:__Show()
EventMgr.Instance:AddListener(EventName.ActivitySignInUpdate, self:ToFunc("UpdateSignInDays"))
	self:InitUI()

    local cfg = ActivityConfig.GetDataSignInReward(self.args.id)
    self.signCfg  = {}
    for k, v in pairs(cfg) do
        table.insert(self.signCfg, v)
    end
    local sortFunc = function(a, b)
        return a.day < b.day
    end
    table.sort(self.signCfg, sortFunc)
    
	self:UpdateSignInDays()
end

function ActivitySignInPanel:__Hide()
	
	EventMgr.Instance:RemoveListener(EventName.ActivitySignInUpdate, self:ToFunc("UpdateSignInDays"))
end

function ActivitySignInPanel:InitUI(info)
	
end

function ActivitySignInPanel:UpdateSignInDays()
	self.info = mod.ActivityCtrl:GetSignInActData(self.args.id)
    
	for k, v in pairs(self.signCfg) do
        local obj = self["SignItem"..v.day]
        self:UpdateSignItem(UtilsUI.GetContainerObject(obj.transform),v)
    end
end
function  ActivitySignInPanel:UpdateSignItem(obj,signCfg)
    local curDay = #self.info
    local status = self.info[signCfg.day] or 3
	
    local canGet = status == 1
    local hasGet = status == 2
    local isSpecial = signCfg.day == 7
    local isTomorrow = signCfg.day == curDay + 1
    
	UnityUtils.SetActive(obj.Content, canGet)


	UnityUtils.SetActive(obj.GrayBg, hasGet)
	UnityUtils.SetActive(obj.NormalContent, not canGet)
	UnityUtils.SetActive(obj.TomTag, isTomorrow)
    
    
	local rewardConfig = ActivityConfig.GetRewardList(signCfg.reward_id)[1]
	local itemInfo = {template_id = rewardConfig[1], count = rewardConfig[2], acquired = hasGet}

    local getItem = self.itemObjs[signCfg.reward_id] or PoolManager.Instance:Pop(PoolType.class, "CommonItem")
    if not getItem then
        getItem = CommonItem.New()
    end
    getItem:InitItem(obj.Item, itemInfo, true)
    self.itemObjs[signCfg.reward_id] = getItem


    local targetContent = status == 1 and obj.Content or obj.NormalContent
    local txtCont = UtilsUI.GetContainerObject(targetContent.transform)
	txtCont.dayNum_txt.text = "0"..signCfg.day
	txtCont.dayTxt_txt.text = TI18N("天")
    obj.TomText_txt.text = TI18N("明日可领")
	UnityUtils.SetActive(txtCont.TeShuBg, isSpecial)

    if status == 1 then
        local layer = WindowManager.Instance:GetCurOrderLayer()
        UtilsUI.SetEffectSortingOrder(txtCont.Effect, layer + 1)
    end

	if canGet then
		local func = function()
            self.info = mod.ActivityCtrl:GetSignInReward(self.args.id,signCfg.day)
            obj.Content_btn.onClick:RemoveAllListeners()
		end
		obj.Content_btn.onClick:RemoveAllListeners()
		obj.Content_btn.onClick:AddListener(func)
	end
	
end
