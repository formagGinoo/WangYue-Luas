CommonBuff = BaseClass("CommonBuff")

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
    UnityUtils.SetActive(self.object.Buff, not self.buffConfig.isDebuff)
    UnityUtils.SetActive(self.object.Debuff, self.buffConfig.isDebuff)
    UnityUtils.SetActive(self.object.Element, self.buffConfig.Type == FightEnum.BuffType.Accumulate)
    UnityUtils.SetActive(self.object.CountDown, self.buffConfig.Type == FightEnum.BuffType.CountDown)
    UnityUtils.SetActive(self.object.BuffBack, self.buffConfig.Type == FightEnum.BuffType.Normal)
    UnityUtils.SetActive(self.object.DebuffBack, self.buffConfig.Type == FightEnum.BuffType.Normal)
    UnityUtils.SetActive(self.object.BuffNum, self.buffConfig.isShowNum)
    UnityUtils.SetActive(self.object.DebuffNum, self.buffConfig.isShowNum)

    self:SetBuffNum(self.buffCount)
    self:SetBuffIcon()
    self:SetBuffElement()
    self:SetBuffInfo()
end

function CommonBuff:SetBuffNum(number)
    if not self.buffConfig.isShowNum then
        return
    end

    local txt = self.buffConfig.isDebuff and self.object.DebuffNum_txt or self.object.BuffNum_txt
    txt.text = number
end

function CommonBuff:SetBuffIcon(forcePath)
    local iconObj = self.buffConfig.isDebuff and self.object.DebuffIcon or self.object.BuffIcon
    SingleIconLoader.Load(iconObj, self.buffConfig.buffIconPath)
end

function CommonBuff:SetBuffElement(forceElement)
    if self.buffConfig.Type == FightEnum.BuffType.Normal then
        return
    end

    local isAccValue = self.buffConfig.Type == FightEnum.BuffType.Accumulate
    local elementIcon = isAccValue and self.object.ElementIcon or self.object.ElementCDIcon
    local elementPath = isAccValue and self:GetElementIconPath(self.buffConfig.elementType) or self:GetElementCDIconPath(self.buffConfig.elementType)
    SingleIconLoader.Load(elementIcon, elementPath)
end

function CommonBuff:GetElementIconPath(element)
    return string.format("Textures/Icon/Single/ElementIcon/buffElement%s.png", element)
end

function CommonBuff:GetElementCDIconPath(element)
    return string.format("Textures/Icon/Single/ElementIcon/buffCD%s.png", element)
end

function CommonBuff:SetBuffInfo(buffConfig)
    local yscale = self.buffConfig.isDebuff and 1 or -1
    if self.buffConfig.Type == FightEnum.BuffType.Accumulate then
        local fillOrigin = self.buffConfig.isDebuff and UIDefine.FillOrigin[UIDefine.FillMethod.Horizontal].Bottom or UIDefine.FillOrigin[UIDefine.FillMethod.Horizontal].Top
        self.object.ElementIcon_img.fillOrigin = fillOrigin
        self.object.ElementIcon_img.fillAmount = 0
        UnityUtils.SetLocalScale(self.object.Element.transform, 1, yscale, 1)
    elseif self.buffConfig.Type == FightEnum.BuffType.CountDown then
        local xscale = self.buffConfig.isDebuff and -1 or 1
        local fillOrigin = self.buffConfig.isDebuff and UIDefine.FillOrigin[UIDefine.FillMethod.Radial360].Top or UIDefine.FillOrigin[UIDefine.FillMethod.Radial360].Bottom
        self.object.ElementCDIcon_img.fillOrigin = fillOrigin
        self.object.ElementCDIcon_img.fillAmount = 1
        UnityUtils.SetLocalScale(self.object.CountDown.transform, xscale, yscale, 1)
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
        self.object.ElementCDIcon_img.fillAmount = self.buff.durationFrame / self.buffConfig.DurationFrame
    end
end

function CommonBuff:Reset()
    self.entity = nil
    self.buff = nil
    self.buffConfig = nil
	self:RemoveListener()
end

function CommonBuff:__cache()
    self:RemoveListener()
end

function CommonBuff:__delete()
    self:RemoveListener()
end