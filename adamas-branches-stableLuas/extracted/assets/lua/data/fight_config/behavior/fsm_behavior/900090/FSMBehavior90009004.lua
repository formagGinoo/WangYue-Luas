FSMBehavior90009004 = BaseClass("FSMBehavior90009004",FSMBehaviorBase)
--NPC通用AI：警告状态
--警告状态下，npc会走到玩家附近，指指点点，强制对话

--初始化
function FSMBehavior90009004:Init()
	self.me = self.instanceId
	self.entityId = BehaviorFunctions.GetEntityTemplateId(self.me)
	self.pointSkillId = 900090904 
	self.alertState = 0
	self.AlertStateEnum = {
		Default = 0,
		WalkToPos = 1,
		Point = 2,
		Talk = 3,		
		}
	
	self.canWalk = false
	self.needPathFind = false
	self.inPathFind = false
	self.havePos = false
	self.inPoint = false
	
	self.alertDialogId = 601019301
	self.sorryDialogId = 601019302
	self.fightDialogId = 601019303
	self.alertChooseSorry = false
	self.alertChooseFight = false
end

--帧事件
function FSMBehavior90009004:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()
	local rolePos = BehaviorFunctions.GetPositionP(self.role)
	local myPos = BehaviorFunctions.GetPositionP(self.me)	
	local heightD = math.abs(rolePos.y - myPos.y) 
	local distance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.role)
	--进入警告流程：
	--判断能否寻路到玩家当前位置
	--判断对应点位navemesh是否可寻路到
	--如果有：直接寻过去
	--如果没有：传送到身边合法位置
	if self.alertState == self.AlertStateEnum.Default then
		if BehaviorFunctions.CheckObstaclesBetweenEntity(self.me,self.role) 
			or heightD > 2 then
			self.needPathFind = true
		else
			self.needPathFind = false			
		end	
		if self.needPathFind == true then
			if BehaviorFunctions.SetPathFollowEntity(self.me,self.role) then
				self.canWalk = true
			else
				--无法寻路到，直接传送
				self.canWalk = false			
			end
		else
			self.canWalk = true
		end
		self.alertState = self.AlertStateEnum.WalkToPos
	end
	--走到角色身边过程
	if self.alertState == self.AlertStateEnum.WalkToPos then
		--没法走了，想办法传送
		if self.canWalk == false then
			local navPos = BehaviorFunctions.GetRandomNavRationalPoint(self.role,3,5)
			--存在可循路点
			if navPos then
				BehaviorFunctions.DoSetPositionP(self.me,navPos)
			else
				--存在合法点
				for i = 20, 50 do --距离（分米）
					for r = 0,360 do --角度
						local roleLookPos = BehaviorFunctions.GetPositionOffsetBySelf(self.role,10,0)
						local transPos = BehaviorFunctions.GetPositionOffsetP(rolePos,roleLookPos,i/10,r)
						if BehaviorFunctions.CheckEntityCollideAtPosition(self.entityId,transPos.x,transPos.y,transPos.z,nil,self.me) then
							BehaviorFunctions.DoSetPositionP(self.me,transPos)
							self.havePos = true
							break
						end
					end
				end
			end
			self.alertState = self.AlertStateEnum.Point
		else
		--能走
			if self.needPathFind and not self.inPathFind then
				BehaviorFunctions.SetPathFollowEntity(self.me,self.role)
			elseif not self.needPathFind then
				BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.role)
			end
			if BehaviorFunctions.GetEntityState(self.me) ~= FightEnum.EntityState.Move and distance >= 3 then
				BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)
			elseif distance < 3 then
				BehaviorFunctions.StopMove(self.me)
				self.alertState = self.AlertStateEnum.Point
			end
		end
	end
	--对着玩家指指点点，强制触发对话
	if self.alertState == self.AlertStateEnum.Point and not self.inPoint then
		BehaviorFunctions.CastSkillByTarget(self.me,self.pointSkillId,self.role)
		BehaviorFunctions.StartNPCDialog(self.alertDialogId,self.me)
		self.ParentBehavior.inAlertTalk = true
		self.inPoint = true
		--BehaviorFunctions.CustomFSMTryChangeState(self.me)
	end
end

--选项：认怂或反抗
function FSMBehavior90009004:StoryPassEvent(dialogId)
	if dialogId == self.sorryDialogId then
		self.alertChooseSorry = true
		--待补：进局子表现
		BehaviorFunctions.CustomFSMTryChangeState(self.me)
	elseif dialogId == self.fightDialogId then
		self.alertChooseFight = true
		BehaviorFunctions.CustomFSMTryChangeState(self.me)
	end
end