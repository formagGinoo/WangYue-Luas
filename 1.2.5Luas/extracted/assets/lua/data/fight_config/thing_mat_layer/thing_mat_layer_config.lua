


ThingMatLayerConfig = ThingMatLayerConfig or {}

local CacheThingLayer = {}
function ThingMatLayerConfig.GetMatLayer(gameObject, posX, posZ)
	local name = gameObject.name
	local layer = CacheThingLayer[name]
	if layer then
		return layer
	end

	local matLayerName = gameObject.transform.parent.name
	layer = TerrainMatLayerConfig.LayerStrType[matLayerName] or 0
	CacheThingLayer[name] = layer

	return layer
end