Behavior2050403 = BaseClass("Behavior2050403",EntityBehaviorBase) 
--咖啡馆管理器
function Behavior2050403.GetGenerates()
	local generates = {8010007,8011010,8010991,8010003,8011010,8010005,8011012,8011012,8010006}
	return generates
end

function Behavior2050403:Init()
	self.me = self.instanceId
	self.outsideTip = false
	self.outsideDialogId = 601019401
	self.createState = 0
	self.inRoom = false
	self.wxTip = false
	self.bossWalk =false
	self.walkState =0
	self.waitressState = 0
	self.waitressPathFinding = false
	self.canFollow = false
	self.isFollow = false
	self.hasFollow = false
	self.waitressTalkState = 0
	self.robberCount = 3
	self.fireCd = 3
	self.fireFrame = 0
	self.inFireCd = false
	self.inCloseUp = false --特写镜头
	self.steelCount = 0 --拿东西计数
	self.startRun = false
	self.inRun = false
	self.xumuSit = false
	self.afriadStartFrame = 0
	self.robber01Cd = false
	self.robber02Cd = false
	self.robber03Cd = false	
end

function Behavior2050403:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.frame = BehaviorFunctions.GetFightFrame()
	self:Fire()
	if self.xumuSit == false then
		--local pos = BehaviorFunctions.GetTerrainPositionP("XumuSit",10020004,"PV11")
		--local lookPos = BehaviorFunctions.GetTerrainPositionP("XumuSitP",10020004,"PV11")
		--BehaviorFunctions.DoMagic(1,self.role,900000027)
		--BehaviorFunctions.DoSetPosition(self.role,pos.x,pos.y,pos.z)
		--BehaviorFunctions.DoLookAtPositionImmediately(self.role,lookPos.x,lookPos.y,lookPos.z)
		--BehaviorFunctions.PlayAnimation(self.role,"Sit_loop",FightEnum.AnimationLayer.PerformLayer)
		--BehaviorFunctions.PlayAnimation(2,"SitR_end",FightEnum.AnimationLayer.PerformLayer)
		self.xumuSit = true
	end
	if self.createState == 0 then
		--招待员
		self.waitress = self:CreateActor(8011010,"Waitress","WaitressLP")
		--店老板
		self.boss = self:CreateActor(8010007,"Boss","WaitressP1")
		--坐着的NPC
		self.sit1 = self:CreateActor(8010003,"SitNpc01","SitNpc02")
		self.sit2 = self:CreateActor(8011010,"SitNpc02","SitNpc01")
		self.sit3 = self:CreateActor(8010005,"SitNpc03","SitNpc04")
		self.sit4 = self:CreateActor(8011010,"SitNpc04","SitNpc03")
		--欢迎
		self.please1 = self:CreateActor(8011012,"Please1","Please2")
		self.please2 = self:CreateActor(8010006,"Please2","Please1")
		
		BehaviorFunctions.DoMagic(1,self.sit1,900000027)
		BehaviorFunctions.DoMagic(1,self.sit2,900000027)
		BehaviorFunctions.DoMagic(1,self.sit3,900000027)
		BehaviorFunctions.DoMagic(1,self.sit4,900000027)		
		BehaviorFunctions.PlayAnimation(self.waitress,"Yell")
		BehaviorFunctions.PlayAnimation(self.boss,"Clap_in",FightEnum.AnimationLayer.PerformLayer)
		BehaviorFunctions.PlayAnimation(self.sit1,"SitTalk")
		BehaviorFunctions.PlayAnimation(self.sit2,"SitTalk")
		BehaviorFunctions.PlayAnimation(self.sit3,"SitTalk")
		BehaviorFunctions.PlayAnimation(self.sit4,"SitTalk")
		self.createState = 1
	end
	--害怕
	if self.createState == 2 and self.frame - self.afriadStartFrame > 30 then
		BehaviorFunctions.RemoveEntity(self.please1)
		BehaviorFunctions.RemoveEntity(self.please2)
		self.robber01 = self:CreateActor(8010991,"Robber01","WaitressP1")
		self.robber02 = self:CreateActor(8010991,"Robber02","WaitressP1")
		self.robber03 = self:CreateActor(8010991,"Robber03","WaitressP1")
		BehaviorFunctions.PlayAnimation(self.waitress,"Afraid_loop")
		BehaviorFunctions.PlayAnimation(self.boss,"Afraid")
		--BehaviorFunctions.PlayAnimation(self.sit1,"Afraid")
		--BehaviorFunctions.PlayAnimation(self.sit2,"Afraid")
		--BehaviorFunctions.PlayAnimation(self.sit3,"Afraid")
		--BehaviorFunctions.PlayAnimation(self.sit4,"Afraid")
		--BehaviorFunctions.DoLookAtTargetImmediately(self.waitress,self.robber01)
		--BehaviorFunctions.DoLookAtTargetImmediately(self.sit1,self.robber01)
		--BehaviorFunctions.DoLookAtTargetImmediately(self.sit2,self.robber01)
		--BehaviorFunctions.DoLookAtTargetImmediately(self.sit3,self.robber01)
		--BehaviorFunctions.DoLookAtTargetImmediately(self.sit4,self.robber01)
		self:AlterStand1(self.robber01)
		self:AlterStand1(self.robber02)
		self:AlterStand1(self.robber03)
		self.robStartFrame = self.frame
		self.createState = 3
	end
	if self.createState == 3 and self.frame - self.robStartFrame > 30 then
		BehaviorFunctions.StartStoryDialog(601010801)
		--设置关卡相机
		local fp1 = BehaviorFunctions.GetPositionP(self.robber02)
		self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
		self.levelCam = BehaviorFunctions.CreateEntity(22002)
		BehaviorFunctions.ShowCommonTitle(7,"发现城市威胁",true)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
		--看向目标
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
		self.createState = 4
	end
	if self.waitress and self.waitressTalkState == 0 and BehaviorFunctions.GetDistanceFromTarget(self.role,self.waitress) < 10 then
		BehaviorFunctions.StartStoryDialog(601019801)
		self.waitressTalkState = 1
	end
	if self.waitress and self.waitressState == 0 then		
		if BehaviorFunctions.GetDistanceFromTarget(self.role,self.waitress) < 3 
			and not self.hasFollow then
			self.canFollow = true
		end
	end
	if self.isFollow then
		if self.waitressTalkState == 1 then
			BehaviorFunctions.StartStoryDialog(601019901)
			self.waitressTalkState = 2
		end
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.waitress)
		if not BehaviorFunctions.CheckEntityState(self.role,FightEnum.EntityState.Move) then
			BehaviorFunctions.DoSetEntityState(self.role,FightEnum.EntityState.Move)
			BehaviorFunctions.DoSetMoveType(self.role,FightEnum.EntityMoveSubState.Walk)	
		end	
	end
	if self.startRun and not self.inRun then
		local bossTargetPos = BehaviorFunctions.GetTerrainPositionP("BossP1",10020004,"PV11")
		local waitressTargetPos = BehaviorFunctions.GetTerrainPositionP("WaitressP2",10020004,"PV11")
		local sitTargetPos = BehaviorFunctions.GetTerrainPositionP("Waitress",10020004,"PV11")
		--boss寻路
		BehaviorFunctions.SetPathFollowPos(self.boss,bossTargetPos)
		BehaviorFunctions.DoSetEntityState(self.boss,FightEnum.EntityState.Move)
		BehaviorFunctions.DoSetMoveType(self.boss,FightEnum.EntityMoveSubState.Run)
		--服务员
		BehaviorFunctions.SetPathFollowPos(self.waitress,waitressTargetPos)
		BehaviorFunctions.DoSetEntityState(self.waitress,FightEnum.EntityState.Move)
		BehaviorFunctions.DoSetMoveType(self.waitress,FightEnum.EntityMoveSubState.Run)
		----路人
		--BehaviorFunctions.SetPathFollowPos(self.sit1,sitTargetPos)
		--BehaviorFunctions.DoSetEntityState(self.sit1,FightEnum.EntityState.Move)
		--BehaviorFunctions.DoSetMoveType(self.sit1,FightEnum.EntityMoveSubState.Run)
		--BehaviorFunctions.SetPathFollowPos(self.sit2,sitTargetPos)
		--BehaviorFunctions.DoSetEntityState(self.sit2,FightEnum.EntityState.Move)
		--BehaviorFunctions.DoSetMoveType(self.sit2,FightEnum.EntityMoveSubState.Run)
		--BehaviorFunctions.SetPathFollowPos(self.sit3,sitTargetPos)
		--BehaviorFunctions.DoSetEntityState(self.sit3,FightEnum.EntityState.Move)
		--BehaviorFunctions.DoSetMoveType(self.sit3,FightEnum.EntityMoveSubState.Run)
		--BehaviorFunctions.SetPathFollowPos(self.sit4,sitTargetPos)
		--BehaviorFunctions.DoSetEntityState(self.sit4,FightEnum.EntityState.Move)
		--BehaviorFunctions.DoSetMoveType(self.sit4,FightEnum.EntityMoveSubState.Run)
		self.inRun = true
	end
	if self.canFollow and not self.hasFollow then
		local pos = BehaviorFunctions.GetDistanceFromTarget(self.role,self.waitress)
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
			self.isTrigger = self.waitress
			if not self.isTrigger then
				return
			end
			self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Talk,nil,"去店里看看")
		else
			if self.isTrigger  then
				self.isTrigger = false
				BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
			end
		end
	end
	if self.robberCount == 0 then
		if not self.hit then
			BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
			local award = BehaviorFunctions.GetEcoEntityByEcoId(3000901030018)
			BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.InteractEntityHit,award)
			self.hit = true
		end
		if BehaviorFunctions.GetDistanceFromTarget(self.role,self.boss) < 3 and not self.wxTip then
			BehaviorFunctions.StartNPCDialog(601011601,self.boss)
			BehaviorFunctions.DoLookAtTargetImmediately(self.boss,self.role)
			BehaviorFunctions.DoLookAtTargetImmediately(self.waitress,self.role)
			BehaviorFunctions.PlayAnimation(self.boss,"Surprise")
			BehaviorFunctions.PlayAnimation(self.waitress,"Clap_in",FightEnum.AnimationLayer.PerformLayer)
			self.wxTip = true
		end	
	end
