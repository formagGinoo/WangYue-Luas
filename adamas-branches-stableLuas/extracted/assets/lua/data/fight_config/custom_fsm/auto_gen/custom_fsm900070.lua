Config = Config or {}
Config.CustomFsm900070 = Config.CustomFsm900070 or { }
Config.CustomFsm900070 = 
{
  FSMId = 900070,
  Name = "火罗睺斩客总状态",
  BehaviorId = 900070,
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
