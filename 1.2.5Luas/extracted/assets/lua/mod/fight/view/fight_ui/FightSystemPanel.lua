FightSystemPanel = BaseClass("FightSystemPanel", BasePanel)

--临时颜色配置
--体力条
local StrengthColor = {
	Color(68/255, 255/255, 213/255, 255/255),	--基础颜色
	Color(43/255, 54/255, 67/255, 159/255),		--基础背景颜色
	Color(247/255, 117/255, 96/255, 255/255),	--低数值颜色
	Color(112/255, 57/255, 59/255, 159/255)	,	--低数值背景颜色
}

--叙慕核心
local XumuResCoreColor = {
	Color(255/255, 40/255, 37/255, 255/255),	--基础颜色
	Color(43/255, 54/255, 67/255, 159/255),		--基础背景颜色
	Color(247/255, 117/255, 96/255, 255/255),	--低数值颜色
	Color(112/255, 57/255, 59/255, 159/255)	,	--低数值背景颜色
}

--刻刻核心
local KekeResCoreColor = {
	Color(154/255, 72/255, 227/255, 255/255),	--基础颜色
	Color(43/255, 54/255, 67/255, 159/255),		--基础背景颜色
	Color(247/255, 117/255, 96/255, 255/255),	--低数值颜色
	Color(112/255, 57/255, 59/255, 159/255)	,	--低数值背景颜色
}


function FightSystemPanel:__init(mainView)
    self:SetAsset("Prefabs/UI/Fight/FightSystemPanel.prefab")
    self.mainView = mainView

	-- 小地图
	self.marksOnShow = {}
	self.markPool = {}
	self.traceMark = {}
	self.traceMarkPool = {}
	self.mapMaskPool = {}
	self.mapMaskOnShow = {}
	self.refreshMiniMap = true
	self.miniMapInited = false

	self.defaultMiniMapScale = 1 / 3

	self.miniMapScale = 1
	self.miniMapMarkScale = 1

	self.tmpCyclePos = Vec3.New()
end

function FightSystemPanel:__BindListener()
    self.TaskButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenTask"))
	self.BagButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenBag"))
	self.RoleButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenRole"))
    self.MainMenuButton_btn.onClick:AddListener(self:ToFunc("OnClick_MainMenu"))
	self.TeachBtn_btn.onClick:AddListener(self:ToFunc("OnClick_TeachBtn"))
	self.AdventureButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenAdventure"))

	local darpEvent = self.Map:AddComponent(UIDragBehaviour)
	darpEvent.onPointerClick = self:ToFunc("OnClick_Map")
	--self.Map_btn.onClick:AddListener(self:ToFunc("OnClick_Map"))
	
	self.strengthBarLogic = CycleProcessLogic.New(self.StrengthBar, self.StrengthBar1, 
		self.StrengthBar2, self.StrengthBarBg, Vec3.New(100, 60, 0), true, StrengthColor)
end

function FightSystemPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.AddTeach, self:ToFunc("UpdateTeachRed"))
    EventMgr.Instance:AddListener(EventName.RetTeachLookReward, self:ToFunc("UpdateTeachRed"))
	EventMgr.Instance:AddListener(EventName.SystemOpen, self:ToFunc("ShowAdv"))
	EventMgr.Instance:AddListener(EventName.MapAreaUpdate, self:ToFunc("OnMapAreaUpdate"))

	self:BindRedPoint(RedPointName.Adv, self.AdvRed)
	self:BindRedPoint(RedPointName.Teach, self.TeachRed)
	self:BindRedPoint(RedPointName.SystemMenu, self.MenuRed)
	self:BindRedPoint(RedPointName.Role, self.RoleRed)
end

function FightSystemPanel:__BaseShow()
	self:SetParent(self.mainView.PanelParent.transform)
end

function FightSystemPanel:__Show()
	self.StrengthBar_canvas.alpha = 0
	--self:UpdateTeachRed()
	self:LoadMiniMap()
	self:ShowAdv()
end
function FightSystemPanel:ShowAdv()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.MaoXian)
	self.AdventureButton:SetActive(isOpen)
end

