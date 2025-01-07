Config = Config or {}
Config.CustomFsm90000302 = Config.CustomFsm90000302 or { }
Config.CustomFsm90000302 = 
{
  FSMId = 90000302,
  Name = "释放技能总状态",
  BehaviorId = 90000302,
  SubFSMDatas = {
    {
      MachineId = 1,
      Name = "技能默认状态",
      IsInitState = true,
      Type = 1,
      BehaviorId = 9000030201,
      SubFSMId = 0,
      JumpTargetLists = {
        {
          TargetMachineId = 3,
          Name = "技能释放状态",
          checkFunName = "CastSkillDefaultToCastingSkill",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        },
        {
          TargetMachineId = 2,
          Name = "技能转向状态",
          checkFunName = "CastSkillDefaultToTurning",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        }
      },
    },
    {
      MachineId = 2,
      Name = "技能转向状态",
      IsInitState = false,
      Type = 1,
      BehaviorId = 9000030202,
      SubFSMId = 0,
      JumpTargetLists = {
        {
          TargetMachineId = 3,
          Name = "技能释放状态",
          checkFunName = "CastSkillTurningToCastingSkill",
          useBehaviorFun = false,
          Params = {},
          DataListenerList = {},
        }
      },
    },
    {
      MachineId = 3,
      Name = "技能释放状态",
      IsInitState = false,
      Type = 1,
      BehaviorId = 9000030203,
      SubFSMId = 0,
      JumpTargetLists = {},
    }
  },
}
