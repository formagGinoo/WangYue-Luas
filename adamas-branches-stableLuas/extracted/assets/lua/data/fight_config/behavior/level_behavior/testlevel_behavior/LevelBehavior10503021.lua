--主线第5章

LevelBehavior10503021 = BaseClass("LevelBehavior10503021",LevelBehaviorBase)
--fight初始化
function LevelBehavior10503021:__init(fight)
	self.fight = fight
end

--预加载
function LevelBehavior10503021.GetGenerates()
	local generates = {2030501}
	return generates
end
function LevelBehavior10503021.GetMagics()
	local generates = {}
	return generates
end
--UI预加载
function LevelBehavior10503021.GetUIGenerates()
	local generates = {
		FightEnum.PreLoadUI.RemoteDialog,--带头像的剧情对话框UI
		FightEnum.PreLoadUI.FightTalkDialog,--纯文字的剧情对话框UI
		FightEnum.PreLoadUI.GuideMask,--教学引导UI
		FightEnum.PreLoadUI.FightTips--中间横幅和底部横幅
	}
	return generates
end

--参数初始化
function LevelBehavior10503021:Init()
	self.missionState = 0   --关卡流程
	self.createId = 2030501
	self.PlayerRestart = BehaviorFunctions.GetTerrainPositionP("PlayerRestart",10503021,"Task_Main_53")
end

--帧事件
function LevelBehavior10503021:Update()
	
	self.player = BehaviorFunctions.GetCtrlEntity()
	
	if self.missionState == 0 then
		--BehaviorFunctions.CreateEntity(self.createId,nil,self.pos2.x,self.pos2.y,self.pos2.z)
		self.Case1 = BehaviorFunctions.CreateEntityByPosition(self.createId, nil, "PlayerRestart", "Task_Main_53", 10503021, self.levelId, nil)
		self.Case1InitialPos = BehaviorFunctions.GetPositionP(self.Case1)
		BehaviorFunctions.AddBuff(self.Case1,self.Case1,200001150)
		BehaviorFunctions.AddEntityGuidePointer(self.Case1,4,2,false)
		
		self.missionState = 1
	end
	
	if self.Case1 then
		self:DistanceEtoP()
		self:CheckCaseState()
	end
	
end

--检测货物状态	
function LevelBehavior10503021:CheckCaseState()
		--如果距离终点很近，完成任务
		--if self.CToTdis <= 2 and self.missionState == 1 then
			----BehaviorFunctions.SendTaskProgress(1050301, 5, 1)
			--BehaviorFunctions.StopHackingMode()
			--self.missionState = 2
			--BehaviorFunctions.FinishLevel(10503021)
		--end

		--如果离开任务Area，将人和货物传送回去
		--if self.Case1 and self.missionState == 1 then
			--if not BehaviorFunctions.CheckEntityInArea(self.Case1,"area1","Task_Main_53") then
				--BehaviorFunctions.StopHackingMode()
				--local p = BehaviorFunctions.GetTerrainPositionP("PlayerRestart",10503021,"Task_Main_53")
				--BehaviorFunctions.TransportByInstanceId(self.Case1,p.x,p.y,p.z,0)	
			
			
			
				--BehaviorFunctions.InMapTransport(self.PlayerRestart.x, self.PlayerRestart.y, self.PlayerRestart.z, false)
	
			--end
		--end 
end
	
	
function LevelBehavior10503021:ExitArea(triggerInstanceId, areaName, logicName)
		
	if triggerInstanceId == self.Case1 and areaName == "area1" then
		BehaviorFunctions.StopHackingMode()
		local p = BehaviorFunctions.GetTerrainPositionP("PlayerRestart",10503021,"Task_Main_53")
		
		BehaviorFunctions.InMapTransport(self.PlayerRestart.x, self.PlayerRestart.y, self.PlayerRestart.z, false)
		
		BehaviorFunctions.TransportByInstanceId(self.Case1,475,57,1479,5)
	end
	
	
end	
--Vector3(479.982361,57.8648605,1471.38245)

--BehaviorFunctions.TransportByInstanceId(40,479,57,1487,0)

	
--检测货物距离目标距离
function LevelBehavior10503021:DistanceEtoP()
	
	self.Case1pos = BehaviorFunctions.GetPositionP(self.Case1)
	self.Targetpos = BehaviorFunctions.GetTerrainPositionP("xilaigate",10503021,"Task_Main_53")
	self.CToTdis = BehaviorFunctions.GetDistanceFromPos(self.Case1pos,self.Targetpos)
	
		
end	

function LevelBehavior10503021:ExitHacking()
	if self.CToTdis <= 5 then
		BehaviorFunctions.RemoveBuff(self.Case1,200001150)
		BehaviorFunctions.FinishLevel(10503021)
		self.missionState = 2
	end
end