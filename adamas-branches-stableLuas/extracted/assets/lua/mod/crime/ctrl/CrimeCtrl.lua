CrimeCtrl = BaseClass("CrimeCtrl", Controller)

function CrimeCtrl:__init()
    self.bountyMap = {}
    self.bountyValue = 0    -- 悬赏值（非坐牢状态）
    self.prisonBountyValue = 0  -- 悬赏值（坐牢状态）
    self.bountyStar = 0
    self.state = 0          -- 0不在坐牢，1坐牢
    self.finishGame = {}    -- 已完成的小游戏
    self.prisonTime = 0
    self.prisonId = 0
    self.countdownPanel = nil
end

function CrimeCtrl:UpdataBounty(info)
    local value = 0
    self.bountyMap = {}
    for k, v in pairs(info) do
        self.bountyMap[k] = v
        value = value + v
    end
    self.bountyValue = value
    local star = CrimeConfig.GetBountyStar(self.bountyValue)
    if star ~= self.bountyStar then
        self.bountyStar = star 
    end
    --EventMgr.Instance:Fire(EventName.OnBountyValueChange)
end

function CrimeCtrl:AddBounty(type)  
    local id,cmd = mod.CrimeFacade:SendMsg("crime_add_bounty",type)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function (ERRORCODE)
        if ERRORCODE == 0 then
            local addVal = CrimeConfig.GetBountyValueByType(type)
            self.bountyValue = self.bountyValue + addVal
            self.bountyStar = CrimeConfig.GetBountyStar(self.bountyValue)
            self.bountyMap[type] = self.bountyMap[type] and self.bountyMap[type] + addVal or addVal
            PanelManager.Instance:OpenPanel(CrimeAddTipPanel,{type = type})
            EventMgr.Instance:Fire(EventName.OnBountyValueChange)
        end
    end)
end

function CrimeCtrl:GetBountyStar()
    return self.bountyStar
end

function CrimeCtrl:GetBountyValue()
    if self.state == 0 then
        return self.bountyValue
    elseif self.state == 1 then
        return self.prisonBountyValue
    end
    return self.bountyValue
end

function CrimeCtrl:UpdataPrisonInfo(data)
    if data.state then
        self.state = data.state
    end
    if data.prison_id then
        self.prisonId = data.prison_id
    end
    if data.bounty_value then
        self.prisonBountyValue = data.bounty_value
        self.prisonTime = self.prisonBountyValue/self:GetBountyReduceSpeed()
        EventMgr.Instance:Fire(EventName.OnBountyValueChange)
    end
    if data.finish_game then
        for _, v in ipairs(data.finish_game) do
            self.finishGame[v] = true
        end
    end
end

function CrimeCtrl:GetPrisonTime()
    return self.prisonTime
end

function CrimeCtrl:SetPrison(state,prisonId)
    self.state = state
    if self.state == 1 then
        self.prisonBountyValue = self.bountyValue
    end
    self.prisonId = prisonId
end

function CrimeCtrl:OutPrison()
    local id,cmd = mod.CrimeFacade:SendMsg("crime_prison_info",0,self.prisonId)
	mod.LoginCtrl:AddClientCmdEvent(id, cmd, function (ERRORCODE)
        if ERRORCODE == 0 then
			mod.CrimeCtrl:SetPrison(0,0)
            self.bountyMap = {}
            self.bountyValue = 0
            self.finishGame = {}
            if self.countdownPanel then
                PanelManager.Instance:ClosePanel(self.countdownPanel)
                self.countdownPanel = nil
            end
            EventMgr.Instance:Fire(EventName.OutPrison)
        end
    end)
end

function CrimeCtrl:CheckInPrison()
    return self.state == 1
end

function CrimeCtrl:CreatePrisonGameLevel()
    local levelMap = {}
    for k, v in pairs(self.bountyMap) do
        local levelList = CrimeConfig.GetLevelId(k,self.prisonId)
        for _, id in ipairs(levelList) do
            levelMap[id] = true
        end
    end
    for _, v in pairs(levelMap) do
        Fight.Instance.levelManager:CreateLevel(v)
    end
end

function CrimeCtrl:FinishPrisonGame(type)
    local id,cmd = mod.CrimeFacade:SendMsg("crime_prison_game_finish",type)
	mod.LoginCtrl:AddClientCmdEvent(id, cmd, function (ERRORCODE)
        if ERRORCODE == 0 then
			self.finishGame[type] = true
            self.prisonBountyValue = self.prisonBountyValue - CrimeConfig.GetPrisonGameReduce(type)
            if self.prisonBountyValue < 0 then self.prisonBountyValue = 0 end
        end
    end)
end

function CrimeCtrl:GetNearPrisonPos()
    local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	local pos = entity.transformComponent.position
	local minDis, targetPoint, targetId
	local mapId = Fight.Instance:GetFightMap()
	local mapConfig = mod.WorldMapCtrl:GetMapConfig(mapId)
	for k, v in ipairs(Config.DataPrison.Find) do
		if mapId == v.map_id then
			local prisonPointPos = BehaviorFunctions.GetTerrainPositionP(v.position[2],mapId,v.position[1])
			local dis = Vector3.Distance(prisonPointPos, pos)
			if not minDis or minDis > dis then
				minDis = dis
                targetId = k
				targetPoint = prisonPointPos
			end 
		end
	end

	return targetId,targetPoint
end

function CrimeCtrl:GetBountyReduceSpeed()
    if not self.prisonId or self.prisonId == 0 then 
        return 0
    end
    return CrimeConfig.GetPrisonConfig(self.prisonId).online_reduce
end

function CrimeCtrl:GetBountyReduceProgress()
    if self.bountyValue == 0 then return 0 end
    return self.prisonBountyValue/self.bountyValue
end