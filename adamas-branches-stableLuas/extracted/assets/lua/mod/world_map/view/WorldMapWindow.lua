WorldMapWindow = BaseClass("WorldMapWindow", BaseWindow)

local MapArea = Config.DataMap.data_map_area
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
    self.traceObjList = {}

    -- 地图标记
    self.markObjPool = {}
    self.marksOnShow = {}

    self.selectedMark = nil

    self.smallAreaNames = {}
    self.midAreaNames = {}
    self.midAreaBoundsLine = {}

    self.tempCustomMark = nil

    self.isTouchEvent = false
    self.initDistance = 0

    self.scalingDragBehavior = nil

    self.switchList = {}

    -- 地图初始化展示位置和回调
    self.initPosX = nil
    self.initPosY = nil
    self.initPosCB = nil

    self.openMouseScroll = true -- 是否开启鼠标滚动缩放

    self.areaOnShow = {}
    self.areaObjPool = {}
end

function WorldMapWindow:__BindListener()
    -- 组件获取
    self.scalingBar = self.Scroller:GetComponent(Scrollbar)
    self.mapScrollRect = self.MapScrollView:GetComponent(ScrollRect)
    self.mapDragBehavior = self.MapScrollView:GetComponent(UIDragBehaviour)
    self.markSelectedCanvas = self.MarkSelect:GetComponent(Canvas)

    InputManager.Instance:SetTouchAction(self:ToFunc("OnTouchEvent"))

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
    self.AreaChangeCover_out_hcb.HideAction:AddListener(self:ToFunc("AreaChangeCoverOutCallBack"))

    self.ciityEvolutionJumpBtn_btn.onClick:AddListener(self:ToFunc("OnJumpToRogueCityEvolution"))
    self.ChooseBtn_btn.onClick:AddListener(self:ToFunc("OnChooseRogueInfoPanel"))

    self:SettingBtnBind()

    EventMgr.Instance:AddListener(EventName.MarkUpdate, self:ToFunc("OnMarkUpdate"))
    EventMgr.Instance:AddListener(EventName.CancelMapMarkTrace, self:ToFunc("OnMarkTraceCancel"))
    EventMgr.Instance:AddListener(EventName.ShopListUpdate, self:ToFunc("OnShopListUpdate"))
    EventMgr.Instance:AddListener(EventName.AlertValueUpdate, self:ToFunc("ShowMercenaryBar"))
    EventMgr.Instance:AddListener(EventName.WorldMapCtrlEntityLoadDone, self:ToFunc("ShowMap"))
    EventMgr.Instance:AddListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
    -- EventMgr.Instance:AddListener(EventName.ShowLevelOnMap, self:ToFunc("ShowLevelOnMap"))
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
                    elseif mark.type == FightEnum.MapMarkType.Event then
                        local show_scale = mark.jumpCfg.show_scale
                        if show_scale[1] > value or show_scale[2] < value then
                            canInsert = false
                        end
                    elseif mark.type == FightEnum.MapMarkType.RoadPath or mark.type == FightEnum.MapMarkType.NavMeshPath then
                        canInsert = false
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

    self.mapScrollRect.onValueChanged:AddListener(self:ToFunc("MapScrollRectValueChange"))
end

function WorldMapWindow:SettingBtnBind()
    self.SettingBtn_btn.onClick:AddListener(self:ToFunc("OnClick_SettingBtn"))
    self.CompletedChallengeSelectBtn_btn.onClick:AddListener(self:ToFunc("OnClick_CompletedChallengeSelectBtn"))
    self.FunctionStoreSelectBtn_btn.onClick:AddListener(self:ToFunc("OnClick_FunctionStoreSelectBtn"))
    self.CustomMaskSelectBtn_btn.onClick:AddListener(self:ToFunc("OnClick_CustomMaskSelectBtn"))
    self.MapSettingCloseBtn_btn.onClick:AddListener(self:ToFunc("OnClick_CloseSettingBtn"))
end

function WorldMapWindow:MapScrollRectValueChange()
    self:RefreshTraceMark()
    self:RefreshCenterPointer()
end

function WorldMapWindow:__Show()
    self.mapId = Fight.Instance:GetFightMap()
    self.ScreenWidth = UIDefine.canvasRoot.rect.width
    self.ScreenHeight = UIDefine.canvasRoot.rect.height

    if self.args then
        self.forceShowMark = self.args.mark
        self.unlockAreaId = self.args.unlockArea
    end

    if self.args and self.args.JumpMapId then
        self.mapId = self.args.JumpMapId
    end

    self:InitCurrencyBar()
    self:InitAreaChangeCover()
    self:LoadMapSwitch()
    self:LoadMap()
    self:LoadMapMask()
    self:LoadMark()
    self:LoadMapAreaName()
    self:LoadMapAreaBounds()
    self:LoadAllMapAreaOccupy()
    --self:ShowMapAreaBounds()
    self:ShowMercenaryBar()
    self:ShowFunc()

	-- 如果有解锁的区域 先移动到这里来
	if self.unlockAreaId then
		local areaMaskX, areaMaskY = Fight.Instance.mapAreaManager:GetAreaMaskPos(self.unlockAreaId, self.mapId)
        local edgeCfg = MapPositionConfig.GetAreaEdgeInfo(FightEnum.AreaType.Mid, self.unlockAreaId, self.mapId)
        local wPosX = (edgeCfg.minX + edgeCfg.maxX) / 2
        local wPosY = (edgeCfg.minY + edgeCfg.maxY) / 2
        local posX, posY = mod.WorldMapCtrl:TransWorldPosToUIPos(wPosX, wPosY, self.mapId)
		self.initPosX = (posX * self.mapScale) - (self.MapScrollView_rect.rect.width * 0.5)
        self.initPosy = (posY * self.mapScale) + (self.MapScrollView_rect.rect.height * 0.5)

		local blockPic = string.format("Textures/Icon/Single/MapIcon/areamask_%s_%s.png", self.unlockAreaId, self.mapId)
        CustomUnityUtils.SetMaterialPropertyAgentPlayingState(self.MapMaskForEffect, true)
		self.MapMaskForEffect.transform:SetParent(self.MapMask.transform)
		local callBackFunc = function()
			local sprite = self.MapMaskForEffect_img.sprite
            local mat = self.MapMaskForEffect_img.material
			UnityUtils.SetSizeDelata(self.MapMaskForEffect.transform, sprite.rect.width, sprite.rect.height)
			UnityUtils.SetLocalScale(self.MapMaskForEffect.transform, 4, 4, 4)
			UnityUtils.SetLocalPosition(self.MapMaskForEffect.transform, areaMaskX, areaMaskY, 0)

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
        local func = function()
            UnityUtils.SetActive(self.MapMaskForEffect, false)
            CustomUnityUtils.SetImagePrimitiveMaterialTexture(self.MapMaskForEffect, blockPic)
            SingleIconLoader.Load(self.MapMaskForEffect, blockPic, callBackFunc)
        end
        self.initPosCB = func
	end

    self:SetMapToInitPos()

    local value = 1 - ((self.maxScale - self.mapScale) / (self.maxScale - self.minScale))
    self.scalingBar.value = value
