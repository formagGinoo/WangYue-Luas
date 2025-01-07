DecorationDisplayCtrl = BaseClass("DecorationDisplayCtrl",PoolBaseClass)

DecorationDisplayCtrl.MaxAssetLevel = 99

function DecorationDisplayCtrl:__init()

end

function DecorationDisplayCtrl:Init(fight, entityManager, displayManager, uniqueId, entity , templateId)
	self.fight = fight
	self.entityManager = entityManager
	self.displayManager = displayManager
	self.uniqueId = uniqueId
	self.templateId = templateId
	self.workTips = nil
    self.workEntity = {}

    self.entity = entity
	for k, v in pairs(FightEnum.WorkPlaceSize) do
		self[k] = self.entity.clientTransformComponent:GetTransformGroup(k)
	end

	self.navPos = self.entity.clientTransformComponent:GetTransformGroup("NavPos")

	local icon,iconDis,name,nameDis,scale= AssetDeviceConfig.GetDecorationItemShow(templateId)

	if icon or name then
		BehaviorFunctions.ShowCharacterHeadTips(self.entity.instanceId, true)
		BehaviorFunctions.ChangeNpcDistanceThreshold(self.entity.instanceId, nil,nil,nameDis ^ 2,iconDis ^2)
		if icon then
			BehaviorFunctions.ChangeNpcHeadIcon(self.entity.instanceId, icon)
		end
		if name then
			if self.displayManager.debug then
				name = name .. self.uniqueId
			end
			BehaviorFunctions.ChangeNpcName(self.entity.instanceId, TI18N(name))
		end
		if scale then
			BehaviorFunctions.ChangeHeadTipScale(self.entity.instanceId, scale)
		end
		
	end

	self.showCollect = false
	self.collectShowDis = -1
	self.showCollect,self.collectShowDis = AssetDeviceConfig.GetDecorationCollecthow(self.templateId)


	self.interactItemsMap = {}
	self:UpdateDisplay()
end

--演出实体更新(GM用，仅提示)
function DecorationDisplayCtrl:UpdateDisplay()
	
	if self.showCollect then

		self.workTips = self.workTips or BehaviorFunctions.ShowWorkHeadTips(self.entity.instanceId, true)

		local info = mod.AssetPurchaseCtrl:GetCurAssetDeviceWorkData(self.uniqueId).work_info
		if info.work_id ~= 0 then
			
			self.workTips:ChangeDistanceThreshold(nil,self.collectShowDis)
			local finish = info.finish_amount >= info.work_amount
			if info.finish_amount < info.work_amount then
				if  #info.partner_list == 0 then
					self.workTips:ChangePage("stop")
					self.workTips:ChangeContent(TI18N("暂停中："))
				else
					self.workTips:ChangePage("working")
					self.workTips:ChangeContent(TI18N("制作中："))
				end
			else 
				self.workTips:ChangePage("finished")
				self.workTips:ChangeContent(TI18N("已完成："))
			end
			local icon = AssetDeviceConfig.GetDecorationCollectItemIcon(info.work_id)
			self.workTips:ChangeIcon(icon)
			self.workTips:ChangeNum(info.finish_amount)
		else
			self.workTips:ChangeDistanceThreshold(nil,0)
		end
	end
	
	if self.displayManager.debug then
		self:UpdateDebugContent()
	end
end

