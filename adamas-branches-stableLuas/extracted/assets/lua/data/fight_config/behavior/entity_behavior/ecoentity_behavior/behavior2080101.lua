Behavior2080101 = BaseClass("Behavior2080101",EntityBehaviorBase)
--电压陷阱
function Behavior2080101.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2080101:Init()
	self.me = self.instanceId
end

function Behavior2080101:LateInit()
	
end

function Behavior2080101:OnActiveJointEntity(instanceId,isActive)
	if instanceId == self.me then
		if isActive == true then
			BehaviorFunctions.DoMagic(self.me,self.me,208010101)	--风扇特效
			BehaviorFunctions.DoEntityAudioPlay(self.me,"Aircraft_Fly",true)
		else
			BehaviorFunctions.RemoveBuff(self.me,208010101)	--风扇特效
			BehaviorFunctions.DoEntityAudioStop(self.me,"Aircraft_Fly",0,0.5)
		end
	end
end