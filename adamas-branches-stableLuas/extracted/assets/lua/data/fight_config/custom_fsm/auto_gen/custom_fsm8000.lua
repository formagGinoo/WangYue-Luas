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
          Name = "受威胁",
          checkFunName = "DefaultToThreatened",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 3,
          Name = "碰撞",
          checkFunName = "DefaultToCollide",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 4,
          Name = "警告",
          checkFunName = "DefaultToAlert",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 5,
          Name = "逃跑",
          checkFunName = "DefaultToEscape",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {
            "inCrime"
          },
        },
        {
          TargetMachineId = 6,
          Name = "战斗",
          checkFunName = "DefaultToFight",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 7,
          Name = "对话",
          checkFunName = "DefaultToTalk",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 99,
          Name = "任务占用",
          checkFunName = "InTask",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        }
      },
    },
    {
      MachineId = 2,
      Name = "受威胁",
      IsInitState = false,
      Type = 1,
      BehaviorId = 800002,
      SubFSMId = 0,
      JumpTargetLists = {
        {
          TargetMachineId = 1,
          Name = "默认",
          checkFunName = "ThreatenedToDefault",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 5,
          Name = "逃跑",
          checkFunName = "ThreatenedToEscape",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 99,
          Name = "任务占用",
          checkFunName = "InTask",
          useBehaviorFun = false,
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
      JumpTargetLists = {
        {
          TargetMachineId = 1,
          Name = "默认",
          checkFunName = "CollideToDefault",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 99,
          Name = "任务占用",
          checkFunName = "InTask",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        }
      },
    },
    {
      MachineId = 4,
      Name = "警告",
      IsInitState = false,
      Type = 1,
      BehaviorId = 800004,
      SubFSMId = 0,
      JumpTargetLists = {
        {
          TargetMachineId = 7,
          Name = "对话",
          checkFunName = "AlertToTalk",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 99,
          Name = "任务占用",
          checkFunName = "InTask",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        }
      },
    },
    {
      MachineId = 5,
      Name = "逃跑",
      IsInitState = false,
      Type = 1,
      BehaviorId = 800005,
      SubFSMId = 0,
      JumpTargetLists = {
        {
          TargetMachineId = 1,
          Name = "默认",
          checkFunName = "EscapeToDefault",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 99,
          Name = "任务占用",
          checkFunName = "InTask",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        }
      },
    },
    {
      MachineId = 6,
      Name = "战斗",
      IsInitState = false,
      Type = 1,
      BehaviorId = 800006,
      SubFSMId = 0,
      JumpTargetLists = {
        {
          TargetMachineId = 1,
          Name = "默认",
          checkFunName = "FightToDefault",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 99,
          Name = "任务占用",
          checkFunName = "InTask",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        }
      },
    },
    {
      MachineId = 7,
      Name = "对话",
      IsInitState = false,
      Type = 1,
      BehaviorId = 800007,
      SubFSMId = 0,
      JumpTargetLists = {
        {
          TargetMachineId = 1,
          Name = "默认",
          checkFunName = "TalkToDefault",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        }
      },
    },
    {
      MachineId = 99,
      Name = "任务占用",
      IsInitState = false,
      Type = 1,
      BehaviorId = 800099,
      SubFSMId = 0,
      JumpTargetLists = {
        {
          TargetMachineId = 1,
          Name = "默认",
          checkFunName = "OutTask",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 7,
          Name = "对话",
          checkFunName = "InTaskToTalk",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        }
      },
    }
  },
}
