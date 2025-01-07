AiCarMotion = BaseClass("AiCarMotion",AiCarAction)

local _random = math.random

function AiCarMotion:__init()
    self.activeConditions = {}
    self.cancelConditions = {}
    self.actions = {}
    self.callBack = {}
    self.actionInstanceId = 0
end

function AiCarMotion:Init(controller, motionInstanceId)
	self.controller = controller
	self.motionInstanceId = motionInstanceId
    self.finished = false
    self.isActive = false
    self.stayTime = 0
    self.time = 0
    self.lastActiveTime = -9999
    for i, v in ipairs(self.actions) do
        v.controller = controller
    end
end

-- 触发条件
function AiCarMotion:AddActiveCondition(condition)
    table.insert(self.activeConditions,condition)
end

-- 中断条件
function AiCarMotion:AddCancelCondition(condition)
    table.insert(self.cancelConditions,condition)
end

function AiCarMotion:AddAction(actionType , ...)

	local args = {...}
	local action = Fight.Instance.objectPool:Get(AiCarAction)
	self.actionInstanceId = self.actionInstanceId + 1
    action:Init(self.controller,self, self.actionInstanceId,actionType,args)
    table.insert(self.actions,action)
end

function AiCarMotion:AddStartCallBack(callBack)
    table.insert(self.actions,action)
end


function AiCarMotion:GetCondition(condition,...)
    
    if self.controller and self.controller[condition] then
	    local args = {...}
        return self.controller[condition](self.controller,args)
    end
end

function AiCarMotion:Update()

    self.time = self.time + FightUtil.deltaTimeSecond

    if not self.isActive then
        self.isActive = true
        for i, v in ipairs(self.activeConditions) do
            if v and not v() then
                self.isActive = false;
				break
            end
        end
        if self.isActive then
            self.lastActiveTime = self.time
        end
    end

    if self.isActive then
        
        local isCancel = #self.cancelConditions > 0 or false

        for i, v in ipairs(self.cancelConditions) do
            if v and not v() then
                isCancel = false;
            end
        end
        if isCancel then
            self.isActive = false
        end
    end

    if self.isActive then
        self.stayTime = self.stayTime + FightUtil.deltaTimeSecond
        for i, v in ipairs(self.actions) do
            if v and not v:IsComplete() then
                v:Update()
            end
        end
    else 
        self.stayTime = 0
        self:Undo()
    end

    
    if isCancel then
        -- todo clear
    end
end

function AiCarMotion:Undo()
    for i, v in ipairs(self.actions) do
        if v and v:IsComplete() then
            v:Undo()
        end
    end
end
function AiCarMotion:GetSinceLastActiveTime()
    return self.time - self.lastActiveTime
end

function AiCarMotion:GetStayTime()
    return self.stayTime
end
function AiCarMotion:IsComplete()
    local result = true
    
    for i, v in ipairs(self.actions) do
        if v and not v:IsComplete() then
            result = false
        end
    end
    return result
end

function AiCarMotion:IsActive()
    return self.isActive
end
function AiCarMotion:__cache()
    self.actionInstanceId = 0
	self.motionInstanceId = 0

    TableUtils.ClearTable(self.activeConditions)
    TableUtils.ClearTable(self.cancelConditions)
    TableUtils.ClearTable(self.actions)
end

function AiCarMotion:__delete()
end
