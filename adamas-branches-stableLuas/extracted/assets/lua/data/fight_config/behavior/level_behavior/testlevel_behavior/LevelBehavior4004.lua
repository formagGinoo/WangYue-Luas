LevelBehavior4004 = BaseClass("LevelBehavior4004",LevelBehaviorBase)
--NPC抢劫AI演示Demo
--BehaviorFunctions.AddLevel(4004)
function LevelBehavior4004:__init(fight)
	self.fight = fight
end


function LevelBehavior4004.GetGenerates()
	local generates = {
		8010010,808011003,8011012,8010004,8010007,8010005,8010991,8010992,
		2030510,2030505,
		2030222,2030223,2030225,
		}
	return generates
end


function LevelBehavior4004:Init()
	self.missionState = 0
	self.pos = 0
	self.actState = 0
	self.timeStart= 0
	self.npc3ActState = 0
	self.npc3runStartTime = 0
	self.npc4ActState = 0
	self.npc4ActStartTime = 0
	self.npc5ActState = 0
	self.GOAPChange1 = false
	self.GOAPChange2 = false
	
	self.alertState = 0
	self.GOAPPlannerChoosen = false
	self.ChoosenPlanner = 0
	self.GOAPisShow = false
	self.GOAPAttr = {
		{50,100,10,10,100,20,20,100,100,100},
		{50,40,100,100,30,40,10,10,50,20},
		{50,60,80,10,10,60,10,10,100,100},
		{10,100,10,10,80,60,100,100,100,10},
		{100,100,100,10,100,20,100,100,100,20},	
		}
	self.ChoosenPlannerIsShow = false
	self.ShowChoosenPlannerNum = 0
	self.Action = {
		{"攻击目标(近)","攻击目标(远)","威胁目标","劝说目标","远离目标","靠近目标","逃离目标","躲起来","开门","主动对话","表达善意","观察","undefined","undefined","undefined","undefined"},
		{"攻击目标(近)","攻击目标(远)","威胁目标","劝说目标","远离目标","靠近目标","逃离目标","追击目标","与实体交互","主动对话","表达害怕","开门","关门","undefined","undefined","undefined"},
		{"攻击目标(近)","攻击目标(远)","威胁目标","劝说目标","远离目标","靠近目标","逃离目标","与实体交互","躲起来","偷窃","undefined","undefined","undefined","undefined","undefined","undefined"},
		{"攻击目标(近)","攻击目标(远)","威胁目标","劝说目标","远离目标","靠近目标","逃离目标","示弱","主动对话","与实体交互","表达善意","undefined","undefined","undefined","undefined","undefined"},
		{"攻击目标(近)","攻击目标(远)","威胁目标","劝说目标","远离目标","靠近目标","追击目标","与实体交互","主动对话","离开椅子","表达善意","undefined","undefined","undefined","undefined","undefined"},
	}
	self.Cost = {
		{99,99,52,28,12,85,23,9,39,54,93,4,9999,9999,9999,9999},
		{40,30,10,50,60,10,9999,9999,9999,9999,9999,10,1,9999,9999,9999},
		{99,99,99,99,40,10,80,20,10,10,9999,9999,9999,9999,9999,9999},
		{40,9999,60,99,20,3,99,3,40,20,9999,9999,9999,9999,9999,9999},
		{80,70,40,20,54,20,9999,9999,60,1,99,9999,9999,9999,9999,9999},
	}
	self.Goal ={
		"规避风险",
		"制造混乱",
		"偷鸡摸狗",
		"忍辱负重",
		"见义勇为"
	}
	self.ActionSelect ={
		{5,9,7,8,12},
		{12,13,6,3},
		{9,6,8,10},
		{6,8,5,10,1},
		{10,6,4},
		}
	--劫匪战斗
	self.npc2Action2 = {"攻击目标(近)","攻击目标(远)","威胁目标","劝说目标","远离目标","靠近目标","逃离目标","追击目标","与实体交互","主动对话","表达害怕","开门","关门","undefined","undefined","undefined"}
	self.npc2Cost2 = {60,10,99,99,99,99,99,99,99,99,99,99,99,9999,9999,9999}
	self.npc2Goal2 = "战斗"
	self.npc2ActionSelect2 = {2}
	--老板一起战斗
	self.npc4Action2 = {"攻击目标(近)","攻击目标(远)","威胁目标","劝说目标","远离目标","靠近目标","逃离目标","示弱","主动对话","关门","表达善意","undefined","undefined","undefined","undefined","undefined"}
	self.npc4Cost2 = {10,9999,99,99,99,99,99,99,99,99,99,9999,9999,9999,9999,9999}
	self.npc4Goal2 = "战斗"
	self.npc4ActionSelect2 = {1}
	--老板表达感谢
	self.npc4Cost3 = {99,99,99,99,99,99,99,99,99,99,1,9999,9999,9999,9999,9999}
	self.npc4Goal3 = "感谢"
	self.npc4ActionSelect3 = {11}
	--小偷示弱、逃跑
	self.npc3Action2 = {"攻击目标(近)","攻击目标(远)","威胁目标","劝说目标","远离目标","靠近目标","逃离目标","与实体交互","躲起来","偷窃","示弱","undefined","undefined","undefined","undefined","undefined"}
	self.npc3Cost2 = {99,99,99,99,10,99,20,99,60,99,10,9999,9999,9999,9999,9999}
	self.npc3Goal2 = "规避风险"
	self.npc3ActionSelect2 = {11,5,7}
	--愤怒追击
	self.npc5Action2 = {"攻击目标(近)","攻击目标(远)","威胁目标","劝说目标","远离目标","靠近目标","追击目标","与实体交互","主动对话","离开椅子","表达善意","undefined","undefined","undefined","undefined","undefined"}
	self.npc5Cost2 = {40,99,99,60,99,20,30,99,99,99,99,9999,9999,9999,9999,9999}
	self.npc5ActionSelect2 = {7,1}
	self.npc5Goal2 = "见义勇为"
	--鼓掌
	self.npc5Action3 = {"攻击目标(近)","攻击目标(远)","威胁目标","劝说目标","远离目标","靠近目标","追击目标","与实体交互","主动对话","离开椅子","表达善意","undefined","undefined","undefined","undefined","undefined"}
	self.npc5Cost3 = {99,99,99,99,99,3,99,99,99,99,1,9999,9999,9999,9999,9999}
	self.npc5ActionSelect3 = {11}
	self.npc5Goal3 = "示好"
	
	self.npc2deathPos = nil 
