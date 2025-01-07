CommonMapMark = BaseClass("CommonMapMark")

function CommonMapMark:__init(obj, parent, initScale, sortingOrder, callBack,isHud)
    self.config = {}
    self.obj = obj
    self.selectedCanvas = self.obj.Selected.transform:GetComponent(Canvas)
    self.closeCallBack = callBack
	self.isHud = isHud

	-- UtilsUI.GetContainerObject(obj.objectTransform, self)
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

    if self.config and (self.config.type == FightEnum.MapMarkType.RoadPath or self.config.type == FightEnum.MapMarkType.NavMeshPath or self.config.type == FightEnum.MapMarkType.LevelEnemy) then
        UnityUtils.SetActive(self.obj.NormalBack, false)
        UnityUtils.SetActive(self.obj.STransBack, false)
        UnityUtils.SetActive(self.obj.STransLock, false)
        UnityUtils.SetActive(self.obj.BTransBack, false)
        UnityUtils.SetActive(self.obj.BTransLock, false)
        self.obj.MarkIcon:SetActive(false)

        if self.config.type == FightEnum.MapMarkType.LevelEnemy then
            self.obj.EnemyTemp:SetActive(true)
        end

        return
    end
    if not icon then
        return
    end

    self.obj.EnemyTemp:SetActive(false)
	local showFunc = function()
        self.obj.MarkIcon_canvas.alpha = 1
		--self.obj.MarkShowNode:SetActive(true)
	end
    UnityUtils.SetEulerAngles(self.obj.MarkIcon.transform, 0, 0, 0)
    if not self.config then
        UnityUtils.SetActive(self.obj.NormalBack, false)
        UnityUtils.SetActive(self.obj.STransBack, false)
        UnityUtils.SetActive(self.obj.STransLock, false)
        UnityUtils.SetActive(self.obj.BTransBack, false)
        UnityUtils.SetActive(self.obj.BTransLock, false)
        SingleIconLoader.Load(self.obj.MarkIcon, icon, showFunc)
        return
    end

    local isNormal = not self.config.jumpCfg or (self.config.jumpCfg.jump_id ~= 100001 and self.config.jumpCfg.jump_id ~= 100002)
    local isActive = false
    local jumpId = 0
    if not isNormal then
        isActive = mod.WorldCtrl:CheckIsTransportPointActive(self.config.ecoCfg.id)
        jumpId = self.config.jumpCfg.jump_id
    end
    --UnityUtils.SetActive(self.obj.NormalBack, isNormal and not self.config.isPlayer)
    UnityUtils.SetActive(self.obj.STransBack, isActive and jumpId == 100002)
    UnityUtils.SetActive(self.obj.STransLock, not isActive and jumpId == 100002)
    UnityUtils.SetActive(self.obj.BTransBack, isActive and jumpId == 100001)
    UnityUtils.SetActive(self.obj.BTransLock, not isActive and jumpId == 100001)

    --self.obj.MarkIcon:SetActive(false)
    self.obj.MarkIcon_canvas.alpha = 0
    SingleIconLoader.Load(self.obj.MarkIcon, icon, showFunc)
end

function CommonMapMark:RemoveNavPath()
    UnityUtils.SetActive(self.obj["UI_NavFullPath"], false)
    UnityUtils.SetActive(self.obj["UI_NavPartPath"], false)
end

function CommonMapMark:SetNavPathScale(scale)
    UnityUtils.SetLocalScale(self.obj.UI_NavFullPath.transform, 1 / scale, 1 / scale, 1 / scale)
    UnityUtils.SetLocalScale(self.obj.UI_NavPartPath.transform, 1 / scale, 1 / scale, 1 / scale)
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
    self.selected = state
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

