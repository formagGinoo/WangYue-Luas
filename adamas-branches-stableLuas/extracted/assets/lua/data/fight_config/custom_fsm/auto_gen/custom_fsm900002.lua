Config = Config or {}
Config.CustomFsm900002 = Config.CustomFsm900002 or { }
Config.CustomFsm900002 = 
{
  FSMId = 900002,
  Name = "非战斗总状态",
  BehaviorId = 900002,
  SubFSMDatas = {
    {
      MachineId = 1,
      Name = "和平总状态",
      IsInitState = true,
      Type = 2,
      BehaviorId = 0,
      SubFSMId = 90000201,
      JumpTargetLists = {
        {
          TargetMachineId = 2,
          Name = "警戒动作状态",
          checkFunName = "PeaceToWarning",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        }
      },
    },
    {
      MachineId = 2,
      Name = "警戒动作状态",
      IsInitState = false,
      Type = 1,
      BehaviorId = 90000202,
      SubFSMId = 0,
      JumpTargetLists = {},
    },
    {
      MachineId = 3,
      Name = "佣兵追击状态（暂不处理）",
      IsInitState = false,
      Type = 1,
      BehaviorId = 90000203,
      SubFSMId = 0,
      JumpTargetLists = {},
    }
  },
}
