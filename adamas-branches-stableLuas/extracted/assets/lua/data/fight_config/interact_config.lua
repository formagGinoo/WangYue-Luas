Config = Config or {}
Config.InteractConfig = Config.InteractConfig or {}
local InteractConfig  = Config.InteractConfig

------------------状态类型枚举-------------------------
--处于战斗中
--WorldEnum.InteractCheckState.InFight
--处于播放旁白对话时
--WorldEnum.InteractCheckState.InAside
--处于所有Timeline状态下时
--WorldEnum.InteractCheckState.InTimeline
---------------------------------------------------

--交互组件处于该状态时候不触发交互按钮
InteractConfig.InteractStateCfg = {
    [WorldEnum.InteractType.Check] = {},
    [WorldEnum.InteractType.Collect] = {},
    [WorldEnum.InteractType.Transport] = {},
    [WorldEnum.InteractType.Talk] = {WorldEnum.InteractCheckState.InAside},
    [WorldEnum.InteractType.Chest] = {},
    [WorldEnum.InteractType.Task] = {},
    [WorldEnum.InteractType.Item] = {WorldEnum.InteractCheckState.InFight},
    [WorldEnum.InteractType.Unlock] = {},
    [WorldEnum.InteractType.OpenDoor] = {},
    [WorldEnum.InteractType.Jade] = {},
    [WorldEnum.InteractType.Drive] = {WorldEnum.InteractCheckState.InFight}
}