function CommonMapMark:GetNavPathComponent()
    if not self.UI_NavFullPathDraw then
        local navPathDraws =  self.obj["UI_NavFullPath"]:GetComponentsInChildren(NavPathDraw)
        for i = 0, navPathDraws.Length - 1 do
            self.UI_NavFullPathDraw = navPathDraws[i]
        end
    end
    if not self.UI_NavPartPathDraw then
        local navPathDraws =  self.obj["UI_NavPartPath"]:GetComponentsInChildren(NavPathDraw)
        for i = 0, navPathDraws.Length - 1 do
            self.UI_NavPartPathDraw = navPathDraws[i]
        end
    end
end

function CommonMapMark:UpdateRoadPath()
    UnityUtils.SetActive(self.obj["UI_NavFullPath"], true)
    local trafficManager = Fight.Instance.entityManager.trafficManager
    self.navPosList = self.navPosList or {}
    trafficManager:PushVec3List(self.navPosList)

    local posList = mod.WorldMapCtrl:GetCurDrawPointUI(self.config.drawInstance, self.config.mapNavPathInstanceId)
	if not posList or #posList == 0 then
        --没有数据时隐藏
        UnityUtils.SetActive(self.obj["UI_NavFullPath"], false)
        UnityUtils.SetActive(self.obj["UI_NavPartPath"], false)
    else
        
        local originPosX ,originPosY = mod.WorldMapCtrl:TransWorldPosToUIPos(posList[1].x, posList[1].z, self.config.map)
        for i, v in ipairs(posList) do
            local posX
            local posY
            posX, posY = mod.WorldMapCtrl:TransWorldPosToUIPos(v.x, v.z, self.config.map)
            
            table.insert(self.navPosList ,trafficManager:PopVec3(posX - originPosX,posY - originPosY,0))
        end
	end

    local color = mod.WorldMapCtrl:GetCurDrawPointColor(self.config.drawInstance, self.config.mapNavPathInstanceId)
    self.UI_NavFullPathDraw:SetNavPathColor(color)
    if self.isHud then
        self.UI_NavFullPathDraw:SetNavUIMask(true)
    else
        self.UI_NavFullPathDraw:SetNavUIMask(false)
    end
    --if not self.InitPathColor then
    --    self.InitPathColor = true
    --end

    self.UI_NavFullPathDraw:DrawPath(self.navPosList)
end


function CommonMapMark:UpdateNavMeshPath()
    --开车状态才用虚线， 走路取到数据后用实线
    local playerDriving = BehaviorFunctions.CheckCtrlDrive()
    local navDraw
    if playerDriving then
        UnityUtils.SetActive(self.obj["UI_NavFullPath"], false)
        UnityUtils.SetActive(self.obj["UI_NavPartPath"], true)
        navDraw = self.UI_NavPartPathDraw
    else
        UnityUtils.SetActive(self.obj["UI_NavFullPath"], true)
        UnityUtils.SetActive(self.obj["UI_NavPartPath"], false)
        navDraw = self.UI_NavFullPathDraw
    end
    
    --local trafficManager = Fight.Instance.entityManager.trafficManager
    self.navMeshPosList = {}
    --trafficManager:PushVec3List(self.navPosList)

    local posList = Fight.Instance.mapNavPathManager:GetCurNavMeshPoint(self.config.drawInstance, self.config.mapNavPathInstanceId)
    if not posList or #posList == 0 then
        UnityUtils.SetActive(self.obj["UI_NavFullPath"], false)
        UnityUtils.SetActive(self.obj["UI_NavPartPath"], false)
    else
        local originPosX ,originPosY = mod.WorldMapCtrl:TransWorldPosToUIPos(posList[1].x, posList[1].z, self.config.map)
        for i, v in ipairs(posList) do
            local posX, posY = mod.WorldMapCtrl:TransWorldPosToUIPos(v.x, v.z, self.config.map)

            table.insert(self.navMeshPosList ,Vec3.New(posX - originPosX,posY - originPosY,0))
        end
    end

    local color = Fight.Instance.mapNavPathManager:GetCurNavMeshPointColor(self.config.drawInstance, self.config.mapNavPathInstanceId)
    navDraw:SetNavPathColor(color)
    if self.isHud then
        navDraw:SetNavUIMask(true)
    else
        navDraw:SetNavUIMask(false)
    end
    --if not self.InitNavPathColor then
    --    self.InitNavPathColor = true
    --end

    navDraw:DrawPath(self.navMeshPosList)
