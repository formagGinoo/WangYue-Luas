Config = Config or {}
Config.CustomFsm900102 = Config.CustomFsm900102 or { }
Config.CustomFsm900102 = 
{
  FSMId = 900102,
  Name = "木计都灵客总状态",
  BehaviorId = 900102,
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
