LevelBehavior104040201 = BaseClass("LevelBehavior104040201",LevelBehaviorBase)
--地江野外Boss神荼1

function LevelBehavior104040201:__init(fight)
	self.fight = fight
end


function LevelBehavior104040201.GetGenerates()
	local generates = {92003}
	return generates
end

function LevelBehavior104040201:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.peicongyuEcoId = 3201001010002
	self.bossEntity = 92003	--Boss的EntityId
	self.bossInstanceId = nil -- Boss的InstanceId
	self.missionState = 0
	self.dialogId = {
        102290201, 102290301, 102290401
    }
	self.dialogState = 0
end

function LevelBehavior104040201:LateInit()
	
end

function LevelBehavior104040201:Update()
	--靠近场地中心开始关卡
	if self.missionState == 0 then
		local levelPos = BehaviorFunctions.GetTerrainPositionP("Shentu", 10020001, "MainTask03")
		local role = BehaviorFunctions.GetCtrlEntity()
		local rolePos = BehaviorFunctions.GetPositionP(role)
		local levelDistance = BehaviorFunctions.GetDistanceFromPos(rolePos,levelPos)
		if levelDistance <= 25 then
			self.missionState = 1
		end
	end
	
	
	--召怪，相机
	if self.missionState == 1 then
		--关卡相机
		BehaviorFunctions.SetVCCameraBlend("OperatingCamera","LevelCamera",0)
		--tips目标：击败神荼
		BehaviorFunctions.ShowTip(10404020101)
		--关卡相机看向
		self:LevelLookAtPos("BossBP",22002,45)
		local bossBP = BehaviorFunctions.GetTerrainPositionP("BossBP", 10020001, "MainTask03")
		--创建boss实体
		self.bossInstanceId = BehaviorFunctions.CreateEntity(self.bossEntity,nil,bossBP.x,bossBP.y,bossBP.z,nil,nil,nil,self.levelId)
		--开启空气墙
		BehaviorFunctions.ActiveSceneObj("ShentuAirWall",true,self.levelId)
		--角色看向
		BehaviorFunctions.DoLookAtTargetImmediately(self.bossInstanceId,self.role)
		self.missionState = 10
	--Boss出场走路
	elseif self.missionState == 10 then
		if BehaviorFunctions.CheckEntityState(self.bossInstanceId,FightEnum.EntityState.Born) then
			BehaviorFunctions.CreateEntity(900000104,self.bossInstanceId)
			BehaviorFunctions.DoSetMoveType(self.bossInstanceId,FightEnum.EntityMoveSubState.Walk)
			--BehaviorFunctions.SetEntityValue(1,"LevelUiTarget",self.bossInstanceId)--添加BossUI
			self.missionState = 20
		end
	end
	--timeline判断
	self:ShentuPlayDialog()
end

function LevelBehavior104040201:Death(instanceId,isFormationRevive)
	if isFormationRevive then
		--关闭空气墙
		BehaviorFunctions.ActiveSceneObj("ShentuAirWall",false,self.levelId)
		--移除怪物
		BehaviorFunctions.RemoveEntity(self.bossInstanceId)
		--移除关卡
		BehaviorFunctions.RemoveLevel(self.levelId)		
		BehaviorFunctions.HideTip()
	elseif instanceId == self.bossInstanceId then
		--关闭空气墙
		BehaviorFunctions.ActiveSceneObj("ShentuAirWall",false,self.levelId)
		--展示击败标签
		BehaviorFunctions.ShowCommonTitle(6,"神荼",true)
		--显示配从玉
		BehaviorFunctions.ChangeEcoEntityCreateState(self.peicongyuEcoId,true)
		BehaviorFunctions.AddDelayCallByTime(5,self,self.Assignment,"dialogState",5)
	end
end

function LevelBehavior104040201:AddEntitySign(instanceId,sign)
	--进入神荼2阶段处理
	if instanceId == self.bossInstanceId and sign == 92003018 then
		--神荼传送
		local bossTP = BehaviorFunctions.GetTerrainPositionP("Center", 10020001, "MainTask03")		
		BehaviorFunctions.DoSetPositionP(self.bossInstanceId,bossTP)
		--玩家传送
		local PlayerTP = BehaviorFunctions.GetTerrainPositionP("Phase2pb", 10020001, "MainTask03")
		BehaviorFunctions.InMapTransport(PlayerTP.x,PlayerTP.y,PlayerTP.z,false)
		self:LevelLookAtPos("Center",22002,45)
	end
end

function LevelBehavior104040201:__delete()

end


function LevelBehavior104040201:LevelLookAtPos(pos,type,frame,bindTransform)
	local fp1 = BehaviorFunctions.GetTerrainPositionP(pos, 10020001, "MainTask03")
	local empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z,nil,nil,nil,self.levelId)
	local camera = BehaviorFunctions.CreateEntity(type,nil,nil,nil,nil,nil,nil,nil,self.levelId)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,empty)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(camera,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(camera,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(camera,empty)
	--延迟移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.SetEntityShowState,camera,false)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,empty)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,camera)
end

function LevelBehavior104040201:ShentuPlayDialog()
    --通过血量判断，设置对话状态
	--print(BehaviorFunctions.GetEntityAttrValueRatio(self.bossInstanceId, 1001))
	if self.bossInstanceId and BehaviorFunctions.CheckEntity(self.bossInstanceId) then
		if self.dialogState == 0 and BehaviorFunctions.GetEntityAttrValueRatio(self.bossInstanceId, 1001) < 9999 then
			self.dialogState = 1
		elseif self.dialogState == 2 and BehaviorFunctions.GetEntityAttrValueRatio(self.bossInstanceId, 1001) < 5000 then
			self.dialogState = 3

		end
	end
  
    if self.dialogState == 1 then
        BehaviorFunctions.StartStoryDialog(self.dialogId[1])
		self.dialogState = 2
    elseif self.dialogState == 3 then
        BehaviorFunctions.StartStoryDialog(self.dialogId[2])
		self.dialogState = 4
    elseif self.dialogState == 5 then
        BehaviorFunctions.StartStoryDialog(self.dialogId[3])
		self.dialogState = 6
		BehaviorFunctions.SendTaskProgress(self.levelId,1,1)
		--移除关卡
		BehaviorFunctions.RemoveLevel(self.levelId)
		BehaviorFunctions.HideTip()
    end
end


--赋值
function LevelBehavior104040201:Assignment(variable,value)
	self[variable] = value
end