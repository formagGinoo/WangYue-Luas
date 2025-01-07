SummonCarCtrl = BaseClass("SummonCarCtrl",BaseCarCtrl)

local _random = math.random

function SummonCarCtrl:__init()

end

function SummonCarCtrl:Init(fight, trafficManager, carInstanceId, entityId, startPos,targetPos,needSearchPath)
	
	self:BaseFunc("Init",fight, trafficManager, carInstanceId)
	self:LoadCarEntity(entityId, startPos,targetPos,needSearchPath)
	self.addUpTime = 0
end


function SummonCarCtrl:LoadCarEntity(entityId, startPos,targetPos,needSearchPath)
	
	self:BaseFunc("LoadCarEntity",entityId,function()
		if needSearchPath then
            local path = {}
            table.insert(path,startPos)
            table.insert(path,targetPos)
            BehaviorFunctions.StartCarFollowPath(self.entity.instanceId,false,path)
        else
		    self.entity.transformComponent:SetPosition(targetPos.x, targetPos.y, targetPos.z)
        end

		self.curGuidePointer = BehaviorFunctions.AddEntityGuidePointer(self.entity.instanceId, FightEnum.GuideType.SummonCar, 1.6,nil,20)
		self.markInstance = mod.WorldMapCtrl:AddCanMoveMark(self.entity.instanceId,"Textures/Icon/Single/MapIcon/carSummon.png",10020005,FightEnum.MapMarkType.SummonCar,TI18N("载具"))
		
	end)

end

function SummonCarCtrl:FreeSummon()
	self.trafficManager:FreeSummonCar(self.carInstanceId)
	BehaviorFunctions.RemoveEntityGuidePointer(self.curGuidePointer)
	mod.WorldMapCtrl:RemoveMapMark(self.markInstance)
end

function SummonCarCtrl:SetDriveOn(isOn,driveInstance)
	BehaviorFunctions.RemoveEntityGuidePointer(self.curGuidePointer)
	mod.WorldMapCtrl:RemoveMapMark(self.markInstance)
	self:BaseFunc("SetDriveOn",isOn,driveInstance)
end


function SummonCarCtrl:Update()
	if not self.isLoad then
		return 
	end

	if not self.hasDrive and not self.crashed and self.enable then
		self.entity.moveComponent.moveComponent:SetEnable(true)
	else
		self.entity.moveComponent.moveComponent:SetEnable(false,false)
	end

	local deltaTime = FightUtil.deltaTimeSecond

	self.addUpTime = self.addUpTime + deltaTime
	if not self.SetDriveOn then
		if self.addUpTime > 30 then
			self:FreeSummon()
			return
		end
	end
	
	self:BaseFunc("Update")
end


function SummonCarCtrl:__cache()
	BehaviorFunctions.RemoveEntityGuidePointer(self.curGuidePointer)
	mod.WorldMapCtrl:RemoveMapMark(self.markInstance)
	self:BaseFunc("__cache")
end
