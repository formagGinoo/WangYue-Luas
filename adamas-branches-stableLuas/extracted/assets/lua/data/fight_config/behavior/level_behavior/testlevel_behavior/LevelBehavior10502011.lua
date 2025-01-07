--主线第5章

LevelBehavior10502011 = BaseClass("LevelBehavior10502011",LevelBehaviorBase)
--fight初始化
function LevelBehavior10502011:__init(fight)
	self.fight = fight
end

--预加载
function LevelBehavior10502011.GetGenerates()
	local generates = {900120,900130,910040}
	return generates
end
function LevelBehavior10502011.GetMagics()
	local generates = {}
	return generates
end
--UI预加载
function LevelBehavior10502011.GetUIGenerates()
	local generates = {
		FightEnum.PreLoadUI.RemoteDialog,--带头像的剧情对话框UI
		FightEnum.PreLoadUI.FightTalkDialog,--纯文字的剧情对话框UI
		FightEnum.PreLoadUI.GuideMask,--教学引导UI
		FightEnum.PreLoadUI.FightTips--中间横幅和底部横幅
	}
	return generates
end

--参数初始化
function LevelBehavior10502011:Init()
	self.missionState = 0   --关卡流程
	self.createId  = 900120
	self.createId2 = 910040
	self.createId3 = 900130
	self.wavestate1 = 0
	self.wavestate2 = 0
	self.player = nil
end


function LevelBehavior10502011:Update()
	
	self.player = BehaviorFunctions.GetCtrlEntity()
	self:checkwave()
	
	
end

--死亡事件
function LevelBehavior10502011:RemoveEntity(instanceId)
	--第一波怪死掉
	if instanceId == self.monster1 or instanceId == self.monster2 or instanceId == self.monster3  then
		self.wavestate1 = self.wavestate1 + 1
	end
	
	--第二波怪死掉
	if instanceId == self.monster4 or instanceId == self.monster5 or instanceId == self.monster6  then
		self.wavestate2 = self.wavestate2 + 1
	end
		
end

function LevelBehavior10502011:checkwave()
	
	--创第一波怪
	if self.missionState == 0 then
		--BehaviorFunctions.CreateEntity(self.createId,nil,self.pos2.x,self.pos2.y,self.pos2.z)
		self.monster1 = BehaviorFunctions.CreateEntityByPosition(self.createId, nil, "strikemonsterpos1", "Task_Main_52", 10502011, self.levelId, nil)
		self.monster2 = BehaviorFunctions.CreateEntityByPosition(self.createId, nil, "strikemonsterpos2", "Task_Main_52", 10502011, self.levelId, nil)
		self.monster3 = BehaviorFunctions.CreateEntityByPosition(self.createId, nil, "strikemonsterpos3", "Task_Main_52", 10502011, self.levelId, nil)
		
		local pos1 = BehaviorFunctions.GetPositionP(self.monster1)
		local pos2 = BehaviorFunctions.GetPositionP(self.player)				
		
		if BehaviorFunctions.GetDistanceFromPos(pos1,pos2) <= 20 then
			--设置怪物进入战斗
			BehaviorFunctions.SetEntityValue(self.monster1,"haveWarn",false)
			BehaviorFunctions.SetEntityValue(self.monster2,"haveWarn",false)
			BehaviorFunctions.SetEntityValue(self.monster3,"haveWarn",false)
			BehaviorFunctions.CastSkillBySelfPosition(self.monster1,90012006,self.player)
				--设置关卡相机
				if BehaviorFunctions.GetDistanceFromPos(pos1,pos2) >= 3 then
					self:LevelLookAtPos("strikemonsterpos1","Task_Main_52",22002)
					BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
					BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
				end
		end
		
		self.missionState = 1
	end
	
	--创第二波怪物
	if self.wavestate1 >= 3 and self.missionState == 1 then
							
		self.monster4 = BehaviorFunctions.CreateEntityByPosition(self.createId2, nil, "strikemonsterpos4", "Task_Main_52", 10502011, self.levelId, nil)
		self.monster5 = BehaviorFunctions.CreateEntityByPosition(self.createId3, nil, "strikemonsterpos5", "Task_Main_52", 10502011, self.levelId, nil)
		self.monster6 = BehaviorFunctions.CreateEntityByPosition(self.createId3, nil, "strikemonsterpos6", "Task_Main_52", 10502011, self.levelId, nil)
		
		local pos1 = BehaviorFunctions.GetPositionP(self.monster4)
		local pos2 = BehaviorFunctions.GetPositionP(self.player)									
		
		if BehaviorFunctions.GetDistanceFromPos(pos1,pos2) <= 20 then
			--设置怪物进入战斗
			BehaviorFunctions.SetEntityValue(self.monster4,"haveWarn",false)
			BehaviorFunctions.SetEntityValue(self.monster5,"haveWarn",false)
			BehaviorFunctions.SetEntityValue(self.monster6,"haveWarn",false)
			BehaviorFunctions.CastSkillBySelfPosition(self.monster4,91004092)
			
			if BehaviorFunctions.GetDistanceFromPos(pos1,pos2) >= 3 then
				self:LevelLookAtPos("strikemonsterlookpos2","Task_Main_52",22002)
				BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
				BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
			end
		end
		
		
		self.missionState = 2
	end
	
	--第二波怪物死光完成关卡
	if self.wavestate2 >= 3 and self.missionState == 2 then
		BehaviorFunctions.FinishLevel(self.levelId)
	end
	
end

function LevelBehavior10502011:LevelLookAtPos(pos,logic,type,bindTransform)
	local fp1 = BehaviorFunctions.GetTerrainPositionP(pos,self.levelId,logic)
	self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
	self.levelCam = BehaviorFunctions.CreateEntity(type)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.player,self.empty)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.player,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.player)
	end
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
end



--function LevelBehavior10502011:SetFightTarget(instanceId,TargetinstanceId)
	
	----BehaviorFunctions.SetEntityValue(self.MonsterCommonParam.me,"beAssassin",self.beAssassin)
	
	--BehaviorFunctions.SetEntityValue(instanceId,"battleTarget",TargetinstanceId)
--end