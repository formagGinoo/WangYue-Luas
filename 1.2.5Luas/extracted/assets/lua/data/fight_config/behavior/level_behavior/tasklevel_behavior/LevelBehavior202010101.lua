LevelBehavior202010101 = BaseClass("LevelBehavior202010101")

--集合关卡
function LevelBehavior202010101.GetGenerates()
	local generates = {800020,900040,910040,900042}
	return generates
end

function LevelBehavior202010101:__init(fight)
	self.fight = fight
end

--storydialog预加载
function LevelBehavior202010101.GetStorys()
	local story = {202010101,202010201,202010301,202010401,202010501,202010601}
	return story
end

function LevelBehavior202010101:Init()
	self.ClickKey=true
	self.missionState=0
	self.monsterNum=0
	self.animationFinish=false
	self.animationFrame=47
	self.animationTotalFrame=92
	self.initialKey=true
	self.taskId=202010101
	self.levelId=202010101
	self.dialogList={
		[1]={id=202010101},
		[2]={id=202010201},
		[3]={id=202010301},
		[4]={id=202010401},
		
	}
	
	
	self.monsterList = {
		[1]={id=900040,instanceId=nil},
		[2]={id=900040,instanceId=nil},
		[3]={id=900040,instanceId=nil},
		[4]={id=900040,instanceId=nil},
		[5]={id=900042,instanceId=nil},
		[6]={id=900040,instanceId=nil},
		
		
		
		
		}

	self.levelProgress = 1
	self.npcStateEnum={
		stand=0,
		run=1
		}
	self.npcState=0
	self.enterAreaKey=false
	self.hitAnimation =true
	self.beHitFrame=0
	self.bhitLastTime=30
end


