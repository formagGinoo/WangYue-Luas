LevelBehavior300201 = BaseClass("LevelBehavior300201",LevelBehaviorBase)
--地江野外Boss神荼1
function LevelBehavior300201:__init(fight)
	self.fight = fight
end


function LevelBehavior300201.GetGenerates()
	local generates = {92003}
	return generates
end


function LevelBehavior300201:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.bossEntity = 92003	--Boss的EntityId
	self.bossInstanceId = nil -- Boss的InstanceId
	self.missionState = 0
end

function LevelBehavior300201:Update()
	
	if self.missionState == 0 then
		BehaviorFunctions.SetVCCameraBlend("OperatingCamera","LevelCamera",0)
		--tips目标：击败神荼
		BehaviorFunctions.ShowTip(30020101)
		self:LevelLookAtPos("BossBP",22002,45)
		local bossBP = BehaviorFunctions.GetTerrainPositionP("BossBP",self.levelId)
		self.bossInstanceId = BehaviorFunctions.CreateEntity(self.bossEntity,nil,bossBP.x,bossBP.y,bossBP.z,nil,nil,nil,self.levelId)
		--开启空气墙
		BehaviorFunctions.ActiveSceneObj("ShentuAirWall",true,self.levelId)
		BehaviorFunctions.DoLookAtTargetImmediately(self.bossInstanceId,self.role)
		self.missionState = 1
	
	elseif self.missionState == 1 then
		if BehaviorFunctions.CheckEntityState(self.bossInstanceId,FightEnum.EntityState.Born) then
			BehaviorFunctions.CreateEntity(900000104,self.bossInstanceId)
			BehaviorFunctions.DoSetMoveType(self.bossInstanceId,FightEnum.EntityMoveSubState.Walk)
			BehaviorFunctions.SetEntityValue(1,"LevelUiTarget",self.bossInstanceId)--添加BossUI
			self.missionState = 2
		end
		
	elseif self.missionState == 2 then

	end
end

function LevelBehavior300201:Death(instanceId,isFormationRevive)
	if isFormationRevive then
		--关闭空气墙
		BehaviorFunctions.ActiveSceneObj("ShentuAirWall",false,self.levelId)
		--移除怪物
		BehaviorFunctions.RemoveEntity(self.bossInstanceId)
		--移除关卡
		--BehaviorFunctions.RemoveLevel(self.levelId)		
		BehaviorFunctions.HideTip()
		--local instanceId = BehaviorFunctions.GetEcoEntityByEcoId(2001002079001)
		--BehaviorFunctions.SetEntityValue(instanceId,"levelResult",false)
	elseif instanceId == self.bossInstanceId then
		--关闭空气墙
		BehaviorFunctions.ActiveSceneObj("ShentuAirWall",false,self.levelId)
		----移除关卡
		--BehaviorFunctions.RemoveLevel(self.levelId)
		BehaviorFunctions.HideTip()
		--展示击败标签
		BehaviorFunctions.ShowCommonTitle(6,"神荼",true)
		--local instanceId = BehaviorFunctions.GetEcoEntityByEcoId(2001002079001)
		--BehaviorFunctions.SetEntityValue(instanceId,"levelResult",true)
		
		BehaviorFunctions.SetDuplicateResult(true)
		BehaviorFunctions.ExitDuplicate()
	end
end

function LevelBehavior300201:AddEntitySign(instanceId,sign)
	--进入神荼2阶段处理
	if instanceId == self.bossInstanceId and sign == 92003018 then
		--神荼传送
		local bossTP = BehaviorFunctions.GetTerrainPositionP("Center",self.levelId)		
		BehaviorFunctions.DoSetPositionP(self.bossInstanceId,bossTP)
		--玩家传送
		local PlayerTP = BehaviorFunctions.GetTerrainPositionP("Phase2pb",self.levelId)
		BehaviorFunctions.InMapTransport(PlayerTP.x,PlayerTP.y,PlayerTP.z,false)
		self:LevelLookAtPos("Center",22002,45)
	end
end

function LevelBehavior300201:__delete()

end


function LevelBehavior300201:LevelLookAtPos(pos,type,frame,bindTransform)
	local fp1 = BehaviorFunctions.GetTerrainPositionP(pos,self.levelId)
	local empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z,nil,nil,nil,self.levelId)
	local camera = BehaviorFunctions.CreateEntity(type,nil,fp1.x,fp1.y,fp1.z,nil,nil,nil,self.levelId)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,empty)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(camera,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(camera,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(camera,empty)
	--延迟移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,empty)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,camera)
end
