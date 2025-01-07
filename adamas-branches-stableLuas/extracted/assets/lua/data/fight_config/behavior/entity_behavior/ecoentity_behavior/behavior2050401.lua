Behavior2050401 = BaseClass("Behavior2050401",EntityBehaviorBase) 
--咖啡馆管理器
function Behavior2050401.GetGenerates()
	local generates = {900070,8010007,900090}
	return generates
end

function Behavior2050401:Init()
	self.me = self.instanceId
	self.outsideTip = false
	self.outsideDialogId = 601019401
	self.createState = 0
	self.inRoom = false
	self.wxTip = false
	self.bossWalk =false
	self.walkState =0
end

function Behavior2050401:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.createState == 0 then
		local bossPos = BehaviorFunctions.GetTerrainPositionP("CBoss",10020004,"PV04")
		local monPos = BehaviorFunctions.GetTerrainPositionP("CMonster",10020004,"PV04")
		local pPos = BehaviorFunctions.GetTerrainPositionP("CPolice",10020004,"PV04")
		self.boss = BehaviorFunctions.CreateEntityByEntity(self.me,8010007,bossPos.x,bossPos.y,bossPos.z,nil,nil,nil)
		self.monster = BehaviorFunctions.CreateEntityByEntity(self.me,900070,monPos.x,monPos.y,monPos.z,nil,nil,nil)
		self.police = BehaviorFunctions.CreateEntityByEntity(self.me,900090,pPos.x,pPos.y,pPos.z,nil,nil,nil)
		--npc蹲下
		BehaviorFunctions.CastSkillBySelfPosition(self.boss,80001003)
		--BehaviorFunctions.CastSkillBySelfPosition(self.monster,900070099)
		self.createState = 1
	end
	if self.bossWalk and self.walkState == 0 then
		BehaviorFunctions.DoSetEntityState(self.boss,FightEnum.EntityState.Move)
		BehaviorFunctions.DoLookAtTargetImmediately(self.boss,self.role)
		self.walkState = 1
	elseif self.walkState == 1 and BehaviorFunctions.GetDistanceFromTarget(self.role,self.boss) < 3 then
		BehaviorFunctions.StopMove(self.boss)
		local entity = BehaviorFunctions.GetEntity(self.boss)
		if entity and entity.stateComponent:IsState(FightEnum.EntityState.Idle) then
			BehaviorFunctions.StartNPCDialog(601019501,self.boss)
			BehaviorFunctions.PlayAnimation(self.boss,"Jump",FightEnum.AnimationLayer.BaseLayer)
			self.walkState = 99
		end
	end
end

function Behavior2050401:EnterArea(triggerInstanceId, areaName, logicName)
	--外部提示
	if self.outsideTip == false and triggerInstanceId == self.role and areaName == "OutCoffeeArea" and logicName == "PV04" then
		BehaviorFunctions.StartStoryDialog(self.outsideDialogId)
		self.outsideTip = true
	end
	if self.inRoom == false and triggerInstanceId == self.role and areaName == "InCoffeeArea" and logicName == "PV04" then
		self.inRoom = true
	end
end

function Behavior2050401:ExitArea(triggerInstanceId, areaName, logicName)
	--外部提示
	if self.inRoom == true and triggerInstanceId == self.role and areaName == "InCoffeeArea" and logicName == "PV04" then
		self.inRoom = false
	end
end

function Behavior2050401:WorldInteractClick(uniqueId, instanceId)
	if not self.inRoom then
		return
	end	
	BehaviorFunctions.CustomFSMTryChangeState(self.boss)
end

function Behavior2050401:Hacking(instanceId)
	if instanceId ~= self.boss then
		return
	end
	if not self.wxTip then
		BehaviorFunctions.ShowCommonTitle(7,"发现城市威胁",true)
		self.wxTip = true
	end
end

function Behavior2050401:Die(attackInstanceId,dieInstanceId, deathReason)
	if dieInstanceId == self.monster then
		BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
		BehaviorFunctions.CastSkillBySelfPosition(self.boss,80001004)
	end
end

function Behavior2050401:StoryEndEvent(dialogId)
	if dialogId == 601019501 then
		local award = BehaviorFunctions.GetEcoEntityByEcoId(3002101040003)
		BehaviorFunctions.InteractEntityHit(award)
		local doorLocker = BehaviorFunctions.GetEcoEntityByEcoId(2002101040064)
		BehaviorFunctions.InteractEntityHit(doorLocker)
	end
end

function Behavior2050401:FinishSkill(instanceId,skillId,skillSign,skillType)
	if skillId == 80001004 then
		self.bossWalk = true
	end
end