WorldMapWindow = BaseClass("WorldMapWindow", BaseWindow)

function WorldMapWindow:__init()
    self:SetAsset("Prefabs/UI/WorldMap/WorldMapWindow.prefab")
    -- self:SetCacheMode(UIDefine.CacheMode.hide)
    self.mapScale = 1
    self.maxScale = 2
    self.minScale = nil
    self.mapId = 0
    self.forceShowMark = nil
    self.unlockAreaId = nil
    self.unlockAreaObj = nil

    -- 跟踪目标
    self.traceObjPool = {}
    self.traceObjList = {}

    -- 地图标记
    self.markObjPool = {}
    self.marksOnShow = {}

    self.mapObjPool = {}
    self.mapBlockOnShow = {}

    self.mapMaskPool = {}
    self.mapMaskOnShow = {}

    self.selectedMark = nil
    self.selectObjPool = {}
    self.selectionOnShow = {}

    self.smallAreaNames = {}
    self.midAreaNames = {}
    self.mapAreaNameObjPool = {}

    self.tempCustomMark = nil

    self.isTouchEvent = false
    self.initDistance = 0

    self.scalingDragBehavior = nil
end

function WorldMapWindow:__BindListener()
    -- 组件获取
    self.scalingBar = self.Scroller:GetComponent(Scrollbar)
    self.mapScrollRect = self.MapScrollView:GetComponent(ScrollRect)
    self.mapDragBehavior = self.MapScrollView:GetComponent(UIDragBehaviour)
    self.markSelectedCanvas = self.MarkSelect:GetComponent(Canvas)

    self.touchEvent = self.MapScrollView:GetComponent(UITouchEvent)
    self.touchEvent:SetTouchAction(self:ToFunc("OnTouchEvent"))

    self.markSelectedCanvas.sortingOrder = self.canvas.sortingOrder + 2

    self.MarkSelect_btn.onClick:AddListener(self:ToFunc("OnClick_MarkSelectBtn"))
    self:SetHideNode("CloseNode")
    self:BindCloseBtn(self.TrueCloseBtn_btn, self:ToFunc("CloseNodeCallBack"), self:ToFunc("OnClick_CloseBtn"))

    self.scalingBar.onValueChanged:AddListener(self:ToFunc("OnValueChange_Scale"))

    self.PayBtn_btn.onClick:AddListener(self:ToFunc("OnClick_PayBtn"))
    self:BindMapListener()

    self.CloseNode_hcb.HideAction:AddListener(self:ToFunc("CloseNodeCallBack"))
    self.EntryAniNode_hcb.HideAction:AddListener(self:ToFunc("EntryAniCallBack"))
    self.MarkSelectExitNode_hcb.HideAction:AddListener(self:ToFunc("MarkSelectExitNodeCallBack"))

    EventMgr.Instance:AddListener(EventName.MarkUpdate, self:ToFunc("OnMarkUpdate"))
    EventMgr.Instance:AddListener(EventName.CancelMapMarkTrace, self:ToFunc("OnMarkTraceCancel"))
    EventMgr.Instance:AddListener(EventName.ShopListUpdate, self:ToFunc("OnShopListUpdate"))
    EventMgr.Instance:AddListener(EventName.AlertValueUpdate, self:ToFunc("ShowMercenaryBar"))
end

function WorldMapWindow:BindMapListener()
    local onDragFunc = function ()
        if self.isTouchEvent then
            return
        end

        self.draging = true
        self:RefreshTraceMark()
    end

    local onPointerUpFunc = function (data)
        if self.isTouchEvent then
            return
        end

        if self.draging then
            self.draging = false
            return
        end

        local hitTable = {}
        local minDis = 30
        local minPos = {}
        for k, v in pairs(self.marksOnShow) do
            local posX, posY = CustomUnityUtils.ScreenPointToLocalPointInRectangle(v.obj.objectTransform, data.position.x, data.position.y, ctx.UICamera)
            local dis = math.sqrt(posX ^ 2 + posY ^ 2)
            if dis <= minDis then
                minDis = dis
                minPos.x = data.position.x - posX
                minPos.y = data.position.y - posY
            end
        end

        minDis = 50
        local closetMark
        local scalePrecent = 1 - ((self.maxScale - self.mapScale) / (self.maxScale - self.minScale))
        local value = math.ceil(scalePrecent * 6) > 0 and math.ceil(scalePrecent * 6) or 1
        for k, v in pairs(self.marksOnShow) do
            local posX, posY = CustomUnityUtils.ScreenPointToLocalPointInRectangle(v.obj.objectTransform, minPos.x, minPos.y, ctx.UICamera)
            local dis = math.sqrt(posX ^ 2 + posY ^ 2)
            if dis <= 50 then
                local mark = v.config
                local canInsert = not mark.isPlayer
                if canInsert then
                    if mark.type == FightEnum.MapMarkType.Ecosystem then
                        local show_scale = mark.jumpCfg.show_scale
                        if show_scale[1] > value or show_scale[2] < value then
                            canInsert = false
                        end
                    else
                        local scale = mark.showScale
                        if scale > value then
                            canInsert = false
                        end
                    end
                end

                if canInsert then
                    if dis < minDis then
                        minDis = dis
                        closetMark = k
                    end
                    table.insert(hitTable, k)
                end
            end
        end

        local len = #hitTable
        if self.tempCustomMark and len > 0 then
            local mark = self.tempCustomMark
            self.tempCustomMark = nil
            mark:CloseMark(true)
            table.insert(self.markObjPool, mark)
        elseif self.selectedMark then
            self.marksOnShow[self.selectedMark]:SetSelect(false)
            self.selectedMark = nil
        end

        if len > 1 then
            self.selectedMark = closetMark
            self.marksOnShow[self.selectedMark]:SetSelect(true, 2)
            self:RefreshMarkSelect(true, hitTable)
        elseif len == 1 then
            self.selectedMark = hitTable[1]
            self.marksOnShow[self.selectedMark]:SetSelect(true, 1)
            self:OnClick_MarkInfo(self.selectedMark)
        else
            local _, hitPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.Content.transform, data.position, ctx.UICamera)
            if self.tempCustomMark then
                self.tempCustomMark:SetPosition({ x = hitPos.x, y = hitPos.y })
            else
                self:OnClick_AddTempMark(hitPos)
            end
        end
    end


    self.mapDragBehavior.onDrag = onDragFunc
    self.mapDragBehavior.onPointerClick = onPointerUpFunc

    self.mapScrollRect.onValueChanged:AddListener(self:ToFunc("RefreshTraceMark"))
