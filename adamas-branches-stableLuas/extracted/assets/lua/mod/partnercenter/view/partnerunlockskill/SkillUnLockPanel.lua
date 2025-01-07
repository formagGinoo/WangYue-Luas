SkillUnLockPanel = BaseClass("SkillUnLockPanel", BasePanel)


local colorCanNotBuy = Color(1,0.36,0.36)
local colorCanBuy = Color(0.41,0.43,0.50 )

function SkillUnLockPanel:__init()
    self:SetAsset("Prefabs/UI/AttendantCenter/SkillUnLockPanel.prefab")
end

function SkillUnLockPanel:__BindListener()
    EventMgr.Instance:AddListener(EventName.PartnerInfoChange, self:ToFunc("PartnerInfoChange"))
    self.addBtn_btn.onClick:AddListener(self:ToFunc("AddAssistHelpStaff"))
end

function SkillUnLockPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.PartnerInfoChange, self:ToFunc("PartnerInfoChange"))
end

--侍从员工技能点击
function SkillUnLockPanel:__Show()
    self.materialsobj = {}
    self.curhelpPartner=nil
    local config = {
        name = TI18N("月灵选择"),
        width = 575,
        col = 3,
        bagType = BagEnum.BagType.Partner,
        onClick = self:ToFunc("SelectPartner"),

        defaultSelect = self:GetRolePartner()
    }
    self.parentWindow:OpenPanel(ItemSelectPanel, { config = config })
end

--选择了侍从
function SkillUnLockPanel:SelectPartner(uniqueId, templateId)
    --我需要知道侍从那些技能以及解锁 需要服务器todo：
    local roleId = self:GetRolePartner()
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId, self.uid, roleId)
    local partnerId = partnerData.template_id
    self.skillIDs = PartnerCenterConfig.GetPartnerSkill(partnerId)
    self:SkillAllRefreshInfo(uniqueId)
end

--刷新所有的技能面板信息
function SkillUnLockPanel:SkillAllRefreshInfo(uniqueId)
    self:SkillTopInfoRefreshInfo(uniqueId)
    self:SkillButtonInfoRefresh(uniqueId)
end

--刷新头部信息  名字技能品质解锁
function SkillUnLockPanel:SkillTopInfoRefreshInfo(uniqueId)
    local roleId = self:GetRolePartner()
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId, self.uid, roleId)
    local partnerId = partnerData.template_id
    local qualityConfig = RoleConfig.GetPartnerQualityConfig(partnerId)
    local baseConfig = ItemConfig.GetItemConfig(partnerId)
    self.Name_txt.text=baseConfig.name
    SingleIconLoader.Load(self.QualityBg, qualityConfig.icon)
    self.LockButton_btn.onClick:RemoveAllListeners()
    self.LockButton_btn.onClick:AddListener(function ()
        local wheelPartnerList = mod.AbilityWheelCtrl:GetAbilityWheelPartnerList()
        for k, v in pairs(wheelPartnerList) do
            if uniqueId == v then
                MsgBoxManager.Instance:ShowTips(TI18N("该月灵在轮盘列表中，请先从轮盘列表卸下。"))
                return
            end
        end
        mod.BagCtrl:SetItemLockState(uniqueId, not partnerData.is_locked, BagEnum.BagType.Partner)
    end)
    UtilsUI.SetActive(self.Locked, partnerData.is_locked == true)
    UtilsUI.SetActive(self.UnLock, partnerData.is_locked == false)
    self:SkillInfoIconRefresh(self.skillIDs)
end

--刷新技能图片
function SkillUnLockPanel:SkillInfoIconRefresh(data)
    local int i=1
    for k,v in pairs(data.partner_skill_id) do
        local object=self["PassiveSkillItem"..i]
        local objectInfo = {}
        UtilsUI.GetContainerObject(object.transform, objectInfo)
        UtilsUI.SetActive(objectInfo.NoSkill,false)
        local baseConfig = RoleConfig.GetPartnerSkillConfig(v)
        if baseConfig ~= nil then
            UtilsUI.SetActive(object,true)
            SingleIconLoader.Load(objectInfo.SkillIcon, baseConfig.icon)
            objectInfo[string.format("Quality%d_tog", baseConfig.quality)].isOn = true
            i = i + 1
        else
            UtilsUI.SetActive(object,false)
        end
    end
