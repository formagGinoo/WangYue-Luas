Config = Config or {}
Config.CustomFsm900071 = Config.CustomFsm900071 or { }
Config.CustomFsm900071 = 
{
  FSMId = 900071,
  Name = "土罗睺斩客总状态",
  BehaviorId = 900071,
  SubFSMDatas = {
    {
      MachineId = 1,
      Name = "通用逻辑状态",
      IsInitState = true,
      Type = 2,
      BehaviorId = 900,
      SubFSMId = 900,
      JumpTargetLists = {},
    }
  },
}