end

function WorldMapWindow:__Show()
    self.mapId = Fight.Instance:GetFightMap()

    if self.args then
        self.forceShowMark = self.args.mark
        self.unlockAreaId = self.args.unlockArea
    end

    self:LoadMap()
    self:LoadMapMask()
    self:LoadMark()
    self:LoadMapAreaName()
    self:ShowMercenaryBar()

    local value = 1 - ((self.maxScale - self.mapScale) / (self.maxScale - self.minScale))
    self.scalingBar.value = value

	-- 如果有解锁的区域 先移动到这里来
	if self.unlockAreaId then
		local areaCfg = Fight.Instance.mapAreaManager:GetAreaConfig(self.unlockAreaId)
        local edgeCfg = MapPositionConfig.GetAreaEdgeInfo(FightEnum.AreaType.Mid, self.unlockAreaId)
        local wPosX = (edgeCfg.minX + edgeCfg.maxX) / 2
        local wPosY = (edgeCfg.minY + edgeCfg.maxY) / 2
        local posX, posY = mod.WorldMapCtrl:TransWorldPosToUIPos(wPosX, wPosY, self.mapId)
		local width = (posX * self.mapScale) - (self.MapScrollView_rect.rect.width * 0.5)
        local height = (posY * self.mapScale) + (self.MapScrollView_rect.rect.height * 0.5)


		local blockPic = string.format("Textures/Icon/Single/MapIcon/areamask_%s.png", self.unlockAreaId)
        CustomUnityUtils.SetMaterialPropertyAgentPlayingState(self.MapMaskForEffect, true)
		self.MapMaskForEffect.transform:SetParent(self.MapMask.transform)
		local callBackFunc = function()
			local sprite = self.MapMaskForEffect_img.sprite
            local mat = self.MapMaskForEffect_img.material
			UnityUtils.SetSizeDelata(self.MapMaskForEffect.transform, sprite.rect.width, sprite.rect.height)
			UnityUtils.SetLocalScale(self.MapMaskForEffect.transform, 4, 4, 4)
			UnityUtils.SetLocalPosition(self.MapMaskForEffect.transform, areaCfg.position_x, areaCfg.position_y, 0)

            mat.mainTexture = sprite.texture
            self.MapMaskForEffect_img.sprite = nil

            UnityUtils.SetActive(self.MapMaskForEffect, true)
            CustomUnityUtils.SetMatPropertyAgentValue(self.MapMaskForEffect, "_DissolveControl")

            local timerFunc = function ()
                self.MapMaskForEffect_anim.enabled = true
                UnityUtils.SetActive(self.MaskEffectNode, true)
            end
            LuaTimerManager.Instance:AddTimer(1, 1, timerFunc)
		end

        if not self.MapMaskForEffect_anim then
            self.MapMaskForEffect_anim = self.MapMaskForEffect:GetComponent("Animator")
        end

        self.MapMaskForEffect_anim.enabled = false
		UnityUtils.SetLocalPosition(self.Content.transform, -width, -height, 0)
        UnityUtils.SetActive(self.MapMaskForEffect, false)
        CustomUnityUtils.SetImagePrimitiveMaterialTexture(self.MapMaskForEffect, blockPic)
		SingleIconLoader.Load(self.MapMaskForEffect, blockPic, callBackFunc)
	end
end

function WorldMapWindow:LoadMap()
    local mapCfg = mod.WorldMapCtrl:GetMapConfig(self.mapId)
    UnityUtils.SetSizeDelata(self.Content.transform, mapCfg.width, mapCfg.length)
    UnityUtils.SetSizeDelata(self.Map.transform, mapCfg.width, mapCfg.length)
    self.minScale = Screen.width / mapCfg.width
    if self.unlockAreaId then
        self.mapScale = self.minScale
    end

    local uiSize = mod.WorldMapCtrl:GetUISize(self.mapId)
    for i = 1, uiSize.areaBlock do
        local blockPic = string.format("%s%s.png", mapCfg.icon, i)
        local blockObj = self:GetMapBlockObj()
        local callBackFunc = function()
            local widthBlock = (i % uiSize.widthBlock) == 0 and uiSize.widthBlock - 1 or (i % uiSize.widthBlock) - 1
            local lengthBlock = (i % uiSize.lengthBlock) == 0 and (uiSize.lengthBlock - (i / uiSize.lengthBlock)) or (uiSize.lengthBlock - math.floor(i / uiSize.lengthBlock)) - 1
            UnityUtils.SetLocalPosition(blockObj.objectTransform, widthBlock * 2048, lengthBlock * 2048, 0)
            blockObj.object:SetActive(true)
            blockObj.object.name = "map_"..i

            if i == uiSize.areaBlock then
                UnityUtils.SetLocalScale(self.Content.transform, self.mapScale, self.mapScale, self.mapScale)
            end

            table.insert(self.mapBlockOnShow, blockObj)
        end

        SingleIconLoader.Load(blockObj.object, blockPic, callBackFunc)
    end
