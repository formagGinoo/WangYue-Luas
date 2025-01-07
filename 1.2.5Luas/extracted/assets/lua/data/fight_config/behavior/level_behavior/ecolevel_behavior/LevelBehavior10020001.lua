LevelBehavior10020001 = BaseClass("LevelBehavior10020001",LevelBehaviorBase)
--生态behavior
function LevelBehavior10020001:__init(fight)
	self.fight = fight
end

function LevelBehavior10020001.GetGenerates()
	local generates = {2030201}
	return generates
end


function LevelBehavior10020001:Init()
	self.missionState = 0
	self.time = 0
	self.timeStart = 0
	self.playingBgm = ""
end

function LevelBehavior10020001:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if BehaviorFunctions.GetAttachLayer(self.role,FightEnum.Layer.Marsh) then
		if not BehaviorFunctions.HasBuffKind(self.role,200000105) then
			BehaviorFunctions.AddBuff(1,self.role,200000105)
			BehaviorFunctions.SetFightMainNodeVisible(2,"K",false) --闪避
			BehaviorFunctions.SetFightMainNodeVisible(2,"O",false) --跳跃
		end
	else
		if BehaviorFunctions.HasBuffKind(self.role,200000105) then
			BehaviorFunctions.RemoveBuff(self.role,200000105)
			BehaviorFunctions.SetFightMainNodeVisible(2,"K",true) --闪避
			BehaviorFunctions.SetFightMainNodeVisible(2,"O",true) --跳跃
		end
	end

	local inFight = BehaviorFunctions.CheckPlayerInFight()
	if not inFight then
		self.FightBgm = nil
	end
	--播bgm
	if inFight and self.playingBgm ~="Blbt" and self.playingBgm ~="Bxlks" then
		if not self.FightBgm then
			-- self:PlayBgm("MtCombat")
			self.FightBgm = true
		end
	elseif BehaviorFunctions.CheckEntityInArea(self.role, "Mountain", "Logic10020001_6") then
		self:PlayBgm("MtExplore")
	elseif BehaviorFunctions.HasBuffKind(1,900000017) then
		-- self:PlayBgm("MtBoss")
	elseif BehaviorFunctions.HasBuffKind(1,900000016) then
		-- self:PlayBgm("MtBoss")
	else
		self:PlayBgm("Meadow")
	end
end
function LevelBehavior10020001:RemoveEntity(instanceId)

end

function LevelBehavior10020001:__delete()

end

function LevelBehavior10020001:PlayBgm(name)
	-- if not string.match(self.playingBgm,name) then
	-- 	BehaviorFunctions.StopBgmSound()
	-- 	BehaviorFunctions.PlayBgmSound(name)
	-- 	Log(name)
	-- 	self.playingBgm = name
	-- end
end