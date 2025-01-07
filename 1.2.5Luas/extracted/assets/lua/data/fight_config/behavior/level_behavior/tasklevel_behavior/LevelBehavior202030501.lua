LevelBehavior202030501 = BaseClass("LevelBehavior202030501")

--创建一个npc
function LevelBehavior202030501.GetGenerates()
	local generates = {800020,2030204}
	return generates
end

function LevelBehavior202030501:__init(fight)
	self.fight = fight
end


function LevelBehavior202030501:Init()
	self.ClickKey=true
	self.missionState=0
	self.dialogList ={
		[1]={id=202030101},
		[2]={id=202030201},
		[3]={id=202030301},
		[4]={id=202030401,key=true},
		[5]={id=202030501,key=true},
		[6]={id=202030601},
		[7]={id=202030701},
		[8]={id=202030801},
		[9]={id=202030901},
		}
	
	self.taskId=202030501
	self.levelId=202030501
	self.tipId=10010018
	self.NpcNum=0
	
	
	self.npcList={
		[1]={id=800020,position="Position_Npc1",instanceId=nil,afraid=false},
		[2]={id=800020,position="Position_Npc2",instanceId=nil,afraid=false},
		[3]={id=800020,position="Position_Npc3",instanceId=nil,afraid=false},
		
		
		
		}
	
	self.boxList2={
		[1]={instanceId=nil,positionName="NPosition1"},
		[2]={instanceId=nil,positionName="NPosition2"},
		[3]={instanceId=nil,positionName="NPosition3"},
		[4]={instanceId=nil,positionName="NPosition4"},
		[5]={instanceId=nil,positionName="NPosition5"},
		[6]={instanceId=nil,positionName="NPosition6"},
		[7]={instanceId=nil,positionName="NPosition7"},
		[8]={instanceId=nil,positionName="NPosition8"},
		[9]={instanceId=nil,positionName="NPosition9"},
	}
	self.blackCurtain=true
	self.progressNum=0
end


