DistanceLifeBarObj = BaseClass("DistanceLifeBarObj", LifeBarObjBase)

function DistanceLifeBarObj:InitData()
	self.squareDistance = 99999
	self.forceShow = false
	self.leftTime = 0
	self.camera = CameraManager.Instance.mainCameraComponent
	self.cameraTransform = self.camera.transform
	self.squareDetailDistance = self.config.DetailDistance^2
	self.squareSimpleDistance = self.config.SimpleDistance^2
	
	self.canvas = self.gameObject:GetComponent(Canvas)
	if self.canvas then
		self.canvas.overrideSorting = true
	end

	self.effectUtil = self.ElementIcon:GetComponent(EffectUtil)
end

function DistanceLifeBarObj:LogicUpdate()
	self.squareDistance = Vec3.SquareDistance(self.cameraTransform.position, self.entity.transformComponent.position)
	
	local timeScale = self.entity.timeComponent:GetTimeScale()
	self.leftTime = self.leftTime - (FightUtil.deltaTime * timeScale)
	self.forceShow = self.leftTime >= 0

	if self:CheckShowDetail() then
		local sortingOrder = math.floor(-self.squareDistance)
		self.canvas.sortingOrder = sortingOrder
		self.effectUtil:SetSortingOrder(sortingOrder + 1)
	end
end

function DistanceLifeBarObj:UpdateShow(showElementBar)
	self.leftTime = self.config.ShowTime * 10000
end

function DistanceLifeBarObj:CheckShowDetail()
	if not self.forceShow and self.squareDistance <= self.squareDetailDistance then
		return true
	end
	
	return self.forceShow
end

function DistanceLifeBarObj:CheckShowSimple()
	if self.forceShow then
		return false
	end
	
	return self.squareDistance <= self.squareSimpleDistance and self.squareDistance > self.squareDetailDistance
end

function DistanceLifeBarObj:CheckShowLevel()
	return self.squareDistance <= self.squareSimpleDistance
end

function DistanceLifeBarObj:OnObjCache()
	self.squareDistance = 99999
	self.forceShow = false
	self.leftTime = 0
	self.camera = nil
	Fight.Instance.objectPool:Cache(DistanceLifeBarObj,self)
end