function DecorationDisplayCtrl:UpdateDebugContent()
	--显示所有物件的提示
	--BehaviorFunctions.ShowCharacterHeadTips(self.entity.instanceId, true)

	--BehaviorFunctions.ChangeNpcDistanceThreshold(self.entity.instanceId, 9999,9999,9999,9999)
	local info = mod.AssetPurchaseCtrl:GetCurAssetDeviceWorkData(self.uniqueId)
	local deviceCfg = AssetPurchaseConfig.GetAssetDeviceInfoById(info.template_id)
	
	local workInfo = info.work_info
	
	local content = deviceCfg.name
	content = content.."物件: "..info.id..'\n'
	content = content.."佩丛: "
	for i, partnerId in ipairs(workInfo.partner_list) do
		content = content..partnerId..' ,'
	end
	content = content..'\n'
	content = content.."last_refresh_time: "..workInfo.last_refresh_time..'\n'
	content = content.."work_id: "..workInfo.work_id..'\n'
	content = content.."work_amount: "..workInfo.work_amount..'\n'
	content = content.."work_value: "..workInfo.work_value..'\n'
	content = content.."finish_amount: "..workInfo.finish_amount..'\n'
	content = content.."product_id: "..workInfo.product_id..'\n'
	content = content.."食物: "
	for i, v in ipairs(workInfo.food_list) do
		content = content..v.key..' ,'..v.value..'\n'
	end
	content = content..'\n'
	BehaviorFunctions.ChangeNpcBubbleContent(self.entity.instanceId, content, 999999)
	BehaviorFunctions.SetNonNpcBubbleVisible(self.entity.instanceId, true)
end

function DecorationDisplayCtrl:ClearInteractItems()
	
	for i, v in pairs(self.interactItemsMap) do
		BehaviorFunctions.WorldInteractRemove(self.entity.instanceId,v)
	end
	TableUtils.ClearTable(self.interactItemsMap)
end


function DecorationDisplayCtrl:InteractClick(interactId)
	for i, v in pairs(self.interactItemsMap) do
		if v == interactId then
			local interactItems = self.displayManager:GetInteractItems(2,self.uniqueId)
			if interactItems and interactItems[i] and interactItems[i].clickFunc then
				interactItems[i].clickFunc()

			end
			if interactItems and interactItems[i] and interactItems[i].clickClose then
				BehaviorFunctions.WorldInteractRemove(self.entity.instanceId,interactId) --移除
			end
		end
	end
end

function DecorationDisplayCtrl:SetInteractActive(ison)
	
	self:ClearInteractItems()
	if ison then
		local interactItems = self.displayManager:GetInteractItems(2,self.uniqueId)
		if interactItems then
			for i, v in pairs(interactItems) do
				if not self.interactItemsMap[v.index] then
					local interactId = BehaviorFunctions.WorldInteractActive(self.entity.instanceId, 0, v.icon, v.text)
					self.interactItemsMap[v.index] = interactId
				end
			end
		end
	end
end


function DecorationDisplayCtrl:GetTemplateId()
	return self.templateId
end

function DecorationDisplayCtrl:GetEventType()
	
	return AssetDeviceConfig.GetShowType(self:GetTemplateId())
end

function DecorationDisplayCtrl:GetEventType()
	
	return AssetDeviceConfig.GetShowType(self:GetTemplateId())
end

-- 检查职业是否匹配
function DecorationDisplayCtrl:CheckCareer(partnerCtrl)
	local workConfig = PartnerBagConfig.GetPartnerWorkConfig(partnerCtrl:GetTemplateId())
	local deviceInfo = AssetPurchaseConfig.GetAssetDeviceInfoById(self:GetTemplateId())

	if workConfig and deviceInfo then
		if  deviceInfo.career == 0 then
			return true

		else
			local result = false
			for i, v in ipairs(workConfig.career) do
				if v[1] == deviceInfo.career then
					result = true
				end
			end
			return true
		end
	end
end


function DecorationDisplayCtrl:GetStation(partnerCtrl)
	
	if  self:CheckCareer(partnerCtrl) then
        local curNum = TableUtils.GetTabelLen(self.workEntity)
		local totalNum = self:GetMaxStaffNum()
		
        if not self.workEntity[partnerCtrl.uniqueId] then
			
			local size = partnerCtrl:GetSize()
			local targetSize
			for k, v in pairs(FightEnum.WorkPlaceSize) do
				if v== size then
					targetSize = k
				end
			end
			local position = partnerCtrl.entity.transformComponent:GetPosition()

            return self:GetEmptyStation(targetSize,position)
        end
	end
end


function DecorationDisplayCtrl:CheckInStation(partnerCtrl)
	return self.workEntity[partnerCtrl.uniqueId]
end

function DecorationDisplayCtrl:GetMaxStaffNum()
	return AssetDeviceConfig.GetStaffNum(self:GetTemplateId(),DecorationDisplayCtrl.MaxAssetLevel)
end