end

function WorldMapWindow:GetMapBlockObj()
    if next(self.mapObjPool) then
        return table.remove(self.mapObjPool)
    end

    local obj =  self:PopUITmpObject("MapBlockTemp")
    obj = UtilsUI.GetContainerObject(obj.objectTransform, obj)
    obj.objectTransform:SetParent(self.Map.transform)

    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)

    return obj
end

function WorldMapWindow:GetMapMaskObj()
    if next(self.mapMaskPool) then
        return table.remove(self.mapMaskPool)
    end

    local obj = self:PopUITmpObject("MapMaskTemp")
    obj = UtilsUI.GetContainerObject(obj.objectTransform, obj)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)

    return obj
end

-- TODO 优化 重复代码
-- TODO 遮罩比例要按照当前地图分辨率大小来算
function WorldMapWindow:LoadMapMask()
    local lockArea = Fight.Instance.mapAreaManager:GetLockMidArea()
    for k, v in pairs(lockArea) do
        local blockPic = string.format("Textures/Icon/Single/MapIcon/areamask_%s.png", v.id)
        local blockObj = self:GetMapMaskObj()
        blockObj.objectTransform:SetParent(self.MapMask.transform)
        local callBackFunc = function()
            local sprite = blockObj.MapMaskTemp_img.sprite
            UnityUtils.SetSizeDelata(blockObj.objectTransform, sprite.rect.width, sprite.rect.height)
            UnityUtils.SetLocalScale(blockObj.objectTransform, 4, 4, 4)
            UnityUtils.SetLocalPosition(blockObj.objectTransform, v.position_x, v.position_y, 0)
            blockObj.object:SetActive(true)
            blockObj.object.name = "map_mask_"..k
        end

        SingleIconLoader.Load(blockObj.object, blockPic, callBackFunc)

        table.insert(self.mapMaskOnShow, blockObj)
    end

    -- local blockArea = Fight.Instance.mapAreaManager:GetBlockArea()
    -- for k, v in pairs(blockArea) do
    --     local blockPic = string.format("Textures/Icon/Single/MapIcon/areamask_%s.png", v.id)
    --     local blockObj = self:GetMapMaskObj()
    --     blockObj.objectTransform:SetParent(self.MapBlock.transform)
    --     local callBackFunc = function()
    --         local sprite = blockObj.MapMaskTemp_img.sprite
    --         UnityUtils.SetSizeDelata(blockObj.objectTransform, sprite.rect.width, sprite.rect.height)
    --         UnityUtils.SetLocalScale(blockObj.objectTransform, 4, 4, 4)
    --         UnityUtils.SetLocalPosition(blockObj.objectTransform, v.position_x, v.position_y, 0)
    --         blockObj.object:SetActive(true)
    --         blockObj.object.name = "map_block_"..v.id
    --     end

    --     SingleIconLoader.Load(blockObj.object, blockPic, callBackFunc)

    --     table.insert(self.mapMaskOnShow, blockObj)
    -- end
end

function WorldMapWindow:LoadMark()
    local marks = mod.WorldMapCtrl:GetMapMark(self.mapId)
    for k, v in pairs(marks) do
        for instanceId, _ in pairs(v) do
            self:AddMark(instanceId)
        end
    end

    if self.forceShowMark and self.marksOnShow[self.forceShowMark] then
        local mark = self.marksOnShow[self.forceShowMark].config
        local posX = mark.posX
        local posY = mark.posY
        if mark.ecoCfg and Fight.Instance.entityManager.ecosystemEntityManager:IsMercenaryEntity(mark.ecoCfg.id) then
            local mercenaryCtrl = Fight.Instance.mercenaryHuntManager:GetMercenaryCtrl(mark.ecoCfg.id)
            if not mercenaryCtrl then
                return
            end

            local position = mercenaryCtrl:GetPosition()
            posX, posY = mod.WorldMapCtrl:TransWorldPosToUIPos(position.x, position.z, mark.map)
        end

        local width = (posX * self.mapScale) - (self.MapScrollView_rect.rect.width * 0.5)
        local height = (posY * self.mapScale) + (self.MapScrollView_rect.rect.height * 0.5)
        UnityUtils.SetLocalPosition(self.Content.transform, -width, -height, 0)

        self.selectedMark = self.forceShowMark
        self.marksOnShow[self.forceShowMark]:SetSelect(true, 1)
        self:OnClick_MarkInfo(self.selectedMark)

        self.forceShowMark = nil
    end
end

