FormationConfig = FormationConfig or {}

FormationConfig.MaxRoleNum = 3

FormationConfig.Sort = {
	Element = 1,
	Type = 2,
}

FormationConfig.SortElement = {
	[1] = TI18N("全部"),
	[2] = TI18N("金"),
	[3] = TI18N("木"),
	[4] = TI18N("水"),
	[5] = TI18N("火"),
	[6] = TI18N("土"),
}

FormationConfig.SortType = {
	[1] = TI18N("培养"),
	[2] = TI18N("品质"),
}

FormationConfig.SelectMode =
{
	Single = 1,
    Plural = 2
}

FormationConfig.SyncProperty =
{
	MaxLife = 1,
	CurLife = 1001,
}

FormationConfig.CameraPos = 
{
	[1] = {pos = {x = 0.8, y = 1.3, z = 2.28}, rot = {y = 180}},
	[2] = {pos = {x = - 0.27, y = 1.29, z = 2.89}, rot = {y = 180}},
	[3] = {pos = {x = -1.42, y = 1.3, z = 2.28}, rot = {y = 180}},
	Far = {pos = {x = 0, y = 0.89, z = 5}, rot = {y = 180}}
}

FormationConfig.ModelPos = {
	Far_1 = {rot = {y = -13}},
	Far_2 = {rot = {y = 0}},
	Far_3 = {rot = {y = 13}},
	Near_1 = {rot = {y = -7.01}},
	Near_2 = {rot = {y = -5.75}},
	Near_3 = {rot = {y = -7.01}},
}

FormationConfig.FormationState = {
	FightEnum.EntityState.Idle,
	FightEnum.EntityState.FightIdle,
	FightEnum.EntityState.Move,
	FightEnum.EntityState.CloseMenu,
}