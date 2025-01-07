UnlockPrepareWindow = BaseClass("UnlockPrepareWindow",BaseWindow)

function UnlockPrepareWindow:__init()
    self:SetAsset("Prefabs/UI/Unlock/UnlockPrepareWindow.prefab")
end

function UnlockPrepareWindow:__delete()
end

function UnlockPrepareWindow:__CacheObject()
end

function UnlockPrepareWindow:__BindListener()
    --self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("ClickCloseBtn"))

    self.SwitchBtn_btn.onClick:AddListener(self:ToFunc("ClickSwitchBtn"))
    self.PartnerBtn_btn.onClick:AddListener(self:ToFunc("ClickSwitchBtn"))
    self.UnlockBtn_btn.onClick:AddListener(self:ToFunc("ClickUnlockBtn"))
end

function UnlockPrepareWindow:ClickCloseBtn()
    self:UpdateCameraView(true)
    WindowManager.Instance:CloseWindow(self)
end

function UnlockPrepareWindow:ClickSwitchBtn()
    self:OpenPanel(UnlockSelectPartnerPanel, {select_data = self.selectPartner})
end

function UnlockPrepareWindow:ClickUnlockBtn()
    local cfg = self.unlockInitCfg
    local itemId = cfg.cost_id
    local costNum = cfg.cos_num
    if mod.BagCtrl:GetItemCountById(itemId) < costNum then
        MsgBoxManager.Instance:ShowTips(TI18N("所需道具不足"))
        return
    end

    local entityInstanceId = self.unlockManager:GetEntityInstanceId()
    local data = {
        lockInfoId = cfg.lock_info_id,
        unlockSkillId = self.selectPartner.skillId,
        unlockSkillLv = self.selectPartner.skillLv,
        ecoId = self.ecoId,
        lockId = cfg.lock_id,
        entityInstanceId = entityInstanceId
    }
    WindowManager.Instance:CloseWindow(self)
    WindowManager.Instance:OpenWindow(UnlockWindow, data)
end

function UnlockPrepareWindow:__Create()

end

function UnlockPrepareWindow:__Show()
    self.ecoId = self.args.ecoId
    self.unlockInitCfg = UnlockConfig.GetUnlockInitCfg(self.ecoId)
    local lockId = self.unlockInitCfg.lock_info_id
    self.lockInfoCfg = UnlockConfig.GetlockInfoCfg(lockId)

    self.unlockManager = BehaviorFunctions.fight.unlockManager
    self.selectPartner = self.unlockManager:GetSelectPartner()

    self.unlockManager:CreatPartner(self.selectPartner)
    self.lastPartnerEntityId = nil
    self.entityMgr = BehaviorFunctions.fight.entityManager

    self:updateLockInfo()
    self:UpdatePartnerInfo()
    self:updateCostInfo()
    self:UpdateCameraView()
end

function UnlockPrepareWindow:UpdateCameraView(isHide)
    local player = Fight.Instance.playerManager:GetPlayer()
	local playerObject = player:GetCtrlEntityObject()
    local playTrans = playerObject.clientEntity.clientTransformComponent.transform
    if isHide then
        BehaviorFunctions.SetCameraState(FightEnum.CameraState.Operating)
        BehaviorFunctions.fight.clientFight.cameraManager:SetMainTarget(playTrans)
    else
        -- local CameraTarget = playerObject.clientEntity.clientTransformComponent:GetTransform("KeyCameraTarget")
        -- local isHit = BehaviorFunctions.CheckObstaclesBetweenPos(playTrans.position, CameraTarget.position)
        -- if isHit then
            -- 发生碰撞后取门的目标点
            local doorInsid = BehaviorFunctions.GetEcoEntityByEcoId(self.ecoId)
            local doorEntity = BehaviorFunctions.GetEntity(doorInsid)
            local transComponent = doorEntity.clientEntity.clientTransformComponent
            local CameraTarget = transComponent:GetTransform("KeyCameraTarget")
        -- end

        if not CameraTarget then return end

        LuaTimerManager.Instance:AddTimer(1, 0.1, function()
            BehaviorFunctions.SetCameraState(FightEnum.CameraState.OpenDoor)
            if CameraTarget then
                CameraTarget.localPosition = CameraTarget.localPosition
                BehaviorFunctions.fight.clientFight.cameraManager.states[FightEnum.CameraState.OpenDoor]:SetMainTarget(CameraTarget)
            end
        end)
    end
end

function UnlockPrepareWindow:__Hide()
    self.unlockManager:DestoryPartner()
end

function UnlockPrepareWindow:updateLockInfo()
    local cfg = self.lockInfoCfg
    local lockLv = cfg.lock_lv
    self.LockLv_txt.text = lockLv
    self.LimitTime_txt.text = cfg.unlock_time.."s"

    local aprtnerSkillLv = self.selectPartner.skillLv
    local lv = 1
    if aprtnerSkillLv <= lockLv then
        lv = lockLv - aprtnerSkillLv <= 2 and 2 or 3
    end

    local color = UnlockConfig.LockLvColor[lv]
    self.LockLv_txt.color = color
end

function UnlockPrepareWindow:UpdatePartnerInfo()
    local partner = self.selectPartner
    local partnerCfg = ItemConfig.GetItemConfig(partner.partnerId)

    self.PartnerName_txt.text = partnerCfg.name
    SingleIconLoader.Load(self.PartnerIcon, partnerCfg.head_icon)
    self.PartnerLv_txt.text = "LV."..partner.lev

    local skillId = partner.skillId
    local skillCfg = RoleConfig.GetPartnerSkillConfig(skillId)
    self.SkillName_txt.text = skillCfg.name.."LV."..partner.skillLv
    SingleIconLoader.Load(self.SkillIcon, skillCfg.icon)
    self.SkillLv_txt.text = partner.skillLv

    self.entityMgr:CallBehaviorFun("OpenDoorMonster", partnerCfg.entity_id, self.lastPartnerEntityId)
    self.lastPartnerEntityId = partnerCfg.entity_id
end

function UnlockPrepareWindow:updateCostInfo()
    local commonItem = CommonItem.New()

    local cfg = self.unlockInitCfg
    local itemId = cfg.cost_id

    local haveCount = mod.BagCtrl:GetItemCountById(itemId)
    local needCount = cfg.cos_num

    local desc = ""
    if haveCount < needCount then
        desc = string.format("<color=#ff0000>%s</color>/<color=#ffffff>%s</color>", haveCount, needCount)
    else
        desc = string.format("<color=#ffffff>%s/%s</color>", haveCount, needCount)
    end

    local itemInfo = {template_id = itemId, count = desc, scale = 0.85}
    commonItem:InitItem(self.CommonItem, itemInfo, true)
    local itemCfg = ItemConfig.GetItemConfig(itemId)
    self.CostName_txt.text = itemCfg.name
end

function UnlockPrepareWindow:UpdateSelectPartnerData(newData)
    self.selectPartner = newData
    self:UpdatePartnerInfo()
    self.unlockManager:CreatPartner(self.selectPartner)
end
