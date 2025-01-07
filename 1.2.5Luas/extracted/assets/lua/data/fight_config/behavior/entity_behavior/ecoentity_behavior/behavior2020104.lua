Behavior2020104 = BaseClass("Behavior2020104",EntityBehaviorBase)
--新手路段传送点
function Behavior2020104.GetGenerates()

end

function Behavior2020104:Init()
	self.me = self.instanceId
	self.revivePos =
	{
		[1] = {taskId = 101030101, ecoId = 1001010006,pos ="checkPoint1"},
		[2] = {taskId = 101030201, ecoId = 1001010007,pos ="checkPoint2"},
		[3] = {taskId = 101030203, ecoId = 1001010008,pos ="checkPoint3"},
		[4] = {taskId = 101030401, ecoId = 1001010009,pos ="checkPoint4"},
		[5] = {taskId = 101030401, ecoId = 1001010010,pos ="checkPoint5"},
		[6] = {taskId = 101040101, ecoId = 1001010011,pos ="checkPoint6"},
		[7] = {taskId = 101040301, ecoId = 1001010012,pos ="checkPoint7"},
		[8] = {taskId = 101040301, ecoId = 1001010013,pos ="checkPoint8"},
		[9] = {taskId = 101040501, ecoId = 1001010014,pos ="checkPoint9"},
		[10] = {taskId = 101060101, ecoId = 1001010015,pos ="checkPoint10"},
		[11] = {taskId = 101060801, ecoId = 1001010016,pos ="checkPoint11"},
		[12] = {taskId = 101061101, ecoId = 1001010017,pos ="checkPoint12"},
		[13] = {taskId = 101062501, ecoId = 1001010018,pos ="checkPoint13"},
		[14] = {taskId = 101070102, ecoId = 1001010019,pos ="checkPoint14"},
	}
end


function Behavior2020104:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity	()
	self.EcoId = BehaviorFunctions.GetEntityEcoId(self.me)
	self.isActive = BehaviorFunctions.CheckEntityEcoState(self.me)
end


function Behavior2020104:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	--激活条件：完成了指定任务且处于对应复活点的激活范围内
	if triggerInstanceId == self.me  and roleInstanceId == self.role then
		for i,v in ipairs(self.revivePos) do
			if v.ecoId == self.EcoId then
				local isTaskFinish = BehaviorFunctions.CheckTaskIsFinish(v.taskId)
				if self.isActive == false and isTaskFinish then					
					BehaviorFunctions.InteractEntityHit(self.me,FightEnum.SysEntityOpType.Transport)
					--LogError("成功激活新手路段复活点"..v.pos)
				elseif not isTaskFinish then
					--LogError("因为"..v.taskId.."未完成，所以激活复活点"..v.pos.."失败")
				end
			end
		end
	end
end


function Behavior2020104:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)

end