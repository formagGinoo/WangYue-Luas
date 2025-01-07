FSMBehavior90000201 = BaseClass("FSMBehavior90000201",FSMBehaviorBase)
--和平状态


function FSMBehavior90000201.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior90000201:Init()
	--逻辑变量
	self.peaceState = nil
	self.PeaceStateEnum = {            --非战斗状态枚举
		Default = 0,
		Patrol = 1,
		Act = 2,
	}
	
	self.param = nil
	self.information = {"peaceState","logicName","patrolList","canReturn","actPerformance"}
	self.list = {}
end

function FSMBehavior90000201:LateInit()
	if self.sInstanceId then
		self.param = BehaviorFunctions.GetEcoEntityExtraParam(self.MainBehavior.ecoMe)
		if  self.param and next(self.param) then
			for k,v in pairs(self.param) do
				for n,m in ipairs(self.information) do
					if v[m]~=nil then
						self.list[m]=self:SplitParam(v[m],"|")
					end
				end
			end
		end
		
		--非战斗方式
		if self.list["logicName"] then
			self.peaceState=self.PeaceStateEnum.Patrol
		elseif self.list["actPerformance"] then
			self.peaceState=self.PeaceStateEnum.Act
		end
		
	end
end

function FSMBehavior90000201:Update()
	--副本召唤怪物
	--非战斗方式
	if self.peaceState == nil and BehaviorFunctions.GetEntityValue(self.MainBehavior.me,"peaceState") then
		self.peaceState = BehaviorFunctions.GetEntityValue(self.MainBehavior.me,"peaceState")
	end
end