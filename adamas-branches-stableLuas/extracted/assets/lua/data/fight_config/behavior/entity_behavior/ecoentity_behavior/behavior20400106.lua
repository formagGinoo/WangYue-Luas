Behavior20400106 = BaseClass("Behavior20400106",EntityBehaviorBase)

--关卡交互实体
function Behavior20400106.GetGenerates()

end

function Behavior20400106:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.me = self.instanceId	
	
	self.myLevelId = 20400106 --创建的对应关卡Id
	
	--关卡挑战的状态
	self.myStateEnum = 
	{
		default = 1,		--未开启
		challengeStart = 2, --开启
		challenging =3,		--进行中
		challengLose = 4,	--输了
		challengWin = 5,	--赢了
		challengEnd = 6,	--结束
	}
	
	--关卡挑战的开始的状态
	self.myState = self.myStateEnum.default
	
end

function Behavior20400106:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.myState == self.myStateEnum.default then
		local result = BehaviorFunctions.CheckTaskIsFinish(302070101)
		local result2 = BehaviorFunctions.CheckTaskIsFinish(302070102)
		local result3 = BehaviorFunctions.CheckTaskIsFinish(302070103)
		if result and not result2 then
			self.myState = self.myStateEnum.challengeStart
		elseif result2 or result3 then
			self.myState = self.myStateEnum.challengWin
		end
	end
	
	--如果挑战开始关卡还没创建则创建
	if self.myState == self.myStateEnum.challengeStart then
		local result = BehaviorFunctions.CheckLevelIsCreate(self.myLevelId)
		if not result then
			BehaviorFunctions.AddLevel(self.myLevelId,nil,true)
		else
			self.myState = self.myStateEnum.challenging
		end
	--如果处于挑战中状态
	elseif self.myState == self.myStateEnum.challenging then
		--local result = BehaviorFunctions.CheckLevelIsCreate(self.myLevelId)
		--if not result then
			--local levelResult = BehaviorFunctions.GetEntityValue(self.me,"levelResult")
			--if levelResult == true then
				--self.myState = self.myStateEnum.challengWin
			--elseif levelResult == false then
				--self.myState = self.myStateEnum.challengLose	
			--end
		--end
		if BehaviorFunctions.CheckTaskIsFinish(302070103) then
			self.myState = self.myStateEnum.challengWin
		end
		
	--如果玩家胜利
	elseif self.myState == self.myStateEnum.challengWin then
		self.myState = self.myStateEnum.challengEnd
		BehaviorFunctions.InteractEntityHit(self.me,true)
		
	--如果玩家失败
	elseif self.myState == self.myStateEnum.challengLose then
		self.myState = self.myStateEnum.challengEnd	
		
	--如果处于挑战结束状态
	elseif self.myState == self.myStateEnum.challengEnd then
		
	end
end

--赋值
function Behavior20400106:Assignment(variable,value)
	self[variable] = value
end

function Behavior20400106:LevelLookAtPos(pos,type,frame,bindTransform)
	local fp1 = BehaviorFunctions.GetTerrainPositionP(pos,10020001,"World00207")
	local empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
	local camera = BehaviorFunctions.CreateEntity(type,nil,nil,nil,nil)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,empty)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(camera,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(camera,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(camera,empty)
	--延迟移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.SetEntityShowState,camera, false)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,empty)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,camera)
end

function Behavior20400106:NpcHack(npcId,type,state)
	if npcId == 8010250 and type == FightEnum.NpcHackType.Mail  and state == FightEnum.NpcHackState.Finish then
		if not BehaviorFunctions.CheckTaskIsFinish(302070101) then
			BehaviorFunctions.SendTaskProgress(302070101,1,1)
			--BehaviorFunctions.ShowCommonTitle(7,"发现城市威胁",true)
		end
	end
end

