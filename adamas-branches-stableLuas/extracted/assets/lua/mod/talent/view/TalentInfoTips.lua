TalentInfoTips = BaseClass("TalentInfoTips", BasePanel)

function TalentInfoTips:__init(parent)
	-- self.parent = parent
	self:SetAsset("Prefabs/UI/Talent/TalentInfoTipsPanel.prefab")
	self.canLvUp = true
end
function TalentInfoTips:__BindListener()
	self:SetHideNode("TalentInfoTipsPanel_Eixt")
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("CloseTips_HideCallBack"),self:ToFunc("OnClick_CloseBtn"))

	self.LvUpBtn_btn.onClick:AddListener(self:ToFunc("OnClick_LvUpBtn"))
end

function TalentInfoTips:__BindEvent()
	EventMgr.Instance:AddListener(EventName.UpdateTalentData, self:ToFunc("UpdateTalentData"))
	EventMgr.Instance:AddListener(EventName.UpdateTalentData, self:ToFunc("OpenUnlockPanel"))
end

function TalentInfoTips:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function TalentInfoTips:__Create()

end

function TalentInfoTips:__delete()
	if self.currencyBar then self.currencyBar:OnCache() end
	EventMgr.Instance:RemoveListener(EventName.UpdateTalentData, self:ToFunc("UpdateTalentData"))
	EventMgr.Instance:RemoveListener(EventName.UpdateTalentData, self:ToFunc("OpenUnlockPanel"))
end

function TalentInfoTips:__ShowComplete()

end

function TalentInfoTips:__Hide()

end

function TalentInfoTips:__Show()
	-- 获取对应的组件
	self:InitCurrencyBar()
	self:SetInfo(self.args.talentId,self.args.isLock)
	self:SetCavansLayer(4)
end

function TalentInfoTips:SetInfo(talentId,isLock)
	self.talentId = talentId
	self.isLock = isLock
	self.canLvUp = true
	self.talentInfo = TalentConfig.GetTalentInfoById(talentId)
	self.talent_lev = mod.TalentCtrl:GetTalentLv(talentId)
	self.talent_max_lev = TalentConfig.GetTalentMaxLvById(talentId)
	self.isMaxLv = self.talent_lev == self.talent_max_lev
	self.GradeConfig = TalentConfig.GetUpgradeConfig(self.talentId, math.max(self.talent_lev,1))
	self.upgradeConfig = TalentConfig.GetUpgradeConfig(self.talentId, math.min(self.talent_max_lev, self.talent_lev+1))
    self.currencyBar:init(self.CurrencyBar, self.upgradeConfig.consume_id)
	self:ShowInfo()
end

function TalentInfoTips:ShowInfo()
	self:SetIcon()
	self:SetName()
	self:SetType()
	self:SetLv()
	self:SetVideoBox()
	self:SetDesc()
	if self.isMaxLv then
		UtilsUI.SetActive(self.Cost,false)
		UtilsUI.SetActive(self.UnlockConditions,false)
	else
		UtilsUI.SetActive(self.Cost,true)
		UtilsUI.SetActive(self.UnlockConditions,true)
		self:SetConditions()
		self:SetCost()
	end
	self:SetBtn()
end

-- 初始化货币栏
function TalentInfoTips:InitCurrencyBar()
	--注意货币栏不用时要放回池子里
    self.currencyBar = Fight.Instance.objectPool:Get(CurrencyBar)
end

function TalentInfoTips:SetIcon()
	SingleIconLoader.Load(self.TalentIcon, self.talentInfo.icon)
end

function TalentInfoTips:SetName()
	self.TalentName_txt.text = self.talentInfo.name
end

function TalentInfoTips:SetType()
	self.TypeText_txt.text = TalentConfig.GetTalentTypeNameByType(self.talentInfo.type)
end

function TalentInfoTips:SetLv()
	self.NowLvText_txt.text = self.talent_lev
	self.MaxLvText_txt.text = "/" .. self.talent_max_lev
end

function TalentInfoTips:SetVideoBox()
	--没有剔除无用参数时的配置不是nil
	if not self.upgradeConfig.video or self.upgradeConfig.video == "" then
        UtilsUI.SetActive(self.VideoBox, false)
        
    else
        UtilsUI.SetActive(self.VideoBox, true)
        self:CreateVideo(self.upgradeConfig.video)
    end
end

local ScreenFactor = math.max(Screen.width / 1280, Screen.height / 720)
function TalentInfoTips:CreateVideo(videoPath)
    local resList = {
        {path = videoPath, type = AssetType.Prefab},
    }

    local callback = function ()
        local videoObj = self.videoLoader:Pop(videoPath)
        videoObj.transform:SetParent(self.Video_rect)
        videoObj.transform:ResetAttr()
		videoObj.transform.sizeDelta = self.Video_rect.sizeDelta
        local videorRimg = videoObj:GetComponent(RawImage)
        local rect = videoObj.transform.rect
        local factor = math.min(ScreenFactor, 2)
        local rtTemp = CustomUnityUtils.GetTextureTemporary(math.floor(rect.width * factor), math.floor(rect.height * factor))
        videorRimg.texture = rtTemp
        local vedioPlayer = videoObj:GetComponent(CS.UnityEngine.Video.VideoPlayer)
        vedioPlayer.targetTexture = rtTemp
		if self.videoLoader then
			AssetMgrProxy.Instance:CacheLoader(self.videoLoader)
			self.videoLoader = nil
		end
    end

    if self.videoLoader then
		AssetMgrProxy.Instance:CacheLoader(self.videoLoader)
        self.videoLoader = nil
    end
    self.videoLoader = AssetMgrProxy.Instance:GetLoader("CreateVideo")
    self.videoLoader:AddListener(callback)
    self.videoLoader:LoadAll(resList)
