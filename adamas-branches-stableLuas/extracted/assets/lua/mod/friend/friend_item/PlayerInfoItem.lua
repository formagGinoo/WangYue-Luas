PlayerInfoItem = BaseClass("PlayerInfoItem", Module)

function PlayerInfoItem:__init()
    self.object = nil
    self.parent = nil
    self.isself = nil
	self.node = {}
    self.playerInfo = {}
end

function PlayerInfoItem:InitItem(object, parent, id)
	-- 获取对应的组件
	self.object = object
    self.parent = parent
    
    UtilsUI.GetContainerObject(self.object.transform,self)

    if id and mod.InformationCtrl:CheckIsSelf(id) then
        self.MoreBtn_btn.onClick:AddListener(self:ToFunc("OpenPlayerInfoEditorPanel"))
        self.ChangeNameButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenPlayerNameEditorPanel"))
        self.ChangeHeadImageButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenPlayerHeadImageEditorPanel"))
        self.ChangeSignatureButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenPlayerSignatureEditorPanel"))
        self.ChangeNamebtn_btn.onClick:AddListener(self:ToFunc("OnClick_OpenPlayerNameEditorPanel"))
        self.Signature_btn.onClick:AddListener(self:ToFunc("OnClick_OpenPlayerSignatureEditorPanel"))
        self.AvatarItem_btn.onClick:AddListener(self:ToFunc("OnClick_OpenPlayerHeadImageEditorPanel"))
    end

    self.CopyBtn_btn.onClick:AddListener(self:ToFunc("OnClick_CopyID"))
    self.AddFriendBtn_btn.onClick:AddListener(self:ToFunc("AddFriend"))

    self.BGButton_btn.onClick:AddListener(self:ToFunc("ClosePlayerInfoEditorPanel"))
    self.CopyUIDButton_btn.onClick:AddListener(self:ToFunc("OnClick_CopyID"))

    if id then
        self:UpdataPlayerInfo(id)
    end
end

function PlayerInfoItem:UpdataPlayerInfo(id)
    if self.playerInfo and self.playerInfo.information and self.playerInfo.information.uid ~= id then
        self:PlayRefreshAnim()
    end
    self.isself = mod.InformationCtrl:CheckIsSelf(id)
    if self.isself then
        self.playerInfo.information = mod.InformationCtrl:GetPlayerInfo()
        self.playerInfo.adventure_lev = mod.WorldLevelCtrl:GetAdventureInfo().lev
        self.playerInfo.world_lev = mod.WorldLevelCtrl:GetWorldLevel()
        self.playerInfo.hero_num = #mod.RoleCtrl:GetRoleIdList()
        self.playerInfo.identity = {}
        local identityInfo = mod.IdentityCtrl:GetNowIdentity()
        self.playerInfo.identity.key = identityInfo.id
        self.playerInfo.identity.value = identityInfo.lv
    else
        self.playerInfo = mod.FriendCtrl:GetPlayerInfo(id)
    end

    if not self.playerInfo.information then
        self.playerInfo.information = TableUtils.CopyTable(mod.InformationCtrl:GetPlayerInfo())
        self.playerInfo.information.uid = id
    end

    if self.playerInfo.identity and self.playerInfo.identity.key ~= 0 then
        self.IdentityTxt_txt.text = IdentityConfig.GetIdentityTitleConfig(self.playerInfo.identity.key,self.playerInfo.identity.value).name
    else
        self.IdentityTxt_txt.text = TI18N("暂无佩戴")
    end

    local path = RoleConfig.HeroBaseInfo[self.playerInfo.information.avatar_id].chead_icon
    SingleIconLoader.Load(self.HeadIcon, path)
    SingleIconLoader.Load(self.HeadIconFrame,InformationConfig.GetFrameIcon(self.playerInfo.information.frame_id))

    self.RoleProgressTxt_txt.text = self.playerInfo.hero_num or 1

    local remark = mod.FriendCtrl:GetFriendRemark(id)
    -- if not self.isself and remark and remark ~= "" then
    --     self.PlayerName_txt.text = remark
    -- else
    self.PlayerName_txt.text = self.playerInfo.information.nick_name
    -- end

    if not self.isself then 
        UtilsUI.SetActiveByScale(self.ChangeNamebtn,false)
        UtilsUI.SetActiveByScale(self.MoreBtn,false)
        local state = mod.FriendCtrl:CheckIsFriend(id) or mod.FriendCtrl:CheckInBlackList(id)
        UtilsUI.SetActive(self.AddFriendBtn,not state)
    else
        UtilsUI.SetActiveByScale(self.ChangeNamebtn,true)
        UtilsUI.SetActiveByScale(self.MoreBtn,true)
        UtilsUI.SetActive(self.AddFriendBtn,false)
    end

    self.PlayerLvTit_txt.text = TI18N("探索等级：")
    self.PlayerLv_txt.text = self.playerInfo.adventure_lev
    self.WorldLvTit_txt.text = TI18N("世界等级：")
    self.WorldLv_txt.text = self.playerInfo.world_lev
    self.BirthDayTit_txt.text = TI18N("生         日：")
    if self.playerInfo.information.birthday_month and self.playerInfo.information.birthday_month > 0 then 
        self.BirthDay_txt.text = string.format(TI18N("%02d-%02d"),self.playerInfo.information.birthday_month ,self.playerInfo.information.birthday_day)
        UtilsUI.SetActive(self.BirthRedPoint,false)
    else
        self.BirthDay_txt.text = "XX-XX"
        if self.isself then
            UtilsUI.SetActive(self.BirthRedPoint,true)
            UtilsUI.SetActive(self.BirthDayBtn,true)
            self.BirthDayBtn_btn.onClick:RemoveAllListeners()
            self.BirthDayBtn_btn.onClick:AddListener(self:ToFunc("SetBirthDay"))
        else
            UtilsUI.SetActive(self.BirthRedPoint,false)
            UtilsUI.SetActive(self.BirthDayBtn,false)
            self.BirthDayBtn_btn.onClick:RemoveAllListeners()
        end
    end
    self.UID_txt.text = "UID:" .. self.playerInfo.information.uid

    local data = os.date("%Y-%m-%d",self.playerInfo.information.register_date) 

    self.RegistrationDate_txt.text = string.format(TI18N("注册日期:%s"),data)

    if not self.playerInfo.information.signature or self.playerInfo.information.signature == "" then
        self.SignatureTxt_txt.text = TI18N("尚未设置签名")
    else
        self.SignatureTxt_txt.text = self.playerInfo.information.signature
    end
    

    self:UpdataRoleInfo()
