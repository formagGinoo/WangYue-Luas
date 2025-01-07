LevelBehavior202030401 = BaseClass("LevelBehavior202030401")

--创建一个npc
function LevelBehavior202030401.GetGenerates()
	local generates = {800020,2030204}
	return generates
end

function LevelBehavior202030401:__init(fight)
	self.fight = fight
end


function LevelBehavior202030401:Init()
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
	
	self.taskId=202030401
	self.levelId=202030401
	
	
	self.npcList={
		[1]={id=800020,position="Position_Npc1",instanceId=nil},
		[2]={id=800020,position="Position_Npc2",instanceId=nil},
		[3]={id=800020,position="Position_Npc3",instanceId=nil},
		}
	
	self.boxList={
		[1]={instanceId=nil,positionName="Position1"},
		[2]={instanceId=nil,positionName="Position2"},
		[3]={instanceId=nil,positionName="Position3"},
		[4]={instanceId=nil,positionName="Position4"},
		[5]={instanceId=nil,positionName="Position5"},
		[6]={instanceId=nil,positionName="Position6"},
		[7]={instanceId=nil,positionName="Position7"},
		[8]={instanceId=nil,positionName="Position8"},
		[9]={instanceId=nil,positionName="Position9"},
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


function LevelBehavior202030401:Update()
	self.role=BehaviorFunctions.GetCtrlEntity()
	--距离
	local Vector1=BehaviorFunctions.GetPositionP(self.role)
	local Vector2=BehaviorFunctions.GetTerrainPositionP("Position_RoleQuit",10020001,"Logic202030101")
	local Vector3=BehaviorFunctions.GetTerrainPositionP("Position_OutsideCity",10020001,"Logic202030101")
	self.distance=BehaviorFunctions.GetDistanceFromPos(Vector1,Vector2)
	self.taskFinDistance=BehaviorFunctions.GetDistanceFromPos(Vector1,Vector3)
	
	if self.blackCurtain==true then
		BehaviorFunctions.ShowBlackCurtain(false,0.5)
		self.blackCurtain=false
	end


	--初始化全部状态
	if self.missionState==0 
		and self.distance<50 then
		--去除黑幕

		local pos1 = BehaviorFunctions.GetTerrainPositionP("Position_Npc",10020001,"Logic202030101")

		self.npc1=BehaviorFunctions.CreateEntity(800020,nil,pos1.x,pos1.y,pos1.z,nil,nil,nil,self.levelId)
		BehaviorFunctions.AddBuff(self.role,self.npc1,900000007)




		--创建箱子
		for i=1,9 do
			local pos=BehaviorFunctions.GetTerrainPositionP(self.boxList[i].positionName,10020001,"Logic202030101")
			self.boxList[i].id=BehaviorFunctions.CreateEntity(2030204,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
			BehaviorFunctions.AddBuff(self.role,self.boxList[i].id,900000007)
		end

		self.missionState=1
	end


	--去城外
	if self.missionState==1 then
		--密谋点对话
		if BehaviorFunctions.GetTaskProgress(self.taskId,1)==0 then
			if self.dialogList[4].key==true then
				BehaviorFunctions.StartStoryDialog(self.dialogList[4].id)
				self.dialogList[4].key=false
			end
		end
		
		--创建第二波npc和箱子
		if self.progressNum==0
			and self.taskFinDistance<20 then
			for i=2,3 do
				local pos = BehaviorFunctions.GetTerrainPositionP(self.npcList[i].position,10020001,"Logic202030101")
				local rot = BehaviorFunctions.GetTerrainRotationP(self.npcList[i].position,10020001,"Logic202030101")
				self.npcList[i].instanceId=BehaviorFunctions.CreateEntity(self.npcList[i].id,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
				BehaviorFunctions.SetEntityEuler(self.npcList[i].instanceId,rot.x,rot.y,rot.z)


			end

			BehaviorFunctions.SetEntityValue(self.npcList[2].instanceId,"actList","Stanshou-5|Tuosai-5")
			BehaviorFunctions.SetEntityValue(self.npcList[3].instanceId,"actList","Schayao-6|Songjian-6")
			
			--创建箱子
			for i=1,9 do
				local pos=BehaviorFunctions.GetTerrainPositionP(self.boxList2[i].positionName,10020001,"Logic202030101")
				self.boxList2[i].id=BehaviorFunctions.CreateEntity(2030204,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
				BehaviorFunctions.AddBuff(self.role,self.boxList2[i].id,900000007)
			end
			
			self.progressNum=1
		end
		
		
		
		
		--到达目标点，直接结束任务
		if BehaviorFunctions.GetTaskProgress(self.taskId,1)==1 then
			if self.taskFinDistance<3 then
				BehaviorFunctions.ShowBlackCurtain(true,0.5)
				BehaviorFunctions.SendTaskProgress(self.taskId,1,1)
				BehaviorFunctions.RemoveLevel(self.levelId)
				self.missionState=2

			end
		end
	end




end
	
	

	
	




function LevelBehavior202030401:__delete()

end


function LevelBehavior202030401:StoryEndEvent(dialogId)
	if self.dialogList[4].id==dialogId then

		
		BehaviorFunctions.SendTaskProgress(self.taskId,1,1)
	end
	
end








