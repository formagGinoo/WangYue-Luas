LifeBar2DObjBase = BaseClass("LifeBar2DObjBase", PoolBaseClass)

local VisibleType = {
	None = 1,
	ForceShow = 2,
	ForceHide = 3,	
}

local HitStayTime = 1 --受击红色保留时间
local HitMaxStayTime = 3 --最长保留时间
local DecPercent = 0.2 --衰减比例
local HitShowFrame = 5 --受击闪烁时间


function LifeBar2DObjBase:__init()

end

function LifeBar2DObjBase:Init(clientEntity, parent, config)
	self.clientFight = Fight.Instance.clientFight
	self.lifeBarManager = self.clientFight.lifeBarManager
	self.clientEntity = clientEntity
	self.entity = self.clientEntity.entity
	self.attr = self.entity.attrComponent
	self.config = config
	self.lifeBarLength = self.config.LifeBarLength + 270
	self.camera = CameraManager.Instance.mainCameraComponent

	self.elementObj = {}
	self.forceVisibleType = 0
	
	self.lifeDec = 0
	self.lifeStayTime = 0
	
	self:InitUI(parent)
	
	self:InitData()
	
	EventMgr.Instance:AddListener(EventName.UpdateElementState, self:ToFunc("UpdateElementState"))
end

function LifeBar2DObjBase:LateInit()
end

function LifeBar2DObjBase:__delete()
	self:OnObjCache()
	
	if not UtilsBase.IsNull(self.gameObject) then
		GameObject.Destroy(self.gameObject)
	end

	self.clientEntity = nil
	self.gameObject = nil
	self.elementObj = {}
	
	EventMgr.Instance:RemoveListener(EventName.UpdateElementState, self:ToFunc("UpdateElementState"))
end

function LifeBar2DObjBase:Cache()
	for _, v in pairs(self.elementObj) do
		ElementItem.Recycle(v)
	end
	
	self.clientFight.assetsPool:Cache(self.config.Prefab, self.gameObject)
	self:OnObjCache()
end

function LifeBar2DObjBase:__cache()
	self.clientEntity = nil
	self.gameObject = nil
end

function LifeBar2DObjBase:SetObjActive(obj, active)
	if obj.activeSelf ~= active then
		obj:SetActive(active)
	end
end

local BarScale = 0.3
function LifeBar2DObjBase:InitUI(parent)
	self.gameObject = self.clientFight.assetsPool:Get(self.config.Prefab)
	
	self.transform = self.gameObject.transform
	self.transform:SetParent(parent)
	UnityUtils.SetLocalScale(self.transform, BarScale, BarScale, BarScale)
	UtilsUI.GetContainerObject(self.transform, self)
	self:SetObjActive(self.gameObject, true)
	
	self.rWidth = self.transform.rect.width * BarScale * 0.5
	self.rHeight = self.transform.rect.height * BarScale
	self.detailScaler = self.Detail.gameObject:GetComponent(DistanceCurveScaler)
	self.simpleScaler = self.Simple.gameObject:GetComponent(DistanceCurveScaler)
	
	local imgs = self.transform:GetComponentsInChildren(Image)
	for i = 0, imgs.Length - 1 do
		imgs[i].material = nil
	end
	
	self.height = self.entity.collistionComponent and self.entity.collistionComponent.config.Height + 0.1 or 0.1
	self.headRadius = self.config.headRadius or 0.5
	self.height = self.config.UseForceHeight and self.config.ForceHeight or self.height
	self.offset = Vec3.New(self.config.OffsetX, self.height, self.config.OffsetZ)


	if self.DetailLevel then
		local lv = self.entity.attrComponent.level
		self.DetailLevel_txt.text = lv
		self.SimpleLevel_txt.text = "Lv."..lv
	end

	self.Life_rect:SetSizeDeltaWidth(self.lifeBarLength + 10)
	self.LifeRBar_rect:SetSizeDeltaWidth(self.lifeBarLength)
	self.LifeBar_rect:SetSizeDeltaWidth(self.lifeBarLength)
	if self.Amror then
		self.Armor_rect:SetSizeDeltaWidth(self.lifeBarLength - 20)
	end
	
	--if self.clientEntity and self.entity.elementStateComponent then
		--local elementState = self.entity.elementStateComponent.elementState
		--for k, v in pairs(elementState) do
			--self:UpdateElementState(self.entity.instanceId, k, v.full, v.count, v.maxCount)
		--end
	--end