function WorldMapWindow:AddMark(markInstance, isSelected)
    local mark = mod.WorldMapCtrl:GetMark(markInstance)
    if not mark or mod.WorldMapCtrl:CheckMarkIsHide(markInstance) then
        if self.marksOnShow[markInstance] then
            self.marksOnShow[markInstance]:CloseMark()
        end

        return
    end

    local scalePrecent = 1 - ((self.maxScale - self.mapScale) / (self.maxScale - self.minScale))
    local value = math.ceil(scalePrecent * 6) > 0 and math.ceil(scalePrecent * 6) or 1
    if self.marksOnShow[markInstance] then
        if mark.type == FightEnum.MapMarkType.Ecosystem then
            local show_scale = mark.jumpCfg.show_scale
            if show_scale[1] <= value and show_scale[2] >= value then
                self.marksOnShow[markInstance]:RefreshMapMark()
                UnityUtils.SetActive(self.marksOnShow[markInstance].obj.object, true)
            end
        elseif mark.type == FightEnum.MapMarkType.Player then
            self:RefreshPlayerMark(self.marksOnShow[markInstance], mark)
        elseif mark.showScale > value then
            self.marksOnShow[markInstance]:RefreshMapMark()
            UnityUtils.SetActive(self.marksOnShow[markInstance].obj.object, true)
        end

        return
    end

    local commonMark = self:GetCommonMark(mark)
    commonMark:SetSelect(isSelected, 1)
    if mark.type == FightEnum.MapMarkType.Ecosystem then
        commonMark.obj.object.name = "Eco_"..mark.ecoCfg.id
    elseif mark.type == FightEnum.MapMarkType.Task then
        commonMark.obj.object.name = string.format("Task_%s_%s", mark.taskId, mark.progressId)
    else
        commonMark.obj.object.name = "CommonMapMark"
    end

    self.marksOnShow[markInstance] = commonMark

    if mark.isPlayer then
        self:RefreshPlayerMark(commonMark, mark)
    end
end

function WorldMapWindow:RefreshPlayerMark(commonMark, mark)
    local transformComponent = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject().transformComponent
    local playerPos = transformComponent:GetPosition()
    local playerRot = transformComponent:GetRotation():ToEulerAngles()
    local posX, posY = mod.WorldMapCtrl:TransWorldPosToUIPos(playerPos.x, playerPos.z, mark.map)
    commonMark:SetPosition(Vec3.New(posX, posY, 0))
    commonMark:SetRotation(-playerRot.y)

    if not self.forceShowMark and not self.unlockAreaId then
        local width = (posX * self.mapScale) - (self.MapScrollView_rect.rect.width * 0.5)
        local height = (posY * self.mapScale) + (self.MapScrollView_rect.rect.height * 0.5)
        UnityUtils.SetLocalPosition(self.Content.transform, -width, -height, 0)
    end
end

function WorldMapWindow:LoadMapAreaName()
    local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    if not entity then
        return
    end

    local curAreaId = entity.values["mAreaId"]
    UnityUtils.SetActive(self.MapName, curAreaId ~= nil)
    if curAreaId then
        local curAreaInfo = Fight.Instance.mapAreaManager:GetAreaConfig(curAreaId)
        self.MapName_txt.text = curAreaInfo.name
    end

    local scalePrecent = 1 - ((self.maxScale - self.mapScale) / (self.maxScale - self.minScale))
    local value = math.ceil(scalePrecent * 6) > 0 and math.ceil(scalePrecent * 6) or 1
    local mCenter, sCenter = Fight.Instance.mapAreaManager:GetAreaCenter_All()
    local isShowMid = 1 <= value and value <= 2
    for k, v in pairs(mCenter) do
        local posX, posY = mod.WorldMapCtrl:TransWorldPosToUIPos(v.x, v.y, self.mapId)
        local obj = self:GetMapAreaNameObj()
        obj.objectTransform:SetParent(self.MidAreaName.transform)
        obj.MapAreaInfoTemp_txt.text = Fight.Instance.mapAreaManager:GetAreaConfig(k).name

        UnityUtils.SetLocalPosition(obj.objectTransform, posX, posY, 0)
        UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
        UnityUtils.SetActive(obj.object, isShowMid)

        table.insert(self.midAreaNames, obj)
    end

    for k, v in pairs(sCenter) do
        local posX, posY = mod.WorldMapCtrl:TransWorldPosToUIPos(v.x, v.y, self.mapId)
        local obj = self:GetMapAreaNameObj()
        obj.objectTransform:SetParent(self.SmallAreaName.transform)
        obj.MapAreaInfoTemp_txt.text = Fight.Instance.mapAreaManager:GetAreaConfig(k).name
        UnityUtils.SetLocalPosition(obj.objectTransform, posX, posY, 0)
        UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
        UnityUtils.SetActive(obj.object, not isShowMid)

        table.insert(self.smallAreaNames, obj)
    end
end

function WorldMapWindow:ShowMercenaryBar()
    self.alertValue = mod.MercenaryHuntCtrl:GetAlertVal()
    self.mainId = mod.MercenaryHuntCtrl:GetMainId()
    local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.ShiMaiLieShou)
	UtilsUI.SetActive(self.MercenaryBar,isOpen)
	if isOpen and self.mainId > 0 then
		self:InitMercenaryBar()
		self:UpdateMercenaryCost()
	end
end

function WorldMapWindow:InitMercenaryBar()
    if self.hunterProgressBar == nil then
        self.hunterProgressBar = Fight.Instance.objectPool:Get(HunterProgressBar)
        self.hunterProgressBar:init(self.HunterProgress)
    end
end

