EffectTypeFontAnimObj = BaseClass("EffectTypeFontAnimObj",FontAnimObj)

local OffsetPos = Vec3.New()
local FightConfig = Config.FightConfig

function EffectTypeFontAnimObj:__init()
    self.path ="Prefabs/UI/Font/effect_type.prefab"
end

function EffectTypeFontAnimObj:OnCache()
    self.fight.objectPool:Cache(EffectTypeFontAnimObj, self)
end

function EffectTypeFontAnimObj:PlayEffectAnimation(npc, effectFontType, attachPoint)
	if not FightConfig then
		return
	end
    local animInfo = FightConfig.EffectFont[effectFontType]
    if not self.gameObject then
        self:LoadAsset()
    end

    self.canvasGroup.alpha = 1
    self.fontCanvasGroup.alpha = 1
    self.DistanceScaler.enabled = true
    self.fontGameObjectText.text = animInfo.name
    self.animator.enabled = true

    attachPoint = attachPoint or FightConfig.EffectFontPoint
    local bindTrans = npc.clientEntity.clientTransformComponent:GetTransform(attachPoint)
    if not bindTrans then
        LogError("找不到字体挂点 -》"..attachPoint, npc.entityId)
        self:PlayAnimationEnd()
        return
    end
    local position = bindTrans.position
    
    local isPlayer = npc.attrComponent.playerNpcTag
    local rangePosType = FightConfig.FontRangePosType.Effect
    self.configRangePosInfo = FightConfig.FontRangePos[rangePosType]
    self.configPosOffset = FightConfig.FontOffsetPos[rangePosType]
    OffsetPos:SetA(FightConfig.FontOffsetPos[rangePosType]) 
    self.rotation = npc.transformComponent.rotation
    self:RandomRangePos(position, 0)
    self.animator:Play("pz_02", 0, 0) 
    self.timer = LuaTimerManager.Instance:AddTimer(1, 2, self:ToFunc("PlayAnimationEnd"))
end