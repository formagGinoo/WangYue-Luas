Behavior2030213 = BaseClass("Behavior2030213",EntityBehaviorBase)
--刷怪淤脉
function Behavior2030213.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2030213:Init()
	self.me = self.instanceId	
	self.battleTarget = nil
	self.playerInRange = false
	
	--怪物状态
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	self.summonList = 
	{
		[1] = {instanceId = nil,entityId = 900040,angle= 45 ,dis = 3 ,state = self.monsterStateEnum.Default},
		[2] = {instanceId = nil,entityId = 900040,angle= 315 ,dis = 3 , state = self.monsterStateEnum.Default}
	}
end

function Behavior2030213:LateInit()
	
end


function Behavior2030213:Update()
	self.battleTarget = BehaviorFunctions.GetCtrlEntity()
	if self.playerInRange == true then
		self:SummonMonster(self.summonList)
	end
	--免疫受击
	if not BehaviorFunctions.HasBuffKind(self.me,900000001) then
		BehaviorFunctions.AddBuff(self.me,self.me,900000001)
	end
	--免疫受击朝向
	if not BehaviorFunctions.HasBuffKind(self.me,900000020) then
		--BehaviorFunctions.AddBuff(self.me,self.me,900000020)
		BehaviorFunctions.DoMagic(self.me,self.me,900000020)
	end
end

--召唤敌人
function Behavior2030213:SummonMonster(monsterList)
	local currentMonsterNum = 0
	for i,v in ipairs(monsterList) do
		if v.state == self.monsterStateEnum.Live then
			return
		end
		for i,v in ipairs(monsterList) do
			local pos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,v.dis,v.angle)
			monsterList[i].instanceId = BehaviorFunctions.CreateEntity(monsterList[i].entityId,nil,pos.x,pos.y,pos.z)
			monsterList[i].state = self.monsterStateEnum.Live
			BehaviorFunctions.DoLookAtTargetImmediately(monsterList[i].instanceId,self.battleTarget)
			--关闭警戒
			BehaviorFunctions.SetEntityValue(monsterList[i].instanceId,"haveWarn",false)
		end
	end
end

function Behavior2030213:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if triggerInstanceId == self.me and roleInstanceId == self.battleTarget then
		if self.playerInRange == false then
			self.playerInRange = true
		end
	end
end

function Behavior2030213:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if triggerInstanceId == self.me and roleInstanceId == self.battleTarget then
		if self.playerInRange == true then
			self.playerInRange = false
		end
	end
end

function Behavior2030213:Die(attackInstanceId,dieInstanceId)
	--自身死亡时清除自身的召唤物
	if dieInstanceId == self.me then
		for i,v in ipairs(self.summonList) do
			BehaviorFunctions.SetEntityAttr(v.instanceId,1001,0)
		end
	end
end

function Behavior2030213:Death(instanceId,isFormationRevive)
	--记录自己召唤出来的小怪是否死亡
	for i,v in ipairs(self.summonList) do
		if instanceId == v.instanceId then
			v.state = self.monsterStateEnum.Dead
		end
	end
end



