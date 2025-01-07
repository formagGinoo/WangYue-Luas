PartnerPoolMgr = BaseClass("PartnerPoolMgr")

function PartnerPoolMgr:__init(poolMgr ,roleMgr)
    self.poolMgr = poolMgr
end

function PartnerPoolMgr:LoadPartner(loadInfo, callBack, notCount)
    self.isLoading = true

    local oldInfo
    if self.loadInfo then
        oldInfo = TableUtils.CopyTable(self.loadInfo)
    end
    
    self.loadInfo = loadInfo

    if oldInfo and oldInfo.partnerId == loadInfo.partnerId then
        self:ReLoadSkills(oldInfo.skills, callBack)
        return
    end

    local loadCount = 1
    local onLoad = function ()
        loadCount = loadCount - 1
        if loadCount == 0 and callBack then
            callBack()
            if oldInfo then
                self:UnLoadPartner(oldInfo)
            end
            self.isLoading = false
        end
    end
    if loadInfo.skills then
        for index, skill in ipairs(loadInfo.skills) do
            local config = RoleConfig.GetPartnerSkillLevelConfig(skill.key, skill.value)
            if config and #config.fight_magic > 0 then
                loadCount = loadCount + 1
                self.poolMgr:LoadPartnerSkillPool(skill.key, skill.value, onLoad, notCount)
            end
        end
    end

    self.poolMgr:LoadEntityPool(loadInfo.partnerId, onLoad, false, notCount)
end

function PartnerPoolMgr:ReLoadSkills(skills, callBack)
    local loadInfo = self.loadInfo
    local loadCount = 1
    self.isLoading = true

    local oldSkills = loadInfo.skills or {}

    local onLoad = function ()
        loadCount = loadCount - 1
        if loadCount == 0 then
            if callBack then
                callBack()
                for _, skill in pairs(oldSkills) do
                    self.poolMgr:UnLoadPartnerSkillPool(skill.key, skill.value)
                end
                loadInfo.skills = skills
                self.isLoading = false
            end
        end
    end

    for _, skill in pairs(skills) do
        local config = RoleConfig.GetPartnerSkillLevelConfig(skill.key, skill.value)
        if config and #config.fight_magic > 0 then
            loadCount = loadCount + 1
            self.poolMgr:LoadPartnerSkillPool(skill.key, skill.value, onLoad)
        end
    end

    onLoad()
end

function PartnerPoolMgr:UnLoadPartner(info)
    local partnerInfo = info or self.loadInfo

    if not partnerInfo then
        return
    end

    if partnerInfo.partnerId then
        self.poolMgr:UnLoadEntityPool(partnerInfo.partnerId)
    end

    if partnerInfo.skills then
        for _, skill in pairs(partnerInfo.skills) do
            self.poolMgr:UnLoadPartnerSkillPool(skill.key, skill.value)
        end
    end

    if not info then
        self.loadInfo = nil
    end
end