end

-- 临时 后续添加为组件
function CommonMapMark:SetEffectSortingOrder(sortingOrder)
    UtilsUI.SetEffectSortingOrder(self.obj["21070"], sortingOrder + 1)
    UtilsUI.SetEffectSortingOrder(self.obj["21030"], sortingOrder + 1)
	
    self:SetNavPathSortingOrder(sortingOrder)

end

function CommonMapMark:SetNavPathSortingOrder(sortingOrder)
    if self.isHud then
        UtilsUI.SetEffectSortingOrder(self.obj["UI_NavFullPath"], 33) -- 收遮罩影响，所有引导线固定33层
        UtilsUI.SetEffectSortingOrder(self.obj["UI_NavPartPath"], 33) -- 收遮罩影响，所有引导线固定33层
    else
        UtilsUI.SetEffectSortingOrder(self.obj["UI_NavFullPath"], sortingOrder + 1) 
        UtilsUI.SetEffectSortingOrder(self.obj["UI_NavPartPath"], sortingOrder + 1)
    end
end

function CommonMapMark:HideMark(isHide)
    self.isHideEffect = isHide
    self:SetEffectState()
end

function CommonMapMark:SetEffectState()
    if self.isHideEffect then
        UtilsUI.SetActiveByScale(self.obj["21070"], false)
        UtilsUI.SetActiveByScale(self.obj["21030"], false)
        return
    end
    UtilsUI.SetActiveByScale(self.obj["21030"], self.config.inTrace == true and not self.config.isPlayer)
    UtilsUI.SetActiveByScale(self.obj["21070"], self.config.type == FightEnum.MapMarkType.Task)
    self:GetNavPathComponent()
    if self.config.type == FightEnum.MapMarkType.RoadPath then
        self:UpdateRoadPath()
    elseif self.config.type == FightEnum.MapMarkType.NavMeshPath then
        self:UpdateNavMeshPath()
    end
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

    UnityUtils.SetLocalPosition(self.obj.objectTransform, posX , posY , 0)
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
	
	
	if self.config and (self.config.type == FightEnum.MapMarkType.RoadPath or self.config.type == FightEnum.MapMarkType.NavMeshPath) then
        --scale = self.isHud and scale * 2 or scale
        self:SetNavPathScale(scale)
	end
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

function CommonMapMark:ShowMark(anim)
    if anim then
        UnityUtils.SetActive(self.obj.MarkShowNode, true)
    else
        UnityUtils.SetActive(self.obj.object, true)
    end
end

function CommonMapMark:CloseMark(isTempClose)
    self.tempClose = isTempClose
    if isTempClose then
        UnityUtils.SetActive(self.obj.MarkSmallNode, false)
        UnityUtils.SetActive(self.obj.MarkBigNode, false)
        UnityUtils.SetActive(self.obj.MarkExitNode, false)
        UnityUtils.SetActive(self.obj.object, false)
    else
        if self.obj.object.activeSelf then
            UnityUtils.SetActive(self.obj.MarkCloseNode, true)
        else
            self:CloseMarkCallBack()
        end
    end
    self:RemoveNavPath()
end

function CommonMapMark:PauseHide()
    self.pauseHide = true
end

function CommonMapMark:CloseMarkCallBack()
    if self.pauseHide then
        self.pauseHide = false
        return
    end

    if self.selected then
        self:SetSelect(false)
    end
    UnityUtils.SetActive(self.obj.object, false)

    if self.closeCallBack then
        local instanceId = self.config and self.config.instanceId or nil
        self.closeCallBack(instanceId)
    end

    self.config = {}
end

function CommonMapMark:__cache()
    
    self:RemoveNavPath()
    self.obj.MarkCloseNode_hcb:RemoveAllListeners()
end

function CommonMapMark:__delete()
    self:RemoveNavPath()
    self.obj.MarkCloseNode_hcb:RemoveAllListeners()
end