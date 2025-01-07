Behavior2030301 = BaseClass("Behavior2030301",EntityBehaviorBase) --在怪物身上使用CheckEcoEntityGroup,来决定是否要调用这个函数。
--资源预加载
function Behavior2030301.GetGenerates()
	local generates = {}
	return generates
end

function Behavior2030301:Init()
	self.me = self.instanceId
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.treasureBoxList={2010101,2010102,2010103,2010104}
	self.treasureBox = nil
	self.mission = 0
	self.finishPuzzle = false
end

function Behavior2030301:Update()

	self.role = BehaviorFunctions.GetCtrlEntity()
	self.groupMember=BehaviorFunctions.GetEcoEntityGroup(nil,nil,self.me)
	
	if self.groupMember ~= nil then
		for index,member in pairs(self.groupMember) do
			if  BehaviorFunctions.CheckEntity(member.instanceId) == true then
				local EntityID = BehaviorFunctions.GetEntityTemplateId(member.instanceId)
				for index2,type in ipairs(self.treasureBoxList) do
					if EntityID == type then
						self.treasureBox = member.instanceId
					end
				end
			end
		end
	end
	
	self:TreasureBox() --奖励传值

end

function Behavior2030301:LotusPuzzle()

end

function Behavior2030301:TreasureBox()
	if self.treasureBox~=0 then
		if self.mission==0 and self.groupMember ~= nil then
			for i,v in pairs(self.groupMember) do --遍历monsterGroup中所有实例id,查找实例id对应的状态。需要知道这个实例是否存活吗？
				if BehaviorFunctions.CheckEntity(v.instanceId)==true then --检查实体是否存在
					if v.instanceId == self.treasureBox then
						BehaviorFunctions.SetEntityValue(v.instanceId,"lockState",2) --初始化的时候给一个上锁状态
						BehaviorFunctions.SetEntityValue(v.instanceId,"isHide",true) --初始化隐藏宝箱
						self.mission=1
					end
				end
			end
		end

		if self.mission == 1 and self.finishPuzzle == true then
			for i,v in pairs(self.groupMember) do --遍历monsterGroup中所有实例id,查找实例id对应的状态。需要知道这个实例是否存活吗？
				if BehaviorFunctions.CheckEntity(v.instnaceId)==true then --检查实体是否存在
					if v.instanceId ==self.treasureBox then
						BehaviorFunctions.SetEntityValue(v.instanceId,"lockState",3) --宝箱解锁
						BehaviorFunctions.SetEntityValue(v.instanceId,"isHide",false) --显示宝箱
						self.mission = 2
						BehaviorFunctions.InteractEntityHit(self.me,FightEnum.SysEntityOpType.Death)
						BehaviorFunctions.AddDelayCallByTime(0.5,BehaviorFunctions,BehaviorFunctions.DoMagic,1,self.me,200000107)
						BehaviorFunctions.AddDelayCallByTime(2.5,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.me)
					end
				end
			end
		end
	end

end

function Behavior2030301:EnterEntityCollider(instanceID,colliderEntity,partName)
	if instanceID == self.role and colliderEntity == self.me and partName == "Center" then
		local pState = BehaviorFunctions.GetEntityState(self.role)
		if pState == FightEnum.EntityState.Jump and self.finishPuzzle ~= true then
			self.finishPuzzle = true
		end
	end
end


