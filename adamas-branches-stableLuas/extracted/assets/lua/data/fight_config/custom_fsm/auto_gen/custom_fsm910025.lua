Config = Config or {}
Config.CustomFsm910025 = Config.CustomFsm910025 or { }
Config.CustomFsm910025 = 
{
  FSMId = 910025,
  Name = "土石龙总状态",
  BehaviorId = 910025,
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
