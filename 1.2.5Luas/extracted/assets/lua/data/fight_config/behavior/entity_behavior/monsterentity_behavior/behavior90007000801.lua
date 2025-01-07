Behavior90007000801 = BaseClass("Behavior90007000801",EntityBehaviorBase)

function Behavior90007000801.GetGenerates()
	local generates = {}
	return generates
end

function Behavior90007000801.GetMagics()
	local generates = {}
	return generates
end

local BF = BehaviorFunctions

--初始化，执行1帧
function Behavior90007000801:Init()

	self.me = self.instanceId
	self.battleTarget = BehaviorFunctions.GetCtrlEntity()--记录玩家
	--self.MonsterCommonParam = BF.CreateBehavior("MonsterCommonParam",self)
	--self.MonsterCommonBehavior = BF.CreateBehavior("MonsterCommonBehavior",self)
	local myPos = Vec3.New()					--获取怪物释放技能位置
end

function Behavior90007000801:Update()
						
	BF.AddDelayCallByTime(2,self,self.RecoverNormal)
end

--传送中丢失目标强制杀死怪物保底
function Behavior90007000801:RecoverNormal(instanceId)
	if BF.CheckEntity(self.me) and BF.CheckEntity(self.battleTarget) == false then
		local myPos = Vec3.New()					--获取怪物释放技能位置
		myPos:Set(myPos.x, myPos.y - 10, myPos.z)
		BF.DoSetPositionP(self.me,myPos)
	end
end