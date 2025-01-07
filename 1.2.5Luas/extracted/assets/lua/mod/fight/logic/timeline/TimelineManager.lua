---@class TimelineManager
TimelineManager = BaseClass("TimelineManager")

function TimelineManager:__init(fight)
	self.fight = fight
end

function TimelineManager:PlayTrack(mainTarget,target,path,transitionTime,timeIn,timeOut)
	local pos = mainTarget.transformComponent.position
	target.transformComponent:SetPosition(pos.x,pos.y,pos.z)
	mainTarget.stateComponent:SetState(FightEnum.EntityState.Perform)
	target.stateComponent:SetState(FightEnum.EntityState.Perform)
	if ctx then
		self.fight.clientFight.clientTimelineManager:PlayTrack(mainTarget,target,path,transitionTime,timeIn,timeOut)
	end
end

function TimelineManager:StopTrack(mainTarget,target,path)
	mainTarget.stateComponent:SetState(FightEnum.EntityState.Idle)
	target.stateComponent:SetState(FightEnum.EntityState.Idle)
	if ctx then
		self.fight.clientFight.clientTimelineManager:StopTrack(mainTarget,target,path)
	end
end

function TimelineManager:__delete()

end