end

function WorldMapWindow:__RepeatShow()
    self:ShowFunc()
end

function WorldMapWindow:ShowFunc()
    if self.args and self.args.logicAreaId then
		local mCenter, sCenter = Fight.Instance.mapAreaManager:GetAreaCenter_All(self.mapId)
		local logicAreaConfig = RoguelikeConfig.GetWorldRougeAreaLogic(self.args.logicAreaId)
		if not mCenter then
			return
		end
        local mapCfg = Fight.Instance.mapAreaManager:GetAreaConfig(logicAreaConfig.map_id, self.mapId)
		local pos = mCenter[logicAreaConfig.map_id]
        --打开mapAreaInfoPanel
        self:OpenPanel(WorldMapAreaInfoPanel, {mapId = self.mapId, logicAreaId = self.args.logicAreaId, isShowRight = false})
		self:OnClickWorldMapToSetPos(mapCfg, pos)
    end
end

function WorldMapWindow:InitCurrencyBar()
	self.currencyBarClass = Fight.Instance.objectPool:Get(CurrencyBar)
	self.currencyBarClass:init(self.CurrencyBar, 5)
end

function WorldMapWindow:InitAreaChangeCover()
    --这里+2 比mark大1
    self.areaChangeCoverCanvas = self.AreaChangeCover:GetComponent(Canvas)
    self.areaChangeCoverCanvas.sortingOrder = self.canvas.sortingOrder + 2
end

function WorldMapWindow:ShowMap()
    if not self.active then
        return
    end

    self:ResetMapWindow()

    self:LoadMap()
    self:LoadMapMask()
    self:LoadMark()
    self:LoadMapAreaName()
    self:LoadMapAreaBounds()

    -- if self.isSelectMap then 
    --     self.isSelectMap = not self.isSelectMap
    --     UtilsUI.SetActive(self.UI_WorldMapWindow_qiehuan,false)
    --     UtilsUI.SetActive(self.UI_WorldMapWindow_qiehuan,true)
    -- end

    local value = 1 - ((self.maxScale - self.mapScale) / (self.maxScale - self.minScale))
    self.scalingBar.value = value
    self:RefreshMapScale()
end

function WorldMapWindow:LoadMapSwitch()
    local fullMapCfg = Config.DataMap.data_map_change
    for k, v in pairs(fullMapCfg) do
        if v.map_icon ~= "" and Fight.Instance.conditionManager:CheckConditionByConfig(v.map_condition) then
            local switchTemp = self:PopUITmpObject("SingleArea", self.AreaSelect.transform)
            UtilsUI.SetActiveByScale(switchTemp.object, true)
            local sIcon = string.format("%s_s.png", v.map_icon)
            local uIcon = string.format("%s_u.png", v.map_icon)

            SingleIconLoader.Load(switchTemp.SAreaIcon, sIcon)
            SingleIconLoader.Load(switchTemp.UAreaIcon, uIcon)

            UnityUtils.SetActive(switchTemp.SAreaIcon, v.map_id == self.mapId)
            UnityUtils.SetActive(switchTemp.UAreaIcon, v.map_id ~= self.mapId)
            UnityUtils.SetActive(switchTemp.SBack, v.map_id == self.mapId)
            UnityUtils.SetActive(switchTemp.UBack, v.map_id ~= self.mapId)
            UnityUtils.SetActive(switchTemp.Anchors, v.map_id == self.mapId)

            switchTemp.AreaName_txt.text = v.name
            self.switchList[v.map_id] = switchTemp
            local switchFunc = function()
                self:OnSwitchMap(v.map_id)
            end
            switchTemp.SwitchBtn_btn.onClick:AddListener(switchFunc)
        end
    end
    self:UpdateMapSwitch()
end

--追踪后刷新 
function WorldMapWindow:UpdateMapSwitch()
    if not self.switchList then
        return
    end
    
    local curMapId = mod.WorldMapCtrl:GetCurMap() --当前所在地图的id
    -- 任务追踪
    local taskGuidMarks = Fight.Instance.taskManager:GetGuideMarks() --任务追踪的markInstanceId
    local taskMark = mod.WorldMapCtrl:GetMark(taskGuidMarks)
    
    -- 地图追踪 
    local traceMarks = mod.WorldMapCtrl:GetTraceMarks()
    local mapTraceId
    for mark_instance, v in pairs(traceMarks) do
        mapTraceId = mark_instance
        break
    end
    

    for _mapId, _switchTemp in pairs(self.switchList) do
        if _mapId ~= curMapId then
            local markIcon
            if taskMark and _mapId == taskMark.map then
                --说明当前这个icon应该优先显示任务追踪
                markIcon = taskMark.icon
            elseif mapTraceId then 
                local mark = mod.WorldMapCtrl:GetMark(mapTraceId)
                if mark and mark.map == _mapId then
                    markIcon = mark and mark.icon or ""
                end
            end
            
            if markIcon and markIcon ~= "" then
                local func = function()
                    UnityUtils.SetActive(_switchTemp.AreaTaskIcon, true)
                end
                SingleIconLoader.Load(_switchTemp.AreaTaskIcon, markIcon, func)
            end
        end
    end
