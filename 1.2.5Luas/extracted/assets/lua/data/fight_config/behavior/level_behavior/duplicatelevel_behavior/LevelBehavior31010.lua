LevelBehavior31010 = BaseClass("LevelBehavior31010",LevelBehaviorBase)
--动态创建关卡1
function LevelBehavior31010:__init(fight)
	self.fight = fight
end


function LevelBehavior31010.GetGenerates()
	local generates = {92003,92001,900040,900042,900050,92002,910040,900041,900051,900070}
	return generates
end

--function LevelBehavior31010.GetStorys()
	--local story = {92003018}
	--return story
--end


function LevelBehavior31010:Init()
	self.role = 1
	self.missionState = 0
	self.audiotime = 0
	self.QTEState = 0
	self.story = 0
	self.storyFrame = 90
	self.timelineFrame = 0
	self.startMission = 0
	self.endMission = 0
end

function LevelBehavior31010:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.life = BehaviorFunctions.CheckEntity(92003)
	--if not BehaviorFunctions.HasEntitySign(self.role,10000007) then
	--BehaviorFunctions.AddEntitySign(self.role,10000007,-1)
	--end
	
	self.SkillId = BehaviorFunctions.GetSkill(self.role)
	
	
	if self.QTEState == 1 then
		BehaviorFunctions.SetFightMainNodeVisible(2, "NormalButton", true)
		self.QTEState = 0 
	end

	--if  self.storyFrame < self.time then
		--BehaviorFunctions.DoMagic(self.monster1,self.monster1,92003020)
		--BehaviorFunctions.DoMagic(self.monster1,self.monster1,92003018)
		--BehaviorFunctions.DoMagic(self.monster1,self.monster1,92003019)
		--BehaviorFunctions.DoMagic(self.monster1,self.role,92003019)
		----self.story = 1
		--self.storyFrame = self.time + 900
	--end

	
	if self.missionState == 0  then
		
		
		--BehaviorFunctions.PlayBgmSound("Test_Event")
		local pos = BehaviorFunctions.GetTerrainPositionP("enemyBorn",20010004)
		local bornPos = BehaviorFunctions.GetTerrainPositionP("characterBorn",20010004)
		BehaviorFunctions.DoSetPositionP(self.role,bornPos)
		--self.monster1 = BehaviorFunctions.CreateEntity(900040,nil,pos.x+1,pos.y,pos.z)
		--self.monster1 = BehaviorFunctions.CreateEntity(910025,nil,pos.x+4,pos.y,pos.z)
		self.monster2 = BehaviorFunctions.CreateEntity(92003,nil,pos.x+2,pos.y,pos.z)
		--self.monster2 = BehaviorFunctions.CreateEntity(900020,nil,pos.x+4,pos.y,pos.z)
		--self.monster2 = BehaviorFunctions.CreateEntity(900041,nil,pos.x+6,pos.y,pos.z)
		--self.monster2 = BehaviorFunctions.CreateEntity(900050,nil,pos.x+6,pos.y,pos.z)
		--self.monster3 = BehaviorFunctions.CreateEntity(910040,nil,pos.x+8,pos.y,pos.z)
		

		--self.monster3 = BehaviorFunctions.CreateEntity(900050,nil,pos.x+3,pos.y,pos.z)
		--BehaviorFunctions.DoMagic(1,1,900000030)
		
		--self.monster2 = BehaviorFunctions.CreateEntity(92001,nil,pos.x+4,pos.y,pos.z)
		
		--self.monster1 = BehaviorFunctions.CreateEntity(2000108,nil,pos.x+1,pos.y,pos.z)
		--BehaviorFunctions.DoMagic(1,self.monster1,900000007)
		--BehaviorFunctions.DoMagic(1,self.monster3,900000007)
		--BehaviorFunctions.DoMagic(1,self.monster2,900000007)
		
		--if self.SkillId == 1001030 or self.SkillId == 1001031 then
			--BehaviorFunctions.DoShowSwitchQTE(self.role,15)
		--end
		--BehaviorFunctions.DoMagic(1,self.monster3,900000007)
		--self.monster1 = BehaviorFunctions.CreateEntity(1999,nil,pos.x+1,pos.y,pos.z)
		--self.monster2 = BehaviorFunctions.CreateEntity(2000108,nil,pos.x-1,pos.y,pos.z)
		--self.monster3 = BehaviorFunctions.CreateEntity(2000108,nil,pos.x,pos.y,pos.z+1)
		--self.monster4 = BehaviorFunctions.CreateEntity(2000108,nil,pos.x,pos.y,pos.z-1)
		self.missionState = 1
	end
	--if self.audiotime == 0 then
		--if BehaviorFunctions.GetSubMoveState(self.role) == FightEnum.EntityMoveSubState.Run then
			--BehaviorFunctions.DoEntityAudioPlay(self.monster1,"Test_Event",false)
			--self.audiotime = 1
		--end
	--end	
	--if self.audiotime == 1 then
		--if not BehaviorFunctions.CheckEntity(self.monster1) then 
			--Log("123")
			--BehaviorFunctions.ResumeBgmSound()
			--BehaviorFunctions.DoEntityAudioStop(self.monster1,"Test_Event")
			--self.audiotime = 2
		--end
	--end
	
	--if BehaviorFunctions.GetEntityValue(self.monster1,"ChangeState") == 1 and self.endMission == 0 then
		--BehaviorFunctions.ShowBlackCurtain(true,1)
		--BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1)
		--self.mission = 1
	--end
	
	--if self.monster1 then
		--if BehaviorFunctions.GetEntityValue(self.monster1,"ChangeState") == 2 and self.endMission == 0 then
			--
			--BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.6)
			--self.endMission = 1
		--end
	--end
