Config = Config or {}
Config.CustomFsm900120 = Config.CustomFsm900120 or { }
Config.CustomFsm900120 = 
{
  FSMId = 900120,
  Name = "噬脉从士总状态",
  BehaviorId = 900120,
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
