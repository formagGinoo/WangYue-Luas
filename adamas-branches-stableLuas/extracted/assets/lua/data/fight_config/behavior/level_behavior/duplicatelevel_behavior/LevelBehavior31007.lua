LevelBehavior31007 = BaseClass("LevelBehavior31007",LevelBehaviorBase)
--贝露贝特副本
function LevelBehavior31007:__init(fight)
	self.fight = fight
end


function LevelBehavior31007.GetGenerates()
	local generates = {900040,900050}
	return generates
end


function LevelBehavior31007:Init()
	self.role = 1
	self.missionState = 0
	self.LevelBeha = BehaviorFunctions.CreateBehavior("LevelBehavior",self)
	self.bgmState = 0
	self.monsterCount = 0
end

function LevelBehavior31007:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()

	--if self.bgmState == 0 then
		--BehaviorFunctions.ActiveSceneObj("blbt",true,self.levelId)
		--self.bgmState = 1
	--end
	
	if self.missionState == 0  then
		local pos = BehaviorFunctions.GetTerrainPositionP("C1",10021002)
		self.LevelBeha:PlayerBorn("Born1","C1",10021002)
		self.monster1 = BehaviorFunctions.CreateEntity(900050,nil,pos.x,pos.y,pos.z)
		self.monster2 = BehaviorFunctions.CreateEntity(900040,nil,pos.x-3.4,pos.y,pos.z-5)
		self.monster3 = BehaviorFunctions.CreateEntity(900040,nil,pos.x+0.75,pos.y,pos.z+3.4)
		BehaviorFunctions.DoLookAtTargetImmediately(self.monster1,self.role)
		BehaviorFunctions.DoLookAtTargetImmediately(self.monster2,self.role)
		BehaviorFunctions.DoLookAtTargetImmediately(self.monster3,self.role)
		
		--为中立怪添加Boss血条标签
		BehaviorFunctions.AddEntitySign(1,10000020,-1,false)
		self.missionState = 1
	end
	
	if self.missionState == 2 and self.time - self.timeStart == 90 then
		local pos = BehaviorFunctions.GetTerrainPositionP("C1",10021002)
		self.monster1 = BehaviorFunctions.CreateEntity(900050,nil,pos.x,pos.y,pos.z)
		self.monster2 = BehaviorFunctions.CreateEntity(900040,nil,pos.x-3.4,pos.y,pos.z-5)
		self.monster3 = BehaviorFunctions.CreateEntity(900040,nil,pos.x+0.75,pos.y,pos.z+3.4)
		BehaviorFunctions.DoLookAtTargetImmediately(self.monster1,self.role)
		BehaviorFunctions.DoLookAtTargetImmediately(self.monster2,self.role)
		BehaviorFunctions.DoLookAtTargetImmediately(self.monster3,self.role)
		self.missionState = 1
	end
end

--死亡事件
function LevelBehavior31007:Death(instanceId,isFormationRevive)
	if instanceId == self.monster1
	or instanceId == self.monster2 
	or instanceId == self.monster3 then		
		self.monsterCount = self.monsterCount + 1
		if self.monsterCount == 3 then
			self.monsterCount = 0
			self.missionState = 2
			self.timeStart = BehaviorFunctions.GetFightFrame()
		end
		
	elseif isFormationRevive then

		BehaviorFunctions.OpenWorldFailWindow(true)
		--BehaviorFunctions.SetDuplicateResult(false)
		BehaviorFunctions.ActiveSceneObj("blbt",false,self.levelId)
	end
end


function LevelBehavior31007:__delete()

end
