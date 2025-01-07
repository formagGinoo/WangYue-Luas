DebugPlanInvoke = {}
DebugPlanInvoke.NotClear = true

function DebugPlanInvoke.SetCache(cache)
	DebugPlanInvoke.Cache = cache
end

function DebugPlanInvoke.TransferToGetSword()
	local targetPos = BehaviorFunctions.GetTerrainPositionP("tp_Sword",10020001,"Logic10020001_6")
	BehaviorFunctions.Transport(10020001,targetPos.x,targetPos.y,targetPos.z)
end

function DebugPlanInvoke.TransferToBaXi()
	local targetPos = BehaviorFunctions.GetTerrainPositionP("checkPoint13",10020001,"Logic10020001_6")
	BehaviorFunctions.Transport(10020001,targetPos.x,targetPos.y,targetPos.z)
end

function DebugPlanInvoke.TransferToWatchWorld()
	BehaviorFunctions.Transport(10020001,602,172,1073.5)
end

function DebugPlanInvoke.TransferToSmallBell()
	BehaviorFunctions.Transport(10020001,585.090027,139.399994,1134.87)
end

function DebugPlanInvoke.TransferToXiLaiCity()
	BehaviorFunctions.Transport(10020001,405.700012,61.0699997,1692.40002)
end

function DebugPlanInvoke.TransferToStrongHold()
	BehaviorFunctions.Transport(10020001,373.282959,114.080002,1434.2052)
end

function DebugPlanInvoke.TransferToShenTu()
	BehaviorFunctions.Transport(10020001,533.321045,104.739998,2190.2124)
end

function DebugPlanInvoke.TransferToCoffee()
	BehaviorFunctions.Transport(10020004,1373.94067,100.93,1419.81335)
end

function DebugPlanInvoke.TransferToStreet()
	BehaviorFunctions.Transport(10020004,1241.88928,89.9800034,1350.2019)
end

function DebugPlanInvoke.TransferToSquare()
	BehaviorFunctions.Transport(10020004,1583.84241,103.589996,1319.11536)
end

function DebugPlanInvoke.TransferToTiantai()
	BehaviorFunctions.Transport(10020004,1152.92004,113.68,1448.62)
end

function DebugPlanInvoke.TransferToLigeBoss()
	BehaviorFunctions.Transport(500100001,252.86,2.151,130.8)
end

function DebugPlanInvoke.TransferToLigePv()
	BehaviorFunctions.Transport(500100001,252.86,2.151,130.8)
end

function DebugPlanInvoke.TransferToshengmingzhihuan()
	BehaviorFunctions.Transport(500100002,410.9827,57.29739,454.96)
end

function DebugPlanInvoke.TransferToGasStation()
	BehaviorFunctions.Transport(10020001,530.9,60.0,1382.9)
end

function DebugPlanInvoke.TransferToSkyIsland()
	BehaviorFunctions.Transport(10020001,728.400024,232.529999,1622.69995)
end

function DebugPlanInvoke.TransferToTestpoint()
	BehaviorFunctions.Transport(10020005,1373.77795,115.192856,865.633179)
end

function DebugPlanInvoke.TransferToRoofTop()
	BehaviorFunctions.Transport(10020005,724.37,355.57,259.73)
end

function DebugPlanInvoke.TransferToYueLingCenter()
	BehaviorFunctions.Transport(1002000301,100,6.5,100)
end

function DebugPlanInvoke.TransferToTaskDup1()
	BehaviorFunctions.CreateDuplicate(3101)
end

function DebugPlanInvoke.TransferToTaskDup2()
	local targetPos = BehaviorFunctions.GetTerrainPositionP("Dup01",10020001,"Logic10020001_Eco1")
	BehaviorFunctions.Transport(10020001,targetPos.x,targetPos.y,targetPos.z)
end

function DebugPlanInvoke.TransferToTaskDup3()
	local targetPos = BehaviorFunctions.GetTerrainPositionP("ShentuBossPos1",10020001,"World00207")
	BehaviorFunctions.Transport(10020001,targetPos.x,targetPos.y,targetPos.z)
end

function DebugPlanInvoke.TransferToPVTFK()
	BehaviorFunctions.Transport(10020004,1289.57727,100.540001,1325.52466)
end

function DebugPlanInvoke.CreateEntity(id,inputpos,entityLev)
	if id =="" then
		return
	end
	local newId = tonumber(id)
	if not newId  then
		return
	end
	
	local entityLevel = nil
	if tonumber(entityLev) then
		entityLevel = tonumber(entityLev)
	end
	
	BehaviorFunctions.fight.levelManager:GMChangeBehaviorMonsterId(newId)
	local dis = 5
	local monsterPos = {}
	local role = BehaviorFunctions.GetCtrlEntity()	
	local pos = string.gsub(inputpos, "Vector3", "")
	local monster = nil
	for number in string.gmatch(pos, "%d+%.?%d*") do
		table.insert(monsterPos,number)
	end
	if #monsterPos == 3 then
		if not entityLevel then
			monster = BehaviorFunctions.CreateNoPreLoadEntity(newId,nil,monsterPos[1],monsterPos[2],monsterPos[3])
		else
			monster = BehaviorFunctions.CreateNoPreLoadEntity(newId,nil,monsterPos[1],monsterPos[2],monsterPos[3],nil,nil,nil,nil,entityLevel)
		end
		
	else
		monsterPos = BehaviorFunctions.GetPositionOffsetBySelf(role,dis,0)
		if not entityLevel then
			monster = BehaviorFunctions.CreateNoPreLoadEntity(newId,nil,monsterPos.x,monsterPos.y,monsterPos.z)
		else
			monster = BehaviorFunctions.CreateNoPreLoadEntity(newId,nil,monsterPos.x,monsterPos.y,monsterPos.z,nil,nil,nil,nil,entityLevel)
		end
	end
