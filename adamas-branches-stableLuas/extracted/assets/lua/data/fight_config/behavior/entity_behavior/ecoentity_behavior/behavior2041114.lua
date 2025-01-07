Behavior2041114 = BaseClass("Behavior2041114",EntityBehaviorBase)
--跑酷玩法交互的金币道具
function Behavior2041114.GetGenerates()
	local generates = {2041114,203040701}
	return generates
end

function Behavior2041114:Init()
	self.missionstate = 0
	self.me = self.instanceId
	self.ecoMe = self.sInstanceId
	self.role = nil	
	self.Active = false
	self.rolePos = 0
	self.mePos = 0
	self.missionDistance = 0
	self.missionUnloadDis = 1
	self.pos = 0
	self.effect = 0
	self.effecttack = false

	--关卡倒计时
	self.timeTack = false
	self.timeLimit = 0.5
	self.startFrame = nil
	self.timeLimitFrames = 0
end

function Behavior2041114:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.timeTack == false then
		self:Timer(self.timeLimit)
		self.timeTack = true
	end

	if self.missionstate == 0 then
		if self:Timer() <= 0 then
			self.effecttack = true
			self.missionstate = 1
		end
	end

	--获取坐标
	self.rolePos = BehaviorFunctions.GetPositionP(self.role)
	self.mePos = BehaviorFunctions.GetPositionP(self.me)
	self.missionDistance = BehaviorFunctions.GetDistanceFromPos(self.rolePos,self.mePos)
	if self.missionDistance <= self.missionUnloadDis then
		if self.effecttack == true then
			self.effect = BehaviorFunctions.CreateEntity(203040701,nil,self.mePos.x,self.mePos.y,self.mePos.z)
			BehaviorFunctions.RemoveEntity(self.me)
		end
	end
end

-------------------------函数-------------------------

function Behavior2041114:Timer(timeLimit)
    if not self.startFrame then  
        self.timeLimitFrames = timeLimit * 30  
        self.startFrame = BehaviorFunctions.GetFightFrame()  
    end
    local currentFrame = BehaviorFunctions.GetFightFrame()  
    local elapsedFrames = currentFrame - self.startFrame  
    local remainingFrames = self.timeLimitFrames - elapsedFrames  
    remainingFrames = math.max(0, remainingFrames)  
    local remainingTime = math.ceil(remainingFrames / 30)
    return remainingTime
end