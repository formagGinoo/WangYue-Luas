Config = Config or {}
Config.CustomFsm9000 = Config.CustomFsm9000 or { }
Config.CustomFsm9000 = 
{
  FSMId = 9000,
  Name = "总状态机",
  BehaviorId = 9000,
  SubFSMDatas = {
    {
      MachineId = 1,
      Name = "出生总状态",
      IsInitState = true,
      Type = 2,
      BehaviorId = 0,
      SubFSMId = 900001,
      JumpTargetLists = {
        {
          TargetMachineId = 2,
          Name = "非战斗总状态",
          checkFunName = "BornToNonFight",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        }
      },
    },
    {
      MachineId = 2,
      Name = "非战斗总状态",
      IsInitState = false,
      Type = 2,
      BehaviorId = 0,
      SubFSMId = 900002,
      JumpTargetLists = {
        {
          TargetMachineId = 3,
          Name = "战斗总状态",
          checkFunName = "NonFightToInFight",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        }
      },
    },
    {
      MachineId = 3,
      Name = "战斗总状态",
      IsInitState = false,
      Type = 2,
      BehaviorId = 0,
      SubFSMId = 900003,
      JumpTargetLists = {
        {
          TargetMachineId = 4,
          Name = "脱战状态",
          checkFunName = "InFightToExitFight",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        }
      },
    },
    {
      MachineId = 4,
      Name = "脱战状态",
      IsInitState = false,
      Type = 1,
      BehaviorId = 900004,
      SubFSMId = 0,
      JumpTargetLists = {
        {
          TargetMachineId = 2,
          Name = "非战斗总状态",
          checkFunName = "ExitFightToPeace",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        }
      },
    }
  },
}
