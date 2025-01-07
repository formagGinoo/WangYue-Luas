PartnerUnlockSkillWindow = BaseClass("PartnerUnlockSkillWindow", BaseWindow)
local modelRoot = "PartnerRoot"

local assetProductId = 100100601
local emptyCameraRotation = Vec3.New(0,180,0)
function PartnerUnlockSkillWindow:__init()
    self:SetAsset("Prefabs/UI/PartnerSkill/PartnerUnlockSkillWindow.prefab")
end

function PartnerUnlockSkillWindow:__BindListener()
    self.RuleBtn_btn.onClick:AddListener(self:ToFunc("OnClickRuleBtn"))
    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))

    self.LockBtn_btn.onClick:AddListener(self:ToFunc("ClickLockBtn"))
    self.UnLockBtn_btn.onClick:AddListener(self:ToFunc("ClickLockBtn"))

    self.ChangeAssistBtn_btn.onClick:AddListener(self:ToFunc("OpenChangeAssistPartnerPanel"))
    self.AddNewPartner_btn.onClick:AddListener(self:ToFunc("OpenChangeAssistPartnerPanel"))

    --self.AddNewPartner_btn.onClick:AddListener(self:ToFunc("OpenChangeAssistPartnerPanel"))

    self.ActivateBtn_btn.onClick:AddListener(self:ToFunc("ClickActivateBtn"))
end

function PartnerUnlockSkillWindow:__BindEvent()
end

function PartnerUnlockSkillWindow:__delete()
end

function PartnerUnlockSkillWindow:__Hide()
    EventMgr.Instance:RemoveListener(EventName.PartnerInfoChange, self:ToFunc("OnPartnerInfoChange"))
    BehaviorFunctions.fight.clientFight.cameraManager:GetCurCamera().camera:SetActive(true)
    Fight.Instance.modelViewMgr:HideView(ModelViewConfig.ViewType.PartnerBag)
    for k, v in pairs(self.partnerSkillItemMap) do
        v.skillItem:Destory()
        v.skillItem:DeleteMe()
        GameObject.Destroy(v.obj)
    end
    self.partnerSkillItemMap = {}

    for k, v in pairs(self.partnerSkillUnlockItemMap) do
        v.resItem:Destory()
        v.resItem:DeleteMe()
        GameObject.Destroy(v.obj)
    end

    self.partnerSkillUnlockItemMap = {}

    if self.assistPartner then
        PoolManager.Instance:Push(PoolType.class, "PartnerAssistItem", self.assistPartner.commonItem)
    end
    self.assistPartner = nil
end

function PartnerUnlockSkillWindow:OnClickRuleBtn()

end

function PartnerUnlockSkillWindow:ClickActivateBtn()
    if not self.curUniqueId then return end
    if not mod.PartnerBagCtrl:CheckActivateSkillCostItem(self.curUniqueId, self.SelectSkillId) then return end
    self.activateSkillData = {
        curUniqueId = self.curUniqueId,
        SelectSkillId = self.SelectSkillId,
    }
    mod.PartnerCenterFacade:SendMsg("asset_partner_skill_unlock", self.curUniqueId, self.SelectSkillId, self.selectAssistPartner)
end

function PartnerUnlockSkillWindow:ClickLockBtn()
    if not self.curUniqueId then return end
    mod.PartnerBagCtrl:LockPartner(self.curUniqueId)
end

function PartnerUnlockSkillWindow:__Show()
    EventMgr.Instance:AddListener(EventName.PartnerInfoChange, self:ToFunc("OnPartnerInfoChange"))
    self.deviceUniqueId = self.args.uniqueId
    self.partnerSkillItemMap = {}
    self.partnerSkillUnlockItemMap = {}
    
    self.SkillMainContent:SetActive(false)

    self:OpenPanel(PartnerSelectPanel,{
        selectPartnerFunc = self:ToFunc("SelectPartner"),
        showPartnerFunc = self:ToFunc("ShowRightPartner"),
    })

    self.Forbidden_txt.text = "技能已激活"
    self:InitCamera()
