Config = Config or {}
Config.CustomFsm800001 = Config.CustomFsm800001 or { }
Config.CustomFsm800001 = 
{
  FSMId = 800001,
  Name = "NPC通用AI子状态机-默认",
  BehaviorId = 800001,
  SubFSMDatas = {
    {
      MachineId = 1,
      Name = "原地播动作",
      IsInitState = true,
      Type = 1,
      BehaviorId = 80000101,
      SubFSMId = 0,
      JumpTargetLists = {},
    },
    {
      MachineId = 2,
      Name = "巡逻",
      IsInitState = false,
      Type = 1,
      BehaviorId = 80000102,
      SubFSMId = 0,
      JumpTargetLists = {},
    }
  },
}
