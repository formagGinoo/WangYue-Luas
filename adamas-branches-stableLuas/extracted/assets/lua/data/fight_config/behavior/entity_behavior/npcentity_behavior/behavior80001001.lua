Behavior80001001 = BaseClass("Behavior80001001",EntityBehaviorBase)
--旧刻刻
function Behavior80001001.GetGenerates()

end

function Behavior80001001:Init()
	self.me = self.instanceId
	self.taskState = 0
	self.StoryStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	self.NPCIdentity = {
		{name = '多闻',ecoID = 405,interactState = false, dialogID = 26001,storyDialogID = nil,uniqueID = nil},
		{name = '安晴',ecoID = 402,interactState = false, dialogID = 31001,storyDialogID = nil,uniqueID = nil},
		{name = '莉莉',ecoID = 404,interactState = false, dialogID = 29001,storyDialogID = nil,uniqueID = nil},
		{name = '于用',ecoID = 403,interactState = false, dialogID = 33001,storyDialogID = nil,uniqueID = nil},
		{name = '温度纱',ecoID = 406,interactState = false, dialogID = 36001,storyDialogID = nil,uniqueID = nil},
		{name = '阿飞',ecoID = 407,interactState = false, dialogID = 45001,storyDialogID = nil,uniqueID = nil},
		{name = '于静',ecoID = 408,interactState = false, dialogID = 48001,storyDialogID = nil,uniqueID = nil},
		{name = '多闻',ecoID = 409,interactState = false, dialogID = 61001,storyDialogID = nil,uniqueID = nil},
		
		{name = '市民',nickName = "村民1",ecoID = 41001,interactState = false, dialogID = 62001,storyDialogID = nil,uniqueID = nil, ecoAnim = "Sit"},
		{name = '市民',nickName = "村民2",ecoID = 41002,interactState = false, dialogID = 63001,storyDialogID = nil,uniqueID = nil, ecoAnim = "Sit"},
		{name = '市民',nickName = "村民3",ecoID = 41003,interactState = false, dialogID = 64001,storyDialogID = nil,uniqueID = nil, ecoAnim = "Sit"},
		{name = '市民',nickName = "村民4",ecoID = 41004,interactState = false, dialogID = 70001,storyDialogID = nil,uniqueID = nil, ecoAnim = "Yell"},
		{name = '市民',nickName = "村民5",ecoID = 41005,interactState = false, dialogID = 66001,storyDialogID = nil,uniqueID = nil, ecoAnim = "Count"},
		{name = '市民',nickName = "村民6",ecoID = 41006,interactState = false, dialogID = 65001,storyDialogID = nil,uniqueID = nil, ecoAnim = "Sit"},
		{name = '市民',nickName = "村民7",ecoID = 41007,interactState = false, dialogID = 71001,storyDialogID = nil,uniqueID = nil, ecoAnim = "Tanshou_loop"},
		{name = '市民',nickName = "村民8",ecoID = 41008,interactState = false, dialogID = 67001,storyDialogID = nil,uniqueID = nil, ecoAnim = "Stand1"},
		{name = '市民',nickName = "村民9",ecoID = 41009, ecoAnim = "Walk",patrolList = {"npc9Patrol1","npc9Patrol2","npc9Patrol3"}},
		{name = '市民',nickName = "村民10",ecoID = 41010,interactState = false, dialogID = 68001,storyDialogID = nil,uniqueID = nil, ecoAnim = "Stand1"},
		{name = '市民',nickName = "村民11",ecoID = 41011, ecoAnim = "Walk",patrolList = {"npc11Patrol1","npc11Patrol2"}},
		{name = '市民',nickName = "村民12",ecoID = 41012,interactState = false, dialogID = 75001,storyDialogID = nil,uniqueID = nil, ecoAnim = "Sit"},
		{name = '市民',nickName = "村民13",ecoID = 41013,interactState = false, dialogID = 74001,storyDialogID = nil,uniqueID = nil, ecoAnim = "Stanshou_loop"},
		{name = '市民',nickName = "村民14",ecoID = 41014,interactState = false, dialogID = 73001,storyDialogID = nil,uniqueID = nil, ecoAnim = "Baoxiong_loop"},
		{name = '市民',nickName = "村民15",ecoID = 41015, ecoAnim = "Walk",patrolList = {"npc15Patrol1","npc15Patrol2","npc15Patrol3","npc15Patrol4","npc15Patrol5","npc15Patrol6"}},
		{name = '市民',nickName = "村民16",ecoID = 41016,interactState = false, dialogID = 72001,storyDialogID = nil,uniqueID = nil, ecoAnim = "Sit"},
		{name = '市民',nickName = "村民17",ecoID = 41017,interactState = false, dialogID = 69001,storyDialogID = nil,uniqueID = nil, ecoAnim = "Stand1"},
		{name = '市民',nickName = "村民18",ecoID = 41018,interactState = false, dialogID = 71001,storyDialogID = nil,uniqueID = nil, ecoAnim = "Chayao_loop"},		
						}
	self.NpcAnimeBegin = false
	self.player = BehaviorFunctions.GetCtrlEntity()
	self.walkMode = false
	self.patrolNum = 1
	self.patrolList = nil
	self.inReturen = false
	self.myEuler = nil
	self.cantTurnAnim = {"Sit","Count","Yell"}
