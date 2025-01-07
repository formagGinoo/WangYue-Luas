AnimEventConfig = AnimEventConfig or {}

local animEventConfigMap = {}

function AnimEventConfig.GetAnimData(id)
	if not id then
		return
	end

	if animEventConfigMap[id] then
		return animEventConfigMap[id]
	end

	local fileName = "AnimEvent"..id
	local config = Config[fileName]
	if not config then
		return
	end
	
	animEventConfigMap[id] = config

	return animEventConfigMap[id]
end