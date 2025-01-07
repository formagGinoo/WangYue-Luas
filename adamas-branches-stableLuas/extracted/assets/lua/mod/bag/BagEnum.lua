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
    Partner = 4, -- 月灵
    Currency = 5, -- 货币 和 item一个背包 但是不显示
    Vehicle = 6, -- 车辆
    Robot = 7, --机器人
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
    [BagEnum.OperaType.Use] = TI18N("使用"),
    [BagEnum.OperaType.Jump] = TI18N("详情"),
    [BagEnum.OperaType.Formula] = TI18N("使用"),
}

-- 对应打开UseItemPanel面板的物品类型，类型ID对应item_type表
BagEnum.UseItemPanelType = {
    [1032] = true,      -- 礼包
    [1055] = true,      -- 体力药
    [1058] = true,      -- 随机礼包
}

