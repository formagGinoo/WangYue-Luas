PartnerDisplayCtrl = BaseClass("PartnerDisplayCtrl",PoolBaseClass)

function PartnerDisplayCtrl:__init()

end

function PartnerDisplayCtrl:Init(fight, entityManager, displayManager, uniqueId,loadfuc)
	self.fight = fight
	self.entityManager = entityManager
	self.displayManager = displayManager
	self.uniqueId = uniqueId
	self.loadfuc = loadfuc

	self.isLoad = false
	self.localDuration = nil
	self.partnerInfo,self.templateId = self.displayManager:GetPartnerWorkInfo(self.uniqueId)

	local partnerCfg = Config.DataPartnerMain.Find[self.templateId]
	self.partnerIcon = partnerCfg.head_icon
	self.partnerName = partnerCfg.name

	self.interactIns = 99999
	local entityId = PartnerBagConfig.GetPartnerWorkConfig(self.templateId).showentity_id

	self:Load(entityId)
	self.interactItemsMap = {}
end

function PartnerDisplayCtrl:ClearInteractItems()
	if not self.entity then
		return
	end
	for i, v in pairs(self.interactItemsMap) do
		BehaviorFunctions.WorldInteractRemove(self.entity.instanceId,v)
	end
	TableUtils.ClearTable(self.interactItemsMap)
end


function PartnerDisplayCtrl:InteractClick(interactId)
	if not self.entity then
		return
	end
	for i, v in pairs(self.interactItemsMap) do
		if v == interactId then
			local interactItems = self.displayManager:GetInteractItems(1,self.uniqueId)
			if interactItems and interactItems[i] and interactItems[i].clickFunc then
				interactItems[i].clickFunc()
			end
			
			if interactItems and interactItems[i] and interactItems[i].clickClose then
				BehaviorFunctions.WorldInteractRemove(self.entity.instanceId,interactId) --移除
			end
		end
	end
end

function PartnerDisplayCtrl:SetInteractActive(ison)
	
	if not self.entity then
		return
	end
	self:ClearInteractItems()
	if ison then
		local interactItems = self.displayManager:GetInteractItems(1,self.uniqueId)
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


function PartnerDisplayCtrl:GetTemplateId()
	return self.templateId
end

function PartnerDisplayCtrl:GetSize()
	if self.entity then
		return self.entity.displayComponent:GetBodyily()
	end
end

function PartnerDisplayCtrl:ClearClientEvent()
	EventMgr.Instance:Fire(EventName.PartnerDisplayUpdate, self.entity.instanceId, nil,nil,nil,nil,true)
end

function PartnerDisplayCtrl:Update()
	if not self.isLoad then
		return
	end
	
	-- 本地工作中不进行刷新
	if self.localDuration then
		self.localDuration = self.localDuration - FightUtil.deltaTimeSecond
		if self.localDuration <= 0 then
			self:ClearClientEvent()
			self:ClearWorkDecoration()
			self.localDuration = nil
			self.needRefresh = true
		else
			return
		end
	end
	
	if not self.needRefresh then
		return
	end


	self:DoUpdatePartnerWork()

end


function PartnerDisplayCtrl:GetWorkInUniques()
	if self.partnerInfo then
		local uniqueId = 0
		if self.partnerInfo.status == 1 then
			uniqueId = self.partnerInfo.work_decoration_id
		elseif self.partnerInfo.status == 2 or self.partnerInfo.status == 3 then
			uniqueId = self.partnerInfo.status_decoration_id
		end
		return uniqueId
	end
	return 0
	
end

function PartnerDisplayCtrl:DoUpdatePartnerWork()

	if self.partnerInfo.status ~= 0 then
		-- 获取目标工作台
		local uniqueId = self:GetWorkInUniques()
		
		local decorationCtrl
		
		if uniqueId ~= 0 then
			decorationCtrl = self.displayManager:GetDecorationCtrl(uniqueId)
		end

		-- 获取工位
		if not decorationCtrl then
			-- 后端有交互对象，如果前端找不到位置，需要持续刷新等待
			self.needRefresh = true
			if self.workDecoration then
				self:ClearWorkDecoration()
			end
			EventMgr.Instance:Fire(EventName.PartnerDisplayUpdate, self.entity.instanceId, nil)
		else
			if decorationCtrl:CheckInStation(self) then
				self.needRefresh = false
			else
				local station = decorationCtrl:GetStation(self)
				if station then
					self.needRefresh = false
					self:SetWorkDecoration(decorationCtrl,station)
				else
					-- 后端有交互对象，如果前端找不到位置，需要持续刷新等待
					self.needRefresh = true
					if self.workDecoration then
						self:ClearWorkDecoration()
						EventMgr.Instance:Fire(EventName.PartnerDisplayUpdate, self.entity.instanceId, nil)
					end
				end
			end
		end
		
	else
		self.needRefresh = false
		self:ClearWorkDecoration()
		EventMgr.Instance:Fire(EventName.PartnerDisplayUpdate, self.entity.instanceId, nil)
	end

