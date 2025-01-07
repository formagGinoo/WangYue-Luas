---@class SyncComponent
SyncComponent = BaseClass("SyncComponent",PoolBaseClass)

function SyncComponent:__init()
end

function SyncComponent:OnCache()
	self.fight.objectPool:Cache(SyncComponent,self)
end

function SyncComponent:__delete()
end