function FightSystemPanel:__ShowComplete()
	self.mainView:AddLoadDoneCount()
end

function FightSystemPanel:__delete()
	self.strengthBarLogic:DeleteMe()
	self.strengthBarLogic = nil
end

function FightSystemPanel:__Hide()
	for k, v in pairs(self.marksOnShow) do
		self:RemoveMark(k)
	end

	for k, v in pairs(self.mapMaskOnShow) do
		local maskObj = self.mapMaskOnShow[k]
		UnityUtils.SetActive(maskObj.object, false)
		table.insert(self.mapMaskPool, maskObj)
		self.mapMaskOnShow[k] = nil
	end

	EventMgr.Instance:RemoveListener(EventName.AddTeach, self:ToFunc("UpdateTeachRed"))
    EventMgr.Instance:RemoveListener(EventName.RetTeachLookReward, self:ToFunc("UpdateTeachRed"))
	EventMgr.Instance:RemoveListener(EventName.SystemOpen, self:ToFunc("ShowAdv"))
	EventMgr.Instance:RemoveListener(EventName.MapAreaUpdate, self:ToFunc("OnMapAreaUpdate"))
end

function FightSystemPanel:OnClick_OpenBag()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Bag)
	if not isOpen then
		MsgBoxManager.Instance:ShowTips(failDesc)
		return
	end
	self.mainView:HideSelf(function ()
		WindowManager.Instance:OpenWindow(BagWindow)
	end)
end

function FightSystemPanel:OnClick_OpenRole()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(101)
	if not isOpen then
		MsgBoxManager.Instance:ShowTips(failDesc)
		return
	end
	self.mainView:HideSelf(function ()
		RoleMainWindow.OpenWindow(mod.RoleCtrl:GetCurUseRole())
	end)
end

function FightSystemPanel:OnClick_OpenTask()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Task)
	if not isOpen then
		MsgBoxManager.Instance:ShowTips(failDesc)
		return
	end
	self.mainView:HideSelf(function ()
		WindowManager.Instance:OpenWindow(TaskMainWindow)
	end)

end

function FightSystemPanel:OnClick_OpenAdventure()
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.MaoXian)
	if not isOpen then
		MsgBoxManager.Instance:ShowTips(failDesc)
		return
	end
	self.mainView:HideSelf(function ()
		WindowManager.Instance:OpenWindow(AdvMainWindowV2)
	end)

end

function FightSystemPanel:OnClick_MainMenu()
	self.mainView:HideSelf(function ()
		WindowManager.Instance:OpenWindow(SystemMenuWindow)
	end)
end

function FightSystemPanel:HideSelf()
	self.ColseSwitch:SetActive(true)
end

function FightSystemPanel:OnClick_TeachBtn()
	self.mainView:HideSelf(function ()
		WindowManager.Instance:OpenWindow(TeachWindow)
	end)
end

-- TODO 后续添加地图参数
function FightSystemPanel:OnClick_Map()
	local isDup = mod.WorldMapCtrl:CheckIsDup()
	if isDup then
		return
	end
	local isOpen, failDesc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Map)
	if not isOpen then
		MsgBoxManager.Instance:ShowTips(failDesc)
		return
	end
	self.mainView:HideSelf(function ()
		WindowManager.Instance:OpenWindow(WorldMapWindow)
	end)

end

function FightSystemPanel:UpdatePlayer()
	self.player = Fight.Instance.playerManager:GetPlayer()
	self.entity = self.player:GetCtrlEntityObject()
end


function FightSystemPanel:Update()
	UnityUtils.BeginSample("FightSystemPanel")
	if self.player and self.player.fightPlayer then
		local staminaValue, staminaMaxValue = self.player.fightPlayer:GetValueAndMaxValue(FightEnum.PlayerAttr.CurStaminaValue)
		self.strengthBarLogic:Update(self.entity, staminaValue, staminaMaxValue)
	end

	-- 小地图
	UnityUtils.BeginSample("UpdateMiniMap")
	self:UpdateMiniMap()
	UnityUtils.EndSample()
	UnityUtils.EndSample()
end