end


function Behavior80001001:Update()
	--self.player = BehaviorFunctions.GetCtrlEntity()
	--self:NPCProcess()
	
	--local ecoID = BehaviorFunctions.GetEntityEcoId(self.me)
	--if self.timeLineState ~= self.StoryStateEnum.Playing then
		--for i,k in ipairs(self.NPCIdentity) do
			--if self.NPCIdentity[i].ecoID == ecoID and self.NPCIdentity[i].storyDialogID == nil then
				--local taskDialog = BehaviorFunctions.GetEntityValue(self.me,"taskDialog")
				--self.NPCIdentity[i].storyDialogID = taskDialog
			--end
		--end
	--end
	----BehaviorFunctions.AddDelayCallByFrame(10,self,self.NpcAnim)
	--self:NpcAnim()
end

--下面这些是临时处理
function Behavior80001001:NPCProcess()
	--于静
	self:HideenNPC(408,{200100213})
	--阿飞
	self:HideenNPC(407,{200100213})
	--温度莎
	self:HideenNPC(406,{200100202})
	--城门口的多闻
	self:HideenNPC(405,{200100211,200100212})
	--树下的多闻
	self:HideenNPC(409,{200100213})
end

function Behavior80001001:NpcAnim()

	if BehaviorFunctions.CheckEntity(self.me) then
		local ecoID = BehaviorFunctions.GetEntityEcoId(self.me)

		--播放默认动作
		if self.NpcAnimeBegin == false then
			for i,k in ipairs(self.NPCIdentity) do
				if self.NPCIdentity[i].ecoID == ecoID and self.NPCIdentity[i].ecoAnim ~= nil then
					if self.NPCIdentity[i].ecoAnim ~= 'Walk' then
						BehaviorFunctions.PlayAnimation(self.me,self.NPCIdentity[i].ecoAnim)
						self.NpcAnimeBegin = true
					else
						if self.walkMode == false then
							BehaviorFunctions.PlayAnimation(self.me,self.NPCIdentity[i].ecoAnim)
							self.patrolList = self.NPCIdentity[i].patrolList
							self.walkMode = true
						end
					end
				end
			end
		end	
		if self.walkMode == true then
			--BehaviorFunctions.DoMoveForward(self.me,0.02)
			self:NpcPatrol(self.patrolList,true)
		end
	end
end

