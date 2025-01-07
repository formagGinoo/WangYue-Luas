SetButtonEnum = SetButtonEnum or {}

--技能消耗的资源类型
SetButtonEnum.UseCostMode = 
{
    EntityCost = 1,
    ChargePoint = 2,
    SkillPoint = 3,
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