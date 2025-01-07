---@class ClientLifeBarComponent
ClientLifeBarComponent = BaseClass("ClientLifeBarComponent",PoolBaseClass)

local LifeBarType = {
	ShowIfAttached = 1,	
	ShowByDistance = 2,	
}

function ClientLifeBarComponent:__init()

end

function ClientLifeBarComponent:Init(clientFight,clientEntity,config)
	self.clientFight = clientFight
	self.clientEntity = clientEntity
	self.config = config
end

function ClientLifeBarComponent:LateInit()
	self:InitLifeBar()
	if self.lifeBarObj and self.lifeBarObj.LateInit then
		self.lifeBarObj:LateInit()
	end
end

function ClientLifeBarComponent:InitLifeBar()
	if self.config.ShowType == LifeBarType.ShowIfAttached then
		self.lifeBarObj = self.clientFight.fight.objectPool:Get(AttackedLifeBarObj)
	elseif self.config.ShowType == LifeBarType.ShowByDistance then
		self.lifeBarObj = self.clientFight.fight.objectPool:Get(DistanceLifeBarObj)
	end
	
	local root = self.clientFight.lifeBarManager.lifeBarRoot.transform
	self.clientFight.lifeBarManager:ShowLifeBar(self.clientEntity.entity, self.lifeBarObj)
	self.lifeBarObj:Init(self.clientEntity, root, self.config)
end

function ClientLifeBarComponent:Update()
	if not self.clientEntity or not self.clientEntity.entity then
		return 
	end
	if self.lifeBarObj then
		self.lifeBarObj:Update()
	end
end

function ClientLifeBarComponent:SetLifeBarForceVisibleType(visibleType)
	if self.lifeBarObj then
		self.lifeBarObj:SetLifeBarForceVisibleType(visibleType)
	end
end

function ClientLifeBarComponent:UpdateLifeBar(show)
	self.lifeBarObj:SuperFunc("UpdateShow", true, show)
end

function ClientLifeBarComponent:DelayDeathHide(delay)
	if self.lifeBarObj then
		self.lifeBarObj:DelayDeathHide(delay)
	end
end

function ClientLifeBarComponent:UpdateAssassinTip(attackId, hitId, skillId, magicId, perfectMagicId)
	if self.lifeBarObj then
		self.lifeBarObj:UpdateAssassinTip(attackId, hitId, skillId, magicId, perfectMagicId)
	end
end

function ClientLifeBarComponent:HideAssassinTip(attackId, hitId)
	if self.lifeBarObj then
		self.lifeBarObj:HideAssassinTip(attackId, hitId)
	end
end


function ClientLifeBarComponent:OnCache()
	self.clientFight.fight.objectPool:Cache(ClientLifeBarComponent,self)
end

function ClientLifeBarComponent:__cache()
	if self.lifeBarObj then
		self.lifeBarObj:Cache()
	end
	self.lifeBarObj = nil
end

function ClientLifeBarComponent:__delete()
	self.clientFight = nil
	self.clientEntity = nil
	
	if self.lifeBarObj then
		self.lifeBarObj:DeleteMe()
		self.lifeBarObj = nil
	end
end

function ClientLifeBarComponent:UpdateLifebarConcludePrecent()
	if self.lifeBarObj then
		self.lifeBarObj:UpdateLifebarConcludePrecent()
	end
end