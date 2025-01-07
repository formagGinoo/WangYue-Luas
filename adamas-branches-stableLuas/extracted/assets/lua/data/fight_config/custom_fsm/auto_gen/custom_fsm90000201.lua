Config = Config or {}
Config.CustomFsm90000201 = Config.CustomFsm90000201 or { }
Config.CustomFsm90000201 = 
{
  FSMId = 90000201,
  Name = "和平总状态",
  BehaviorId = 90000201,
  SubFSMDatas = {
    {
      MachineId = 1,
      Name = "默认状态",
      IsInitState = true,
      Type = 1,
      BehaviorId = 9000020101,
      SubFSMId = 0,
      JumpTargetLists = {
        {
          TargetMachineId = 2,
          Name = "巡逻状态",
          checkFunName = "PeaceDefaultToPatrol",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 3,
          Name = "生态表演状态",
          checkFunName = "PeaceDefaultToAct",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        }
      },
    },
    {
      MachineId = 2,
      Name = "巡逻状态",
      IsInitState = false,
      Type = 1,
      BehaviorId = 9000020102,
      SubFSMId = 0,
      JumpTargetLists = {},
    },
    {
      MachineId = 3,
      Name = "生态表演状态",
      IsInitState = false,
      Type = 1,
      BehaviorId = 9000020103,
      SubFSMId = 0,
      JumpTargetLists = {},
    }
  },
}
