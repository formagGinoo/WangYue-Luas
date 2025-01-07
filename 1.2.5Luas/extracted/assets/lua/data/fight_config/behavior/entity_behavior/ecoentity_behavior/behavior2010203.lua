Behavior2010203 = BaseClass("Behavior2010203",EntityBehaviorBase)
--鱼鱼
local DataItem = Config.DataItem.data_item

--预加载
function Behavior2010203.GetGenerates()

end

function Behavior2010203:Init()
	self.me = self.instanceId
	self.switchTime = 3 --s,方向切换事件
	self.moveStartTime = 0
	self.maxDistance = 2 --m,最远游泳距离
	self.canBack = true
	self.nextPos = Vec3.New()
end


function Behavior2010203:Update()
	self.myTime = BehaviorFunctions.GetEntityFrame(self.me)/30
	--出生点，出生距离
	if not self.bornPosition then
		local posx, posy, posz = BehaviorFunctions.GetPosition(self.me)
		self.bornPosition = Vec3.New(posx, posy, posz)    
	else
		local myPos = BehaviorFunctions.GetPositionP(self.me)
		self.bornDistance = BehaviorFunctions.GetDistanceFromPos(myPos,self.bornPosition)
	end
	--一直走，不要停
	if BehaviorFunctions.GetEntityState(self.me) ~= FightEnum.EntityState.Move then
		BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Move)
		BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
	end
	--角度控制
	if self.bornDistance and self.bornDistance < self.maxDistance then
		--在范围里，每switchTime获取随机角度
		if self.myTime >= self.switchTime + self.moveStartTime then
			self.canBack = true
			self.moveAngle = math.random(1,60)
			self.moveStartTime = self.myTime	
			--按随机角度设置朝向
			if self.moveAngle then
				local posx, posy, posz = BehaviorFunctions.GetPosition(self.me)
				local nextPosx = posx+math.sin(self.moveAngle)
				local nextPosz = posz+math.cos(self.moveAngle)
				self.nextPos:Set(nextPosx,posy,nextPosz)
				--BehaviorFunctions.DoLookAtPositionImmediately(self.me,nextPos.x,nextPos.y,nextPos.z)
				BehaviorFunctions.DoLookAtPositionByLerp(self.me,self.nextPos.x,self.nextPos.y,self.nextPos.z,false,0,60)
			end
		end
		--不在范围内，返回出生点
	elseif self.bornDistance and self.bornDistance >= self.maxDistance and self.canBack == true then
		--BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.bornPosition.x,self.bornPosition.y,self.bornPosition.z)
		BehaviorFunctions.DoLookAtPositionByLerp(self.me,self.bornPosition.x,self.bornPosition.y,self.bornPosition.z,false,0,60)
		self.moveAngle = nil
		self.moveStartTime = self.myTime
		self.canBack = false
	end
end

function Behavior2010203:WorldInteractClick(uniqueId)
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		BehaviorFunctions.InteractEntityHit(self.me)
	end
end

function Behavior2010203:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger then
		return
	end
	self.isTrigger = triggerInstanceId == self.me
	if not self.isTrigger then
		return
	end
	if not self.itemInfo then
		self.itemInfo = BehaviorFunctions.GetEntityItemInfo(self.me)
	end

	self.interactUniqueId = BehaviorFunctions.WorldItemInteractActive(self.itemInfo.id)
end

function Behavior2010203:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me then
		self.isTrigger = false
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
	end
end

function Behavior2010203:__delete()
	if self.isTrigger then
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
		self.isTrigger = false
	end
end