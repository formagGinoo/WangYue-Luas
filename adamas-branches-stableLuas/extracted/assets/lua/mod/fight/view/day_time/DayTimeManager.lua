
DayTimeManager = BaseClass("DayTimeManager")

local _os_time = os.time
-- 1小时1天
local OneDayTime = 3600
local OneDayHour = OneDayTime / 3600
local DaySpeed = 24 * 3600 / OneDayTime

function DayTimeManager:__init(clientFight)
	self.clientFight = clientFight
end


function DayTimeManager:StartFight()
	-- self:SetDayTimeHourMinSec(10, 0, 0)
end


function DayTimeManager:SetDayTimeHourMinSec(hour, min, sec)
	if not self.dayTimeMananger then
		local transform = self.clientFight.clientMap.transform
		local dayRoot = self.clientFight.assetsPool:Get("Prefabs/Others/TimeOfDayRoot.prefab")
		if dayRoot then
			dayRoot.transform:SetParent(transform)
			self.dayTimeMananger = dayRoot:GetComponentInChildren(TimeOfDayManager)
		end
	end

	local offsetTime = hour * 3600 + min * 60 + sec
	DayStartTime = _os_time() - offsetTime * DaySpeed

	local time = offsetTime / 3600
	self.dayTimeMananger:SetTime(time, 0)
	self.dayTimeMananger:SetLoopTime(0, 5)
	self.dayTimeMananger:Play()
end

function DayTimeManager:SetDayLoopTime(hour, min)
	if self.dayTimeMananger then
		self.dayTimeMananger:SetLoopTime(hour, min)
	end
end

function DayTimeManager:GetDayTimeHourMinSec()
	local offsetTime = _os_time() - DayStartTime
	local timestamp = _os_time() + offsetTime * DaySpeed
	local timeTable = os.date("*t", timestamp)
	return timeTable.hour, hour.min, timeTable.sec 
end
