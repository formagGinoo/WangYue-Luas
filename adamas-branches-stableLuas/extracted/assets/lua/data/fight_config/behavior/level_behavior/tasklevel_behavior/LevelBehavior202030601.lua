LevelBehavior202030601 = BaseClass("LevelBehavior202030601")

--创建一个npc
function LevelBehavior202030601.GetGenerates()
	local generates = {800020,2030204}
	return generates
end

function LevelBehavior202030601:__init(fight)
	self.fight = fight
end
function LevelBehavior202030601.GetStorys()
	local story = {202030101,202030201,202030301,202030401,202030501,202030601,202030701,202030801,202030901}
	return story
end


function LevelBehavior202030601:Init()
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
	
	self.taskId=202030601
	self.levelId=202030601
	self.tipId=10010018
	self.NpcNum=0
	
	
	self.npcList={
		[1]={id=800020,position="Position_Npc1",instanceId=nil},
		[2]={id=800020,position="Position_Npc2",instanceId=nil},
		[3]={id=800020,position="Position_Npc3",instanceId=nil},
		
		
		
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
	self.taskId=202030601
	self.progressNum=0
	self.actKey=true
end


function LevelBehavior202030601:Update()
	self.role=BehaviorFunctions.GetCtrlEntity()
	--距离
	local Vector1=BehaviorFunctions.GetPositionP(self.role)
	local Vector3=BehaviorFunctions.GetTerrainPositionP("Runaway2",10020001,"Logic202030101")
	self.taskFinDistance=BehaviorFunctions.GetDistanceFromPos(Vector1,Vector3)
	
	if self.blackRemove
		and BehaviorFunctions.GetEntityFrame(self.role)-self.blackRemove==15 then
		BehaviorFunctions.ShowBlackCurtain(false,1)
		self.blackRemove=nil
	end


	--初始化全部状态
	if self.missionState==0 then 

		if self.taskFinDistance<50 then
		BehaviorFunctions.ShowBlackCurtain(false,1)
		--创造复刷点
		local guidepos=BehaviorFunctions.GetTerrainPositionP("Runaway2",10020001,"Logic202030101")
		self.guide=BehaviorFunctions.CreateEntity(200000108,nil,guidepos.x,guidepos.y,guidepos.z,nil,nil,nil,self.levelId)
		--获取玩家体力上限
		self.maxStamina=BehaviorFunctions.GetPlayerAttrVal(642)
		
		--创建箱子
		for i=1,9 do
			local pos=BehaviorFunctions.GetTerrainPositionP(self.boxList2[i].positionName,10020001,"Logic202030101")
			self.boxList2[i].id=BehaviorFunctions.CreateEntity(2030204,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
			BehaviorFunctions.AddBuff(self.role,self.boxList2[i].id,900000007)
		end


	

		self.missionState=1
		end
	end


	--开启关卡
	if self.missionState==1 then
		if self.taskFinDistance<3 then
			
			BehaviorFunctions.ChangePlayerAttr(FightEnum.PlayerAttr.CurStaminaValue,self.maxStamina)

			BehaviorFunctions.StartStoryDialog(self.dialogList[7].id)
			local pos=BehaviorFunctions.GetTerrainPositionP("Runaway2",10020001,"Logic202030101")
			local rot=BehaviorFunctions.GetTerrainRotationP("Runaway2",10020001,"Logic202030101")
			
			BehaviorFunctions.DoSetPositionP(self.role,pos)
			BehaviorFunctions.SetEntityEuler(self.role,rot.x,rot.y,rot.z)
			
			if BehaviorFunctions.CheckEntity(self.guide) then
				BehaviorFunctions.RemoveEntity(self.guide)
			end
			BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"O",false) --跳跃按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",false)
			BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) --技能按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"K",false) --技能按钮
			BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能按钮
			self.runStart = BehaviorFunctions.GetEntityFrame(self.role)
			local pos = BehaviorFunctions.GetTerrainPositionP("Position_Npc1",10020001,"Logic202030101")
			self.npc = BehaviorFunctions.CreateEntity(800020,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
			BehaviorFunctions.AddBuff(self.role,self.npc,900000001)
			self.missionState=2
			BehaviorFunctions.SetGuideTask(self.taskId)
		end
	end
	
	if self.runStart
		and BehaviorFunctions.GetEntityFrame(self.role)-self.runStart>30 then
		self.missionState=3
		self.levelCam = BehaviorFunctions.CreateEntity(22002)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.npc)

		self.runStart=nil 
		
	end
	
	
	if self.missionState==3 then
		local pos = BehaviorFunctions.GetTerrainPositionP("Runaway3",10020001,"Logic202030101")
		BehaviorFunctions.SetPathFollowPos(self.npc,pos)
		BehaviorFunctions.DoSetEntityState(self.npc,FightEnum.EntityState.Move)
		BehaviorFunctions.DoSetMoveType(self.npc,FightEnum.EntityMoveSubState.Run)
		self.finishGuide=BehaviorFunctions.CreateEntity(20600,nil,pos.x,pos.y,pos.z,0,0,0,self.levelId)
		--self.cameraRemove=BehaviorFunctions.GetEntityFrame(self.role)
		self.missionState=4
	end
	
	--if self.cameraRemove
		--and BehaviorFunctions.GetEntityFrame(self.role)-self.cameraRemove>60 then
		--BehaviorFunctions.RemoveEntity(self.levelCam)
		--self.cameraRemove=nil
	--end
	
	
	--if self.missionState==4 then
		--local pos = BehaviorFunctions.GetTerrainPositionP("Runaway2",10020001,"Logic202030101")
		--BehaviorFunctions.SetPathFollowPos(self.npc,pos)
		--self.missionState=5
		
	--end
	
	--if self.missionState==6 then
		--local pos = BehaviorFunctions.GetTerrainPositionP("Runaway3",10020001,"Logic202030101")
		--BehaviorFunctions.SetPathFollowPos(self.npc,pos)
		--self.missionState=7

	--end
	
	if self.missionState==5 then 
		if self.runFrame
			and BehaviorFunctions.GetEntityFrame(self.role)-self.runFrame>2 
			and self.actKey==true then
			BehaviorFunctions.PlayAnimation(self.npc,"Afraid_loop")
			BehaviorFunctions.StartStoryDialog(self.dialogList[8].id)
			self.actKey=false
		end
		
	end 




