BagEnum = BagEnum or {}

BagEnum.ItemType = {
    Weapon = 1,
    Armor = 2,
    Combat = 3,
    Decorations = 4,
    Skill = 5,
    Talent = 6,
    Grow = 7,
    Material = 8,
    Task = 9,
    Other = 10
}

BagEnum.BagType = {
    Weapon = 1,
    Item = 2,
    Role = 3,
    Partner = 4, -- 佩从
    Currency = 5, -- 货币 和 item一个背包 但是不显示
}

BagEnum.WeaponType = 
{
    TwoSwords = 1,
    TwoGuns = 2
}

BagEnum.SortType = {
    Quality = 1,
    Lvl = 2
}

BagEnum.CurrencyType = {
    Gold = 2,
    Diamond = 3
}

-- Tips处的按钮操作类型
BagEnum.OperaType = {
    None = 0,   -- 不显示
    Use = 1,    -- 使用
    Jump = 2,    -- 跳转
    Formula = 3    -- 配方学习
}

-- 按钮操作类型的对应描述
BagEnum.OperaDesc = {
    [BagEnum.OperaType.Use] = "使用",
    [BagEnum.OperaType.Jump] = "详情",
    [BagEnum.OperaType.Formula] = "使用",
}