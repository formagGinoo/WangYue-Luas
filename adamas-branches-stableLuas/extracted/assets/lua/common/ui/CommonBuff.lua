CommonBuff = BaseClass("CommonBuff")

local _buffEffectType = FightEnum.BuffEffectType

function CommonBuff:__init()
    self.buff = nil
    self.object = nil
end

function CommonBuff:LoadBuff()

end

function CommonBuff:InitBuff(object, entity, buff, number)
    if not object or not buff then
        return
    end

    self.buff = buff
    self.object = object
    self.entity = entity
    self.buffConfig = buff.config
    self.buffCount = number
    self.isDebuff = BehaviorFunctions.CheckIsDebuff(self.entity.instanceId, self.buff.instanceId)

    self.object.object:GetComponent(Animator):Play("UI_CommonBuff_in")
    UtilsUI.SetHideCallBack(self.object.CommonBuff_out, self:ToFunc("HideBuff"))
    self:SetBuff()
    self:BindListener()

    return self
end

function CommonBuff:BindListener()
    EventMgr.Instance:AddListener(EventName.UIBuffValueChange, self:ToFunc("BuffValueChange"))
end

function CommonBuff:RemoveListener()
    EventMgr.Instance:RemoveListener(EventName.UIBuffValueChange, self:ToFunc("BuffValueChange"))
end

-- 先把所有显隐的事情做了
function CommonBuff:SetBuff()
    UtilsUI.SetActive(self.object.Buff, not self.isDebuff)
    UtilsUI.SetActive(self.object.Debuff, self.isDebuff)
    UtilsUI.SetActive(self.object.Element, self.buffConfig.Type == FightEnum.BuffType.Accumulate)
    UtilsUI.SetActive(self.object.CountDown, self.buffConfig.Type == FightEnum.BuffType.CountDown)
    UtilsUI.SetActive(self.object.BuffNum, self.buffConfig.isShowNum)
    UtilsUI.SetActive(self.object.DebuffNum, self.buffConfig.isShowNum)

    self:SetBuffNum(self.buffCount)
    self:SetBuffIcon()
    self:SetBuffElement()
    self:SetBuffInfo()
end

function CommonBuff:SetBuffNum(number)
    if not self.buffConfig.isShowNum then
        return
    end
    
    local txt = self.isDebuff and self.object.DebuffNum_txt or self.object.BuffNum_txt
    UtilsUI.SetActive(txt.gameObject, number > 1)
    txt.text = number
end

function CommonBuff:SetBuffIcon(forcePath)
    local iconObj = self.isDebuff and self.object.DebuffIcon or self.object.BuffIcon
    SingleIconLoader.Load(iconObj, self.buffConfig.buffIconPath)
end

function CommonBuff:SetBuffElement(forceElement)
    if self.buffConfig.Type == FightEnum.BuffType.Normal then
        return
    end

    local isAccValue = self.buffConfig.Type == FightEnum.BuffType.Accumulate
    local elementIcon = isAccValue and self.object.ElementIcon
    if elementIcon then
        local elementPath = CommonBuff:GetElementBgIconPath(self.buffConfig.elementType)
        SingleIconLoader.Load(elementIcon, elementPath)
    end
end

function CommonBuff:GetElementIconPath(element)
    return string.format("Textures/Icon/Single/ElementIcon/buffElement%s.png", element)
end

function CommonBuff:GetElementCDIconPath(element)
    return string.format("Textures/Icon/Single/ElementIcon/buffCD%s.png", element)
end

function CommonBuff:GetElementBgIconPath(element)
    return string.format("Textures/Icon/Single/ElementIcon/buffBg_%s.png", element)
end

function CommonBuff:SetBuffInfo(buffConfig) 
    local yscale = self.isDebuff and 1 or -1
    if self.buffConfig.Type == FightEnum.BuffType.Accumulate then
        local fillOrigin = UIDefine.FillOrigin[UIDefine.FillMethod.Horizontal].Bottom

        self.object.ElementIcon_img.fillOrigin = fillOrigin
        self.object.ElementIcon_img.fillAmount = 0
    elseif self.buffConfig.Type == FightEnum.BuffType.CountDown then
        local xscale = self.isDebuff and -1 or 1
        local fillOrigin = UIDefine.FillOrigin[UIDefine.FillMethod.Radial360].Button
        self.object.CountDownElementCDIcon_img.fillOrigin = fillOrigin
        self.object.CountDownElementCDIcon_img.fillAmount = 1
    end
end

function CommonBuff:BuffValueChange(entity, buff)
    if self.buffConfig.Type ~= FightEnum.BuffType.Accumulate then
        return
    end

    if entity.instanceId ~= self.entity.instanceId or buff.instanceId ~= self.buff.instanceId then
        return
    end

    local percent = self.buff.curAccumulateValue / self.buffConfig.NeedValue
    self.object.ElementIcon_img.fillAmount = percent
end

function CommonBuff:Update()
    if self.buffConfig.Type == FightEnum.BuffType.CountDown then
        self.object.CountDownElementCDIcon_img.fillAmount = self.buff.durationFrame / self.buff.configDuration
    end
    if self.buffConfig.Type == FightEnum.BuffType.Accumulate then
        self.object.ElementIcon_img.fillAmount = 1 - (self.buff.durationFrame / self.buff.configDuration)
    end
end

function CommonBuff:HideBuff()
    if self.resetTimmer then
        LuaTimerManager.Instance:RemoveTimer(self.resetTimmer)
    end
    if not self.buff then
        UtilsUI.SetActive(self.object.object, false)
    end
end

function CommonBuff:Reset()
    self.resetTimmer = LuaTimerManager.Instance:AddTimer(1,1.2,self:ToFunc("HideBuff"))
    self.entity = nil
    self.buff = nil
    self.buffConfig = nil
    self.isDebuff = false
	self:RemoveListener()
end

function CommonBuff:__cache()
    self:RemoveListener()
end

function CommonBuff:__delete()
    self:RemoveListener()
end