end

function WorldMapWindow:OnSwitchMap(mapId)
    if mapId == self.mapId then
        return
    end

    for k, v in pairs(self.switchList) do
        UnityUtils.SetActive(v.SAreaIcon, k == mapId)
        UnityUtils.SetActive(v.UAreaIcon, k ~= mapId)
        UnityUtils.SetActive(v.SBack, k == mapId)
        UnityUtils.SetActive(v.UBack, k ~= mapId)
    end

    self.mapId = mapId

    -- 标记切换地图，播放动效
    -- self.isSelectMap = true
    UtilsUI.SetActive(self.AreaChangeCover, true)

    -- 临时 后续要优化成通用的
    if mapId == 10020004 then
        self.AreaChangeCover_anim:Play("UI_AreaChangeCover_tianguicheng", 0, 0)
    else
        self.AreaChangeCover_anim:Play("UI_AreaChangeCover_dijiang", 0, 0)
    end

    if mod.WorldMapCtrl:CheckMapMarkInitDone(self.mapId) then
        self:ShowMap()
    else
        mod.WorldMapCtrl:InitMapMark(self.mapId)
    end
end

function WorldMapWindow:AreaChangeCoverOutCallBack()
    UtilsUI.SetActive(self.AreaChangeCover, false)
    --暂时先放这 后续需要规划一下层级，避免区域画线层级超出
    self:ShowMapAreaBounds()
end

function WorldMapWindow:LoadMap()
    local mapSceneCfg, mapCfg = mod.WorldMapCtrl:GetMapConfig(self.mapId)
    UnityUtils.SetSizeDelata(self.Content.transform, mapCfg.width, mapCfg.length)
    UnityUtils.SetSizeDelata(self.Map.transform, mapCfg.width, mapCfg.length)
    self.minScale = math.max(0.33, self.ScreenWidth/ mapCfg.width)
    -- 如果有解锁区域就放到最小
    if self.unlockAreaId or self.mapScale < self.minScale then
        self.mapScale = self.minScale
    end

    local uiSize = mod.WorldMapCtrl:GetUISize(self.mapId)
    for i = 1, uiSize.areaBlock do
        local blockPic = string.format("%s%s.png", mapCfg.icon, i)
        local blockObj = self:PopUITmpObject("MapBlockTemp", self.Map.transform)
        local callBackFunc = function()
            local widthBlock = (i % uiSize.widthBlock) == 0 and uiSize.widthBlock - 1 or (i % uiSize.widthBlock) - 1
            local lengthBlock = (i % uiSize.lengthBlock) == 0 and (uiSize.lengthBlock - (i / uiSize.lengthBlock)) or (uiSize.lengthBlock - math.floor(i / uiSize.lengthBlock)) - 1
            UnityUtils.SetLocalPosition(blockObj.objectTransform, widthBlock * 2048, lengthBlock * 2048, 0)
            blockObj.object:SetActive(true)
            blockObj.object.name = "map_"..i
            if i == uiSize.areaBlock then
                UnityUtils.SetLocalScale(self.Content.transform, self.mapScale, self.mapScale, self.mapScale)
            end
        end
        SingleIconLoader.Load(blockObj.object, blockPic, callBackFunc)
    end

    local transformComponent = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject().transformComponent
    local playerPos = transformComponent:GetPosition()
    local posX, posY = mod.WorldMapCtrl:TransWorldPosToUIPos(playerPos.x, playerPos.z, self.mapId)

    self.initPosX = (posX * self.mapScale) - (self.MapScrollView_rect.rect.width * 0.5)
    self.initPosY = (posY * self.mapScale) + (self.MapScrollView_rect.rect.height * 0.5)

    --刷新下城市rogue的进度
    --判断这个城市有没有rogue区域,有就显示
    self:UpdateRoguePanel()
end

function WorldMapWindow:UpdateRoguePanel()
    self.cityProgress:SetActive(false)
    --打开地图时check下Rogue有没有开启，开启则显示
    local isShowRogueProgress = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Rogue)
    if not isShowRogueProgress then
        return
    end

    local nowNum = 0
    local maxNum = 0
    local logicArea = mod.RoguelikeCtrl:GetAreaLogicMaps()
    for logicId, v in pairs(logicArea) do
        --获取每个区域的配置
        local logicConfig = RoguelikeConfig.GetWorldRougeAreaLogic(logicId)
        --位运算一下
        local key = UtilsBase.GetDoubleKeys(logicConfig.map_id, self.mapId)
        --如果有这个值则计算进度
        if MapArea[key] then
            --获取属于该地图的区域的进度值
            local progressAmount = mod.RoguelikeCtrl:GetAreaEventProgress(logicId)
            if progressAmount >= 1 then
                nowNum = nowNum + 1
            end
            maxNum = maxNum + 1
        end
    end
    
    if maxNum == 0 then --代表没有逻辑区域在该地图上
        return 
    end
    self.cityProgressText_txt.text = TI18N("隐患清除进度 ")..nowNum..'/'..maxNum

    self.cityProgress:SetActive(true)
end