end

function PartnerUnlockSkillWindow:InitCamera()
    Fight.Instance.modelViewMgr:LoadView(ModelViewConfig.ViewType.PartnerBag, function ()
        local view = self:GetModelView()
        --加载模型
        view:LoadScene(ModelViewConfig.Scene.PartnerBag, function()
            Fight.Instance.modelViewMgr:ShowView(ModelViewConfig.ViewType.PartnerBag)
            view:BlendToNewCamera(Vec3.zero, emptyCameraRotation)
            BehaviorFunctions.fight.clientFight.cameraManager:GetCurCamera().camera:SetActive(false)
        end)
    end)
end

function PartnerUnlockSkillWindow:SelectPartner(unique_id)
    self.defaultSkillId = false
    self.selectAssistPartner = nil
    self.curUniqueId = unique_id
    self.SkillMainContent:SetActive(true)
    local partnerData = mod.BagCtrl:GetPartnerData(unique_id)
    self:UpdateModel(partnerData)
end


function PartnerUnlockSkillWindow:UpdateModel(partnerData)
    if not partnerData then      
        return
    end
    
    if partnerData and self.SelectPartnerId == partnerData.template_id then
        self:UpdatePartnerDetailInfo()
        return
    end

    local onLoad = function()
        self.SelectPartnerId = partnerData.template_id
        self:SetCameraSetings(partnerData)
        self:UpdatePartnerDetailInfo()
    end

    local view = self:GetModelView()
    view:LoadModel(modelRoot, partnerData.template_id, onLoad)
end

function PartnerUnlockSkillWindow:SetCameraSetings(partnerData)
    local partner = partnerData and partnerData.template_id or 0
    local cameraConfig = RoleConfig.GetPartnerCameraConfig(partner, RoleConfig.PartnerCameraType.PartnerBag)
    local view = Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.PartnerBag)

    view:BlendToNewCamera(cameraConfig.camera_position, cameraConfig.camera_rotation, 24.5)
    view:SetModelRotation(modelRoot, cameraConfig.model_rotation)
    view:PlayModelAnim(modelRoot, cameraConfig.anim, 0.5)
end

function PartnerUnlockSkillWindow:GetModelView()
    return Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.PartnerBag)
end

function PartnerUnlockSkillWindow:__ShowComplete()
end

--退出动画
function PartnerUnlockSkillWindow:__AfterExitAnim()
    WindowManager.Instance:CloseWindow(self)
end

--月灵信息改变监听
function PartnerUnlockSkillWindow:OnPartnerInfoChange(oldData, newData)
    if newData.unique_id ~= self.curUniqueId then
        return 
    end
    self:UpdatePartnerDetailInfo()
end

function PartnerUnlockSkillWindow:UpdatePartnerLockState(oldItem, newItem)
    local partnerData = mod.BagCtrl:GetPartnerData(self.curUniqueId)
    if not partnerData then return end
    local isLock = partnerData.is_locked
    self.UnLockBtn:SetActive(not isLock)
    self.LockBtn:SetActive(isLock)
end

function PartnerUnlockSkillWindow:UpdateSkillLockDetail()
    --local isAllUnlock = mod.PartnerBagCtrl:CheckAssetPartnerSkillAllUnlock(self.curUniqueId)
    --if isAllUnlock then
    --    self.Forbidden_txt.text = "技能已全部激活"
    --end

    if not self.curUniqueId or not self.SelectSkillId then
        return
    end

    local isUnLockSkill = mod.PartnerBagCtrl:CheckAssetPartnerSkillUnlock(self.curUniqueId, self.SelectSkillId)
    if not isUnLockSkill then
        self:UpdateUnlockResList(self.SelectSkillId)
    else
        self:UpdateActivateView(not isUnLockSkill)
    end
end

