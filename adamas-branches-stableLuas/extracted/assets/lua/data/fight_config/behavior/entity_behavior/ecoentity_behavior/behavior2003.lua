Behavior2003 = BaseClass("Behavior2003",EntityBehaviorBase)
--生态关卡创建通用实体
function Behavior2003.GetGenerates()

end

function Behavior2003:Init()
	--获取生态表中对应唯一id
	self.ecoMe = self.sInstanceId
	self.me = self.instanceId
	self.isSuccess = false
end

function Behavior2003:LateInit()
	--获取生态对应的关卡id
	if self.ecoMe then
		self.bindLevelId = BehaviorFunctions.GetEcoEntityBindLevel(self.ecoMe)
	end
	if self.bindLevelId then
		--如果关卡不存在 创建关卡
		if BehaviorFunctions.CheckLevelIsCreate(self.bindLevelId) then
			return
		else 
			BehaviorFunctions.AddLevel(self.bindLevelId)
		end	
	end
end

--如果完成关卡 避免重复创建
function Behavior2003:FinishLevel(levelId)
	if levelId == self.bindLevelId and not self.isSuccess then
		BehaviorFunctions.InteractEntityHit(self.me)
		self.isSuccess = true
	end
end

--如果移除关卡 则重新创建关卡
function Behavior2003:RemoveLevel(levelId)
	if levelId == self.bindLevelId and not self.isSuccess then
		if BehaviorFunctions.CheckLevelIsCreate(self.bindLevelId) then
			return
		else
			BehaviorFunctions.AddLevel(self.bindLevelId)
		end
	end
end