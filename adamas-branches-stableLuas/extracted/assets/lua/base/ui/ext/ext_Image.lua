local base = xlua.getmetatable(Image)
local __baseindex = base.__index
local __extends = {}

--扩展
local atlasPaths = {}
local function getPhysicalPath(atlasKey,spriteKey)
	if atlasPaths[atlasKey] then return atlasPaths[atlasKey] end
	local s, t = string.find(spriteKey, "folderSprite")
	if s == nil then return nil end
	local physicalPath = string.sub(spriteKey, 0, s + 5)
	atlasPaths[atlasKey] = physicalPath
	return atlasPaths[atlasKey]
end

function __extends.SetSpriteSameAtlas(self,name,nativeSize)
	local atlasKey = self.materialKey
	if not atlasKey or atlasKey == "" then return end
	local physicalPath = getPhysicalPath(atlasKey,self.spriteKey)
	if not physicalPath then return end
	local sprite = AssetManager.GetSubObjectByPhysicalPath(physicalPath,name)
	if not sprite then return end
	self.sprite = sprite
	if nativeSize then self:SetNativeSize() end
end

--
base.__index = function(t,k)
	if __extends[k] then
		return __extends[k]
	else
		return __baseindex(t,k)
	end
end
xlua.setmetatable(Image, base)