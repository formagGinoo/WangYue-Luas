Config = Config or {}
Config.CustomFsm900080 = Config.CustomFsm900080 or { }
Config.CustomFsm900080 = 
{
  FSMId = 900080,
  Name = "木箴石之劣总状态",
  BehaviorId = 900080,
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
