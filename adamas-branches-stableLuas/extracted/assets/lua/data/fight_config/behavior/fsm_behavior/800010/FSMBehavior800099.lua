FSMBehavior800099 = BaseClass("FSMBehavior800099",FSMBehaviorBase)
--NPC通用AI：对话状态

--初始化
function FSMBehavior800099:Init()
	self.me = self.instanceId
	self.interactIsOpne = false
	self.inTalk = false
	self.bornPos = nil
	self.reborn = nil
end


--初始化结束
function FSMBehavior800099:LateInit()
	if self.ParentBehavior.defaultDialogId and self.ParentBehavior.defaultDialogId >0 then
		BehaviorFunctions.SetEntityWorldInteractState(self.me,true)
		local posx, posy, posz = BehaviorFunctions.GetPosition(self.me)
		self.bornPos = Vec3.New(posx, posy, posz)
	end
end

--帧事件
function FSMBehavior800099:Update()
	if self.ParentBehavior.defaultDialogId and self.ParentBehavior.defaultDialogId >0 then
		if not self.interactIsOpne then
			BehaviorFunctions.SetEntityWorldInteractState(self.me,true)
			self.interactIsOpne = true
		end
		--五月版本临时需求：NPC主动靠近玩家开启对话
		local myPos = BehaviorFunctions.GetPositionP(self.me)
		local bornDistance = BehaviorFunctions.GetDistanceFromPos(self.bornPos,myPos)
		local role = BehaviorFunctions.GetCtrlEntity()
		local distance = BehaviorFunctions.GetDistanceFromTarget(self.me,role)
		--20m范围内跑向玩家
		if not self.reborn then
			if bornDistance <20  then
				if distance < 10 then
					BehaviorFunctions.DoLookAtTargetImmediately(self.me,role)
					if BehaviorFunctions.GetEntityState(self.me) ~= FightEnum.EntityState.Move then
						BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)
					end
					if distance < 3 then
						if BehaviorFunctions.GetEntityState(self.me) == FightEnum.EntityState.Move then
							BehaviorFunctions.StopMove(self.me)
						end
					end
				else
					if BehaviorFunctions.GetEntityState(self.me) == FightEnum.EntityState.Move then
						BehaviorFunctions.StopMove(self.me)
					end
				end
			else
				--超出范围就停下
				if BehaviorFunctions.GetEntityState(self.me) == FightEnum.EntityState.Move then
					BehaviorFunctions.StopMove(self.me)
				end
				--超出范围，且玩家走远了,返回出生点
				if distance > 3  and not self.reborn then
					self:PathFindingBegin(self.bornPos)
					if BehaviorFunctions.GetEntityState(self.me) ~= FightEnum.EntityState.Move then
						BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)
					end
					BehaviorFunctions.ChangeNpcBubbleContent(self.me,"没意思，真没意思",3)
					self.reborn = true
				end
			end
		end
	else
		if self.interactIsOpne then
			BehaviorFunctions.SetEntityWorldInteractState(self.me,false)
			self.interactIsOpne = false
		end	
	end
	if self.inPathFinding then
		if BehaviorFunctions.GetEntityState(self.me) ~= FightEnum.EntityState.Move then
			BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)
		end
	end
end


--寻路开始
function FSMBehavior800099:PathFindingBegin(pos)
	local result = BehaviorFunctions.SetPathFollowPos(self.me,pos)
	if result == true then
		self.inPathFinding = true
		--LogError(pos.x,pos.y,pos.z)
		return true
	else
		-- LogError("无法抵达该地点，已停止跟随".."坐标"..pos.x.." "..pos.y.." "..pos.z)
		return false
	end
end

--寻路结束
function FSMBehavior800099:PathFindingEnd(instanceId,result)
	if instanceId == self.me and result == true	then
		--抵达目标地点
		BehaviorFunctions.ClearPathFinding(self.me)
		self.reborn = false
		self.inPathFinding = false
	elseif instanceId == self.me and result == false then
		--寻路异常
		BehaviorFunctions.ClearPathFinding(self.me)
		self.inPathFinding = false
		LogError("无法抵达该地点，已停止跟随")
	end
end