end

function Behavior2050403:EnterArea(triggerInstanceId, areaName, logicName)
	--欢迎
	if triggerInstanceId == self.role and areaName == "PleaseArea" and logicName == "PV11" then
		if not self.please then
			BehaviorFunctions.PlayAnimation(self.please1,"PleaseL_in",FightEnum.AnimationLayer.PerformLayer)
			BehaviorFunctions.PlayAnimation(self.please2,"PleaseL_in",FightEnum.AnimationLayer.PerformLayer)		
			self.please = true
		end
	end
	--鞠躬
	if triggerInstanceId == self.role and areaName == "BowArea" and logicName == "PV11" then
		if not self.bossbow then
			BehaviorFunctions.PlayAnimation(self.boss,"Bow_in",FightEnum.AnimationLayer.PerformLayer)
			self.bossbow = true
		end
	end
end


function Behavior2050403:WorldInteractClick(uniqueId, instanceId)
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
		--转身动作
		BehaviorFunctions.CastSkillBySelfPosition(self.waitress,80001059)
		local lookPos = BehaviorFunctions.GetTerrainPositionP("Robber03",10020004,"PV11")
		BehaviorFunctions.DoLookAtPositionByLerp(self.waitress,lookPos.x,lookPos.y,lookPos.z,false,180,460)
		--if self.canFollow then
			--self.canFollow = false
			--self.isFollow = true
			--if not self.waitressPathFinding then
				--local targetPos = BehaviorFunctions.GetTerrainPositionP("WaitressP1",10020004,"PV11")
				--BehaviorFunctions.SetPathFollowPos(self.waitress,targetPos)
				--BehaviorFunctions.DoSetEntityState(self.waitress,FightEnum.EntityState.Move)
				--BehaviorFunctions.DoSetMoveType(self.waitress,FightEnum.EntityMoveSubState.Walk)
				--self.waitressPathFinding = true
				--self.waitressState = 1
				--self.isFollow = true
				--self.hasFollow = true
			--end
		--end
	end