end

--死亡事件
function LevelBehavior31010:RemoveEntity(instanceId)
	--if instanceId == self.monster2 then
		--local pos = BehaviorFunctions.GetTerrainPositionP("enemyBorn",20010004)
		--self.monster2 = BehaviorFunctions.CreateEntity(910040,nil,pos.x+4,pos.y,pos.z)
		--Log(self.monster)
	--end
	--if instanceId == self.monster1 then
		--local pos = BehaviorFunctions.GetTerrainPositionP("C1",20010004)
		--self.monster1 = BehaviorFunctions.CreateEntity(92003,nil,pos.x+1,pos.y,pos.z)
		----Log(self.monster)
	--end

	--if instanceId == self.monster2 then
		--local pos = BehaviorFunctions.GetTerrainPositionP("C1",10021003)
		--self.monster2 = BehaviorFunctions.CreateEntity(2000108,nil,pos.x-1,pos.y,pos.z)
		----Log(self.monster2)
	--end
	--if instanceId == self.monster3 then
		--local pos = BehaviorFunctions.GetTerrainPositionP("C1",10021003)
		--self.monster3 = BehaviorFunctions.CreateEntity(2000108,nil,pos.x,pos.y,pos.z+1)
		----Log(self.monster3)
	--end
	--if instanceId == self.monster4 then
		--local pos = BehaviorFunctions.GetTerrainPositionP("C1",10021003)
		--self.monster4 = BehaviorFunctions.CreateEntity(2000108,nil,pos.x,pos.y,pos.z-1)
		----Log(self.monster4)
	--end
end

--function LevelBehavior31010:CastSkill(instanceId,skillId,skillType)
	--if instanceId == self.role and skillId == 1001030 then
		
		--self.QTEID = BehaviorFunctions.DoShowResistQTE(self.role, "", "", 2, 500, 500, 10, 5, 50, 100000005, 100000006)
		--BehaviorFunctions.AddBuff(1,self.role,900000999,1)
		--BehaviorFunctions.SetFightMainNodeVisible(2, "NormalButton", false)
	--end
--end


function LevelBehavior31010:__delete()

end

--function LevelBehavior31010:ExitQTE(qteType, returnValue, qteId)
	
	--if qteId == self.QTEID then
		--self.QTEState = 1
		--BehaviorFunctions.RemoveBuff(self.role,900000999)
	--end

--end