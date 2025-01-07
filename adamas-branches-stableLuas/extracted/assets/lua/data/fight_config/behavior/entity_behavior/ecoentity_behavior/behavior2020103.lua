Behavior2020103 = BaseClass("Behavior2020103",EntityBehaviorBase)
--气脉树
function Behavior2020103.GetGenerates()

end

function Behavior2020103:Init()
	self.me = self.instanceId
	self.taskState = 0
	self.animationFrame = 0
	self.playFrame = 0
	self.playState = 0

	--指引相关
	self.guideDistance = 30 --指引距离
	self.canGuide = nil
	self.guideIcon = nil
	self.localActive = nil
	self.canInteract = true
	
	--是否将叙慕编入队伍
	self.hasXumu = false
end


function Behavior2020103:Update()
	self.role = BehaviorFunctions.GetCtrlEntity	()
	self.EcoId = BehaviorFunctions.GetEntityEcoId(self.me)
	self.isActive = BehaviorFunctions.CheckEntityEcoState(self.me)
	self.myFrame = BehaviorFunctions.GetEntityFrame(self.me)
	
	--没到目标任务进度前不开启
	if not self.canInteract then
		if BehaviorFunctions.CheckTaskIsFinish(104011101) then
			self.canInteract = true
		end
	end
	
	--如果没有叙慕则强制引导玩家换上叙慕
	if not self.hasXumu then
		local currentFormation = BehaviorFunctions.GetCurFormationRoleList()--获取当前队伍人物
		for i,v in ipairs(currentFormation.roleList) do
			if v == 1001001 then
				self.hasXumu = true
				break
			end
		end
	else
		local currentFormation = BehaviorFunctions.GetCurFormationRoleList()--获取当前队伍人物
		for i,v in ipairs(currentFormation.roleList) do
			if v == 1001001 then
				self.hasXumu = true
				break
			end
			self.hasXumu = false
		end
	end
	
    --已激活用策划动作
	if self.isActive and self.playState == 0 then
		BehaviorFunctions.PlayAnimation(self.me,"FxQiActived")
		self.playState = 999
	elseif not self.isActive and not self.localActive then
		if self.canGuide == nil  then
			self.canGuide = true
		end
	end

	--guideIcon显示
	if self.canGuide and BehaviorFunctions.CheckEntity(self.me) then
		if  BehaviorFunctions.GetDistanceFromTarget(self.me,self.role) <= self.guideDistance and self.guideIcon == nil then
			self.guideIcon = BehaviorFunctions.AddEntityGuidePointer(self.me,FightEnum.GuideType.Transport,2.7)
		elseif BehaviorFunctions.GetDistanceFromTarget(self.me,self.role) > self.guideDistance and self.guideIcon then
			BehaviorFunctions.RemoveEntityGuidePointer(self.guideIcon)
			self.guideIcon = nil
		end
	end

end


function Behavior2020103:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	if self.canInteract == true and self.hasXumu == true then
		if self.interactUniqueId and self.interactUniqueId == uniqueId then
			self.localActive = true
			if self.canGuide and self.guideIcon then
				self.canGuide = nil
				BehaviorFunctions.RemoveEntityGuidePointer(self.guideIcon)
				self.guideIcon = nil
			end
			--复活玩家
			self.playerFormation = BehaviorFunctions.GetCurFormationEntities()
			for index,instanceId in ipairs(self.playerFormation) do
				--复活magic
				BehaviorFunctions.DoMagic(instanceId,instanceId,200000111)
				--回血magic
				BehaviorFunctions.DoMagic(instanceId,instanceId,200000014)
			end
			
			--强制切换玩家前台
			self:ForceSwitchRoleCharacter(1001001)
			
			BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
			--临时创建副本
			BehaviorFunctions.CreateDuplicate(2015)
			----传送相关逻辑
			--BehaviorFunctions.ShowWeakGuide(10009)
			--BehaviorFunctions.InteractEntityHit(self.me,FightEnum.SysEntityOpType.Transport)
			--BehaviorFunctions.ShowTip(3001011)
			BehaviorFunctions.PlayAnimation(self.me,"FxQiActive")
			self.playFrame = self.myFrame
			self.effectPlayFrame = self.myFrame
			self.playState = 1
			self.effectState = 1
			self.isTrigger = false
		end
	--如果能交互但是叙慕不在编队
	elseif self.canInteract == true and self.hasXumu == false then
		BehaviorFunctions.LeaveFighting()
		BehaviorFunctions.PlayGuide(2207,1,1)
		BehaviorFunctions.SetPlayerAttr(43,99999)
	else
		if self.interactUniqueId and self.interactUniqueId == uniqueId then
			BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
			--似乎没有任何反应，以后再来吧
			BehaviorFunctions.ShowTip(32000005)
		end
	end
end


function Behavior2020103:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.canInteract == true then
		if self.isTrigger then
			return
		end

		self.isTrigger = triggerInstanceId == self.me
		if not self.isTrigger then
			return
		end
		self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Transport,nil,"进入脉树", 1)
	else
		if self.isTrigger then
			return
		end

		self.isTrigger = triggerInstanceId == self.me
		if not self.isTrigger then
			return
		end
		self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Transport,nil,"???", 1)
	end
end
--end


function Behavior2020103:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me then
		self.isTrigger = false
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	end
end


function Behavior2020103:ForceSwitchRoleCharacter(RoleEntityID)
	--替换玩家队伍1号位为目标
	local currentFormation = BehaviorFunctions.GetCurFormationRoleList()--获取当前队伍人物
	local targetFormation = TableUtils.CopyTable(currentFormation)

	for i,v in ipairs(targetFormation.roleList) do
		if v == RoleEntityID then
			local currentRole = BehaviorFunctions.GetCtrlEntity()
			if BehaviorFunctions.GetEntityTemplateId(currentRole) + 1000000 ~= RoleEntityID then
				local curFormationIns = BehaviorFunctions.GetCurFormationEntities()
				for i2,v2 in ipairs(curFormationIns) do
					local entityID = BehaviorFunctions.GetEntityTemplateId(v2)
					if entityID + 1000000 == RoleEntityID then
						BehaviorFunctions.CallBehaviorFuncByEntityEx(Behavior1000001,"ChangeRole",1,currentRole,v2)
						break
					end
				end
			end
			break
		end
	end
end