-- TODO 优化 重复代码
-- TODO 遮罩比例要按照当前地图分辨率大小来算
function WorldMapWindow:LoadMapMask()
    local lockArea = Fight.Instance.mapAreaManager:GetLockMidArea()
    for k, v in pairs(lockArea) do
        if v.map_id ~= self.mapId then
            goto continue
        end

        local areaMaskX, areaMaskY = Fight.Instance.mapAreaManager:GetAreaMaskPos(v.id, self.mapId)
        local blockPic = string.format("Textures/Icon/Single/MapIcon/areamask_%s_%s.png", v.id, self.mapId)
        local blockObj = self:PopUITmpObject("MapMaskTemp", self.MapMask.transform)
        local callBackFunc = function()
            local sprite = blockObj.MapMaskTemp_img.sprite
            UnityUtils.SetSizeDelata(blockObj.objectTransform, sprite.rect.width, sprite.rect.height)
            UnityUtils.SetLocalScale(blockObj.objectTransform, 4, 4, 4)
            UnityUtils.SetLocalPosition(blockObj.objectTransform, areaMaskX, areaMaskY, 0)
            blockObj.object:SetActive(true)
            blockObj.object.name = "map_mask_"..k

            UnityUtils.SetSizeDelata(blockObj.wenli.transform, sprite.rect.width, sprite.rect.height)
            UnityUtils.SetSizeDelata(blockObj.wenlihei.transform, sprite.rect.width, sprite.rect.height)
            UnityUtils.SetSizeDelata(blockObj.wenliad.transform, sprite.rect.width, sprite.rect.height)

            CustomUnityUtils.ChangeUIEffectMaskTexture(blockObj.wenli, sprite, "DefaultMaterials/UI_WorldMapWindow_1")
            CustomUnityUtils.ChangeUIEffectMaskTexture(blockObj.wenlihei, sprite, "DefaultMaterials/UI_WorldMapWindow_3")
            CustomUnityUtils.ChangeUIEffectMaskTexture(blockObj.wenliad, sprite, "DefaultMaterials/UI_WorldMapWindow_2")
        end

        SingleIconLoader.Load(blockObj.object, blockPic, callBackFunc)
        ::continue::
    end

    -- TODO 封锁区域
end

function WorldMapWindow:LoadMark()
    local marks = mod.WorldMapCtrl:GetMapMark(self.mapId)
    if not marks or not next(marks) then
        return
    end

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

        self.initPosX = (posX * self.mapScale) - (self.MapScrollView_rect.rect.width * 0.5)
        self.initPosY = (posY * self.mapScale) + (self.MapScrollView_rect.rect.height * 0.5)

        local func = function()
            self.selectedMark = self.forceShowMark
            self.marksOnShow[self.forceShowMark]:SetSelect(true, 1)
            self:OnClick_MarkInfo(self.selectedMark)
        end
        self.forceShowMark = nil
        self.initPosCB = func
    end
end

function WorldMapWindow:AddMark(markInstance, isSelected)
    local mark = mod.WorldMapCtrl:GetMark(markInstance)
    if mark.type == FightEnum.MapMarkType.LevelEnemy then
        return
    end

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
                -- UnityUtils.SetActive(self.marksOnShow[markInstance].obj.object, true)
                self.marksOnShow[markInstance]:ShowMark()
            end
        elseif mark.type == FightEnum.MapMarkType.Player then
            self:RefreshPlayerMark(self.marksOnShow[markInstance], mark)
        elseif mark.showScale > value then
            self.marksOnShow[markInstance]:RefreshMapMark()
            -- UnityUtils.SetActive(self.marksOnShow[markInstance].obj.object, true)
            self.marksOnShow[markInstance]:ShowMark()
        end

        return
    end

    local commonMark = self:GetCommonMark(mark)
    if isSelected then
        commonMark:SetSelect(true, 1)
    end

    if mark.type == FightEnum.MapMarkType.Ecosystem then
        commonMark.obj.object.name = "Eco_"..mark.ecoCfg.id
    elseif mark.type == FightEnum.MapMarkType.Task then
        commonMark.obj.object.name = string.format("Task_%s_%s", mark.taskId, mark.stepId)
    elseif mark.type == FightEnum.MapMarkType.Event then
        commonMark.obj.object.name = string.format("Event_%s_%s", mark.map, mark.eventId)
    elseif mark.type == FightEnum.MapMarkType.LevelEvent then
        commonMark.obj.object.name = string.format("LevelEvent_%s_%s", mark.map, mark.levelEventId)
    elseif mark.type == FightEnum.MapMarkType.RoadPath then
        commonMark.obj.object.name = string.format("RoadPath_%s_%s_%s", mark.map, mark.mapNavPathInstanceId, mark.drawInstance)
        commonMark.obj.object:SetActive(true)
    elseif mark.type == FightEnum.MapMarkType.NavMeshPath then
        commonMark.obj.object.name = string.format("NavMeshPath_%s_%s_%s", mark.map, mark.mapNavPathInstanceId, mark.drawInstance)
        commonMark.obj.object:SetActive(true)
    else
        commonMark.obj.object.name = "CustomCommonMapMark"
        commonMark.obj.object:SetActive(true)
        commonMark:SetSelect(false)
    end

    self.marksOnShow[markInstance] = commonMark

    -- 做个判断 地图缩小到一定程度 标记点会消失
    local scalePrecent = 1 - ((self.maxScale - self.mapScale) / (self.maxScale - self.minScale))
    local value = math.ceil(scalePrecent * 6) > 0 and math.ceil(scalePrecent * 6) or 1
    if mark.type ~= FightEnum.MapMarkType.Ecosystem then
        local scale = commonMark.config.showScale
        if scale > value then
            commonMark:CloseMark(true)
        end
    end

    if mark.isPlayer then
        self:RefreshPlayerMark(commonMark, mark)
    end
end

function WorldMapWindow:RefreshPlayerMark(commonMark, mark)
    local transformComponent = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject().transformComponent
    local playerPos = transformComponent:GetPosition()
    local playerRot = transformComponent:GetRotation():ToEulerAngles()
    local posX, posY = mod.WorldMapCtrl:TransWorldPosToUIPos(playerPos.x, playerPos.z, self.mapId)
    commonMark:SetPosition(Vec3.New(posX, posY, 0))
    commonMark:SetRotation(-playerRot.y)
    commonMark:ShowMark()

    mark.posX = posX
    mark.posY = posY

    self.initPosX = (posX * self.mapScale) - (self.MapScrollView_rect.rect.width * 0.5)
    self.initPosY = (posY * self.mapScale) + (self.MapScrollView_rect.rect.height * 0.5)
