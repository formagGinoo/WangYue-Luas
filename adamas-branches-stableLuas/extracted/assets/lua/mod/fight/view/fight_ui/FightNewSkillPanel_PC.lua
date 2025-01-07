FightNewSkillPanel_PC = BaseClass("FightNewSkillPanel_PC", FightNewSkillPanel)
function FightNewSkillPanel_PC:__Show()
    self:BaseFunc("__Show")
    self.nowState = FightEnum.JumpType.Jump
	self.updateFrame = Application.targetFrameRate / 10
    self.remainUpdateFrame = 0
end

function FightNewSkillPanel_PC:__delete()
    self:BaseFunc("__delete")
end

function FightNewSkillPanel_PC:UpdatePlayerSkillList()
    self:BaseFunc("UpdatePlayerSkillList")
    self:ResetSkillGroupLayout()
    self:CheckJumpIconState()
end

function FightNewSkillPanel_PC:Update()
    self:BaseFunc("Update")
    self.remainUpdateFrame = self.remainUpdateFrame - 1
    if self.remainUpdateFrame <= 0 then
        self.remainUpdateFrame = self.updateFrame
        self:ResetSkillGroupLayout()
    end
end

function FightNewSkillPanel_PC:UpdateUltimateSkillBtnActive()
    self:BaseFunc("UpdateUltimateSkillBtnActive")
    self:ResetSkillGroupLayout()
    self:CheckJumpIconState()
end

function FightNewSkillPanel_PC:ChangeButtonConfig(instanceId,keyEvent)
    self:BaseFunc("ChangeButtonConfig", instanceId,keyEvent)
    self:ResetSkillGroupLayout()
    self:CheckJumpIconState()
end

FightNewSkillPanel_PC.Offset = 
{
    [FightEnum.KeyEvent2Btn[FightEnum.KeyEvent.UltimateSkill]] = 20,
}
function FightNewSkillPanel_PC:ResetSkillGroupLayout()
    local width = 0
    for i = 0, self.SkillGroup.transform.childCount - 1, 1 do
        local btnName = self.SkillGroup.transform.gameObject.transform:GetChild(i).name
        btnName = string.gsub(btnName, "_", "")
        local config = self.skillSetComponent:GetConfigByBtnName(btnName)
        if config and self.btns[btnName] then
            if self.btns[btnName].BtnBody.activeInHierarchy == true then
                UnityUtils.SetAnchoredPosition(self.btns[btnName].transform, - width, self.btns[btnName].transform.anchoredPosition.y)
                local offset = self.Offset[btnName] or 0
                width = width + self.btns[btnName].transform.rect.width * self.btns[btnName].transform.localScale.x + offset
            end
        end
    end
end

function FightNewSkillPanel_PC:CheckJumpIconState()
    UtilsUI.SetActive(self.btns["O"].BtnBody, not (self.nowState == FightEnum.JumpType.Jump or self.nowState == FightEnum.JumpType.JumpDouble))
end

function FightNewSkillPanel_PC:OnJumpIconChange(state, force)
    self:CheckJumpIconState()
    if state == self.nowState and not force then
        return
    end
    self.nowState = state
    if state == FightEnum.JumpType.Glide then
        self:DisableButtonStateChange(true)
        AtlasIconLoader.Load(self.btns["O"].Icon, AssetConfig.GetBehaviorSkillIcon("Glide"))
    elseif state == FightEnum.JumpType.GlideCancel then
        self:DisableButtonStateChange(true)
        AtlasIconLoader.Load(self.btns["O"].Icon, AssetConfig.GetBehaviorSkillIcon("GlideCancel"))
    else
        self:DisableButtonStateChange(false)
    end
end