end

function PlayerInfoItem:UpdataRoleInfo()
    if self.isself then
        -- mod.RoleCtrl:GetRoleData(id)
        -- self.RightPart_btn.onClick:RemoveAllListeners()
        -- self.RightPart_btn.onClick:AddListener(self:ToFunc("SetShowRoleList"))
        self.RoleBtn1_btn.onClick:RemoveAllListeners()
        self.RoleBtn2_btn.onClick:RemoveAllListeners()
        self.RoleBtn3_btn.onClick:RemoveAllListeners()
        self.RoleBtn4_btn.onClick:RemoveAllListeners()
        self.RoleBtn1_btn.onClick:AddListener(self:ToFunc("SetShowRoleList"))
        self.RoleBtn2_btn.onClick:AddListener(self:ToFunc("SetShowRoleList"))
        self.RoleBtn3_btn.onClick:AddListener(self:ToFunc("SetShowRoleList"))
        self.RoleBtn4_btn.onClick:AddListener(self:ToFunc("SetShowRoleList"))
        if self.playerInfo.information.hero_id_list[1] and self.playerInfo.information.hero_id_list[1] ~= 0 then
            local role = RoleConfig.GetRoleConfig(self.playerInfo.information.hero_id_list[1])
            UtilsUI.SetActive(self.MainRoleInfo,true)
            SingleIconLoader.Load(self.MainRoleImg,role.stand_icon)
            local qualityData = ItemManager.GetItemColorData(role.quality)
            SingleIconLoader.Load(self.MainQuality, AssetConfig.GetQualityIcon(qualityData.itemFront))
            self.MainRoleName_txt.text = role.name
            self.MainRoleLv_txt.text = string.format(TI18N("等级%d"),mod.RoleCtrl:GetRoleData(role.id).lev)
        else
            UtilsUI.SetActive(self.MainRoleInfo,false)
        end
        for i = 2, 4, 1 do
            if self.playerInfo.information.hero_id_list[i] and self.playerInfo.information.hero_id_list[i] ~= 0 then
                local role = RoleConfig.GetRoleConfig(self.playerInfo.information.hero_id_list[i])
                UtilsUI.SetActive(self["Role"..i-1],true)
                local qualityData = ItemManager.GetItemColorData(role.quality)
                SingleIconLoader.Load(self["HeadIcon"..i-1],role.shead_icon)
                SingleIconLoader.Load(self["QualityImg"..i-1],AssetConfig.GetQualityIcon(qualityData.back))
                self["Name".. i-1 .. "_txt" ].text = role.name
                self["Lv".. i-1 .. "_txt" ].text =  string.format(TI18N("等级%d"),mod.RoleCtrl:GetRoleData(role.id).lev)
            else
                UtilsUI.SetActive(self["Role"..i-1],false)
            end
        end
    else
        self.RoleBtn1_btn.onClick:RemoveAllListeners()
        self.RoleBtn2_btn.onClick:RemoveAllListeners()
        self.RoleBtn3_btn.onClick:RemoveAllListeners()
        self.RoleBtn4_btn.onClick:RemoveAllListeners()
        self.RoleBtn1_btn.onClick:AddListener(self:ToFunc("OnClickShowRole1"))
        self.RoleBtn2_btn.onClick:AddListener(self:ToFunc("OnClickShowRole2"))
        self.RoleBtn3_btn.onClick:AddListener(self:ToFunc("OnClickShowRole3"))
        self.RoleBtn4_btn.onClick:AddListener(self:ToFunc("OnClickShowRole4"))
        
        if self.playerInfo.information.hero_id_list[1] and self.playerInfo.information.hero_id_list[1] ~= 0 then
            local role = RoleConfig.GetRoleConfig(self.playerInfo.information.hero_id_list[1])
            UtilsUI.SetActive(self.MainRoleInfo,true)
            SingleIconLoader.Load(self.MainRoleImg,role.stand_icon)
            local qualityData = ItemManager.GetItemColorData(role.quality)
            SingleIconLoader.Load(self.MainQuality, AssetConfig.GetQualityIcon(qualityData.itemFront))
            local roleInfo
            for _, v in pairs(self.playerInfo.hero_list) do
                if v.id == self.playerInfo.information.hero_id_list[1] then
                    roleInfo = v
                    break 
                end
            end
            if not roleInfo then
                roleInfo = mod.RoleCtrl:GetRoleData(role.id)
            end
            self.MainRoleName_txt.text = role.name
            self.MainRoleLv_txt.text = string.format(TI18N("等级%d"),roleInfo.lev)
        else
            UtilsUI.SetActive(self.MainRoleInfo,false)
        end
        for i = 2, 4, 1 do
            UtilsUI.SetActive(self["Empty"..i-1],false)
            if self.playerInfo.information.hero_id_list[i] and self.playerInfo.information.hero_id_list[i] ~= 0 then
                local role = RoleConfig.GetRoleConfig(self.playerInfo.information.hero_id_list[i])
                UtilsUI.SetActive(self["Role"..i-1],true)
                local qualityData = ItemManager.GetItemColorData(role.quality)
                SingleIconLoader.Load(self["HeadIcon"..i-1],role.shead_icon)
                SingleIconLoader.Load(self["QualityImg"..i-1],AssetConfig.GetQualityIcon(qualityData.back))
                self["Name".. i-1 .. "_txt" ].text = role.name
                local roleInfo
                for _, v in pairs(self.playerInfo.hero_list) do
                    local tempId = v.id
                    if tempId == 10010011 or tempId == 10010012 then
                        tempId = 1001001
                    end
                    if tempId == self.playerInfo.information.hero_id_list[i] then
                        roleInfo = v
                        break 
                    end
                end
                if not roleInfo then
                    roleInfo = mod.RoleCtrl:GetRoleData(role.id)
                end
                self["Lv".. i-1 .. "_txt" ].text =  string.format(TI18N("等级%d"),roleInfo.lev)
            else
                UtilsUI.SetActive(self["Role"..i-1],false)
            end
        end
    end