end

function LifeBar2DObjBase:Update()
	if not self.clientEntity then
		return 
	end
	local forceShow = self.forceVisibleType == VisibleType.ForceShow
	local forceHide = self.forceVisibleType == VisibleType.ForceHide

	if forceHide or (self.entity.stateComponent and self.entity.stateComponent:IsState(FightEnum.EntityState.Death)) then
		self:SetObjActive(self.gameObject, false)
		return
	end

	-- UnityUtils.BeginSample("LifeBar2DObjBase:Update")
	self:LogicUpdate()

	self:_UpdateDecLifeAnim()
	
	if forceShow or self:CheckShowDetail() then
		self:SetObjActive(self.Detail, true)
		self:SetObjActive(self.Level, self:CheckShowLevel())

		self:UpdateLifeBar()
		self:UpdateArmorBar()
		self:UpdateRestraintArrow()
	else
		self:SetObjActive(self.Detail, false)
	end
	
	if forceShow or (self:CheckShowSimple() and self:CheckShowLevel()) then
		self:SetObjActive(self.Simple, true)
	else
		self:SetObjActive(self.Simple, false)
	end

	-- UnityUtils.BeginSample("UpdateTransform")
	self:UpdateTransform()
	-- UnityUtils.EndSample()
	
	--UnityUtils.EndSample()
end

function LifeBar2DObjBase:UpdateLifeBar(hit)
	if not self.Life then
		return
	end
	local curLife = self.attr:GetValue(EntityAttrsConfig.AttrType.Life)
	local maxLife = self.attr:GetValue(EntityAttrsConfig.AttrType.MaxLife)
	if not self.lifeRecord then
		self.lifeRecord = curLife
	end

	self.LifeBar_rect:SetSizeDeltaWidth((curLife / maxLife) * self.lifeBarLength)
	
	if not hit or self.lifeRecord <= curLife then
		return 
	end
	
	if (self.lifeDec <= 0 or self.lifeStayTime <= 0) and not self.playDec then
		self.lifeStayTime = HitMaxStayTime
	end
	
	self.lifeDec = HitStayTime
	
	self.hitFrame = BehaviorFunctions.GetFightFrame()
	self.LifeWBar_rect:SetSizeDeltaWidth((curLife / maxLife) * self.lifeBarLength)
	self:SetObjActive(self.LifeWBar, true)
end

function LifeBar2DObjBase:_UpdateDecLifeAnim()
	self.lifeDec = self.lifeDec - FightUtil.deltaTimeSecond
	self.lifeStayTime = self.lifeStayTime - FightUtil.deltaTimeSecond
	
	if self.hitFrame and self.hitFrame + HitShowFrame <= BehaviorFunctions.GetFightFrame() then
		self:SetObjActive(self.LifeWBar, false)
	end
	
	if self.lifeDec > 0 and self.lifeStayTime > 0 then
		return
	end
	
	self.lifeDec = 0
	self.lifeStayTime = 0
	
	local curLife = self.attr:GetValue(EntityAttrsConfig.AttrType.Life)
	local maxLife = self.attr:GetValue(EntityAttrsConfig.AttrType.MaxLife)
	
	if not self.lifeRecord or math.abs(self.lifeRecord - curLife) < 1 then
		self.playDec = false
		return 
	end
	
	self.playDec = true

	local rPercent = (self.lifeRecord / maxLife) - DecPercent * FightUtil.deltaTimeSecond
	rPercent = math.max(curLife / maxLife, rPercent)
	self.LifeRBar_rect:SetSizeDeltaWidth(rPercent * self.lifeBarLength)
	
	self.lifeRecord = rPercent * maxLife
end

function LifeBar2DObjBase:UpdateArmorBar()
	if not self.Armor then
		return
	end

	if not self.config.ShowArmorBar then
		self:SetObjActive(self.Armor, false)
	end

	local curArmor = self.attr:GetValue(EntityAttrsConfig.AttrType.Armor)
	local maxArmor = self.attr:GetValue(EntityAttrsConfig.AttrType.MaxArmor)
	if not self.lastfillAmount or self.lastfillAmount ~=  curArmor / maxArmor then
		self.lastfillAmount = curArmor / maxArmor
		self.ArmorBar_img.fillAmount = curArmor / maxArmor
	end
