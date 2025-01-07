Config = Config or {}
Config.PasvConfig = Config.PasvConfig or {}

Config.PasvConfig[1004] = {
    [1004012] = {
        TotalFrame = 180,
        FrameEvent = {
            [30] = {
                Action = 
				{
					{
						Type = "CreateEntity",
						EntityName = "FxAtk001_1003001",
					},
				}
            },
			[90] = {
				Action = 
				{
					{
						Type = "CreateEntity",
						EntityName = "FxAtk001_1003001",
					},
				}
			}
        }
    },
    [1004014] = {
        TotalFrame = 50,
        FrameEvent = {
            [0] = {
                Action = 
				{
					{
						Type = "Log",
						Msg = "调试信息1001002_0",
					}
				}
            },
			[15] = {
				Action = 
				{
					{
						Type = "Log",
						Msg = "调试信息1001002_15",
					}
				}
			},
			[8] = {
				Action = 
				{
					{
						Type = "Log",
						Msg = "调试信息1001002_8",
					}
				}
			}
        }
    }
}
