Behavior2020501 = BaseClass("Behavior2020501",EntityBehaviorBase)
--地脉之花
function Behavior2020501.GetGenerates()
	local generates = {2020203}
	return generates
end

--UI预加载
function Behavior2020501.GetUIGenerates()
	local generates = {
		FightEnum.PreLoadUI.RemoteDialog,--带头像的剧情对话框UI
		FightEnum.PreLoadUI.FightTalkDialog,--纯文字的剧情对话框UI
		FightEnum.PreLoadUI.GuideMask,--教学引导UI
		FightEnum.PreLoadUI.FightTips--中间横幅和底部横幅
	}
	return generates
end

function Behavior2020501:Init()
	
	--生态相关
	self.me = self.instanceId
	self.effectState = 0
	self.intercatDone = false
	
	
	--拒点相关
	self.distance = nil
	self.ecoGroup = {}             --生态分组
	self.monsterGroup = {}         --怪物分组
	self.monsterNum = 5            --拒点总怪物数量
	self.currentMonsterNum = nil   --当前剩余怪物数量
	self.initState = 0
	self.done = false
	
	--引导相关
	self.canGuide = nil
	self.guideIcon = nil
	self.guideDistance = 30 --奖励指引距离
	self.fightDistance = 38 --战斗提示距离
	self.haveTip = false    --是否有tips
	self.canActive = false
end

function Behavior2020501:LateInit()

end

function Behavior2020501:Update()
	self.time = BehaviorFunctions.GetFightFrame()/30
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.distance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.role)
	if not self.canActive and  BehaviorFunctions.CheckTaskId(102030301) or BehaviorFunctions.CheckTaskIsFinish(102030301) then
		self.canActive = true
	end
	if self.initState == 0 then
		if not next(self.ecoGroup) then
			self.ecoGroup = BehaviorFunctions.GetEcoEntityGroup(nil,nil,self.me)
		end
		self.timeStart = self.time
		self.initState = 1
	elseif self.initState == 1 and self.time - self.timeStart > 5 then
		if not next(self.monsterGroup) and next(self.ecoGroup) then
			for i,v in pairs(self.ecoGroup) do
				if BehaviorFunctions.GetNpcType(v.instanceId) and BehaviorFunctions.GetNpcType(v.instanceId)==FightEnum.EntityNpcTag.Monster then
					table.insert(self.monsterGroup,v)
				end
			end
			self.initState =2
		end
	elseif self.initState == 2 then
		self.currentMonsterNum = #self.monsterGroup	
		self.initState = 3 
	end
	if self.initState == 3 then
		if not self.done and self.currentMonsterNum ~=0 then
			if self.distance <= self.fightDistance then
				if self.haveTip == false then
					BehaviorFunctions.ShowTip(10030001)
					BehaviorFunctions.ChangeSubTipsDesc(1,10030001,self.currentMonsterNum)		
					self.haveTip = true
				end
			elseif self.distance >self.fightDistance and self.haveTip then
				BehaviorFunctions.HideTip()
				self.haveTip = false
			end
		elseif not self.done and self.currentMonsterNum ==0 then
			if self.distance <= self.fightDistance then
				BehaviorFunctions.HideTip()
				self.haveTip = false
				self.done = true
				if self.canGuide == nil then
					self.canGuide = true
				end
				if BehaviorFunctions.CheckTaskId(102030301) then
					BehaviorFunctions.SendTaskProgress(102030301,1,1)
				end
			end
		end	
	end

	if self.effectState == 0  and self.done then
		self.stand = BehaviorFunctions.CreateEntity(202020301,self.me)
		self.effectState =1 
	end
	
	--guideIcon显示
	if self.canGuide and BehaviorFunctions.CheckEntity(self.me) then
		if  BehaviorFunctions.GetDistanceFromTarget(self.me,self.role) <= self.guideDistance and self.guideIcon == nil then
			self.guideIcon = BehaviorFunctions.AddEntityGuidePointer(self.me,FightEnum.GuideType.TreasureBox,1.2)
		elseif BehaviorFunctions.GetDistanceFromTarget(self.me,self.role) > self.guideDistance and self.guideIcon then
			BehaviorFunctions.RemoveEntityGuidePointer(self.guideIcon)
			self.guideIcon = nil
		end
	end
end

function Behavior2020501:Die(attackInstanceId,dieInstanceId)
	if self.initState == 3 then
		for i,v in pairs(self.monsterGroup) do
			if 	dieInstanceId == v.instanceId then
				self.currentMonsterNum = self.currentMonsterNum - 1 
				BehaviorFunctions.ChangeSubTipsDesc(1,10030001,self.currentMonsterNum)
			end
		end
	end
end

function Behavior2020501:WorldInteractClick(uniqueId)
	if self.canActive then
		if self.interactUniqueId and self.interactUniqueId == uniqueId then
			if BehaviorFunctions.CheckTaskId(900000002) then
				BehaviorFunctions.SendTaskProgress(900000002,1,1)
			end
			if self.canGuide and self.guideIcon then
				self.canGuide = nil
				BehaviorFunctions.RemoveEntityGuidePointer(self.guideIcon)
				self.guideIcon = nil
			end
			BehaviorFunctions.CreateEntity(202020304,self.me)
			if self.stand then
				BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.stand)
				self.stand = nil
			end
			BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
			self.intercatDone = true
			BehaviorFunctions.InteractEntityHit(self.me,false)
		end
	end
end


function Behavior2020501:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.canActive then
		if self.done  then
			if self.intercatDone == false then
				if self.isTrigger then
					return
				end
				self.isTrigger = triggerInstanceId == self.me
				if not self.isTrigger then
					return
				end
				self.interactUniqueId = BehaviorFunctions.WorldInteractActive(WorldEnum.InteractType.Check,nil,"领取据点奖励",1)
			end
		end
	end
end


function Behavior2020501:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.canActive then
		if self.isTrigger and triggerInstanceId == self.me and self.intercatDone == false then
			self.isTrigger = false
			BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
		end
	end
end

function Behavior2020501:RemoveEntity(instanceId)
	if instanceId == self.me then
		if self.stand and BehaviorFunctions.CheckEntity(self.stand) then
			BehaviorFunctions.RemoveEntity(self.stand)
		end
	end
end