end

function Behavior2050403:FinishSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.waitress and skillId == 80001059 then
		if self.canFollow then
			self.canFollow = false
			self.isFollow = true
			if not self.waitressPathFinding then
				local targetPos = BehaviorFunctions.GetTerrainPositionP("WaitressP1",10020004,"PV11")
				BehaviorFunctions.SetPathFollowPos(self.waitress,targetPos)
				BehaviorFunctions.DoSetEntityState(self.waitress,FightEnum.EntityState.Move)
				BehaviorFunctions.DoSetMoveType(self.waitress,FightEnum.EntityMoveSubState.Walk)
				self.waitressPathFinding = true
				self.waitressState = 1
				self.isFollow = true
				self.hasFollow = true
			end
		end
	end
	
end

function Behavior2050403:Die(attackInstanceId,dieInstanceId, deathReason)
	if dieInstanceId == self.robber01 or dieInstanceId == self.robber02 or dieInstanceId == self.robber03 then
		BehaviorFunctions.DoMagic(1,dieInstanceId,900000008)
		BehaviorFunctions.DoMagic(1,dieInstanceId,900000036)
		BehaviorFunctions.DoMagic(1,dieInstanceId,900000027)
		BehaviorFunctions.AddBuff(1,dieInstanceId,900000029)
		self.robberCount = self.robberCount - 1
	end
