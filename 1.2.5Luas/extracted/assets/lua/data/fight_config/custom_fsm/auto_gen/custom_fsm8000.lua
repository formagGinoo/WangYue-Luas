Config = Config or {}
Config.CustomFsm8000 = Config.CustomFsm8000 or { }
Config.CustomFsm8000 = 
{
  FSMId = 8000,
  Name = "NPC通用AI",
  BehaviorId = 8000,
  SubFSMDatas = {
    {
      MachineId = 1,
      Name = "默认",
      IsInitState = true,
      Type = 2,
      BehaviorId = 800001,
      SubFSMId = 800001,
      JumpTargetLists = {
        {
          TargetMachineId = 2,
          Name = "受击",
          checkFunName = "DefaultToHit",
          Params = {},
          DataListenerList = {},
        }
      },
    },
    {
      MachineId = 2,
      Name = "受击",
      IsInitState = false,
      Type = 1,
      BehaviorId = 800002,
      SubFSMId = 0,
      JumpTargetLists = {
        {
          TargetMachineId = 1,
          Name = "默认",
          checkFunName = "HitToDefault",
          Params = {},
          DataListenerList = {},
        }
      },
    },
    {
      MachineId = 3,
      Name = "碰撞",
      IsInitState = false,
      Type = 1,
      BehaviorId = 800003,
      SubFSMId = 0,
      JumpTargetLists = {},
    },
    {
      MachineId = 4,
      Name = "警戒",
      IsInitState = false,
      Type = 1,
      BehaviorId = 800004,
      SubFSMId = 0,
      JumpTargetLists = {},
    },
    {
      MachineId = 5,
      Name = "逃跑",
      IsInitState = false,
      Type = 1,
      BehaviorId = 800005,
      SubFSMId = 0,
      JumpTargetLists = {},
    },
    {
      MachineId = 6,
      Name = "战斗",
      IsInitState = false,
      Type = 1,
      BehaviorId = 800006,
      SubFSMId = 0,
      JumpTargetLists = {},
    },
    {
      MachineId = 7,
      Name = "对话",
      IsInitState = false,
      Type = 1,
      BehaviorId = 800007,
      SubFSMId = 0,
      JumpTargetLists = {},
    },
    {
      MachineId = 99,
      Name = "任务占用",
      IsInitState = false,
      Type = 1,
      BehaviorId = 800099,
      SubFSMId = 0,
      JumpTargetLists = {},
    }
  },
}
