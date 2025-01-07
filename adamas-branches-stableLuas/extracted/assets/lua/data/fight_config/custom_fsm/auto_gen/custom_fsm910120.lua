Config = Config or {}
Config.CustomFsm910120 = Config.CustomFsm910120 or { }
Config.CustomFsm910120 = 
{
  FSMId = 910120,
  Name = "木啸叫总状态",
  BehaviorId = 910120,
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
