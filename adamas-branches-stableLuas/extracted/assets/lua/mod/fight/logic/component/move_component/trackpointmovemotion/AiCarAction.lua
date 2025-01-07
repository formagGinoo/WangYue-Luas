AiCarAction = BaseClass("AiCarAction",PoolBaseClass)

local _random = math.random

function AiCarAction:__init()

end

function AiCarAction:Init(controller, motion, actionInstanceId, actionType,args)
	self.motion = motion
	self.controller = controller
	self.actionInstanceId = actionInstanceId
    self.finished = false
    self.actionType = actionType
    self.args = args
end

function AiCarAction:Update()
    self.controller:DoAction(self)
end

function AiCarAction:Undo()
    self.controller:UnDoAction(self)
    self.finished = false
end

function AiCarAction:IsComplete()
    return self.finished
end

function AiCarAction:SetComplete()
    self.finished = true;
end
function AiCarAction:__cache()
end

function AiCarAction:__delete()
end