end


function Behavior2050403:PathFindingEnd(instanceId,result)
	if instanceId == self.waitress and result == true	then
		--抵达目标地点
		BehaviorFunctions.ClearPathFinding(instanceId)
		BehaviorFunctions.StopMove(instanceId)
		if self.createState == 1 then
			self.isFollow = false
			self.afriadStartFrame = self.frame
			self.createState = 2
		end
	end
	if self.inRun == true and (instanceId == self.boss or instanceId == self.waitress)then
		BehaviorFunctions.StopMove(instanceId)
		local lookPos = BehaviorFunctions.GetTerrainPositionP("Sp1",10020004,"PV11")
		BehaviorFunctions.DoLookAtPositionImmediately(instanceId,lookPos.x,lookPos.y,lookPos.z)
		BehaviorFunctions.PlayAnimation(instanceId,"Afraid")
	end
	if result == true then
		--抵达目标地点
		BehaviorFunctions.ClearPathFinding(instanceId)
		BehaviorFunctions.StopMove(instanceId)
	end
	if instanceId == self.sit1 or instanceId == self.sit2 or instanceId == self.sit3 or instanceId == self.sit4 then
		if result == true then
			BehaviorFunctions.RemoveEntity(instanceId)
		end
	end
end


function Behavior2050403:CreateActor(entityId,bornPos,lookPos)
	local actorBornPos = BehaviorFunctions.GetTerrainPositionP(bornPos,10020004,"PV11")
	local actorLookPos = BehaviorFunctions.GetTerrainPositionP(lookPos,10020004,"PV11")
	local instanceId = BehaviorFunctions.CreateEntityByEntity(self.me,entityId,actorBornPos.x,actorBornPos.y,actorBornPos.z,actorLookPos.x,actorLookPos.y,actorLookPos.z)
	return instanceId
end

