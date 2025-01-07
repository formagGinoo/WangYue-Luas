Config = Config or {}
Config.CustomFsm900090 = Config.CustomFsm900090 or { }
Config.CustomFsm900090 = 
{
  FSMId = 900090,
  Name = "巡卫AI",
  BehaviorId = 900090,
  SubFSMDatas = {
    {
      MachineId = 1,
      Name = "默认",
      IsInitState = true,
      Type = 2,
      BehaviorId = 800001,
      SubFSMId = 90009001,
      JumpTargetLists = {
        {
          TargetMachineId = 2,
          Name = "受威胁",
          checkFunName = "DefaultToThreatened",
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 4,
          Name = "警告",
          checkFunName = "GuardDefaultToAlert",
          Params = {},
          DataListenerList = {
            "inCrime"
          },
        },
        {
          TargetMachineId = 6,
          Name = "战斗",
          checkFunName = "DefaultToFight",
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 7,
          Name = "对话",
          checkFunName = "DefaultToTalk",
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 99,
          Name = "任务占用",
          checkFunName = "InTask",
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
      BehaviorId = 90009002,
      SubFSMId = 0,
      JumpTargetLists = {
        {
          TargetMachineId = 1,
          Name = "默认",
          checkFunName = "GuardThreatenedToDefault",
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 6,
          Name = "战斗",
          checkFunName = "GuardThreatenedToFight",
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 99,
          Name = "任务占用",
          checkFunName = "InTask",
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
      BehaviorId = 90009004,
      SubFSMId = 0,
      JumpTargetLists = {
        {
          TargetMachineId = 1,
          Name = "默认",
          checkFunName = "GuardAlertToDefault",
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 6,
          Name = "战斗",
          checkFunName = "GuardAlertToFight",
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 99,
          Name = "任务占用",
          checkFunName = "InTask",
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
      BehaviorId = 90009006,
      SubFSMId = 0,
      JumpTargetLists = {
        {
          TargetMachineId = 1,
          Name = "默认",
          checkFunName = "FightToDefault",
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 99,
          Name = "任务占用",
          checkFunName = "InTask",
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
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 99,
          Name = "任务占用",
          checkFunName = "InTask",
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
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 7,
          Name = "对话",
          checkFunName = "InTaskToTalk",
          Params = {},
          DataListenerList = {},
        }
      },
    }
  },
}
