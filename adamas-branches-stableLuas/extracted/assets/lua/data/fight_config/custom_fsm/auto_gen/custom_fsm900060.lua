Config = Config or {}
Config.CustomFsm900060 = Config.CustomFsm900060 or { }
Config.CustomFsm900060 = 
{
  FSMId = 900060,
  Name = "水尾狐总状态",
  BehaviorId = 900060,
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