end

function LifeBar2DObjBase:UpdateRestraintArrow()
	if not self.ELArrow then
		return
	end

	if self.element == -1 then
		return
	end

	if not self.element then
		self.element = -1
		if self.entity.tagComponent.npcTag ~= FightEnum.EntityNpcTag.Player and self.entity.elementStateComponent then
			self.element = self.entity.elementStateComponent.config.ElementType
		end
		self:SetObjActive(self.ELArrow, self.element ~= -1)
	end

	local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	local playerElement = player.elementStateComponent.config.ElementType
	self:SetObjActive(self.ELArrow1, FightEnum.ElementRelationDmgType[playerElement] == self.element)
	self:SetObjActive(self.ELArrow2, FightEnum.ElementRelationDmgType[self.element] == playerElement)
end

local HalfScreenWidth = Screen.width / 2
local HalfScreenHeight = Screen.height / 2
function LifeBar2DObjBase:UpdateTransform()
	local clientTransform = self.clientEntity.clientTransformComponent.transform
	local entityPos = UtilsBase.GetLuaPosition(clientTransform)
	local entityRotation = UtilsBase.GetLuaRotation(clientTransform)
	local pos = entityPos +  entityRotation * self.offset
	
	if not self.config.lockPosion then
		local camRotation = UtilsBase.GetLuaRotation(self.clientFight.cameraManager.mainCamera.transform)
		local euler = camRotation:ToEulerAngles()--会构建v3
		if euler.x > 180 then
			euler.x = 360 - euler.x
		end
		local offset = camRotation * Vec3.New(0, euler.x / 90 * self.headRadius, 0)
		pos = pos + offset
	end
	
	self.detailScaler:UpdateScale(pos.x, pos.y, pos.z)
	self.simpleScaler:UpdateScale(pos.x, pos.y, pos.z)
	
	local sp = UtilsBase.WorldToUIPointBase(pos.x, pos.y, pos.z)
	self:SetObjActive(self.gameObject, sp.z >= 0)
	if sp.z >= 0 then
		if self.config.canShowInBody then
			local sp2 =  UtilsBase.WorldToUIPointBase(entityPos.x, entityPos.y, entityPos.z)
			if sp2.z >= 0 and sp2.x < HalfScreenWidth and sp2.x > -HalfScreenWidth and 
				sp2.y < HalfScreenHeight and sp2.y > -HalfScreenHeight then
				sp.x = MathX.Clamp(sp.x, -(HalfScreenWidth - self.rWidth), (HalfScreenWidth - self.rWidth))
				sp.y = MathX.Clamp(sp.y, -(HalfScreenHeight - self.rHeight), (HalfScreenHeight - self.rHeight))
			end
		end
		
		UnityUtils.SetLocalPosition(self.gameObject.transform, sp.x, sp.y , 0)
	end

end

function LifeBar2DObjBase:UpdateElementState(instanceId, element, full, value, maxValue)
	if not self.clientEntity or not self.clientEntity.entity then
		return 
	end
	
	if instanceId ~= self.clientEntity.entity.instanceId then
		return 
	end
	
	if not self.elementObj[element] then
		self.elementObj[element] = ElementItem.Get(self.ElementGroup, element)
	end
	
	self.elementObj[element]:UpdateState(full, value, maxValue)
end

function LifeBar2DObjBase:SetLifeBarForceVisibleType(visibleType)
	self.forceVisibleType = visibleType
	if self.forceVisibleType ~= VisibleType.ForceHide then
		self:SetObjActive(self.gameObject, true)
	end
end


--重载
function LifeBar2DObjBase:InitData()
	
end

function LifeBar2DObjBase:LogicUpdate()
	
end

function LifeBar2DObjBase:UpdateShow(args)
	
end

function LifeBar2DObjBase:CheckShowDetail()
	return false
end

function LifeBar2DObjBase:CheckShowSimple()
	return false
end

function LifeBar2DObjBase:CheckShowLevel()
	return false
end

function LifeBar2DObjBase:OnObjCache()
end