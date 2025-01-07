Behavior300001303 = BaseClass("Behavior300001303",EntityBehaviorBase)
function Behavior300001303.GetGenerates()


end

function Behavior300001303.GetMagics()
	local generates = {300001313}
	return generates
end

function Behavior300001303:Init()
	self.ecoEntitys = nil
	self.magicState = 0
	self.me = self.instanceId
	self.starttime = nil
	self.intervaltime = BehaviorFunctions.GetEntityFrame(self.instanceId)/30--初始化间隔时间
	self.interval = false
end

function Behavior300001303:Update()
	self.time = BehaviorFunctions.GetEntityFrame(self.me)/30--时间

end

function Behavior300001303:Collide(attackInstanceId,hitInstanceId)
    if attackInstanceId == self.me 
		and hitInstanceId ~= self.me--击中
		and (self.starttime == nil or self.time> self.starttime+ 10) --且没在cd
		and self.time> self.intervaltime + 0.5 then--且没在间隔
		
		local randomresult = BehaviorFunctions.Random(0,100)
		self.intervaltime = BehaviorFunctions.GetEntityFrame(self.me)/30--记录间隔时间
		
		if randomresult and randomresult<=30 then
			BehaviorFunctions.DoMagic(self.me,self.me,300001313,1)--火伤提升
			self.starttime = BehaviorFunctions.GetEntityFrame(self.me)/30--记录cd时间
		end
	end
end