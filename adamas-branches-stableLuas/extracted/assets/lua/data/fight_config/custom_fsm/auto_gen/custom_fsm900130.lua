Config = Config or {}
Config.CustomFsm900130 = Config.CustomFsm900130 or { }
Config.CustomFsm900130 = 
{
  FSMId = 900130,
  Name = "噬脉弓从士总状态",
  BehaviorId = 900130,
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
