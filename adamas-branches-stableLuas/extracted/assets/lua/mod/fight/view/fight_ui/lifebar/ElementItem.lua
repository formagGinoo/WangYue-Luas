ElementItem = BaseClass("ElementItem", Module)

local itemPrefab = "Prefabs/UI/Common/ElementItem.prefab"
local material3DPath = "DefaultMaterials/UI_3D_Default"

local Element2ToFullEffect = {
	--[FightEnum.ElementType.Phy] = Color(1, 1, 1, 76/255),
	[FightEnum.ElementType.Gold] = "Effect/UI/22010.prefab",
	[FightEnum.ElementType.Wood] = "Effect/UI/22008.prefab",
	[FightEnum.ElementType.Water] = "Effect/UI/22008.prefab",
	[FightEnum.ElementType.Fire] = "Effect/UI/22008.prefab",
	[FightEnum.ElementType.Earth] = "Effect/UI/22008.prefab",
}

local Element2ToZeroEffect = {
	--[FightEnum.ElementType.Phy] = Color(1, 1, 1, 76/255),
	[FightEnum.ElementType.Gold] = "Effect/UI/22011.prefab",
	[FightEnum.ElementType.Wood] = "Effect/UI/22009.prefab",
	[FightEnum.ElementType.Water] = "Effect/UI/22009.prefab",
	[FightEnum.ElementType.Fire] = "Effect/UI/22009.prefab",
	[FightEnum.ElementType.Earth] = "Effect/UI/22009.prefab",
}

local Element2ToFullColor = {
	--[FightEnum.ElementType.Phy] = Color(1, 1, 1, 76/255),
	[FightEnum.ElementType.Gold] = Color(153/255, 121/255, 1, 76/255),
	[FightEnum.ElementType.Wood] = Color(1, 1, 1, 76/255),
	[FightEnum.ElementType.Water] = Color(1, 1, 1, 76/255),
	[FightEnum.ElementType.Fire] = Color(1, 78/255, 49/255, 76/255),
	[FightEnum.ElementType.Earth] = Color(1, 1, 1, 76/255),
}

local Element2ToZeroColor = {
	--[FightEnum.ElementType.Phy] = Color(1, 1, 1, 153/255),
	[FightEnum.ElementType.Gold] = Color(200/255, 149/255, 1, 153/255),
	[FightEnum.ElementType.Wood] = Color(1, 1, 1, 153/255),
	[FightEnum.ElementType.Water] = Color(1, 1, 1, 153/255),
	[FightEnum.ElementType.Fire] = Color(235/255, 56/255, 32/255, 153/255),
	[FightEnum.ElementType.Earth] = Color(1, 1, 1, 153/255),
}

local Element2Name = {
	--[FightEnum.ElementType.Phy] = "fire",
	[FightEnum.ElementType.Gold] = "gold",
	[FightEnum.ElementType.Wood] = "fire",
	[FightEnum.ElementType.Water] = "fire",
	[FightEnum.ElementType.Fire] = "fire",
	[FightEnum.ElementType.Earth] = "fire",
}

function ElementItem.Get(parent, element, config)
	local item = PoolManager.Instance:Pop(PoolType.class, "ElementItem")
	if not item then
		item = ElementItem.New()
	end
	item:LoadItem(parent, element, config)
	return item
end

function ElementItem.Recycle(item)
	item:Reset()
	PoolManager.Instance:Push(PoolType.class, "ElementItem", item)
end

function ElementItem:__init()
	self.parent = nil
	self.assetLoader = nil
	self.object = nil
	self.config = nil
	self.nodes = {}
	self.loadDone = false
end

--[[
	UI2D = true, --是否2DUI
]]
function ElementItem:LoadItem(parent, element, config)
	self.parent = parent
	self.element = element
	self.config = config
	
	local flag, item = self:GetItemObj()
	self.loadDone = flag
	
	if flag then self:OnLoadDone(item) end
end

function ElementItem:GetItemObj()
	local item = PoolManager.Instance:Pop(PoolType.object, "ElementItemObject"..self.element)
	if not item then
		local callback = function()
			local object = self.assetLoader:Pop(itemPrefab)
			local toFullEffect = self.assetLoader:Pop(Element2ToFullEffect[self.element])
			local toZeroEffect = self.assetLoader:Pop(Element2ToZeroEffect[self.element])
			
			UtilsUI.AddUIChild(object.transform:Find("ToFull_"), toFullEffect)
			UtilsUI.AddUIChild(object.transform:Find("ToZero_"), toZeroEffect)
			
			self:OnLoadDone(object)
		end

		local resList = {
			{path = itemPrefab, type = AssetType.Prefab},
			{path = Element2ToZeroEffect[self.element], type = AssetType.Prefab},
			{path = Element2ToFullEffect[self.element], type = AssetType.Prefab},
		}
		
		self.assetLoader = AssetMgrProxy.Instance:GetLoader("ElementItemLoader")
		self.assetLoader:AddListener(callback)
		self.assetLoader:LoadAll(resList)
		return false
	end
	return true, item