end

function WorldMapWindow:LoadMapName()
    local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    if not entity then
        return
    end
    
    local curMapId = mod.WorldMapCtrl:GetCurMap()
    local mapSceneCfg, mapCfg = mod.WorldMapCtrl:GetMapConfig(self.mapId)
    local curAreaId = entity.values["mAreaId"]
    local curAreaInfo
    if self.mapId == curMapId then
        curAreaInfo = curAreaId and Fight.Instance.mapAreaManager:GetAreaConfig(curAreaId, self.mapId) or nil
    end
    
    self.MapName_txt.text = curAreaInfo and curAreaInfo.name or mapCfg.name
end

function WorldMapWindow:LoadMapAreaName()
    
    self:LoadMapName()

    local scalePrecent = 1 - ((self.maxScale - self.mapScale) / (self.maxScale - self.minScale))
    local value = math.ceil(scalePrecent * 6) > 0 and math.ceil(scalePrecent * 6) or 1
    local mCenter, sCenter = Fight.Instance.mapAreaManager:GetAreaCenter_All(self.mapId)
    local isShowMid = 1 <= value and value <= 2
    local areaCfg
    for k, v in pairs(mCenter) do
        areaCfg = Fight.Instance.mapAreaManager:GetAreaConfig(k, self.mapId)
        if not areaCfg or not next(areaCfg) then
            goto continue
        end

        local posX, posY = mod.WorldMapCtrl:TransWorldPosToUIPos(v.x, v.y, self.mapId)
        local obj = self:PopUITmpObject("MapAreaInfoTemp", self.MidAreaName.transform)
        obj.MapAreaInfoTemp_txt.text = areaCfg.name

        UnityUtils.SetLocalPosition(obj.objectTransform, posX, posY, 0)
        UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
        UnityUtils.SetActive(obj.object, isShowMid)

        self.midAreaNames[areaCfg.id] = obj
        --table.insert(self.midAreaNames, obj)

        ::continue::
    end

    for k, v in pairs(sCenter) do
        areaCfg = Fight.Instance.mapAreaManager:GetAreaConfig(k, self.mapId)
        if not areaCfg or not next(areaCfg) then
            goto continue
        end

        local posX, posY = mod.WorldMapCtrl:TransWorldPosToUIPos(v.x, v.y, self.mapId)
        local obj = self:PopUITmpObject("MapAreaInfoTemp", self.SmallAreaName.transform)
        obj.MapAreaInfoTemp_txt.text = areaCfg.name

        UnityUtils.SetLocalPosition(obj.objectTransform, posX, posY, 0)
        UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
        UnityUtils.SetActive(obj.object, not isShowMid)

        table.insert(self.smallAreaNames, obj)

        ::continue::
    end
end

function WorldMapWindow:LoadMapAreaBounds()
    --刷新地图的区域边框
    local mCenter = Fight.Instance.mapAreaManager:GetArea_All(self.mapId)
    --用画线工具把区域边框画出来
    for areaId, bounds in ipairs(mCenter) do
        local posList = {}
        local obj = self:PopUITmpObject("MapAreaBoundsTemp", self.MidAreaBounds.transform)
        local lineRenderer = obj.object:GetComponent(LineRenderer)
        lineRenderer.loop = true
        lineRenderer.sortingOrder = self.canvas.sortingOrder + 1
        UnityUtils.SetActive(obj.object, false)
        UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)

        for i, v in ipairs(bounds) do
            local posX, posY = mod.WorldMapCtrl:TransWorldPosToUIPos(v.x, v.y, self.mapId)
            table.insert(posList, Vec3.New(posX, posY, 0))
        end

        local color = FightEnum.MapAreaBoundsColor[areaId] or FightEnum.MapAreaBoundsColor[1]
        lineRenderer.startWidth = 0.02;
        lineRenderer.endWidth = 0.02;
        lineRenderer.startColor = color
        lineRenderer.endColor = color
        lineRenderer.positionCount = #posList
        lineRenderer:SetPositions(posList)

        self.midAreaBoundsLine[areaId] = obj
    end
end

function WorldMapWindow:LoadAllMapAreaOccupy()
    local levelList = Fight.Instance.levelManager:GetMapAreaOnShow()
    if not levelList or not next(levelList) then
        return
    end

    for k, v in pairs(levelList) do
        if v then
            self:LoadSingleMapAreaOccupy(k)
        end
    end
end

