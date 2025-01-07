PartnerDisplayManager = BaseClass("PartnerDisplayManager")

local CtrlType = 
{
	display = 1,
	decoration = 2
}

function PartnerDisplayManager:__init(fight, entityManager)
    self.fight = fight
    self.entityManager = entityManager
	self.debug = false

	self.displayEntityCtrls = {}
	self.displayDecorationCtrls = {}
	self.removeCtrls = {}
	self.addCtrls = {}

	self.ins2DisplayCtrls = {}
	self.ins2DecorationCtrls = {}

	self.localTest = false
	self.localPartnerWork = {}
	self.localPartnerUnique = 0

	self.decorationInteractIndex = 0
	self.decorationInteractItemInfo = {}
	self.displayInteractIndex = 0
	self.displayInteractItemInfo = {}

	self.HaveInit = false

    EventMgr.Instance:AddListener(EventName.PartnerWorkUpdate, self:ToFunc("OnPartnerWorkUpdate"))
	EventMgr.Instance:AddListener(EventName.AssetDecorationInfoUpdate, self:ToFunc("OnDeviceUpdate"))
	--EventMgr.Instance:AddListener(EventName.EnterAsset, self:ToFunc("OnEnterAsset"))

end


function PartnerDisplayManager:GetInteractItems(ctrlType,uniqueid)
	if ctrlType == CtrlType.decoration then
		return self.decorationInteractItemInfo[uniqueid]
	else
		return self.displayInteractItemInfo[uniqueid]
	end
end


function PartnerDisplayManager:AddDisplayInteract(uniqueid, icon, text, clickFunc, clickClose)
	return self:DoAddInteract(CtrlType.display,uniqueid, icon, text, clickFunc, clickClose)
end

function PartnerDisplayManager:RemoveDisplayInteract(uniqueid,interactId)
	self:DoRemoveInteract(CtrlType.display,uniqueid,interactId)
end

function PartnerDisplayManager:RemoveDisplayInteractAll(uniqueid)
	self:DoRemoveInteract(CtrlType.display,uniqueid)
end

function PartnerDisplayManager:AddDecorationInteract(uniqueid, icon, text, clickFunc, clickClose)
	return self:DoAddInteract(CtrlType.decoration,uniqueid, icon, text, clickFunc, clickClose)
end

function PartnerDisplayManager:RemoveDecorationInteract(uniqueid,interactId)
	self:DoRemoveInteract(CtrlType.decoration,uniqueid,interactId)
end

function PartnerDisplayManager:RemoveDecorationInteractAll(uniqueid)
	self:DoRemoveInteract(CtrlType.decoration,uniqueid)
end

function PartnerDisplayManager:DoAddInteract(ctrlType,uniqueid, icon, text, clickFunc, clickClose)
	local result 
	if ctrlType == CtrlType.decoration then
		self.decorationInteractItemInfo[uniqueid] = self.decorationInteractItemInfo[uniqueid] or {}
		self.decorationInteractIndex = self.decorationInteractIndex + 1
		self.decorationInteractItemInfo[uniqueid][self.decorationInteractIndex] = {index = self.decorationInteractIndex,icon = icon,text = text,clickFunc = clickFunc,clickClose = clickClose}
		result = self.decorationInteractIndex

	elseif ctrlType == CtrlType.display then
		self.displayInteractItemInfo[uniqueid] = self.displayInteractItemInfo[uniqueid] or {}
		self.displayInteractIndex = self.displayInteractIndex + 1
		self.displayInteractItemInfo[uniqueid][self.displayInteractIndex] = {index = self.displayInteractIndex,icon = icon,text = text,clickFunc = clickFunc,clickClose = clickClose}
		result = self.displayInteractIndex
	end
	Fight.Instance.entityManager:CallBehaviorFun("OnUpdateDiaplayInteractItem", uniqueid)

	return result
end

function PartnerDisplayManager:DoRemoveInteract(ctrlType,uniqueid,interactId)

	if ctrlType == CtrlType.decoration then
		if self.decorationInteractItemInfo[uniqueid] then
			if not interactId then
				TableUtils.ClearTable(self.decorationInteractItemInfo[uniqueid])
			else
				self.decorationInteractItemInfo[uniqueid][interactId] = nil
			end
		end
	elseif ctrlType == CtrlType.display then
		if self.displayInteractItemInfo[uniqueid] then
			if not interactId then
				TableUtils.ClearTable(self.displayInteractItemInfo[uniqueid])
			else
				self.displayInteractItemInfo[uniqueid][interactId] = nil
			end
		end
		
	end
	Fight.Instance.entityManager:CallBehaviorFun("OnUpdateDiaplayInteractItem", uniqueid)
