LevelBehavior202030301 = BaseClass("LevelBehavior202030301")

--创建一个npc
function LevelBehavior202030301.GetGenerates()
	local generates = {800020,2030204}
	return generates
end

function LevelBehavior202030301:__init(fight)
	self.fight = fight
end


function LevelBehavior202030301:Init()
	self.ClickKey=true
	self.missionState=0
	self.dialogList ={
		[1]={id=202030101},
		[2]={id=202030201},
		[3]={id=202030301},
		[4]={id=202030401},
		[5]={id=202030501},
		[6]={id=202030601},
		[7]={id=202030701},
		[8]={id=202030801},
		[9]={id=202030901},
		}
	
	self.taskId=202030301
	self.levelId=202030301
	self.levelProgress = 1
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

	
end


function LevelBehavior202030301:Update()
	self.role=BehaviorFunctions.GetCtrlEntity()
	--距离
	local Vector1=BehaviorFunctions.GetPositionP(self.role)
	local Vector2=BehaviorFunctions.GetTerrainPositionP("Position_RoleQuit",10020001,"Logic202030101")
	self.distance=BehaviorFunctions.GetDistanceFromPos(Vector1,Vector2)
	
	if self.missionState==0 then 
		--去除黑幕
		BehaviorFunctions.ShowBlackCurtain(false,0.5)	

		local pos = BehaviorFunctions.GetTerrainPositionP("Position_Npc",10020001,"Logic202030101")
		
		--保证npc和场景和上一步相同
		self.npc=BehaviorFunctions.CreateEntity(800020,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
		BehaviorFunctions.SetEntityLifeBarVisibleType(self.npc,3)
		BehaviorFunctions.AddBuff(self.role,self.npc,900000007)
		
		local rotation = BehaviorFunctions.GetTerrainRotationP("Position_Npc",10020001,"Logic202030101")
		BehaviorFunctions.SetEntityEuler(self.npc,rotation.x,rotation.y,rotation.z)
		BehaviorFunctions.SetEntityValue(self.npc,"act","Count")
		self.guide=BehaviorFunctions.CreateEntity(200000102,nil,Vector2.x,Vector2.y,Vector2.z,nil,nil,nil,self.levelId)
		--创建箱子
		for i=1,9 do
			local pos=BehaviorFunctions.GetTerrainPositionP(self.boxList[i].positionName,10020001,"Logic202030101")
			self.boxList[i].id=BehaviorFunctions.CreateEntity(2030204,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
			BehaviorFunctions.AddBuff(self.role,self.boxList[i].id,900000007)
		end
		
		
		self.missionState=1
	end
	
	if self.missionState==1 then
		if self.distance<2 then
			BehaviorFunctions.RemoveEntity(self.guide)
			BehaviorFunctions.StartStoryDialog(self.dialogList[3].id)
			
			self.missionState=2
		end
	end	

	
	
end



function LevelBehavior202030301:__delete()

end



function LevelBehavior202030301:StoryEndEvent(dialogId)

	if self.dialogList[3].id==dialogId then

		BehaviorFunctions.SendTaskProgress(self.taskId,1,1)
		BehaviorFunctions.RemoveLevel(self.levelId)
		self.missionState=3
	end
	
	
end