end
local PartnerStatusEnum = {
    [0] = "无",
    [1] = "饥饿",
    [2] = "抑郁",
    [3] = "抑郁+饥饿",
	[4] = "交互",
	[5] = "举起",
}
function PartnerDisplayCtrl:UpdateDisplay()
	self.needRefresh = true
	self.partnerInfo = self.displayManager:GetPartnerWorkInfo(self.uniqueId)
	self:UpdateStateDisplay()

	
	if self.partnerInfo then
		self:UpdateDebugContent()
	end

end


function PartnerDisplayCtrl:UpdateDebugContent()
	if self.displayManager.debug  and self.entity  then
		
		BehaviorFunctions.ShowCharacterHeadTips(self.entity.instanceId, true)
		
		BehaviorFunctions.ChangeNpcDistanceThreshold(self.entity.instanceId, 9999,9999,9999,9999)
		local uniqueId = self:GetWorkInUniques()
		local content = self.partnerName .. self.uniqueId .. " 状态 - " .. PartnerStatusEnum[self.displayManager:GetAssetPartnerState(self.uniqueId)]  .. "\n"

		local targetContent = uniqueId
		if uniqueId ~= 0 then
			local decorationCtrl = self.displayManager:GetDecorationCtrl(uniqueId)
			if decorationCtrl then
				local icon,iconDis,name,nameDis= AssetDeviceConfig.GetDecorationItemShow(decorationCtrl.templateId)
				targetContent = name.. uniqueId
			end
		end
		content = content .. "目标 - "..targetContent .. "\n"
		content = content .. "work_decoration_id - "..self.partnerInfo.work_decoration_id .. "\n"
		content = content .. "status_decoration_id - "..self.partnerInfo.status_decoration_id.. "\n"
		content = content .. "Asset - "..self.partnerInfo.asset_id .. " status - "..self.partnerInfo.status .. " speed - "..self.partnerInfo.work_speed.. "\n"
		content = content .. "饱食度 - "..self.partnerInfo.satiety  .."  ".. "San - "..self.partnerInfo.san
		BehaviorFunctions.ChangeNpcBubbleContent(self.entity.instanceId, content, 999999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.entity.instanceId, true)
	end
end

function PartnerDisplayCtrl:UpdateStateDisplay()
	
	if not self.entity then
		return
	end
	local state = self.displayManager:GetAssetPartnerState(self.uniqueId)
	
	EventMgr.Instance:Fire(EventName.UpdatePartnerDisplayState, self.entity.instanceId, state,self:GetWorkSpeed())

	
end

function PartnerDisplayCtrl:GetWorkSpeed()
	if self.partnerInfo then
		local workSpeedRange  = Config.DataPartnerWorkshow.Find[1].partner_workspeed
		local showSpeedRange  = Config.DataPartnerWorkshow.Find[1].show_speed

		local currentSpeed = MathX.Clamp(self.partnerInfo.work_speed, workSpeedRange[1], workSpeedRange[2])
		
		local playSpeed =  showSpeedRange[1] + ((currentSpeed - workSpeedRange[1])/ (workSpeedRange[2] - workSpeedRange[1]) )* (showSpeedRange[2] - showSpeedRange[1])
		return playSpeed/10000
	else 
		return 1
	end
end
-- 本地限时工作
function PartnerDisplayCtrl:SetWorkDecorationLocal(decorationCtrl,station,duration)

	self.localDuration = duration
	self:SetWorkDecoration(decorationCtrl,station,true)
end


function PartnerDisplayCtrl:ClearWorkDecoration()
	
	if not self.entity then
		return
	end
	if self.workDecoration then
		self.workDecoration:RemovePartnerStay(self)
		self.workDecoration = nil
	end
end
-- 设置目标工位
function PartnerDisplayCtrl:SetWorkDecoration(decorationCtrl,station,isClient,direct)
	
	if not self.entity then
		return
	end
	if self.workDecoration then
		self.workDecoration:RemovePartnerStay(self)
		self.workDecoration = nil
	end
	self.workDecoration = decorationCtrl
	local uniqueId
	local eventType
	local position
	local rotation
	if decorationCtrl then
		decorationCtrl:AddPartnerStay(self,station)
		position = station.transform.position
		rotation = station.transform.rotation.eulerAngles
		eventType = decorationCtrl:GetEventType()
		EventMgr.Instance:Fire(EventName.PartnerDisplayUpdate, self.entity.instanceId, decorationCtrl.uniqueId,eventType,position,rotation,isClient,direct,false,station.navTarget and station.navTarget.position)
	else
		EventMgr.Instance:Fire(EventName.PartnerDisplayUpdate, self.entity.instanceId, nil)
	end

