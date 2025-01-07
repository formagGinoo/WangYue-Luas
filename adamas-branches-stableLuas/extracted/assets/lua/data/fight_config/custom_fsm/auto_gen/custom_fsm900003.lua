Config = Config or {}
Config.CustomFsm900003 = Config.CustomFsm900003 or { }
Config.CustomFsm900003 = 
{
  FSMId = 900003,
  Name = "战斗总状态",
  BehaviorId = 900003,
  SubFSMDatas = {
    {
      MachineId = 1,
      Name = "战斗游荡总状态",
      IsInitState = true,
      Type = 2,
      BehaviorId = 0,
      SubFSMId = 90000301,
      JumpTargetLists = {
        {
          TargetMachineId = 2,
          Name = "释放技能总状态",
          checkFunName = "WanderToCastSkill",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        }
      },
    },
    {
      MachineId = 2,
      Name = "释放技能总状态",
      IsInitState = false,
      Type = 2,
      BehaviorId = 0,
      SubFSMId = 90000302,
      JumpTargetLists = {
        {
          TargetMachineId = 1,
          Name = "战斗游荡总状态",
          checkFunName = "CastSkillToWander",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        }
      },
    }
  },
}
