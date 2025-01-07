---@class PasvComponent : PoolBaseClass
PasvComponent = BaseClass("PasvComponent",PoolBaseClass)

function PasvComponent:__init()
    self.removeQueue = {}
    self.execPasvs = List.New()
    self.eventActiveSign = {}
end

function PasvComponent:__delete()
end

function PasvComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
    self.skillComponent = entity.skillComponent
	self.pasvConfig = entity:GetComponentConfig(FightEnum.ComponentType.Pasv).Skills
end

function PasvComponent:Update()
    if next(self.removeQueue) then
        for i = #self.removeQueue, 1, -1 do
            self.fight.objectPool:Cache(PasvRunData,self.removeQueue[i].value)
            self.execPasvs:Remove(self.removeQueue[i])
        end

        for i = #self.removeQueue, 1, -1 do
            table.remove(self.removeQueue)
        end
	end

	if self.execPasvs.length <= 0 then
		return
	end
    for iter in self.execPasvs:Items() do
        local pasvRunData = iter.value
        pasvRunData.frame = pasvRunData.frame + 1
        if pasvRunData.frame > pasvRunData.totalFrame then
            self:Finish(pasvRunData.pasvId)
        else
            pasvRunData.frameEvent:DoFrameEvent(pasvRunData.frame, self.skillComponent:GetSkillLevel(pasvRunData.pasvId))
        end
    end
end

function PasvComponent:CastPasv(pasvId,args)
    if self.execPasvs:GetIterByIndex(pasvId) then
        return
    end

    local pasvRunData = self.fight.objectPool:Get(PasvRunData)
    pasvRunData:Init(self,pasvId)

    local iter = self.execPasvs:Push(pasvRunData)
    self.execPasvs:SetIndex(pasvId,iter)
    pasvRunData.frameEvent:SetFrameEventConfig(self.pasvConfig[pasvId])
	pasvRunData.frameEvent:DoFrameEvent(0,self.skillComponent:GetSkillLevel(pasvId))
end

function PasvComponent:CancelPasv(pasvId)
    self:Clear(pasvId)
end

function PasvComponent:ExistPasv(pasvId)
    local iter = self.execPasvs:GetIterByIndex(pasvId)
    return iter and iter.value.frame < iter.value.totalFrame or false
end

function PasvComponent:Finish(pasvId)
	self:Clear(pasvId)
end

function PasvComponent:AddEventActiveSign(sign,args)
	self.eventActiveSign[sign] = args or true
end

function PasvComponent:RemoveEventActiveSign(sign)
	if self.eventActiveSign[sign] then
		self.eventActiveSign[sign] = nil
	end
end

function PasvComponent:CheckEventActiveSign(sign)
	return self.eventActiveSign[sign] ~= nil,self.activeSign[sign]
end

function PasvComponent:Clear(pasvId)
    local iter = self.execPasvs:GetIterByIndex(pasvId)
    if not iter then
        return
    end

    self.execPasvs:RemoveIndex(pasvId)
    table.insert(self.removeQueue,iter)
end

function PasvComponent:OnCache()
	self.fight.objectPool:Cache(PasvComponent,self)

    for iter in self.execPasvs:Items() do
        self.fight.objectPool:Cache(PasvRunData,iter.value)
    end
    self.execPasvs:Clear()
end

function PasvComponent:__cache()

end