end

function ElementItem:OnLoadDone(object)
	if self.assetLoader then
		AssetMgrProxy.Instance:CacheLoader(self.assetLoader)
		self.assetLoader = nil
	end

	UtilsUI.AddUIChild(self.parent, object)
	
	self:InitItem(object, self.element, self.config)
end

function ElementItem:InitItem(object, element, config)
	self.object = object
	self.element = element
	self.config = config or {}
	self.loadDone = true
	
	self.nodes = UtilsUI.GetContainerObject(self.object.transform)
	
	self:UpdateMaterial()
	
	local toFullEffect = self.nodes.ToFull.transform:GetChild(0).gameObject
	local toZeroEffect = self.nodes.ToZero.transform:GetChild(0).gameObject
	toZeroEffect.transform.localScale = Vector3(-1, 1, 1)
	
	self.nodes.ToFullEffectMat = {}
	local toFullMats = toFullEffect:GetComponentsInChildren(Renderer)
	for i = 0, toFullMats.Length - 1 do
		self.nodes.ToFullEffectMat[i + 1] = toFullMats[i].material
	end
	
	self.nodes.ToZeroEffectMat = {}
	local toZeroMats = toZeroEffect:GetComponentsInChildren(Renderer)
	for i = 0, toZeroMats.Length - 1 do
		self.nodes.ToZeroEffectMat[i + 1] = toZeroMats[i].material
	end
	
	self.object:SetActive(false)
	self:Show()
	
	if self.tmp then
		self:UpdateState(self.tmp[1], self.tmp[2], self.tmp[3])
		self.tmp = nil
	end
end

function ElementItem:__delete()
	if self.assetLoader then
		AssetMgrProxy.Instance:CacheLoader(self.assetLoader)
		self.assetLoader = nil
	end
end

function ElementItem:Reset()
	if self.timer then
		LuaTimerManager.Instance:RemoveTimer(self.timer)
		self.timer = nil
	end
	
	if self.object then
		PoolManager.Instance:Push(PoolType.object, "ElementItemObject"..self.element, self.object)
		self.object = nil
	end
	
	self.nodes = {}
	self.config = nil
	self.parent = nil
	self.loadDone = false
end

function ElementItem:UpdateMaterial()
	if not ElementItem.Mat3D then
		ElementItem.Mat3D = CustomUnityUtils.GetMaterial(material3DPath)
	end
	
	local mat = ElementItem.Mat3D
	if self.config.UI2D then
		mat = nil
	end
	
	local imgs = self.object.transform:GetComponentsInChildren(Image)
	for i = 0, imgs.Length - 1 do
		imgs[i].material = mat
	end
end

function ElementItem:Show()
	local path = AssetConfig.GetElementWeakIcon(Element2Name[self.element])
	self.nodes.Icon:SetActive(false)
	
	local callback = function()
		self.nodes.Icon:SetActive(true)
	end
	
	SingleIconLoader.Load(self.nodes.Icon, path, callback)
	
	self.nodes.ToFull_img.color = Element2ToFullColor[self.element]
	self.nodes.ToZero_img.color = Element2ToZeroColor[self.element]
end

function ElementItem:SetTextureOffset(mat, tex, offset)
	if mat then
		mat:SetTextureOffset(tex, offset)
	end
end

function ElementItem:UpdateState(full, value, maxValue)
	-- 0的情况要显示
	if maxValue == 0 then
		maxValue = 1
		value = 0
	end

	if not self.loadDone then
		self.tmp = {full, value, maxValue}
		return
	end
	
	if not self.object.activeSelf then
		self.object.transform:SetAsLastSibling()
	end
	
	self.object:SetActive(true)
	self.nodes.ToFull:SetActive(not full)
	self.nodes.ToZero:SetActive(full)
	
	local img = full and self.nodes.ToZero_img or self.nodes.ToFull_img
	img.fillAmount = value / maxValue
	if full and value <= 0 then
		self.object:SetActive(false)
	end
	
	if not full then
		self:SetTextureOffset(self.nodes.ToFullEffectMat[1], "_MainTex", Vector2(0, 0.9 - img.fillAmount * 0.35))
		self:SetTextureOffset(self.nodes.ToFullEffectMat[2], "_MainTex", Vector2(0, 1 - img.fillAmount * 3.58))
		--self.nodes.ToFullEffectMat[3]:SetTextureOffset("_MaskTex", Vector2(0, 0.9 - img.fillAmount))
	else
		self:SetTextureOffset(self.nodes.ToZeroEffectMat[1], "_MainTex", Vector2(0, -0.6 + (1 - img.fillAmount) * 1.5))
		self:SetTextureOffset(self.nodes.ToZeroEffectMat[2], "_MainTex", Vector2(0, -2.13 + (1 - img.fillAmount) * 2.93))
		self:SetTextureOffset(self.nodes.ToZeroEffectMat[3], "_MaskTex", Vector2(0, -1.05 + (1 - img.fillAmount) * 1.95))
	end
end

function ElementItem:OnReset()

end