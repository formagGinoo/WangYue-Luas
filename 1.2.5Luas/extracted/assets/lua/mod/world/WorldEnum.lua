WorldEnum = {}


WorldEnum.InteractType = 
{
	Check = 1,
	Collect = 2,
	Transport = 3,
	Talk = 4,
	Chest = 5,
	Task = 6,
	Item = 7,
	Unlock = 8,
	OpenDoor = 9,
	Jade = 10,
}

WorldEnum.InteractIcon =
{
	[WorldEnum.InteractType.Talk] = "",
	[WorldEnum.InteractType.Task] = "",
}

WorldEnum.MiniMapRefreshType =
{
	Add = 1,
	Refresh = 2,
	Remove = 3,
}
WorldEnum.MarkOpera =
{
	Add = 1,
	Refresh = 2,
	Remove = 3,
}