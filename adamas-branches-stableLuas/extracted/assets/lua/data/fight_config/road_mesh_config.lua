RoadMeshConfig = RoadMeshConfig or {}

local configMap = {}
local cacheConfigMap = {}
local cacheConfigList = {}
local CacheConfigMax = 4

function RoadMeshConfig.GetRoadMeshId(posX, posZ)
	posX = math.floor(posX + 0.5)
	posZ = math.floor(posZ + 0.5)
	
	local roadMeshFileId = (math.floor(posX / 512) + 1000) << 16 | (math.floor(posZ / 512) + 1000)
	local fileName = "RoadMesh"..roadMeshFileId
	local RoadMeshConfig = Config[fileName]
	if not RoadMeshConfig then
		return 
	end

	

	local posKey = math.floor(posX/5) << 16 | math.floor(posZ/5)
	
	return RoadMeshConfig.RoadMeshDict[posKey] or nil
end

function RoadMeshConfig.GetRoadMeshConfig(posX, posZ)
	posX = math.floor(posX + 0.5)
	posZ = math.floor(posZ + 0.5)
	
	local roadMeshFileId = (math.floor(posX / 512) + 1000) << 16 | (math.floor(posZ / 512) + 1000)
	local fileName = "RoadMesh"..roadMeshFileId
	local RoadMeshConfig = Config[fileName]
	return RoadMeshConfig
end