function PartnerUnlockSkillWindow:ClearShowView()
    for k, v in pairs(self.partnerSkillItemMap) do
        v.obj.gameObject:SetActive(false)
    end

    for k, v in pairs(self.partnerSkillUnlockItemMap) do
        v.obj.gameObject:SetActive(false)
    end

    self.NoSelect:SetActive(true)
    self.UnlockSkill:SetActive(false)
    self.ActivateBtn:SetActive(false)
    self.ActivateForbidden:SetActive(true)
end

function PartnerUnlockSkillWindow:CheckShowActivateSkillSucPnl()
    if not self.activateSkillData then return end
    local data = self.activateSkillData
    if data.curUniqueId ~= self.curUniqueId or data.SelectSkillId ~= self.SelectSkillId then return end
    PanelManager.Instance:OpenPanel(ExclusiveSkillUnlockSucPanel, {skillId = data.SelectSkillId})
    self.activateSkillData = nil
end

function PartnerUnlockSkillWindow:UpdatePartnerBaseInfo()
    if not self.SelectPartnerId then return end
    local paretnerCfg = PartnerConfig.GetPartnerConfig(self.SelectPartnerId)
    if not paretnerCfg then return end

    self.PartnerName_txt.text = paretnerCfg.name

    local qualityCfg = PartnerConfig.GetPartnerQualityConfig(paretnerCfg.quality)

    SingleIconLoader.Load(self.PartnerQualityIcon, qualityCfg.icon)
end

-- 这里将详情放在这里就行,不通用
function PartnerUnlockSkillWindow:UpdatePartnerDetailInfo()
    self:ClearShowView()
    self:UpdatePartnerBaseInfo()
    self:UpdateSkillLockDetail()
    self:UpdateAssistPartnerInfo()
    self:UpdatePartnerLockState()
    self:CheckShowActivateSkillSucPnl()
    
    local partnerId = self.SelectPartnerId
    local exclusiveSkillCfg = PartnerCenterConfig.GetPartnerExclusiveSkillConfig(partnerId)
    if not exclusiveSkillCfg then
        --LogErrorf("缺少月灵配置, id = "..partnerId)
        self:ClearShowView()
        return 
    end
    local skillList = exclusiveSkillCfg.partner_skill_id
    
    for i = 1, #skillList do
        local skillId = skillList[i]
        if skillId ~= 0 then
            if not self.partnerSkillItemMap[i] then
                local obj = GameObject.Instantiate(self.SkillTemp)
                obj.transform:SetParent(self.SkillList.transform)
                UnityUtils.SetLocalScale(obj.transform, 1,1,1)
                self.partnerSkillItemMap[i] = {obj = obj, skillItem = PartnerSkillItem.New(), skillId = skillId}
            end

            local skillItem = self.partnerSkillItemMap[i].skillItem
            self.partnerSkillItemMap[i].skillId = skillId
            local data = {skillId = skillId, obj = self.partnerSkillItemMap[i].obj, idx = i, curUniqueId = self.curUniqueId}

            skillItem:SetData(self, data)
        end
    end

    if not self.defaultSkillId then
        -- 默认选择第一个
        self:SelectPartnerSkill(skillList[1], true)
        self.defaultSkillId = true
    end
end

function PartnerUnlockSkillWindow:GetCurSelectSkillId()
    return self.SelectSkillId
end

function PartnerUnlockSkillWindow:SelectPartnerSkill(skillId, isInit)
    for k, data in pairs(self.partnerSkillItemMap) do
        data.skillItem:UpdateSelectState(data.skillId == skillId)
        if data.skillId == skillId then
            self.SelectSkillId = data.skillId
        end
    end

    self:UpdateSkillLockDetail()
end

function PartnerUnlockSkillWindow:UpdateActivateView(isActivate)
    self.ActivateBtn:SetActive(isActivate and self.selectAssistPartner)
    self.ActivateForbidden:SetActive(not isActivate)
    self.NoSelect:SetActive(not isActivate)
    self.UnlockSkill:SetActive(isActivate)

    if not isActivate then
        self.Forbidden_txt.text = "技能已激活"
    end