function WorldMapWindow:UpdateMercenaryCost()
    local cost = MercenaryHuntConfig.GetCostListByIdAndAlertVal(self.mainId,self.alertValue)
    if cost[1] == nil then
        UtilsUI.SetActive(self.PayBtn,false)
        UtilsUI.SetActive(self.Cost,false)
        return
    end
    UtilsUI.SetActive(self.PayBtn,true)
    UtilsUI.SetActive(self.Cost,true)
    SingleIconLoader.Load(self.CostIcon, ItemConfig.GetItemIcon(cost[1]))
    self.CostCount_txt.color = BagCtrl:GetItemCountById(cost[1]) >= cost[2] and Color(0.23,0.23,0.28) or Color(1,0.37,0.29)
    self.CostCount_txt.text = cost[2]    
end

function WorldMapWindow:OnMarkUpdate(markOpera, markInstance)
    if not self.active then
        return
    end

    if markOpera == WorldEnum.MarkOpera.Add then
        self:AddMark(markInstance)
    elseif markOpera == WorldEnum.MarkOpera.Refresh then
        self.marksOnShow[markInstance]:RefreshMapMark()
        UnityUtils.SetActive(self.marksOnShow[markInstance].obj.object, true)
    elseif markOpera == WorldEnum.MarkOpera.Remove then
        self.marksOnShow[markInstance]:CloseMark()
    end
end

function WorldMapWindow:RemoveMarkCallBack(instanceId)
    if not instanceId then
        return
    end

    if self.selectedMark and self.selectedMark == instanceId then
        self.selectedMark = nil
    end

    local commonMark = self.marksOnShow[instanceId]
    table.insert(self.markObjPool, commonMark)
    self.marksOnShow[instanceId] = nil
end

function WorldMapWindow:RefreshMarkSelect(isShow, selectList)
    if isShow then
        self.MarkSelect:SetActive(true)
    else
        self.MarkSelectExitNode:SetActive(true)
    end

    for i = 1, #self.selectionOnShow do
        local obj = table.remove(self.selectionOnShow)
        obj.object:SetActive(false)
        table.insert(self.selectObjPool, obj)
    end

    if isShow then
        for i = 1, #selectList do
            local mark = mod.WorldMapCtrl:GetMark(selectList[i])
            local selectObj = self:GetSelectObj()
            local icon = self:GetMarkIcon(mark)

            selectObj.object:SetActive(true)
            SingleIconLoader.Load(selectObj.MarkIcon, icon)
            selectObj.MarkName_txt.text = mark.name and mark.name or "标记"

            local onClickFunc = function ()
                self:RefreshMarkSelect(false)
                if self.selectedMark and self.selectedMark ~= selectList[i] then
                    self.marksOnShow[self.selectedMark]:SetSelect(false)
                    self.selectedMark = selectList[i]
                    self.marksOnShow[self.selectedMark]:SetSelect(true, 1)
                elseif self.selectedMark then
                    self.marksOnShow[self.selectedMark]:SetSelect(false)
                    self.marksOnShow[self.selectedMark]:SetSelect(true, 1)
                end
                self:OnClick_MarkInfo(selectList[i])
            end
            selectObj.SelectBtn_btn.onClick:RemoveAllListeners()
            selectObj.SelectBtn_btn.onClick:AddListener(onClickFunc)
            table.insert(self.selectionOnShow, selectObj)
        end
    end

    if self.panelList["WorldMapInfoPanel"] and self.panelList["WorldMapInfoPanel"].active then
        self.panelList["WorldMapInfoPanel"]:HidePanel(true)
    end

    if self.panelList["MercenaryTipsPanel"] and self.panelList["MercenaryTipsPanel"].active then
        self.panelList["MercenaryTipsPanel"]:Hide()
    end
end

-- todo 临时 变化大小不用动效先
function WorldMapWindow:RefreshMapScale()
    local _, minPos, maxPos
    _, minPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.Content.transform, Vector2(0, 0), ctx.UICamera)
    _, maxPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.Content.transform, Vector2(Screen.width, Screen.height), ctx.UICamera)

    local centerPos = { x = (minPos.x + maxPos.x) * -0.5, y = (minPos.y + maxPos.y) * -0.5 }
    local width = (centerPos.x * self.mapScale) + (self.MapScrollView_rect.rect.width * 0.5)
    local height = (centerPos.y * self.mapScale) - (self.MapScrollView_rect.rect.height * 0.5)
    UnityUtils.SetLocalScale(self.Content.transform, self.mapScale, self.mapScale, self.mapScale)
    UnityUtils.SetLocalPosition(self.Content.transform, width, height)

    local changeScale = 1 / self.mapScale
    local scalePrecent = 1 - ((self.maxScale - self.mapScale) / (self.maxScale - self.minScale))
    local value = math.ceil(scalePrecent * 6) > 0 and math.ceil(scalePrecent * 6) or 1
    for _, commonMark in pairs(self.marksOnShow) do
        if commonMark.config.type == FightEnum.MapMarkType.Ecosystem then
            local show_scale = commonMark.config.jumpCfg.show_scale
            if show_scale[1] <= value and show_scale[2] >= value then
                commonMark:SetScale(changeScale)
                UnityUtils.SetActive(commonMark.obj.object, true)
            else
                UnityUtils.SetActive(commonMark.obj.object, false)
            end
        else
            local scale = commonMark.config.showScale
            if scale <= value then
                commonMark:SetScale(changeScale)
                UnityUtils.SetActive(commonMark.obj.object, true)
            else
                UnityUtils.SetActive(commonMark.obj.object, false)
            end
        end
    end

    if self.tempCustomMark then
        self.tempCustomMark:SetScale(changeScale)
    end

    local isShowMid = 1 <= value and value <= 2
    for k, v in pairs(self.midAreaNames) do
        UnityUtils.SetActive(v.object, isShowMid)
        if isShowMid then
            UnityUtils.SetLocalScale(v.objectTransform, changeScale, changeScale, changeScale)
        end
    end

    for k, v in pairs(self.smallAreaNames) do
        UnityUtils.SetActive(v.object, not isShowMid)
        if not isShowMid then
            UnityUtils.SetLocalScale(v.objectTransform, changeScale, changeScale, changeScale)
        end
    end
