MessageConfig = MessageConfig or {}

MessageConfig.PanelType =
{
    PhonePanel = 1,
    MessagePanel = 2,
}

MessageConfig.ReadingMessage = {}    --存储正在阅读中的所有短信
MessageConfig.MessageTypes = {}      --存储收到的短信类型

MessageConfig.RoelMessages = {}      --按照角色来划分短信并添加短信状态
MessageConfig.SortMessages = {}      --用来排序用的(筛选)

MessageConfig.SeverMessage = {}      --接受服务器传来的数据

MessageConfig.ConditionType =
{
    Finish = 1,             --已完成
    End = 2,                --任务待处理
    Reading = 3,            --阅读中
    Start = 4,              --未开始阅读
}

MessageConfig.SortType =   --筛选类型
{
    Default = 1,           --默认排序
    Level = 2,             --等级排序
    Quality = 3,           --品质排序
    MaiXiang = 4,          --脉象
    LoveValue = 5,         --好感度
    Person = 6,            --个人
    Group = 7,             --群聊
}