-- View类型
ViewType = {
    BaseView = 0
    ,MainUI = 1
    ,Panel = 2
    ,WIndow = 3
    ,Tips = 4
}

-- 资源类型
AssetType = {
    Prefab = 1
    ,Asset = 2
    ,Unity = 3
    ,Object = 9
}

-- 窗口缓存类型
CacheMode = {
    Visible = 1,	-- 关闭隐藏
	Destroy = 2	    -- 关闭立即销毁
}

-- 外观类型
LooksType = {
    None = 0
    ,Weapon = 1
    ,Hair = 2
    ,Dress = 3
}

-- AXIS
BoxLayoutAxis = {
    X = 1
    ,Y = 2
}

-- Dir
BoxLayoutDir = {
    Left = 1
    ,Right = 2
    ,Top = 3
    ,Down = 4
}

-- 方向
LuaDirection = {
    Mid = 0
    ,Left = 1
    ,Top = 2
    ,Right = 3
    ,Buttom = 4
}

-- Link类型
WinLinkType = {
    Link = 1        -- 做窗口连动
    ,Single = 2     -- 不连动
}

-- 模型预览类型
PreViewType = {
    Role = 1
    ,Npc = 2
    ,Pet = 3
    ,Shouhu = 4
    ,Wings = 5
    ,RoleWings = 6
    ,Weapon = 7
    ,Home = 8
    ,Ride = 9
}

-- 音频类型
AudioSourceType = {
    BGM = "BGM"             -- 背景音乐
    ,UI = "UI"              -- UI音效
    ,Combat = "Combat"      -- 战斗音效
    ,CombatHit = "CombatHit"      -- 战斗受击音效
    ,NPC = "NPC"            -- NPC对话
    ,Chat = "Chat"          -- 语音
}

-- 资源加载类型
-- 加载类型
AssetLoadType = {
    BothAsync = 1       -- 全导步
    ,BothSync = 2       -- 全同步
    ,FSyncAAsync = 3    -- 读取文件同步，读取资源异步
    ,FAsyncASync = 4    -- 读取文件异步，读取资源同步
}

