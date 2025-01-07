Behavior2004 = BaseClass("Behavior2004",EntityBehaviorBase)
--生态关卡创建通用实体
function Behavior2004.GetGenerates()

end

function Behavior2004:Init()
	--获取生态表中对应唯一id
	self.ecoMe = self.sInstanceId
	self.me = self.instanceId
	self.group = nil
	self.zhuangZhiId = nil
	
	self.isSuccess = false
end

function Behavior2004:LateInit()
	
end

function Behavior2004:Update()
	if not self.bindLevelId then
		--获取生态对应的关卡id
		if self.ecoMe then
			self.group = BehaviorFunctions.GetEcoEntityGroup(nil,self.sInstanceId,nil)
			if self.group ~= nil then
				for i,v in ipairs(self.group) do
					if v.instanceId ~= self.instanceId then
						self.zhuangZhiId = v.ecoId
					end
				end
				self.bindLevelId = BehaviorFunctions.GetEcoEntityBindLevel(self.zhuangZhiId)
			end
		end
		if self.bindLevelId then
			--如果关卡不存在 创建关卡
			if BehaviorFunctions.CheckLevelIsCreate(self.bindLevelId) then
				return
			else


			end
		end
	end
end

--如果完成关卡 避免重复创建
function Behavior2004:FinishLevel(levelId)
	if levelId == self.bindLevelId and not self.isSuccess then
		BehaviorFunctions.InteractEntityHit(self.me)
		self.isSuccess = true
	end
end