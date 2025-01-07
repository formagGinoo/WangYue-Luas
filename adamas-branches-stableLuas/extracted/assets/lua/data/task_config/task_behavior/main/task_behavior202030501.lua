TaskBehavior202030501 = BaseClass("TaskBehavior202030501")

--和坏人对话

function TaskBehavior202030501.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior202030501:__init(taskInfo)
	self.taskInfo = taskInfo
	self.ClickKey=true
	--self.npc=BehaviorFunctions.GetNpcEntity(8010228)
	self.missionState=0
	self.levelId=202030501
	self.dialogList ={
		[1]={id=202030101},
		[2]={id=202030201},
		[3]={id=202030301},
		[4]={id=202030401},
		[5]={id=202030501},
		[6]={id=202030601},
		[7]={id=202030701},
		[8]={id=202030801},
		[9]={id=202030901},
	}
	self.levelCreate=false

end

function TaskBehavior202030501:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	
	--创建关卡
	if self.missionState==0 then
		BehaviorFunctions.AddLevel(self.levelId)
		self.missionState=1
	end
	
	
	


end





function TaskBehavior202030501:Death(instanceId,isFormationRevive)
	if instanceId==self.role then
		if isFormationRevive==true then
			BehaviorFunctions.RemoveLevel(self.levelId)
			self.missionState=0
		end
	end
end