end

function PartnerUnlockSkillWindow:UpdateUnlockResList(skillId)
    local isAllUnlock = mod.PartnerBagCtrl:CheckAssetPartnerSkillAllUnlock(self.curUniqueId)
    if isAllUnlock then
        return
    end
    local skillCfg = PartnerCenterConfig.GetPartnerExclusiveSkillUnlockConfig(skillId)
    if not skillCfg then
        return
    end

    self:UpdateActivateView(true)

    local needResList = skillCfg.item_consume
    for k, v in pairs(self.partnerSkillUnlockItemMap) do
        v.obj.gameObject:SetActive(false)
    end
    for i = 1, #needResList do
        local data = needResList[i]
        local resId = data[1]
        if resId ~= 0 then
            if not self.partnerSkillUnlockItemMap[i] then
                local obj = GameObject.Instantiate(self.ResTemp)
                obj.transform:SetParent(self.NeedResContent.transform)
                UnityUtils.SetLocalScale(obj.transform, 1,1,1)
                self.partnerSkillUnlockItemMap[i] = {obj = obj, resItem = PartnerSkillUnLockResItem.New()}
            end

            local resItem = self.partnerSkillUnlockItemMap[i].resItem
            local newData = {
                resId = resId,
                num = data[2],
                obj = self.partnerSkillUnlockItemMap[i].obj
            }
            resItem:SetData(self, newData)
        end
    end
end

-- 更新协助的月灵
function PartnerUnlockSkillWindow:UpdateAssistPartnerInfo()
    -- 筛选出一个满足条件的月灵
    local partnerList = mod.PartnerBagCtrl:GetCareerPartnerList(self.curUniqueId)
    if not partnerList then
        self.AddNewPartner:SetActive(true)
        self.CurPartnerView:SetActive(false)
        self.selectAssistPartner = nil
        return
    end
    
    self.AddNewPartner:SetActive(false)
    self.CurPartnerView:SetActive(true)

    if self.selectAssistPartner then
        return --如果已经选择过了，就不用自动筛选了
    end
    
    table.sort(partnerList, function(a, b)
        if a.careerLv == b.careerLv then
            return a.quality > b.quality
        end
        return a.careerLv > b.careerLv
    end)

    local selectPartnerData = partnerList[1]
    self:UpdateAssistPartnerView(selectPartnerData.unique_id)
end

function PartnerUnlockSkillWindow:UpdateAssistPartnerView(uniqueId)
    local newData = {
        parent = self.CurPartnerView,
        uniqueId = uniqueId,
        deviceUniqueId = self.deviceUniqueId
    }

    local commonItem
    if not self.assistPartner then
        commonItem = PoolManager.Instance:Pop(PoolType.class, "PartnerAssistItem")
        if not commonItem then
            commonItem = PartnerAssistItem.New()
        end
        self.assistPartner = newData
        self.assistPartner.commonItem = commonItem
    else
        commonItem = self.assistPartner.commonItem
    end
    commonItem:Init(self.AssistPartner)
    commonItem:UpdateUI(newData)
    self.selectAssistPartner = uniqueId

    self.AddNewPartner:SetActive(false)
    self.CurPartnerView:SetActive(true)
end

--点击换协助月灵
function PartnerUnlockSkillWindow:ChangeAssistPartner(uniqueId)
    self:UpdateAssistPartnerView(uniqueId)
    self:UpdateSkillLockDetail()
end

function PartnerUnlockSkillWindow:OpenChangeAssistPartnerPanel()
    self:OpenPanel(ChangeAssistPartnerPanel, {curUniqueId = self.curUniqueId, partnerId = self.SelectPartnerId, selectAssistPartner = self.selectAssistPartner, deviceUniqueId = self.deviceUniqueId})
end