function FightSystemPanel:UpdateTeachRed()
	-- local teachManager = Fight.Instance.teachManager

	-- local isShow = false
    -- local systemMgr = Fight.Instance.systemManager
    -- if systemMgr:CheckSystemOpen(SystemManager.TeachSystemId) then
    --     isShow = teachManager:CheckShowTeachRed()
    -- end

	-- --self.TeachRed:SetActive(isShow)
	-- self.MenuRed:SetActive(isShow)
end

--#region MiniMap

-- TODO 后续按照位置做区块加载 加载一个九宫格出来
function FightSystemPanel:LoadMiniMap()
	local mapId = Fight.Instance:GetFightMap()
	local mapCfg = mod.WorldMapCtrl:GetMapConfig(mapId)
	if not mapCfg.mini_map or mapCfg.mini_map == "" then
		self.MapContent:SetActive(false)
		self.refreshMiniMap = false
		return
	end

	self.defaultMiniMarkScale = 2048 / mapCfg.width
	local iconCb = function ()
		if not self.MapContent_img then
			return
		end

		local sprite = self.MapContent_img.sprite
		self.miniMapScale = self.defaultMiniMapScale

		local areaId = self.entity.values["sAreaId"]
		local areaCfg = Fight.Instance.mapAreaManager:GetAreaConfig(areaId)
		if areaCfg and next(areaCfg) then
			local changeTimes = areaCfg.change_scale ~= 0 and areaCfg.change_scale or 1
			self.miniMapScale = changeTimes * self.defaultMiniMapScale
		end
		self.miniMapMarkScale = self.defaultMiniMarkScale / self.miniMapScale

		UnityUtils.SetSizeDelata(self.MapContent.transform, sprite.rect.width, sprite.rect.height)
		UnityUtils.SetLocalScale(self.MapContent.transform, self.miniMapScale, self.miniMapScale, self.miniMapScale)

		self:LoadMapMasks(mapId)
		self:LoadMapMarks(mapId)
		self.miniMapInited = true
	end
	SingleIconLoader.Load(self.MapContent, mapCfg.mini_map, iconCb)
end

function FightSystemPanel:LoadMapMasks(mapId)
	local lockArea = Fight.Instance.mapAreaManager:GetLockMidArea()
	local maskScale = 1 / self.defaultMiniMarkScale
    for k, v in pairs(lockArea) do
        local blockPic = string.format("Textures/Icon/Single/MapIcon/areamask_%s.png", v.id)
        local blockObj = self:GetMapMaskObj()
        local callBackFunc = function()
			if not self.defaultMiniMapScale or not self.defaultMiniMarkScale then
				return
			end

            local sprite = blockObj.MaskTemp_img.sprite
            UnityUtils.SetSizeDelata(blockObj.objectTransform, sprite.rect.width, sprite.rect.height)
			UnityUtils.SetLocalScale(blockObj.objectTransform, maskScale, maskScale, maskScale)
            UnityUtils.SetLocalPosition(blockObj.objectTransform, v.position_x / maskScale, v.position_y / maskScale, 0)
            blockObj.object:SetActive(true)
            blockObj.object.name = "map_mask_"..k
        end

        SingleIconLoader.Load(blockObj.object, blockPic, callBackFunc)

        table.insert(self.mapMaskOnShow, blockObj)
    end
end

function FightSystemPanel:GetMapMaskObj()
    if next(self.mapMaskPool) then
        return table.remove(self.mapMaskPool)
    end

    local obj = self:PopUITmpObject("MaskTemp")
    obj = UtilsUI.GetContainerObject(obj.objectTransform, obj)
    obj.objectTransform:SetParent(self.MapBlock.transform)

    return obj
end

function FightSystemPanel:OnMapAreaUpdate()
	if not self.miniMapInited then return end
	local mapId = Fight.Instance:GetFightMap()
	local mapCfg = mod.WorldMapCtrl:GetMapConfig(mapId)
	if not mapCfg.mini_map or mapCfg.mini_map == "" then
		return
	end

	for k, v in pairs(self.mapMaskOnShow) do
		local maskObj = self.mapMaskOnShow[k]
		UnityUtils.SetActive(maskObj.object, false)
		table.insert(self.mapMaskPool, maskObj)
		self.mapMaskOnShow[k] = nil
	end

	self:LoadMapMasks()
