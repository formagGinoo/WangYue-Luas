BargainEnum = BargainEnum or {}

BargainEnum.Choice = 
{
    Up = 1,
    Under = 2,
    NoChoice = 3,
}

BargainEnum.Order = 
{
    Npc = 1,
    Together = 2,
}

BargainEnum.Strategy = 
{
    Random = 0,
    Up = 1,
    Under = 2,
    Last = 3,
    ContraryLast = 4,
}

BargainEnum.Type = 
{
    Shop = 1,
    Trade = 2,
    Bargain = 3,
}

BargainEnum.Model = 
{
    Npc = 1,
    Player = 2,
}

BargainEnum.AnimState1 = 
{
    None = 1,
    Up = 2,
    Under = 3,
    Show = 4,
}


BargainEnum.AnimState2 = 
{
    None = 1,
    Start = 2,
    End = 3,
}

BargainEnum.ResultType = 
{
    Success = 1, --成功
    Fail = 2,    --失败
    Draw = 3,    --平局
}