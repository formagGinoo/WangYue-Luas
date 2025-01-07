LevelBehavior10020004 = BaseClass("LevelBehavior10020004",LevelBehaviorBase)


--动态创建关卡1
function LevelBehavior10020004:__init(fight)
	self.fight = fight
end

--创建怪物和npc
function LevelBehavior10020004.GetGenerates()
	local generates = {900050,910040}
	return generates
end


function LevelBehavior10020004:Init()
	self.role = nil
	self.state = nil
	
end

function LevelBehavior10020004:Update()
	if not self.state then
		self.role = BehaviorFunctions.GetCtrlEntity()
		local pos = BehaviorFunctions.GetTerrainPositionP("born",10020004)
		BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		self.state = true
	end
end


function LevelBehavior10020004:__delete()

end