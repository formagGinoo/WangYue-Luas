LevelBehavior4003 = BaseClass("LevelBehavior4003",LevelBehaviorBase)
--NPC白模交互演示demo
function LevelBehavior4003:__init(fight)
	self.fight = fight
end
--[[
GOAPPerform.ActivityAttrOnly(true)
--瞄准
--害怕
GOAPPerform.Instance:SetStaticAttr({50,50,10,10,50,30,80,100,50,30})
--拍照看枪口
GOAPPerform.Instance:SetStaticAttr({50,60,100,10,100,100,30,100,50,60})
--推搡
GOAPPerform.Instance:SetStaticAttr({50,70,50,50,60,50,80,30,50,60})
--掏枪射击
GOAPPerform.Instance:SetStaticAttr({50,80,100,100,80,50,10,10,50,100})
--拍照
--蹦蹦跳跳
GOAPPerform.Instance:SetStaticAttr({10,80,80,10,100,100,100,100,50,100})
--合照
GOAPPerform.Instance:SetStaticAttr({80,80,60,10,80,100,100,100,50,100})
--指指点点
GOAPPerform.Instance:SetStaticAttr({80,80,50,60,50,40,100,100,50,60})
--钢管
GOAPPerform.Instance:SetStaticAttr({20,80,100,100,30,10,10,10,50,60})

]]

function LevelBehavior4003.GetGenerates()
	local generates = {808011003,8010004,8011001,8010007,8011010,8010003,8011010,8010005,8011012,8011012,8010006,8010992}
	return generates
end


function LevelBehavior4003:Init()
	self.missionState = 0
	self.pos = 0
	self.pos2 = 0
	self.actState = 0
	self.actStartFrame = nil
	self.actdelayFrame = 80
end

function LevelBehavior4003:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.pos = BehaviorFunctions.GetTerrainPositionP("role",self.levelId)
	
	if self.missionState == 0 then
		BehaviorFunctions.DoSetPositionP(self.role,self.pos)
		self.npc = self:CreateActor(8010992,"npc2","npc2l")
		BehaviorFunctions.SetEntityBineVisible(self.npc,"Phone",true)
		BehaviorFunctions.PlayAnimation(self.npc,"TextStand_loop")
		self.missionState = 1
	end
	if self.actState == 1 and self.time - self.actStartFrame > self.actdelayFrame  then
		--NPC1:蹦蹦跳跳
		BehaviorFunctions.PlayAnimation(self.npc,"CheerL_in")
		BehaviorFunctions.AddDelayCallByFrame(19,BehaviorFunctions,BehaviorFunctions.PlayAnimation,self.npc,"CheerL_loop")
		self.actState = 999
	end
	if self.actState == 2 and self.time - self.actStartFrame > self.actdelayFrame  then
		--NPC2:自拍合照
		BehaviorFunctions.SetEntityBineVisible(self.npc,"Phone02",true)
		BehaviorFunctions.PlayAnimation(self.npc,"PhotoSelf_in")
		self.actState = 999
	end
	if self.actState == 3 and self.time - self.actStartFrame > self.actdelayFrame  then
		--NPC3:指指点点
		BehaviorFunctions.DoLookAtTargetByLerp(self.npc,self.role,nil,180,180)
		BehaviorFunctions.SetEntityBineVisible(self.npc,"Phone",false)
		BehaviorFunctions.PlayAnimation(self.npc,"Point")
		self.actState = 999
	end
	if self.actState == 4 and self.time - self.actStartFrame > self.actdelayFrame  then
		--NPC4:钢管攻击
		BehaviorFunctions.SetEntityBineVisible(self.npc,"Phone",false)
		BehaviorFunctions.SetEntityBineVisible(self.npc,"wuqi",true)
		BehaviorFunctions.PlayAnimation(self.npc,"InStand2")
		BehaviorFunctions.DoLookAtTargetByLerp(self.npc,self.role,nil,180,180)
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.CastSkillByTarget,self.npc,80002001,self.role)
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.SetAnimationTranslate,self.npc,"Stand1","Stand2")
		self.actState = 999
	end
end

--死亡事件

function LevelBehavior4003:CreateActor(entityId,bornPos,lookPos)
	local actorBornPos = BehaviorFunctions.GetTerrainPositionP(bornPos,self.levelId)
	local actorLookPos = BehaviorFunctions.GetTerrainPositionP(lookPos,self.levelId)
	local instanceId = BehaviorFunctions.CreateEntity(entityId,nil,actorBornPos.x,actorBornPos.y,actorBornPos.z,actorLookPos.x,actorLookPos.y,actorLookPos.z,self.levelId)
	BehaviorFunctions.DoMagic(1,instanceId,900000027)
	return instanceId
end

function LevelBehavior4003:__delete()

end


function LevelBehavior4003:EntryPhotoFrame(entityInstanceId)
	if self.actState == 0 and entityInstanceId == self.npc then
		self.actStartFrame = self.time
		self.actState = 4
	end
end