end

--刷新底部信息
function SkillUnLockPanel:SkillButtonInfoRefresh(uniqueId)
    local data=mod.PartnerCenterCtrl:PartnerToSkillLock(uniqueId)
    UtilsUI.SetActive(self.nothing, data.isallUnlock)
    UtilsUI.SetActive(self.normal, not data.isallUnlock)
    if data.isallUnlock==true then
        return
    end
    --self:RefreshAssistStaff(data)
    local consumeconfig=PartnerCenterConfig.GetConsumItemID(data.curskillID)
    self:RefreshMaterialsInfo(consumeconfig.item_consume)  --todo:暂时注释
    UtilsUI.SetActive(self.addBtn, self.curhelpPartner == nil)
    UtilsUI.SetActive(self.staffshow, not self.curhelpPartner == nil)
end


--侍从员工技能点击
function SkillUnLockPanel:AttencentSkillClick()

end

--技能刷新
function SkillUnLockPanel:RefreshSkillInfo(data)

end

--材料刷新
function SkillUnLockPanel:RefreshMaterialsInfo(data)
    local consumitem={}
    for k,v in pairs(data) do
        local needitem={}
        needitem.scale=0.8
        needitem.template_id=v[1]
        needitem.neednum=v[2]
        table.insert(consumitem,needitem)
    end
    for k,v in pairs(consumitem) do
        if self.materialsobj[k]==nil then
            self.materialsobj[k]=ItemManager.Instance:GetItem(self.MaterialContent, v,nil)
        end
        local itmeobj=self.materialsobj[k]
        itmeobj.object:SetActive(true)
        --todo:关于字体的
         local havenum=mod.BagCtrl:GetItemCountById(v.template_id)
         local neednum=v.neednum
        if(havenum<neednum) then
            self.num_txt.color=colorCanNotBuy
        else
            self.num_txt.color=colorCanBuy
        end
        self.num_txt.text=string.format("%s/%s",havenum,neednum)
        
    end
    if #data>=#self.materialsobj then
        return
    end
    for i=#data,#self.materialsobj,1 do
        self.materialsobj[i].object:SetActive(false)
    end
end

--添加协助员工
function SkillUnLockPanel:AddAssistHelpStaff()
    local config = {
        callback = self:ToFunc("SelectHelpPatner"),
        --partnerlist=mod.PartnerCenterCtrl:GetStaffList() --todo:暂时这样不行后端跑不通  uniqueId
        partnerlist={[1]=3001011,[2]=3001012,[3]=3001013}
    }
    self.parentWindow:OpenPanel(HelpPatnerPanel,config)
end

--技能解锁面板选择协助配从
function SkillUnLockPanel:SelectHelpPatner(enter)
    if enter==true  then
        UtilsUI.SetActive(self.addBtn,false)
        UtilsUI.SetActive(self.staffshow,true)
        --UtilsUI.SetActive(self.itemObj,true)
        if self.commonItem==nil then
            self.commonItem = PoolManager.Instance:Pop(PoolType.class, "StaffStateItem") --CommonItem.New()
            if not self.commonItem then
                self.commonItem = StaffStateItem.New()
            end
        end
        self.commonItem:InitItem(self.SingleItem,{staffname="小明"})
    end
end


--配从技能激活
function SkillUnLockPanel:AttentcentSkillActivation()
    --且必须要有协助员工
    --todo:相关协议请求附带实体id，配从技能id，协助员工id
end

function SkillUnLockPanel:GetRolePartner()
    local roleId = mod.RoleCtrl:GetCurUISelectRole()
    return mod.RoleCtrl:GetRolePartner(roleId,self.uid)
end

--月灵信息变化
function SkillUnLockPanel:PartnerInfoChange(oldData, newData)
    --if not self.active or oldData.hero_id ~= newData.hero_id then
    --    return
    --end
    --if self.curSelect and self.curSelect == newData.unique_id then
    --    self:SkillAllRefreshInfo(self.curSelect)
    --elseif newData.unique_id == self:GetRolePartner() then
    --    self:SkillAllRefreshInfo(newData.unique_id)
    --end
    UtilsUI.SetActive(self.Locked, newData.is_locked == true)
    UtilsUI.SetActive(self.UnLock, newData.is_locked == false)
end