end

function DebugPlanInvoke.Transport(mapid,inputpos)
	if mapid =="" then
		return
	end
	local newId = tonumber(mapid)
	if not newId  then
		local role = BehaviorFunctions.GetCtrlEntity()
		mapid = Fight.Instance:GetFightMap(role)
	end
	local transPos = {}
	local pos = string.gsub(inputpos, "Vector3", "")
	for number in string.gmatch(pos, "%d+%.?%d*") do
		table.insert(transPos,number)
	end
	for i = 1, #transPos do
		transPos[i] = tonumber(transPos[i])
	end
	if #transPos == 3 then
		BehaviorFunctions.Transport(mapid,transPos[1],transPos[2],transPos[3])
	end
end

function DebugPlanInvoke.SkipAllTask()
	mod.GmFacade:SendMsg("gm_exec", "task_accept", {"101130901"})
end

function DebugPlanInvoke:GMSetMonsterId(id)
	if id ~= self.createId then
		self.createId = id
	end
end

function DebugPlanInvoke:MuteBgm()
	BehaviorFunctions.SetActiveBGM("FALSE")
	BehaviorFunctions.StopBgmSound()
end

function DebugPlanInvoke:ActiveBgm()
	BehaviorFunctions.SetActiveBGM("TRUE")
end

function DebugPlanInvoke:ActiveRenderFrame()
	DebugConfig.UseRenderFrame = true
end

function DebugPlanInvoke:DeactiveRenderFrame()
	DebugConfig.UseRenderFrame = false
end

function DebugPlanInvoke:ActiveNpcAiLOD()
	DebugConfig.NpcAiLOD = true
end

function DebugPlanInvoke:DeactiveNpcAiLOD()
	DebugConfig.NpcAiLOD = false
end

function DebugPlanInvoke:SlowCameraSpeed()
	local lockingPOV = CameraManager.Instance.states[FightEnum.CameraState.Operating].lockingPOV
	local axisH = lockingPOV.m_HorizontalAxis
	axisH.m_MaxSpeed = 0.02
	axisH.m_AccelTime = 0.2
	axisH.m_DecelTime = 0.2
	lockingPOV.m_HorizontalAxis = axisH
	
	local axisV = lockingPOV.m_VerticalAxis
	axisV.m_MaxSpeed = 0.02
	axisV.m_AccelTime = 0.2
	axisV.m_DecelTime = 0.2
	lockingPOV.m_VerticalAxis = axisV
end


function DebugPlanInvoke:GamePause()
	BehaviorFunctions.Pause()
end


function DebugPlanInvoke:GameResume()
	BehaviorFunctions.Resume()
end


function DebugPlanInvoke:ClimbAble()
	BehaviorFunctions.SetClimbEnable(true)
end

function DebugPlanInvoke:PrintBgmState()
	BehaviorFunctions.PrintBgmState()
end

function DebugPlanInvoke.LoadLogicPosition()
	if not DebugConfig.ShowLevelLogic then
		return
	end

	if DebugPlanInvoke.Cache.LogicPosition and next(DebugPlanInvoke.Cache.LogicPosition) then
		return
	end

	DebugPlanInvoke.Cache.LogicPosition = {}
	local curMap = Fight.Instance:GetFightMap()
	local mapPositions = MapPositionConfig.GetMapPositionData(curMap)
	if not mapPositions or not next(mapPositions) then
		return
	end

	for k, v in pairs(mapPositions) do
		for name, pos in pairs(v) do
			local gameObject = Fight.Instance.clientFight.assetsPool:Get("CommonEntity/ShowPosition.prefab", true)
			gameObject.transform.localScale = Vec3.New(1, 1, 1)
			gameObject.transform.position = Vec3.New(pos.x, pos.y, pos.z)
			gameObject.transform.rotation = Quat.New(pos.rotX, pos.rotY, pos.rotZ, pos.rotW)
			local tmp = gameObject.transform:Find("Info"):GetComponent(TextMeshPro)
			if not UtilsBase.IsNull(tmp) then
				tmp.text = string.format("%s\n%s", k, name)
			end

			table.insert(DebugPlanInvoke.Cache.LogicPosition, gameObject)
		end
	end
end

function DebugPlanInvoke.UnLoadLogicPosition()
	if not DebugConfig.ShowLevelLogic then
		return
	end

	if not DebugPlanInvoke.Cache.LogicPosition or not next(DebugPlanInvoke.Cache.LogicPosition) then
		return
	end

	for i = #DebugPlanInvoke.Cache.LogicPosition, 1, -1 do
		Fight.Instance.clientFight.assetsPool:Cache("CommonEntity/ShowPosition.prefab", DebugPlanInvoke.Cache.LogicPosition[i])
		DebugPlanInvoke.Cache.LogicPosition[i] = nil
	end
end