end


function PartnerDisplayManager:InteractClick(instanceId,interactId)
	local decorationCtrl = self:GetDecorationByEntity(instanceId)
	if decorationCtrl then
		decorationCtrl:InteractClick(interactId)
	end
	
	local displayCtrl = self:GetDisplayByEntity(instanceId)
	if displayCtrl then
		displayCtrl:InteractClick(interactId)
	end
end


function PartnerDisplayManager:SetInteractActive(instanceId,ison)

	local decorationCtrl = self:GetDecorationByEntity(instanceId)
	if decorationCtrl then
		decorationCtrl:SetInteractActive(ison)
		return true
	end
	
	local displayCtrl = self:GetDisplayByEntity(instanceId)
	if displayCtrl then
		displayCtrl:SetInteractActive(ison)
		return true
	end

end



function PartnerDisplayManager:AddLocalDecoration(templateId,distance,callback)
	if not self.localTest then
		return
	end
	local config = Config.DataDecorationItem.Find[templateId]
	if config then
		self.fight.clientFight.assetsNodeManager:LoadEntity(config.entity_id, function()
			local entity
			entity = self.entityManager:CreateEntity(config.entity_id)
			
			local instanceId = BehaviorFunctions.GetCtrlEntity()
			local playerEntity = BehaviorFunctions.GetEntity(instanceId)
			local playerPos = playerEntity.transformComponent:GetPosition()
			--entity.transformComponent:SetPosition(navPos.x, navPos.y, navPos.z)
			entity.transformComponent:SetPosition(playerPos.x, playerPos.y, playerPos.z + distance)

			self:AddDecorationInteract(entity.instanceId, "Textures/Icon/Single/FuncIcon/Trigger_door.png", "点我", function()
				LogError("点我干啥")
			end)

			self:AddDecorationEntity(entity.instanceId,entity,templateId)
			if callback then
				callback(entity.instanceId)
			end
		end)
	end
end

function PartnerDisplayManager:AddLocalDisplayPartner(templateId,targetWork,state)
	if not self.localTest then
		return
	end
	self.localPartnerUnique = self.localPartnerUnique + 1
	self.localPartnerWork[self.localPartnerUnique] = 
	{
		satiety = 1,
		san = 2,
		asset_id = 1,
		status = targetWork and 1 or 0,
		work_speed = 10000;
		work_decoration_id = targetWork or 0,
		status_decoration_id = 0,
		state = state or 0,
		templateId = templateId
	}
	self:AddDisplayEntity(self.localPartnerUnique)
end

function PartnerDisplayManager:LocalChangePartnerWork(partnerUnique,targetWorkEntityIns)
	if not self.localTest then
		return
	end
	self.localPartnerUnique = self.localPartnerUnique + 1
	if self.localPartnerWork[partnerUnique] then
		
		self.localPartnerWork[partnerUnique].status = targetWorkEntityIns and 1 or 0
		self.localPartnerWork[partnerUnique].work_decoration_id = targetWorkEntityIns or 0

        EventMgr.Instance:Fire(EventName.PartnerWorkUpdate, partnerUnique)
	end
end


--None = 0, --无
--Hunger = 1, --饥饿
--Sad = 2, --抑郁
--HungerAndSad = 3, --抑郁+饥饿
function PartnerDisplayManager:ChangePartnerState(partnerUnique,state)
	if not self.localTest then
		return
	end
	self.localPartnerUnique = self.localPartnerUnique + 1
	if self.localPartnerWork[partnerUnique] then
		self.localPartnerWork[partnerUnique].state = state

        EventMgr.Instance:Fire(EventName.PartnerWorkUpdate, partnerUnique)
	end
end



function PartnerDisplayManager:GetAssetPartnerState(partnerUnique)
	if self.localTest then
		if self.localPartnerWork[partnerUnique] then
			return self.localPartnerWork[partnerUnique].state
		end
	end
	return mod.PartnerBagCtrl:GetAssetPartnerState(partnerUnique)
end

function PartnerDisplayManager:StartFight()
	
	if self.localTest then
		
		self:AddLocalDecoration(1001004, -10)
		
			--self:AddLocalDisplayPartner(3002012,nil,1)
		self:AddLocalDecoration(1001002, -20,
		function (instanceId)
			self:AddLocalDisplayPartner(3002012,instanceId,1)
		end)

	end
	
end


