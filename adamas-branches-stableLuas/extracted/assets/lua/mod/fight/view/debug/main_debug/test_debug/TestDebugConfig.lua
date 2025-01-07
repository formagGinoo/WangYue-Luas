-- Automatically generated - do not edit.

    TestDebugConfig = TestDebugConfig or {}
    
    TestDebugConfig.Find = {
     
        [101] = {id = 101, id_desc = "传送坐标", group_id = 1, group_desc = "基础功能", gm_func = "Transport", param_num = 2, param1 = "地图id", param2 = "", param3 = ""},
        [102] = {id = 102, id_desc = "修改年龄", group_id = 1, group_desc = "基础功能", gm_func = "SetAge", param_num = 0, param1 = "", param2 = "", param3 = ""},
        [103] = {id = 103, id_desc = "修改移速", group_id = 1, group_desc = "基础功能", gm_func = "ChangeRoleSpeed", param_num = 0, param1 = "", param2 = "", param3 = ""},
        [104] = {id = 104, id_desc = "重载", group_id = 1, group_desc = "基础功能", gm_func = "ReloadLua", param_num = 0, param1 = "", param2 = "", param3 = ""},
        [105] = {id = 105, id_desc = "游戏速度X2", group_id = 1, group_desc = "基础功能", gm_func = "DoubleGameSpeed", param_num = 0, param1 = "", param2 = "", param3 = ""},
        [106] = {id = 106, id_desc = "游戏速度X0.5", group_id = 1, group_desc = "基础功能", gm_func = "HalfGameSpeed", param_num = 0, param1 = "", param2 = "", param3 = ""},
        [107] = {id = 107, id_desc = "游戏速度X1", group_id = 1, group_desc = "基础功能", gm_func = "OneGameSpeed", param_num = 0, param1 = "", param2 = "", param3 = ""},
        [108] = {id = 108, id_desc = "GM", group_id = 1, group_desc = "基础功能", gm_func = "OpenGM", param_num = 0, param1 = "", param2 = "", param3 = ""},
        [109] = {id = 109, id_desc = "协议测试", group_id = 1, group_desc = "基础功能", gm_func = "ProtocolTest", param_num = 0, param1 = "", param2 = "", param3 = ""},
        [110] = {id = 110, id_desc = "执行lua代码", group_id = 1, group_desc = "基础功能", gm_func = "OpenLuaCmd", param_num = 0, param1 = "", param2 = "", param3 = ""},
        [111] = {id = 111, id_desc = "剧情控制", group_id = 1, group_desc = "基础功能", gm_func = "OpenStoryCtrl", param_num = 0, param1 = "", param2 = "", param3 = ""},   
        [112] = {id = 112, id_desc = "地图列表", group_id = 1, group_desc = "基础功能", gm_func = "OpenMapList", param_num = 0, param1 = "", param2 = "", param3 = ""},
        [113] = {id = 113, id_desc = "日志", group_id = 1, group_desc = "基础功能", gm_func = "OpenLog", param_num = 0, param1 = "", param2 = "", param3 = ""},


        [201] = {id = 201, id_desc = "角色满血", group_id = 2, group_desc = "战斗相关", gm_func = "RegenerateMaxHealth", param_num = 0, param1 = "", param2 = "", param3 = ""},
        [202] = {id = 202, id_desc = "角色死亡", group_id = 2, group_desc = "战斗相关", gm_func = "SetRoleDeath", param_num = 0, param1 = "", param2 = "", param3 = ""},
        [203] = {id = 203, id_desc = "伤害倍率", group_id = 2, group_desc = "战斗相关", gm_func = "SetDamageMultiplier", param_num = 1, param1 = "", param2 = "", param3 = ""},
        [204] = {id = 204, id_desc = "攻击碰撞", group_id = 2, group_desc = "战斗相关",gm_func = "ToggleAttackCollision", param_num = 0, param1 = "", param2 = "", param3 = ""},
        [205] = {id = 205, id_desc = "挤兑碰撞", group_id = 2, group_desc = "战斗相关", gm_func = "ToggleCollision", param_num = 0, param1 = "", param2 = "", param3 = ""},
        [206] = {id = 206, id_desc = "实体属性", group_id = 2, group_desc = "战斗相关", gm_func = "OpenEntityAttr", param_num = 0, param1 = "", param2 = "", param3 = ""},
        [207] = {id = 207, id_desc = "角色技能", group_id = 2, group_desc = "战斗相关", gm_func = "OpenRoleSkill", param_num = 0, param1 = "", param2 = "", param3 = ""},
        [208] = {id = 208, id_desc = "替换怪物", group_id = 2, group_desc = "战斗相关", gm_func = "ChangeMonster", param_num = 1, param1 = "", param2 = "", param3 = ""},
        [209] = {id = 209, id_desc = "打印实体属性", group_id = 2, group_desc = "战斗相关", gm_func = "TDLogEntityAttr", param_num = 2, param1 = "实体id", param2 = "属性id", param3 = ""},
        [210] = {id = 210, id_desc = "设置实体属性",group_id = 2, group_desc = "战斗相关", gm_func = "TDSetEntityAttr", param_num = 3, param1 = "实体id", param2 = "属性id", param3 = "属性value"},
        [211] = {id = 211, id_desc = "使用Magic", group_id = 2, group_desc = "战斗相关", gm_func = "TDDoMagic", param_num = 3, param1 = "主目标id", param2 = "从目标id", param3 = "MagicId"},
        [212] = {id = 212, id_desc = "打印护盾属性", group_id = 2, group_desc = "战斗相关", gm_func = "TDLogEntitySheild", param_num = 1, param1 = "实体id", param2 = "", param3 = ""},
        [213] = {id = 213, id_desc = "伤害报告", group_id = 2, group_desc = "战斗相关", gm_func = "OpenDamgeStatistics", param_num = 0, param1 = "", param2 = "", param3 = ""},
        [214] = {id = 214, id_desc = "伤害免疫", group_id = 2, group_desc = "战斗相关", gm_func = "SetInvincibleState", param_num = 0, param1 = "", param2 = "", param3 = ""},
        [215] = {id = 215, id_desc = "暂停/恢复怪物逻辑", group_id = 2, group_desc = "战斗相关", gm_func = "StopMonsterLogic", param_num = 0, param1 = "", param2 = "", param3 = ""},

        [301] = {id = 301, id_desc = "获得千机锁", group_id = 3, group_desc = "临时Debug", gm_func = "GetPartnerBalls", param_num = 0, param1 = "", param2 = "", param3 = ""},
        [302] = {id = 302, id_desc = "获得能力卡", group_id = 3, group_desc = "临时Debug", gm_func = "GetAbilityCard", param_num = 0, param1 = "", param2 = "", param3 = ""},
    }
    
    