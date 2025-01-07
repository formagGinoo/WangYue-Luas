CoreUIBase = BaseClass("CoreUIBase", PoolBaseClass)

local DefaultFollowSpeed = 0.15

function CoreUIBase:__init()

end

function CoreUIBase:Init(entity, config, parent, sortingOrder)
	self.config = config
	self.belongEntity = entity
	self.coreDev = {1}
	self.enable = true
	self.visibleAnim = {
		play = false,
		fromValue = 0,
		toValue = 1,
		changeTime = 0,
		tickTime = 0,
	}

	self:InitConfig()
	self:InitUI(parent, sortingOrder)
	self:InitListener()
	self:OnInit()
end

function CoreUIBase:InitUI(parent, sortingOrder)
	self.ui = {}
	self.ui.gameObject = Fight.Instance.clientFight.assetsPool:Get(self.config.UIPath)
	self.ui.transform = self.ui.gameObject.transform
	self.ui.transform:SetParent(parent)
	
	self.ui.canvasGroup = self.ui.gameObject:GetComponent(CanvasGroup)
	self.ui.SetUIEffectAlpha = self.ui.gameObject:GetComponent("SetUIEffectAlpha")
	UtilsUI.GetContainerObject(self.ui.transform, self.ui)

	self.effectUtils = {}
	local effectUtils = self.ui.transform:GetComponentsInChildren(EffectUtil, true)
	for j = 0, effectUtils.Length - 1 do
		table.insert(self.effectUtils, effectUtils[j])
		effectUtils[j]:SetSortingOrder(sortingOrder + 1)
	end
	
	self:UpdateScale(self.config.Scale)
	self:SetCoreUIEnable(false)
end

function CoreUIBase:InitConfig()
	self.locationPoint = self.belongEntity.clientEntity.clientTransformComponent:GetTransform(self.config.LocationPoint)
	self.locationOffset = Vec3.New(self.config.LocationOffset[1], self.config.LocationOffset[2], self.config.LocationOffset[3])
	self.screenOffset = Vec3.New(self.config.ScreenOffset[1], self.config.ScreenOffset[2], self.config.ScreenOffset[3])
	
	self.bindRes = self.config.BindRes
end

function CoreUIBase:InitListener()
	EventMgr.Instance:AddListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
	EventMgr.Instance:AddListener(EventName.ShowCoreUIEffect, self:ToFunc("ShowEffect"))

end

function CoreUIBase:__cache()
	EventMgr.Instance:RemoveListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
	EventMgr.Instance:RemoveListener(EventName.ShowCoreUIEffect, self:ToFunc("ShowEffect"))
	self:OnReset()
	
	Fight.Instance.clientFight.assetsPool:Cache(self.config.UIPath, self.ui.gameObject)
	self.ui = nil
	self.config = nil
	self.belongEntity = nil
end

function CoreUIBase:__delete()
	EventMgr.Instance:RemoveListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
	EventMgr.Instance:RemoveListener(EventName.ShowCoreUIEffect, self:ToFunc("ShowEffect"))
	self:OnReset()
	
	self.ui = nil
	self.config = nil
	self.belongEntity = nil
end


function CoreUIBase:SetObjActive(obj, active)
	if obj.activeSelf == active then
		return
	end

	obj:SetActive(active)
end

function CoreUIBase:Lerp(from, to, percent)
	return from + (to - from) * percent
end

function CoreUIBase:EntityAttrChange(attrType, entity, oldValue, newValue)
	if entity.entityId ~= self.belongEntity.entityId or attrType ~= self.bindRes then
		return
	end
	UnityUtils.BeginSample("CoreUIBase:EntityAttrChange")
	local value, maxValue = entity.attrComponent:GetValueAndMaxValue(self.bindRes)
	self:UpdatePercent(value, maxValue)
	UnityUtils.EndSample()
end


function CoreUIBase:UpdateVisibleAnim()
	if not self.visibleAnim.play then
		return 
	end

	self.visibleAnim.tickTime = self.visibleAnim.tickTime + Global.deltaTime
	
	local percent = math.min(self.visibleAnim.tickTime / self.visibleAnim.changeTime, 1)
	percent = self:Lerp(self.visibleAnim.fromValue, self.visibleAnim.toValue, percent)
	self.ui.canvasGroup.alpha = percent
	self:UpdateEffectVisible(percent)

	if self.visibleAnim.tickTime >= self.visibleAnim.changeTime then
		self.visibleAnim.play = false
	end
