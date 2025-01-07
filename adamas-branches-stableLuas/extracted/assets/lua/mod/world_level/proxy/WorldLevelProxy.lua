WorldLevelProxy = BaseClass("WorldLevelProxy",Proxy)

function WorldLevelProxy:__init()

end

function WorldLevelProxy:__InitProxy()
    self:BindMsg("adventure")
    self:BindMsg("world_level")
    self:BindMsg("world_level_upgrade")
    self:BindMsg("world_level_degrade")

end

function WorldLevelProxy:Recv_adventure(data)
    local rankInfo ={
        lev = data.lev,
        exp = data.exp
    }
	mod.WorldLevelCtrl:UpdatePlayerAdventure(rankInfo)
end

function WorldLevelProxy:Recv_world_level(data)
    mod.WorldLevelCtrl:UpdateWorldLevel(data.level, data.max_level);
end

function WorldLevelProxy:Send_world_level_upgrade()
    
end

function WorldLevelProxy:Send_world_level_degrade()
    
end