AttackedLifeBarObj = BaseClass("AttackedLifeBarObj", LifeBarObjBase)

function AttackedLifeBarObj:InitData()
	self.leftTime = 0
end

function AttackedLifeBarObj:LogicUpdate()
	local timeScale = self.entity.timeComponent:GetTimeScale()
	self.leftTime = self.leftTime - (FightUtil.deltaTime * timeScale)
end

function AttackedLifeBarObj:UpdateShow(showElementBar)
	self.leftTime = self.config.ShowTime * 10000
end

function AttackedLifeBarObj:CheckShowDetail()
	if self.leftTime <= 0 or not self.gameObject.activeSelf then
		return false
	end
	
	return true
end

function AttackedLifeBarObj:CheckShowSimple()
	return false
end

function AttackedLifeBarObj:CheckShowLevel()
	return false
end

function AttackedLifeBarObj:OnObjCache()
	self.leftTime = 0
	Fight.Instance.objectPool:Cache(AttackedLifeBarObj,self)
end