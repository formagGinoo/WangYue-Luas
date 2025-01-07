Behavior6000035 = BaseClass("Behavior6000035",EntityBehaviorBase)

local BF = BehaviorFunctions

function Behavior6000035.GetGenerates()

end
function Behavior6000035.GetMagics()

end

function Behavior6000035:Init()
	self.me = self.instanceId		--记录自己
end

function Behavior6000035:Update()
	
end

--元素攻击判断
function Behavior6000035:BeforeCalculateDamage(attackInstanceId,hitInstanceId,damageType,magicId,damageElementType,
		attackType,partType,damageInfo,ownerInstanceId)
	if ownerInstanceId == self.me and damageElementType ~= 1 then
		damageInfo.atkCrit = damageInfo.atkCrit + 0.2 --单次暴击率修改必须使用"伤害计算前"回调
	end
end
		
