Behavior2030207 = BaseClass("Behavior2030207",EntityBehaviorBase)
--荆棘
function Behavior2030207.GetGenerates()
	 local generates = {}
	 return generates
end

function Behavior2030207:Init()
	self.me = self.instanceId
	self.magicState = 0
	self.thornStateEnum =
	{
		Default = 0,
		Burning = 1,
		Death = 2,
	}
	
	self.thornState = self.thornStateEnum.Default
	
	self.onCollide = false --进入碰撞
	
	self.fireDistance = 10 --火焰传递范围
	
	self.onFirstHit = false
	
	
end


function Behavior2030207:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.EcoId = BehaviorFunctions.GetEntityEcoId(self.me)
	self.entityId = BehaviorFunctions.GetEntityTemplateId(self.me)
		if self.magicState == 0 then
			BehaviorFunctions.DoMagic(1,self.me,900000020)
			--BehaviorFunctions.DoMagic(1,self.me,900000022)
			self.magicState = 1
		end
	--进入燃烧状态后延迟一段时间移除荆棘
	if self.thornState == self.thornStateEnum.Burning then
		BehaviorFunctions.AddDelayCallByFrame(60, BehaviorFunctions, BehaviorFunctions.RemoveEntity, self.me)
		self.thornState = self.thornStateEnum.Death
	end
end

--900000105死亡溶解特效实体
--BehaviorFunctions.CreateEntity(900000105,3)

function Behavior2030207:Damage(attackInstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal,attackType,partType,damageInfo,ownerInstanceId,isCirt)
	--被火属性打中了
	if damageElementType == FightEnum.ElementType.Fire and hitInstanceId == self.me then
		if self.thornState == self.thornStateEnum.Default then
			BehaviorFunctions.CreateEntity(203020701, self.me) --特效
			self.thornState = self.thornStateEnum.Burning
		end		
	end
end

--赋值
function Behavior2030207:Assignment(variable,value)
	self[variable] = value
end

--黑魔法 firePass
function Behavior2030207:RemoveEntity(instanceId)
	--获取移除的实体instanceId
	local entityId = BehaviorFunctions.GetEntityTemplateId(instanceId)
	--确认移除的实体是荆棘
	if entityId == 2030207 then
		--获取被移除的荆棘的位置
		local mypos = BehaviorFunctions.GetPositionP(instanceId)
		--获取场上荆棘的位置
		local thornPos = BehaviorFunctions.GetPositionP(self.me)
		--获取二者距离
		local distance = BehaviorFunctions.GetDistanceFromPos(mypos,thornPos)
		if distance < self.fireDistance then
			if self.thornState == self.thornStateEnum.Default then
				--BehaviorFunctions.AddDelayCallByFrame(45, BehaviorFunctions, BehaviorFunctions.CreateEntity, 203020701, self.me)  --特效
				BehaviorFunctions.CreateEntity(203020701, self.me) --特效
				self.thornState = self.thornStateEnum.Burning
			end
		end
	end
end