end

function WorldMapWindow:RefreshTraceMark()
    local minEdgeX = -(self.MapScrollView_rect.rect.width * 0.5) + 52
    local maxEdgeX = (self.MapScrollView_rect.rect.width * 0.5) - 52
    local minEdgeY = -(self.MapScrollView_rect.rect.height * 0.5) + 52
    local maxEdgeY = (self.MapScrollView_rect.rect.height * 0.5) - 52

    local _, minPos, maxPos
    _, minPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.Content.transform, Vector2(0, 0), ctx.UICamera)
    _, maxPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.Content.transform, Vector2(Screen.width, Screen.height), ctx.UICamera)

    -- TODO 优化成traceList
    local mark = {}
    for _, v in pairs(self.marksOnShow) do
        mark = v.config
        if mark.inTrace then
            local xOut = mark.posX < minPos.x or mark.posX > maxPos.x
            local yOut = mark.posY < minPos.y or mark.posY > maxPos.y
            local traceObj = self.traceObjList[mark.instanceId]
            if not self.traceObjList[mark.instanceId] then
                traceObj = self:GetTraceObj()
                self.traceObjList[mark.instanceId] = traceObj
                SingleIconLoader.Load(traceObj.TraceIcon, self:GetMarkIcon(mark))

                local onclickFunc = function ()
                    if self.mapMoveSequence then
                        self.mapMoveSequence:Kill()
                        self.mapMoveSequence = nil
                    end

                    self.mapMoveSequence = DOTween.Sequence()
                    local width = (traceObj.tracePos.x * self.mapScale) - (self.MapScrollView_rect.rect.width * 0.5)
                    local height = (traceObj.tracePos.y * self.mapScale) + (self.MapScrollView_rect.rect.height * 0.5)
                    local targetPos = Vector3(-width, -height, 0)
                    local tween = self.Content.transform:DOLocalMove(targetPos, 0.5, true)
                    self.mapMoveSequence:Append(tween)
                end
                traceObj.Circle_btn.onClick:RemoveAllListeners()
                traceObj.Circle_btn.onClick:AddListener(onclickFunc)
            end

            traceObj.object:SetActive(xOut or yOut)
            if xOut or yOut then
                local centerPos = Vector2((maxPos.x + minPos.x) * 0.5, (maxPos.y + minPos.y) * 0.5)
                local tracePos = Vector2(mark.posX, mark.posY)
                local offsetVector = centerPos - tracePos
                local angle = Vector2.SignedAngle(Vector2.up, offsetVector.normalized)

                traceObj.tracePos = tracePos

                local tracePosX = minEdgeX
                local tracePosY = minEdgeY
                if mark.posX > minPos.x then
                    if mark.posX > maxPos.x then
                        tracePosX = maxEdgeX
                    else
                        local percent = ((mark.posX - minPos.x) / (maxPos.x - minPos.x)) - 0.5
                        local tempPosX = self.MapScrollView_rect.rect.width * percent
                        tracePosX = (self.MapScrollView_rect.rect.width * 0.5) - math.abs(tempPosX) > 52 and tempPosX or (percent < 0 and minEdgeX or maxEdgeX)
                    end
                end

                if mark.posY > minPos.y then
                    if mark.posY > maxPos.y then
                        tracePosY = maxEdgeY
                    else
                        local percent = ((mark.posY - minPos.y) / (maxPos.y - minPos.y)) - 0.5
                        local tempPosY = self.MapScrollView_rect.rect.height * percent
                        tracePosY = (self.MapScrollView_rect.rect.height * 0.5) - math.abs(tempPosY) > 52 and tempPosY or (percent < 0 and minEdgeY or maxEdgeY)
                    end
                end

                UnityUtils.SetLocalPosition(traceObj.objectTransform, tracePosX, tracePosY, 0)
                UnityUtils.SetEulerAngles(traceObj.Circle.transform, 0, 0, 180 + angle)
            end
        end
    end
end

function WorldMapWindow:OnMarkTraceCancel(instanceId)
    local traceObj = self.traceObjList[instanceId]
    if not traceObj then
        return
    end

    self.traceObjList[instanceId] = nil
    UnityUtils.SetActive(traceObj.object, false)
    table.insert(self.traceObjPool, traceObj)
end

function WorldMapWindow:HideSelectedMark(isTempCustom)
	if isTempCustom or not self.selectedMark then
		return
	end

    self.marksOnShow[self.selectedMark]:SetSelect(false)
    if self.selectedOnShow and next(self.selectedOnShow) then
        self.marksOnShow[self.selectedMark]:SetSelect(true, 2)
    else
        self.selectedMark = nil
    end
end

function WorldMapWindow:ShowCloseNode()
    self.CloseShowNode:SetActive(true)
end

