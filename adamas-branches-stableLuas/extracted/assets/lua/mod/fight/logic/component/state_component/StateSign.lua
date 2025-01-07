---@class StateSign
StateSign = BaseClass("StateSign",StateSign)

function StateSign:__init()
end

function StateSign:Init(fight,entity,lastFrame,ignoreTimeScale,startFightFrame,startEntityFrame)
	self.fight = fight
	self.entity = entity
	self.lastFrame = lastFrame
	self.ignoreTimeScale = ignoreTimeScale
	self.startFightFrame = startFightFrame
	self.startEntityFrame = startEntityFrame
end

function StateSign:Refresh(lastFrame,ignoreTimeScale,startFightFrame,startEntityFrame)
	self.lastFrame = lastFrame
	self.ignoreTimeScale = ignoreTimeScale
	self.startFightFrame = startFightFrame
	self.startEntityFrame = startEntityFrame
end

function StateSign:IsValid()
	if self.lastFrame < 0 then
		return true
	end
	if self.ignoreTimeScale then
		return self.startFightFrame <= self.fight.fightFrame and self.fight.fightFrame <= self.startFightFrame + self.lastFrame
	else
		return self.startEntityFrame <= self.entity.timeComponent.frame and self.entity.timeComponent.frame <= self.startEntityFrame + self.lastFrame
	end
end

function StateSign:__cache()
	self.state = nil
	self.lastFrame = nil
	self.ignoreTimeScale = nil
	self.startFightFrame = nil
	self.startEntityFrame = nil
end

function StateSign:__delete()

end