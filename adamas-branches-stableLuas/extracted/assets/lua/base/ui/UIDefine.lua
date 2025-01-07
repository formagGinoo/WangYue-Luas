UIDefine = BaseClass("UIDefine")

UIDefine.ViewType =
{
    window = 1, --窗体
    panel = 2, --面板
    item = 3, -- item
}

UIDefine.CacheMode =
{
    destroy = 1,--删除
    hide = 2,--隐藏
}

UIDefine.BlurBackCaptureType = {
    Scene = 0,
    UI = 1,
}

UIDefine.FillMethod = {
    Horizontal = 0,
    Vertical = 1,
    Radial90 = 2,
    Radial180 = 3,
    Radial360 = 4
}

UIDefine.FillOrigin = {
    [UIDefine.FillMethod.Horizontal] = {
        Left = 0,
        Right = 1,
    },
    [UIDefine.FillMethod.Vertical] = {
        Bottom = 0,
        Top = 1,
    },
    [UIDefine.FillMethod.Radial90] = {
        BottomLeft = 0,
        TopLeft = 1,
        TopRight = 2,
        BottomRight = 3,
    },
    [UIDefine.FillMethod.Radial180] = {
        Bottom = 0,
        Left = 1,
        Top = 2,
        Right = 3,
    },
    [UIDefine.FillMethod.Radial360] = {
        Bottom = 0,
        Right = 1,
        Top = 2,
        Left = 3,
    },
}

UIDefine.LayOutMode = {
	Mobile = 1,
	PC = 0,
	Record = 2,
}

UIDefine.canvasRoot = nil
UIDefine.uiCamera = nil

UIDefine.FixedLayer =
{
    ["LoginWindow"] = 0,
    ["CreateRoleWindow"] = 0,
}
local orderId = 0
function UIDefine.GetOrderId()
    orderId = orderId + 1
    return orderId
end