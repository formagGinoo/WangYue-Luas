FontAnimManager = BaseClass("FontAnimManager")

local MaxFontShow = 15
local FightConfig = Config.FightConfig

function FontAnimManager:__init(clientFight)
	self.uniqueId = 0
	self.tipsMap = {}
	self.fontAnimMap = {}
	self.fontAnimStack = List.New()
	self.fight = Fight.Instance
	self.visible = true
	self.clientFight = clientFight
end

function FontAnimManager:StartFight()
	self.fontRoot = self.clientFight.assetsPool:Get("Prefabs/UI/Font/FontRoot.prefab")
	self.fontRootTrans = self.fontRoot.transform
	self.fontRootTrans:SetParent(self.clientFight.fightRootTrans)
end

function FontAnimManager:__delete()
	if self.fontAnimMap then
		for _, v in pairs(self.fontAnimMap) do
			v:DeleteMe()
		end
		self.fontAnimMap = nil
	end

	self.fontAnimStack:Clear()
end

function FontAnimManager:PlayEffectAnimation(npc, effectFontType, attachPoint)
	-- PV专用
	if DebugClientInvoke.Cache.closeUI == true then
		return
	end

	if not self.visible then
		return
	end

	self.uniqueId = self.uniqueId + 1

	local animInfo = FightConfig.EffectFont[effectFontType]
	if not animInfo then
		LogError("animInfo null fontType "..effectFontType)
		return
	end

	local fontAnimObj = self.fight.objectPool:Get(EffectTypeFontAnimObj)
	fontAnimObj.uniqueId = self.uniqueId
	self.fontAnimMap[self.uniqueId] = fontAnimObj
	fontAnimObj:PlayEffectAnimation(npc, effectFontType, attachPoint)

	self.fontAnimStack:Push(self.uniqueId)
	if self.fontAnimStack:Count() > MaxFontShow then
		local uniqueId = self.fontAnimStack:PopHead()
		self:PlayAnimationEnd(self.fontAnimMap[uniqueId])
	end
end

function FontAnimManager:PlayTipsAnimation(npc, tipsFontType, attachPoint)
	-- PV专用
	if DebugClientInvoke.Cache.closeUI == true then
		return
	end

	if not self.visible then
		return
	end

	self.uniqueId = self.uniqueId + 1
	local animInfo = FightConfig.TipsFont[tipsFontType]
	if not animInfo then
		LogError("animInfo null fontType "..tipsFontType)
		return
	end

	local fontAnimObj = self.fight.objectPool:Get(TipsTypeFontAnimObj)
	fontAnimObj.uniqueId = self.uniqueId
	self.fontAnimMap[self.uniqueId] = fontAnimObj
	fontAnimObj:PlayTipsAnimation(npc, tipsFontType, attachPoint)

end

function FontAnimManager:PlayAnimation(npc, fontType, text, isCirt, isRestriction, attachPoint, flyPosition)
	-- PV专用
	if DebugClientInvoke.Cache.closeUI == true then
		return
	end

	UnityUtils.BeginSample("FontAnimManager:PlayAnimation")
	if not self.visible then
		return
	end

	self.uniqueId = self.uniqueId + 1

	local animInfo = FightConfig.FontInfo[fontType]
	if not animInfo then
		LogError("元素类型的飘字不存在,检查下配置吧:"..fontType)
		return
	end

	local typeName = animInfo.className
	if isCirt and fontType ~= FightConfig.FontType.DAMAGE_TYPE1 then
		typeName = animInfo.wClassName
		if not typeName then
			typeName = animInfo.className
		end
	end

	local fontAnimObj = self.fight.objectPool:Get(typeName)
	fontAnimObj.uniqueId = self.uniqueId
	self.fontAnimMap[self.uniqueId] = fontAnimObj
	fontAnimObj:PlayAnimation(npc, fontType, text, isCirt, isRestriction, attachPoint, flyPosition)

	self.fontAnimStack:Push(self.uniqueId)
	if self.fontAnimStack:Count() > MaxFontShow then
		local uniqueId = self.fontAnimStack:PopHead()
		self:PlayAnimationEnd(self.fontAnimMap[uniqueId])
	end
	UnityUtils.EndSample()
end

function FontAnimManager:Update()
	for k, v in pairs(self.fontAnimMap) do
		v:Update()
	end
end

function FontAnimManager:PlayTipsAnimationEnd()
	
end

function FontAnimManager:PlayAnimationEnd(fontAnimObj)
	if not fontAnimObj then
		return
	end
	if self.fontAnimMap[fontAnimObj.uniqueId] then
		self.fontAnimMap[fontAnimObj.uniqueId]:OnCache()
		self.fontAnimMap[fontAnimObj.uniqueId] = nil
		self.fontAnimStack:RemoveByValue(fontAnimObj.uniqueId)
		return
	end
	LogError("飘字资源回收失败" .. fontAnimObj.uniqueId)
end

function FontAnimManager:SetVisible(visible)
	self.fontRoot:SetActive(visible)
	self.visible = visible
end