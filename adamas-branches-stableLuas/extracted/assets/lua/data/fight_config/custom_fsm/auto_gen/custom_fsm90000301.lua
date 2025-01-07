Config = Config or {}
Config.CustomFsm90000301 = Config.CustomFsm90000301 or { }
Config.CustomFsm90000301 = 
{
  FSMId = 90000301,
  Name = "游荡总状态",
  BehaviorId = 90000301,
  SubFSMDatas = {
    {
      MachineId = 1,
      Name = "战斗游荡管理状态",
      IsInitState = true,
      Type = 2,
      BehaviorId = 9000030101,
      SubFSMId = 9000030101,
      JumpTargetLists = {},
    }
  },
}
