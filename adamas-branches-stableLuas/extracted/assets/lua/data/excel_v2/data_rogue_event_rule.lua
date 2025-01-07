-- Automatically generated - do not edit.

Config = Config or {}
Config.DataRogueEventRule = Config.DataRogueEventRule or {}


local DataRogueEventRule = Config.DataRogueEventRule
DataRogueEventRule.FindLength = 19
DataRogueEventRule.Find = {
	[1] = {id = 1, event_rule_id = 100101, game_num = {0, 1}, event_rule_basic_group = {1000101, 0}},
	[2] = {id = 2, event_rule_id = 100101, game_num = {2, 2}, event_rule_basic_group = {1000101, 1000102}},
	[3] = {id = 3, event_rule_id = 100101, game_num = {3, 3}, event_rule_basic_group = {1000101, 0}},
	[4] = {id = 4, event_rule_id = 100101, game_num = {4, 99}, event_rule_basic_group = {1000101, 1000102}},
	[5] = {id = 5, event_rule_id = 100201, game_num = {0, 1}, event_rule_basic_group = {1000201, 0}},
	[6] = {id = 6, event_rule_id = 100201, game_num = {2, 2}, event_rule_basic_group = {1000201, 0}},
	[7] = {id = 7, event_rule_id = 100201, game_num = {3, 3}, event_rule_basic_group = {1000201, 1000202}},
	[8] = {id = 8, event_rule_id = 100201, game_num = {4, 99}, event_rule_basic_group = {1000201, 1000202}},
	[9] = {id = 9, event_rule_id = 100301, game_num = {0, 1}, event_rule_basic_group = {1000301, 1000302}},
	[10] = {id = 10, event_rule_id = 100301, game_num = {2, 2}, event_rule_basic_group = {1000301, 1000302}},
	[11] = {id = 11, event_rule_id = 100301, game_num = {3, 3}, event_rule_basic_group = {1000301, 0}},
	[12] = {id = 12, event_rule_id = 100301, game_num = {4, 99}, event_rule_basic_group = {1000301, 1000302}},
	[13] = {id = 13, event_rule_id = 100401, game_num = {0, 1}, event_rule_basic_group = {1000401, 0}},
	[14] = {id = 14, event_rule_id = 100401, game_num = {2, 2}, event_rule_basic_group = {1000401, 0}},
	[15] = {id = 15, event_rule_id = 100401, game_num = {3, 3}, event_rule_basic_group = {1000401, 0}},
	[16] = {id = 16, event_rule_id = 200101, game_num = {0, 99}, event_rule_basic_group = {20001101, 0}},
	[17] = {id = 17, event_rule_id = 200201, game_num = {0, 99}, event_rule_basic_group = {20002101, 0}},
	[18] = {id = 18, event_rule_id = 200301, game_num = {0, 99}, event_rule_basic_group = {20003101, 0}},
	[19] = {id = 19, event_rule_id = 200401, game_num = {0, 99}, event_rule_basic_group = {20004101, 0}},
}
	
local DataRogueEventRule = Config.DataRogueEventRule
DataRogueEventRule.GetRuleBasicListByRuleIdLength = 8
DataRogueEventRule.GetRuleBasicListByRuleId = {
	[100101] = {{{0, 1}, {1000101, 0}}, {{2, 2}, {1000101, 1000102}}, {{3, 3}, {1000101, 0}}, {{4, 99}, {1000101, 1000102}}},
	[100201] = {{{0, 1}, {1000201, 0}}, {{2, 2}, {1000201, 0}}, {{3, 3}, {1000201, 1000202}}, {{4, 99}, {1000201, 1000202}}},
	[100301] = {{{0, 1}, {1000301, 1000302}}, {{2, 2}, {1000301, 1000302}}, {{3, 3}, {1000301, 0}}, {{4, 99}, {1000301, 1000302}}},
	[100401] = {{{0, 1}, {1000401, 0}}, {{2, 2}, {1000401, 0}}, {{3, 3}, {1000401, 0}}},
	[200101] = {{{0, 99}, {20001101, 0}}},
	[200201] = {{{0, 99}, {20002101, 0}}},
	[200301] = {{{0, 99}, {20003101, 0}}},
	[200401] = {{{0, 99}, {20004101, 0}}},
}
	

return DataRogueEventRule
