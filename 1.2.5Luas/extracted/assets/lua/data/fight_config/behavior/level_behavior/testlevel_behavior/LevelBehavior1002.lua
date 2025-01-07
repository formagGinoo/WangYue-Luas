LevelBehavior1002 = BaseClass("LevelBehavior1002",LevelBehaviorBase)
--贝露贝特测试关1
function LevelBehavior1002:__init(fight)
	self.fight = fight
end


function LevelBehavior1002.GetGenerates()
	local generates = {92001}
	return generates
end


function LevelBehavior1002:Init()
    
	self.missionState = 0   
end

function LevelBehavior1002:Update()
	self.time = BehaviorFunctions.GetFightFrame()/30
	self.role = BehaviorFunctions.GetCtrlEntity()
	if not BehaviorFunctions.HasEntitySign(self.role,10000007) then
		BehaviorFunctions.AddEntitySign(self.role,10000007,-1)
	end
	if  self.missionState == 0 and BehaviorFunctions.CanCtrl(self.role) then
		local role = BehaviorFunctions.GetTerrainPositionP("born1")
		local blbt = BehaviorFunctions.GetTerrainPositionP("blbt")
		--BehaviorFunctions.ActiveSceneObj("blbtbgm",true)
		--BehaviorFunctions.DoSetPosition(self.role,role.x,role.y,role.z) 
		BehaviorFunctions.SetPlayerBorn(role.x,role.y,role.z)	--设置角色出生点  
		self.Monster = BehaviorFunctions.CreateEntity(92001,nil,blbt.x,blbt.y,blbt.z,role.x,nil,role.z)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.Monster)
		BehaviorFunctions.InitCameraAngle(0)
		BehaviorFunctions.DoMagic(self.role,self.role,200000002)
		--BehaviorFunctions.ActiveSceneObj("po_cam",true)
		--BehaviorFunctions.SetSceneCameraLock("po_cam",self.Monster)
		self.missionState = 5
	end
	if self.missionState == 30 and self.time - self.timeStart >=1 then
		local canshu = 3
		BehaviorFunctions.ShowTip(1106,canshu)
		self.timeStart =self.time
		self.missionState = 31
	end
	if self.missionState == 31 and self.time - self.timeStart >=1 then
		local canshu = 2
		BehaviorFunctions.ShowTip(1106,canshu)
		self.timeStart =self.time
		self.missionState = 32
	end
	if self.missionState == 32 and self.time - self.timeStart >=1 then
		local canshu = 1
		BehaviorFunctions.ShowTip(1106,canshu)
		self.timeStart =self.time
		self.missionState = 33
	end
	if self.missionState == 33 and self.time - self.timeStart >=1 then
		BehaviorFunctions.SetFightResult(true)
		self.missionState = 999
	end
end

function LevelBehavior1002:Death(instanceId)
	if instanceId == self.role then
        BehaviorFunctions.SetFightResult(false)
	end
	if instanceId == self.Monster then
		self.missionState = 30
		self.timeStart = self.time
	end
end

function LevelBehavior1002:__delete()

end