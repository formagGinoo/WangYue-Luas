Config = Config or {}
Config.CustomFsm900001 = Config.CustomFsm900001 or { }
Config.CustomFsm900001 = 
{
  FSMId = 900001,
  Name = "出生总状态",
  BehaviorId = 900001,
  SubFSMDatas = {
    {
      MachineId = 1,
      Name = "出生默认状态",
      IsInitState = true,
      Type = 1,
      BehaviorId = 90000101,
      SubFSMId = 0,
      JumpTargetLists = {
        {
          TargetMachineId = 2,
          Name = "特殊状态",
          checkFunName = "BornDefaultToSpecial",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 3,
          Name = "初始化状态",
          checkFunName = "BornDefaultToInitial",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        }
      },
    },
    {
      MachineId = 2,
      Name = "出生特殊状态",
      IsInitState = false,
      Type = 1,
      BehaviorId = 90000102,
      SubFSMId = 0,
      JumpTargetLists = {},
    },
    {
      MachineId = 3,
      Name = "初始化状态",
      IsInitState = false,
      Type = 1,
      BehaviorId = 90000103,
      SubFSMId = 0,
      JumpTargetLists = {},
    }
  },
}
