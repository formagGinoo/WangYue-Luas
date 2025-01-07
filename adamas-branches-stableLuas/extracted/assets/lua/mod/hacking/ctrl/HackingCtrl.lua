---@class HackingCtrl
HackingCtrl = BaseClass("HackingCtrl", Controller)

function HackingCtrl:__init()
    self.tmprecodeNpc = {}
end

function HackingCtrl:OnEnterMap()

end

function HackingCtrl:__InitComplete()
end


function HackingCtrl:AddRecode(instanceId)
    self.tmprecodeNpc[instanceId] = true
end