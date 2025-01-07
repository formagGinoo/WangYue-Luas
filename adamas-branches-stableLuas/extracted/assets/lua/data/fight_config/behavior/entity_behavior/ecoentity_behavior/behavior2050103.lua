Behavior2050103 = BaseClass("Behavior2050103",EntityBehaviorBase) --在怪物身上使用CheckEcoEntityGroup,来决定是否要调用这个函数。
--资源预加载
function Behavior2050103.GetGenerates()
	local generates = {}
	return generates
end

function Behavior2050103:Init()
	--self.MonsterCommonParam = self.MainBehavior.MonsterCommonParam  --一定要写这个！不然MonsterCommonParam无法传值进来
	--self.missionState=0

	----这里需要新的参数
	--self.direaction =BehaviorFunctions.GetEntityAngle(self.MonsterCommonParam.shaota,self.MonsterCommonParam.battleTarget) --哨塔需要做成实体，顺时针，0-360
	--self.positionM =BehaviorFunctions.GetPositionP(self.MonsterCommonParam.me) --怪物坐标
	--self.positionH =BehaviorFunctions.GetPositionP(self.MonsterCommonParam.me) --英雄坐标
	--self.distance= BehaviorFunctions.GetDistanceFromPos(self.position,self.p1)
	self.me = self.instanceId
	self.mission=0
	self.bornPosition={}
	self.warnKey=true
	self.warnOthers= false
	self.treasureBoxList={2010101,2010102,2010103,2010104}
	self.mission=0
	self.treasureBox=0 --给一个初始化id

end

function Behavior2050103:Update()
	--if self.monsterGroup ==nil then
	self.monsterGroup=BehaviorFunctions.GetEcoEntityGroup(nil,nil,self.me) --怪物跑逻辑的时候就会知道自己的组员（如果有）。
	--BehaviorFunctions.DoMagic(self.me,self.me,205010301)
	--end
	if self.monsterGroup~=nil then
		for i,v in pairs(self.monsterGroup) do
			if  BehaviorFunctions.CheckEntity(v.instanceId) == true
				and (BehaviorFunctions.GetEntityTemplateId(v.instanceId)==2010101
					or BehaviorFunctions.GetEntityTemplateId(v.instanceId)==2010102
					or BehaviorFunctions.GetEntityTemplateId(v.instanceId)==2010103
					or BehaviorFunctions.GetEntityTemplateId(v.instanceId)==2010104) then
				self.treasureBox =v.instanceId --取宝箱的id
			end
		end
	end

	self:TreasureBox() --奖励传值
end



--只负责上锁和怪物死亡时候的解锁，触发一次后移除。

function Behavior2050103:TreasureBox()
	if self.treasureBox~=0 then
		if self.mission==0 and self.monsterGroup~=nil then
			for i,v in pairs(self.monsterGroup) do --遍历monsterGroup中所有实例id,查找实例id对应的状态。需要知道这个实例是否存活吗？
				if BehaviorFunctions.CheckEntity(v.instanceId)==true then --检查实体是否存在
					if v.instanceId==self.treasureBox then
						BehaviorFunctions.SetEntityValue(v.instanceId,"lockState",2) --初始化的时候给一个上锁状态
						BehaviorFunctions.SetEntityValue(v.instanceId,"isHide",true) --初始化隐藏宝箱
						end
					end
				end
				self.mission=1
			end

			--加载出宝箱之后，发现没怪物了，自动解锁。
		end

end






--如何只在死亡的时候触发(正常解锁逻辑)
function Behavior2050103:Death(instanceId,isFormationRevive)
	if self.monsterGroup~=nil
		and self.mission==1 then
		local k=0
		for i,v in pairs(self.monsterGroup) do
			if v.instanceId ==instanceId then --当死亡的怪物是组内怪物时触发
				for x,y in pairs(self.monsterGroup) do
					if BehaviorFunctions.CheckEntity(y.instanceId)== true
						and BehaviorFunctions.GetNpcType(y.instanceId)
						and BehaviorFunctions.GetNpcType(y.instanceId)==FightEnum.EntityNpcTag.Monster then --判断是否有怪物剩余 
						k=k+1
					end
				end
				if k==0 then
					BehaviorFunctions.SetEntityValue(self.treasureBox,"isHide",false) --初始化显示宝箱
					BehaviorFunctions.SetEntityValue(self.treasureBox,"lockState",3)  --解锁
					--BehaviorFunctions.SetEntityValue(self.treasureBox,"openState",true)
					self.mission=2
					BehaviorFunctions.InteractEntityHit(self.me,FightEnum.SysEntityOpType.Death)
				end
			end
		end
	end
end