function LevelBehavior202010101:Update()
	self.role=BehaviorFunctions.GetCtrlEntity()
	if self.missionState==0 then 
		local pos = BehaviorFunctions.GetTerrainPositionP("Position0",10020001,"Logic202010101")
		local rot = BehaviorFunctions.GetTerrainRotationP("Position0",10020001,"Logic202010101")
		self.npc=BehaviorFunctions.CreateEntity(800020,nil,pos.x,pos.y,pos.z,0,0,0,self.levelId)
		BehaviorFunctions.SetEntityEuler(self.npc,rot.x,rot.y,rot.z)
		BehaviorFunctions.AddBuff(self.role,self.npc,900000001)
		self.dialogId=BehaviorFunctions.SetEntityValue(self.npc,"dialogId",self.dialogList[1].id)
		BehaviorFunctions.SetEntityValue(self.npc,"act","Yell")
		BehaviorFunctions.SetEntityValue(self.npc,"talkEnd","noReaction")
		--支线光柱
		self.zhixianGuide=BehaviorFunctions.CreateEntity(20600,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
		
		--self.bhitLastTime=BehaviorFunctions.GetEntityAnimationFrame(self.npc,"Bhit")
		self.missionState=1
	end

	if self.missionState==2 then
		
		
		if self.levelProgress==1 then

			local pos1 = BehaviorFunctions.GetTerrainPositionP("Position1_1",10020001,"Logic202010101")
			local pos2 = BehaviorFunctions.GetTerrainPositionP("Position1_2",10020001,"Logic202010101")
			local pos3 = BehaviorFunctions.GetTerrainPositionP("Position1_3",10020001,"Logic202010101")
			

			self.monsterList[1].instanceId=BehaviorFunctions.CreateEntity(900040,nil,pos1.x,pos1.y,pos1.z,0,0,0,self.levelId)
			self.monsterList[2].instanceId=BehaviorFunctions.CreateEntity(900040,nil,pos2.x,pos2.y,pos2.z,0,0,0,self.levelId)
			self.monsterList[3].instanceId=BehaviorFunctions.CreateEntity(900040,nil,pos3.x,pos3.y,pos3.z,0,0,0,self.levelId)

			for i=1,3 do
				BehaviorFunctions.SetEntityValue(self.monsterList[i].instanceId,"battleTarget",self.npc)
				BehaviorFunctions.SetEntityValue(self.monsterList[i].instanceId,"haveWarn",false)
				BehaviorFunctions.DoLookAtTargetImmediately(self.monsterList[i].instanceId,self.npc)

			end
			
		

			BehaviorFunctions.StartStoryDialog(self.dialogList[2].id)
			BehaviorFunctions.PlayAnimation(self.npc,"Afraid")
			self.afraidStart=BehaviorFunctions.GetEntityFrame(self.role)
			self.levelProgress=2
		end
		if self.levelProgress==2 then

			BehaviorFunctions.ShowTip(10010016,0)
			

			BehaviorFunctions.ChangeTitleTipsDesc(10010016,self.monsterNum)
			self.levelProgress=3
		end
		
		----npc害怕循环
		--if self.afraidStart
			--and BehaviorFunctions.GetEntityFrame(self.role)-self.afraidStart>self.animationFrame
			--and self.animationFinish==false then
			--BehaviorFunctions.PlayAnimation(self.npc,"Afraid_loop")
			--self.animationFinish=true
			--self.afraidStart=nil
			
		--end
		
		
		
		--结束害怕，进入下一阶段
		if self.levelProgress==3 then
			if self.monsterNum==3 then
				BehaviorFunctions.HideTip(10010016)


				BehaviorFunctions.PlayAnimation(self.npc,"Afraid")
				self.walkStart=BehaviorFunctions.GetEntityFrame(self.role)
				
				self.levelProgress=0
				
			end
		end


		--设置npc去下一个目标点
		if self.walkStart
			and BehaviorFunctions.GetEntityFrame(self.role)-self.walkStart>self.animationTotalFrame then
			local pos = BehaviorFunctions.GetTerrainPositionP("Position2",10020001,"Logic202010101")
			local result=BehaviorFunctions.SetPathFollowPos(self.npc,pos)
			if result==true then
				BehaviorFunctions.DoSetEntityState(self.npc,FightEnum.EntityState.Move)
				BehaviorFunctions.DoSetMoveType(self.npc,FightEnum.EntityMoveSubState.Run)
				self.walkStart=nil
				self.missionState=3
				self.hitAnimation=true
			end
		end
		
	end
	
	

	
	
	if self.missionState==4 then

		if self.levelProgress==1 then

			local pos1 = BehaviorFunctions.GetTerrainPositionP("Position2_1",10020001,"Logic202010101")
			local pos2 = BehaviorFunctions.GetTerrainPositionP("Position2_2",10020001,"Logic202010101")
			local pos3 = BehaviorFunctions.GetTerrainPositionP("Position2_3",10020001,"Logic202010101")

			self.monsterList[4].instanceId=BehaviorFunctions.CreateEntity(900040,nil,pos1.x,pos1.y,pos1.z,0,0,0,self.levelId)
			self.monsterList[5].instanceId=BehaviorFunctions.CreateEntity(900040,nil,pos2.x,pos2.y,pos2.z,0,0,0,self.levelId)
			self.monsterList[6].instanceId=BehaviorFunctions.CreateEntity(900040,nil,pos3.x,pos3.y,pos3.z,0,0,0,self.levelId)


			--将npc设置为攻击目标
			
			for i=4,6 do
				BehaviorFunctions.SetEntityValue(self.monsterList[i].instanceId,"battleTarget",self.npc)
				BehaviorFunctions.SetEntityValue(self.monsterList[i].instanceId,"haveWarn",false)
				BehaviorFunctions.DoLookAtTargetImmediately(self.monsterList[i].instanceId,self.npc)
				
			end
		
			BehaviorFunctions.StartStoryDialog(self.dialogList[3].id)
			BehaviorFunctions.PlayAnimation(self.npc,"Afraid")
			self.afraidStart=BehaviorFunctions.GetEntityFrame(self.role)
			self.levelProgress=2
		end
		
		if self.levelProgress==2 then

			BehaviorFunctions.ShowTip(10010016,0)
			

			BehaviorFunctions.ChangeTitleTipsDesc(10010016,self.monsterNum)
			self.levelProgress=3
		end





		--结束害怕，进入下一阶段
		if self.levelProgress==3 then
			if self.monsterNum==3 then
				BehaviorFunctions.HideTip(10010016)
				BehaviorFunctions.PlayAnimation(self.npc,"Afraid")
				self.walkStart=BehaviorFunctions.GetEntityFrame(self.role)
				self.levelProgress=0

			end
		end


		--设置npc去下一个目标点
		if self.walkStart
			and BehaviorFunctions.GetEntityFrame(self.role)-self.walkStart>self.animationTotalFrame then
			local pos = BehaviorFunctions.GetTerrainPositionP("Position3",10020001,"Logic202010101")
			BehaviorFunctions.SetPathFollowPos(self.npc,pos)
			BehaviorFunctions.DoSetEntityState(self.npc,FightEnum.EntityState.Move)
			BehaviorFunctions.DoSetMoveType(self.npc,FightEnum.EntityMoveSubState.Run)
			self.walkStart=nil
			self.missionState=5
		end

	end
	
	if self.missionState==6 then
		local pos1 = BehaviorFunctions.GetTerrainPositionP("Position3",10020001,"Logic202010101")
		local pos2 = BehaviorFunctions.GetPositionP(self.role)
		self.taskFinishDistance=BehaviorFunctions.GetDistanceFromPos(pos1,pos2)
		if self.taskFinishDistance<5 then
			self.enterAreaKey=true
			else
			self.enterAreaKey=false
		end
		
		if self.enterAreaKey==true then
			BehaviorFunctions.ShowBlackCurtain(true,0.5)
			BehaviorFunctions.RemoveEntity(self.npc)
			BehaviorFunctions.SendTaskProgress(self.taskId,1,1)
			BehaviorFunctions.RemoveLevel(self.levelId)
			self.missionState=7
		end
	end
	
	if self.missionState==999 then
		if BehaviorFunctions.GetFightFrame()-self.rebornTime>30 then
			BehaviorFunctions.ShowBlackCurtain(false,0.2)
			self.missionState=0
			local pos = BehaviorFunctions.GetTerrainPositionP("Position0_Role",10020001,"Logic202010101")
			BehaviorFunctions.Transport(10020001,pos.x,pos.y,pos.z)
			

		end
	end
	
	
	--npc受击动画
	if self.hitAnimation==false
		and BehaviorFunctions.GetEntityFrame(self.role)-self.beHitFrame>self.bhitLastTime then
		self.hitAnimation=true
		if BehaviorFunctions.CheckEntity(self.npc) then
		BehaviorFunctions.PlayAnimation(self.npc,"Afraid")
		self.afraidStart=BehaviorFunctions.GetEntityFrame(self.role)
		end
	end
	
	--npc由害怕变成循环害怕
	if self.afraidStart
		and BehaviorFunctions.GetEntityFrame(self.role)-self.afraidStart>self.animationFrame then
		if BehaviorFunctions.CheckEntity(self.npc) then
			BehaviorFunctions.PlayAnimation(self.npc,"Afraid_loop")
			self.afraidStart=nil
		end
	end

	
	
	
end


function LevelBehavior202010101:__delete()

end

function LevelBehavior202010101:StoryStartEvent(dialogId)
	if dialogId==self.dialogList[1].id then
		self.npcState=self.npcStateEnum.run
		if self.zhixianGuide
			and BehaviorFunctions.CheckEntity(self.zhixianGuide) then
			BehaviorFunctions.RemoveEntity(self.zhixianGuide)
			self.zhixianGuide=nil
		end
	end
end

function LevelBehavior202010101:StoryEndEvent(dialogId)
	if dialogId==self.dialogList[1].id then
		local pos = BehaviorFunctions.GetTerrainPositionP("Position1",10020001,"Logic202010101")
		BehaviorFunctions.SetPathFollowPos(self.npc,pos)
		BehaviorFunctions.DoSetEntityState(self.npc,FightEnum.EntityState.Move)
		BehaviorFunctions.DoSetMoveType(self.npc,FightEnum.EntityMoveSubState.Run)
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
		BehaviorFunctions.SetGuideTask(self.taskId)


	end
end


function LevelBehavior202010101:PathFindingEnd(instanceId,result)
	if instanceId==self.npc  then
		--第一次寻路到目的地
		if self.missionState==1 then
			if result ==true then
				BehaviorFunctions.ClearPathFinding(self.npc)
				BehaviorFunctions.DoSetEntityState(self.npc,FightEnum.EntityState.Idle)
				self.missionState=2
			else
				local pos = BehaviorFunctions.GetTerrainPositionP("Position1",10020001,"Logic202010101")
				BehaviorFunctions.SetPathFollowPos(self.npc,pos)
				BehaviorFunctions.DoSetEntityState(self.npc,FightEnum.EntityState.Move)
				BehaviorFunctions.DoSetMoveType(self.npc,FightEnum.EntityMoveSubState.Run)

			end
		end
		--第二次寻路到目的地
		if self.missionState==3 then
			if result ==true then
				BehaviorFunctions.ClearPathFinding(self.npc)
				BehaviorFunctions.DoSetEntityState(self.npc,FightEnum.EntityState.Idle)
				self.missionState=4
				self.levelProgress=1
				self.monsterNum=0
				self.animationFinish=false
			else
				local pos = BehaviorFunctions.GetTerrainPositionP("Position2",10020001,"Logic202010101")
				BehaviorFunctions.SetPathFollowPos(self.npc,pos)
				BehaviorFunctions.DoSetEntityState(self.npc,FightEnum.EntityState.Move)
				BehaviorFunctions.DoSetMoveType(self.npc,FightEnum.EntityMoveSubState.Run)

			end
		end
		
		--第三次寻路到目的地
		if self.missionState==5 then
			if result ==true then
				BehaviorFunctions.ClearPathFinding(self.npc)
				BehaviorFunctions.DoSetEntityState(self.npc,FightEnum.EntityState.Idle)



				self.missionState=6
			else
				local pos = BehaviorFunctions.GetTerrainPositionP("Position3",10020001,"Logic202010101")
				BehaviorFunctions.SetPathFollowPos(self.npc,pos)
				BehaviorFunctions.DoSetEntityState(self.npc,FightEnum.EntityState.Move)
				BehaviorFunctions.DoSetMoveType(self.npc,FightEnum.EntityMoveSubState.Run)
				
			end

		end
		

		
		
	end
end



function LevelBehavior202010101:Die(attackInstanceId,dieInstanceId)

	for k,v in ipairs(self.monsterList) do
		if v.instanceId==dieInstanceId then
			self.monsterNum=self.monsterNum+1
			BehaviorFunctions.ChangeTitleTipsDesc(10010016,self.monsterNum)
		end
	end
	

end

function LevelBehavior202010101:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType)
	if attackInstanceId==self.role then
		for k,v in ipairs(self.monsterList) do 
			if v.instanceId==hitInstanceId then
				BehaviorFunctions.SetEntityValue(hitInstanceId,"battleTarget",self.role)
			end
		end
	end
