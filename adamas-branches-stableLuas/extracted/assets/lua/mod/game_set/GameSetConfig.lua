

GameSetConfig = GameSetConfig or {}

GameSetConfig.PanelType = {
    Volume = 1,
    View = 2,
    KeyMap = 3,
    Fight = 4,
    Dirve = 5,
    Other = 6,
}

GameSetConfig.EffectQuality = {
    None = 0,
    Low = 1,
    Middle = 2,
    High = 3,
}

GameSetConfig.ImageEnhancementType = {
    None = 0,
    DLSS = 1,
    FSR = 2,
}

GameSetConfig.PanelToggle = 
{
    {
        type = GameSetConfig.PanelType.Volume,
        icon = "SettingVoice", 
        name = TI18N("声音"), 
        callback = function(parent, isSelect)
            if isSelect then
                parent:OpenPanel(SetVolumePanel)
            else
                parent:ClosePanel(SetVolumePanel)
            end
        end
    },
    {
        type = GameSetConfig.PanelType.View,
        icon = "SettingImage", 
        name = TI18N("图像"), 
        callback = function(parent, isSelect)
            if isSelect then
                parent:OpenPanel(SetViewPanel)
            else
                parent:ClosePanel(SetViewPanel)
            end
        end
    },
    {
        type = GameSetConfig.PanelType.KeyMap,
        icon = "SettingKey", 
        name = TI18N("键位"), 
        callback = function(parent, isSelect)
            if isSelect then
                parent:OpenPanel(SetKeyMapPanel)
            else
                parent:ClosePanel(SetKeyMapPanel)
            end
        end
    },
    {
        type = GameSetConfig.PanelType.Fight,
        icon = "SettingOther", 
        name = TI18N("战斗"), 
        callback = function(parent, isSelect)
          if isSelect then
                parent:OpenPanel(SetFightPanel)
            else
                parent:ClosePanel(SetFightPanel)
            end
        end
    },
    {
        type = GameSetConfig.PanelType.Dirve,
        icon = "SettingDrive", 
        name = TI18N("载具"), 
        callback = function(parent, isSelect)
          if isSelect then
                parent:OpenPanel(SetDrivePanel)
            else
                parent:ClosePanel(SetDrivePanel)
            end
        end
    },
    {
        type = GameSetConfig.PanelType.Other,
        icon = "SettingOther", 
        name = TI18N("其他"), 
        callback = function(parent, isSelect)
          if isSelect then
                parent:OpenPanel(SetOtherPanel)
            else
                parent:ClosePanel(SetOtherPanel)
            end
        end
    },
}


GameSetConfig.SaveKey =
{
	-- 声音
	VolumeTotal = "VolTotal", 
	VolumeMusic = "VolMusic",
	VolumeEffect = "VolEffect",
	VolumeLanguage = "VolLanguage", 

	-- 图像
	ViewQualityLevel = "ViewQualityLevel",
	ViewResolution = "ViewResolution", 
    ViewRenderScale = "ViewRenderScale", 
	ViewAAType = "ViewAAType", 
	ViewAAQuality = "ViewAAQuality",
    ViewMsaaQuality = "ViewMsaaQuality", 
    ViewSmaaQuality = "ViewSmaaQuality",
    ViewTaaQuality = "ViewTaaQuality",
	ViewFrame = "ViewFrame",
    DLSSResolutionIndex = "DLSSResolutionIndex",
    AnisotropicFilteringMode = "AnisotropicFilteringMode",

    --战斗
    FightTipsFonts = "FightTipsFonts", -- 战斗飘字

    --载具
    TrafficMode = "TrafficMode", -- 驾驶模式
    DriveCameraCentralAuto = "DriveCameraCentralAuto", -- 驾驶时相机自动居中
}

GameSetConfig.Volume =
{
	-- 声音
	[GameSetConfig.SaveKey.VolumeTotal] = {DefalutValue = 10, SetUIFun = "SetTotalVolume", RTPC_Key = "VolumeTotal" },
	[GameSetConfig.SaveKey.VolumeMusic] = {DefalutValue = 10, SetUIFun = "SetMusicVolume", RTPC_Key = "VolumeMusic"},
	[GameSetConfig.SaveKey.VolumeEffect] = {DefalutValue = 10, SetUIFun = "SetEffectVolume", RTPC_Key = "VolumeEffect"}, 
	[GameSetConfig.SaveKey.VolumeLanguage] = {DefalutValue = 10, SetUIFun = "SetLanVolume", RTPC_Key = "VolumeLang"},  
}

GameSetConfig.Fight  =
{
	-- 战斗
    {
        SaveKey = GameSetConfig.SaveKey.FightTipsFonts,
        SetName = "是否开启战斗飘字",
        DefalutValue = 1, 
        SetValues = {
            {name = "是", value = 0},
            {name = "否", value = 1},
        }
    },
}