--#region 响应事件
function WorldMapWindow:OnClick_MarkInfo(markInstance)
    local mark = mod.WorldMapCtrl:GetMark(markInstance)
    if mark.ecoCfg and Fight.Instance.entityManager.ecosystemEntityManager:IsMercenaryEntity(mark.ecoCfg.id) then
        if self.panelList["WorldMapInfoPanel"] and self.panelList["WorldMapInfoPanel"].active then
            self.panelList["WorldMapInfoPanel"]:HidePanel()
        end
        local hunterInfo = mod.MercenaryHuntCtrl:GetMercenaryData(mark.ecoCfg.id)
        self:OpenPanel(MercenaryTipsPanel, {openType = 1, hunterInfo = hunterInfo}, UIDefine.CacheMode.hide)
        return
    end

    if self.panelList["MercenaryTipsPanel"] and self.panelList["MercenaryTipsPanel"].active then
        self.panelList["MercenaryTipsPanel"]:Hide()
    end

    if self.panelList["WorldMapInfoPanel"] and self.panelList["WorldMapInfoPanel"].active then
        self.panelList["WorldMapInfoPanel"]:UpdateInfo(self.mapId, markInstance)
    else
        self.CloseBtnNode:SetActive(true)
        self:OpenPanel(WorldMapInfoPanel, { false, self.mapId, markInstance })
    end
end

function WorldMapWindow:OnClick_AddTempMark(hitPos)
    if not self.tempCustomMark then
        self.tempCustomMark = self:GetCommonMark()
    end

    local position = Vec3.New(hitPos.x, hitPos.y, 0)
    UnityUtils.SetActive(self.tempCustomMark.obj.object, true)
    self.tempCustomMark:SetPosition(position)
    self.tempCustomMark:SetMarkIcon("Textures/Icon/Single/MapIcon/mark.png")
    self.tempCustomMark:SetSelect(true, 1)

    if self.panelList["MercenaryTipsPanel"] and self.panelList["MercenaryTipsPanel"].active then
        self.panelList["MercenaryTipsPanel"]:Hide()
    end

    if self.panelList["WorldMapInfoPanel"] and self.panelList["WorldMapInfoPanel"].active then
        self.panelList["WorldMapInfoPanel"]:SetTempCustomMarkInfo(hitPos.x, hitPos.y, FightEnum.MapMarkCustomType.None, self.mapId)
    else
        self.CloseBtnNode:SetActive(true)
        self:OpenPanel(WorldMapInfoPanel, {true, hitPos.x, hitPos.y, FightEnum.MapMarkCustomType.None, self.mapId})
    end
end

function WorldMapWindow:OnClick_RemoveTempMark()
    if not self.tempCustomMark then
        return
    end

    local mark = self.tempCustomMark
    self.tempCustomMark = nil
    mark:CloseMark()
end

function WorldMapWindow:ChangeTempCustomMarkType(type)
    if not self.tempCustomMark then
        return
    end

    self.tempCustomMark:SetMarkIcon("Textures/Icon/Single/MapIcon/mark.png")
end

function WorldMapWindow:OnClick_CloseBtn()
    for k, v in pairs(self.marksOnShow) do
        v:CloseMark()
    end
end

function WorldMapWindow:OnClick_PayBtn()
    local cost = MercenaryHuntConfig.GetCostListByIdAndAlertVal(self.mainId,self.alertValue)
    local itemConfig = ItemConfig.GetItemConfig(cost[1])
    if BagCtrl:GetItemCountById(cost[1]) < cost[2] then
        MsgBoxManager.Instance:ShowTips( itemConfig.name .. "不足")
    else
        mod.MercenaryHuntFacade:SendMsg("mercenary_clean_alert_value")
    end
end

function WorldMapWindow:CloseNodeCallBack()
    WindowManager.Instance:CloseWindow(self)
end

function WorldMapWindow:EntryAniCallBack()
    self.Map.transform:SetParent(self.Content.transform)
    self.Map.transform:SetAsFirstSibling()
    UnityUtils.SetLocalPosition(self.Map.transform, 0, 0, 0)
	UnityUtils.SetLocalScale(self.Map.transform, 1, 1, 1)
end

function WorldMapWindow:MarkSelectExitNodeCallBack()
    self.MarkSelect:SetActive(false)
end

function WorldMapWindow:OnClick_MarkSelectBtn()
    if not self.selectedMark then
        return
    end

    self.marksOnShow[self.selectedMark]:SetSelect(false)
    self.selectedMark = nil
    self:RefreshMarkSelect(false)
end

function WorldMapWindow:OnValueChange(value)
    self:OnTouchEvent(false, value)
end

function WorldMapWindow:OnValueChange_Scale(value)
    self.mapScale = self.maxScale - ((self.maxScale - self.minScale) * (1 - value))
    self:RefreshMapScale()
    self:RefreshTraceMark()
end
--#endregion

--#region 获取资源 资源池管理
function WorldMapWindow:GetMarkIcon(mark)
    if mark.type == FightEnum.MapMarkType.Ecosystem then
        local ecoCfg = mark.ecoCfg
        local jumpCfg = mark.jumpCfg
        local icon = jumpCfg.icon
        if ecoCfg.is_transport and not mod.WorldCtrl:CheckIsTransportPointActive(ecoCfg.id) then
            local tempStr = string.sub(icon, 1, string.len(icon) - 4)
            tempStr = tempStr .. "_lock.png"
            icon = tempStr
        end

        return icon
    else
        return mark.icon
    end
end

