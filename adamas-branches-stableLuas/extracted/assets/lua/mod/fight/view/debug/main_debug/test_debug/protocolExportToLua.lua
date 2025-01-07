-- 生成的Lua代码
 Config = Config or {} 
 Config.protocolExport = {
   struct_ability_roulette = {
    int32__pos = 1, -- 位置
    int32__ability_id = 2, -- ability_main.id
   },
   struct_ability_roulette_partner = {
    int32__id = 1, -- roulette_partner.id
    int32__partner_id = 2, -- 绑定的月灵
   },
   -- 上线全量同步数据
   resp_ability_roulette_info = {
    repeated__struct_ability_roulette__ability_roulette_list = 1, -- 玩家配置的轮盘数据
    repeated__struct_ability_roulette_partner__partner_list = 2, -- 绑定使用的月灵列表
    int32__use_id = 3, -- 使用的轮盘能力id
    repeated__int32__ability_id_list = 4, --已解锁的能力id列表
   },
   -- 修改使用的轮盘能力id
   req_ability_roulette_use = {
    int32__use_id = 1,
   },
   -- 修改绑定的能力
   req_ability_roulette_change = {
    repeated__struct_ability_roulette__ability_list = 1,
   },
   -- 修改绑定的月灵
   req_ability_roulette_partner_change = {
    repeated__struct_ability_roulette_partner__partner = 1,
   },
   struct_activity_task = {
    int32__task_id = 1,
    bool__is_finish = 2,
   },
   -- 活跃度信息
   req_activity_info = {
   },
   resp_activity_info = {
    int32__value = 1,
    int32__control_id = 2,
    repeated__struct_activity_task__task_list = 3,
    repeated__int32__can_get = 4,
    repeated__int32__has_get = 5,
   },
   -- 领取活跃奖励
   req_activity_award = {
    int32__award_value = 1,
   },
   resp_activity_award = {
    int32__error_code = 1,
    int32__award_value = 2,
   },
   -- 探索等级
   req_adventure = {
   },
   resp_adventure = {
    int32__lev = 1,
    int32__exp = 2,
   },
   --import "struct_common.proto";
   struct_solution = {
    repeated__struct_kv__left = 1,
    repeated__struct_kv__right = 2,
   },
   struct_alchemy_formula = {
    int32__formula_id = 1,
    repeated__struct_solution__history_yin = 2,
    repeated__struct_solution__history_yang = 3,
    repeated__struct_solution__history_balance = 4,
   },
   -- 炼金系统信息
   req_alchemy_info = {
   },
   resp_alchemy_info = {
    repeated__struct_alchemy_formula__formula_list = 1,
   },
   -- 炼金请求
   req_alchemy = {
    int32__formula_id = 1,
    struct_solution__solution = 2,
    int32__count = 3,
   },
   resp_alchemy = {
    int32__error_code = 1,
    int32__formula_id = 2,
   },
   -- 体力信息
   resp_energy_info = {
    uint32__energy = 1, -- 当前体力值
    uint64__next_timestamp = 2, -- 下次加体力时间戳（单位毫秒）
   },
   -- 玩家货币
   resp_role_asset_info = {
    uint32__gold = 1,             -- 金币
    uint32__bind_diamond = 2,     -- 绑定钻石
    uint32__diamond = 3,          -- 钻石
    uint32__power = 4,            -- 能源
    uint32__mercenary_medal = 5,  -- 佣兵勋章
    uint32__gundam_copper = 6,  -- 高达核心材料
    uint32__city_copper = 7,  -- 城市币
    uint32__skill_book_copper = 8,  -- 打书币
    uint32__paota_hexin = 9,  -- 炮塔核心材料
   },
   --虚拟货币
   resp_role_virtual_item = {
    map__int32__int32____virtual_item = 1,
   },
   --import "struct_asset_center.proto";
   --import "struct_common.proto";
   --购买资产
   req_asset_center_buy_asset = {
    uint32__purchase_template_id = 1, -- 资产导购模板id
    repeated__int32__show_id_list = 2,  --墙纸装饰等id列表
   },
   --购买物件
   req_asset_center_buy_decoration = {
    uint32__asset_id = 1, --资产id
    uint32__decoration_template_id = 2, -- 物件模板id
    uint32__amount = 3, --数量
   },
   --修改物件坐标信息
   req_asset_center_change_decoration_pos = {
    uint32__asset_id = 1, --资产id
    uint32__id = 2, -- 物件唯一id
    string__pos_info = 3, --坐标信息
   },
   --资产升级
   req_asset_center_asset_level_up = {
    uint32__asset_id = 1, --资产id
   },
   --月灵技能解锁
   req_asset_partner_skill_unlock = {
    uint32__partner_id = 1, --月灵id
    uint32__skill_id = 2, --解锁技能id
    uint32__assist_partner_id = 3, --辅助月灵id
   },
   --资产列表信息
   resp_asset_center_asset_build_list = {
    repeated__struct_asset_center_build_info__asset_build_list = 1,
   },
   --单独更新某个资产的物件信息
   resp_asset_center_decoration_list = {
    uint32__asset_id = 1, --资产id
    repeated__struct_asset_center_decoration_info__decoration_list = 2,
   },
   --单独更新某个资产的物件数量信息
   resp_asset_center_decoration_count_list = {
    uint32__asset_id = 1, --资产id
    repeated__struct_kv__decoration_count_list = 2,
   },
   --单独更新物件背包信息
   resp_asset_center_decoration_bag_list = {
    repeated__struct_asset_center_decoration_info__decoration_list = 1,
   },
   --单独删除物件背包一个物件
   resp_asset_center_decoration_bag_list_del_id = {
    uint32__only_id = 1, --物件唯一id
   },
   --单独更新物件背包数量信息
   resp_asset_center_decoration_bag_count_list = {
    repeated__struct_kv__decoration_count_list = 1,
   },
   --单独更新某个资产的等级
   resp_asset_center_build_level = {
    uint32__asset_id = 1, --资产id
    uint32__level = 2, --等级
   },
   -- [资产中心][工作]设置物件工作
   req_asset_center_work_set = {
    uint32__asset_id = 1, --资产id
    uint32__decoration_id = 2, -- 物件唯一id
    repeated__int32__partner_list = 3, -- 月灵id列表
    uint32__work_id = 4, -- 工作id（D.asset_product的id）
    uint32__work_amount = 5, -- 工作数量
    uint32__product_id = 6, -- 产物id（月灵球：D.asset_partner_catch的id）
   },
   -- [资产中心][工作]修改资产上阵月灵
   req_asset_center_partner_set = {
    uint32__asset_id = 1, --资产id
    repeated__int32__partner_list = 2, -- 月灵id列表
   },
   -- [资产中心][工作]设置物件工作月灵
   req_asset_center_work_partner_set = {
    uint32__asset_id = 1, --资产id
    uint32__decoration_id = 2, -- 物件唯一id
    repeated__int32__partner_list = 3, -- 月灵id列表
   },
   -- [资产中心][工作]替换物件工作月灵
   req_asset_center_work_partner_replace = {
    uint32__asset_id = 1, --资产id
    uint32__decoration_id = 2, -- 物件唯一id（被替换的月灵的物件id）
    uint32__old_partner_id = 3, -- 旧月灵id（被替换的月灵id，为0时代表上阵到物件的空位）
    uint32__new_partner_id = 4, -- 新月灵id（替换的月灵id，为0时代表下阵到游离状态）
   },
   -- [资产中心][工作]取消物件工作
   req_asset_center_work_cancel = {
    uint32__asset_id = 1, --资产id
    uint32__decoration_id = 2, -- 物件唯一id
   },
   -- [资产中心][工作]获取物件工作产物
   req_asset_center_work_fetch = {
    uint32__asset_id = 1, --资产id
    uint32__decoration_id = 2, -- 物件唯一id
   },
   -- [资产中心][工作]设置餐桌食物
   req_asset_center_food_set = {
    uint32__asset_id = 1, --资产id
    uint32__decoration_id = 2, -- 物件唯一id
    repeated__struct_kv__food_list = 3,
   },
   -- [资产中心][工作]物件更新（工作结算）
   resp_asset_center_work_update = {
    repeated__struct_asset_center_work_update__update_list = 1,
   },
   struct_bargain = {
    int32__negotiate_id = 1, -- 交涉id
    int32__bargain_count = 2, -- 该id被该玩家使用了多少次
    int32__latest_point = 3, -- 最近一次分数记录
   },
   resp_bargain_list = {
    repeated__struct_bargain__bargain_list = 1,
   },
   --请求检查出牌序列
   req_bargain_check_seq = {
    int32__type = 1, -- 玩法类型
    int32__relate_id = 2,  -- 具体内容与玩法类型相关
    int32__negotiate_id = 3, -- 交涉id
    repeated__int32__npc_seq = 4, -- npc 出牌序列
    repeated__int32__client_seq = 5, -- 玩家出牌序列
    int32__original_point = 6, -- 前端结果
   },
   resp_bargain_point_info = {
    int32__bargain_count = 1, -- 交涉次数
    int32__original_point = 2, -- 所得分数
    int32__negotiate_id = 3, -- 交涉id
   },
   -- 消除砍价的影响
   req_bargain_remove_effect = {
    int32__type = 1,
    int32__relate_id = 2,
   },
   -- 讨价还价计算
   req_bargaining_calc = {
    int32__type = 1,
    int32__calc_id = 2,
    repeated__int32__op_seq = 3,
   },
   -- 讨价还价计算
   resp_bargaining_calc = {
    bool__result = 1,
    bool__test = 2,
   },
   enum_battle_opt  = {
    Move = 0,
    Fight = 1,
    Exit = 2,
   },
   -- erl_handle : handle_battle
   -- pt_mod : pt_mod
   -- this is first comment
   -- second comment will append the previous one
   req_battle_frame = {
    int32__frame_id = 1,
    battle_opt__battle_opt = 2,
   },
   -- this is another comment
   req_battle_verify = {
    string__key_session = 1,
    repeated__req_battle_frame__battle_frame_list = 2,
   },
   --import "struct_common.proto";
   --import "struct_build.proto";
   --购买物件
   req_build_buy_decoration = {
    uint32__template_id = 1, -- 物件模板id
    uint32__amount = 2, --数量
   },
   --修改物件坐标信息
   req_change_decoration_pos = {
    uint32__id = 1, -- 物件唯一id
    string__pos_info = 2, --坐标信息
   },
   resp_build_decoration_list = {
    repeated__struct_decoration_info__decoration_list = 1,
   },
   struct_bullet_chat = {
    int32__send_time = 1, -- 从播放timeline开始的计时，单位秒
    string__content = 2, -- 内容（文本/表情）
    int32__color = 3, -- 文本颜色
   },
   -- 请求弹幕列表
   req_bullet_chat_history = {
    int32__timeline_id = 1,
   },
   -- 返回弹幕列表
   resp_bullet_chat_history = {
    int32__timeline_id = 1,
    repeated__struct_bullet_chat__history = 2,
   },
   -- 发送弹幕
   req_bullet_chat_send = {
    int32__timeline_id = 1,
    struct_bullet_chat__bullet_chat = 2, -- 发送的弹幕
   },
   -- 紧急委托
   struct_city_operate_entrust_urgent = {
    int32__entrust_id = 1,
    int32__entrust_reward_grade = 2, -- 档位
       -- TODO 自订奖励列表
   },
   -- 店铺信息
   struct_city_operate_store = {
    int32__store_id = 1,
    int32__entrust_level = 2,
    repeated__struct_city_operate_entrust_urgent__entrust_urgent_list = 3,
    int32__max_entrust_level = 4,
   },
   -- 城市经营-信息-上线推送
   resp_city_operate_info = {
    repeated__struct_city_operate_store__store_list = 1,
   },
   -- 请求-城市经营-评级设置
   req_city_operate_entrust_level_setting = {
    int32__store_id = 1,
    int32__entrust_level = 2,
    int32__max_entrust_level = 3,
   },
   -- 请求-城市经营-委托进行
   req_city_operate_entrust_enter = {
    int32__store_id = 1,
    int32__entrust_id = 2,
    repeated__int32__use_hero_id_list = 3,
   },
   -- 请求-城市经营-委托结算
   req_city_operate_entrust_finish = {
    int32__system_duplicate_id = 1,
    bool__is_win = 2,
   },
   --import "struct_common.proto";
   -- 心跳包
   req_heartbeat = {
    uint32__client_time = 1, -- 客户端ping基准时间
   },
   resp_heartbeat = {
    uint32__client_time = 1, -- 客户端ping基准时间
    uint32__server_time = 2, -- 服务端时间
   },
   -- 客户端登录
   req_client_login = {
    string__account = 1,       -- 帐号名称（若sdk_account有值, 则应和sdk_account一致）
    uint32__type = 2,          -- 客户端类型
    string__platform = 3,      -- 平台标识
    uint32__zone_id = 4,       -- 区号
    uint32__channel_reg = 5,   -- 注册渠道
    string__dispense_id = 6,   -- 分发id
    string__device_id = 7,     -- 设备id
    string__user_id = 9,       -- 用户id（游戏维护的唯一id）
    uint32__ts = 10,           -- 时间戳
    string__ticket = 11,       -- 验证数据
    uint32__os_type = 12,      -- 设备类型,1:安卓 2:ios 3:pc
    uint32__age = 13,          -- 年龄
    string__sdk_account = 14,  -- sdk的账号
    uint64__version = 15,      -- 版本号
   },
   resp_client_login = {
    bool__flag = 1,              -- 验证结果0:失败,1:成功
    string__msg = 2,             -- 信息
    int64__server_timestamp = 3, -- 服务端unix时间戳（毫秒）
    sint32__timezone = 4,        -- 时区
    int64__uid = 5,              -- uid
   },
   -- 客户端退出
   req_client_quit = {
   },
   resp_client_quit = {
    uint32__error_code = 1,
   },
   -- 客户端记录
   req_client_file_record = {
    repeated__string__rec_list = 1,
   },
   -- 通用协议回应
   resp_client_cmd = {
    uint32__order_id = 1,        -- 序号
    uint32__cmd = 2,             -- 协议号
    uint32__notice_code = 3,
    string__module = 4,  -- 模块
    uint32__line = 5,
    string__args = 6,
   },
   --被顶号下线 -- Deprecated
   resp_client_replace = {
   },
   -- 客户端缓存
   req_client_cache_list = {
    repeated__struct_client_cache__cache_list = 1,
   },
   -- 客户端缓存
   resp_client_cache_list = {
    repeated__struct_client_cache__cache_list = 1,
   },
   -- 客户端游戏内部时间-请求
   req_client_inner_time = {
    int32__inner_time = 1,
   },
   -- 客户端游戏内部时间-回应
   resp_client_inner_time = {
    int32__inner_time = 1,
   },
   -- 查询条件状态
   req_condition_state = {
    int32__id = 1, -- 条件id
   },
   resp_condition_state = {
    int32__error_code = 1,
    int32__id = 2,
    bool__state = 3,
   },
   req_crime_add_bounty = {
    int32__crime_type = 1,
   },
   resp_crime_bounty = {
    map__int32__int32____bounty_info = 1,
   },
   req_crime_prison_game_finish = {
    int32__game_id = 1,
   },
   req_crime_prison_info = {
    int32__state = 1, --  0出狱 1坐牢
    int32__prison_id = 2, -- 监狱id
   },
   resp_crime_prison_info = {
    int32__state = 1, -- 0没在坐牢 1坐牢
    int32__prison_id = 2, -- 监狱id
    int32__bounty_value = 3, -- 剩余悬赏
    repeated__int32__finish_game = 4, -- 已经完成的小游戏
   },
   struct_sign_in = {
    int32__nth_day = 1,      -- 签到天数
    int32__status = 2,       -- 签到状态, 1:可领, 2:已领
   },
   struct_daily_sign_in = {
    int32__id = 1,         -- 签到组id
    repeated__struct_sign_in__status_list = 2,
   },
   -- 签到信息
   req_daily_sign_in_info = {
   },
   resp_daily_sign_in_info = {
    repeated__struct_daily_sign_in__daily_sign_in_list = 1,
   },
   -- 领取签到奖励
   req_daily_sign_in_award = {
    int32__id = 1,
    int32__nth_day = 2,
   },
   -- 选择对话信息
   resp_dialog_reward_info = {
    map__int32__int32____group_id_maps = 1, -- group_id - talk_id
   },
   -- 请求对话选择
   req_dialog_select = {
    int32__talk_id = 1,
   },
   -- 选择对话重置(删除记录), 按类型删除
   resp_dialog_reward_remove = {
    int32__refresh_type = 1,
   },
   -- 通知对话选项解锁
   resp_dialog_reward_unlock = {
    int32__talk_id = 1,
   },
   -- 抽卡
   req_draw = {
    int32__draw_id = 1, -- 卡池id
    int32__button = 2, -- 抽卡按钮
   },
   -- 抽卡结果
   resp_draw = {
    int32__draw_id = 1, -- 卡池id
    repeated__int32__item_list = 2, -- 抽卡奖励
   },
   -- 累计抽卡次数
   resp_draw_count = {
    int32__draw_id = 1, -- 卡池id
    int32__draw_count = 2, -- 累计抽卡次数
    int32__daily_draw_count = 3, -- 今日抽卡次数
   },
   -- 抽卡保底次数
   resp_draw_guarantee = {
    int32__draw_group_id = 1,
    int32__current_count = 2,
    int32__max_count = 3,
   },
   -- 抽卡记录-请求
   req_draw_history = {
    int32__draw_group_id = 1, -- 卡池组id
   },
   struct_draw_history = {
    int32__item_id = 1,
    int32__timestamp = 2,
   },
   -- 抽卡记录-返回
   resp_draw_history = {
    int32__draw_group_id = 1, -- 卡池组id
    repeated__struct_draw_history__history_list = 2, -- 历史记录列表
   },
   --import "struct_common.proto";
   --import "struct_duplicate.proto";
   --import "struct_item.proto";
   -------------------通用部分------------------------
   --通用副本信息
   resp_duplicate_state_list = {
    repeated__struct_duplicate_info__duplicate_list = 1,
   },
   --通用进入返回
   resp_duplicate_enter_base = {
    int32__system_duplicate_id = 1,
    repeated__struct_kv__progress_list = 2,
    struct_position__pos = 3,
    struct_position__rotate = 4,
    repeated__int32__use_hero_id_list = 5,
    repeated__struct_kv__use_buff_list = 6,
   },
   -- 通用重置副本
   req_duplicate_reset_base = {
   },
   -- 通用退出副本
   req_duplicate_quit_base = {
   },
   --通用退出返回
   resp_duplicate_quit_base = {
    int32__system_duplicate_id = 1,
    struct_position__rotate = 2,
   },
   -- 通用进度
   req_duplicate_progress_base = {
    repeated__struct_kv__progress_list = 1,
   },
   -- 通用复活点
   req_duplicate_relive_pos_base = {
    struct_position__pos = 1,
    struct_position__rotate = 2,
   },
   -- 通用副本再次挑战
   req_duplicate_again_base = {
   },
   resp_duplicate_again_base = {
    int32__system_duplicate_id = 1,
   },
   -------------------任务副本部分------------------------
   -- 进入任务副本
   req_duplicate_task_enter = {
    int32__system_duplicate_id = 1,
    struct_position__rotate = 2,
    repeated__int32__use_hero_id_list = 3,
   },
   -- 任务副本完成
   req_duplicate_task_finish = {
    int32__system_duplicate_id = 1,
    repeated__struct_kv__kill_mon_list = 2, -- 杀怪列表
    bool__is_win = 3,
   },
   --任务副本完成返回
   resp_duplicate_task_finish = {
    int32__system_duplicate_id = 1,
    repeated__struct_reward_show__reward_list = 2, -- 展示奖励列表
   },
   -------------------资源副本部分------------------------
   -- 进入资源副本
   req_duplicate_resource_enter = {
    int32__system_duplicate_id = 1,
    struct_position__rotate = 2,
    repeated__int32__use_hero_id_list = 3,
   },
   -- 资源副本完成
   req_duplicate_resource_finish = {
    int32__system_duplicate_id = 1,
    repeated__struct_kv__kill_mon_list = 2, -- 杀怪列表
    bool__is_win = 3,
   },
   --资源副本完成返回
   resp_duplicate_resource_finish = {
    int32__system_duplicate_id = 1,
    repeated__struct_reward_show__reward_list = 2, -- 展示奖励列表
   },
   -------------------梦魇副本部分------------------------
   -- 进入梦魇副本
   req_duplicate_nightmare_enter = {
    int32__system_duplicate_id = 1,
    struct_position__rotate = 2,
    repeated__int32__use_hero_id_list = 3,
    repeated__struct_kv__use_buff_list = 4,
   },
   -- 梦魇副本完成
   req_duplicate_nightmare_finish = {
    int32__system_duplicate_id = 1,
    repeated__struct_kv__kill_mon_list = 2, -- 杀怪列表
    bool__is_win = 3,
    int32__duplicate_use_time = 4,--副本耗时，秒
    int32__hp_percent = 5,       --剩余血量，万分比分子
    repeated__int32__use_hero_id_list = 6,--带入角色列表[{id1,id2}]
    repeated__struct_kv__use_buff_list = 7,--副本耗时，秒[{词缀组，第n个},{词缀组，第n个}]
   },
   --梦魇副本完成返回
   resp_duplicate_nightmare_finish = {
    int32__system_duplicate_id = 1,
    repeated__struct_reward_show__reward_list = 2, -- 展示奖励列表
   },
   -- 梦魇副本回溯
   req_duplicate_nightmare_reset = {
    int32__key_type = 1,
    int32__system_duplicate_id = 2,
   },
   -- 梦魇副本回溯返回,key_type类型,1-副本,2-组,结构为 = {type,id},,id为副本id或组id
   resp_duplicate_nightmare_reset = {
    int32__key_type = 1,
    int32__system_duplicate_id = 2,
   },
   -- 梦魇副本领取积分奖励
   req_duplicate_nightmare_get_score_award = {
    repeated__struct_kv__layer_score_list = 1,
   },
   -- 梦魇副本领取积分奖励返回
   resp_duplicate_nightmare_get_score_award = {
    repeated__struct_kv__layer_score_list = 1,
   },
   -- 梦魇层级对应最高积分返回
   resp_duplicate_nightmare_layer_score_list = {
    repeated__struct_kv__layer_score_list = 1,
   },
   -- 梦魇副本历史最佳记录返回
   resp_duplicate_nightmare_best_list = {
    int32__type = 1,
    repeated__struct_duplicate_best__duplicate_best_list = 2,
   },
   -- 梦魇副本终战记录返回
   resp_duplicate_nightmare_final_info = {
    struct_duplicate_nightmare_final__nightmare_final_info = 1,
   },
   -- 梦魇副本排行榜
   req_duplicate_nightmare_rank = {
    int32__rank_type = 1,
   },
   -- 梦魇副本排行榜返回
   resp_duplicate_nightmare_rank = {
    int32__rank_type = 1,
    repeated__struct_nightmare_rank_info__show_list = 2,
    repeated__struct_kv__rank_score_list = 3,
   },
   -------------------城市经营,委托副本部分------------------------
   --委托副本完成返回
   resp_duplicate_city_operate_finish = {
    int32__system_duplicate_id = 1,
    repeated__struct_reward_show__reward_list = 2, -- 展示奖励列表
    int32__cost_energy = 3,
   },
   --import "struct_common.proto";
   -- erl_handle : handle_ecosystem
   -- pt_mod : pt_ecosystem
   -- 月灵捕捉相关信息
   struct_conclude_info = {
    int32__probability = 1, -- 击杀后捕获概率（万分比）
    int32__time = 2, -- 使用月灵球/战斗中心跳的时间戳（秒）
   },
   struct_entity_born = {
    int64__id = 1,
    int32__reborn_time = 2,
    struct_conclude_info__conclude_info = 3,
   },
   struct_ecosystem_drop = {
    int64__id = 1,
    int32__item_template_id = 2,
    int32__item_count = 3,
    int64__form_entity_id = 4,
    int32__dead_time = 5,
    struct_position__position = 6,
   },
   -- 生态状态
   req_ecosystem_state = {
    int32__map_id = 1,
   },
   resp_ecosystem_state = {
    int32__map_id = 1,
    repeated__struct_entity_born__entity_born_list = 2,
    repeated__int64__unable_reborn_entity_list = 3,
    repeated__struct_ecosystem_drop__drop_list = 4,
   },
   -- 生态-命中操作
   req_ecosystem_hit = {
    int64__id = 1,
    struct_position__position = 2,
   },
   struct_ecosystem_hit_partner_conclude_info = {
    int32__partner_id = 1,
    int32__golden_conclude_time = 2,
   },
   resp_ecosystem_hit = {
    int64__id = 1,
    repeated__struct_ecosystem_drop__drop_list = 2,
    struct_ecosystem_hit_partner_conclude_info__partner_conclude_info = 3,
    int32__error_code = 4,
   },
   -- 生态-更新, 用于更新重生时间, 或者新增实体
   resp_ecosystem_update = {
    int32__map_id = 1,
    repeated__struct_entity_born__entity_born_list = 2,
   },
   -- 已激活的地图传送点
   resp_ecosystem_transport_point = {
    repeated__int64__entity_born_id = 1,
   },
   -- 生态实体状态
   struct_entity_state = {
    int64__entity_born_id = 1,
    int32__state = 2,
   },
   -- 生态实体状态 - 更新
   req_ecosystem_entity_state = {
    int32__map_id = 1,
    repeated__struct_entity_state__entity_state_list = 2,
   },
   -- 生态实体状态 - 下发
   resp_ecosystem_entity_state = {
    int32__map_id = 1,
    repeated__struct_entity_state__entity_state_list = 2,
   },
   -- NPC状态 - 请求
   req_npc_state = {
    repeated__struct_kv__npc_state_list = 1,
   },
   -- NPC状态 - 下发
   resp_npc_state = {
    repeated__struct_kv__npc_state_list = 1,
   },
   -- 怪物等级偏移查询-请求
   req_ecosystem_monster_level_bias = {
    repeated__int64__id_list = 1,
   },
   -- 怪物等级偏移查询-回应
   resp_ecosystem_monster_level_bias = {
    map__int64__int32____level_bias_maps = 1,
   },
   struct_battle = {
    int32__frame_id = 1,
    int64__opts = 2,
   },
   e2s_verify_battle = {
    string__session = 1,
    repeated__struct_battle__battle_list = 2,
   },
   s2e_verify_battle = {
   },
   e2s_hello_world = {
    string__msg = 1,
   },
   s2e_hello_world = {
    string__msg = 1,
   },
   s2e_hello_test = {
    string__msg = 1,
   },
   enum_example_opt  = {
    Opt1 = 0,
    Opt2 = 1,
    Opt3 = 2,
   },
   -- this is first comment
   -- second comment will append the previous one
   req_example = {
    int32__req_field = 1,
    example_opt__example_opt = 2,
   },
   -- this is another comment
   -- spec_erl_handle : handle_special
   -- spec_pt_mod : pt_special
   req_example_spec = {
    string__resp_field = 1,
   },
   resp_example = {
    string__resp_field = 1,
   },
   -- 头像框激活信息
   req_frame_list = {
   },
   -- 头像框激活信息-增量
   resp_frame_list = {
    repeated__int32__frame_list = 1,
   },
   --import "information.proto";
   --import "struct_hero.proto";
   --import "struct_weapon.proto";
   --import "struct_partner.proto";
   --import "struct_common.proto";
   struct_player_information = {
    resp_information__information = 1,
    int32__adventure_lev = 2, -- 探索等级
    int32__world_lev = 3, -- 世界等级
    repeated__struct_hero__hero_list = 4,
    repeated__struct_weapon__weapon_list = 5,
    repeated__struct_partner__partner_list = 6,
    int32__offline_timestamp = 7,
    int32__hero_num = 8, -- 角色总数
    struct_kv__identity = 9, -- 道途信息
   },
   -- 关系对象
   struct_relation_obj = {
    int64__target_id = 1,
    string__remark = 2,
    struct_player_information__info = 3,
   },
   -- 查询好友列表
   req_friend_fetch = {},
   -- 下发好友列表
   resp_friend_fetch = {
    repeated__struct_relation_obj__friend_list = 1,
   },
   -- 好友在线状态更新
   resp_friend_offline = {
    int64__target_id = 1,
    int64__timestamp = 2, -- 0为在线，大于0为离线时间戳（毫秒）
   },
   -- 玩家搜索
   req_friend_search = {
    int64__target_id = 1,
   },
   -- 好友申请
   req_friend_request = {
    int64__target_id = 1,
   },
   -- 下发好友申请
   resp_friend_request = {
    repeated__struct_relation_obj__request_list = 1,
   },
   -- 回应好友申请
   req_friend_request_reply = {
    bool__is_accept = 1,
    int64__target_id = 2,
   },
   -- 移除好友
   req_friend_remove = {
    int64__target_id = 1,
   },
   -- 下发移除好友（用于被移除方实时更新)
   resp_friend_remove = {
    int64__target_id = 1,
   },
   -- 查询黑名单列表
   req_friend_black_fetch = {},
   -- 下发黑名单列表
   resp_friend_black_fetch = {
    repeated__struct_relation_obj__black_list = 1,
   },
   -- 添加黑名单
   req_friend_black_add = {
    int64__target_id = 1,
   },
   -- 移除黑名单
   req_friend_black_remove = {
    int64__target_id = 1,
   },
   -- 查询玩家个人信息
   req_friend_info_fetch = {
    int64__target_id = 1,
   },
   -- 下发玩家个人信息
   resp_friend_info_fetch = {
    int64__target_id = 1,
    struct_player_information__info = 2,
   },
   -- 修改备注
   req_friend_remark = {
    int64__target_id = 1,
    string__remark = 2,
   },
   -- 推荐好友
   req_friend_recommend = {},
   -- 下发推荐好友
   resp_friend_recommend = {
    repeated__struct_relation_obj__recommend_list = 1,
   },
   -- 聊天
   req_friend_chat = {
    int64__target_id = 1,
    string__content = 2,
   },
   struct_chat_content = {
    int64__from_id = 1,
    string__content = 2,
    int64__timestamp = 3,
   },
   -- 下发聊天信息
   resp_friend_chat = {
    int64__target_id = 1,
    repeated__struct_chat_content__content_list = 2,
    bool__is_unread = 3,
   },
   -- 聊天标记为已读
   req_friend_chat_read = {
    int64__target_id = 1,
   },
   -- erl_handle : handle_gm
   -- pt_mod : pt_gm
   struct_gm_args_desc = {
    string__args_desc = 1,
    string__args_default = 2,
   },
   struct_gm = {
    string__gm_name = 1,
    string__gm_desc = 2,
    repeated__struct_gm_args_desc__args_desc_list = 3,
   },
   -- 旧款, 待移除
   req_gm_cmd = {
    string__cmd_str = 1,
   },
   resp_gm_cmd = {
    string__res_str = 1,
   },
   -- gm 命令列表
   req_gm_list = {
   },
   resp_gm_list = {
    repeated__struct_gm__gm_list = 1,
   },
   -- gm 执行
   req_gm_exec = {
    string__gm_name = 1,
    repeated__string__args = 2,
   },
   resp_gm_exec = {
    string__tips = 1,
   },
   -- 添加完成引导
   req_guide_add = {
    int32__id = 1, -- 引导id
   },
   resp_guide_add = {
    int32__error_code = 1,
    int32__id = 2,
   },
   req_guide_init = {
   },
   resp_guide_init = {
    repeated__int32__id_list = 2,
   },
   --import "struct_common.proto";
   -- 生成建造物
   req_hacking_build = {
    int32__build_id = 1,
   },
   -- 前端请求解锁建造
   req_hacking_build_unlock = {
    int32__build_id = 1,
   },
   -- 已解锁建造（只包含道具解锁和条件解锁）
   resp_hacking_build_unlock = {
    repeated__int32__build_id = 1,
   },
   struct_build_unlock = {
    int32__build_id = 1,
    repeated__struct_progress__progresses_list = 2,
   },
   -- 建造解锁进度
   resp_hacking_build_unlock_progress = {
    repeated__struct_build_unlock__unlock_progress_list = 1,
   },
   -- 蓝图-解锁
   req_blueprint_unlock = {
    int32__blueprint_id = 1,
   },
   struct_blueprint_connect_point = {
    string__parent_bone_name = 1,
    string__child_bone_name = 2,
    string__point_type = 3,
   },
   struct_blueprint_node = {
    int32__index = 1,
    int32__build_id = 2,
    struct_position__offset = 3,
    struct_position__rotate = 4,
    repeated__int32__parent_index = 5,
    repeated__struct_blueprint_connect_point__connect_point = 6,
   },
   struct_blueprint = {
    int64__blueprint_id = 1,
    string__name = 2,
    string__image_path = 3,
    repeated__struct_blueprint_node__nodes = 4,
   },
   -- 蓝图-保存自定义蓝图
   req_blueprint_custom_save = {
    struct_blueprint__blueprint = 1,
   },
   -- 蓝图-删除自定义蓝图
   req_blueprint_custom_delete = {
    int64__blueprint_id = 1,
   },
   -- 蓝图-信息
   resp_blueprint_info = {
    repeated__int32__unlock_list = 1,
    repeated__struct_blueprint__custom_list = 2,
    map__int64__int32____use_time = 3, -- 使用次数
    map__int64__int32____history = 4, -- 使用历史记录
   },
   -- 蓝图-放置
   req_blueprint_set = {
    int32__type = 1, -- 1：预制蓝图, 2：玩家自定义蓝图
    int64__blueprint_id = 2,
   },
   --import "struct_hero.proto";
   --import "struct_common.proto";
   -- 角色-更新列表信息
   req_hero_list = {
   },
   resp_hero_list = {
    repeated__struct_hero__hero_list = 1,
   },
   -- 角色-升级
   req_hero_lev_up = {
    int32__hero_id = 1,
    repeated__struct_kv__item_list = 2,
   },
   resp_hero_lev_up = {
    int32__error_code = 1,
   },
   -- 角色-突破
   req_hero_stage_up = {
    int32__hero_id = 1,
   },
   resp_hero_stage_up = {
    int32__error_code = 1,
   },
   -- 角色-升星
   req_hero_star_up = {
    int32__hero_id = 1,
   },
   resp_hero_star_up = {
    int32__error_code = 1,
   },
   -- 角色-技能升级
   req_hero_skill_lev_up = {
    int32__hero_id = 1,
    int32__skill_order_id = 2,
   },
   resp_hero_skill_lev_up = {
    int32__error_code = 1,
   },
   -- 编队-信息
   req_formation_list = {
   },
   resp_formation_list = {
    repeated__struct_formation__formation_list = 1,
   },
   -- 编队-更新组员
   req_formation_update = {
    int32__id = 1,
    repeated__int32__hero_id_list = 3,
   },
   resp_formation_update = {
    int32__id = 1,
    repeated__int32__hero_id_list = 3,
   },
   -- 编队-命名
   req_formation_name = {
    int32__id = 1,
    string__name = 2,
   },
   resp_formation_name = {
    int32__id = 1,
    string__name = 2,
   },
   -- 编队-出战
   req_formation_use = {
    int32__id = 1,
   },
   resp_formation_use = {
    int32__id = 1,
   },
   -- 角色-同步属性
   req_hero_sync_property = {
    int32__hero_id = 1,
    repeated__struct_kv__property_list = 3,
   },
   resp_hero_sync_property = {
    int32__error_code = 1,
   },
   -- 角色-出战
   req_hero_use = {
    int32__id = 1,
   },
   resp_hero_use = {
    int32__id = 1,
   },
   -- 角色-切换武器
   req_hero_change_weapon = {
    int32__id = 1,
    int64__weapon_id = 2,
   },
   -- 角色-穿仲魔
   req_hero_equip_partner = {
    int32__id = 1,
    int64__partner_id = 2,
   },
   -- 角色-脱仲魔
   req_hero_unequip_partner = {
    int32__id = 1,
   },
   -- 删除红点
   req_hero_del_red_point = {
    int32__id = 1,
   },
   --import "struct_common.proto";
   -- 道途信息-属性
   resp_identity_info_attr = {
    struct_kv__identity = 1,
    map__int32__int32____identity_attr_maps = 2, -- attr_id - value
    map__int32__int32____identity_level_maps = 3, -- id - current_level
   },
   -- 道途信息-奖励
   resp_identity_info_reward = {
    repeated__struct_kv__reward_list = 1, -- [{id, level}]
   },
   -- 请求-领取道途奖励
   req_identity_reward = {
    repeated__struct_kv__reward_list = 1, -- [{id, level}]
   },
   -- 请求-切换身份
   req_identity_swtich = {
    struct_kv__identity = 1,
   },
   resp_identity_swtich = {
    struct_kv__identity = 1,
   },
   -- 玩家信息
   req_information = {
   },
   resp_information = {
    string__nick_name = 1,
    string__signature = 2,
    int32__avatar_id = 5,
    int32__frame_id = 6,
    repeated__int32__hero_id_list = 7,
    repeated__int32__badge_id_list = 8,
    int32__birthday_month = 9,
    int32__birthday_day = 10,
    int32__register_date = 11,
    int32__sex = 12,
   },
   -- 玩家信息-修改昵称
   req_information_nick_name = {
    string__nick_name = 1,
   },
   resp_information_nick_name = {
    string__nick_name = 1,
   },
   -- 玩家信息-修改签名
   req_information_signature = {
    string__signature = 1,
   },
   resp_information_signature = {
    string__signature = 1,
   },
   -- 玩家信息-修改头像 Deprecated
   req_information_photo_id = {
    int32__photo_id = 1,
   },
   -- Deprecated
   resp_information_photo_id = {
    int32__photo_id = 1,
   },
   -- 玩家信息-修改头像
   req_information_avatar_id = {
    int32__avatar_id = 1,
   },
   resp_information_avatar_id = {
    int32__avatar_id = 1,
   },
   -- 玩家信息-修改头像框
   req_information_frame_id = {
    int32__frame_id = 1,
   },
   resp_information_frame_id = {
    int32__frame_id = 1,
   },
   -- 玩家信息-生日
   req_information_birthday = {
    int32__birthday_month = 1,
    int32__birthday_day = 2,
   },
   resp_information_birthday = {
    int32__birthday_month = 1,
    int32__birthday_day = 2,
   },
   -- 玩家信息-角色展框
   req_information_hero_list = {
    repeated__int32__hero_id_list = 1,
   },
   resp_information_hero_list = {
    repeated__int32__hero_id_list = 1,
   },
   -- 玩家信息-徽章
   req_information_badge_list = {
    repeated__int32__badge_id_list = 1,
   },
   resp_information_badge_list = {
    repeated__int32__badge_id_list = 1,
   },
   -- 玩家信息-设置性别
   req_information_sex = {
    int32__sex = 1,
   },
   resp_information_sex = {
    int32__sex = 1,
   },
   --import "struct_common.proto";
   --import "struct_item.proto";
   -- 更新物品信息
   req_item_list = {
   },
   resp_item_list = {
    repeated__struct_item__item_list = 1,
   },
   -- 丢弃物品-- to delete
   req_item_drop = {
    repeated__struct_item__item_list = 1,
   },
   -- 出售物品
   req_item_sell = {
    repeated__struct_item__item_list = 1,
   },
   -- 使用物品
   req_item_use = {
    int64__unique_id = 1,
    int32__count = 2,
   },
   resp_item_use = {
    int64__unique_id = 1,
    int64__count = 2,
    int32__error_code = 3,
   },
   -- 锁定物品--to delete
   req_item_lock = {
    int64__unique_id = 1,
    bool__is_lock = 2,
   },
   -- 奖励物品
   resp_item_reward = {
    int32__reward_src = 1,               -- 来源
    repeated__struct_reward_show__reward_list = 2, -- 展示奖励列表
    repeated__int64__ex_arg_list = 3,     -- 额外参数
   },
   -- 更新物品信息
   resp_item_init = {
    int32__volume = 1,
    repeated__struct_item__item_list = 2,
   },
   -- 更新物品信息
   resp_item_update = {
    repeated__struct_item__add_list = 1,
    repeated__int64__del_list = 2,
    repeated__struct_item__mod_list = 3,
   },
   -- 物品兑换
   req_item_exchange = {
    repeated__struct_kv__exchange_list = 3,
    bool__is_show = 4,
   },
   resp_item_exchange = {
    repeated__struct_kv__exchange_list = 1,
   },
   -- 使用体力物品-批量特殊使用
   req_item_use_energy = {
    repeated__struct_kv__item_list = 1,
   },
   --import "struct_common.proto";
   --import "struct_level_event.proto";
   --领取随机事件奖励
   req_level_event_get_award = {
    uint32__event_id = 1, -- 事件id
   },
   --触发事件ID
   req_level_event_trigger = {
    int32__event_id = 1, -- 事件id
   },
   --事件信息列表
   resp_level_event_info_list = {
    repeated__struct_level_event__level_event_list = 1, --事件信息列表
   },
   --事件触发ID列表
   resp_level_event_trigger_list = {
    repeated__int32__trigger_list = 1, --事件id列表
   },
   --import "struct_common.proto";
   -- 邮件结构
   struct_mail = {
    int64__id = 1,
    int32__type = 2,         -- 根据类型来确认逻辑,如title,如果是游戏系统邮件则读模板表
    int32__template_id = 3,  -- 邮件模板, 可读表(依赖type)
    string__from = 4,        -- 发件人(依赖type)
    string__title = 5,       -- 标题(依赖type)
    string__content = 6,     -- 内容(依赖type)
    repeated__struct_kv__item_list = 7,   -- 附件列表
    int32____read_flag = 8,   -- 已读标识
    int32____reward_flag = 9, -- 附件领取标识
    int32__send_ts = 10,      -- 发出时间
    int32__expire_ts = 11,   -- 过期时间
   },
   -- 邮件列表
   req_mail_list = {
   },
   resp_mail_list = {
    repeated__struct_mail__mail_list = 1,
   },
   -- 标记已经邮件
   req_mail_read = {
    int64__id = 1,
   },
   resp_mail_read = {
    int64__id = 1,
   },
   -- 领取附件
   req_mail_get_reward = {
    int64__id = 1,
   },
   resp_mail_get_reward = {
    int64__id = 1,
   },
   -- 领取附件(全部)
   req_mail_get_reward_all = {
   },
   resp_mail_get_reward_all = {
    repeated__int64__id_list = 1,
   },
   -- 删除邮件
   req_mail_delete = {
    repeated__int64__id_list = 1,
   },
   resp_mail_delete = {
    repeated__int64__id_list = 1,
   },
   -- 删除邮件(删除已读)
   req_mail_delete_read = {
   },
   resp_mail_delete_read = {
    repeated__int64__id_list = 1,
   },
   --import "struct_common.proto";
   -- 脉灵信息
   resp_mailing_info = {
     -- [ = {脉灵id， 状态（1：已激活未兑换，2：已激活已兑换）},]
    repeated__struct_kv__mailing_list = 1,
   },
   -- 激活脉灵
   req_mailing_active = {
    int32__mailing_id = 1,
   },
   -- 脉灵交付道具
   req_mailing_exchange = {
    int32__mailing_id = 1,
    int32__item_id = 2,
    int32__item_count = 3,
   },
   -- 脉灵交付道具结果
   resp_mailing_exchange = {
    int32__mailing_id = 1,
    int32__result = 2,
   },
   --import "struct_common.proto";
   -- erl_handle : handle_map
   -- pt_mod : pt_map
   struct_map_mark = {
    int32__mark_id = 1,
    int32__type = 2,
    string__name = 3,
    int32__map_id = 4,
    struct_position__position = 5,
   },
   -- 地图信息
   req_map_info = {
   },
   -- 地图信息, 上线信息
   resp_map_info = {
    int32__map_id = 1,
    struct_position__position = 2,
    struct_position__rotate = 3,
   },
   -- 同步位置
   req_map_sync_position = {
    int32__map_id = 1,
    struct_position__position = 2,
    struct_position__rotate = 3,
   },
   -- 同步位置, 仅当失败时回应上一次位置
   resp_map_sync_position = {
    int32__error_code = 1,
    int32__map_id = 2,
    struct_position__position = 3,
   },
   -- 进入地图
   req_map_enter = {
    int32__map_id = 1,
    struct_position__position = 2,
    struct_position__rotate = 3,
   },
   resp_map_enter = {
    int32__map_id = 1,
    struct_position__position = 2,
    struct_position__rotate = 3,
   },
   -- 使用地图传送点传送
   req_map_to_transport_point = {
    int64__entity_born_id = 1,
    struct_position__position = 2,
    struct_position__rotate = 3,
   },
   resp_map_to_transport_point = {
    int32__map_id = 1,
    struct_position__position = 2,
    struct_position__rotate = 3,
   },
   -- 更新地图自定义标记
   req_map_mark = {
    struct_map_mark__map_mark = 1,
   },
   resp_map_mark = {
    repeated__struct_map_mark__map_mark = 1,
   },
   -- 删除地图自定义标记
   req_map_mark_remove = {
    int32__mark_id = 1,
   },
   resp_map_mark_remove = {
    int32__mark_id = 1,
   },
   -- 请求-已激活的可传送地图标记
   req_map_system_jump = {
    repeated__int64__show_list = 1,
   },
   -- 返回-已激活的可传送地图标记
   resp_map_system_jump = {
    repeated__int64__show_list = 1,
   },
   struct_role_scene_msg = {
    int64__scene_msg_id = 1,
    int32__operation = 2,
   },
   -- [场景留言] 交互留言（点赞、点踩）
   req_scene_msg_operate = {
    struct_role_scene_msg__scene_msg = 1,
   },
   -- [场景留言] 已交互留言列表
   resp_scene_msg_operate_list = {
    repeated__struct_role_scene_msg__scene_msg = 1,
   },
   -- [场景留言] 请求 - 留言点赞、点踩统计
   req_scene_msg_statistic = {
    int64__scene_msg_id = 1,
   },
   -- [场景留言] 返回 - 留言点赞、点踩统计
   resp_scene_msg_statistic = {
    int64__scene_msg_id = 1,
    int32__like = 2,
    int32__dislike = 3,
   },
   -- 表情激活信息
   req_meme_list = {
   },
   -- 表情激活信息-增量
   resp_meme_list = {
    repeated__int32__meme_list = 1,
   },
   -- 佣兵总览信息（此信息每日刷新）
   resp_mercenary_main_info = {
    int32__main_id = 1, -- 总控id
   },
   -- 佣兵警戒值（生态交互触发增加；闲置随时间降低；花钱一次性清除）
   resp_mercenary_alert_value = {
    int32__value = 2,
   },
   -- 花钱消除警戒值
   req_mercenary_clean_alert_value = {
   },
   -- 佣兵战斗状态切换（闲置时持续降低警戒值）
   req_mercenary_fight_state = {
    int32__state = 1, -- （0：闲置；1：追击/战斗中）
   },
   struct_mercenary = {
    int64__ecosystem_id = 1, -- 生态id
    int32__level = 2, -- 佣兵等级
    repeated__int32__name_list = 3, -- 名字库id列表，拼接后为名字
    int32__discover_state = 4, -- 发现状态（0：未发现；1：已发现）
    int32__chase_state = 5, -- 追击状态（0：未追击；1：追击中）
    int64__reborn_time = 6, -- 重生时间戳（毫秒）
    int32__rank_id = 7, -- 大段位
    int32__rank_lv = 8, -- 小段位
   },
   -- 佣兵列表
   resp_mercenary_list = {
    repeated__struct_mercenary__mercenary_list = 1,
   },
   -- 发现佣兵
   req_mercenary_discover_state = {
    int64__ecosystem_id = 1,
   },
   -- 佣兵击杀玩家
   req_mercenary_kill_player = {
   },
   -- 佣兵系统段位信息
   resp_mercenary_rank = {
    int32__rank_id = 1, -- 大段位
    int32__rank_lv = 2, -- 小段位
   },
   -- 领取佣兵系统段位奖励
   req_mercenary_reward_list = {
    int32__rank_id = 1,
   },
   -- 已领取的佣兵系统段位奖励
   resp_mercenary_reward_list = {
    repeated__int32__rank_id_list = 1,
   },
   -- 晋升段位信息
   resp_mercenary_promote_info = {
    int32__promote_time = 1, -- 剩余晋升次数
    int64__last_add_promote_time = 2, -- 上次增加次数时间
   },
   -- 领取每日奖励
   req_mercenary_daily_reward = {
   },
   -- 每日奖励信息
   resp_mercenary_daily_reward = {
    int32__is_get_daily_reward = 1, -- 是否已经领取
    int32__daily_reward_rank_id = 2, -- 领取的奖励段位
   },
   struct_message = {
    int32__message_id = 1,
    int32__talk_id = 2,
    repeated__int32__option_list = 3,
   },
   req_message_read = {
    struct_message__message = 1,
   },
   resp_message_read = {
    repeated__struct_message__reading_list = 1,
    repeated__struct_message__finish_list = 2,
   },
   -- 商品信息
   struct_notice = {
    int32__id = 1,
    int32__tab = 2,
    string__title = 3,
    string__content = 4,
    int32__start_time = 5,
    int32__end_time = 6,
    string__banner = 7,
    int32__priority = 8,
   },
   -- 公告列表
   req_noticeboard_list = {
   },
   resp_noticeboard_list = {
    repeated__struct_notice__notice_list = 1,
   },
   -- 红点已读
   req_noticeboard_redpoint = {
    int32__notice_id = 1,
   },
   resp_noticeboard_redpoint = {
    repeated__int32__notice_id_list = 1,
   },
   struct_novice = {
    int32__id = 1,
    int32__acc_times = 2,
    int32__value = 3,
    repeated__int32__reward_value_list = 4,
   },
   -- 活跃度信息
   req_novice_info = {
   },
   resp_novice_info = {
    repeated__struct_novice__novice_list = 1,
   },
   -- 领取活跃奖励
   req_novice_award = {
    int32__id = 1,
    int32__reward_value = 2,
   },
   --import "struct_common.proto";
   --import "struct_partner.proto";
   -- 仲魔背包信息
   resp_partner_update = {
    repeated__struct_partner__add_list = 1,
    repeated__int64__del_list = 2,
    repeated__struct_partner__mod_list = 3,
   },
   -- 更新物品信息
   resp_partner_init = {
    int32__volume = 1,
    repeated__struct_partner__item_list = 2,
   },
   -- 锁定/解锁
   req_partner_lock = {
    int32__partner_id = 1,
    bool__is_lock = 2,
   },
   -- 仲魔升级
   req_partner_lev_up = {
    int32__partner_id = 1,
    repeated__int32__partner_id_list = 2,
    repeated__struct_kv__item_list = 3,
   },
   -- 仲魔天赋升级
   req_partner_skill_lev_up = {
    int32__partner_id = 1,
    int32__skill_id = 2,
   },
   -- 打书
   req_partner_use_skill_book = {
    int32__partner_id = 1,
    int32__pos = 2, -- 打书槽位
    int32__book_item_id = 3, -- 使用的技能书
   },
   -- 打盘
   req_partner_eat = {
    int32__partner_id = 1,
    struct_kv__pos = 2, -- 打盘槽位
    int32__eat_id = 3, -- 被吞的月灵id
   },
   -- 仲魔获取弹窗
   req_partner_show_get_window = {
    int32__partner_group_id = 1,
   },
   -- 保存月灵巅峰盘
   req_partner_panel = {
    int32__partner_id = 1,
    repeated__struct_panel__panel_list = 2,
   },
   -- 重置月灵巅峰盘
   req_partner_panel_reset = {
    int32__partner_id = 1,
   },
   -- 上线发送月灵捕捉相关信息
   resp_partner_conclude_info = {
    int32__golden_conclude_time = 1, -- 今日捕捉金色月灵次数
   },
   -- 使用月灵球
   req_partner_conclude = {
    int32__item_id = 1,
    int64__ecosystem_id = 2,
    int64__hp_percent = 3, -- 当前剩余hp（万分比）
    bool__is_break = 4, --  -- 五行击破标志
   },
   -- 使用月灵球
   resp_partner_conclude = {
    int64__ecosystem_id = 1,
    int32__probability = 2, -- 理论概率
    int32__rand_probability = 3, -- 此次随机出的数值
    bool__result = 4, -- 捕捉结果
   },
   -- 使用月灵球后的战斗心跳（脱战判断）
   req_partner_conclude_heart = {
    int64__ecosystem_id = 1,
   },
   -- 月灵捕捉重置
   req_partner_conclude_reset = {
    int64__ecosystem_id = 1,
   },
   -- 月灵融合-请求
   req_partner_fusion = {
    int32__master_partner_id = 1,
    repeated__struct_affix__master_affix_list = 2,
    int32__slave_partner_id = 3,
    repeated__struct_affix__slave_affix_list = 4,
   },
   --import "struct_common.proto";
   -- 累计付费
   resp_purchase_total_purchase = {
    int32__month_total = 1, -- 月累计付费
   },
   struct_purchase_cfg = {
    int32__id = 1,
    int32__price = 2, -- 价格
    int32__item_id = 3, -- 获得物品id
    int32__item_num = 4, -- 获得物品数量
    int32__first_item_id = 5, -- 首次充值额外物品id
    int32__first_item_num = 6, -- 首次充值额外物品数量
    int32__extra_item_id = 7, -- 非首次充值额外物品id
    int32__extra_item_num = 8, -- 非首次充值额外物品数量
    string__name = 9, -- 名称
    string__icon = 10, -- 图表
    string__icon_bg = 11, -- 背景
    int32__priority = 12, -- 优先级
   },
   -- 充值配置
   resp_purchase_cfg = {
    repeated__struct_purchase_cfg__cfg_list = 1,
   },
   -- 充值信息
   resp_purchase_info = {
    repeated__struct_kv__buy_count_list = 1,
   },
   -- 充值
   req_purchase_buy = {
    int32__id = 1,
   },
   struct_purchase_package_cfg = {
    int32__id = 1,
    int32__price = 2, -- 价格
    string__name = 3, -- 名称
    string__icon = 4,  -- 图标
    int32__page = 5, -- 所属分页
    int32__cost_item = 6, -- 消耗道具
    int32__cost_item_num = 7, -- 消耗道具数量
    int32__reward_id = 8, -- 奖励id
    int32__buy_limit = 9, -- 购买次数限制
    int32__refresh = 10, -- 次数限制重置id
    int32__show_tag = 11, -- 标签
    string__show_discount = 12, -- 显示折扣
    bool__soldout_show = 13, -- 售罄显示
    int32__priority = 14, -- 优先级
   },
   -- 礼包配置信息
   resp_purchase_package_cfg = {
    repeated__struct_purchase_package_cfg__cfg_list = 1,
   },
   -- 礼包购买信息
   resp_purchase_package_info = {
    repeated__struct_kv__buy_count_list = 1,
   },
   -- 买礼包
   req_purchase_package_buy = {
    int32__id = 1,
   },
   struct_monthcard = {
    int32__id = 1,
    int32__rest_day = 2, -- 剩余天数
    int32__is_reward = 3, -- 是否已经领取
   },
   -- 月卡信息
   resp_monthcard_info = {
    repeated__struct_monthcard__card_list = 1,
   },
   -- 买月卡
   req_monthcard_buy = {
    int32__id = 1,
   },
   -- 领取每日奖励
   req_monthcard_reward = {
    int32__id = 1,
   },
   struct_rogue_area_logic = {
    int32__area_logic_id = 1,
    map__int32__bool____current_event_maps = 2,
   },
   struct_season_event = {
    int32__event_id = 1,
    bool__is_discovered = 2,     -- 是否已发现
    int32__finish_ts = 3,  -- 第一次完成时间戳
   },
   -- 初始信息
   req_rogue_info = {
   },
   resp_rogue_info = {
    int32__season_version_id = 1,
    int32__area_version_id = 2,
    int32__game_round = 3,
    map__int32__struct_rogue_area_logic____rogue_area_logic_maps = 4,
    int32__season_schedule = 6, -- 赛季进度值, 每完成一个区域则累加1
    repeated__int32__season_schedule_reward_list = 7, -- 赛季进度奖励, 已领列表
    int32__game_refresh_times = 8, -- 可刷新次数
    int32__game_last_refresh_ts = 9, -- 上次一刷新时间
    repeated__int32__game_discovered_event_list = 11, -- 已发现事件
    repeated__struct_season_event__season_event_list = 12, -- 赛季事件
   },
   -- 完成事件
   req_rogue_event_finish = {
    int32__area_logic_id = 1,
    int32__event_id = 2,
   },
   resp_rogue_event_finish = {
    int32__area_logic_id = 1,
    int32__event_id = 2,
    int32__season_schedule = 3, -- 赛季进度值, 每完成一个区域则累加1
    int32__ts = 4,
   },
   -- 刷新重启次数/时间
   resp_rogue_info_refresh = {
    int32__game_refresh_times = 1, -- 可刷新次数
    int32__game_last_refresh_ts = 2, -- 上次一刷新时间
   },
   -- 领取赛季奖励
   req_rogue_season_schedule_reward = {
    repeated__int32__reward_level_list = 2, -- 领取的等级
   },
   -- 重启世界
   req_rogue_restart = {
    repeated__int32__remove_card_id_list = 1,
   },
   -- 上线同步卡牌信息
   resp_rogue_card_info = {
    map__int32__int32____card_bag = 1, -- 卡牌库 #{CardId
    map__int32__int32____card_equip = 2, -- 装备中的卡牌 #{CardId
    map__int32__int32____current_round_card_bag = 3, -- 卡牌库 #{CardId
   },
   -- 选择卡牌奖励
   req_rogue_card_choose = {
    int32__card_id = 1,
   },
   -- 卡牌奖励选择列表
   resp_rogue_card_choice_list = {
    repeated__int32__card_list = 1,
    int32__area_logic = 2,
   },
   -- 装备卡牌
   req_rogue_card_equip = {
    map__int32__int32____card_equip = 1, -- 需要装备的卡牌 #{CardId
   },
   -- 发现事件
   req_rogue_event_discover = {
    int32__area_logic_id = 1,
    int32__event_id = 2,
   },
   req_quit = {
   },
   -- 初始信息
   req_role_init = {
   },
   -- 初始信息结束
   resp_role_init = {
   },
   -- 玩家维度-属性信息
   resp_role_property = {
    map__int32__int32____property_maps = 1,
   },
   -- 玩家维度-属性同步
   req_role_property_sync = {
    map__int32__int32____property_maps = 1,
   },
   -- 玩家踢下线通知
   resp_role_kick_offline = {
    int32__kick_type = 1,
    string__kick_context = 2,     -- 内容
    int64__version = 3, --版本号
   },
   --import "struct_common.proto";
   -- 商品信息
   struct_goods = {
    int32__goods_id = 1, -- 商品id
    int32__item_id = 2, -- 物品id
    int32__item_count = 3, -- 单份数量
    repeated__struct_kv__consume = 4, -- 消耗
    int32__condition = 5, -- 开放条件
    int32__buy_limit = 6, -- 限购数量
    int32__refresh_id = 7, -- 重置id
    int32__buy_count = 8, -- 已购份数
    int32__priority = 9, -- 排序优先级
    bool__is_bargain = 10, -- 是否受到砍价的影响
   },
   -- 请求商品列表
   req_shop_goods = {
    int32__shop_id = 1,
   },
   -- 返回商品列表
   resp_shop_goods = {
    int32__shop_id = 1, -- 商店id
    int32__refresh_type = 2, -- 刷新类型
    repeated__struct_goods__goods_list = 3, -- 商品列表
    int32__discount = 4,-- 商品折扣 万分比  前端/10000
   },
   -- 购买商品
   req_shop_goods_buy = {
    int32__goods_id = 1, -- 商品id
    int32__buy_count = 2, -- 购买数量
   },
   -- 统计数据
   resp_statistic_info = {
    struct_tree__statistic_info = 1,
   },
   -- 客户端统计信息, 增量方式
   req_statistic_client_control_add = {
    int32__type = 1,
    int32__add_value = 2,
   },
   struct_tree = {
    int32__key = 1,
    int32__value = 2,
    repeated__struct_tree__next = 3,
   },
   --import "struct_common.proto";
   struct_asset_center_build_info = {
    int32__asset_id = 1,
    int32__level = 2,
    repeated__struct_asset_center_decoration_info__decoration_list = 3,
    repeated__struct_kv__decoration_count_list = 4,
    string__pos_info = 5,
    repeated__int32__partner_list = 6, -- 上阵月灵id列表
   },
   -- 物件工作相关信息
   struct_asset_center_decoration_work_info = {
    repeated__int32__partner_list = 1, -- 月灵id列表
    int32__last_refresh_time = 2, -- 上次结算时间戳（秒）
    uint32__work_id = 3, -- 工作id（D.asset_product的id）
    int32__work_amount = 4, -- 工作数量
    int32__work_value = 5, -- 工作量
    int32__finish_amount = 6, -- 完成数量
    uint32__product_id = 7, -- 产物id（月灵球：D.asset_partner_catch的id）
    repeated__struct_kv__food_list = 8, -- 食物id, 食物数量
   },
   -- 物件信息
   struct_asset_center_decoration_info = {
    int32__id = 1,
    int32__template_id = 2,
    string__pos_info = 3,
    struct_asset_center_decoration_work_info__work_info = 4,
   },
   -- 物件更新（工作结算）
   struct_asset_center_work_update = {
    uint32__asset_id = 1,
    repeated__struct_asset_center_decoration_info__decoration_list = 2,
   },
   --import "struct_common.proto";
   struct_decoration_info = {
    int32__id = 1,
    int32__template_id = 2,
    string__pos_info = 3,
   },
   struct_kv = {
    int32__key = 1,
    int32__value = 2,
   },
   -- 进度值
   struct_progress = {
    int32__id = 1,
    int32__current = 2,
   },
   -- 位置
   struct_position = {
    int32__pos_x = 1,
    int32__pos_y = 2,
    int32__pos_z = 3,
   },
   struct_client_cache = {
    string__cache_key = 1,
    repeated__string__cache_value = 2,
   },
   --import "struct_common.proto";
   struct_duplicate_key = {
    int32__duplicate_id = 1,
    int32__system_duplicate_id = 2,
    int32__task_duplicate_id = 3,
   },
   struct_duplicate = {
    struct_duplicate_key__key = 1,
    int32__best_score = 2,
    int32__finished_times = 3, -- 完成次数
   },
   struct_duplicate_info = {
    int32__system_duplicate_id = 1,
    int32__finished_times = 2, -- 完成次数
    int32__best_score = 3,
    int32__current_score = 4,
    repeated__int32__use_hero_id_list = 5,
    repeated__struct_kv__use_buff_list = 6,
    int32__win_times = 7,
   },
   struct_duplicate_best = {
    int32__duplicate_best_key_type = 1,
    int32__duplicate_best_key_sysdupid = 2,
    repeated__struct_duplicate_best_info__duplicate_best_info_list = 3,
   },
   struct_duplicate_best_info = {
    int32__system_duplicate_id = 1,
    int32__best_score = 2,
    int32__use_time = 3,
    int32__hp_percent = 4,
    repeated__int32__use_hero_id_list = 5,
    repeated__struct_kv__use_buff_list = 6,
   },
   struct_duplicate_nightmare_final = {
    int32__round = 1,
    int32__layer = 2,
    int32__old_layer = 3,
    int32__last_time = 4,
    int32__order = 5,
    int32__duplicate_rule = 6,
    int32__level = 7,
   },
   struct_nightmare_rank_info = {
    int64__user_id = 1,
    string__user_name = 2,
    int32__score = 3,
    repeated__int32__hero_list = 4,
    int32__frame = 5,
   },
   --import "struct_common.proto";
   -- 技能信息
   struct_hero_skill = {
    int32__order_id = 1,
    int32__lev = 2,
    int32__ex_lev = 3,
   },
   struct_hero = {
    int64__id = 1,
    int32__lev = 2,
    int32__exp = 3,
    int32__stage = 4,
    int32__star = 5,
    bool__is_new = 6, -- 是否是新获得, 目前以这个标志更新临时属性
    int64__weapon_id = 7,
    int64__partner_id = 8,
    repeated__struct_kv__property_list = 9,
    repeated__struct_hero_skill__skill_list = 10,
   },
   struct_formation = {
    int32__id = 1,
    string__name = 2,
    repeated__int32__hero_id_list = 3,
   },
   struct_item = {
    int64__unique_id = 1,
    int32__template_id = 2,
    int32__count = 3,
    bool__is_locked = 4, -- to del
   },
   struct_reward_show = {
    int64__unique_id = 1,
    int32__template_id = 2,
    int32__count = 3,
   },
   --import "struct_common.proto";
   struct_level_event = {
    int32__event_id = 1,
    int32__first_finish_time = 2,
   },
   --import "struct_common.proto";
   -- 月灵巅峰盘技能信息
   struct_panel_skill = {
    int32__skill_id = 1,
    struct_kv__pos = 2,
    bool__is_active = 3,
   },
   -- 月灵巅峰盘信息
   struct_panel = {
    int32__panel_id = 1,
    int32__template_id = 2,
    repeated__struct_panel_skill__skill_list = 3,
    struct_kv__pos = 4,
    int32__rotate = 5,
   },
   -- 月灵职业特性词缀
   struct_affix = {
    int32__id = 1,
    int32__level = 2,
   },
   -- 月灵工作信息
   struct_partner_work = {
    int32__satiety = 1, -- 饱食度
    int32__san = 2, -- san值
    int32__asset_id = 3, -- 所在资产id
    int32__status = 4, -- 状态（0：无, 1：工作, 2: 吃饭, 3: 睡觉）
    int32__work_speed = 5, -- 工作速度
    int32__work_decoration_id = 6, -- 工作所在物件id
    int32__status_decoration_id = 7, -- 吃饭/睡觉占用的物件id
   },
   -- 月灵信息
   struct_partner = {
    int64__unique_id = 1,
    int32__template_id = 2,
    int32__hero_id = 3,
    int32__lev = 4,
    int32__exp = 5,
    repeated__struct_kv__property_list = 6,
    repeated__struct_kv__skill_list = 7,
    repeated__struct_kv__passive_skill_list = 8,
    repeated__struct_panel__panel_list = 9,
    bool__is_locked = 10,
    repeated__struct_affix__affix_list = 11,
    struct_partner_work__work_info = 12, -- 工作信息
    repeated__int32__asset_skill_list = 13, --月灵中心解锁技能
   },
   --import "struct_common.proto";
   -- 任务
   struct_task = {
    int32__id = 1,
    int32__step = 2,
    bool__finish = 3,
    struct_progress__progress = 4,
    bool__in_progress = 5,
   },
   -- 任务节点
   struct_task_node = {
    int32__node_id = 1,
    repeated__struct_task__task_list = 2,
   },
   -- 任务章节
   struct_task_group = {
    int32__group_id = 1,
    int32__dream_id = 2,
    int32__start_node = 3,
    int32__current_node = 4,
    map__int32__struct_task_node____task_node = 5,
   },
   -- 完成的节点信息
   struct_finish_task_node = {
    repeated__int32__task_list = 1,
   },
   struct_weapon = {
    int64__unique_id = 1,
    int32__template_id = 2,
    int32__lev = 3,
    int32__exp = 4,
    int32__stage = 5,
    int32__refine = 6,
    int32__hero_id = 7,
    bool__is_locked = 8,
   },
   --import "struct_common.proto";
   -- 系统任务结构
   struct_system_task = {
    int32__id = 1,
    repeated__struct_progress__progress_list = 2,
    bool__finish = 3,
   },
   -- 返回-系统任务-任务列表
   resp_system_task_list = {
    repeated__struct_system_task__task_list = 1,
   },
   -- 返回-系统任务-已完成任务列表
   resp_system_task_finished_list = {
    repeated__int32__finished_list = 1,
   },
   -- 请求-系统任务-提交
   req_system_task_commit = {
    int32__id = 1,
   },
   -- 回应-系统任务-取消
   resp_system_task_cancel_list = {
    repeated__int32__cancel_list = 1,
   },
   -- 前端触发事件
   req_system_task_client_event = {
    int32__event_type = 1,
    repeated__int32__arg_list = 2,
   },
   -- 添加系统开启记录
   req_sys_open_add = {
    int32__id = 1,
   },
   resp_sys_open_add = {
    repeated__int32__id = 1,
   },
   --import "struct_common.proto";
   -- 天赋信息
   resp_talent_info = {
    repeated__struct_kv__talent_list = 1,
   },
   -- 天赋升级
   req_talent_lev_up = {
    int32__talent_id = 1,
   },
   --import "struct_task.proto";
   -- 上线批量发送任务信息
   resp_task_info = {
    repeated__struct_task_group__task_group = 1,
    int32__task_dream_id = 2,
    repeated__struct_task_group__task_dream = 3,
    map__int32__struct_finish_task_node____task_node_finished = 4,
    int32__task_trace = 5,
   },
   -- 更新任务节点信息（节点切换）
   resp_task_node_update = {
    struct_task_node__task_node = 1,
   },
   -- 更新单条任务信息
   resp_task_update = {
    repeated__struct_task__task_list = 1,
   },
   -- 前端修改任务追踪
   req_task_trace = {
    int32__task_id = 1,
   },
   -- 推送任务追踪
   resp_task_trace = {
    int32__task_id = 1,
   },
   -- 前端控制任务进度
   req_task_client_add_progress = {
    int32__task_id = 1,
    int32__step_id = 2,
    int32__add_num = 3,
    int32__type = 4,
   },
   -- 重置任务进度
   req_task_reset_progress = {
    int32__task_id = 1,
   },
   -- 领取任务阶段奖励
   req_task_reward = {
    int32__task_id = 1,
   },
   -- 已经领取的任务阶段奖励
   resp_task_reward = {
    repeated__int32__task_id = 1,
   },
   struct_task_choice = {
    int32__id = 1, -- cfg_task_choose_weight.id
    map__int32__int32____task_choice_count_maps = 2, -- {task_id, count}
   },
   -- 全服任务完成统计
   req_task_finish_statistic = {
    int32__type = 1,
    int32__sec_type = 2,
   },
   -- 全服任务完成统计
   resp_task_finish_statistic = {
    int32__type = 1,
    int32__sec_type = 2,
    repeated__struct_task_choice__choice_list = 3,
   },
   -- 添加教学
   req_teach_add = {
    int32__id = 1,
   },
   -- 领取教学奖励
   req_teach_reward = {
    int32__id = 1,
   },
   -- 领取教学奖励返回
   resp_teach_reward = {
    int32__id = 1,
   },
   -- 最近添加的教学
   resp_teach_last_id = {
    repeated__int32__id_list = 1,
   },
   struct_order = {
    int32__id = 1,
    int32__bargain_result = 2, -- 讨价还价结果 0: 未进行, 1: 成功, 2:失败
    int32__discount = 3,
   },
   struct_store = {
    int32__id = 1,
    repeated__struct_order__order_list = 2,
    int32__next_refresh_ts = 3,
   },
   -- 请求交易信息
   req_trade_info = {
   },
   -- 回应交易信息
   resp_trade_info = {
    repeated__struct_store__store_list = 1,
   },
   -- 请求激活交易库
   req_trade_store_activate = {
    int32__store_id = 1,
   },
   -- 请求交易订单
   req_trade_order = {
    int32__store_id = 1,
    int32__order_id = 2,
    int32__item_id = 3,
   },
   -- 开始开锁
   req_unlock_begin = {
    int32__id = 1,
   },
   -- 开锁成功
   req_unlock_success = {
    int32__id = 1,
   },
   -- 已开锁id列表
   resp_unlock_list = {
    repeated__int32__unlock_list = 1,
   },
   resp_vehicle_unlock_list = {
    repeated__int32__unlock_list = 1,
   },
   --import "struct_common.proto";
   --import "struct_weapon.proto";
   -- 武器-升级
   req_weapon_lev_up = {--20003
    int32__weapon_id = 1,
    repeated__int32__weapon_id_list = 2,
    repeated__struct_kv__item_list = 3,
   },
   resp_weapon_lev_up = {
    int32__error_code = 1,
   },
   -- 武器-突破
   req_weapon_stage_up = {
    int32__weapon_id = 1,
   },
   resp_weapon_stage_up = {
    int32__error_code = 1,
   },
   -- 武器-精炼
   req_weapon_refine = {
    int32__weapon_id = 1,
    repeated__int32__weapon_id_list = 2,
   },
   resp_weapon_refine = {
    int32__error_code = 1,
   },
   -- 初始化武器信息
   resp_weapon_init = {
    int32__volume = 1,
    repeated__struct_weapon__item_list = 2,
   },
   -- 更新武器信息
   resp_weapon_update = {
    repeated__struct_weapon__add_list = 1,
    repeated__int64__del_list = 2,
    repeated__struct_weapon__mod_list = 3,
   },
   -- 武器-锁定
   req_weapon_lock = {
    int32__weapon_id = 1,
    bool__is_lock = 2,
   },
   resp_weapon_lock = {
    int32__error_code = 1,
   },
   -- 返回-世界等级-信息
   resp_world_level = {
    int32__level = 1,
    int32__max_level = 2,
   },
   -- 请求-世界等级-升级
   req_world_level_upgrade = {
   },
   -- 请求-世界等级-降级
   req_world_level_degrade = {
   },
}