end

function LevelBehavior4004:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		self.pos = BehaviorFunctions.GetTerrainPositionP("role",self.levelId)
		BehaviorFunctions.DoSetPositionP(self.role,self.pos)
		GOAPPerform.Activity(true)
		self.GOAPPlannerChoosen = false
		self.ChoosenPlanner = 0
		--BehaviorFunctions.AddDelayCallByFrame(5,self,self.GOAPShowInit)
		--清空属性、目标、行为列表
		--怯战蜥蜴
		self.npc1 = self:CreateActor(8011012,"npc1")
		--劫匪
		self.npc2 = self:CreateActor(8010991,"npc2")
		--偷钱仔
		self.npc3 = self:CreateActor(8010007,"npc3")
		--店老板
		self.npc4 = self:CreateActor(8010992,"npc4")
		--愤怒
		self.npc5 = self:CreateActor(8010005,"npc5")
		--NPC列表
		self.npcInstanceList = {self.npc1,self.npc2,self.npc3,self.npc4,self.npc5}
		--摄像头
		self.monitor1 = self:CreateActor(2030510,"monitor1")
		self.monitor2 = self:CreateActor(2030510,"monitor2")
		self.monitor3 = self:CreateActor(2030505,"monitor3")
		--破坏物
		self.table1 = self:CreateActor(2030222,"table1")
		self.table2 = self:CreateActor(2030222,"table2")
		self.xuanguan = self:CreateActor(2030225,"xuanguan")
		self.huajia = self:CreateActor(2030223,"huajia")
		--钢管
		self.gangguan = self:CreateActor(801099201,"ironbar")
		
		
		self.timeStart = self.time
		self.missionState = 1
	end
	if self.missionState == 1 and self.time - self.timeStart == 30  then
		self:GOAPPerform()
		self:GOAPShowChoosenNpc()
	end
	if self.missionState == 10 and self.time - self.timeStart > 30 then
		BehaviorFunctions.SetEntityValue(1,"open",true)
		local npcRunPos = BehaviorFunctions.GetTerrainPositionP("npc1run",self.levelId)
		BehaviorFunctions.SetPathFollowPos(self.npc1,npcRunPos)
		BehaviorFunctions.DoSetEntityState(self.npc1,FightEnum.EntityState.Move)
		BehaviorFunctions.DoSetMoveType(self.npc1,FightEnum.EntityMoveSubState.Run)
		BehaviorFunctions.ChangeNpcBubbleContent(self.npc1,"快跑啊！光天化日有人抢劫啦",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.npc1,true)
		BehaviorFunctions.PlayAnimation(self.npc2,"Fire_Shoot_loop")
		BehaviorFunctions.PlayAnimation(self.npc3,"Water")
		self.npc3ActState = 1
		BehaviorFunctions.PlayAnimation(self.npc4,"Squat_loop")
		BehaviorFunctions.PlayAnimation(self.npc5,"Point")
		
		BehaviorFunctions.ChangeNpcBubbleContent(self.npc2,"钱放在哪了？交出来",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.npc2,true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.npc4,"我知道你很急，但你先别急",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.npc4,true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.npc5,"好大的胆子！",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.npc5,true)
		
		
		self.missionState = 20
	end
	if self.missionState == 20 then
		self:GOAPPerform()
		self:GOAPShowChoosenNpc()
	end
	--NPC3偷钱仔：一开始在偷钱，被玩家靠近后逃跑
	if self.npc3ActState == 1 and BehaviorFunctions.GetDistanceFromTarget(self.npc3,self.role)< 3 then
		GOAPPerform.Instance:AddEvent("Planner Close To Object,ObjectInstanceId:".."29")
		BehaviorFunctions.DoLookAtTargetImmediately(self.npc3,self.role)
		BehaviorFunctions.PlayAnimation(self.npc3,"Afraid")
		BehaviorFunctions.ChangeNpcBubbleContent(self.npc3,"你干嘛？",2)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.npc3,true)
		--切换小偷、愤怒信息
		self.Action[3] = self.npc3Action2
		self.Cost[3] = self.npc3Cost2
		self.Goal[3] = self.npc3Goal2
		self.ActionSelect[3] = self.npc3ActionSelect2
		
		--显示选中NPC的属性
		GOAPPerform.Instance:SetStaticAttr(self.GOAPAttr[self.ChoosenPlanner])
		--显示选中NPC的行为、Cost
		GOAPPerform.Instance:InitActions(self.Action[self.ChoosenPlanner],self.Cost[self.ChoosenPlanner])
		--显示选中NPC的目标、行为路径
		GOAPPerform.Instance:SetSelectActions(self.Goal[self.ChoosenPlanner],self.ActionSelect[self.ChoosenPlanner])
		--选中广播
		GOAPPerform.Instance:AddEvent("Planner Choosen InstanceId:"..self.npcInstanceList[self.ChoosenPlanner])
		
		self.Action[5] = self.npc5Action2
		self.Cost[5] = self.npc5Cost2
		self.ActionSelect[5] = self.npc5ActionSelect2
		self.Goal[5] = self.npc5Goal2
		self.GOAPPlannerChoosen = false
		self.npc3runStartTime = self.time
		self.npc3ActState = 2
	end
	if self.npc3ActState == 2  and self.time - self.npc3runStartTime > 60 then
		local npcRunPos = BehaviorFunctions.GetTerrainPositionP("npc1run",self.levelId)
		BehaviorFunctions.SetPathFollowPos(self.npc3,npcRunPos)
		BehaviorFunctions.DoSetEntityState(self.npc3,FightEnum.EntityState.Move)
		BehaviorFunctions.DoSetMoveType(self.npc3,FightEnum.EntityMoveSubState.Run)
		BehaviorFunctions.ChangeNpcBubbleContent(self.npc3,"溜了溜了",3)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.npc3,true)
		self.npc3ActState = 3 
		self.npc5ActState = 1
	end
	--NPC4店老板：劫匪死了开心的蹦蹦跳跳
	if self.npc4ActState == 1 then
		self.npc4ActState = 2
	end
	if self.npc4ActState == 2 and self.time - self.npc4ActStartTime > 30 then
		BehaviorFunctions.DoLookAtPositionImmediately(self.npc4,self.npc2deathPos.x,self.npc2deathPos.y,self.npc2deathPos.z)
		BehaviorFunctions.PlayAnimation(self.npc4,"CheerL_loop")
		BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.npc4,"我还没出力他就倒下了",3)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.npc4,true)
		self.npc4ActStartTime = self.time
		self.npc4ActState = 3
	end
	if self.npc4ActState == 3 and self.time - self.npc4ActStartTime > 90 then
		BehaviorFunctions.DoLookAtTargetImmediately(self.npc4,self.role)
		BehaviorFunctions.PlayAnimation(self.npc4,"CheerR_loop")
		BehaviorFunctions.ChangeNpcBubbleContent(self.npc4,"谢谢你，收下奖励吧！",3)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.npc4,true)
		local award = BehaviorFunctions.GetEcoEntityByEcoId(3002101040003)
		BehaviorFunctions.InteractEntityHit(award)
		self.npc4ActState = 4
	end
	--NPC5愤怒：去追偷钱仔
	if self.npc5ActState == 1 then
		BehaviorFunctions.SetPathFollowEntity(self.npc5,self.npc3)
		BehaviorFunctions.DoSetEntityState(self.npc5,FightEnum.EntityState.Move)
		BehaviorFunctions.DoSetMoveType(self.npc5,FightEnum.EntityMoveSubState.Run)
		BehaviorFunctions.ChangeNpcBubbleContent(self.npc5,"别跑！站住！",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.npc5,true)
		self.npc5ActState = 2
	end
