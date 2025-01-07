LevelBehavior101010101 = BaseClass("LevelBehavior101010101",LevelBehaviorBase)
--临时负责处理场景相关生态物件的光照信息问题
function LevelBehavior101010101:__init(fight)
	self.fight = fight
end

function LevelBehavior101010101.GetGenerates()
	local generates = {}
	return generates
end

function LevelBehavior101010101.GetStorys()
	local storys = {}
	return storys
end

function LevelBehavior101010101:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.ecoEntityList = 
	{
		[1] = {ecoId = 2003001000016 },
		[2] = {ecoId = 2003001000018 },
		[3] = {ecoId = 2003001000021 },
		[4] = {ecoId = 2003001000015 },
		[5] = {ecoId = 2003001000017 },
		[6] = {ecoId = 2003001000019 },
	}
	self.missionState = 0
end

function LevelBehavior101010101:LateInit()

end

function LevelBehavior101010101:Update()
	if self.missionState == 0 then
		for i,v in ipairs(self.ecoEntityList) do
			local insId = BehaviorFunctions.GetEcoEntityByEcoId(v.ecoId)
			BehaviorFunctions.SetBakeData(insId,v.ecoId)
		end
		self.missionState = 1
	end
end