function PartnerDisplayManager:InitDiaplyPartner()
	
	local assetId = self:GetPartnerAssetId()
	if assetId then
		local partners = mod.AssetPurchaseCtrl:GetAssetPartnerList(assetId)
		if partners then
			for i, v in ipairs(partners) do
				self:AddDisplayEntity(v)
			end
		end
		
	end
	self.HaveInit = true
end

function PartnerDisplayManager:GetDisplayCtrl(uniqueId)
	return self.displayEntityCtrls[uniqueId]
end


function PartnerDisplayManager:GetDecorationCtrl(uniqueId)
	return self.displayDecorationCtrls[uniqueId]
end

function PartnerDisplayManager:GetPartnerAssetId()
	
	local result = mod.AssetPurchaseCtrl:GetCurAssetId()
	if self.localTest and not result then
		return 1
	end
	return result
end

function PartnerDisplayManager:GetAssetLevel()
	
	local assetId = self:GetPartnerAssetId()

	if assetId then
		local result = mod.AssetPurchaseCtrl:GetAssetLevel(assetId)
		if self.localTest and not result then
			return 5
		end
		return result
	end
end

-- 添加演出实体
function PartnerDisplayManager:AddDisplayEntity(uniqueId)
	if self.removeCtrls[uniqueId] then
		self.removeCtrls[uniqueId] = nil
	end
	if self.addCtrls[uniqueId] then
		return
	end
	if self.displayEntityCtrls[uniqueId] then
		return
	end

	self.addCtrls[uniqueId] = {uniqueId = uniqueId}
end

function PartnerDisplayManager:AddDecorationEntity(uniqueId,decorationEntity,templateId)
	if self.displayDecorationCtrls[uniqueId] then
		LogError("重复加载装饰演出实体 = ".. uniqueId)
		return
	end

	local ctrl = self.fight.objectPool:Get(DecorationDisplayCtrl)
	ctrl:Init(self.fight ,self.entityManager ,self ,uniqueId ,decorationEntity, templateId)
	self.displayDecorationCtrls[uniqueId] = ctrl
	self.ins2DecorationCtrls[decorationEntity.instanceId] = uniqueId
end

function PartnerDisplayManager:RemoveDecorationEntity(uniqueId)
	if self.displayDecorationCtrls[uniqueId] then
		
		local ctrl = self.displayDecorationCtrls[uniqueId] 
		self.displayDecorationCtrls[uniqueId] = nil
		self.ins2DecorationCtrls[ctrl.entity.instanceId] = nil
		self.fight.objectPool:Cache(DecorationDisplayCtrl,ctrl)
		
		self:RemoveDecorationInteractAll(uniqueId)
	end
end

function PartnerDisplayManager:RemoveDisplayEntityByID(uniqueId)
	
	self:RemoveDisplayInteractAll(uniqueId)
	if self.addCtrls[uniqueId] then
		self.addCtrls[uniqueId] = nil
	end
	if not self.displayEntityCtrls[uniqueId] then
		return
	end
	self.removeCtrls[uniqueId] = 1
end

function PartnerDisplayManager:Update()
	
	for k, v in pairs(self.removeCtrls) do
		local ctrl = self.displayEntityCtrls[k]
		self.displayEntityCtrls[k] = nil
		if ctrl then
			if ctrl.entity then
				self.ins2DisplayCtrls[ctrl.entity.instanceId] = nil
			end
			self.fight.objectPool:Cache(PartnerDisplayCtrl,ctrl)
		end
	end
	for k, v in pairs(self.addCtrls) do
		if self.displayEntityCtrls[k] then
			LogError("重复加载演出实体 = ".. k)
		end
        local ctrl
	
		local partnerInfo,templateId = self:GetPartnerWorkInfo(v.uniqueId)
		local config = PartnerBagConfig.GetPartnerWorkConfig(templateId)
		if partnerInfo and config and config.showentity_id ~= 0 then
			ctrl = self.fight.objectPool:Get(PartnerDisplayCtrl)

			ctrl:Init(self.fight ,self.entityManager ,self ,v.uniqueId,function (ins)

				self.ins2DisplayCtrls[ins] = v.uniqueId
			end)

			self.displayEntityCtrls[k] = ctrl
		end

	end
	
	
	for k, ctrl in pairs(self.displayEntityCtrls) do
		ctrl:Update()
	end
	
	for k, ctrl in pairs(self.displayDecorationCtrls) do
		ctrl:Update()
	end

    TableUtils.ClearTable(self.addCtrls)
	TableUtils.ClearTable(self.removeCtrls)
end

