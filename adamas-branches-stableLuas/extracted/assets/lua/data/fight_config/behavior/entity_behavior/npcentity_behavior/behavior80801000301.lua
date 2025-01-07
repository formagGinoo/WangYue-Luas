Behavior80801000301 = BaseClass("Behavior80801000301",EntityBehaviorBase)
--月灵大师特殊NPC测试lua
function Behavior80801000301.GetGenerates()
	local generates = {900080}
	return generates
end


function Behavior80801000301.GetMagics()
	local generates = {}
	return generates
end

function Behavior80801000301:Init()
	self.me = self.instanceId
	self.ecoMe = self.sInstanceId --获得生态id
	self.yueling = nil --月灵大师配套的月灵的实例id
	self.role = nil --当前操控角色
	self.yuelingFresh = false --当前的月灵是否刷新出来了
	self.groupAll = {} --生态分组
	
	self.missionOutState = 0 --副本外的关卡状态
	self.missionOutStateEnum = {default = 0, start = 1, ongoing = 2, success = 3, fail = 4} --副本外的关卡状态枚举
	
	self.param = nil --额外参数
	self.duplicate = nil --副本系统id
	
	self.battleDialogFinish = false --开始战斗的对话结束，进入战斗
	self.endDialogFinish = false --关卡结束的对话结束
	
	--需要配置的内容------------------------------------------
	self.startDialog = 602300101 --开始玩法的对话
	self.endDialog = 602300301   --结束玩法的对话
	self.battleDialog = 602300201 --选择战斗的对话

	self.stopBuff = 500002001 --暂停实体行为逻辑的buff
end

function Behavior80801000301:LateInit()
end

function Behavior80801000301:Update()
	
	if self.bindLevelId and self.createLevel == false then
		self.createLevel = true
		
	end
	
	--默认状态，修改npc默认状态
	if self.missionOutState == 0 then
		BehaviorFunctions.SetEntityWorldInteractState(self.me, true) --设置交互按钮显示
		BehaviorFunctions.ChangeWorldInteractInfo(self.me,nil,"交谈") --修改交互按钮内容
		
		--获取配置的副本
		self.param = BehaviorFunctions.GetEcoEntityExtraParam(self.ecoMe)
		if next(self.param) then
			self.duplicate = tonumber(self.param[1].duplicate)
		end
		
		self.missionOutState = 1
	
	--修改月灵相关状态
	elseif self.missionOutState == 1 then

		if self.yueling then
			self.yuelingFresh = BehaviorFunctions.CheckEcoEntityState(self.yueling) --检测当前月灵是否刷新出来
			if self.yuelingFresh then
			else
				self.yueling = nil --如果月灵没刷新出来，则重置月灵状态
			end
		else
			--根据分组获得月灵id
			self.groupAll = BehaviorFunctions.GetEcoEntityGroupMember(nil,nil,self.ecoMe) --获取分组成员
			if next(self.groupAll) then
				for i, v in pairs(self.groupAll) do
					local id = BehaviorFunctions.GetEcoEntityByEcoId(v)
					if id ~= self.me then
						self.yueling = id
						BehaviorFunctions.RemoveBehavior(self.yueling) --移除月灵的行为逻辑
					end
				end
			end
		end
		
		
		--若玩家选择了进入战斗的dialog，就进入下一个状态
		if self.battleDialogFinish then
			self.missionOutState = 2
		end
		
	--与npc进行对话，触发关卡中时，创建副本，进入副本中
	elseif self.missionOutState == 2 then
		if self.duplicate then
			BehaviorFunctions.CreateDuplicate(self.duplicate) --创建副本
			self.battleDialogFinish = false
			self.missionOutState = 1
		end
	end
end

--与NPC互动
function Behavior80801000301:WorldInteractClick(uniqueId,instanceId)
	if instanceId == self.me then
		if self.startDialog then
			BehaviorFunctions.StartStoryDialog(self.startDialog)
		end
	end
end


--对话开始
function Behavior80801000301:StoryStartEvent(dialogId)
	if dialogId == self.startDialog then

	end
end

--对话结束
function Behavior80801000301:StoryEndEvent(dialogId)
	if dialogId == self.battleDialog then
		self.battleDialogFinish = true
	end
end