end


function LevelBehavior4004:__delete()

end


function LevelBehavior4004:EntryPhotoFrame(entityInstanceId)
	if self.actState == 0 and entityInstanceId == self.npc then
		self.actStartFrame = self.time
		self.actState = 1
	end
end

function LevelBehavior4004:CreateActor(entityId,bornPos)
	local instanceId = BehaviorFunctions.CreateEntityByPosition(entityId,nil,bornPos,nil,self.levelId,self.levelId)
	BehaviorFunctions.fight.clientFight.headInfoManager:CreateHeadInfoObj(instanceId)
	return instanceId
end
function LevelBehavior4004:Die(attackInstanceId,instanceId)
	if instanceId == self.npc2 then
		self.npc2deathPos = BehaviorFunctions.GetPositionP(instanceId)
	end
	
end
function LevelBehavior4004:Death(InstanceId)
	if InstanceId == self.npc2 and self.npc4ActState == 0 then
		--节肥死了
		GOAPPerform.Instance:AddEvent("Remove Planner,InstanceId:"..self.npc2)		
		--切换老板信息
		self.Cost[4] = self.npc4Cost3
		self.Goal[4] = self.npc4Goal3
		self.ActionSelect[4] = self.npc4ActionSelect3
		--切换愤怒信息
		self.Cost[5] = self.npc5Cost3
		self.Goal[5] = self.npc5Goal3
		self.ActionSelect[5] = self.npc5ActionSelect3
		BehaviorFunctions.PlayAnimation(self.npc5,"Clap_loop")
		BehaviorFunctions.ChangeNpcBubbleContent(self.npc5,"你实在是太强了",10)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.npc5,true)
		
		BehaviorFunctions.SetEntityBineVisible(self.npc4,"Weapon",false)
		BehaviorFunctions.SetEntityValue(self.npc4,"StartFight",false)
		BehaviorFunctions.StopMove(self.npc4)
		BehaviorFunctions.BreakSkill(self.npc4)
		BehaviorFunctions.SetAnimationTranslate(self.npc4,"Stand1","Stand1")
		local pos = BehaviorFunctions.GetTerrainPositionP("npc3",self.levelId)
		BehaviorFunctions.DoSetPositionP(self.npc3,pos)
		self.npc4ActState = 1
		self.GOAPPlannerChoosen = false
		--显示选中NPC的属性
		GOAPPerform.Instance:SetStaticAttr(self.GOAPAttr[self.ChoosenPlanner])
		--显示选中NPC的行为、Cost
		GOAPPerform.Instance:InitActions(self.Action[self.ChoosenPlanner],self.Cost[self.ChoosenPlanner])
		--显示选中NPC的目标、行为路径
		GOAPPerform.Instance:SetSelectActions(self.Goal[self.ChoosenPlanner],self.ActionSelect[self.ChoosenPlanner])
		--选中广播
		GOAPPerform.Instance:AddEvent("Planner Choosen InstanceId:"..self.npcInstanceList[self.ChoosenPlanner])

	end
