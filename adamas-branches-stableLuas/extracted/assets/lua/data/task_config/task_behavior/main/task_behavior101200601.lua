TaskBehavior101200601 = BaseClass("TaskBehavior101200601")
--谈判流程任务

function TaskBehavior101200601.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101200601:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.missionState = 0	

	self.endingNum = nil
	self.daotuChoiceList = 
	{
		--谈判1道途选项
		[1] = {dialogId = 101202401 ,groupId = 1012024,resultId = nil,choiceId = {[1] = {id = 101202406,nextDialog = 2},[2] = {id = 101202409,nextDialog = 2}}},
		--谈判2道途选项
		[2] = {dialogId = 101202501 ,groupId = 1012025,resultId = nil,choiceId = {[1] = {id = 101202505,nextDialog = 3},[2] = {id = 101202509,nextDialog = 3},[3] = {id = 101202512,nextDialog = 3}}},
		--谈判3道途选项
		[3] = {dialogId = 101202601 ,groupId = 1012026,resultId = nil,choiceId = {[1] = {id = 101202607,nextDialog = nil},[2] = {id = 101202609,nextDialog = 4},[3] = {id = 101202614,nextDialog = 4}}},
		--谈判4道途选项
		[4] = {dialogId = 101203001 ,groupId = 1012030,resultId = nil,choiceId = {[1] = {id = 101203005,nextDialog = 5},[2] = {id = 101203008,nextDialog = 5},[3] = {id = 101203013,nextDialog = 5}}},
		--谈判5道途选项
		[5] = {dialogId = 101203201 ,groupId = 1012032,resultId = nil,choiceId = {[1] = {id = 101203206,nextDialog = nil},[2] = {id = 101203207,nextDialog = 6},[3] = {id = 101203208,nextDialog = 7},[3] = {id = 101203209,nextDialog = 8}}},
		--谈判6-1道途选项
		[6] = {dialogId = 101203301 ,groupId = 1012033,resultId = nil,choiceId = {[1] = {id = 101203311,nextDialog = nil},[2] = {id = 101203314,nextDialog = nil}}},
		--谈判6-2道途选项
		[7] = {dialogId = 101204601 ,groupId = 1012046,resultId = nil,choiceId = {[1] = {id = 101204618,nextDialog = nil},[2] = {id = 101204619,nextDialog = nil}}},
		--谈判6-3道途选项
		[8] = {dialogId = 101203801 ,groupId = 1012038,resultId = nil,choiceId = {[1] = {id = 101203807,nextDialog = nil},[2] = {id = 101203810,nextDialog = nil}}},
	}
	
	self.endingPreTaskList = 
	{
		[1] = 	{taskId = 101200701,keySection = {self.daotuChoice[3].choiceId[1],self.daotuChoice[8].choiceId[1]},describe = "结局1或2，战斗"},
		[2] = 	{taskId = 101200730,keySection = {self.daotuChoice[5].choiceId[4],self.daotuChoice[6].choiceId[1],self.daotuChoice[8].choiceId[2]},describe = "结局3"},
		[3] = 	{taskId = 101200740,keySection = {self.daotuChoice[6].choiceId[2]},describe = "结局4"},
		[4] = 	{taskId = 101200750,keySection = {self.daotuChoice[7].choiceId[1]},describe = "结局5"},
		[5] = 	{taskId = 101200760,keySection = {self.daotuChoice[7].choiceId[2]},describe = "结局6"},
	}
end

function TaskBehavior101200601:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()	
	--任务开始时检查哪些道途已经完成了
	self:getDaotuResult(self.daotuChoiceList)
end

function TaskBehavior101200601:getDaotuResult(List)
	for i,v in ipairs(List) do
		v.resultId = BehaviorFunctions.CheckSaveDialog(v.groupId)
		if v.resultId ~= nil then
			for i2,v2 in ipairs(self.endingPreTaskList) do
				for i3,v3 in ipairs(v2.keySection) do
					if v3 == v.result then
						LogError("Ending"..i3)
					end
				end
			end
		end
	end
end

function TaskBehavior101200601:StoryStartEvent(dialogId)

end

function TaskBehavior101200601:StoryEndEvent(dialogId)

end