function WorldMapWindow:LoadSingleMapAreaOccupy(levelId)
    local bounds = Fight.Instance.levelManager:GetLevelOccupancyData(levelId)
    if not bounds or not next(bounds) then
        return
    end

	local pointList = {}
	for i = 1, #bounds do
		local posX, posY = mod.WorldMapCtrl:TransWorldPosToUIPos(bounds[i].x, bounds[i].y, self.mapId)
		table.insert(pointList, Vec3.New(posX, posY, 0))
	end

	local areaObj = self:GetAreaObj()
	local first = 1
	for i = 1, #pointList do
		if pointList[i].x < pointList[first].x then
			first = i
			goto continue
		end

		if pointList[i].x == pointList[first].x and pointList[i].y < pointList[first].y then
			first = i
		end

		::continue::
	end

	local firstPoint = pointList[first]
	areaObj.polygon:SetFirst(pointList[first])
	table.remove(pointList, first)

	local angleList = {}
	for i = 1, #pointList do
		local angle = Vec3.Angle(Vec3.up, pointList[i] - firstPoint)
		angleList[i] = { angle = angle, key = i }
	end
	table.sort(angleList, function (a, b)
		return a.angle < b.angle
	end)
	areaObj.polygon:SetArrayNum(#pointList)

	for i = 1, #angleList do
		areaObj.polygon.v2Arr[i - 1] = pointList[angleList[i].key]
	end

	areaObj.obj.objectTransform:SetParent(self.AreaOccupy.transform)
	UnityUtils.SetLocalScale(areaObj.obj.objectTransform, 1, 1, 1)
	UnityUtils.SetLocalPosition(areaObj.obj.objectTransform, 0, 0, 0)
	UnityUtils.SetActive(areaObj.obj.object, true)
	self.areaOnShow[levelId] = areaObj
end

function WorldMapWindow:RemoveLevelOnMap()
	for k, v in pairs(self.areaOnShow) do
        v.polygon:ResetVert()
        UnityUtils.SetActive(v.obj.object, false)
        table.insert(self.areaObjPool, v)
    end

    self.areaOnShow = {}
end

function WorldMapWindow:GetAreaObj()
	if next(self.areaObjPool) then
		return table.remove(self.areaObjPool)
	end

	local obj = self:PopUITmpObject("MapAreaTemp")
	local polygon = obj.object:GetComponent(UIPolygonWithVert)
	if not polygon then
		polygon = obj.object:AddComponent(UIPolygonWithVert)
	end

	return { obj = obj, polygon = polygon }
end

function WorldMapWindow:ShowMapAreaBounds()
    local scalePrecent = 1 - ((self.maxScale - self.mapScale) / (self.maxScale - self.minScale))
    local value = math.ceil(scalePrecent * 6) > 0 and math.ceil(scalePrecent * 6) or 1
    local isShowMid = 1 <= value and value <= 2

    for areaId, obj in pairs(self.midAreaBoundsLine) do
        UnityUtils.SetActive(obj.object, isShowMid)
    end
end

-- 初始化地图之后设置到展示位置 优先级:跳转标点 = 区域解锁 > 玩家 > 中心点
function WorldMapWindow:SetMapToInitPos()
    if not self.initPosX or not self.initPosY then
        return
    end

    UnityUtils.SetLocalPosition(self.Content.transform, -self.initPosX, -self.initPosY, 0)
    if self.initPosCB then
        self.initPosCB()
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
    self.CostCount_txt.color = BagCtrl:GetItemCountById(cost[1]) >= cost[2] and Color(1,1,1) or Color(1,0.37,0.29)
    self.CostCount_txt.text = cost[2]    
end

function WorldMapWindow:OnMarkUpdate(markOpera, markInstance)
    if not self.active then
        return
    end

    if markOpera == WorldEnum.MarkOpera.Add then
        self:AddMark(markInstance)
    elseif markOpera == WorldEnum.MarkOpera.Refresh then
        if self.marksOnShow[markInstance] then
            self.marksOnShow[markInstance]:RefreshMapMark()
            UnityUtils.SetActive(self.marksOnShow[markInstance].obj.object, true)
        end
    elseif markOpera == WorldEnum.MarkOpera.Remove then
        if self.marksOnShow[markInstance] then
            self.marksOnShow[markInstance]:CloseMark()
        end
    end
    self:UpdateMapSwitch()
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

    self:PushAllUITmpObject("SelectTemp")
    if isShow then
        for i = 1, #selectList do
            local mark = mod.WorldMapCtrl:GetMark(selectList[i])
            local selectObj = self:PopUITmpObject("SelectTemp", self.MarkSelectPos.transform)
            local icon = self:GetMarkIcon(mark)

            UtilsUI.SetActiveByScale(selectObj.object, true)
            SingleIconLoader.Load(selectObj.MarkIcon, icon)
            selectObj.MarkName_txt.text = mark.name and mark.name or TI18N("标记")

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
                commonMark:ShowMark()
                -- UnityUtils.SetActive(commonMark.obj.object, true)
            else
                commonMark:CloseMark(true)
                -- UnityUtils.SetActive(commonMark.obj.object, false)
            end
        elseif commonMark.config.type == FightEnum.MapMarkType.Event then
            local show_scale = commonMark.config.jumpCfg.show_scale
            if show_scale[1] <= value and show_scale[2] >= value then
                commonMark:SetScale(changeScale)
                commonMark:ShowMark()
                -- UnityUtils.SetActive(commonMark.obj.object, true)
            else
                commonMark:CloseMark(true)
                -- UnityUtils.SetActive(commonMark.obj.object, false)
            end
        elseif commonMark.config.type == FightEnum.MapMarkType.LevelEvent then
            local show_scale = commonMark.config.jumpCfg.show_scale
            if show_scale[1] <= value and show_scale[2] >= value then
                commonMark:SetScale(changeScale)
                commonMark:ShowMark()
            else
                commonMark:CloseMark(true)
            end
        else
            local scale = commonMark.config.showScale
            if scale <= value then
                commonMark:SetScale(changeScale)
                commonMark:ShowMark()
            else
                commonMark:CloseMark(true)
            end
        end
    end

    if self.tempCustomMark then
        self.tempCustomMark:SetScale(changeScale)
    end

    local isShowMid = 1 <= value and value <= 2
    for k, v in pairs(self.midAreaNames) do
        UtilsUI.SetActiveByScale(v.object, isShowMid)
        if isShowMid then
            UnityUtils.SetLocalScale(v.objectTransform, changeScale, changeScale, changeScale)
        end
    end

    for k, v in pairs(self.smallAreaNames) do
        UtilsUI.SetActiveByScale(v.object, not isShowMid)
        if not isShowMid then
            UnityUtils.SetLocalScale(v.objectTransform, changeScale, changeScale, changeScale)
        end
    end

    --for i, v in pairs(self.midAreaBoundsLine) do
    --    UtilsUI.SetActiveByScale(v.object, isShowMid)
    --end
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
        if mark.map ~= self.mapId then
            goto continue
        end

        if mark.inTrace then
            local xOut = mark.posX < minPos.x or mark.posX > maxPos.x
            local yOut = mark.posY < minPos.y or mark.posY > maxPos.y
            local traceObj = self.traceObjList[mark.instanceId]
            if not self.traceObjList[mark.instanceId] then
                traceObj = self:PopUITmpObject("TraceTemp", self.TraceNode.transform)
                UtilsUI.SetActiveByScale(traceObj.object, true)
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
        ::continue::
    end
end

function WorldMapWindow:RefreshCenterPointer()
    local _, minPos, maxPos
    _, minPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.Content.transform, Vector2(0, 0), ctx.UICamera)
    _, maxPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.Content.transform, Vector2(Screen.width, Screen.height), ctx.UICamera)
    local centerPosX = (maxPos.x + minPos.x) * 0.5
    local centerPosY = (maxPos.y + minPos.y) * 0.5
    
    --UnityUtils.SetLocalPosition(self.centerPointer.transform, centerPosX, centerPosY, 0)
    local posX, posZ = mod.WorldMapCtrl:TransUIPosToWorldPos(centerPosX, centerPosY, self.mapId)
    
    local centerPos = { x = posX, z = posZ}
    local areaMap = Fight.Instance.mapAreaManager:GetArea_All(self.mapId)
    local inAreaId
    for areaId, bounds in pairs(areaMap) do
        --检测是否位于中区域内
        --local isInArea = BehaviorFunctions.IsPointInsidePolygon(centerPos, bounds)
        local isInArea =  BehaviorFunctions.CheckPointInArea(centerPos, areaId, FightEnum.AreaType.Mid, self.mapId)
        if isInArea then
            inAreaId = areaId
            break
        end
    end

    if inAreaId then
        self:RefreshLeftAreaInfo(inAreaId)
    else
        self:ClosePanel(WorldMapTipPanel)
        
        if self.InAreaId then
            self:LoadMapAreaBoundsByAreaId(self.InAreaId, false)
            self.InAreaId = nil
        end
    end
