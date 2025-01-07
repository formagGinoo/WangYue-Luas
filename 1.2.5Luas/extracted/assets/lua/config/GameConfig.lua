
GameConfig = GameConfig or {}

GameConfig.LoginRet = {
	Fail = 0,         
	Suc = 1,         
	LimitTime = 2,    
	LimitSection = 3
}

GameConfig.LoginState = {
	Begin = 1,      
	ConSocket = 2,
	ConLogin = 3,
	LoginSuc = 4,
	InGame = 5
}


GameConfig.UISortOrder =
{
	MainDebug = 21,
	GuideMask = 999,
}