end

function FightSystemPanel:LoadMapMarks(mapId)
	local mapMarks = mod.WorldMapCtrl:GetMapMark(mapId)
	if not mapMarks or not next(mapMarks) then
		return
	end

	for k, v in pairs(mapMarks) do
        for instanceId, _ in pairs(v) do
            self:AddMark(instanceId)
        end
    end
end

function FightSystemPanel:AddMark(instanceId)
	if self.marksOnShow[instanceId] then
		return
	end

	local mark = mod.WorldMapCtrl:GetMark(instanceId)
	if mark.isPlayer or mod.WorldMapCtrl:CheckMarkIsHide(instanceId) then
		return
	end

	local commonMark = self:GetMarkObj(mark)
	self.marksOnShow[instanceId] = commonMark

	if mark.inTrace then
		if not self.traceMark then
			self.traceMark = {}
		end

		local traceObj = self:GetTraceObj()
		self.traceMark[instanceId] = traceObj
		self.traceMark[instanceId].info = mark
	end
end

function FightSystemPanel:RefreshMark(instanceId)
	if not self.marksOnShow[instanceId] then
		return
	end

	local mark = mod.WorldMapCtrl:GetMark(instanceId)
	self.marksOnShow[instanceId]:RefreshMapMark()

	if self.traceMark[instanceId] and not mark.inTrace then
		self.traceMark[instanceId].obj.object:SetActive(false)
		table.insert(self.traceMarkPool, self.traceMark[instanceId].obj)
		self.traceMark[instanceId] = nil
	elseif not self.traceMark[instanceId] and mark.inTrace then
		local traceObj = self:GetTraceObj()
		self.traceMark[instanceId] = traceObj
		self.traceMark[instanceId].info = mark
	end
end

function FightSystemPanel:RemoveMark(instnaceId)
	if not self.marksOnShow[instnaceId] then
		return
	end

	self.marksOnShow[instnaceId]:CloseMark()
end

function FightSystemPanel:RemoveMarkCallBack(instnaceId)
	local commonMark = self.marksOnShow[instnaceId]
	table.insert(self.markPool, commonMark)
	self.marksOnShow[instnaceId] = nil

	if self.traceMark[instnaceId] then
		self.traceMark[instnaceId].obj.object:SetActive(false)
		table.insert(self.traceMarkPool, self.traceMark[instnaceId].obj)
		self.traceMark[instnaceId] = nil
	end
end

function FightSystemPanel:GetMarkIcon(mark)
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

function FightSystemPanel:UpdateMiniMap()
	if not self.refreshMiniMap or self.mapSequence then
		return
	end

	if self.waitUpdateScale then
		self:RefreshMapScale(self.miniMapScale)
		self.waitUpdateScale = false
		return
	end

	local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	local position = entity.transformComponent.position
	local mapId = Fight.Instance:GetFightMap()
	local width, height = mod.WorldMapCtrl:TransWorldPosToUIPos(position.x, position.z, mapId)

	-- 因为特效会透过来 临时算一下mark的位置 手动操控一下特效
	self:TempActiveTraceEffect(width, height)
	self:RefreshTraceMark(width, height)

	width = width * self.miniMapScale * self.defaultMiniMarkScale
	height = height * self.miniMapScale * self.defaultMiniMarkScale

	UnityUtils.SetLocalPosition(self.MapContent.transform, -width, -height)
	UnityUtils.SetEulerAngles(self.ArrowGroup.transform, 0, 0, -entity.clientEntity.clientTransformComponent.eulerAngles.y)
	UnityUtils.SetEulerAngles(self.Direction.transform, 0, 0, -CameraManager.Instance.mainCamera.transform.rotation.eulerAngles.y)
end

