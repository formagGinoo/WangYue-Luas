
TerrainMatLayerConfig = TerrainMatLayerConfig or {}
TerrainMatLayerConfig.Layer =
{
	-- 草地
	Grass = 1,
	-- 泥地
	Mud = 2,
	-- 沙地
	Sand = 3,
	-- 雪地F
	Snow = 4,
	-- 石头
	Stone = 5,
	-- 金属
	Metal = 6,
	-- 木头
	Wood = 7,
	-- 水
	Water = 8,
}

TerrainMatLayerConfig.LayerStr =
{
	[TerrainMatLayerConfig.Layer.Grass] = "Grass",
	[TerrainMatLayerConfig.Layer.Mud] = "Mud",
	[TerrainMatLayerConfig.Layer.Sand] = "Sand",
	[TerrainMatLayerConfig.Layer.Snow] = "Snow",
	[TerrainMatLayerConfig.Layer.Stone] = "Stone",
	[TerrainMatLayerConfig.Layer.Metal] = "Metal",
	[TerrainMatLayerConfig.Layer.Wood] = "Wood",
	[TerrainMatLayerConfig.Layer.Water] = "Water",
}

TerrainMatLayerConfig.LayerStrType =
{
	["Grass"] = TerrainMatLayerConfig.Layer.Grass,
	["Mud"] = TerrainMatLayerConfig.Layer.Mud,
	["Sand"] = TerrainMatLayerConfig.Layer.Sand,
	["Snow"] = TerrainMatLayerConfig.Layer.Snow,
	["Stone"] = TerrainMatLayerConfig.Layer.Stone,
	["Metal"] = TerrainMatLayerConfig.Layer.Metal,
	["Wood"] = TerrainMatLayerConfig.Layer.Wood,
}

TerrainMatLayerConfig.LayerColor = 
{
	[TerrainMatLayerConfig.Layer.Grass] = Color(0,1,0,1),
	[TerrainMatLayerConfig.Layer.Mud] = Color(129/255,111/255,79/255,1),
	[TerrainMatLayerConfig.Layer.Sand] = Color(129/255,111/255,79/255,1),
	[TerrainMatLayerConfig.Layer.Snow] = Color(1,1,1,1),
	[TerrainMatLayerConfig.Layer.Stone] = Color(0,0,0,1)
}

local configMap = {}
local cacheConfigMap = {}
local cacheConfigList = {}
local CacheConfigMax = 4
function TerrainMatLayerConfig.GetMatLayer(posX, posZ)
	posX = math.floor(posX + 0.5)
	posZ = math.floor(posZ + 0.5)
	
	local terrainLayerFileId = (math.floor(posX / 512) + 1000) << 16 | (math.floor(posZ / 512) + 1000)
	local fileName = "TerrainMatLayer"..terrainLayerFileId
	local terrainMatLayerConfig = Config[fileName]
	if not terrainMatLayerConfig then
		return 1
	end

	if not cacheConfigMap[fileName] then
		local count = 0
		for k, v in pairs(cacheConfigMap) do
			count = count + 1
		end

		if #cacheConfigList >= CacheConfigMax then
			local removeFileName = cacheConfigList[1]
			table.remove(cacheConfigList, 1)

			cacheConfigMap[removeFileName] = nil
			cacheConfigMap[fileName] = true

			local requireName = ClzMapping[removeFileName]
			package.loaded[requireName] = nil
		end

		table.insert(cacheConfigList, fileName)
	end

	local blockKey = posX << 16 | posZ
	if terrainMatLayerConfig.terrianBlockLayer then
		return terrainMatLayerConfig.terrianBlockLayer[blockKey] or terrainMatLayerConfig.terrianLayer
	end

	return terrainMatLayerConfig.terrianLayer
end

function TerrainMatLayerConfig.GetDebugLayerColor(layer)
	return TerrainMatLayerConfig.LayerColor[layer]
end	