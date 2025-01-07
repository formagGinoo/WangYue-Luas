TeachConfig = TeachConfig or {}
TeachConfig.TeachIdMapById = {}

local _tinsert = table.insert

local DataImageTips = Config.DataImageTips.Find
local TeachIdMap = Config.DataImageTips.FindbyTeachId
local DataTeachTag = Config.DataTeachTag.Find
local DataTeachMain = Config.DataTeachMain.Find

local CommonCfg = Config.DataCommonCfg.Find
TeachConfig.TeachRewardId = CommonCfg["TeachRewardId"].int_val

TeachConfig.ShowType = {
    ShowImgPanel = 1, -- 强引导
    ShowTip = 2, -- 弱引导
}

TeachConfig.TeachStateType = {
    def = 1,
    receive = 2,
}

TeachConfig.ShowTeachResType = {
    Image = 1,
    Video = 2,
}

TeachConfig.AllTagIdx = 1
TeachConfig.AllTagCfg = {
    name = TI18N("全部"),
    cancel_icon = SystemConfig.GetIconConfig("TeachAll").icon1,
    select_icon = SystemConfig.GetIconConfig("TeachAll").icon2,
    weak_icon = ""
}

function TeachConfig.InitTeachIdMap(teachId)
    local teachIdMap = TeachIdMap[teachId]
	if not teachIdMap then return end
	local data = {}
	for _, id in pairs(teachIdMap) do
		local cfg = DataImageTips[id]
		if cfg then
            _tinsert(data, {id = id, stage = cfg.teach_stage})
		end
	end

    table.sort(data, function (a, b)
        return a.stage < b.stage
    end)

    TeachConfig.TeachIdMapById[teachId] = data
end

function TeachConfig.GetTeachIdMap(teachId)
    local map = TeachConfig.TeachIdMapById[teachId]
    if not map then
        TeachConfig.InitTeachIdMap(teachId)
    end

    return TeachConfig.TeachIdMapById[teachId]
end

-- 具体id配置
function TeachConfig.GetTeachIdCfg(teachId)
    return DataImageTips[teachId]
end

-- 所属id配置
function TeachConfig.GetTeachTypeIdCfg(teachId)
    return DataTeachMain[teachId]
end

function TeachConfig.GetTeachTypeIdCfgByTeachId(teachId)
    local teachIdCfg = TeachConfig.GetTeachIdCfg(teachId)
    if not teachIdCfg then return end
    return DataTeachMain[teachIdCfg.teach_id]
end

function TeachConfig.GetTeachTagConfig(tagType)
    if tagType then
        return DataTeachTag[tagType]
    end
    return DataTeachTag
end