function FightSystemPanel:TempActiveTraceEffect(width, height)
	local scaleOffset = self.miniMapMarkScale / self.defaultMiniMarkScale
	local xCheck = 92 * scaleOffset
	local yCheck = 92 * scaleOffset
	for k, v in pairs(self.marksOnShow) do
		if not v.config.inTrace then
			goto continue
		end

		local isHide = false
		local toward = Vec3.Normalize(Vec3.New(v.config.posX - width, 0, v.config.posY - height))
		local targetAngle = Vec3.Angle(Vec3.forward, toward)
		if toward.x < 0 then
			targetAngle = 360 - targetAngle
		end

		local xOffset = (v.config.posX - width) * scaleOffset
		local yOffset = (v.config.posY - height) * scaleOffset
		if math.abs(math.sin(math.rad(targetAngle)) * xCheck) < math.abs(xOffset) then
			isHide = true
		end

		if math.abs(math.cos(math.rad(targetAngle)) * yCheck) < math.abs(yOffset) then
			isHide = true
		end

		v:SetEffectState(isHide)

		::continue::
	end
end

function FightSystemPanel:RefreshTraceMark(width, height)
	if not self.traceMark then
		return
	end

	local scaleOffset = self.miniMapScale * self.defaultMiniMarkScale
	local xCheck = 92
	local yCheck = 92
	local xDif = 29
	local yDif = 29
	for k, v in pairs(self.traceMark) do
		local isShow = false
		local toward = Vec3.Normalize(Vec3.New(v.info.posX - width, 0, v.info.posY - height))
		local targetAngle = Vec3.Angle(Vec3.forward, toward)
		if toward.x < 0 then
			targetAngle = 360 - targetAngle
		end

		local xOffset = (v.info.posX - width) * scaleOffset
		local yOffset = (v.info.posY - height) * scaleOffset
		if math.abs(math.sin(math.rad(targetAngle)) * xCheck) < math.abs(xOffset) then
			isShow = true
			xOffset = (math.sin(math.rad(targetAngle)) * xDif) / scaleOffset
		end

		if math.abs(math.cos(math.rad(targetAngle)) * yCheck) < math.abs(yOffset) then
			isShow = true
			yOffset = (math.cos(math.rad(targetAngle)) * yDif) / scaleOffset
		end

		local obj
		if v.obj then
			obj = v.obj
		else
			obj = self:GetTraceObj()
			local icon = self:GetMarkIcon(v.info)
			SingleIconLoader.Load(obj.TraceIcon, icon)

			local isNormal = not v.info.jumpCfg or (v.info.jumpCfg.jump_id ~= 100001 and v.info.jumpCfg.jump_id ~= 100002)
			if not isNormal then
				local isActive = mod.WorldCtrl:CheckIsTransportPointActive(v.info.ecoCfg.id)
				UnityUtils.SetActive(obj.STransBack, isActive and v.info.jumpCfg.jump_id == 100002)
				UnityUtils.SetActive(obj.STransLock, not isActive and v.info.jumpCfg.jump_id == 100002)
				UnityUtils.SetActive(obj.BTransBack, isActive and v.info.jumpCfg.jump_id == 100001)
				UnityUtils.SetActive(obj.BTransLock, not isActive and v.info.jumpCfg.jump_id == 100001)
			end
			UnityUtils.SetActive(obj.NormalBack, isNormal and not v.info.isPlayer)

			self.traceMark[k].obj = obj
		end

		UtilsUI.SetActive(obj.object, isShow)
		if not isShow then
			return
		end

		if isShow then
			UtilsUI.SetActive(obj["21044"], v.info.type == FightEnum.MapMarkType.Task)
			UtilsUI.SetActive(obj["21030"], v.info.type ~= FightEnum.MapMarkType.Task)
			UnityUtils.SetLocalPosition(obj.objectTransform, width * self.defaultMiniMarkScale + xOffset, height * self.defaultMiniMarkScale + yOffset, 0)
		else

		end
	end
end

