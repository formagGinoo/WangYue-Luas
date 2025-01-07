LevelBehavior202010201 = BaseClass("LevelBehavior202010201")

--集合关卡
function LevelBehavior202010201.GetGenerates()
	local generates = {800020,900040,910040,900042}
	return generates
end

function LevelBehavior202010201:__init(fight)
	self.fight = fight
end

--storydialog预加载
function LevelBehavior202010201.GetStorys()
	local story = {202010101,202010201,202010301,202010401,202010501,202010601}
	return story
end


function LevelBehavior202010201:Init()
	self.ClickKey=true
	self.missionState=0
	self.monsterNum=0
	self.animationFinish=false
	self.animationFrame=47
	self.animationTotalFrame=92
	self.initialKey=true
	self.taskId=202010201
	self.levelId=202010201
	self.dialogList={
		[1]={id=202010101},
		[2]={id=202010201},
		[3]={id=202010301},
		[4]={id=202010401},
		[5]={id=202010501},
		[6]={id=202010601},
		
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
end


function LevelBehavior202010201:Update()
	self.role=BehaviorFunctions.GetCtrlEntity()
	--初始化NPC状态
	if self.missionState==0 then 
		BehaviorFunctions.ShowBlackCurtain(false,1)
		local pos = BehaviorFunctions.GetTerrainPositionP("Position3",10020001,"Logic202010101")
		self.npc=BehaviorFunctions.CreateEntity(800020,nil,pos.x,pos.y,pos.z)
		BehaviorFunctions.AddBuff(self.role,self.npc,900000001)
		self.dialogId=BehaviorFunctions.SetEntityValue(self.npc,"dialogId",self.dialogList[4].id)
		self.missionState=1
	end
	
	if self.removeNpc
		and BehaviorFunctions.CheckEntity(self.npc)
		and BehaviorFunctions.GetEntityFrame(self.role)-self.removeNpc>30 then


		BehaviorFunctions.RemoveEntity(self.npc)
		self.removeNpc=nil
		BehaviorFunctions.ShowBlackCurtain(false,0.5)
		
		self.nextMission=BehaviorFunctions.GetEntityFrame(self.role)

	end
	
	
	if self.nextMission
		and BehaviorFunctions.GetEntityFrame(self.role)-self.nextMission>15 then
		self.nextMission=nil
		self.missionState=2
	end
	
	
	
	

	if self.missionState==2 then
		
		
		if self.levelProgress==1 then

			local pos1 = BehaviorFunctions.GetTerrainPositionP("Position3_1",10020001,"Logic202010101")
			local pos2 = BehaviorFunctions.GetTerrainPositionP("Position3_2",10020001,"Logic202010101")
			local pos3 = BehaviorFunctions.GetTerrainPositionP("Position3_3",10020001,"Logic202010101")
			BehaviorFunctions.RemoveEntity(self.levelCam)
			BehaviorFunctions.RemoveEntity(self.empty)

			self.monsterList[1].instanceId=BehaviorFunctions.CreateEntity(900042,nil,pos1.x,pos1.y,pos1.z,0,0,0,self.levelId)
			self.monsterList[2].instanceId=BehaviorFunctions.CreateEntity(910040,nil,pos2.x,pos2.y,pos2.z,0,0,0,self.levelId)
			self.monsterList[3].instanceId=BehaviorFunctions.CreateEntity(900040,nil,pos3.x,pos3.y,pos3.z,0,0,0,self.levelId)

			for i=1,3 do
				BehaviorFunctions.SetEntityValue(self.monsterList[i].instanceId,"battleTarget",self.role)
				BehaviorFunctions.SetEntityValue(self.monsterList[i].instanceId,"haveWarn",false)
				BehaviorFunctions.DoLookAtTargetImmediately(self.monsterList[i].instanceId,self.role)

			end
			--npc逃跑

			
		

			BehaviorFunctions.StartStoryDialog(self.dialogList[5].id)

			self.levelProgress=2
		end
		if self.levelProgress==2 then
			BehaviorFunctions.ShowTip(10010016,0)
			BehaviorFunctions.ChangeTitleTipsDesc(10010016,self.monsterNum)
			self.levelProgress=3
		end
		
		--将怪物杀死，播放对白
		if self.levelProgress==3 then
			if self.monsterNum==3 then
				BehaviorFunctions.HideTip(10010016)
				self.levelProgress=0

				self.finishTime = BehaviorFunctions.GetEntityFrame(self.role)
				
				self.missionState=3

			end
		end

		
	end
	
	
	if self.missionState==3 
		and BehaviorFunctions.GetEntityFrame(self.role)-self.finishTime>15 then
		BehaviorFunctions.ShowCommonTitle(5,"护送游商",true)
		BehaviorFunctions.SendTaskProgress(self.taskId,1,1)
		BehaviorFunctions.RemoveLevel(self.levelId)
		self.missionState=4
		
	end
	
	
	
	
end



function LevelBehavior202010201:__delete()

end



function LevelBehavior202010201:StoryEndEvent(dialogId)
	if dialogId==self.dialogList[4].id then
		BehaviorFunctions.HideTip(10010017)
		BehaviorFunctions.ShowBlackCurtain(true,0.2)
		self.removeNpc=BehaviorFunctions.GetEntityFrame(self.role)
		local pos = BehaviorFunctions.GetTerrainPositionP("Position3",10020001,"Logic202010101")
		local rot = BehaviorFunctions.GetTerrainRotationP("Position3",10020001,"Logic202010101")
		BehaviorFunctions.DoSetPositionP(self.role,pos)
		BehaviorFunctions.SetEntityEuler(self.role,rot.x,rot.y,rot.z)
		local fp1 = BehaviorFunctions.GetTerrainPositionP("Position3_2",10020001,"Logic202010101")
		self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z,0,0,0,self.levelId)
		self.levelCam=BehaviorFunctions.CreateEntity(22001,nil,nil,nil,nil,0,0,0,self.levelId)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		
		
		
		
	end

end


function LevelBehavior202010201:PathFindingEnd(instanceId,result)

end





function LevelBehavior202010201:Die(attackInstanceId,dieInstanceId)

	for k,v in ipairs(self.monsterList) do
		if v.instanceId==dieInstanceId then
			self.monsterNum=self.monsterNum+1
			BehaviorFunctions.ChangeTitleTipsDesc(10010016,self.monsterNum)
		end
	end
	
end


