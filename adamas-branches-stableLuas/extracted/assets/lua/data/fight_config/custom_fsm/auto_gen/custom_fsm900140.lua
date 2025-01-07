Config = Config or {}
Config.CustomFsm900140 = Config.CustomFsm900140 or { }
Config.CustomFsm900140 = 
{
  FSMId = 900140,
  Name = "男恶来卒总状态",
  BehaviorId = 900140,
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