function WorldMapWindow:GetCommonMark(mark)
    local changeScale = 1 / self.mapScale
    local parentTrans = self.CommonMark.transform
    if mark and mark.isPlayer then
        parentTrans = self.PlayerMark.transform
    elseif mark and mark.type == FightEnum.MapMarkType.Task then
        parentTrans = self.TaskMark.transform
    elseif mark and mark.type == FightEnum.MapMarkType.Ecosystem then
        local isTransport = Fight.Instance.entityManager.ecosystemEntityManager:CheckEcoEntityType(mark.ecoCfg.id, FightEnum.EcoEntityType.Transport)
        if isTransport then
            local transportCfg = Config.DataMap.data_map_transport[mark.ecoCfg.id]
            if transportCfg.mid_area ~= 0 or mod.WorldCtrl:CheckIsTransportPointActive(mark.ecoCfg.id) then
                parentTrans = self.TransportMark.transform
            end
        end
    end
    if next(self.markObjPool) then
        local commonMark = table.remove(self.markObjPool)
        if mark then
            commonMark:InitMapMark(mark, changeScale, self:ToFunc("RemoveMarkCallBack"))
            commonMark:SetParent(parentTrans)
            UnityUtils.SetActive(commonMark.obj.object, true)
        end
        return commonMark
    end

    local commonMark = CommonMapMark.New(self:PopUITmpObject("CommonMapMark"), parentTrans, changeScale, self.canvas.sortingOrder)
    commonMark:InitSelectLayer(self.canvas.sortingOrder + 1)
    if mark then
        commonMark:InitMapMark(mark, changeScale, self:ToFunc("RemoveMarkCallBack"))
        UnityUtils.SetActive(commonMark.obj.object, true)
    end

    return commonMark
end

function WorldMapWindow:GetTraceObj()
    if next(self.traceObjPool) then
        return table.remove(self.traceObjPool)
    end

    local obj = self:PopUITmpObject("TraceTemp")
    obj = UtilsUI.GetContainerObject(obj.objectTransform, obj)

    obj.objectTransform:SetParent(self.TraceNode.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)

    return obj
end

function WorldMapWindow:GetMapAreaNameObj()
    if next(self.mapAreaNameObjPool) then
        return table.remove(self.mapAreaNameObjPool)
    end

    local obj = self:PopUITmpObject("MapAreaInfoTemp")
    obj = UtilsUI.GetContainerObject(obj.objectTransform, obj)

    return obj
end

function WorldMapWindow:GetSelectObj()
    if next(self.selectObjPool) then
        return table.remove(self.selectObjPool)
    end

    local obj = self:PopUITmpObject("SelectTemp")
    obj = UtilsUI.GetContainerObject(obj.objectTransform, obj)

    obj.objectTransform:SetParent(self.MarkSelectPos.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)

    return obj
end
--#endregion

function WorldMapWindow:CheckIsNeedChangeIcon(originMark, newMark)
    if originMark.ecoId ~= newMark.ecoId then
        return true
    end

    if originMark.type == FightEnum.MapMarkType.Transport then
        local newActive = mod.WorldCtrl:CheckIsTransportPointActive(newMark.ecoId)
        return newActive ~= originMark.isActive
    end

    return false
end

function WorldMapWindow:__Hide()
    if self.selectedMark then
        self.marksOnShow[self.selectedMark]:SetSelect(false)
        self.selectedMark = nil
    end

    self.Map.transform:SetParent(self.Map_ani.transform)
    if self.panelList["WorldMapInfoPanel"] then
        self.panelList["WorldMapInfoPanel"]:Hide()
    end

    if self.panelList["MercenaryTipsPanel"] then
        self.panelList["MercenaryTipsPanel"]:Hide()
    end

    for i = #self.mapBlockOnShow, 1, -1 do
        local temp = table.remove(self.mapBlockOnShow)
        UnityUtils.SetActive(temp.object, false)
        table.insert(self.mapObjPool, temp)
    end

    for i = #self.mapMaskOnShow, 1, -1 do
        local temp = table.remove(self.mapMaskOnShow)
        UnityUtils.SetActive(temp.object, false)
        table.insert(self.mapMaskPool, temp)
    end

    for i = #self.midAreaNames, 1, -1 do
        local temp = table.remove(self.midAreaNames)
        UnityUtils.SetActive(temp.object, false)
        table.insert(self.mapAreaNameObjPool, temp)
    end

    for i = #self.smallAreaNames, 1, -1 do
        local temp = table.remove(self.smallAreaNames)
        UnityUtils.SetActive(temp.object, false)
        table.insert(self.mapAreaNameObjPool, temp)
    end

	self.args = nil
    self.forceShowMark = nil
    self.unlockAreaId = nil
    UnityUtils.SetActive(self.MapMaskForEffect, false)
end

function WorldMapWindow:__delete()
    EventMgr.Instance:RemoveListener(EventName.MarkUpdate, self:ToFunc("OnMarkUpdate"))
    EventMgr.Instance:RemoveListener(EventName.AlertValueUpdate, self:ToFunc("ShowMercenaryBar"))
end

function WorldMapWindow:OnTouchEvent(isRelease, distance)
    if isRelease then
        self.isTouchEvent = false
        self.initDistance = 0
        self.mapScrollRect.content = self.Content_rect
        return
    end

    self.isTouchEvent = true
    if self.initDistance == 0 then
        self.initDistance = distance
        self.touchValue = self.scalingBar.value
    end

    local diff = self.initDistance - distance
    if math.abs(diff) <= 5 then
        return
    end

    diff = diff < 0 and diff + 5 or diff - 5
    local value = MathX.Clamp(self.touchValue - (diff * 0.005), 0, 1)
    self:OnValueChange_Scale(value)
    self.scalingBar.value = value
    self.mapScrollRect.content = nil
end