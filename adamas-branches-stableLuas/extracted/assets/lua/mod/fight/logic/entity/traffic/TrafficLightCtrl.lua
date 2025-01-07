TrafficLightCtrl = BaseClass("TrafficLightCtrl",PoolBaseClass)

local _random = math.random
local LightType =
{
    Dark = 0,
    Red = 1,
    FlickerRed = 2,
    Yellow = 3,
    FlickerGreen = 4,
    Green = 5
}
function TrafficLightCtrl:__init()

end

function TrafficLightCtrl:Init(fight, trafficManager, id, objectPos)
	self.fight = fight
	self.trafficManager = trafficManager
	self.trafficParams = self.trafficManager.trafficParams
	
	self.LoadInternalTimer = 0
	self.LoadInternalTime = 0.5 -- 红绿灯刷新间隔

	self.isLoad = false

    self.crossId = id % 10000
    self.streetId = math.floor(id /10000) 
    
    if objectPos == 0 then
        -- 无车道红绿灯
        self.objectPos = nil
    else
        self.objectPos = objectPos
    end
    
	local curStreet = self.trafficManager:GetStreetCenterData(self.streetId)
    self.sideLight = curStreet.HeadCross == self.crossId and curStreet.HeadSideLight or curStreet.AssSideLight

    self.sideLightObject = {}
end

function TrafficLightCtrl:GetLightBehaviour(pos,str)
    
    local collider,count = CustomUnityUtils.OverlapSphereColliderGetCollider(pos, 1, FightEnum.LayerBit.Default,0)
    local result
    if collider then
        for i = 0, count - 1 do
            local v = collider[i]
            if v.transform.name == str then
                local gb = v.gameObject
                result = gb:GetComponent(TrafficLightBehaviour)
                if not result then
                    result = gb:AddComponent(TrafficLightBehaviour)
                end
            end
        end
    end
    return result
end
function TrafficLightCtrl:RelateObject()

    -- 车道红绿灯
    if self.objectPos and (not self.lightBehaviour or UtilsBase.IsNull(self.lightBehaviour)) then
		self.lightBehaviour = self:GetLightBehaviour(self.objectPos,"TrafficLight_10020005_03b_City")
    end

    -- 人行道红绿灯
    for i, v in ipairs(self.sideLight) do
        if not self.sideLightObject[i] or UtilsBase.IsNull(self.sideLightObject[i]) then
            local behaviour = self:GetLightBehaviour(v,"TrafficLight_10020005_02b_City")
            self.sideLightObject[i] = behaviour
        end
    end
end

function TrafficLightCtrl:Update()
	
	if self.LoadInternalTimer == 0 then
        self:UpdateEffect()
		self:RelateObject()
	end
	local deltaTime = FightUtil.deltaTimeSecond

	self.LoadInternalTimer = self.LoadInternalTimer >= self.LoadInternalTime and 0 or self.LoadInternalTimer + deltaTime

end


function TrafficLightCtrl:UpdateEffect()
    
    local signal,revertSignal = self.trafficManager:GetTrafficLightType(self.streetId,self.crossId)
    if self.lightBehaviour and not UtilsBase.IsNull(self.lightBehaviour) then
        self.lightBehaviour:ChangeType(self:GetlLightBehaviourType(signal))
    end
    for k, v in pairs(self.sideLightObject) do
        if v and not UtilsBase.IsNull(v) then
            local lightType = self:GetlLightBehaviourType(revertSignal)
            if lightType == LightType.Yellow  then
                lightType = LightType.Red
            end
            v:ChangeType(lightType)
        end 
    end
end

function TrafficLightCtrl:GetlLightBehaviourType(signal,isSide)
    if signal == 1 then
        return LightType.Green
    elseif signal == 2 then
        return LightType.FlickerGreen
    elseif signal == 3 then        
        return LightType.Yellow
    elseif signal == 4 then
        if self.trafficManager.enableRedLight then
            return LightType.Red
        else
            return LightType.Yellow
        end
    end
end

function TrafficLightCtrl:__cache()
    if self.lightBehaviour and not UtilsBase.IsNull(self.lightBehaviour) then
        self.lightBehaviour:ChangeType(LightType.Dark)
    end
    for k, v in pairs(self.sideLightObject) do
        if v and not UtilsBase.IsNull(v) then
            v:ChangeType(LightType.Dark)
        end 
    end
	self.lightBehaviour = nil
    TableUtils.ClearTable(self.sideLightObject)
end

function TrafficLightCtrl:__delete()
end