function Behavior2050403:Fire()
	if self.robberCount > 0 and self.startFire then
		if self.robber01 and BehaviorFunctions.CheckEntity(self.robber01) and BehaviorFunctions.CanCtrl(self.robber01) and not self.robber01Cd then
			self.robber01Cd = true
			BehaviorFunctions.AddDelayCallByFrame(10,BehaviorFunctions,BehaviorFunctions.CastSkillByTarget,self.robber01,801099101,self.role)
			BehaviorFunctions.AddDelayCallByTime(10,self,self.Assignment,"robber01Cd",false)
		end
		if self.robber02 and BehaviorFunctions.CheckEntity(self.robber02) and BehaviorFunctions.CanCtrl(self.robber02)and not self.robber02Cd then
			self.robber02Cd = true
			BehaviorFunctions.AddDelayCallByFrame(20,BehaviorFunctions,BehaviorFunctions.CastSkillByTarget,self.robber02,801099101,self.role)
			BehaviorFunctions.AddDelayCallByTime(10,self,self.Assignment,"robber02Cd",false)
		end
		if self.robber03 and BehaviorFunctions.CheckEntity(self.robber03) and BehaviorFunctions.CanCtrl(self.robber03) and not self.robber03Cd then
			self.robber03Cd = true
			BehaviorFunctions.AddDelayCallByFrame(40,BehaviorFunctions,BehaviorFunctions.CastSkillByTarget,self.robber03,801099101,self.role)
			BehaviorFunctions.AddDelayCallByTime(10,self,self.Assignment,"robber03Cd",false)
		end
	end
end

function Behavior2050403:AlterStand1(instanceId)
	local aniName = BehaviorFunctions.GetPlayingAnimationName(instanceId,0)
	if aniName ~= "Fire_Shoot_loop" then
		BehaviorFunctions.SetAnimationTranslate(instanceId,"Stand1","Fire_Shoot_loop")
		BehaviorFunctions.PlayAnimation(instanceId,"Stand1")
	end
end

function Behavior2050403:StoryPassEvent(dialogId)
	--选项
	if dialogId == 601010806 and self.inCloseUp == false then
		--怼脸特写
		--设置关卡相机
		self.startRun = true
		self.lookupCamera = BehaviorFunctions.CreateEntity(22006)
		BehaviorFunctions.CameraEntityFollowTarget(self.lookupCamera,self.role,"CloseUpFollow")
		BehaviorFunctions.CameraEntityLockTarget(self.lookupCamera,self.role,"CloseUpLookat")
		BehaviorFunctions.PlayAnimation(self.role,"Tuoshou_loop",FightEnum.AnimationLayer.PerformLayer)
		BehaviorFunctions.PlayAnimation(self.role,"Serious_loop",FightEnum.AnimationLayer.FaceLayer)
		BehaviorFunctions.RemoveEntity(self.sit1)
		BehaviorFunctions.RemoveEntity(self.sit2)
		BehaviorFunctions.RemoveEntity(self.sit3)
		BehaviorFunctions.RemoveEntity(self.sit4)
		self.inCloseUp = true
	end
	--选完
	if dialogId == 601010807  and not self.mingtu then
		BehaviorFunctions.ShowCommonTitle(9,"人物道途已发生改变",true)
		BehaviorFunctions.RemoveEntity(self.lookupCamera)
		self.mingtu = true
	end

end


function Behavior2050403:StoryEndEvent(dialogId)
	if dialogId == 601010801 then
		BehaviorFunctions.AddFightTarget(self.role,self.robber01)
		BehaviorFunctions.AddFightTarget(self.role,self.robber02)
		BehaviorFunctions.AddFightTarget(self.role,self.robber03)
		self.startFire = true
		BehaviorFunctions.RemoveEntity(self.levelCam)
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
	end
end

function Behavior2050403:OnStealEntityGoods(goods_id,instanceId)
	BehaviorFunctions.InteractEntityHit(instanceId)
	self.steelCount = self.steelCount + 1
	if self.steelCount == 6 then
		BehaviorFunctions.StartStoryDialog(601011701)
	end
end

--赋值
function Behavior2050403:Assignment(variable,value)
	self[variable] = value
end