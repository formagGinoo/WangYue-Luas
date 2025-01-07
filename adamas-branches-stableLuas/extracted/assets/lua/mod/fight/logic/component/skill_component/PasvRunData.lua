PasvRunData = BaseClass("PasvRunData",PoolBaseClass)

function PasvRunData:__init()
    self.pasvComponent = nil
    self.pasvId = 0
    self.frame = 0
    self.frameEvent = nil
    self.totalFrame = 0
    self.isCancel = false
end

function PasvRunData:__delete()

end

function PasvRunData:Init(pasvComponent,pasvId)
    self.pasvComponent = pasvComponent
    self.pasvId = pasvId
    self.frame = 0
    self.frameEvent = self.pasvComponent.fight.objectPool:Get(FrameEventComponent)
	local pasvConfig = self.pasvComponent.pasvConfig[pasvId]
	--assert(pasvConfig, "pasvConfig null pasvId:"..pasvId)
    self.totalFrame = pasvConfig.TotalFrame
    self.frameEvent:Init(self.pasvComponent.fight,self.pasvComponent)
end

function PasvRunData:__cache()
    if self.frameEvent then
        self.pasvComponent.fight.objectPool:Cache(FrameEventComponent,self.frameEvent)
        self.frameEvent = nil
    end

    self.pasvComponent = nil
end