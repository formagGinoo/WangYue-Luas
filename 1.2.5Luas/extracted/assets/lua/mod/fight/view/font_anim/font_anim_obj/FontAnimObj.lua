
FontAnimObj = BaseClass("FontAnimObj",PoolBaseClass)

local _random = math.random
local _floor = math.floor
local FightConfig = Config.FightConfig
local LastRangePos = Vec3.New()
local OffsetPos = Vec3.New()

function FontAnimObj:__init()
    self.clientFight = Fight.Instance.clientFight
    self.fontAnimManager = self.clientFight.fontAnimManager
    self.parent = self.fontAnimManager.fontRootTrans
    self.fight = Fight.Instance

    --子类覆盖预设路径
    self.path ="Prefabs/UI/Font/dmg_type1.prefab"
end

function FontAnimObj:_delete()
    if not UtilsBase.IsNull(self.gameObject) then
		GameObject.Destroy(self.gameObject)
    end

    if self.timer then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
        self.timer = nil
    end
end

function FontAnimObj:__cache()
    if self.timer then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
        self.timer = nil
    end

    self.DistanceScaler.enabled = false
    self.canvasGroup.alpha = 0
    self.animator.enabled = false
end

function FontAnimObj:LoadAsset()
    if not self.path then
        return
    end
    self.gameObject = self.clientFight.assetsPool:Get(self.path)
    self.DistanceScaler = self.gameObject:GetComponent(DistanceScaler)
    self.canvasGroup = self.gameObject:GetComponent(CanvasGroup)

    self.gameObjectTrans = self.gameObject.transform
    self.gameObjectTrans:SetParent(self.parent)
    self.fontGameObject = self.gameObjectTrans:Find("dmg_text")
    self.fontGameObjectText = self.fontGameObject:GetComponent(Text)
    self.animator = self.fontGameObject:GetComponent(Animator)
    self.fontCanvasGroup = self.fontGameObject:GetComponent(CanvasGroup)
end

function FontAnimObj:PlayAnimation(npc, fontType, text, isCirt, isRestriction, attachPoint, flyPosition)
	local animInfo = FightConfig.FontInfo[fontType]
    if not animInfo then
        LogError("animInfo null fontType "..fontType)
        return
    end

    if not self.gameObject then
        self:LoadAsset()
    end

    self.canvasGroup.alpha = 1
    self.fontCanvasGroup.alpha = 1
    self.DistanceScaler.enabled = true
    self.animator.enabled = true

    local position = flyPosition
    if not position then
        attachPoint = animInfo.point
    	local bindTrans = npc.clientEntity.clientTransformComponent:GetTransform(attachPoint)
        if not bindTrans then
            LogError("找不到字体挂点 -》"..attachPoint)
            return
        end
        position = bindTrans.position
    end
 
    local isPlayer = npc.attrComponent.playerNpcTag
    local rangePosType = FightConfig.FontRangePosType.PlayerDecHp
    if type(text) == "number" then
        if text < 0 then
            rangePosType = FightConfig.FontRangePosType.AddHp
        else
            if not isPlayer then
                rangePosType = FightConfig.FontRangePosType.MonsterDecHp
            end
        end
    end

    self.configRangePosInfo = FightConfig.FontRangePos[rangePosType]
    self.configPosOffset = FightConfig.FontOffsetPos[rangePosType]
    OffsetPos:SetA(FightConfig.FontOffsetPos[rangePosType]) 
    self.rotation = npc.transformComponent.rotation
    self:RandomRangePos(position, 0)

    local animName
    if isCirt then
        text = "b"..text
        animName = "pz_02"
    else
        if isPlayer then
            animName = "pz_03"
        else
            animName = "pz_01"
        end
    end

    self.fontGameObjectText.text = text
    self.animator:Play(animName, 0, 0)

    self.timer = LuaTimerManager.Instance:AddTimer(1, 2, self:ToFunc("PlayAnimationEnd"))
end

function FontAnimObj:PlayEffectAnimation(npc, effectFontType, attachPoint)

end

function FontAnimObj:RandomRangePos(position, count)
    OffsetPos.x = self.configPosOffset.x + _random(self.configRangePosInfo.rangeMinX, self.configRangePosInfo.rangeMaxX) * 0.01
    OffsetPos.y = self.configPosOffset.y + _random(self.configRangePosInfo.rangeMinY, self.configRangePosInfo.rangeMaxY) * 0.01
    OffsetPos = OffsetPos * self.rotation

    local x = position.x + OffsetPos.x
    local y = position.y + OffsetPos.y
    local z = position.z + OffsetPos.z

    local distance = (x -LastRangePos.x) ^ 2 + (y - LastRangePos.y) ^ 2 + (z - LastRangePos.z) ^ 2
    if distance < FightConfig.FontMinDistance and count < 5 then
        count = count + 1
        self:RandomRangePos(position, count)
        return
    end

    LastRangePos:Set(x, y, z)
    UnityUtils.SetPosition(self.gameObjectTrans, x, y, z)
end

function FontAnimObj:PlayAnimationEnd()
    if self.timer then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
        self.timer = nil
    end
    
    self.fontAnimManager:PlayAnimationEnd(self)
end

function FontAnimObj:OnCache()

end