end

function LevelBehavior4004:Hacking(instanceId)
	if instanceId == self.monitor3 then
		GOAPPerform.Instance:AddEvent("Player Is Hacking Outdoor Monitor InstanceId:"..instanceId)
		Fight.Instance.hackManager.coverTest= false
	elseif instanceId == self.monitor2 then
		GOAPPerform.Instance:AddEvent("Player Is Hacking Monitor InstanceId:"..instanceId)
	end
	for i = 1, 5 do
		if instanceId == self.npcInstanceList[i] then
			GOAPPerform.Instance:AddEvent("Player Is Hacking Planner InstanceId:"..instanceId)
			if i == 3 then
				Fight.Instance.hackManager.coverTest= true
			end
		end
	end
	if (instanceId == self.npc4 or instanceId == self.npc2) and self.alertState == 0 then
		BehaviorFunctions.ShowCommonTitle(7,"发现城市威胁",true)
		self.alertState = 1
	end
end

function LevelBehavior4004:ExitHacking()
	GOAPPerform.Instance:AddEvent("Hacking End")
end

function LevelBehavior4004:GOAPPerform()
	--选中10m范围内最近的NPC
	local npc1Distance = BehaviorFunctions.GetDistanceFromTarget(self.role,self.npc1)
	local npc2Distance = 999
	if BehaviorFunctions.CheckEntity(self.npc2) then
		npc2Distance = BehaviorFunctions.GetDistanceFromTarget(self.role,self.npc2)
	end
	local npc3Distance = BehaviorFunctions.GetDistanceFromTarget(self.role,self.npc3)
	local npc4Distance = BehaviorFunctions.GetDistanceFromTarget(self.role,self.npc4)
	local npc5Distance = BehaviorFunctions.GetDistanceFromTarget(self.role,self.npc5)
	local minDistance = math.min(npc1Distance,npc2Distance,npc3Distance,npc4Distance,npc5Distance)
	if minDistance <10 then
		self.GOAPPlannerChoosen = true
		if minDistance == npc1Distance then
			self.ChoosenPlanner = 1
		elseif minDistance == npc2Distance then
			self.ChoosenPlanner = 2
		elseif minDistance == npc3Distance then
			self.ChoosenPlanner = 3
		elseif minDistance == npc4Distance then
			self.ChoosenPlanner = 4
		elseif minDistance == npc5Distance then
			self.ChoosenPlanner = 5
		end
	else
		self.GOAPPlannerChoosen = false
		self.ChoosenPlanner = 0 
		--清空属性、目标、行为列表
		GOAPPerform.Instance:SetStaticAttr({0,0,0,0,0,0,0,0,0,0})
		GOAPPerform.Instance:InitActions({},{})
		GOAPPerform.Instance:SetSelectActions("",{})
	end