end

function TalentInfoTips:SetDesc()
	self.DescText_txt.text = self.GradeConfig.desc
end

local colorReach = Color(0.45,0.47,0.51)
local colorNotReach = Color(1,0.37,0.29)
function TalentInfoTips:SetConditions()
	self:SetConditionTittle()
	local isPass, desc, conditionInfo
	if self.upgradeConfig.condition_id1 and self.upgradeConfig.condition_id1 > 0 then
		UtilsUI.SetActive(self.UnlockConditions,true)
	else
		UtilsUI.SetActive(self.UnlockConditions,false)
		return
	end
	if self.upgradeConfig.condition_id1 and self.upgradeConfig.condition_id1 > 0 then
		UtilsUI.SetActive(self.UnlockCondition1,true)
		conditionInfo = TalentConfig.GetConditionInfoById(self.upgradeConfig.condition_id1)
		isPass = TalentConfig.CheckConditionIsDone(self.upgradeConfig.condition_id1)
		self.canLvUp = self.canLvUp and isPass

		UtilsUI.SetActive(self.ConditionReach1,isPass)
		self.ConditionText1_txt.text = conditionInfo.description
		self.ConditionText1_txt.color = isPass and colorReach or colorNotReach
	else
		UtilsUI.SetActive(self.UnlockCondition1,false)
	end

	if self.upgradeConfig.condition_id2 and self.upgradeConfig.condition_id2 > 0 then
		UtilsUI.SetActive(self.UnlockCondition2,true)
		conditionInfo = TalentConfig.GetConditionInfoById(self.upgradeConfig.condition_id2)
		isPass = TalentConfig.CheckConditionIsDone(self.upgradeConfig.condition_id2)
		self.canLvUp = self.canLvUp and isPass

		UtilsUI.SetActive(self.ConditionReach2,isPass)
		self.ConditionText2_txt.text = conditionInfo.description
		self.ConditionText2_txt.color = isPass and colorReach or colorNotReach
	else
		UtilsUI.SetActive(self.UnlockCondition2,false)
	end
end

function TalentInfoTips:SetConditionTittle()
	if self.upgradeConfig.lv == 1 then
		self.UnlockTittle_txt.text = string.format(TI18N("%s条件:"),TalentConfig.LvUpType.unLock[1])
	else
		self.UnlockTittle_txt.text = string.format(TI18N("%s条件:"),TalentConfig.LvUpType.lvUp[1])
	end
end

function TalentInfoTips:SetCost()
	if self.isMaxLv then
		UtilsUI.SetActive(self.Cost,false)
		return
	end
	local itemConfig = ItemConfig.GetItemConfig(self.upgradeConfig.consume_id)
	SingleIconLoader.Load(self.CurIcon, ItemConfig.GetItemIcon(itemConfig.id))
	self.Count_txt.text = self.upgradeConfig.consume_count
	if BagCtrl:GetItemCountById(self.upgradeConfig.consume_id) < self.upgradeConfig.consume_count then
		self.Count_txt.color = colorNotReach
	else 
		self.Count_txt.color = colorReach
	end
end

function TalentInfoTips:SetBtn()
	if self.isLock then
		UtilsUI.SetActive(self.LvUpBtn,false)
		UtilsUI.SetActive(self.LockBtn,true)
		self.LockBtnText_txt.text = TalentConfig.LvUpType.unLock[1]
		return
	end
	if self.isMaxLv then
		UtilsUI.SetActive(self.LvUpBtn,false)
		UtilsUI.SetActive(self.LockBtn,true)
		self.LockBtnText_txt.text = TalentConfig.LvUpType.maxLv[1]
		return
	end
	UtilsUI.SetActive(self.LvUpBtn,true)
	UtilsUI.SetActive(self.LockBtn,false)
	if self.upgradeConfig.level == 1 then
		self.LvUpBtnText_txt.text = TalentConfig.LvUpType.unLock[1]
	else
		self.LvUpBtnText_txt.text = TalentConfig.LvUpType.lvUp[1]
	end
end

function TalentInfoTips:OnClick_LvUpBtn()
	if self.canLvUp and (BagCtrl:GetItemCountById(self.upgradeConfig.consume_id) >= self.upgradeConfig.consume_count) then
		mod.TalentCtrl:TalentLevelUp(self.talentInfo.talent_id)
	else 
		if not self.canLvUp then
			MsgBoxManager.Instance:ShowTips(TI18N("未满足所有条件"))
		else
			MsgBoxManager.Instance:ShowTips(ItemConfig.GetItemConfig(self.upgradeConfig.consume_id).name..TI18N("不足"))
		end
	end
end

function TalentInfoTips:UpdateTalentData(type, talent_id)
	if self.talentId == talent_id then
		self:SetInfo(talent_id)
	end
end

function TalentInfoTips:OpenUnlockPanel(type, id, lev)
	PanelManager.Instance:OpenPanel(TalentUnlockPanel,{ talentId = id, talentLev = lev})
end

function TalentInfoTips:OnClick_CloseBtnWithAnim()
	self.TalentInfoTipsPanel_Eixt:SetActive(true)
end

function TalentInfoTips:OnClick_CloseBtn()
	self.args.treePanel:CloseSelectTips()
end

function TalentInfoTips:CloseTips_HideCallBack()
	self.args.treePanel:AfterCloseInfoTips()
end