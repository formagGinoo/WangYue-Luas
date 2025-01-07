DmageDebugConfig = DmageDebugConfig or {}

DmageDebugConfig.SkillTypeP = 
{
    {FightEnum.SkillType.Unique,FightEnum.SkillType.UniqueStart},
    {FightEnum.SkillType.Core},
    {FightEnum.SkillType.Skill},
    {FightEnum.SkillType.NormalAttack},
    {FightEnum.SkillType.JumpCounter, FightEnum.SkillType.JumpCounterTread, FightEnum.SkillType.JumpCounterAttack},
}

DmageDebugConfig.M_SkillType = 
{
    Unique = 1,
    Core = 2,
    Skill = 3,
    NormalAttack = 4,
    JumpCounter = 5,
    Other = 6
}

DmageDebugConfig.M_SkillTypeName = 
{
    [DmageDebugConfig.M_SkillType.Unique] = "大招",
    [DmageDebugConfig.M_SkillType.Core] = "核心",
    [DmageDebugConfig.M_SkillType.Skill] = "技能",
    [DmageDebugConfig.M_SkillType.NormalAttack] = "普攻",
    [DmageDebugConfig.M_SkillType.JumpCounter] = "跳反",
    [DmageDebugConfig.M_SkillType.Other] = "其他",

}

DmageDebugConfig.SkillType2M = 
{
    [FightEnum.SkillType.NormalAttack] = DmageDebugConfig.M_SkillType.NormalAttack,
    [FightEnum.SkillType.Unique] = DmageDebugConfig.M_SkillType.Unique,
    [FightEnum.SkillType.UniqueStart] = DmageDebugConfig.M_SkillType.Unique,
    [FightEnum.SkillType.JumpCounter] = DmageDebugConfig.M_SkillType.JumpCounter,
    [FightEnum.SkillType.JumpCounterTread] = DmageDebugConfig.M_SkillType.JumpCounter,
    [FightEnum.SkillType.JumpCounterAttack] = DmageDebugConfig.M_SkillType.JumpCounter,
    [FightEnum.SkillType.Skill] = DmageDebugConfig.M_SkillType.Skill,
    [FightEnum.SkillType.Core] = DmageDebugConfig.M_SkillType.Core,
}