end

function LevelBehavior4004:GOAPShowChoosenNpc()
	--选中NPC
	if self.GOAPPlannerChoosen then
		if self.ShowChoosenPlannerNum ~= self.ChoosenPlanner then
			self.ChoosenPlannerIsShow = false
		end
		if self.ChoosenPlannerIsShow == false then
			--显示选中NPC的属性
			GOAPPerform.Instance:SetStaticAttr(self.GOAPAttr[self.ChoosenPlanner])
			--显示选中NPC的行为、Cost
			GOAPPerform.Instance:InitActions(self.Action[self.ChoosenPlanner],self.Cost[self.ChoosenPlanner])
			--显示选中NPC的目标、行为路径
			GOAPPerform.Instance:SetSelectActions(self.Goal[self.ChoosenPlanner],self.ActionSelect[self.ChoosenPlanner])
			--选中广播
			GOAPPerform.Instance:AddEvent("Planner Choosen InstanceId:"..self.npcInstanceList[self.ChoosenPlanner])
			for i = 1,5 do
				if BehaviorFunctions.CheckEntity(self.npcInstanceList[i]) then
					if i == self.ChoosenPlanner then
						if not BehaviorFunctions.CheckNPCSelectUI(self.npcInstanceList[i]) then
							BehaviorFunctions.ShowNPCSelectUI(self.npcInstanceList[i],true)
						end
					else
						if BehaviorFunctions.CheckNPCSelectUI(self.npcInstanceList[i]) then
							BehaviorFunctions.ShowNPCSelectUI(self.npcInstanceList[i],false)
						end
					end
				end
			end
			self.ChoosenPlannerIsShow = true
			self.ShowChoosenPlannerNum = self.ChoosenPlanner
		end
	--无选中NPC	
	else
		if self.ChoosenPlannerIsShow == true then
			for i = 1,5 do
				if BehaviorFunctions.CheckEntity(self.npcInstanceList[i]) and BehaviorFunctions.CheckNPCSelectUI(self.npcInstanceList[i]) then
					BehaviorFunctions.ShowNPCSelectUI(self.npcInstanceList[i],false)
				end
			end
			GOAPPerform.Instance:AddEvent("Cancel Planner Choosen")
			self.ChoosenPlannerIsShow = false
		end
	end
