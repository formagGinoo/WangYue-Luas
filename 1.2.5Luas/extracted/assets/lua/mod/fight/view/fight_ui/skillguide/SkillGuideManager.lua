SkillGuideManager = SingleClass("SkillGuideManager")

local skillGuideCfg = Config.DataTips.data_skill_guide
local skillGuideCfgLen = Config.DataTips.data_skill_guide_length

function SkillGuideManager:__init(clientFight)
    self.clientFight = clientFight
    self.fight = clientFight.fight

    self.saveCfgs = {}
    self.window = nil
end

function SkillGuideManager:__delete()
    if self.window and next(self.window) then
        self.window:Destroy()
    end
end

function SkillGuideManager:Update()
    if not self.window or not next(self.window) or not self.window.active then
        return
    end

	if self.window.totalState == FightEnum.SkillGuideState.Succeeded then
		self.window:Hide()
		return
	end
	
    self.window:Update(self.fight)
end

function SkillGuideManager:ShowGuide(groupId, forceStep)
    local config = self:GetConfig(groupId)
    if not self.window or not next(self.window) then
        self.window = SkillGuideWindow.New()
        self.window:SetParent(UIDefine.canvasRoot.transform)
    end

    self.window:Show({config = config, forceStep = forceStep})
end

function SkillGuideManager:StopGuide()
    if not self.window then
        return
    end

    self.window:Destroy()
end

function SkillGuideManager:GetConfig(groupId)
    if self.saveCfgs[groupId] and next(self.saveCfgs[groupId]) then
        return self.saveCfgs[groupId]
    end

    local cfgs = {}
    for i = 1, skillGuideCfgLen do
        local key = string.format("%s_%s", groupId, i)
        if skillGuideCfg[key] then
            cfgs[i] = skillGuideCfg[key]
        else
            break;
        end
    end

    self.saveCfgs[groupId] = cfgs

    return cfgs
end

function SkillGuideManager:SetCurSkill(skillId)
    if not self.window then
        return
    end

    self.window.curSkillId = skillId
end

function SkillGuideManager:GetCurStep()
    if not self.window then
        return 0
    end

    return self.window.curStep
end

function SkillGuideManager:GetTotalState()
    if not self.window then
        return FightEnum.SkillGuideState.Waiting
    end

    return self.window.totalState
end

function SkillGuideManager:GetCurStepState()
    if not self.window or not self.window:GetStep() then
        return
    end

    local step = self.window:GetStep()
    return step.state
end

function SkillGuideManager:ChangeStepState(state, index)
    if not self.window then
        return
    end

    local step = self.window:GetStep(index)
    step.state = state
end

function SkillGuideManager:ResetWindow()
    if not self.window then
        return
    end

    self.window:ResetGuide()
end

function SkillGuideManager:ForceSetStep(groupStep)
    if not self.window then
        return
    end

    self.window:ForceSetStep(groupStep)
end