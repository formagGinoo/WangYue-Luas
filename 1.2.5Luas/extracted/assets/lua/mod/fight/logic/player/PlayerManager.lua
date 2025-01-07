---@class PlayerManager
PlayerManager = BaseClass("PlayerManager")


function PlayerManager:__init(fight)
	self.fight = fight
end

function PlayerManager:Init(fightData)
	self.players = {}
	for key,value in pairs(fightData.PlayerData) do
		local player = Player.New()
		player:Init(self.fight,value.Id,value.heroes)
		self.players[key] = player
	end
end

function PlayerManager:StartFight(pos,cb)
	for i = 1, #self.players do
		self.players[i]:StartFight(pos,cb)
	end
end

function PlayerManager:Update()
	for i = 1, #self.players do
		if self.players[i].Update then
			self.players[i]:Update()
		end
	end
end

---@return Player
function PlayerManager:GetPlayer()
	return self.players[1]
end

function PlayerManager:GetPlayerList()
	return self.players
end

function PlayerManager:__delete()

end