LevelBehavior4002 = BaseClass("LevelBehavior4002",LevelBehaviorBase)
--NPC九宫格演示demo
function LevelBehavior4002:__init(fight)
	self.fight = fight
end


function LevelBehavior4002.GetGenerates()
	local generates = {808011003,8011001,8010007,8011010,8010003,8011010,8010005,8011012,8011012,8010006}
	return generates
end


function LevelBehavior4002:Init()
	self.missionState = 0
	self.monster1 = 0
	self.monster2 = 0
	self.monster3 = 0 
	self.pos = 0
	self.pos2 = 0
	self.createId = 900040
	self.createId2 = 2020902
end

function LevelBehavior4002:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.pos = BehaviorFunctions.GetTerrainPositionP("role",self.levelId)
	
	if self.missionState == 0 then
		BehaviorFunctions.DoSetPositionP(self.role,self.pos)
		BehaviorFunctions.SetEntityShowState(self.role,false)	
		self.sleepNPC = self:CreateActor(8011001,"sleep","sleepL")				
		self.qiuraoNPC = self:CreateActor(8011001,"qiurao","qiuraoL")
		self.runNPC = self:CreateActor(8011001,"run","run1")	
		self.duanlianNPC = self:CreateActor(8011001,"duanlian","duanlianL")
		self.attackNPC1 = self:CreateActor(808011003,"attack","attackL")
		self.attackNPC2 = self:CreateActor(808011003,"attackL","attack")	
		self.huanyingNPC = self:CreateActor(8011001,"huanying","huanyingL")
		self.happyNPC = self:CreateActor(8010003,"happy","happyL")
		self.angryNPC = self:CreateActor(8011001,"angry","angryL")		
		self.battleNPC1 = self:CreateActor(8011001,"battle","battleL")
		self.photoNPC1 = self:CreateActor(8011001,"photo","photoL")
		self.battleNPC2 = self:CreateActor(8011001,"battleL","battle")
		self.afraidNPC = self:CreateActor(8011001,"afraid","afraidL")
		self.photoNPC2 = self:CreateActor(8011001,"photoL","photo")
		self.timeStart = self.time
		self.missionState = 1
	end
	if self.missionState == 1 and self.time - self.timeStart > 5  then
		BehaviorFunctions.PlayAnimation(self.battleNPC1,"Point")
		BehaviorFunctions.PlayAnimation(self.angryNPC,"Point")
		BehaviorFunctions.PlayAnimation(self.happyNPC,"Jump")
		BehaviorFunctions.PlayAnimation(self.huanyingNPC,"Bow_loop")
		BehaviorFunctions.PlayAnimation(self.duanlianNPC,"Exercise3")
		BehaviorFunctions.PlayAnimation(self.sleepNPC,"Sleep_loop")
		BehaviorFunctions.PlayAnimation(self.qiuraoNPC,"Squat_loop")
		BehaviorFunctions.PlayAnimation(self.runNPC,"Run")
		BehaviorFunctions.SetEntityValue(self.attackNPC1,"battleTarget",self.attackNPC2)
		BehaviorFunctions.SetEntityValue(self.attackNPC2,"battleTarget",self.attackNPC1)
		BehaviorFunctions.SetEntityValue(self.attackNPC1,"StartFight",true)
		BehaviorFunctions.SetEntityValue(self.attackNPC2,"StartFight",true)
		BehaviorFunctions.ChangeCamp(self.attackNPC1,3)
		BehaviorFunctions.ChangeCamp(self.attackNPC2,4)
		BehaviorFunctions.SetEntityBineVisible(self.photoNPC1,"Phone",true)
		BehaviorFunctions.PlayAnimation(self.photoNPC1,"PhotoSelf_loop")
		BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.PlayAnimation,self.battleNPC2,"Point")
		BehaviorFunctions.PlayAnimation(self.afraidNPC,"Afraid_loop")
		BehaviorFunctions.AddDelayCallByTime(10,BehaviorFunctions,BehaviorFunctions.PlayAnimation,self.photoNPC2,"Dance")
		--BehaviorFunctions.PlayAnimation(self.photoNPC2,"Dance")
		--气泡对话
		BehaviorFunctions.ChangeNpcBubbleContent(self.photoNPC1,"跳的不错",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.photoNPC1,true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.qiuraoNPC,"对不起，对不起！",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.qiuraoNPC,true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.runNPC,"快跑啊！",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.runNPC,true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.duanlianNPC,"1,2,3,4!",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.duanlianNPC,true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.huanyingNPC,"欢迎光临!",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.huanyingNPC,true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.battleNPC1,"你这个是什么意思？",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.battleNPC1,true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.battleNPC2,"没时间了",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.battleNPC2,true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.afraidNPC,"不要啊~",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.afraidNPC,true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.happyNPC,"嘿嘿嘿，嘿嘿嘿",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.happyNPC,true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.angryNPC,"有你好果子吃！",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.angryNPC,true)
		self.missionState = 2
	end
end

--死亡事件

function LevelBehavior4002:CreateActor(entityId,bornPos,lookPos)
	local actorBornPos = BehaviorFunctions.GetTerrainPositionP(bornPos,self.levelId)
	local actorLookPos = BehaviorFunctions.GetTerrainPositionP(lookPos,self.levelId)
	local instanceId = BehaviorFunctions.CreateEntity(entityId,nil,actorBornPos.x,actorBornPos.y,actorBornPos.z,actorLookPos.x,actorLookPos.y,actorLookPos.z,self.levelId)
	if entityId ~= 808011003 then
		BehaviorFunctions.DoMagic(1,instanceId,900000027)
	end
	BehaviorFunctions.fight.clientFight.headInfoManager:CreateHeadInfoObj(instanceId)
	return instanceId
end

function LevelBehavior4002:ActorRun(entityId,bornPos,lookPos)
	local actorBornPos = BehaviorFunctions.GetTerrainPositionP(bornPos,self.levelId)
	local actorLookPos = BehaviorFunctions.GetTerrainPositionP(lookPos,self.levelId)
	local instanceId = BehaviorFunctions.CreateEntity(entityId,nil,actorBornPos.x,actorBornPos.y,actorBornPos.z,actorLookPos.x,actorLookPos.y,actorLookPos.z,self.levelId)
	BehaviorFunctions.DoMagic(1,instanceId,900000027)
	return instanceId
end

function LevelBehavior4002:__delete()

end