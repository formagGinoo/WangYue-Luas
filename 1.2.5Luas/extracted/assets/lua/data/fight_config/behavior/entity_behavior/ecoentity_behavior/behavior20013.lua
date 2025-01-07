Behavior20013 = BaseClass("Behavior20013",EntityBehaviorBase)
--骇入解救npc

function Behavior20013.GetGenerates()
	local generates = {8011001}
	return generates
end

function Behavior20013:Init()
	self.me = self.instanceId
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.missionState = 0
	self.npc1Id = 0
	self.isInArea = nil
	self.target = 0
	--怪物状态
	
	--关卡控制参数
	self.flag1 = true

	--self.delayCallId = 0

	--挑战是否开启
	self.challengeStart = false
	--挑战是否结束
	self.challengeEnd = false
	--挑战是否成功
	self.challengeSuccece = nil

	--显示路标
	self.showSelf = true
	
	self.guide = nil
	self.enter = nil

	self.interactUniqueId = 0
end


function Behavior20013:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()

	--召唤npc
	if self.flag1 == true then
		self.flag1 = false
		local pos1 = BehaviorFunctions.GetTerrainPositionP("ch_npc1",self.levelId,"world10020001_shoujitiaozhan")
		self.npc1Id = BehaviorFunctions.CreateEntity(8011001,nil,pos1.x,pos1.y,pos1.z)
		--要先用showheadtips，并且和改变气泡内容及显隐不能在同一帧跑
		BehaviorFunctions.ShowCharacterHeadTips(self.npc1Id,true)
	end
	
	if self.npc1Id then
		local pos = BehaviorFunctions.GetDistanceFromTarget(self.role,self.npc1Id)
		if pos <= 3 then
			self.enter = true
		else
			self.enter = false
		end
		--交互列表
		if self.enter then
			if self.isTrigger then
				return
			end
			self.isTrigger = self.npc1Id
			if not self.isTrigger then
				return
			end
			self.interactUniqueId = BehaviorFunctions.WorldInteractActive(WorldEnum.InteractType.Unlock,nil,"对话",1)
		else
			if self.isTrigger  then
				self.isTrigger = false
				BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
			end
		end
	end
	
	
	--npc对话后判断是否还在区域内
	if self.missionState == 3 then
		if self.target == 0 then
			local posCon = BehaviorFunctions.GetTerrainPositionP("ch_center",self.levelId,"world10020001_shoujitiaozhan")
			self.target = BehaviorFunctions.CreateEntity(2001,nil,posCon.x,posCon.y,posCon.z)
		end
		
		local posEnd = BehaviorFunctions.GetDistanceFromTarget(self.role,self.target)
		if posEnd >= 15 then
			self.isInArea = false
		end
		
		--离开区域后改任务状态,改变npc位置
		if self.isInArea == false then
			self.missionState = 4
			self:Remake()
		end
	end
	


	--挑战结束
	--if self.challengeSuccece ~= nil and self.challengeEnd == false then
		--if self.challengeSuccece == true then
			--BehaviorFunctions.InteractEntityHit(self.me, false)
			--self:ChallengeFinish("已成功",true)
			--self.challengeEnd = true
		--end
	--end
end


--挑战开始
--function Behavior20013:ChallengeStart(challangeName)
	----开始挑战
	--self.challengeStart = true
--end

----挑战结束
--function Behavior20013:ChallengeFinish(challangeName,isSuccese)
	--if isSuccese then
		--BehaviorFunctions.ShowCommonTitle(5,challangeName,true)
	--end
--end

