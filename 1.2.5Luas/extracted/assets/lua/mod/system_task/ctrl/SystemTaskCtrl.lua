SystemTaskCtrl = BaseClass("SystemTaskCtrl",Controller)

function SystemTaskCtrl:__init()
    self.finishedList = {}
    self.curList = {}
	
	self:BindListener()
end

function SystemTaskCtrl:__delete()
	self:RemoveListener()
end

function SystemTaskCtrl:BindListener()
	EventMgr.Instance:AddListener(EventName.CastSkill, self:ToFunc("OnEntityCastSkill"))
	EventMgr.Instance:AddListener(EventName.EnterElementStateReady, self:ToFunc("EnterElementStateReady"))
	EventMgr.Instance:AddListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
	EventMgr.Instance:AddListener(EventName.OnDealDodge, self:ToFunc("OnEntityDealDodge"))
	EventMgr.Instance:AddListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
	EventMgr.Instance:AddListener(EventName.CastSkillCost, self:ToFunc("OnCastSkillCost"))
end

function SystemTaskCtrl:RemoveListener()
	EventMgr.Instance:RemoveListener(EventName.CastSkill, self:ToFunc("OnEntityCastSkill"))
	EventMgr.Instance:RemoveListener(EventName.EnterElementStateReady, self:ToFunc("EnterElementStateReady"))
	EventMgr.Instance:RemoveListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
	EventMgr.Instance:RemoveListener(EventName.OnDealDodge, self:ToFunc("OnEntityDealDodge"))
	EventMgr.Instance:RemoveListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
	EventMgr.Instance:RemoveListener(EventName.CastSkillCost, self:ToFunc("OnCastSkillCost"))
end

function SystemTaskCtrl:UpdateTaskList(data)
    for key, info in pairs(data.task_list) do
        if self.curList[info.id] then
            self.curList[info.id] = info
            --TODO 任务状态改变
            if info.finish then
                EventMgr.Instance:Fire(EventName.SystemTaskFinish, info)
            else
                EventMgr.Instance:Fire(EventName.SystemTaskChange, info)
            end
        else
            --TODO 接取新任务
            self.curList[info.id]= info
            EventMgr.Instance:Fire(EventName.SystemTaskAccept, info)
        end
    end
    EventMgr.Instance:Fire(EventName.SystemTaskUpdateComplete)
end

function SystemTaskCtrl:UpdataFinishedList(data)
    for _, id in pairs(data.finished_list) do
        if not self.finishedList[id] then
            self.finishedList[id] = true
        end
        if self.curList[id] and next(self.curList[id]) then
            self.curList[id] = nil
            --TODO 任务提交完成
            EventMgr.Instance:Fire(EventName.SystemTaskFinished, id)
        end
    end
    EventMgr.Instance:Fire(EventName.SystemTaskUpdateComplete)
end

function SystemTaskCtrl:CancelSystemTask(data)
	for _, v in pairs(data.cancel_list) do
		self.curList[v] = nil
		self.finishedList[v] = nil
	end
	EventMgr.Instance:Fire(EventName.SystemTaskUpdate)
end

function SystemTaskCtrl:SystemTaskCommit(id)
    mod.SystemTaskFacade:SendMsg("system_task_commit", id)
end

function SystemTaskCtrl:CheckTaskCanFinish(taskId)
    if self.curList[taskId] then
        return self.curList[taskId].finish
    end
end

function SystemTaskCtrl:CheckTaskFinished(taskId)
    if self.finishedList[taskId] then
        return true
    end
end

function SystemTaskCtrl:GetTaskProgress(taskId)
    local progress = 0
    if self.curList[taskId] then
        if SystemTaskConfig.UseLocalProgress(taskId) then
            if self.curList[taskId].finish then
                progress = SystemTaskConfig.GetTaskTarget(taskId) or progress
            else
                local conditionId = SystemTaskConfig.GetTask(taskId).condition
                local _, value = Fight.Instance.conditionManager:CheckConditionByConfig(conditionId)
                progress = value or progress
            end

            --Log("本地任务进度:"..progress)
        else
            if self.curList[taskId].finish then
                progress = SystemTaskConfig.GetTaskTarget(taskId) or progress
            else
                for key, value in pairs(self.curList[taskId].progress_list) do
                    progress = progress + value.current
                end
            end
            --Log("服务器任务进度:"..progress)
        end
        return progress
    elseif self.finishedList[taskId] then
        --Log("已完成任务进度:"..-1)
        return -1
    else
        --Log("未接取任务进度:"..0)
        return 0
    end
end

--mod.SystemTaskCtrl:RecordClinetEvent(SystemTaskConfig.EventType.PerfectAssassinate)
function SystemTaskCtrl:RecordClinetEvent(type, ...)
    mod.SystemTaskFacade:SendMsg("system_task_client_event", type, {...})
end

--监听事件

--释放技能
function SystemTaskCtrl:OnEntityCastSkill(instanceId, skillId, skillType)
	--local entity = BehaviorFunctions.GetEntity(instanceId)
	----配从释放技能
	--if entity and entity.tagComponent and 
		--entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Partner then
		--self:RecordClinetEvent(SystemTaskConfig.EventType.UsePartnerSkill)
	--end
end

--进入元素状态
function SystemTaskCtrl:EnterElementStateReady(atkInstanceId, instanceId, element)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	--击破敌人弱点槽
	if entity and entity.tagComponent then
		if entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Monster
			or entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Elite
			or entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Boss then

			self:RecordClinetEvent(SystemTaskConfig.EventType.EnterElementStateReady)
		end
	end
end

--属性变化
function SystemTaskCtrl:EntityAttrChange(type, entity, oldValue, value)
	-- 击杀敌人
	if type == EntityAttrsConfig.AttrType.Life and value <= 0 then
		if entity.tagComponent then
			if entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Monster
				or entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Elite
				or entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Boss then
				
				mod.SystemTaskCtrl:RecordClinetEvent(SystemTaskConfig.EventType.KillEnemy)
			end
		end
	end
end

--闪避和跳反
function SystemTaskCtrl:OnEntityDealDodge(instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.tagComponent and entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Player then
		self:RecordClinetEvent(SystemTaskConfig.EventType.Dodge)
	end
end

function SystemTaskCtrl:OnActionInput(key, value)
	--local entity = BehaviorFunctions.GetEntity(instanceId)
	----配从释放技能
	--if entity and entity.tagComponent and
		--entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Partner then
		--self:RecordClinetEvent(SystemTaskConfig.EventType.UsePartnerSkill)
	--end
	
	if key == FightEnum.KeyEvent.Partner then
		self.castPartnerSkill = true
	end
	
	--self.castPartnerSkill = key == FightEnum.KeyEvent.Partner
end

function SystemTaskCtrl:OnCastSkillCost(skillId, instanceId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	--配从释放技能
	if entity and entity.tagComponent and
		entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Partner then
		if self.castPartnerSkill then
			print(111)
			self:RecordClinetEvent(SystemTaskConfig.EventType.UsePartnerSkill)
		end
	end
	self.castPartnerSkill = false
end