function DecorationDisplayCtrl:AddPartnerStay(partnerCtrl,station)
	if station then
        self.workEntity[partnerCtrl.uniqueId] = station.stationIndex
	end
end

function DecorationDisplayCtrl:RemovePartnerStay(partnerCtrl)
	if partnerCtrl then
        self.workEntity[partnerCtrl.uniqueId] = nil
	end
end
function DecorationDisplayCtrl:CheckEmptyStation(targetSize,position)
	
	if self[targetSize] then
		
		local targetIndex
		local minDist = math.huge
		for i = 1, self:GetMaxStaffNum(), 1 do
			local find = false
			for k, v in pairs(self.workEntity) do
				if i == v %10 then
					find = true
				end
			end
			if not find then
				return true
			end
		end
		
	end
end
function DecorationDisplayCtrl:GetAnyStation(targetSize,position)

	if self[targetSize] then

		local targetIndex
		local minDist = math.huge
		local targetUnique
		for i = 1, self:GetMaxStaffNum(), 1 do
			local unique
			for k, v in pairs(self.workEntity) do
				if i == v %10 then
					unique = k
				end
			end
			local dist = Vec3.Distance(position,self[targetSize][i].transform.position)
			if dist < minDist then
				minDist = dist
				targetIndex = i
				targetUnique = unique
			end
		end
		if targetIndex then
			local navTarget = nil
			if self.navPos and self.navPos[targetIndex] then
				navTarget = self.navPos[targetIndex]
			end
			return {transform = self[targetSize][targetIndex].transform,stationIndex = FightEnum.WorkPlaceSize[targetSize] * 10 + targetIndex,navTarget = navTarget,unique = targetUnique}
		end

	end
end
function DecorationDisplayCtrl:GetEmptyStation(targetSize,position)
	
	if self[targetSize] then
		
		local targetIndex
		local minDist = math.huge
		for i = 1, self:GetMaxStaffNum(), 1 do
			local find = false
			for k, v in pairs(self.workEntity) do
				if i == v %10 then
					find = true
				end
			end
			if not find then
				local dist = Vec3.Distance(position,self[targetSize][i].transform.position)
				if dist < minDist then
					minDist = dist
					targetIndex = i
				end
			end
		end
		if targetIndex then
			local navTarget = nil
			if self.navPos and self.navPos[targetIndex] then
				navTarget = self.navPos[targetIndex]
			end
			return {transform = self[targetSize][targetIndex].transform,stationIndex = FightEnum.WorkPlaceSize[targetSize] * 10 + targetIndex,navTarget = navTarget}
		end
		
	end
end

function DecorationDisplayCtrl:Update()
	if not self.entity.displayComponent then
		return
	end
	if TableUtils.GetTabelLen(self.workEntity) > 0 then
		self.entity.displayComponent:Display(1)
	else
		self.entity.displayComponent:Display(0)
	end
	
	if self.entity.displayComponent:GetDisplayType() == 1 then
		self.entity.displayComponent:ChangeState(1)
	else
		self.entity.displayComponent:ChangeState(0)
	end

	if self.entity.displayComponent.stateEffectList and next(self.entity.displayComponent.stateEffectList) then
		for k, v in pairs(self.entity.displayComponent.stateEffectList) do
			if v.displayComponent then
				v.displayComponent:Display(TableUtils.GetTabelLen(self.workEntity) > 0 and 1 or 0)
			end
		end
	end
end


function DecorationDisplayCtrl:UpdatePartnerDisaplay()

	
	self.partnerInfo = self.displayManager:GetPartnerWorkInfo(self.uniqueId)
	
end

function DecorationDisplayCtrl:Unload()
	for k, v in pairs(self.workEntity) do
		local displayCtrl = self.displayManager:GetDisplayCtrl(k)
		if  displayCtrl then
			displayCtrl:ClearWorkDecoration()
		end
	end
	if self.workTips then
		BehaviorFunctions.ShowWorkHeadTips(self.entity.instanceId, false)
	end
end

function DecorationDisplayCtrl:__cache()
	self:Unload()
	self.entity = nil
end

function DecorationDisplayCtrl:__delete()

end
