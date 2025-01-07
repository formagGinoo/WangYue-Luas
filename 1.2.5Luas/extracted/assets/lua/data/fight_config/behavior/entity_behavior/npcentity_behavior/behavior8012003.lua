Behavior8012003 = BaseClass("Behavior8012003",EntityBehaviorBase)
--异种小猪
function Behavior8012003.GetGenerates()
	-- local generates = {}
	-- return generates
end
function Behavior8012003:Init()
	self.me = self.instanceId
	self.AnimalCommon = BehaviorFunctions.CreateBehavior("AnimalCommon",self)
	
	--怪物参数
	self.myHeight = 0.8
	self.myLenth = 1.6
	--休闲状态
	self.leisureCD = 5        --休闲状态下多久做一次行动变化
	self.leisureFrame = 0     --记录休闲状态的帧数
	self.wandMinRange = 4     --游荡的最短距离
	self.wandMaxRange = 8     --游荡的最远距离
	--默认动作
	self.actList= {[1] = {aniName = "Eat" , lastTime = 5}}	 --休闲动作列表
end

function Behavior8012003:LateInit()
	
end


function Behavior8012003:Update()
	self.AnimalCommon:Update()
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