function Behavior20013:WorldInteractClick(uniqueId)
		if self.interactUniqueId and self.interactUniqueId == uniqueId then
			--一阶段交互气泡以及玩家在区域内对话后改任务状态
			if self.missionState == 0 then
				--BehaviorFunctions.ShowCharacterHeadTips(self.npc1Id,true)
				BehaviorFunctions.ChangeNpcBubbleContent(self.npc1Id,"脉者大人，你可以帮助我逃离这个鬼地方吗？",5)
				BehaviorFunctions.SetNonNpcBubbleVisible(self.npc1Id,true)
				self.missionState = 1
			
			elseif self.missionState == 1 then
				--BehaviorFunctions.ShowCharacterHeadTips(self.npc1Id,true)
				BehaviorFunctions.ChangeNpcBubbleContent(self.npc1Id,"这是...机匣？太好了！",5)
				BehaviorFunctions.SetNonNpcBubbleVisible(self.npc1Id,true)
				self.missionState = 2
			
			elseif self.missionState == 2 then
				BehaviorFunctions.ChangeNpcBubbleContent(self.npc1Id,"在铁丝网旁边建造机匣也许就能让我出去了，我们外面见！",8)
				BehaviorFunctions.SetNonNpcBubbleVisible(self.npc1Id,true)
				self.missionState = 3
			

				
			--二阶段交互后气泡
			elseif self.missionState == 4 then
				BehaviorFunctions.ShowCharacterHeadTips(self.npc1Id,true)
				BehaviorFunctions.ChangeNpcBubbleContent(self.npc1Id,"谢谢你，脉者大人！",5)
				BehaviorFunctions.SetNonNpcBubbleVisible(self.npc1Id,true)
				--对话后黑幕
				BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,true,0)
				BehaviorFunctions.AddDelayCallByTime(5,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1)
				--显示宝箱
				BehaviorFunctions.AddDelayCallByTime(4,BehaviorFunctions,BehaviorFunctions.ChangeEcoEntityCreateState,2002060667,true)
				--移除交互列表
				BehaviorFunctions.AddDelayCallByTime(5,BehaviorFunctions,BehaviorFunctions.WorldInteractRemove,self.interactUniqueId)
				--逻辑实体删除
				BehaviorFunctions.AddDelayCallByTime(5,BehaviorFunctions,BehaviorFunctions.InteractEntityHit,self.me,false)
			end
			--BehaviorFunctions.WorldInteractRemove(self.interactUniqueId) --移除
		end
end

--function Behavior20011:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	--if self.showSelf then
		--if self.isTrigger then
			--return
		--end

		--self.isTrigger = triggerInstanceId == self.me
		--if not self.isTrigger then
			--return
		--end
		
		--self.interactUniqueId = BehaviorFunctions.WorldInteractActive(WorldEnum.InteractType.Talk,nil,"开启挑战", 1)
	--end
--end


--function Behavior20011:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	--if self.showSelf then
		--if self.isTrigger and triggerInstanceId == self.me then
			--self.isTrigger = false
			--BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
		--end
	--end
--end

function Behavior20013:Remake()
	--黑幕+传送
	BehaviorFunctions.ShowBlackCurtain(true,0)
	local remakePos = BehaviorFunctions.GetTerrainPositionP("ch_end1",10020001,"world10020001_shoujitiaozhan")
	BehaviorFunctions.InMapTransport(remakePos.x,remakePos.y,remakePos.z)
	--npc位置改变
	BehaviorFunctions.RemoveEntity(self.npc1Id)
	self.npc1Id = BehaviorFunctions.CreateEntity(8011001,nil,remakePos.x+1.5,remakePos.y-0.5,remakePos.z+1.5)
	BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1)
	BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.DoLookAtTargetImmediately,self.npc1Id,self.role)
	BehaviorFunctions.AddDelayCallByTime(2,self,self.CameraEnd)
end

function Behavior20013:CameraEnd()
	--看向终点镜头
	local fp1 = BehaviorFunctions.GetPositionP(self.npc1Id)
	self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y+1,fp1.z)
	self.levelCam = BehaviorFunctions.CreateEntity(22001)
	BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
	--延时移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(15,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
	BehaviorFunctions.AddDelayCallByFrame(15,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
end

function Behavior20013:RemoveEntity(instancedId)
	--逻辑实体被移除后需要移除npc
	if instancedId == self.me then
		if self.npc1Id and BehaviorFunctions.CheckEntity(self.npc1Id) then
			BehaviorFunctions.RemoveEntity(self.npc1Id)
		end
	end
end