function Behavior80001001:NpcPatrol(positionList,canReturn)
	--目标点
	local nextPosition = BehaviorFunctions.GetTerrainPositionP(positionList[self.patrolNum],10020001,"Logic10020001_5")
	--当前点
	local myPosition = BehaviorFunctions.GetPositionP(self.me)
	--目标点和当前点的距离
	local distance = BehaviorFunctions.GetDistanceFromPos(myPosition,nextPosition)
	BehaviorFunctions.CancelLookAt(self.me)
	BehaviorFunctions.DoLookAtPositionImmediately(self.me,nextPosition.x,nil,nextPosition.z)
	--BehaviorFunctions.DoLookAtPositionByLerp(self.MonsterCommonParam.me,nextPosition.x,nil,nextPosition.z,false,0,180,-2)
	--判断距离,切换移动状态
		--没到目标点，朝着目标点走
		if distance >= 0.1 then
			BehaviorFunctions.DoMoveForward(self.me,0.02)
			--到达目标点，按规则切换下个目标点
		elseif distance < 0.1 then
			--不会折返
			if canReturn == false then
				if self.patrolNum < #positionList  then
					self.patrolNum = self.patrolNum + 1
				elseif self.patrolNum == #positionList  then
					self.patrolNum = 1
				end
				--会折返
			elseif canReturn == true then
				--没开始折返，正常巡逻
				if self.inReturen == false then
					if self.patrolNum < #positionList  then
						self.patrolNum = self.patrolNum + 1
					elseif self.patrolNum == #positionList  then
						self.inReturen = true
					end
					--开始折返，反向巡逻
				elseif self.inReturen == true then
					if self.patrolNum > 1  then
						self.patrolNum = self.patrolNum - 1
					elseif self.patrolNum == 1 then
						self.inReturen = false
					end
				end
			end
		end
end

function Behavior80001001:HideenNPC(EcoID,TaskLsit)
	local visbel = 0
	for i,TaskID in ipairs(TaskLsit) do
		if BehaviorFunctions.CheckTaskId(TaskID) == true then
			local ecoID = BehaviorFunctions.GetEntityEcoId(self.me)
			if ecoID == EcoID then
				if BehaviorFunctions.HasBuffKind(self.me,900000010) == false then
					BehaviorFunctions.DoMagic(self.me,self.me,900000010)
				end
				visbel = visbel + 1
			end
		elseif BehaviorFunctions.CheckTaskId(TaskID) == false and visbel == 0 then
			local ecoID = BehaviorFunctions.GetEntityEcoId(self.me)
			if ecoID == EcoID and self.timeLineState ~= self.StoryStateEnum.Playing then
				if BehaviorFunctions.HasBuffKind(self.me,900000010) == true then
					BehaviorFunctions.RemoveBuff(self.me,900000010)
				end
			end
		end
	end
end

function Behavior80001001:HiddenInteraction(EcoID,TaskID)
	local ecoID = BehaviorFunctions.GetEntityEcoId(self.me)
	if BehaviorFunctions.CheckTaskId(TaskID) and ecoID == EcoID then
		return true
	else
		return false
	end
end
--我是分割线


function Behavior80001001:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	for index,value in ipairs(self.NPCIdentity) do
		if uniqueId == self.NPCIdentity[index].uniqueID then
			if self.NPCIdentity[index].storyDialogID ~= nil then
				local canTurn = true
				self.myEuler = BehaviorFunctions.GetEntityEuler(self.me)
				for i,anim in ipairs(self.cantTurnAnim) do
					if self.NPCIdentity[index].ecoAnim == anim then
						canTurn = false
					end
				end
				if canTurn == true then
					--玩家和npc对视
					BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.player)
					BehaviorFunctions.DoLookAtTargetImmediately(self.player,self.me)
				end
				BehaviorFunctions.StartStoryDialog(self.NPCIdentity[index].storyDialogID,{})
				self.NPCIdentity[index].storyDialogID = nil
			elseif self.NPCIdentity[index].storyDialogID == nil then
				local canTurn = true
				self.myEuler = BehaviorFunctions.GetEntityEuler(self.me)
				for i,anim in ipairs(self.cantTurnAnim) do
					if self.NPCIdentity[index].ecoAnim == anim then
						canTurn = false
					end
				end
				if canTurn == true then
					--玩家和npc对视
					BehaviorFunctions.DoLookAtTargetImmediately(self.me,self.player)
					BehaviorFunctions.DoLookAtTargetImmediately(self.player,self.me)
				end
				BehaviorFunctions.StartStoryDialog(self.NPCIdentity[index].dialogID,{})
			end
			BehaviorFunctions.SetEntityValue(self.me,"diaLogState",true)
		end
	end
