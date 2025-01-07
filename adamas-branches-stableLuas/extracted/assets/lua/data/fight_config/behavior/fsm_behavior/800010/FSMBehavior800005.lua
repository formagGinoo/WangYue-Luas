FSMBehavior800005 = BaseClass("FSMBehavior800005",FSMBehaviorBase)
--NPC通用AI：逃跑状态

--初始化
function FSMBehavior800005:Init()
	self.me = self.instanceId
	self.runStartFrame = nil
	self.runTime = 10
	self.inRemove = false
	
end


--初始化结束
function FSMBehavior800005:LateInit()


end

--帧事件
function FSMBehavior800005:Update()
	local frame = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if BehaviorFunctions.CanCtrl(self.me) then
		local roleAngle = BehaviorFunctions.GetEntityAngle(self.me,self.role)
		local escapeDir = 0
		if roleAngle <= 180 then
			escapeDir = 180 + roleAngle
		else
			escapeDir = roleAngle - 180
		end
		local myPos = BehaviorFunctions.GetPositionP(self.me)
		local directionPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,1,escapeDir)
		BehaviorFunctions.DoLookAtPositionByLerp(self.me,directionPos.x,directionPos.y,directionPos.z,nil,120,180)
		if BehaviorFunctions.GetEntityState(self.me) ~= FightEnum.EntityState.Move then
			BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)
			BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Run)
		end
	end
	--逃跑：传递犯罪坐标点
	if not BehaviorFunctions.GetBlackBoardValue(CustomFsmDataBlackBoardEnum.inCrime) then
		local myPos = BehaviorFunctions.GetPositionP(self.me)
		BehaviorFunctions.SetBlackBoardValue(CustomFsmDataBlackBoardEnum.inCrime,myPos)
	end
	if not self.runStartFrame then
		self.runStartFrame = frame
	elseif frame - self.runStartFrame >self.runTime*30 and not self.inRemove then
		BehaviorFunctions.CreateEntity(900000109,self.me)--消失
		BehaviorFunctions.AddDelayCallByTime(2.8,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.me)
		self.inRemove = true
	end
end