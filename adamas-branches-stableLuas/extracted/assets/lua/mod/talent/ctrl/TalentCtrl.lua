TalentCtrl = BaseClass("TalentCtrl", Controller)

function TalentCtrl:__init()
    self.talentList = {}
end

function TalentCtrl:__delete()
    self.talentList = {}
end

function TalentCtrl:__InitComplete()

end

function TalentCtrl:UpdateTalentsList(talentList)
    -- key:talent_id 
    -- value:level
    for k, v in pairs(talentList) do
        local type = TalentConfig.GetTalentInfoById(v.key).type
        if not self.talentList[type] then
            self.talentList[type] = TalentConfig.GetTalentListByType(type)
        end
        self.talentList[type][v.key].lv = v.value
        EventMgr.Instance:Fire(EventName.UpdateTalentData, type, v.key, v.value)
    end
end

function TalentCtrl:GetTalentListByType(TalentType)
    if self.talentList[TalentType] then
        return self.talentList[TalentType]
    end
    self.talentList[TalentType] = TalentConfig.GetTalentListByType(TalentType)
    return self.talentList[TalentType]
end

-- 当前已点等级
function TalentCtrl:GetTalentLvByType(type)
    if not self.talentList[type] then
        return 0
    end
    local num = 0
    for k, v in pairs(self.talentList[type]) do
        if v.lv then
            num = num + v.lv
        end
    end
    return num
end

function TalentCtrl:GetAllTalentLev()
    local count = 0
    for type, value in pairs(self.talentList) do
        count = count + self:GetTalentLvByType(type)
    end
    return count
end

function TalentCtrl:GetTalentLv(talentId)
    local type = TalentConfig.GetTalentInfoById(talentId).type
    return( self.talentList[type] and self.talentList[type][talentId]) and self.talentList[type][talentId].lv or 0
end

function TalentCtrl:GetAllTalent()
    return self.talentList
end

function TalentCtrl:TalentLevelUp(talentId)
    local id, cmd = mod.TalentFacade:SendMsg("talent_lev_up", talentId)
    CurtainManager.Instance:EnterWait()
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function()
        CurtainManager.Instance:ExitWait()
    end)
end

function TalentCtrl:SetCurWindowLayer()
    self.windowLayer = WindowManager.Instance:GetCurOrderLayer() + 1
end

function TalentCtrl:GetCurWindowLayer()
    if not self.windowLayer then
		self.windowLayer = WindowManager.Instance:GetCurOrderLayer() + 1
	end
    return self.windowLayer
end

