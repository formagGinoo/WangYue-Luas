Behavior2050201 = BaseClass("Behavior2050201",EntityBehaviorBase) --在怪物身上使用CheckEcoEntityGroup,来决定是否要调用这个函数。
--资源预加载
function Behavior2050201.GetGenerates()
	local generates = {}
	return generates
end

function Behavior2050201:Init()
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

function Behavior2050201:Update()
	self.monsterGroup=BehaviorFunctions.GetEcoEntityGroup(nil,nil,self.me) --怪物跑逻辑的时候就会知道自己的组员
	if self.monsterGroup~=nil then
		for x,y in pairs(self.monsterGroup) do
			if BehaviorFunctions.CheckEntity(y.instanceId)== true
				and BehaviorFunctions.GetNpcType(y.instanceId)
				and BehaviorFunctions.GetNpcType(y.instanceId)==FightEnum.EntityNpcTag.Monster then
				BehaviorFunctions.SetEntityValue(y.instanceId,"peaceState",2)
				BehaviorFunctions.SetEntityValue(y.instanceId,"actPerformance","Sit")
			end
		end
	end
end




