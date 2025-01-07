---@class ClientSoundComponent
ClientSoundComponent = BaseClass("ClientSoundComponent",PoolBaseClass)

function ClientSoundComponent:__init()
	self.bindLifeSoundList = {}
	self.delayEventList = {}
	self.animSoundMap = {}
	self.playAnimSound = nil
end

function ClientSoundComponent:Update()

end

function ClientSoundComponent:Init(clientFight,clientEntity)
	self.clientFight = clientFight
	self.clientEntity = clientEntity
	self.config = self.clientEntity.entity:GetComponentConfig(FightEnum.ComponentType.Sound)
	self.soundEventList = self.config.SoundEventList
	self.bornSoundPlay = false
end

function ClientSoundComponent:LateInit()

end

function ClientSoundComponent:OnEvent(eventType)
	if self.soundEventList then
		for k, v in pairs(self.soundEventList) do
			if v.EventType == eventType then
				if v.DelayTime <= 0 then
					self:PlaySound(v.SoundEvent, v.LifeBindEntity)
				end
			else
				local event = TableUtils.CopyTable(v)
				table.insert(self.delayEventList, event)
			end
		end
	end
end


function ClientSoundComponent:Update()
	if not self.bornSoundPlay then
		self.gameObject = self.clientEntity.clientTransformComponent:GetGameObject()
		self:OnEvent(FightEnum.SoundEventType.Born)
		self.bornSoundPlay = true
	end
	
	for i = #self.delayEventList, 1, -1 do
		local delayTime = self.delayEventList[i].DelayTime - Global.deltaTime
		if delayTime > 0 then
			self.delayEventList[i].DelayTime = delayTime
		else
			table.remove(self.delayEventList, i)
		end
	end
end

function ClientSoundComponent:PlaySound(soundEvent, lifeBindEntity)
	SoundManager.Instance:PlayObjectSound(soundEvent, self.gameObject)
	if lifeBindEntity then
		table.insert(self.bindLifeSoundList, soundEvent)
	end
end

function ClientSoundComponent:PlayTerrainSound(soundEvent, lifeBindEntity)
	local terrainMatLayer = self.clientEntity.clientTransformComponent:GetGroundMatLayer()
	if terrainMatLayer == 0 then
		terrainMatLayer = TerrainMatLayerConfig.Layer.Mud
	end
	if self.gameObject then
		GameWwiseContext.SetSwitch("Material", TerrainMatLayerConfig.LayerStr[terrainMatLayer], self.gameObject)
		self:PlaySound(soundEvent, lifeBindEntity)
	end
end

function ClientSoundComponent:StopSound(soundEvent)
	SoundManager.Instance:StopObjectSound(soundEvent, self.gameObject)
end

function ClientSoundComponent:SetRTPCValue(name, value, time)
	GameWwiseContext.SetRTPCValue(name, value, self.gameObject, time)
end

function ClientSoundComponent:OnCache()
	self.clientFight.fight.objectPool:Cache(ClientSoundComponent, self)
end

function ClientSoundComponent:__cache()
	self:OnEvent(FightEnum.SoundEventType.Destroy)

	for k, v in pairs(self.bindLifeSoundList) do
		SoundManager.Instance:StopObjectSound(v, self.gameObject)
	end
	TableUtils.ClearTable(self.bindLifeSoundList)
	TableUtils.ClearTable(self.delayEventList)
end

function ClientSoundComponent:__delete()
	self.clientFight = nil
	self.clientEntity = nil
end