-- 更新月灵实体演出状态
function PartnerDisplayManager:OnPartnerWorkUpdate(uniqueId)
	if not self.HaveInit then
		return
	end
	local workInfo = self:GetPartnerWorkInfo(uniqueId)
	local delete = workInfo.asset_id == 0
    if delete then
		self:RemoveDisplayEntityByID(uniqueId)
    else
		if workInfo.asset_id == self:GetPartnerAssetId() then
			if not self.displayEntityCtrls[uniqueId] then
				self:AddDisplayEntity(uniqueId)
			else
				self.displayEntityCtrls[uniqueId]:UpdateDisplay()
			end
		end
    end
end

--更新物件实体演出状态
function PartnerDisplayManager:OnDeviceUpdate(assetId, deviceUniqueId)
	if self.displayDecorationCtrls[deviceUniqueId] then
		self.displayDecorationCtrls[deviceUniqueId]:UpdateDisplay()
	end
end

function PartnerDisplayManager:UpdateAllDisplayDecoration()
	for uniqueId, v in pairs(self.displayDecorationCtrls) do
		self.displayDecorationCtrls[uniqueId]:UpdateDisplay()
	end
end


-- 获取月灵信息
function PartnerDisplayManager:GetPartnerWorkInfo(uniqueId)
	if self.localTest then
		if self.localPartnerWork[uniqueId] then
			return self.localPartnerWork[uniqueId],self.localPartnerWork[uniqueId].templateId
		end
	end
	
	return mod.PartnerBagCtrl:GetPartnerWorkInfo(uniqueId),mod.PartnerBagCtrl:GetPartnerDataByUniqueId(uniqueId).template_id
end


function PartnerDisplayManager:GetDecorationByEntity(ins)
	local unique = self.ins2DecorationCtrls[ins]
	if unique then
		return self:GetDecorationCtrl(unique)
	end
end

function PartnerDisplayManager:GetDisplayByEntity(ins)
	local unique = self.ins2DisplayCtrls[ins]
	if unique then
		return self:GetDisplayCtrl(unique)
	end
end

-- 获取装饰信息
function PartnerDisplayManager:TrySetWork(entityId,targetEntityId,unique)
	local partnerCtrl
	local decorationCtrl
	for k, ctrl in pairs(self.displayEntityCtrls) do

		if ctrl.entity.instanceId == entityId then
			partnerCtrl = ctrl
		end
	end


	for k, ctrl in pairs(self.displayDecorationCtrls) do

		if ctrl.entity.instanceId == targetEntityId then
			decorationCtrl = ctrl
		end
	end


	if partnerCtrl and decorationCtrl then

		if not self.localTest then
			if not unique then
				-- 替换空位会进行本地演出
				if mod.PartnerCenterCtrl:SetPartnerWorkInDevice(partnerCtrl.uniqueId, decorationCtrl.uniqueId) then
				end
				local station = decorationCtrl:GetStation(partnerCtrl)
				if station then
					partnerCtrl:SetWorkDecorationLocal(decorationCtrl,station,5)
				end
			else
				-- 互换没有本地演出
				mod.PartnerCenterCtrl:ReplacePartnerWorkDevice(partnerCtrl.uniqueId, unique)
			end
		else
			local station = decorationCtrl:GetStation(partnerCtrl)
			if station then
				partnerCtrl:SetWorkDecorationLocal(decorationCtrl,station,5)
			end
		end
	end
end

function PartnerDisplayManager:GetReachDistance(entity,targetEntity)

end

function PartnerDisplayManager:ClearDisplay()
    
	for k, v in pairs(self.displayEntityCtrls) do
		local ctrl = self.displayEntityCtrls[v]
		self.fight.objectPool:Cache(PartnerDisplayCtrl,ctrl)
		self.displayEntityCtrls[v] = nil
	end
	
	for k, v in pairs(self.displayDecorationCtrls) do
		local ctrl = self.displayDecorationCtrls[v]
		self.fight.objectPool:Cache(DecorationDisplayCtrl,ctrl)
		self.displayDecorationCtrls[v] = nil
	end
end



function PartnerDisplayManager:__delete()
	
    EventMgr.Instance:RemoveListener(EventName.PartnerWorkUpdate, self:ToFunc("OnPartnerWorkUpdate"))
	EventMgr.Instance:RemoveListener(EventName.AssetDecorationInfoUpdate, self:ToFunc("OnDeviceUpdate"))
	--EventMgr.Instance:RemoveListener(EventName.EnterAsset, self:ToFunc("OnEnterAsset"))
end