end

function LevelBehavior4004:EnterArea(triggerInstanceId, areaName, logicName)
	if triggerInstanceId == self.role and areaName == "inroom" then
		if not self.roomin then
			GOAPPerform.Instance:AddEvent("Player Enter Room,roomId:".."32")
			self.roomin = true
		end
	elseif triggerInstanceId == self.role and areaName == "demostart" then
		if self.missionState == 1 then
			self.missionState = 10
		end
	end
end

function LevelBehavior4004:Hit(attackInstanceId,hitInstanceId,hitType)
	if attackInstanceId == self.role and hitInstanceId == self.npc2 then
		if self.GOAPChange1 == false then
			--
			GOAPPerform.Instance:AddEvent("Planner is Attacked by Role,InstanceId:"..self.npc2)
			--切换劫匪信息
			self.Action[2] = self.npc2Action2
			self.Cost[2] = self.npc2Cost2
			self.Goal[2] = self.npc2Goal2
			self.ActionSelect[2] = self.npc2ActionSelect2
			--切换老板信息
			self.Action[4] = self.npc4Action2
			self.Cost[4] = self.npc4Cost2
			self.Goal[4] = self.npc4Goal2
			self.ActionSelect[4] = self.npc4ActionSelect2
			self.GOAPPlannerChoosen = false
			self.GOAPChange1 = true
			
			--显示选中NPC的属性
			GOAPPerform.Instance:SetStaticAttr(self.GOAPAttr[self.ChoosenPlanner])
			--显示选中NPC的行为、Cost
			GOAPPerform.Instance:InitActions(self.Action[self.ChoosenPlanner],self.Cost[self.ChoosenPlanner])
			--显示选中NPC的目标、行为路径
			GOAPPerform.Instance:SetSelectActions(self.Goal[self.ChoosenPlanner],self.ActionSelect[self.ChoosenPlanner])
			--选中广播
			GOAPPerform.Instance:AddEvent("Planner Choosen InstanceId:"..self.npcInstanceList[self.ChoosenPlanner])
			
			--老板拾取武器站起来进入战斗
			BehaviorFunctions.SetAnimationTranslate(self.npc4,"Stand1","Stand2")
			BehaviorFunctions.SetAnimationTranslate(self.npc2,"Stand1","Fire_Shoot_loop")
			--BehaviorFunctions.CastSkillBySelfPosition(self.npc4,80001004)
			BehaviorFunctions.SetEntityValue(self.npc4,"battleTarget",self.npc2)
			BehaviorFunctions.SetEntityBineVisible(self.npc4,"Weapon",true)
			--开始战斗
			BehaviorFunctions.AddDelayCallByFrame(10,BehaviorFunctions,BehaviorFunctions.SetEntityValue,self.npc4,"StartFight",true)
			GOAPPerform.Instance:AddEvent("Planner Take Melee,MeleeType:1,PlannerInstanceId:"..self.npc4)
			GOAPPerform.Instance:AddEvent("Melee is Token,MeleeInstanceId:"..self.gangguan)
			BehaviorFunctions.RemoveEntity(self.gangguan)		
			--隐藏气泡
			BehaviorFunctions.SetNonNpcBubbleVisible(self.npc2,false)
			BehaviorFunctions.SetNonNpcBubbleVisible(self.npc4,false)
			BehaviorFunctions.SetNonNpcBubbleVisible(self.npc5,false)
			
		end
	end
end