end

function WorldMapWindow:RefreshLeftAreaInfo(areaId)
    if not areaId then
        --对应区域边缘线刷新
        return
    end
    
    if self.InAreaId == areaId then
        return
    end
    --对应区域边缘线刷新
    self:LoadMapAreaBoundsByAreaId(self.InAreaId, false)
    self.InAreaId = areaId
    self:LoadMapAreaBoundsByAreaId(self.InAreaId, true)

    self:OpenPanel(WorldMapTipPanel, {mapId = self.mapId, areaId = self.InAreaId, sortingOrder = self.canvas.sortingOrder + 2})
end

function WorldMapWindow:OnMarkTraceCancel(instanceId)
    local traceObj = self.traceObjList[instanceId]
    if not traceObj then
        return
    end

    self.traceObjList[instanceId] = nil
    self:PushUITmpObject("TraceTemp", traceObj)
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
        local isDiscover = mod.MercenaryHuntCtrl:CheckMercenaryIsDiscover(mark.ecoCfg.id)
        if isDiscover then
            self:OpenPanel(MercenaryTipsPanel, {openType = 1, hunterInfo = hunterInfo, markInstance = markInstance}, UIDefine.CacheMode.hide)
        end
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
    self.tempCustomMark.obj.object.name = "TempCommonMapMark"

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

function WorldMapWindow:OnClick_RemoveTempMark(isTempClose)
    if not self.tempCustomMark then
        return
    end

    local mark = self.tempCustomMark
    self.tempCustomMark = nil
    mark:CloseMark(isTempClose)
    table.insert(self.markObjPool, mark)
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
        MsgBoxManager.Instance:ShowTips(string.format(TI18N("%s不足"), itemConfig.name))
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
    self:RefreshCenterPointer()
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
            if not transportCfg then
                LogError("data_map_transport can't find id = "..mark.ecoCfg.id)
            elseif transportCfg.mid_area ~= 0 or mod.WorldCtrl:CheckIsTransportPointActive(mark.ecoCfg.id) then
                parentTrans = self.TransportMark.transform
            end
        end
    end

    if next(self.markObjPool) then
        local commonMark = table.remove(self.markObjPool)
        if mark then
            commonMark:InitMapMark(mark, changeScale, self:ToFunc("RemoveMarkCallBack"))
            commonMark:SetParent(parentTrans)
            -- UnityUtils.SetActive(commonMark.obj.object, true)
        end
        commonMark:SetScale(changeScale)
        return commonMark
    end

    local commonMark = CommonMapMark.New(self:PopUITmpObject("CommonMapMark"), parentTrans, changeScale, self.canvas.sortingOrder)
    commonMark:InitSelectLayer(self.canvas.sortingOrder + 1)
    if mark then
        commonMark:InitMapMark(mark, changeScale, self:ToFunc("RemoveMarkCallBack"))
        -- UnityUtils.SetActive(commonMark.obj.object, true)
    end

    return commonMark
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
    self:ResetMapWindow()
    for k, v in pairs(self.switchList) do
        self:PushUITmpObject("SingleArea", self.switchList[k])
        self.switchList[k] = nil
    end

    self.Map.transform:SetParent(self.Map_ani.transform)
    InputManager.Instance:RemoveTouchAction()
	self.args = nil
    self.forceShowMark = nil
    self.unlockAreaId = nil
	
	self.currencyBarClass:OnCache()
	self.currencyBarClass = nil
end

function WorldMapWindow:ResetMapWindow()
    self.initPosX = nil
    self.initPosY = nil
    self.initPosCB = nil

    if self.selectedMark then
        self.marksOnShow[self.selectedMark]:SetSelect(false)
        self.selectedMark = nil
    end

    for k, v in pairs(self.marksOnShow) do
        v:CloseMark()
    end

    if self.panelList["WorldMapInfoPanel"] then
        self.panelList["WorldMapInfoPanel"]:Hide()
    end

    if self.panelList["MercenaryTipsPanel"] then
        self.panelList["MercenaryTipsPanel"]:Hide()
    end

    self:PushAllUITmpObject("TraceTemp")
    self:PushAllUITmpObject("MapBlockTemp")
    self:PushAllUITmpObject("MapMaskTemp")
    self:PushAllUITmpObject("SelectTemp")
    self:PushAllUITmpObject("MapAreaTemp")

    for i = #self.midAreaNames, 1, -1 do
        self:PushUITmpObject("MapAreaInfoTemp", table.remove(self.midAreaNames))
    end

    for i = #self.smallAreaNames, 1, -1 do
        self:PushUITmpObject("MapAreaInfoTemp", table.remove(self.smallAreaNames))
    end

    for i = #self.midAreaBoundsLine, 1, -1 do
        self:PushUITmpObject("MapAreaBoundsTemp", table.remove(self.midAreaBoundsLine))
    end

    UnityUtils.SetActive(self.MapMaskForEffect, false)