end
	
	







function LevelBehavior202030601:__delete()

end


function LevelBehavior202030601:StoryPassEvent(dialogId)
	if dialogId==202030702 then
		BehaviorFunctions.RemoveEntity(self.levelCam)
		BehaviorFunctions.SetFightMainNodeVisible(2,"L",true) --大招按钮
		BehaviorFunctions.SetFightMainNodeVisible(2,"O",true) --跳跃按钮
		BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",true)
		BehaviorFunctions.SetFightMainNodeVisible(2,"J",true) --技能按钮
		BehaviorFunctions.SetFightMainNodeVisible(2,"K",true) --技能按钮
		BehaviorFunctions.SetFightMainNodeVisible(2,"I",true) --技能按钮
	end
end


function LevelBehavior202030601:StoryEndEvent(dialogId)

	if dialogId==self.dialogList[8].id then
		BehaviorFunctions.SendTaskProgress(self.taskId,1,1)
		BehaviorFunctions.RemoveLevel(self.levelId)
	
	end
	
	if dialogId==self.dialogList[7].id 
		and BehaviorFunctions.CheckEntity(self.levelCam) then
		
		BehaviorFunctions.RemoveEntity(self.levelCam)
		BehaviorFunctions.SetFightMainNodeVisible(2,"L",true) --大招按钮
		BehaviorFunctions.SetFightMainNodeVisible(2,"O",true) --跳跃按钮
		BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",true)
		BehaviorFunctions.SetFightMainNodeVisible(2,"J",true) --技能按钮
		BehaviorFunctions.SetFightMainNodeVisible(2,"K",true) --技能按钮
		BehaviorFunctions.SetFightMainNodeVisible(2,"I",true) --技能按钮
	end
	
	
end

function LevelBehavior202030601:StoryStartEvent(dialogId)


end

function LevelBehavior202030601:PathFindingEnd(instanceId,result)
	if instanceId==self.npc  then
		--第一次寻路到目的地
		--if self.missionState==3 then
			--if result ==true then
				--BehaviorFunctions.ClearPathFinding(self.npc)
				--self.missionState=4
			--else
				--local pos = BehaviorFunctions.GetTerrainPositionP("Runaway1",10020001,"Logic202030101")
				--BehaviorFunctions.SetPathFollowPos(self.npc,pos)
			--end
		--end
		----第二次寻路到目的地
		--if self.missionState==5 then
			--if result ==true then
				--BehaviorFunctions.ClearPathFinding(self.npc)
				--self.missionState=6
			--else
				--local pos = BehaviorFunctions.GetTerrainPositionP("Runaway2",10020001,"Logic202030101")
				--BehaviorFunctions.SetPathFollowPos(self.npc,pos)
			--end
		--end

		--第三次寻路到目的地
		if self.missionState==4 then
			if result ==true then
				BehaviorFunctions.ClearPathFinding(self.npc)
				BehaviorFunctions.RemoveEntity(self.npc)
				BehaviorFunctions.ShowCommonTitle(5,"追上小偷",false)
				for i = 1,9 do
					if BehaviorFunctions.CheckEntity(self.boxList2[i].id) then
						BehaviorFunctions.RemoveEntity(self.boxList2[i].id)
					end
				end
				BehaviorFunctions.RemoveEntity(self.finishGuide)
				--添加黑幕
				BehaviorFunctions.ShowBlackCurtain(true,0.2)
				self.blackRemove=BehaviorFunctions.GetEntityFrame(self.role)
				local pos = BehaviorFunctions.GetTerrainPositionP("Position_Reset",10020001,"Logic202030101")
				BehaviorFunctions.DoSetPositionP(self.role,pos)
				self.missionState=0
			else
				local pos = BehaviorFunctions.GetTerrainPositionP("Runaway3",10020001,"Logic202030101")
				BehaviorFunctions.SetPathFollowPos(self.npc,pos)
			end

		end
	end
end


function LevelBehavior202030601:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	if hitInstanceId==self.npc 
		and self.missionState==4 then
		BehaviorFunctions.ClearPathFinding(self.npc)
		BehaviorFunctions.StopMove(self.npc)
		self.runFrame=BehaviorFunctions.GetEntityFrame(self.role)
		if BehaviorFunctions.CheckEntity(self.finishGuide) then
			BehaviorFunctions.RemoveEntity(self.finishGuide)
		end
		BehaviorFunctions.ShowCommonTitle(5,"追上小偷",true)
		self.missionState=5
		
	end
	
	
end

