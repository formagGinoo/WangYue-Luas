Behavior2030406 = BaseClass("Behavior2030406",EntityBehaviorBase)
--生态玩法跑酷交互机关
function Behavior2030406.GetGenerates()
	local generates = {2030406}
	return generates
end

function Behavior2030406:Init()
	self.me = self.instanceId
	self.ecoMe = self.sInstanceId
	self.button = nil
    self.role = nil
	self.level = 405010201
	self.inArea = false
	self.distance = 0
	self.totalFrame = 0
	self.effectState = 0
	self.effectStateEnum = {
		Near = 1,
		Far = 2,
		}
	self.effectDistance = 15
	self.effect = 0
	self.missionState = 0
	self.pos = 0
	self.myRotateY = 0
	self.nextRotateY = 0
	self.rotate = 0
	self.removeLevel = false
	self.finishLevel = false
	self.effectTurn = true
	self.ecoState = nil
	self.stateEnum = {
		actived = 0,
		finished = 1
	}
	self.mystate = nil
end

function Behavior2030406:LateInit()
	-- 获取生态状态
	self.state = BehaviorFunctions.GetEcoEntityState(self.ecoMe)
	--获取绑定关卡id
	self.bindLevelId = BehaviorFunctions.GetEcoEntityBindLevel(self.ecoMe)

end

function Behavior2030406:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoMe)
	self.time = BehaviorFunctions.GetFightFrame()
	
	if self.missionState == 0 then
	
		local myPos = BehaviorFunctions.GetPositionP(self.me)
		self.effect = BehaviorFunctions.CreateEntityByEntity(self.me,203040601,myPos.x,myPos.y,myPos.z)
		self.missionState = 1
	end
	if self.missionState == 2 and self.removeLevel == true then
		--开启交互
		BehaviorFunctions.SetEntityWorldInteractState(self.me, true)
		self.removeLevel = false
	
		self.missionState = 3
	end
	
	if self.ecoState == 0 then
		self.myState = self.stateEnum.actived
		
	elseif self.ecoState == 1 then
		self.myState = self.stateEnum.finished
	end
	
	if self.myState == self.stateEnum.finished then
		--机关完成后转变为已完成状态
		BehaviorFunctions.RemoveEntity(self.effect)
		--关闭激活特效
		BehaviorFunctions.SetEntityBineVisible(self.me,"FxChallenge_parkour",false)
		--关闭待机特效
		BehaviorFunctions.SetEntityBineVisible(self.me,"FxChallenge_parkour_Stand",false)
		--关闭过渡特效
		BehaviorFunctions.SetEntityBineVisible(self.me,"FxChallenge_parkour01",false)
		--关闭时过渡特效
		BehaviorFunctions.SetEntityBineVisible(self.me,"FxChallenge_parkour02",false)
		--关闭激活音效
		BehaviorFunctions.DoEntityAudioStop(self.me,"OpenWorld_Challenge",0,1)
		--移除交互
		BehaviorFunctions.SetEntityWorldInteractState(self.me, false)
		self.effectTurn = false	
	end

	if self.effectTurn == true then
		--取到物件角度
		self.myRotateY = BehaviorFunctions.GetEntityWorldAngle(self.effect)
		--匹配特效角速度
		self.nextRotateY = self.myRotateY - self.rotate
	
	
		if not self.effect then
		
			local myPos = BehaviorFunctions.GetPositionP(self.me)
		
			self.effect = BehaviorFunctions.CreateEntityByEntity(self.me,203040601,myPos.x,myPos.y,myPos.z)
		
			BehaviorFunctions.SetEntityWorldAngle(self.effect,self.myRotateY)
		end
	
		
		BehaviorFunctions.SetEntityWorldAngle(self.effect,self.nextRotateY)
	
		--距离开控制特效的播放
		self.distance = BehaviorFunctions.GetDistanceFromTarget(self.role,self.me)

		if self.distance <= self.effectDistance then
			--判断特效状态
			if self.effectState ~= self.effectStateEnum.Near then
				--隐藏待机特效
				BehaviorFunctions.AddDelayCallByFrame(7,BehaviorFunctions,BehaviorFunctions.SetEntityBineVisible,self.me,"FxChallenge_parkour_Stand",false)
				--播放过渡特效
				BehaviorFunctions.SetEntityBineVisible(self.me,"FxChallenge_parkour01",true)
				--关闭时过渡特效
				BehaviorFunctions.SetEntityBineVisible(self.me,"FxChallenge_parkour02",false)
				--播放激活特效
				BehaviorFunctions.AddDelayCallByFrame(7,BehaviorFunctions,BehaviorFunctions.SetEntityBineVisible,self.me,"FxChallenge_parkour",true)
				--播放激活音效
				BehaviorFunctions.AddDelayCallByFrame(3,BehaviorFunctions,BehaviorFunctions.DoEntityAudioPlay,self.me,"OpenWorld_Challenge",false)

				self.effectState = 	self.effectStateEnum.Near
				self.rotate = 3
			end
		else
			if self.effectState ~= self.effectStateEnum.Far then
				--隐藏激活特效
				BehaviorFunctions.SetEntityBineVisible(self.me,"FxChallenge_parkour",false)
				--播放待机特效
				BehaviorFunctions.SetEntityBineVisible(self.me,"FxChallenge_parkour_Stand",true)
				--关闭过渡特效
				BehaviorFunctions.SetEntityBineVisible(self.me,"FxChallenge_parkour01",false)
				--关闭时过渡特效
				BehaviorFunctions.SetEntityBineVisible(self.me,"FxChallenge_parkour02",true)
				--关闭激活音效

				BehaviorFunctions.DoEntityAudioStop(self.me,"OpenWorld_Challenge",0,1)
				self.effectState = 	self.effectStateEnum.Far
				self.rotate = 1
			end
		end
	end	
end

--点击交互
function Behavior2030406:WorldInteractClick(uniqueId,instanceId)

		if instanceId ~= self.me then
			return
		end

		if instanceId ==self.me then
		    --创建对应关卡
		    BehaviorFunctions.AddLevel(self.bindLevelId)
	
			--移除交互
			BehaviorFunctions.SetEntityWorldInteractState(self.me, false)
		self.missionState = 2
		end	
end


function Behavior2030406:RemoveLevel(LevelId)
--通过remove来检测挑战是否失败
	if LevelId == self.bindLevelId then
		self.removeLevel = true
	end
end

	
function Behavior2030406:FinishLevel(levelId)
	if levelId == self.bindLevelId then
		BehaviorFunctions.SetEcoEntityState(self.ecoMe,1)	
		--self.myState == self.stateEnum.finished	

	end
end