GameSetConfig.Dirve  =
{
	-- 驾驶
    {
        SaveKey = GameSetConfig.SaveKey.TrafficMode,
        SetName = "载具驾驶模式",
        DefalutValue = 2, 
        SetValues = {
            {name = "安全竞速模式", value = 2},
            {name = "都市自由模式", value = 1},
        }
    },
    {
        SaveKey = GameSetConfig.SaveKey.DriveCameraCentralAuto,
        SetName = "是否开启驾驶时镜头自动居中",
        DefalutValue = 0, 
        SetValues = {
            {name = "是", value = 0},
            {name = "否", value = 1},
        }
    },
}
GameSetConfig.ViewLevel =
{
    Highest = 0,
    High  = 1,
    Mid = 2,
    Low = 3,
    Customize = 4,
}

GameSetConfig.PC_View =
{
    {
        SaveKey = GameSetConfig.SaveKey.ViewQualityLevel,
        SetFun = "ChangeLevel",
        SetName = "图像质量",
        SetValues = 
        {
            {name = "高", value = 0},
            {name = "中", value = 1},
            {name = "低", value = 2},
            {name = "自定义", value = 4},
        }
    },
    {
        SaveKey = GameSetConfig.SaveKey.ViewResolution,
        SetName = "显示模式",
        CSKey = "IntResolution",
        SetValues = 
        {
        }
    },
    {
        SaveKey = GameSetConfig.SaveKey.ViewRenderScale,
        SetName = "渲染精度",
        SetValues = 
        {
            {name = "2", value = 0},
            {name = "1.2", value = 1},
            {name = "1.1", value = 2},
            {name = "1.0", value = 3},
            {name = "0.9", value = 4},
        }
    },
    {
        SaveKey = GameSetConfig.SaveKey.ViewAAType,
        SetName = "抗锯齿",
        CSKey = "IntAAType",
        SetValues = 
        {
            {name = "MSAA", value = 1},
            {name = "SMAA", value = 2},
            {name = "TAA", value = 3},
        }
    }, 
    {
        SaveKey = GameSetConfig.SaveKey.ViewFrame,
        SetName  = "帧率",
        CSKey = "FrameRate",
        SetValues = 
        {
            {name = "60", value = 60},
            {name = "90", value = 90},
            {name = "120", value = 120},
        }
    },
    --{
    --    SaveKey = GameSetConfig.SaveKey.DLSSResolutionIndex,
    --    SetName = "DLSS",
    --    CSKey = "DLSSResolutionIndex",
    --    SetValues =
    --    {
    --        {name = "关", value = 0},
    --        {name = "超级性能", value = 1},
    --        {name = "性能优先", value = 2},
    --        {name = "均衡模式", value = 3},
    --        {name = "最高画质", value = 4},
    --    }
    --},
    {
        SaveKey = GameSetConfig.SaveKey.AnisotropicFilteringMode,
        SetName  = "贴图细节",
        CSKey = "AnisotropicFilteringMode",
        SetValues =
        {
            {name = "低", value = 0},
            {name = "中", value = 1},
            {name = "高", value = 2},
        }
    },
}

GameSetConfig.AASet =
{
     {
        SaveKey = GameSetConfig.SaveKey.ViewMsaaQuality,
        SetName = "抗锯齿等级",
        CSKey = "IntMsaaQuality",
        SetValues =
        {
            {name = "Disabled", value = 1},
            {name = "_2x", value = 2},
            {name = "_4x", value = 4},
            {name = "_8x", value = 8},
        }
    },  
    {
        SaveKey = GameSetConfig.SaveKey.ViewSmaaQuality,
        SetName = "抗锯齿等级",
        CSKey = "IntSmaaQuality",
        SetValues =
        {
            {name = "低", value = 0},
            {name = "中", value = 1},
            {name = "高", value = 2},
        }
    },
    {
        SaveKey = GameSetConfig.SaveKey.ViewTaaQuality,
        SetName = "抗锯齿等级",
        CSKey = "IntTAAQuality",
        SetValues =
        {
            {name = "低", value = 1},
            {name = "中", value = 2},
            {name = "高", value = 3},
            {name = "极高", value = 4},
        }
    },
}


GameSetConfig.Mobile_View =
{

 
}


function GameSetConfig.SetViewConfig()
    if Application.platform == RuntimePlatform.Android or 
        platform == RuntimePlatform.IPhonePlayer then
        GameSetConfig.View = GameSetConfig.Mobile_View
    else
        GameSetConfig.View = GameSetConfig.PC_View
    end    
end
GameSetConfig.SetViewConfig()

function GameSetConfig.GetViewSetName(saveKey, value)
    for _, v in pairs(GameSetConfig.View) do
        if saveKey == v.SaveKey then
            for __, vv in pairs(v.SetValues) do
                if vv.value == value then
                    return vv.name
                end
            end
        end
    end

    for _, v in pairs(GameSetConfig.AASet) do
        if saveKey == v.SaveKey then
            for __, vv in pairs(v.SetValues) do
                if vv.value == value then
                    return vv.name
                end
            end
        end
    end
end

function GameSetConfig.GetViewInfo(saveKey)
    for k, v in pairs(GameSetConfig.View) do
        if saveKey == v.SaveKey then
            return v
        end
    end
	
	for _, v in pairs(GameSetConfig.AASet) do
		if saveKey == v.SaveKey then
			return v
		end
	end
end