end


function Behavior80001001:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	local ecoID = BehaviorFunctions.GetEntityEcoId(triggerInstanceId)
	if triggerInstanceId == self.me then
		if ecoID ~= nil then
			if self.timeLineState == self.StoryStateEnum.Playing  then

			elseif self:HiddenInteraction(408,200100213) == true then
				
			elseif self:HiddenInteraction(407,200100213) == true then
				
			elseif self:HiddenInteraction(406,200100202) == true then
				
			elseif self:HiddenInteraction(405,200100211) == true then
			
			elseif self:HiddenInteraction(405,200100212) == true then
				
			elseif self:HiddenInteraction(409,200100213) == true then
				
			else
				for index,value in ipairs(self.NPCIdentity) do
					if self.NPCIdentity[index].ecoID == ecoID and self.NPCIdentity[index].interactState == false and self.NPCIdentity[index].dialogID ~= nil then
						--self.NPCIdentity[index].uniqueID = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Item,200001,self.NPCIdentity[index].name, 1)
						self.NPCIdentity[index].uniqueID = BehaviorFunctions.WorldNPCInteractActive(self.me,self.NPCIdentity[index].name)
						BehaviorFunctions.SetEntityValue(self.me,"UniID",self.NPCIdentity[index].uniqueID)
						self.NPCIdentity[index].interactState = true
					end
				end
			end
		elseif ecoID == nil then
			--for index,value in ipairs(self.NPCIdentity) do
				--if  self.NPCIdentity[index].interactState == false then
					----self.NPCIdentity[index].uniqueID = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Item,200001,self.NPCIdentity[index].name, 1)
					--self.NPCIdentity[index].uniqueID = BehaviorFunctions.WorldNPCInteractActive(self.me,self.NPCIdentity[index].name)
					--BehaviorFunctions.SetEntityValue(self.me,"UniID",self.NPCIdentity[index].uniqueID)
					--self.NPCIdentity[index].interactState = true
				--end
			--end
		end
	end
end

function Behavior80001001:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	local ecoID = BehaviorFunctions.GetEntityEcoId(triggerInstanceId)
	for index,value in ipairs(self.NPCIdentity) do
		if self.NPCIdentity[index].ecoID == ecoID and self.NPCIdentity[index].interactState == true then
			BehaviorFunctions.WorldInteractRemove(self.me,self.NPCIdentity[index].uniqueID)
			self.NPCIdentity[index].interactState = false
		end
	end
end

function Behavior80001001:StoryStartEvent(dialogId)
	self.timeLineState = self.StoryStateEnum.Playing
end

function Behavior80001001:StoryEndEvent(dialogId)
	self.timeLineState = self.StoryStateEnum.PlayOver
	local ecoID = BehaviorFunctions.GetEntityEcoId(self.me)
	for i,k in ipairs(self.NPCIdentity) do
		if self.NPCIdentity[i].ecoID == ecoID and self.NPCIdentity[i].storyDialogID ~= nil then
			self.NPCIdentity[i].storyDialogID = nil
		elseif self.NPCIdentity[i].ecoID == ecoID and self.NPCIdentity[i].dialogID ~= nil then
			if self.myEuler ~= nil then
				BehaviorFunctions.SetEntityEuler(self.me,self.myEuler.x,self.myEuler.y,self.myEuler.z)
			end
		end
	end
end