SkillGuideWindow = BaseClass("SkillGuideWindow", BaseWindow)

function SkillGuideWindow:__init()
    self:SetAsset("Prefabs/UI/Guide/SkillGuide.prefab")

    self.guideObjs = {}
    self.steps = {}
    self.curStep = 0
    self.waitFrame = 0
    self.pressFrame = 0
    self.successFrame = 0
    self.curSkillId = 0
    self.curConfig = nil
    self.totalState = FightEnum.SkillGuideState.Processing
end

function SkillGuideWindow:__BindEvent()

end

function SkillGuideWindow:__delete()
    if self.sequence then
        self.sequence:Kill()
        self.sequence = nil
    end

    self:ResetGuide()
    self.waitFrame = 0
    self.pressFrame = 0
    self.successFrame = 0
end

function SkillGuideWindow:__Hide()
    if self.sequence then
        self.sequence:Kill()
        self.sequence = nil
    end

    self:ResetGuide()
    self.waitFrame = 0
    self.pressFrame = 0
    self.successFrame = 0
end

function SkillGuideWindow:__Show()
    if self.cacheMode == UIDefine.CacheMode.destroy then
        self:SetCacheMode(UIDefine.CacheMode.hide)
    end
    
    if not self.guideObjs or not next(self.guideObjs) then
        self:InitGuideObjs()
    end

    local showStep = self.args.forceStep and self.args.forceStep or 1
    for i = 1, #self.args.config do
        self.steps[i] = { config = self.args.config[i], state = FightEnum.SkillGuideState.Waiting }
    end

    self.sequence = DOTween.Sequence()
    self.sequence:Append(self.Content.transform:DOLocalMoveX(#self.steps > 6 and -350 or 0, 0.1))
    self:RefreshSteps(false, showStep)
    -- UnityUtils.SetLocalPosition(self.Content.transform, #self.steps > 6 and -350 or 0, -76.5, 0)

    self.Content:SetActive(true)
    self.Completed:SetActive(false)
end

function SkillGuideWindow:__ShowComplete()
    self:InitSteps()
end

--#region Initialize SkillGuide Object And Info
function SkillGuideWindow:InitGuideObjs()
    for i = 1, self.Content.transform.childCount do
        local singleGuide = {}
        singleGuide.transform = self.Content.transform:GetChild(i - 1)
        local uiContainer = singleGuide.transform:GetComponent(UIContainer)
        if uiContainer then
            local listName = uiContainer.ListName
			local listObjects = uiContainer.ListObj

			local listCompName = uiContainer.ListCompName
			local listCompObjects = uiContainer.ListComponent

			for i = 0, listName.Count - 1 do
				local name = listName[i]
				singleGuide[name] = listObjects[i]
			end

			for i = 0, listCompName.Count - 1 do
				local name = listCompName[i]
				singleGuide[name] = listCompObjects[i]
			end
		end

        self.guideObjs[i] = singleGuide
    end
end

function SkillGuideWindow:InitSteps()
    for i = 1, #self.steps do
        if i > 6 then
            UnityUtils.SetPivot(self.Content.transform, 0, 0.5)
        else
            UnityUtils.SetPivot(self.Content.transform, 0.5, 0.5)
        end

        self:LoadSingleGuide(i)
    end
end

function SkillGuideWindow:LoadSingleGuide(stepIndex)
    local config = self.steps[stepIndex].config
    local guideObj = self.guideObjs[stepIndex]

    guideObj.transform:SetActive(config and next(config))
    if not config or not next(config) then
        return
    end

    guideObj.Desc_txt.text = config.key_desc
    guideObj.TypeDesc_txt.text = FightEnum.SkillGuideTypeDesc[config.guide_type]
    guideObj.TypeArea:SetActive(FightEnum.SkillGuideTypeDesc[config.guide_type] ~= "")

    local path = ""
    guideObj.SkillIcon:SetActive(config.skill_icon ~= "")
    guideObj.AttackIcon:SetActive(config.attack_icon ~= "")
    if config.skill_icon ~= "" then
        path = AssetConfig.GetSkillIcon(config.skill_icon)
        SingleIconLoader.Load(guideObj.SkillIcon, path)
    elseif config.attack_icon ~= "" then
        path = AssetConfig.GetSkillIcon(config.attack_icon)
        SingleIconLoader.Load(guideObj.AttackIcon, path)
    end

    guideObj.Failed:SetActive(false)
    guideObj.Succeed:SetActive(false)
    guideObj.Filled:SetActive(config.guide_type == FightEnum.SkillGuideType.Press)
    guideObj.Progress_img.fillAmount = 0
end
--#endregion

function SkillGuideWindow:Update(fight)
    if not self.steps or not next(self.steps) then
        return
    end

    if self.steps[self.curStep].state == FightEnum.SkillGuideState.Failed then
        self.totalState = FightEnum.SkillGuideState.Failed
        return
    end

    if not self.curConfig then
        self.curConfig = self.steps[self.curStep].config
    end

	if self:CheckIsGuidePass() then
        if self.successFrame == 30 then
            self.Content:SetActive(false)
            self.Completed:SetActive(true)
        elseif self.successFrame == 100 then
		    self.totalState = FightEnum.SkillGuideState.Succeeded
        end

        self.successFrame = self.successFrame + 1
		return
	end

    local isPass, isWait = self:CheckIsOperaPass(fight)
    if not isPass then
        local isFail = self.curConfig.is_must and not isWait
        if isFail then
            self.guideObjs[self.curStep].Wait:SetActive(false)
            self.guideObjs[self.curStep].Failed:SetActive(true)
            self.steps[self.curStep].state = FightEnum.SkillGuideState.Failed
            return
        end

        self.waitFrame = self.waitFrame + 1
        if self.waitFrame >= self.curConfig.wait_frame and self.curConfig.wait_frame > 0 then
            self.guideObjs[self.curStep].Wait:SetActive(false)
            self.guideObjs[self.curStep].Failed:SetActive(true)
            self.steps[self.curStep].state = FightEnum.SkillGuideState.Failed
			self.waitFrame = 0
            return
        end

        if self.curConfig.guide_type == FightEnum.SkillGuideType.Press then
            if fight.operationManager:CheckKeyDown(FightEnum.SkillBtn2Event[self.curConfig.press_key]) then
                self.pressFrame = self.pressFrame + 1
            else
                self.pressFrame = 0
            end
            self:RefreshSteps()
        end

        return
    end

    -- 按对了之后需要做些什么
    local isSucceeded = self.curConfig.guide_type ~= FightEnum.SkillGuideType.Press or self.pressFrame >= self.curConfig.press_frame
    if isSucceeded then
        -- 首先检查一下是不是整个通过了 通过了就显示完成
        self.pressFrame = 0
        self.steps[self.curStep].state = FightEnum.SkillGuideState.Succeeded
        if self.curStep <= #self.steps then
            self.guideObjs[self.curStep].Wait:SetActive(false)
            self.guideObjs[self.curStep].Succeed:SetActive(true)
		
			if self.curStep < #self.steps then
            	self:RefreshSteps(#self.steps > 6 and self.curStep > 3 or false, self.curStep + 1)
			end
        end
    else
        self.pressFrame = self.pressFrame + 1
        self:RefreshSteps()
    end
end

function SkillGuideWindow:RefreshSteps(move, moveIndex)
    if moveIndex then
        if move then
            local diffIndex = moveIndex - self.curStep
            local moveX = diffIndex > 0 and (-118 * diffIndex) or 118 * diffIndex
            local position = self.Content.transform.localPosition
            self.sequence:Append(self.Content.transform:DOLocalMoveX(position.x + moveX, 0.1))
        end

        self.curStep = moveIndex
        self.curConfig = self.steps[moveIndex].config
        self.steps[moveIndex].state = FightEnum.SkillGuideState.Processing
        self.guideObjs[moveIndex].Wait:SetActive(true)
        self.guideObjs[moveIndex].Click:SetActive(self.curConfig.guide_type == FightEnum.SkillGuideType.Click)
        self.guideObjs[moveIndex].Press:SetActive(self.curConfig.guide_type == FightEnum.SkillGuideType.Press)
        self.guideObjs[moveIndex].CrazyPush:SetActive(self.curConfig.guide_type == FightEnum.SkillGuideType.CrazyPush)
    else
        self.guideObjs[self.curStep].Progress_img.fillAmount = self.pressFrame / self.curConfig.press_frame
    end
end

function SkillGuideWindow:ResetGuide()
    for i = 1, #self.steps do
        self.steps[i].state = (i == 1) and FightEnum.SkillGuideState.Processing or FightEnum.SkillGuideState.Waiting
        self.guideObjs[i].Succeed:SetActive(false)
        self.guideObjs[i].Failed:SetActive(false)
        self.guideObjs[i].Progress_img.fillAmount = 0
    end

    self:RefreshSteps(false, 1)
    self.Content:SetActive(true)
    self.Completed:SetActive(false)
    self.totalState = FightEnum.SkillGuideState.Processing
    UnityUtils.SetLocalPosition(self.Content.transform, #self.steps > 6 and -350 or 0, -76.5, 0)
end

function SkillGuideWindow:CheckIsOperaPass(fight)
    if not self.curSkillId or self.curSkillId == 0 then
        return false, true
    end

	self.waitFrame = 0
    for k, v in pairs(self.curConfig.skill_ids) do
        if self.curSkillId == v then
            self.curSkillId = 0
            return true, false
        end
    end

    self.curSkillId = 0
    return false, false
end

function SkillGuideWindow:CheckIsGuidePass()
    for i = 1, #self.steps do
        if self.steps[i].state ~= FightEnum.SkillGuideState.Succeeded then
            return false
        end
    end

    return true
end

function SkillGuideWindow:GetStep(index)
    if not self.steps or not next(self.steps) then
        return
    end

    if not index then
        return self.steps[self.curStep]
    else
        return self.steps[index]
    end
end