end

function LevelBehavior202010101:Death(instanceId,isFormationRevive)
	if instanceId==self.npc then
		self.missionState=999
		BehaviorFunctions.ShowBlackCurtain(true,0.2)
		self.rebornTime=BehaviorFunctions.GetFightFrame()
		BehaviorFunctions.HideTip(10010016)


		
		self.levelProgress=1
		self.monsterNum=0
		self.animationFinish=false
		self.npcState=self.npcStateEnum.stand
		
		for k,v in ipairs(self.monsterList) do
			if v.instanceId 
				and BehaviorFunctions.CheckEntity(v.instanceId) then
				BehaviorFunctions.RemoveEntity(v.instanceId)
			end
		end
		
	end
end

--function LevelBehavior202010101:EnterArea(triggerInstanceId,areaName,logicName)
	--if triggerInstanceId==self.role
		--and areaName=="Area3"
		--and (self.missionState==6
		--or self.missionState==5)
		--and self.enterAreaKey==false
		--and logicName=="Logic202010101" then
		--self.enterAreaKey=true
	--end
--end


function LevelBehavior202010101:AfterDamage(InstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal,attackType,partType,damageInfo,attackInstanceId,isCirt)
	if InstanceId==self.role
		and hitInstanceId==self.npc then
		BehaviorFunctions.ChangeEntityAttr(self.npc,1001,damageVal,1)
		
	end
end


function LevelBehavior202010101:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	if hitInstanceId==self.npc
		and attackInstanceId~=self.role 
		and self.hitAnimation ==true then
		self.hitAnimation=false
		local attpos = BehaviorFunctions.GetPositionP(attackInstanceId)
		local hitpos = BehaviorFunctions.GetPositionP(hitInstanceId)
		local hitrot = BehaviorFunctions.GetEntityEuler(hitInstanceId)
		local rot = Quat.Euler(hitrot.x, hitrot.y, hitrot.z)
		local angle1 = BehaviorFunctions.GetPosAngle(rot,hitpos,attpos)
		local angle2 = 360-angle1
		local angle = math.min(angle1,angle2)
		if angle<90 then
			BehaviorFunctions.PlayAnimation(hitInstanceId,"Fhit")
			self.beHitFrame=BehaviorFunctions.GetEntityFrame(self.role)
			return 
		else
			BehaviorFunctions.PlayAnimation(hitInstanceId,"Bhit")
			self.beHitFrame=BehaviorFunctions.GetEntityFrame(self.role)
			return
		end
	end
end



