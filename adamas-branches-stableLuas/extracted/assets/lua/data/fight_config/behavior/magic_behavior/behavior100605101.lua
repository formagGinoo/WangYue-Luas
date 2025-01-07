
Behavior100605101 = BaseClass("Behavior100605101",EntityBehaviorBase)
function Behavior100605101.GetGenerates()


end

function Behavior100605101.GetMagics()

end

function Behavior100605101:Init()
	self.me = self.instanceId		--记录自己
	self.inTrigger = false    --默认为不在圈内
	self.cureFrame = 0
	self.cureTime = 2	--治疗冷却两秒
end

function Behavior100605101:Update()
	self.time = BehaviorFunctions.GetFightFrame()	--获取时间
	
	--临时逻辑，找到青门隐
	self.RoleList = BehaviorFunctions.GetCurFormationEntities()	--获取全队id
	
	for i,v in pairs(self.RoleList) do
		if BehaviorFunctions.GetEntityTemplateId(self.RoleList[i]) == 1006 then
			self.role1006 = self.RoleList[i]
		end
	end
	
	if not self.role1006 then
		self.role1006 = self.me
	end
	
	--从有标记开始，进行治疗计时
	if self.inTrigger == true then
		if self.cureFrame < self.time then
			BehaviorFunctions.DoMagic(self.role1006,self.me,1000092,1)	--添加治疗
			BehaviorFunctions.DoMagic(self.role1006,self.me,1000093,1)	--播放特效
			self.cureFrame = self.time + self.cureTime * 30	--治疗cd
		end
	end
end


--进入范围
function Behavior100605101:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	--local x,y,z = BehaviorFunctions.GetCurFormationEntities()
	if triggerEntityId == 100605102 and roleInstanceId == self.me then
		self.inTrigger = true	--标记为在圈内
		--BehaviorFunctions.DoMagic(self.Me,roleInstanceId,1000092,1)	--添加治疗
		--BehaviorFunctions.DoMagic(self.Me,roleInstanceId,1000093,1)	--播放特效
	end
end



--退出交互范围
function Behavior100605101:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if triggerEntityId == 100605102 and roleInstanceId == self.me then
		self.inTrigger = false	--标记为出圈
	end
end