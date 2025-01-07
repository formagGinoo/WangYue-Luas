---@class BehaviorDelayCallback
BehaviorDelayCallback = BaseClass("BehaviorDelayCallback")

function BehaviorDelayCallback:__init(fight)
	self.fight = fight
	self.callbackCount = 0
	self.delayCallbacks = {}
	self.delayCallbackInstances = {}
	self.addQueue = {}
	self. removeQueue = {}
	self.instanceId = 0
end

function BehaviorDelayCallback:Update()
	if next(self.addQueue) then
		for i = 1, #self.addQueue do
			table.insert(self.delayCallbackInstances,self.addQueue[i])
			self.callbackCount = self.callbackCount + 1
		end
		for i = #self.addQueue, 1, -1 do
			table.remove(self.addQueue)
		end
	end
	for i = 1, #self.delayCallbackInstances do
		local delayCallback = self.delayCallbacks[self.delayCallbackInstances[i]]
		if delayCallback then
			if self.fight.fightFrame > delayCallback.frame then
				if delayCallback.selfObj == BehaviorFunctions then
					delayCallback.callback(table.unpack(delayCallback.parms))
				else
					delayCallback.callback(delayCallback.selfObj,table.unpack(delayCallback.parms))
				end
				table.insert(self.removeQueue,i)
			end
		else
			table.insert(self.removeQueue,i)
		end
	end
	if next(self.removeQueue) then
		for i = #self.removeQueue, 1,-1 do
			local pos = table.remove(self.removeQueue)
			table.remove(self.delayCallbackInstances,pos)
			self.callbackCount = self.callbackCount - 1
		end
	end

	--if self.callbackCount > 150 then
	--	LogError(" CurBehaviorDelayCallbackCount = "..self.callbackCount.." , 请检查逻辑, 不要每帧调用DelayCall节点" )
	--end
end

function BehaviorDelayCallback:AddDelayCallByTime(time,obj,callback,...)
	local frame = math.ceil(time * 30)
	return self:AddDelayCallByFrame(frame,obj,callback,...)
end

function BehaviorDelayCallback:AddDelayCallByFrame(frame,obj,callback,...)
	self.instanceId = self.instanceId + 1
	table.insert(self.addQueue,self.instanceId)
	local delayCallback = {instanceId = self.instanceId,selfObj = obj,callback = callback,parms = {...},frame = frame + self.fight.fightFrame}
	self.delayCallbacks[self.instanceId] = delayCallback
	return self.instanceId
end

function BehaviorDelayCallback:RemoveDelayCall(instanceId)
	self.delayCallbacks[instanceId] = nil
end

function BehaviorDelayCallback:ResetDelayCallByTime(instanceId,time)
	local frame = math.ceil(time * 30)
	self:ResetDelayCallByFrame(instanceId,frame)
end

function BehaviorDelayCallback:ResetDelayCallByFrame(instanceId,frame)
	self.delayCallbacks[instanceId].frame = frame + self.fight.fightFrame
end

function BehaviorDelayCallback:__delete()

end