end

function WorldMapWindow:__delete()
    if self.hunterProgressBar then
        self.hunterProgressBar:OnCache()
        self.hunterProgressBar = nil
    end
    EventMgr.Instance:RemoveListener(EventName.MarkUpdate, self:ToFunc("OnMarkUpdate"))
    EventMgr.Instance:RemoveListener(EventName.CancelMapMarkTrace, self:ToFunc("OnMarkTraceCancel"))
    EventMgr.Instance:RemoveListener(EventName.ShopListUpdate, self:ToFunc("OnShopListUpdate"))
    EventMgr.Instance:RemoveListener(EventName.AlertValueUpdate, self:ToFunc("ShowMercenaryBar"))
    EventMgr.Instance:RemoveListener(EventName.WorldMapCtrlEntityLoadDone, self:ToFunc("ShowMap"))
    EventMgr.Instance:RemoveListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
    -- EventMgr.Instance:RemoveListener(EventName.ShowLevelOnMap, self:ToFunc("ShowLevelOnMap"))
end

function WorldMapWindow:OnActionInput(key, value)
    if not self.openMouseScroll then
        return
    end
    if key == FightEnum.KeyEvent.MouseScroll then
        local newValue = self.scalingBar.value
        if value.y > 100 then --往上滑
            newValue = newValue + 0.1
        elseif value.y < -100 then
            newValue = newValue - 0.1
        end
        newValue = MathX.Clamp(newValue,0,1)
        self.scalingBar.value = newValue
        self:OnValueChange_Scale(newValue)
    end
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

function WorldMapWindow:DoMapScale(mapCfg)
    --点击之后，读取该区域的放缩参数
    if mapCfg then
        --需要缩放的百分比
        local precent = mapCfg.change_scale / 6
        self.scalingBar.value = precent
        self:OnValueChange_Scale(precent)
    end
end

function WorldMapWindow:DOMapMove(pos)
    --地图上发现的事件，只能是服务端抽到的事件
    if pos then
        if self.mapMoveSequence then
            self.mapMoveSequence:Kill()
            self.mapMoveSequence = nil
        end

        self.mapMoveSequence = DOTween.Sequence()
        local width = (pos.x * self.mapScale) - (self.MapScrollView_rect.rect.width * 0.5)
        local height = (pos.y * self.mapScale) + (self.MapScrollView_rect.rect.height * 0.5)
        local targetPos = Vector3(-width, -height, 0)
        local tween = self.Content.transform:DOLocalMove(targetPos, 0.5, true)
        self.mapMoveSequence:Append(tween)
    end
end

--关闭一些function面板
function WorldMapWindow:SetFuncPanel(isShow)
    if self.AreaSelect then
        self.AreaSelect:SetActive(isShow)
    end
    if self.Scale then
        self.Scale:GetComponent(CanvasGroup).alpha = isShow and 1 or 0
    end
    UtilsUI.SetActiveByScale(self.CommonBack, isShow)
    UtilsUI.SetActiveByScale(self.cityProgress, isShow)
end

--特化显示边框和区域名
function WorldMapWindow:LoadMapAreaBoundsByAreaId(areaId, isShow)
    if self.midAreaBoundsLine[areaId] then
        UtilsUI.SetActiveByScale(self.midAreaBoundsLine[areaId].object, isShow)
    end
    if self.midAreaNames[areaId] then
        UtilsUI.SetActiveByScale(self.midAreaNames[areaId].object, isShow)
    end
end

--外部调用 点击区域{mapCfg , pos}
function WorldMapWindow:OnClickWorldMapToSetPos(mapCfg, pos)
    --屏蔽滚轮缩放 
    self.openMouseScroll = false
    
    self:DoMapScale(mapCfg)
    self:DOMapMove(pos)
    self:SetFuncPanel(false)
    self:LoadMapAreaBoundsByAreaId(mapCfg.id, true)
    --更新区域名称
    self.MapName_txt.text = mapCfg and mapCfg.name or ""
end

--从中区域状态回到大地图状态
function WorldMapWindow:AreaToMapWindow()
    --还原滚轮缩放 
    self.openMouseScroll = true

    self.scalingBar.value = 0
    self:OnValueChange_Scale(0)
    self:SetFuncPanel(true)
    self:UpdateRoguePanel()
    self:LoadMapName()
end

--跳转城市衍化界面
function WorldMapWindow:OnJumpToRogueCityEvolution()
    PanelManager.Instance:OpenPanel(RogueCityEvolutionPanel)
end

function WorldMapWindow:OnChooseRogueInfoPanel()
    self:OpenPanel(WorldMapAreaInfoPanel, {mapId = self.mapId, isShowRight = true})
end

-- 显示关卡区域占用
-- function WorldMapWindow:ShowLevelOnMap(levelId, isShow)
--     if not isShow then

--     end

--     local pointList = Fight.Instance.levelManager:GetLevelOccupancyData(levelId)
--     if not pointList or not next(pointList) then
--         return
--     end


-- end

-- 地图设置
function WorldMapWindow:OnClick_SettingBtn()
    UtilsUI.SetActive(self.WorldMapSetting,true)
end

function WorldMapWindow:OnClick_CloseSettingBtn()
    UtilsUI.SetActive(self.WorldMapSetting,false)
end

function WorldMapWindow:OnClick_CompletedChallengeSelectBtn()
    
end

function WorldMapWindow:OnClick_FunctionStoreSelectBtn()
    
end

function WorldMapWindow:OnClick_CustomMaskSelectBtn()
    
end