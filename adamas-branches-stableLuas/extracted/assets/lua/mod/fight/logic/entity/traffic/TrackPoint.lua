---@class TrackPoint 道路点
TrackPoint = BaseClass("TrackPoint",PoolBaseClass)

function TrackPoint:__init()
    self.pos = Vec3.New(0,0,0)
    self.originPos = Vec3.New(0,0,0)
end


function TrackPoint:Init(fight,pos, speedModify,streetIndex,pointIndex,roadLine,crossIndex,ingnoreCross)  
	self.fight = fight
	self.pos:SetA(pos)
	self.originPos:SetA(pos)
	self.crossIndex = crossIndex
	self.ingnoreCross = ingnoreCross
	self.roadLine = roadLine
	self.streetIndex = streetIndex
	self.pointIndex = pointIndex
	self.speedModify = speedModify
end


function TrackPoint:OnCache()
	self.crossIndex = nil
	self.streetIndex = nil
	self.fight.objectPool:Cache(TrackPoint,self)
end

function TrackPoint:__cache()
end

function TrackPoint:__delete()
end