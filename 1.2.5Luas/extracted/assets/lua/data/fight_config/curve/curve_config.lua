CurveConfig = CurveConfig or {}

local CurveConfigMap = {}

function CurveConfig.GetCurveConfig(id)
	if not id then
		return
	end

	if CurveConfigMap[id] then
		return CurveConfigMap[id]
	end

	local fileName = "Curve"..id
	local config = Config[fileName]
	if not config then
		return
	end

	CurveConfigMap[id] = config

	return CurveConfigMap[id]
end

function CurveConfig.GetCurve(id, curveId)
	if not id or not curveId then
		return
	end
	
	local config = CurveConfig.GetCurveConfig(id)
	if not config then
		config =  CurveConfig.GetCurveConfig(1000)
	end
	local curve = config[curveId]
	if not curve then
		return CurveConfig.GetCurveConfig(1000)[curveId]
	end
	return config[curveId]
end