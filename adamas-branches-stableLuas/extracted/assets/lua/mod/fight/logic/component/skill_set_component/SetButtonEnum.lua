SetButtonEnum = SetButtonEnum or {}

--技能消耗的资源类型
SetButtonEnum.UseCostMode = 
{
    EntityCost = 1,
    ChargePoint = 2,
    SkillPoint = 3,
    NormalSkillPoint = 4,
    ExSkillPoint = 5,
    StaminaValue = 6,
}

--CD充能恢复的资源类型
SetButtonEnum.AssetType = 
{
    EntityCost = 1,
    ChargePoint = 2,
}

--充能的方式
SetButtonEnum.ChargeMode = 
{
    None = 1,
    AloneCD = 2,
}

--消耗来源
SetButtonEnum.CostSource = 
{
    Entity = 1,
    ParentEntity = 2,
    Player = 3
}