function LevelBehavior202030501:Update()
	self.role=BehaviorFunctions.GetCtrlEntity()
	--距离
	local Vector1=BehaviorFunctions.GetPositionP(self.role)
	local Vector2=BehaviorFunctions.GetTerrainPositionP("Position_OutsideCity",10020001,"Logic202030101")
	local Vector3=BehaviorFunctions.GetTerrainPositionP("Position_Npc2",10020001,"Logic202030101")
	self.taskFinDistance=BehaviorFunctions.GetDistanceFromPos(Vector1,Vector3)
	self.outsideDistance=BehaviorFunctions.GetDistanceFromPos(Vector1,Vector2)
	
	if self.blackCurtain==true then 
		BehaviorFunctions.ShowBlackCurtain(false,0.5)
		self.blackCurtain=false
	end



	--初始化全部状态
	if self.missionState==0 
		and self.outsideDistance<50 then
		--去除黑幕
		
		self.guide=BehaviorFunctions.CreateEntity(200000102,nil,Vector3.x,Vector3.y,Vector3.z,nil,nil,nil,self.levelId)

		
		for i=2,3 do
			local pos = BehaviorFunctions.GetTerrainPositionP(self.npcList[i].position,10020001,"Logic202030101")
			local rot = BehaviorFunctions.GetTerrainRotationP(self.npcList[i].position,10020001,"Logic202030101")
			self.npcList[i].instanceId=BehaviorFunctions.CreateEntity(self.npcList[i].id,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
			BehaviorFunctions.SetEntityEuler(self.npcList[i].instanceId,rot.x,rot.y,rot.z)
			BehaviorFunctions.AddBuff(self.role,self.npcList[i].instanceId,900000001)
			
			
		end
		
		BehaviorFunctions.SetEntityValue(self.npcList[2].instanceId,"actList","Stanshou-5|Tuosai-5")
		BehaviorFunctions.SetEntityValue(self.npcList[3].instanceId,"actList","Schayao-6|Songjian-6")
		
		--创建箱子
		for i=1,9 do
			local pos=BehaviorFunctions.GetTerrainPositionP(self.boxList2[i].positionName,10020001,"Logic202030101")
			self.boxList2[i].id=BehaviorFunctions.CreateEntity(2030204,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
			BehaviorFunctions.AddBuff(self.role,self.boxList2[i].id,900000007)
		end
		
	

		self.missionState=1
	end


	--去城外
	if self.missionState==1 then
		--到达远眺点
		if BehaviorFunctions.GetTaskProgress(self.taskId,1)==0 then
			if self.dialogList[4].key==true then
				
				self.levelCam = BehaviorFunctions.CreateEntity(22002)
				BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
				BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.npcList[3].instanceId)
				BehaviorFunctions.StartStoryDialog(self.dialogList[5].id)
				self.cameraTime=BehaviorFunctions.GetFightFrame()
				BehaviorFunctions.RemoveEntity(self.guide)
				self.dialogList[4].key=false
			end
		end
		
		--移除相机
		if self.cameraTime
			and BehaviorFunctions.CheckEntity(self.levelCam)
			and BehaviorFunctions.GetFightFrame()-self.cameraTime>60 then
			BehaviorFunctions.RemoveEntity(self.levelCam)
			
		end
		
		
		
		--到达目标点，直接结束任务
		if BehaviorFunctions.GetTaskProgress(self.taskId,1)==1 then
			if self.taskFinDistance<5
				and self.progressNum==0 then
				if BehaviorFunctions.CheckEntity(self.npcList[2].instanceId)
					and BehaviorFunctions.CheckEntity(self.npcList[3].instanceId) then
					local npcPos2 = BehaviorFunctions.GetPositionP(self.npcList[2].instanceId)
					local lookPos = BehaviorFunctions.GetPositionP(self.role)
					local npcPos3 = BehaviorFunctions.GetPositionP(self.npcList[3].instanceId)
					--BehaviorFunctions.DoLookAtPositionByLerp(self.npcList[2].instanceId,lookPos.x,myPos.y,lookPos.z,false,180,460)
					--BehaviorFunctions.PlayAnimation(self.npcList[2].instanceId,"Standback")
					BehaviorFunctions.SetEntityValue(self.npcList[2].instanceId,"act","Standback")
					BehaviorFunctions.SetEntityValue(self.npcList[3].instanceId,"act","Standback")
					BehaviorFunctions.DoLookAtPositionByLerp(self.npcList[2].instanceId,lookPos.x,npcPos2.y,lookPos.z,false,180,460)
					BehaviorFunctions.DoLookAtPositionByLerp(self.npcList[3].instanceId,lookPos.x,npcPos3.y,lookPos.z,false,180,460)
					--BehaviorFunctions.DoLookAtTargetImmediately(self.npcList[2].instanceId,self.role)
					--BehaviorFunctions.DoLookAtTargetImmediately(self.npcList[3].instanceId,self.role)
					BehaviorFunctions.StartStoryDialog(self.dialogList[6].id)
					self.progressNum=1
				end

			end
			
			if self.NpcNum==2 then
				self.missionState=2
				self.nextLevelFrame=BehaviorFunctions.GetEntityFrame(self.role)
							
			end
		end
	end
	
	
	if self.missionState==2
		and self.nextLevelFrame
		and BehaviorFunctions.GetEntityFrame(self.role)-self.nextLevelFrame>30 then
		self.nextLevelFrame=nil
		BehaviorFunctions.ShowBlackCurtain(true,0.2)
		for i=1,3 do
			BehaviorFunctions.RemoveEntity(self.npcList[i].instanceId)
		end
		for i=1,9 do
			BehaviorFunctions.RemoveEntity(self.boxList2[i].id)
		end
		
		local guidepos=BehaviorFunctions.GetTerrainPositionP("Runaway2",10020001,"Logic202030101")
		BehaviorFunctions.DoSetPositionP(self.role,guidepos)
		BehaviorFunctions.HideTip(self.tipId)
		BehaviorFunctions.SendTaskProgress(self.taskId,1,1)
		BehaviorFunctions.RemoveLevel(self.levelId)
		
	end
	




end
	
	







function LevelBehavior202030501:__delete()

end


function LevelBehavior202030501:StoryEndEvent(dialogId)
	if self.dialogList[5].id==dialogId then
		BehaviorFunctions.ShowTip(10010018,0)
	end


	
end

function LevelBehavior202030501:StoryStartEvent(dialogId)
	if self.dialogList[5].id==dialogId then
		BehaviorFunctions.SendTaskProgress(self.taskId,1,1)
	end

end


function LevelBehavior202030501:Collide(attackInstanceId,hitInstanceId,instanceId,shakeStrenRatio,attackType)
	for i =2,3 do
		if hitInstanceId==self.npcList[i].instanceId
			and self.npcList[i].afraid==false then
			BehaviorFunctions.PlayAnimation(self.npcList[i].instanceId,"Afraid_loop")
			--BehaviorFunctions.RemoveEntity(self.npcList[i].instanceId)
			self.NpcNum=self.NpcNum+1
			BehaviorFunctions.ChangeTitleTipsDesc(self.tipId,self.NpcNum)
			self.npcList[i].afraid=true

		end
	end
end