end

local TempVec = Vec3.New()
function CoreUIBase:GetCyclePos()
	TempVec:SetA(self.locationOffset)
	TempVec:Add(self.locationPoint.transform.position)
	local sp = UtilsBase.WorldToUIPointBase(TempVec.x, TempVec.y, TempVec.z)
	return sp + self.screenOffset
end

function CoreUIBase:AutoUpdateCyclePosition(followSpeed)
	followSpeed = followSpeed or DefaultFollowSpeed
	local sp = self:GetCyclePos()
	local newSp = Vec3.Lerp(self.ui.transform.localPosition, sp, followSpeed)
	UnityUtils.SetLocalPosition(self.ui.transform, newSp.x, newSp.y, 0)
end

function CoreUIBase:UpdateScale(scale)
	self.ui.transform.localScale = Vector3(scale, scale, scale)
end

function CoreUIBase:UpdateEffectVisible(percent)
	for _, v in pairs(self.effectUtils) do
		v:SetKeywordValue("_mainAlpha", percent)
		v:SetKeywordValue("_BaseColor", Color(1, 1, 1, percent))
		v:SetKeywordValue("_RopeAlpha", percent)
	end
end

function CoreUIBase:UpdateVisible(visible, time, force)
	if not self.enable and not force then
		return
	end
	
	local percent = visible and 1 or 0
	local animData = self.visibleAnim
	if percent == animData.toValue and not force then
		return
	end
	if self.ui.SetUIEffectAlpha then
		self.ui.SetUIEffectAlpha.enabled = (percent < 1)
	end
	if not time or time == 0 then
		self.ui.canvasGroup.alpha = percent
		animData.toValue = percent
		self:UpdateEffectVisible(percent)
	else
		animData.play = true
		animData.fromValue = self.ui.canvasGroup.alpha
		animData.toValue = percent
		animData.tickTime = (1 - math.abs(animData.toValue - animData.fromValue)) * time
		animData.changeTime = time
	end
end

function CoreUIBase:UpdateCyclePosition(x, y, lock)
	self.posLock = lock
	if x and y then
		UnityUtils.SetLocalPosition(self.ui.transform, x, y, 0)
	end
end

function CoreUIBase:UpdateEffect(id, enable)
	if not self.enable or not self.ui[id] then
		return
	end

	self:SetObjActive(self.ui[id], enable)
end

function CoreUIBase:SetCoreUIEnable(enable)
	if enable == self.enable then 
		return 
	end
	
	self:UpdateVisible(false, 0, true)
	self.enable = enable
	self.posLock = false
	UtilsUI.SetActiveByPosition(self.ui.gameObject, enable)
end

function CoreUIBase:OnReset()
end

-------------------------------------- 这里开始根据需要重写 ------------------------------------------------------
function CoreUIBase:OnInit()
end

function CoreUIBase:ShowEffect(entity, index, active, percent, ...)

end

function CoreUIBase:Update(entity)
	if BehaviorFunctions.fight.pauseCount >= 1 then
		return
	end

	if not self.enable then
		return
	end
	
	self:UpdateVisibleAnim()
	
	if not self.posLock then
		self:AutoUpdateCyclePosition(DefaultFollowSpeed)
	end
end

function CoreUIBase:SwitchCoreUIType(type)
	
end

function CoreUIBase:UpdatePercent(value, maxValue)
	
end

function CoreUIBase:Cache()
	
end

function CoreUIBase:SetCorUIPercentDivide(...)
	if not ... then
		LogError("SetCorUIPercentDivide参数不正确, 参数为空")
		return
	end
	local total = 0
	local args = {...}
	for k, percent in pairs(args) do
		total = total + percent
	end
	if total ~= 1 then
		LogError("SetCorUIPercentDivide参数不正确, total ~= 1")
		return
	end
	self.coreDev = args
end
----------------------------------------------------------------------------------------------------------------