CommonMapMark = BaseClass("CommonMapMark")

function CommonMapMark:__init(obj, parent, initScale, sortingOrder, callBack)
    self.config = {}
    self.obj = obj
    self.selectedCanvas = self.obj.Selected.transform:GetComponent(Canvas)
    self.closeCallBack = callBack

	UtilsUI.GetContainerObject(obj.objectTransform, self)
    self:SetParent(parent)
    self:SetScale(initScale)
    self:SetEffectSortingOrder(sortingOrder)

    self.obj.MarkCloseNode_hcb.HideAction:AddListener(self:ToFunc("CloseMarkCallBack"))
end

function CommonMapMark:InitMapMark(mark, initScale, callBack, mapScale)
    self.config = mark

    self.closeCallBack = callBack
    self.mapScale = mapScale and mapScale or 1

    self:SetScale(initScale)
    self:SetMarkIcon()
    self:SetArea()
    self:SetEffectState()
    self:SetPosition()
end

function CommonMapMark:InitSelectLayer(sortingOrder)
    if not self.selectedCanvas then
        return
    end

    self.selectedCanvas.sortingOrder = sortingOrder
end

function CommonMapMark:RefreshMapMark()
    self:SetMarkIcon()
    self:SetArea()
    self:SetEffectState()
    self:SetPosition()
end

function CommonMapMark:SetMarkIcon(forceIcon)
    local icon = forceIcon and forceIcon or self:GetMarkIcon()
    if not icon then
        return
    end

    UnityUtils.SetEulerAngles(self.obj.MarkIcon.transform, 0, 0, 0)
    if not self.config then
        UnityUtils.SetActive(self.obj.NormalBack, false)
        UnityUtils.SetActive(self.obj.STransBack, false)
        UnityUtils.SetActive(self.obj.STransLock, false)
        UnityUtils.SetActive(self.obj.BTransBack, false)
        UnityUtils.SetActive(self.obj.BTransLock, false)
        SingleIconLoader.Load(self.obj.MarkIcon, icon)
        return
    end

    local isNormal = not self.config.jumpCfg or (self.config.jumpCfg.jump_id ~= 100001 and self.config.jumpCfg.jump_id ~= 100002)
    local isActive = false
    local jumpId = 0
    if not isNormal then
        isActive = mod.WorldCtrl:CheckIsTransportPointActive(self.config.ecoCfg.id)
        jumpId = self.config.jumpCfg.jump_id
    end
    UnityUtils.SetActive(self.obj.NormalBack, isNormal and not self.config.isPlayer)
    UnityUtils.SetActive(self.obj.STransBack, isActive and jumpId == 100002)
    UnityUtils.SetActive(self.obj.STransLock, not isActive and jumpId == 100002)
    UnityUtils.SetActive(self.obj.BTransBack, isActive and jumpId == 100001)
    UnityUtils.SetActive(self.obj.BTransLock, not isActive and jumpId == 100001)

    SingleIconLoader.Load(self.obj.MarkIcon, icon)
end

-- 比例是临时的
function CommonMapMark:SetArea()
    if not self.config.radius or self.config.radius <= 0 then
        UnityUtils.SetActive(self.obj.AreaIcon, false)
        return
    end

    UnityUtils.SetActive(self.obj.AreaIcon, true)
    local uiSize = mod.WorldMapCtrl:GetUISize(self.config.map)
    local width = self.config.radius * 2 * uiSize.widthScale
    local length = self.config.radius * 2 * uiSize.lengthScale
    UnityUtils.SetSizeDelata(self.obj.AreaIcon_rect, width, length)
    UnityUtils.SetLocalScale(self.obj.AreaIcon_rect, 1 / self.mapScale, 1 / self.mapScale, 1 / self.mapScale)
end

function CommonMapMark:SetSelect(state, type)
    if state then
        if type == 1 then
            UnityUtils.SetActive(self.obj.MarkSmallNode, true)
        elseif type == 2 then
            UnityUtils.SetActive(self.obj.MarkBigNode, true)
        end
    else
        UnityUtils.SetActive(self.obj.MarkExitNode, true)
    end