function FightSystemPanel:RefreshMapScale(changeTimes)
	local changeScale = changeTimes and changeTimes * self.defaultMiniMapScale or self.defaultMiniMapScale
	if self.miniMapScale == changeScale and not self.waitUpdateScale then
		return
	end

	if self.mapSequence then
		self.waitUpdateScale = true
		self.miniMapScale = changeScale
		return
	end

	self.mapSequence = DOTween.Sequence()
	self.miniMapScale = changeScale
	self.miniMapMarkScale = self.defaultMiniMarkScale / self.miniMapScale
	local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	local position = entity.transformComponent.position
	local mapId = Fight.Instance:GetFightMap()
	local width, height = mod.WorldMapCtrl:TransWorldPosToUIPos(position.x, position.z, mapId)
	self:RefreshTraceMark(width, height)
	width = width * self.miniMapScale * self.defaultMiniMarkScale
	height = height * self.miniMapScale * self.defaultMiniMarkScale

	local tween1 = self.MapContent.transform:DOScale(self.miniMapScale, 0.5)
	local tween2 = self.MapContent.transform:DOLocalMove(Vector3(-width, -height, 0), 0.5)
	local marksTween = {}
	for _, v in pairs(self.marksOnShow) do
		table.insert(marksTween, v.obj.objectTransform:DOScale(self.miniMapMarkScale, 0.5))
	end

	for _, v in pairs(self.traceMark) do
		table.insert(marksTween, v.obj.objectTransform:DOScale(self.miniMapMarkScale, 0.5))
	end

	self.mapSequence:Append(tween1)
	self.mapSequence:Join(tween2)
	for _, v in pairs(marksTween) do
		self.mapSequence:Join(v)
	end

	local timerFunc = function()
		if self.mapSequence.isPlaying then
			LogError("11")
		end

		if self.mapSequence then
			self.mapSequence:Kill()
			self.mapSequence = nil
		end
	end
	--LuaTimerManager.Instance:AddTimer(1, 1, timerFunc)
end

--#region 获取动态加载item

function FightSystemPanel:GetTraceObj()
	if next(self.traceMarkPool) then
		return table.remove(self.traceMarkPool)
	end

    local obj = self:PopUITmpObject("TraceTemp")
    obj = UtilsUI.GetContainerObject(obj.objectTransform, obj)

    obj.objectTransform:SetParent(self.MapContent.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, self.miniMapMarkScale, self.miniMapMarkScale, self.miniMapMarkScale)
	UtilsUI.SetEffectSortingOrder(obj["21030"], self.canvas.sortingOrder)

    return obj
end

function FightSystemPanel:GetMarkObj(mark)
	if next(self.markPool) then
		local commonMark = table.remove(self.markPool)
		commonMark:InitMapMark(mark, self.miniMapMarkScale, self:ToFunc("RemoveMarkCallBack"), self.defaultMiniMarkScale)
		UnityUtils.SetActive(commonMark.obj.object, true)
		return commonMark
	end

	local parent = self.CommonMark.transform
	if mark.type == FightEnum.MapMarkType.Ecosystem then
		local isTransport = Fight.Instance.entityManager.ecosystemEntityManager:CheckEcoEntityType(mark.ecoCfg.id, FightEnum.EcoEntityType.Transport)
        if isTransport then
            local transportCfg = Config.DataMap.data_map_transport[mark.ecoCfg.id]
            if transportCfg.mid_area ~= 0 or mod.WorldCtrl:CheckIsTransportPointActive(mark.ecoCfg.id) then
                parent = self.TransportMark.transform
            end
        end
	elseif mark.type == FightEnum.MapMarkType.Task then
		parent = self.TaskMark.transform
	end

	local commonMark = CommonMapMark.New(self:PopUITmpObject("CommonMapMark"), parent, self.miniMapMarkScale, self.canvas.sortingOrder)
	commonMark:InitMapMark(mark, self.miniMapMarkScale, self:ToFunc("RemoveMarkCallBack"), self.defaultMiniMarkScale)
	UnityUtils.SetActive(commonMark.obj.object, true)

	return commonMark
end

--#endregion

---comment
---@param refreshType number 刷新小地图类型(刷新，添加，移除)
---@param mark any 对应的标记
function FightSystemPanel:RefreshMiniMapMark(refreshType, mark)
	if refreshType == WorldEnum.MarkOpera.Add then
		self:AddMark(mark)
	elseif refreshType == WorldEnum.MarkOpera.Refresh then
		self:RefreshMark(mark)
	elseif refreshType == WorldEnum.MarkOpera.Remove then
		self:RemoveMark(mark)
	end
end

--#endregion