end

function PlayerInfoItem:OnClickShowRole1()
    self:ShowFriendRoleInfo(1)
end

function PlayerInfoItem:OnClickShowRole2()
    self:ShowFriendRoleInfo(2)
end

function PlayerInfoItem:OnClickShowRole3()
    self:ShowFriendRoleInfo(3)
end

function PlayerInfoItem:OnClickShowRole4()
    self:ShowFriendRoleInfo(4)
end

function PlayerInfoItem:ShowFriendRoleInfo(index)
    local id = self.playerInfo.information.hero_id_list[index]
    if id and id ~= 0 then
        RoleMainWindow.OpenWindow(id, {uid = self.playerInfo.information.uid,roleId = id})
    end
    
    -- for i, v in ipairs(self.playerInfo.information.hero_id_list) do
    --     if v ~= 0 then
    --         RoleMainWindow.OpenWindow(v, {uid = self.playerInfo.information.uid,roleId = v})
    --         --WindowManager.Instance:OpenWindow(RoleMainWindow,{uid = self.playerInfo.information.uid,roleId = v})
    --         return
    --     end
    -- end
end

function PlayerInfoItem:OnClick_OpenPlayerHeadImageEditorPanel()
    self:ClosePlayerInfoEditorPanel()
    --mod.InformationFacade:SendMsg("frame_list")
    self.editorPanel = PanelManager.Instance:OpenPanel(PlayerHeadImageEditorPanel)
    self.editorPanel:Show()
