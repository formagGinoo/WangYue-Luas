LevelBehavior4005 = BaseClass("LevelBehavior4005",LevelBehaviorBase)
--NPC白模交互演示demo
--BehaviorFunctions.AddLevel(4005)
function LevelBehavior4005:__init(fight)
	self.fight = fight
end

function LevelBehavior4005.GetGenerates()
	local generates = {808011003,8010004,8011001,8010007,8011010,8010003,8011010,8010005,8011012,8011012,8010006,8010992,900070}
	return generates
end


function LevelBehavior4005:Init()
	self.missionState = 0
	self.pos = 0
	self.pos2 = 0
	self.actState = 0
	self.actStartFrame = nil
	self.actdelayFrame = 80
	self.npcActState = 0
	self.npcPos = nil
	self.npcdemoAct = false
	self.creatFrame = 0
end

function LevelBehavior4005:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	--self.pos = BehaviorFunctions.GetTerrainPositionP("role",self.levelId)
	self.pos = BehaviorFunctions.GetTerrainPositionP("r1",self.levelId)
	
	if self.missionState == 0 then
		BehaviorFunctions.Transport(10020004,self.pos.x,self.pos.y,self.pos.z)
		--self.npc = self:CreateActor(8010007,"npc1")
		--BehaviorFunctions.DoMagic(1,self.npc,900000027)
		--self.monster = self:CreateActor(910040,"monster1")
		self.npc = self:CreateActor(8010992,"n1")
		self.monster = self:CreateActor(900070,"m1")
		self.creatFrame = self.time
		BehaviorFunctions.SetEntityBineVisible(self.npc,"Weapon",true)
		BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.SetEntityValue,self.npc,"battleTarget",self.monster)
		BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.SetEntityValue,self.npc,"StartFight",true)
		self.missionState = 1
	end
	--if self.missionState == 1 and self.time - self.creatFrame >100 then
		--local npcTarget = BehaviorFunctions.GetTerrainPositionP("npc1r",self.levelId)
		--BehaviorFunctions.SetPathFollowPos(self.npc,npcTarget)
		--local a = BehaviorFunctions.SetPathFollowPos(self.npc,npcTarget)
		--BehaviorFunctions.ChangeNpcBubbleContent(self.npc,"有怪物，快跑！",10)
		--BehaviorFunctions.SetNonNpcBubbleVisible(self.npc,true)
		--BehaviorFunctions.DoSetEntityState(self.npc,FightEnum.EntityState.Move)
		--BehaviorFunctions.DoSetMoveType(self.npc,FightEnum.EntityMoveSubState.Run)
		--self.missionState = 2
	--end
	--if self.npcActState == 1 then
		--self.npcPos = BehaviorFunctions.GetPositionOffsetBySelf(self.role,3,0)
		--BehaviorFunctions.SetPathFollowPos(self.npc,self.npcPos)
		--BehaviorFunctions.DoSetEntityState(self.npc,FightEnum.EntityState.Move)
		--BehaviorFunctions.DoSetMoveType(self.npc,FightEnum.EntityMoveSubState.Run)
		--self.npcActState = 2
	--elseif self.npcActState == 10 then
		--BehaviorFunctions.StopMove(self.npc)
		--BehaviorFunctions.SetEntityBineVisible(self.npc,"Phone",false)
		--BehaviorFunctions.AddDelayCallByFrame(10,BehaviorFunctions,BehaviorFunctions.PlayAnimation,self.npc,"SitGround_in")
		----BehaviorFunctions.PlayAnimation(self.npc,"SitGround_in")
		--BehaviorFunctions.ChangeNpcBubbleContent(self.npc,"哎呦好痛啊，被误伤了",3)
		--BehaviorFunctions.SetNonNpcBubbleVisible(self.npc,true)
		--self.actStartFrame = self.time
		--self.npcActState = 11
	--elseif self.npcActState == 11 and self.time - self.actStartFrame > 144 then
		--BehaviorFunctions.StartStoryDialog(601012901)
		----怼脸特写
		----设置关卡相机
		----self.lookupCamera = BehaviorFunctions.CreateEntity(22006)
		----BehaviorFunctions.CameraEntityFollowTarget(self.lookupCamera,self.role,"CloseUpFollow")
		----BehaviorFunctions.CameraEntityLockTarget(self.lookupCamera,self.role,"CloseUpLookat")
		----BehaviorFunctions.PlayAnimation(self.role,"Tuoshou_loop",FightEnum.AnimationLayer.PerformLayer)
		----BehaviorFunctions.PlayAnimation(self.role,"Serious_loop",FightEnum.AnimationLayer.FaceLayer)
		--self.npcActState = 20
	--elseif self.npcActState == 30 then
		--local runPos = BehaviorFunctions.GetTerrainPositionP("npc1r",self.levelId)
		--BehaviorFunctions.SetPathFollowPos(self.npc,runPos)
		--BehaviorFunctions.ChangeNpcBubbleContent(self.npc,"溜了溜了",3)
		--BehaviorFunctions.SetNonNpcBubbleVisible(self.npc,true)
		--BehaviorFunctions.DoSetEntityState(self.npc,FightEnum.EntityState.Move)
		--BehaviorFunctions.DoSetMoveType(self.npc,FightEnum.EntityMoveSubState.Run)
		--self.npcActState = 999
	--end
end

--死亡事件
function LevelBehavior4005:Death(dieInstanceId)
	if dieInstanceId == self.monster then
		self.npcActState = 1
	end
end

function LevelBehavior4005:StoryEndEvent(dialogId)
	if dialogId ==  601012901 then
		self.npcActState = 30
		--BehaviorFunctions.RemoveEntity(self.lookupCamera)
	end
	
end
function LevelBehavior4005:CreateActor(entityId,bornPos)
	local instanceId = BehaviorFunctions.CreateEntityByPosition(entityId,nil,bornPos,nil,self.levelId,self.levelId,1)
	BehaviorFunctions.fight.clientFight.headInfoManager:CreateHeadInfoObj(instanceId)
	return instanceId
end
function LevelBehavior4005:__delete()

end

--寻路结束
function LevelBehavior4005:PathFindingEnd(instanceId,result)
	if instanceId == self.npc and result == true then
		if self.npcdemoAct == false then
			BehaviorFunctions.StopMove(self.npc)
			local pos = BehaviorFunctions.GetTerrainPositionP("npc1",self.levelId)
			local pos2 = BehaviorFunctions.GetTerrainPositionP("monster1",self.levelId)
			BehaviorFunctions.AddDelayCallByFrame(100,BehaviorFunctions,BehaviorFunctions.DoSetPositionP,self.npc,pos)
			BehaviorFunctions.DoLookAtPositionImmediately(self.npc,pos2.x,pos2.y,pos2.z)
			BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.PlayAnimation,self.npc,"TakePhoto_loop")
			BehaviorFunctions.SetEntityBineVisible(self.npc,"Phone",true)
			--BehaviorFunctions.DoSetPositionP(self.npc,pos)
			self.npcdemoAct = true
		else
			self.npcActState = 10
		end
	end
end

function LevelBehavior4005:Hit(attackInstanceId,hitInstanceId,hitType)
	if attackInstanceId == self.npc and hitInstanceId == self.monster then
		BehaviorFunctions.SetEntityValue(self.monster,"battleTarget",self.npc)
	end
end