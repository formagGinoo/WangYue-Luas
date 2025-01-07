---@class PlayerManager
PlayerManager = BaseClass("PlayerManager")


function PlayerManager:__init(fight)
	self.fight = fight
end

function PlayerManager:Init(fightData)
	self.players = {}
	for key,value in pairs(fightData.PlayerData) do
		local player = Player.New()
		player:Init(self.fight,value.Id,value.heroes,value.abilityPartner)
		self.players[key] = player
	end
end

function PlayerManager:StartFight(pos, rot, cb)
	for i = 1, #self.players do
		self.players[i]:StartFight(pos, rot, cb)
	end
end

function PlayerManager:Update()
	for i = 1, #self.players do
		if self.players[i].Update then
			self.players[i]:Update()
		end
	end
end

function PlayerManager:AfterUpdate()
	for i = 1, #self.players do
		if self.players[i].AfterUpdate then
			self.players[i]:AfterUpdate()
		end
	end
end

function PlayerManager:LowUpdate()
	for i = 1, #self.players do
		if self.players[i].LowUpdate then
			self.players[i]:LowUpdate()
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
	for k, player in pairs(self.players) do
		player:DeleteMe()
	end
end