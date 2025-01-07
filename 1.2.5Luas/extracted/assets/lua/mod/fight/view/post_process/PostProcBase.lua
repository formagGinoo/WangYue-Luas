PostProcBase = BaseClass("PostProcBase")

function PostProcBase:__init(type, invokeCmp)
	self.procType = type
	self.invokeCmp = invokeCmp
	self.clientFight = Fight.Instance.clientFight
	
	self.isWork = false
	self.params = nil
	self.entity = nil
end

function PostProcBase:Start(params, entity)
	self.isWork = true
	self.frame = 0
	self.entity = entity
	self.params = params
	
	self:DoStartFrame()
end

function PostProcBase:Update()
	if not self.isWork then
		return 
	end
	
	self.frame = self.frame + 1
	self:DoFrame(self.frame)
end

function PostProcBase:Reset()
	self:OnReset()
	
	self.isWork = false
	self.invokeCmp:RemovePostProcess(self.procType)
	
	self.params = nil
	self.entity = nil
end

function PostProcBase:__delete()
	self.invokeCmp = nil
	self.params = nil
	self.entity = nil
end

--重载
function PostProcBase:DoStartFrame()
end

function PostProcBase:DoFrame(frame)
end

function PostProcBase:CanStart()
	return not self.isWork
end

function PostProcBase:IsWork()
	return self.isWork
end

function PostProcBase:UpdateState(params)
end

function PostProcBase:OnReset()
end

function PostProcBase:EndProcess()
	self:Reset()
end