LevelBehavior31001 = BaseClass("LevelBehavior31001",LevelBehaviorBase)
--任务3：TaskBehavior200100103，完成挑战
function LevelBehavior31001:__init(fight)
	self.fight = fight
end


function LevelBehavior31001.GetGenerates()
	local generates = {900020}
	return generates
end


function LevelBehavior31001:Init()
	self.missionState = 0
	self.time = 0
	self.lasttime = 13
	self.count = 0

end

function LevelBehavior31001:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetFightFrame()/30
	self.pos = BehaviorFunctions.GetPositionP(self.role)
	BehaviorFunctions.SetFightMainNodeVisible(2,"Guide",false)
	if self.missionState == 0  then
		self.epos = BehaviorFunctions.GetTerrainPositionP("e1",10021001)
		BehaviorFunctions.ShowTip(3001001)
		BehaviorFunctions.ShowTip(3001005,self.lasttime)
		BehaviorFunctions.SetGuide(1004,self.epos.x,self.epos.y,self.epos.z)
		self.guide = BehaviorFunctions.CreateEntity(900000102,nil,self.epos.x,self.epos.y,self.epos.z)
		self.timeStart = self.time
		BehaviorFunctions.ActiveSceneObj("Effect",true,10021001)
		self.missionState = 1
	end
	if self.missionState == 1 and BehaviorFunctions.GetDistanceFromPos(self.pos,self.epos)< 3 then
		BehaviorFunctions.ShowTip(3001002)
		BehaviorFunctions.SendGmExec("task_finish", {"200100102"})
		BehaviorFunctions.CancelGuide()
		BehaviorFunctions.RemoveEntity(self.guide)
		BehaviorFunctions.SetDuplicateResult(true)
		BehaviorFunctions.ActiveSceneObj("Effect",false,10021001)
		self.missionState = 999
	end
	if self.missionState == 1 and self.lasttime > 0 then
		if self.count == 0 and self.time - self.timeStart >= 1 then
			self.lasttime = self.lasttime - 1
			BehaviorFunctions.ShowTip(3001005,self.lasttime)
			self.timeStart = self.time
			self.count = 1
		end
		if self.count == 1 and self.time - self.timeStart >= 1 then
			self.lasttime = self.lasttime - 1
			BehaviorFunctions.ShowTip(3001005,self.lasttime)
			self.timeStart = self.time
			self.count = 0		
		end
	elseif self.lasttime == 0 then
		BehaviorFunctions.ShowTip(3001003)
		BehaviorFunctions.CancelGuide()
		BehaviorFunctions.RemoveEntity(self.guide)
		BehaviorFunctions.SetDuplicateResult(false)
		BehaviorFunctions.ActiveSceneObj("Effect",false,10021001)
	end
end



function LevelBehavior31001:__delete()

end