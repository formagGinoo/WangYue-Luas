CoreUILogic1002 = BaseClass("CoreUILogic1002", CoreUIBase)

local GradurationNum = 48 --刻度数，根据UI来
local QuadGradurationNum = 12 --单个部分的刻度数
local QuadrantOffset = { 0, 0.002, -0.002, 0, 0 } --每个部分的偏移值，首位给0使用

local IntervalOffset = 0.013 --间隔的偏移值
local PerGradurationOffset = 0.0187 --单个刻度的偏移值

local AimStateFixedPosition = Vec3.New(-135, -165, 0) --激活时的固定位置

function CoreUILogic1002:OnInit()
	-- self.gradurationEffect = {}
	-- if self.ui["22091"] then
	-- 	local parent = self.ui["22091"].transform:Find("Positon")
	-- 	if parent then
	-- 		for i = 0, parent.childCount - 1 do
	-- 			self.gradurationEffect[i + 1] = parent:GetChild(i)
	-- 		end
	-- 	end
	-- end
	
	self:SwitchCoreUIType(1)
end

function CoreUILogic1002:GetPercent(value, maxValue)
	local curGradurationNum = math.floor(value / (maxValue / GradurationNum))

	local quadrant = math.ceil(curGradurationNum / QuadGradurationNum)
	local percent = IntervalOffset * (2 * quadrant - 1) + PerGradurationOffset * curGradurationNum + QuadrantOffset[quadrant + 1]
	percent = curGradurationNum % QuadGradurationNum == 0 and curGradurationNum / GradurationNum or percent

	return percent, quadrant, curGradurationNum
end

function CoreUILogic1002:UpdatePercent(value, maxValue)
	self.value = value
	self.maxValue = maxValue
	local percent, quadrant, curGradurationNum = self:GetPercent(value, maxValue)
	local oldPercent = self.coreProcess_img.fillAmount

	self.coreProcess_img.fillAmount = percent
	self.coreQuadrant_img.fillAmount = quadrant * 0.2

	-- if oldPercent ~= percent then
	-- 	for i = 1, GradurationNum do
	-- 		self:SetObjActive(self.gradurationEffect[i].gameObject, i <= curGradurationNum)
	-- 	end
	-- end
	if not self.coreActive and self.value == self.maxValue then
		self:UpdateEffect("CoreUI1002_man", true)
	end
end

local TempVec = Vec3.New()
function CoreUILogic1002:GetCyclePos()
	TempVec:SetA(self.locationOffset)
	TempVec:Add(self.locationPoint.transform.position)
	local sp = UtilsBase.WorldToUIPointBase(TempVec.x, TempVec.y, TempVec.z)
	sp = sp + self.screenOffset
	if self.belongEntity.stateComponent:IsState(FightEnum.EntityState.Aim) then
		sp = AimStateFixedPosition
	end
	return sp
end


function CoreUILogic1002:SwitchCoreUIType(type)
	local active = type == 2
	if self.coreActive and self.coreActive == active then
		return
	end

	self.coreActive = active
	self.ui.ActiveIcon:SetActive((self.value == self.maxValue) or self.ui["CoreUI1002_daojishi"].activeSelf)
	self.ui.NormalIcon:SetActive(not (self.value == self.maxValue) or not self.coreActive)
	self.ui.ActiveProcess:SetActive(active)
	self.ui.NormalProcess:SetActive(not active)
	self.ui.ActiveQuadrant:SetActive(active)
	self.ui.NormalQuadrant:SetActive(not active)

	local quadrantPercent, processPercent = 0, 0
	if self.coreProcess_img then
		quadrantPercent = self.coreQuadrant_img.fillAmount
		processPercent = self.coreProcess_img.fillAmount
	end
	
	self.coreQuadrant_img = active and self.ui.ActiveQuadrant_img or self.ui.NormalQuadrant_img
	self.coreProcess_img = active and self.ui.ActiveProcess_img or self.ui.NormalProcess_img
	
	self.coreQuadrant_img.fillAmount = quadrantPercent
	self.coreProcess_img.fillAmount = processPercent
end

function CoreUILogic1002:ShowEffect(entity, index, active)
	if entity.entityId ~= 1002 then
		return
	end
	if index == 1 then
		self:SetObjActive(self.ui.CoreUI1002_xuli, active)
	end
end

function CoreUILogic1002:Cache()
	-- self.gradurationEffect = {}
	Fight.Instance.objectPool:Cache(CoreUILogic1002,self)
end