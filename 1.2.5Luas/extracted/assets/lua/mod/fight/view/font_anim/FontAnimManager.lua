FontAnimManager = BaseClass("FontAnimManager")

local MaxFontShow = 15
local FightConfig = Config.FightConfig

function FontAnimManager:__init(clientFight)
	self.uniqueId = 0
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
	if not self.visible then
		return
	end

	self.uniqueId = self.uniqueId + 1

	local animInfo = FightConfig.EffectFont[effectFontType]
	if not animInfo then
		LogError("animInfo null fontType "..fontType)
		return
	end

	local fontAnimObj = self.fight.objectPool:Get(EffectTypeFontAnimObj)
	fontAnimObj.uniqueId = self.uniqueId
	fontAnimObj:PlayEffectAnimation(npc, effectFontType, attachPoint)

	self.fontAnimMap[self.uniqueId] = fontAnimObj

	self.fontAnimStack:Push(self.uniqueId)
	if self.fontAnimStack:Count() > MaxFontShow then
		local uniqueId = self.fontAnimStack:PopHead()
		self:PlayAnimationEnd(self.fontAnimMap[uniqueId])
	end
end

function FontAnimManager:PlayAnimation(npc, fontType, text, isCirt, isRestriction, attachPoint, flyPosition)
	UnityUtils.BeginSample("FontAnimManager:PlayAnimation")
	if not self.visible then
		return
	end

	self.uniqueId = self.uniqueId + 1

	local animInfo = FightConfig.FontInfo[fontType]
	if not animInfo then
		LogError("animInfo null fontType "..fontType)
		return
	end

	local typeName = animInfo.className
	if isRestriction and fontType ~= FightConfig.FontType.DAMAGE_TYPE1 then
		typeName = animInfo.wClassName
	end

	local fontAnimObj = self.fight.objectPool:Get(typeName)
	fontAnimObj.uniqueId = self.uniqueId
	fontAnimObj:PlayAnimation(npc, fontType, text, isCirt, isRestriction, attachPoint, flyPosition)

	self.fontAnimMap[self.uniqueId] = fontAnimObj

	self.fontAnimStack:Push(self.uniqueId)
	if self.fontAnimStack:Count() > MaxFontShow then
		local uniqueId = self.fontAnimStack:PopHead()
		self:PlayAnimationEnd(self.fontAnimMap[uniqueId])
	end
	UnityUtils.EndSample()
end

function FontAnimManager:PlayAnimationEnd(fontAnimObj)
	if self.fontAnimMap[fontAnimObj.uniqueId] then
		self.fontAnimMap[fontAnimObj.uniqueId]:OnCache()
		self.fontAnimMap[fontAnimObj.uniqueId] = nil
		self.fontAnimStack:RemoveByValue(fontAnimObj.uniqueId)
	end
end

function FontAnimManager:SetVisible(visible)
	self.fontRoot:SetActive(visible)
	self.visible = visible
end