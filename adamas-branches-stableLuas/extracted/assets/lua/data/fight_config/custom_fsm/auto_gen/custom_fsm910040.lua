Config = Config or {}
Config.CustomFsm910040 = Config.CustomFsm910040 or { }
Config.CustomFsm910040 = 
{
  FSMId = 910040,
  Name = "精英丛士总状态",
  BehaviorId = 910040,
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