end

-- 临时 后续添加为组件
function CommonMapMark:SetEffectSortingOrder(sortingOrder)
    UtilsUI.SetEffectSortingOrder(self.obj["21070"], sortingOrder + 1)
    UtilsUI.SetEffectSortingOrder(self.obj["21030"], sortingOrder + 1)
end

function CommonMapMark:SetEffectState(forceClose)
    if forceClose then
        UnityUtils.SetActive(self.obj["21070"], false)
        UnityUtils.SetActive(self.obj["21030"], false)
        return
    end

    UnityUtils.SetActive(self.obj["21030"], self.config.inTrace == true and not self.config.isPlayer)
    UnityUtils.SetActive(self.obj["21070"], self.config.type == FightEnum.MapMarkType.Task)
end

function CommonMapMark:SetPosition(position)
    if position and next(position) then
        UnityUtils.SetLocalPosition(self.obj.objectTransform, position.x, position.y, 0)
        return
    end

    local isMercenary = false
    if self.config.ecoCfg then
        isMercenary = Fight.Instance.entityManager.ecosystemEntityManager:IsMercenaryEntity(self.config.ecoCfg.id)
    end

    local posX = self.config.posX
    local posY = self.config.posY
    if self.config.isPlayer then
        local playerPos = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject().transformComponent:GetPosition()
        posX, posY = mod.WorldMapCtrl:TransWorldPosToUIPos(playerPos.x, playerPos.z, self.config.map)
    elseif isMercenary then
        local mercenaryCtrl = Fight.Instance.mercenaryHuntManager:GetMercenaryCtrl(self.config.ecoCfg.id)
        if not mercenaryCtrl then
            return
        end

        posX, posY = mod.WorldMapCtrl:TransWorldPosToUIPos(mercenaryCtrl.position.x, mercenaryCtrl.position.z, self.config.map)
    end

    UnityUtils.SetLocalPosition(self.obj.objectTransform, posX * self.mapScale, posY * self.mapScale, 0)
end

function CommonMapMark:SetRotation(rotY)
    if not rotY then
        return
    end

    UnityUtils.SetEulerAngles(self.obj.MarkIcon.transform, 0, 0, rotY + 90)
end

function CommonMapMark:SetScale(scale)
    UnityUtils.SetLocalScale(self.obj.objectTransform, scale, scale, scale)
    UnityUtils.SetLocalScale(self.obj.AreaIcon_rect, 1 / scale, 1 / scale, 1 / scale)
end

function CommonMapMark:SetParent(parent)
    self.obj.objectTransform:SetParent(parent)
end

function CommonMapMark:GetMarkIcon()
    if self.config.type == FightEnum.MapMarkType.Ecosystem then
        local ecoCfg = self.config.ecoCfg
        local jumpCfg = self.config.jumpCfg
        local icon = jumpCfg.icon
        if ecoCfg.is_transport and not mod.WorldCtrl:CheckIsTransportPointActive(ecoCfg.id) then
            local tempStr = string.sub(icon, 1, string.len(icon) - 4)
            tempStr = tempStr .. "_lock.png"
            icon = tempStr
        end

        return icon
    else
        return self.config.icon
    end
end

function CommonMapMark:CloseMark(isTempClose)
    self.tempClose = isTempClose
    UnityUtils.SetActive(self.obj.MarkCloseNode, true)
end

function CommonMapMark:PauseHide()
    self.pauseHide = true
end

function CommonMapMark:CloseMarkCallBack()
    if self.pauseHide then
        self.pauseHide = false
        return
    end

    self:SetSelect(false)
    UnityUtils.SetActive(self.obj.object, false)

    if self.tempClose then
        self.tempClose = false
        return
    end

    if self.closeCallBack then
        local instanceId = self.config and self.config.instanceId or nil
        self.closeCallBack(instanceId)
    end

    self.config = nil
end

function CommonMapMark:__cache()
    self.obj.MarkCloseNode_hcb:RemoveAllListeners()
end

function CommonMapMark:__delete()
    self.obj.MarkCloseNode_hcb:RemoveAllListeners()
end