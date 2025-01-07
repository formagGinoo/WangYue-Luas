Config = Config or {}
Config.CustomFsm808011003 = Config.CustomFsm808011003 or { }
Config.CustomFsm808011003 = 
{
  FSMId = 808011003,
  Name = "序章劫匪npc003总状态",
  BehaviorId = 808011003,
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