end

function PlayerInfoItem:OnClick_OpenPlayerNameEditorPanel()
    self:ClosePlayerInfoEditorPanel()
    self.editorPanel = PanelManager.Instance:OpenPanel(PlayerInfoEditorPanel,{view = PlayerInfoEditorPanel.EditorView.Name})
    self.editorPanel:Show()
end

function PlayerInfoItem:OnClick_OpenPlayerSignatureEditorPanel()
    self:ClosePlayerInfoEditorPanel()
    self.editorPanel = PanelManager.Instance:OpenPanel(PlayerInfoEditorPanel,{view = PlayerInfoEditorPanel.EditorView.Signature})
    self.editorPanel:Show()
end

function PlayerInfoItem:OnClick_CopyID()
    self:ClosePlayerInfoEditorPanel()
    GUIUtility.systemCopyBuffer = self.playerInfo.information.uid
    MsgBoxManager.Instance:ShowTips(TI18N("复制成功"))
end

function PlayerInfoItem:SetBirthDay()
    if self.playerInfo.information.birthday_month > 0 then return end
    self.parent:OpenPanel(SetBirthdayPanel)
end

function PlayerInfoItem:AddFriend()
    mod.FriendCtrl:AddFriend(self.playerInfo.information.uid)
end

function PlayerInfoItem:OpenPlayerInfoEditorPanel()
    UtilsUI.SetActive(self.PlayerInfoEditorPanel,true)
end

function PlayerInfoItem:ClosePlayerInfoEditorPanel()
    UtilsUI.SetActive(self.PlayerInfoEditorPanel,false)
end

function PlayerInfoItem:SetShowRoleList()
    UtilsUI.SetActiveByScale(self.BGBtn_,true)
    local config = {
        curIndex = self.curIndex or 1,
        roleList = self.playerInfo.information.hero_id_list,
        selectMode = InformationConfig.SelectMode
    }
    self.parent:OpenPanel(RoleListPanel,config)
end

function PlayerInfoItem:PlayRefreshAnim()
    self.PlayerInfoItem_anim:Play("UI_PlayerInfoItem_qiehuan",0,0)
end

function PlayerInfoItem:OnReset()
    self.AvatarItem_btn.onClick:RemoveAllListeners()
    self.ChangeNamebtn_btn.onClick:RemoveAllListeners()
    self.Signature_btn.onClick:RemoveAllListeners()
    self.CopyBtn_btn.onClick:RemoveAllListeners()
    self.AddFriendBtn_btn.onClick:RemoveAllListeners()

    self.MoreBtn_btn.onClick:RemoveAllListeners()
    self.BGButton_btn.onClick:RemoveAllListeners()
    self.ChangeNameButton_btn.onClick:RemoveAllListeners()
    self.ChangeHeadImageButton_btn.onClick:RemoveAllListeners()
    self.ChangeSignatureButton_btn.onClick:RemoveAllListeners()
    self.CopyUIDButton_btn.onClick:RemoveAllListeners()

    self.BirthDayBtn_btn.onClick:RemoveAllListeners()

    self.object = nil
    self.parent = nil
    self.isself = nil
	self.node = {}
    self.playerInfo = {}
end