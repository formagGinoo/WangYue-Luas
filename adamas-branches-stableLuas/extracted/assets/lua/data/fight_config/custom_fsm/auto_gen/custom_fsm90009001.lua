Config = Config or {}
Config.CustomFsm90009001 = Config.CustomFsm90009001 or { }
Config.CustomFsm90009001 = 
{
  FSMId = 90009001,
  Name = "默认状态",
  BehaviorId = 90009001,
  SubFSMDatas = {
    {
      MachineId = 1,
      Name = "演出",
      IsInitState = true,
      Type = 1,
      BehaviorId = 9000900101,
      SubFSMId = 0,
      JumpTargetLists = {
        {
          TargetMachineId = 2,
          Name = "巡逻",
          checkFunName = "ActToPatrol",
          Params = {},
          DataListenerList = {},
        }
      },
    },
    {
      MachineId = 2,
      Name = "巡逻",
      IsInitState = false,
      Type = 1,
      BehaviorId = 9000900102,
      SubFSMId = 0,
      JumpTargetLists = {
        {
          TargetMachineId = 1,
          Name = "演出",
          checkFunName = "PatrolToAct",
          Params = {},
          DataListenerList = {},
        }
      },
    }
  },
}
