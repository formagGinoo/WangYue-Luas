LevelBehavior103320104 = BaseClass("LevelBehavior103320104",LevelBehaviorBase)
--浮空岛3护送义向

function LevelBehavior103320104.GetGenerates()
    local generates = {791004002}
    return generates
end

function LevelBehavior103320104:Init()
	self.missionState = 0
end

 
function LevelBehavior103320104:Update()
	if self.missionState == 0 then
		MsgBoxManager.Instance:ShowTips(TI18N("暂时无法护送义向，任务自动完成"), 3)
		BehaviorFunctions.FinishLevel(self.levelId)
		self.missionState = 1
	end
end