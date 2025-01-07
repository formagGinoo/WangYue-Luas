Behavior2020502 = BaseClass("Behavior2020502",EntityBehaviorBase)
--地脉之花-中
function Behavior2020502.GetGenerates()
	local generates = {2020203,900040,900042}
	return generates
end

--UI预加载
function Behavior2020502.GetUIGenerates()
	local generates = {
		FightEnum.PreLoadUI.RemoteDialog,--带头像的剧情对话框UI
		FightEnum.PreLoadUI.FightTalkDialog,--纯文字的剧情对话框UI
		FightEnum.PreLoadUI.GuideMask,--教学引导UI
		FightEnum.PreLoadUI.FightTips--中间横幅和底部横幅
	}
	return generates
end

function Behavior2020502:Init()

	--生态相关
	self.me = self.instanceId
	self.effectState = 0
	self.intercatDone = false


	--拒点相关
	self.distance = nil
	self.ecoGroup = {}             --生态分组
	self.monsterGroup = {}         --怪物分组
	self.currentEliteNum = 0   --当前剩余怪物数量
	self.currentMonsterNum = 0   --当前剩余怪物数量
	self.currentAlertNum = 0     --当前剩余警报器数量
	self.initState = 0
	self.done = false
	self.monster1 = 0
	self.monster2 = 0

	--引导相关
	self.canGuide = nil
	self.guideIcon = nil
	self.guideDistance = 60 --奖励指引距离
	self.fightDistance = 76 --战斗提示距离
	self.alarmDistance = 50 --警报距离
	self.warnTip = false
end

function Behavior2020502:LateInit()

end

function Behavior2020502:Update()
	self.time = BehaviorFunctions.GetFightFrame()/30
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.distance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.role)
	if self.initState == 0 then
		if not next(self.ecoGroup) then
			self.ecoGroup = BehaviorFunctions.GetEcoEntityGroup(nil,nil,self.me)
		end
		self.timeStart = self.time
		self.initState = 1
	elseif self.initState == 1 and self.time - self.timeStart > 5 then
		if next(self.ecoGroup) then
			for i,v in pairs(self.ecoGroup) do
				--精英
				if v.instanceId and BehaviorFunctions.CheckEntity(v.instanceId) 
					and BehaviorFunctions.GetEntityTemplateId(v.instanceId)==910040 then
					self.currentEliteNum = self.currentEliteNum + 1
				end
				--小怪
				if v.instanceId and BehaviorFunctions.CheckEntity(v.instanceId)
					and BehaviorFunctions.GetEntityTemplateId(v.instanceId)==900050 then
					self.currentMonsterNum = self.currentMonsterNum + 1
				end
				--警报
				if v.instanceId and BehaviorFunctions.CheckEntity(v.instanceId) 
					and BehaviorFunctions.GetEntityTemplateId(v.instanceId)==2030210 then
					self.currentAlertNum = self.currentAlertNum + 1
				end
			end
			self.initState =3
		end
	end
	if self.initState == 3 then
		if not self.done then
			if self.distance <= self.fightDistance then
				if not self.haveTip then
					BehaviorFunctions.ShowTip(10030002)
					BehaviorFunctions.ChangeSubTipsDesc(1,10030002,self.currentEliteNum)
					BehaviorFunctions.ChangeSubTipsDesc(2,10030002,self.currentMonsterNum)
					self.haveTip = true		
				end

				if self.currentAlertNum ~= 0  then
					BehaviorFunctions.ChangeSubTipsDesc(3,10030002,"！！警报未解除！！")
				else
					BehaviorFunctions.ChangeSubTipsDesc(3,10030002,"警报已解除")
				end				
			elseif self.distance >self.fightDistance and self.haveTip then
				BehaviorFunctions.HideTip()
				self.haveTip = false
				if BehaviorFunctions.CheckEntity(self.monster1) then
					BehaviorFunctions.RemoveEntity(self.monster1)
				end
				if BehaviorFunctions.CheckEntity(self.monster2) then
					BehaviorFunctions.RemoveEntity(self.monster2)
				end
			end
		end
		--消灭精英和小怪
		if not self.done and self.currentMonsterNum == 0 and self.currentEliteNum == 0 then
			if self.distance <= self.fightDistance then
				BehaviorFunctions.HideTip()
				self.done = true
				if self.canGuide == nil then
					self.canGuide = true
				end
				if BehaviorFunctions.CheckTaskId(102060301) then
					BehaviorFunctions.StartStoryDialog(102060401)
				end
			end
		end
	end
	--初始化结束，有警报器，且进入警报范围
	if self.initState == 3 and self.distance < self.alarmDistance and self.currentAlertNum ~= 0 and not self.done then
		if self.warnTip == false then
			local pos = BehaviorFunctions.GetPositionP(self.me)
			self.monster1 = BehaviorFunctions.CreateEntity(900040,nil,pos.x+2,pos.y,pos.z)
			self.monster2 = BehaviorFunctions.CreateEntity(900042,nil,pos.x-2,pos.y,pos.z)
			BehaviorFunctions.ShowTip(10030003)
			self.currentMonsterNum = self.currentMonsterNum + 2 
			BehaviorFunctions.ChangeSubTipsDesc(2,10030002,self.currentMonsterNum)
			self.warnTip = true
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
function Behavior2020502:Die(attackInstanceId,dieInstanceId)
	if self.initState == 3 then
		--小怪
		if BehaviorFunctions.GetEntityTemplateId(dieInstanceId)==900050 then
			if self.currentMonsterNum > 0 then
				self.currentMonsterNum = self.currentMonsterNum - 1
				BehaviorFunctions.ChangeSubTipsDesc(2,10030002,self.currentMonsterNum)
			end
		end
		
		--精英
		if BehaviorFunctions.GetEntityTemplateId(dieInstanceId)==910040 then
			if self.currentEliteNum > 0 then
				self.currentEliteNum = self.currentEliteNum - 1
				BehaviorFunctions.ChangeSubTipsDesc(1,10030002,self.currentEliteNum)
			end
		end
		--特殊小怪
		if dieInstanceId == self.monster1 or dieInstanceId == self.monster2 then
			self.currentMonsterNum = self.currentMonsterNum - 1
			BehaviorFunctions.ChangeSubTipsDesc(2,10030002,self.currentMonsterNum)
		end
		--警报
		if BehaviorFunctions.GetEntityTemplateId(dieInstanceId)==2030210 then
			self.currentAlertNum = self.currentAlertNum - 1
		end
	end
end

function Behavior2020502:WorldInteractClick(uniqueId)
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


function Behavior2020502:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
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


function Behavior2020502:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me and self.intercatDone == false then
		self.isTrigger = false
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
	end
end

function Behavior2020502:RemoveEntity(instanceId)
	if instanceId == self.me then
		if self.monster1 and BehaviorFunctions.CheckEntity(self.monster1) then
			BehaviorFunctions.RemoveEntity(self.monster1)
		end
		if self.monster2 and BehaviorFunctions.CheckEntity(self.monster2) then
			BehaviorFunctions.RemoveEntity(self.monster2)
		end
		if self.stand and BehaviorFunctions.CheckEntity(self.stand) then
			BehaviorFunctions.RemoveEntity(self.stand)
		end
	end
end