end


function PartnerDisplayCtrl:Load(entityId)
	self.loading = true
	self.fight.clientFight.assetsNodeManager:LoadEntity(entityId, function()
		local entity
		entity = self.entityManager:CreateEntity(entityId)
		if self.loadfuc then
			self.loadfuc(entity.instanceId)
			self.loadfuc = nil
		end
		entity.buffComponent:AddState(FightEnum.EntityBuffState.ImmuneByCollision)
		entity.buffComponent:AddState(FightEnum.EntityBuffState.ImmuneToCollision)

		self.isLoad = true
		self.entity = entity
		self.loading = false
		
		local uniqueId = self:GetWorkInUniques()
		local emptyStation 
		if uniqueId ~= 0 then
			-- 获取目标工作台
			local decorationCtrl = self.displayManager:GetDecorationCtrl(uniqueId)
			-- 获取工位
			if decorationCtrl then
				local station = decorationCtrl:GetStation(self)
				if station then
					self:SetWorkDecoration(decorationCtrl,station,false,true)
				else
					--找不到位置，需要持续刷新等待
					emptyStation = true
					self.needRefresh = true
				end
			else
				LogError("前端还未生产交互目标实体，有时序问题")
				emptyStation = true
			end
		else
			emptyStation = true
		end
		if emptyStation then

			local MapPos = AssetPurchaseCtrl:GetAssetEnterPos(self.displayManager:GetPartnerAssetId())
			local navPos = BehaviorFunctions.GetRandomNavRationalPointPos( Vec3.CreateByCustom(MapPos),1,10,true)
				
			if navPos then
				entity.transformComponent:SetPosition(navPos.x, navPos.y, navPos.z)
			else
				local instanceId = BehaviorFunctions.GetCtrlEntity()
				local playerEntity = BehaviorFunctions.GetEntity(instanceId)
				local playerPos = playerEntity.transformComponent:GetPosition()
				entity.transformComponent:SetPosition(playerPos.x, playerPos.y, playerPos.z + 3)
			end
		end
		-- 添加一个交互按钮触发
		self.displayManager:AddDisplayInteract(self.uniqueId, self.partnerIcon, TI18N(self.partnerName) .."-".. TI18N("抚摸") , function()
			self:InteractClientEvent()
		end,true)

        self:UpdateStateDisplay()
		
		self:UpdateDebugContent()

	end)
end

function PartnerDisplayCtrl:GetInteractRange()
	return 0.5
end

-- 产生一个交互的本地事件
function PartnerDisplayCtrl:InteractClientEvent()

	local instanceId = BehaviorFunctions.GetCtrlEntity()
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local playerPos = entity.transformComponent:GetPosition()
	local selfPos = self.entity.transformComponent:GetPosition()
	local rotate = Quat.LookRotationA(playerPos.x - selfPos.x,playerPos.y - selfPos.y,playerPos.z - selfPos.z)
	local direct = selfPos - playerPos
	direct.y = 0
	local targetPos
	if direct:Magnitude() > self.GetInteractRange() then
		targetPos = playerPos + direct:Normalize() * self.GetInteractRange()
	else
		targetPos = selfPos
	end
	self.interactIns = self.interactIns + 1

	EventMgr.Instance:Fire(EventName.PartnerDisplayUpdate, self.entity.instanceId, self.interactIns,FightEnum.PartnerDisplayType.interact,targetPos,rotate:ToEulerAngles(),true,false,true)
	
	if self.InteractTimmer then
		LuaTimerManager.Instance:RemoveTimer(self.InteractTimmer)
	end
	self.InteractTimmer = LuaTimerManager.Instance:AddTimer(1, 4, function ()
		self:ClearClientEvent()

	end)
end

function PartnerDisplayCtrl:Unload()
	-- 解除工作台登记
	self:ClearWorkDecoration()
	if self.entity then
		self.isLoad = false
		self.entityManager:RemoveEntity(self.entity.instanceId,true)
		self.entity = nil
	end
end

function PartnerDisplayCtrl:__cache()
	
    if self.InteractTimmer then
        LuaTimerManager.Instance:RemoveTimer(self.InteractTimmer)
    end
	self:Unload()
	self.entity = nil
end

function PartnerDisplayCtrl:__delete()

end
