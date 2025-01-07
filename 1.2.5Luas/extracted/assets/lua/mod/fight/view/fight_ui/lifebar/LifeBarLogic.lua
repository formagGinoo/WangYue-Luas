LifeBarLogic = BaseClass("LifeBarLogic", PoolBaseClass)

local HitStayFrame = 30 --受击红色保留时间
local HitMaxStayFrame = 60 --最长保留时间
local DecPercent = 0.3 --衰减比例

function LifeBarLogic:__init()
	self.lifeDec = 0
	self.lifeStayTime = 0
	self.rLife = -1
	
	self.recordLife = 0
	self.recordMaxLife = 1
end

function LifeBarLogic:__delete()
end

function LifeBarLogic:Cache()
	Fight.Instance.objectPool:Cache(LifeBarLogic, self)
end

function LifeBarLogic:__cache()
end

function LifeBarLogic:GetPercent(curLife, maxLife)
	return curLife / maxLife
end

function LifeBarLogic:UpdateLifeBar(v, mv)
	if self.rLife == -1 then
		self.rLife = mv
	end
	
	if self.rLife > v then
		local frame = BehaviorFunctions.GetFightFrame()
		if (self.lifeDec <= frame or self.lifeStayTime <= frame) and not self.playDec then
			self.lifeStayTime = frame + HitMaxStayFrame
		end
	
		self.lifeDec = frame + HitStayFrame
	end
	
	self.recordLife = v
	self.recordMaxLife = mv
end

function LifeBarLogic:DoDecLifeAnim()
	if self.rLife == -1 then return end
	
	local frame = BehaviorFunctions.GetFightFrame()
	local percent = self:GetPercent(self.rLife, self.recordMaxLife)
	if self.lifeDec <= frame or self.lifeStayTime <= frame then
		if not self.rLife or math.abs(self.rLife - self.recordLife) < 1 then
			self.playDec = false
		else
			self.playDec = true

			percent = percent - DecPercent * FightUtil.deltaTimeSecond
			percent = math.max(percent, self:GetPercent(self.recordLife, self.recordMaxLife))
			self.rLife = percent * self.recordMaxLife
		end
	end
	return percent
end