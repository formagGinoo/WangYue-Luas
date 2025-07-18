local M = {}

M.MSG_ID = {
 	["e2s_hello_world"] = 133,
 	["e2s_verify_battle"] = 134,
 	["rep_teach_add"] = 175,
 	["req_activity"] = 216,
 	["req_activity_award"] = 206,
 	["req_activity_finish_task"] = 207,
 	["req_activity_info"] = 208,
 	["req_adventure"] = 82,
 	["req_alchemy"] = 222,
 	["req_alchemy_info"] = 217,
 	["req_battle_frame"] = 113,
 	["req_battle_verify"] = 114,
 	["req_client_file_record"] = 1,
 	["req_client_login"] = 2,
 	["req_client_quit"] = 3,
 	["req_condition_state"] = 80,
 	["req_duplicate_enter"] = 71,
 	["req_duplicate_finish"] = 72,
 	["req_duplicate_quit"] = 73,
 	["req_duplicate_state"] = 74,
 	["req_ecosystem_entity_state"] = 9,
 	["req_ecosystem_hit"] = 10,
 	["req_ecosystem_state"] = 11,
 	["req_example"] = 88,
 	["req_example_spec"] = 89,
 	["req_formation_list"] = 30,
 	["req_formation_name"] = 31,
 	["req_formation_update"] = 32,
 	["req_formation_use"] = 33,
 	["req_gm_cmd"] = 61,
 	["req_gm_exec"] = 62,
 	["req_gm_list"] = 63,
 	["req_guide_add"] = 84,
 	["req_guide_init"] = 85,
 	["req_hacking_build"] = 226,
 	["req_heartbeat"] = 4,
 	["req_hero_change_weapon"] = 34,
 	["req_hero_equip_partner"] = 154,
 	["req_hero_lev_up"] = 35,
 	["req_hero_list"] = 36,
 	["req_hero_skill_lev_up"] = 37,
 	["req_hero_stage_up"] = 38,
 	["req_hero_star_up"] = 39,
 	["req_hero_sync_property"] = 40,
 	["req_hero_unequip_partner"] = 155,
 	["req_hero_use"] = 41,
 	["req_information"] = 53,
 	["req_information_nick_name"] = 54,
 	["req_information_photo_id"] = 55,
 	["req_information_signature"] = 56,
 	["req_item_drop"] = 20,
 	["req_item_list"] = 21,
 	["req_item_lock"] = 22,
 	["req_item_sell"] = 23,
 	["req_item_use"] = 24,
 	["req_mailing_active"] = 182,
 	["req_mailing_exchange"] = 183,
 	["req_map_enter"] = 91,
 	["req_map_info"] = 92,
 	["req_map_mark"] = 93,
 	["req_map_mark_remove"] = 94,
 	["req_map_sync_position"] = 95,
 	["req_map_system_jump"] = 196,
 	["req_map_to_transport_point"] = 96,
 	["req_mercenary_clean_alert_value"] = 186,
 	["req_mercenary_discover_state"] = 187,
 	["req_mercenary_fight_state"] = 188,
 	["req_mercenary_reward_list"] = 189,
 	["req_partner_lev_up"] = 163,
 	["req_partner_level_up"] = 162,
 	["req_partner_show_get_window"] = 227,
 	["req_partner_skill_lev_up"] = 164,
 	["req_quit"] = 127,
 	["req_role_init"] = 128,
 	["req_scene_msg_operate"] = 97,
 	["req_scene_msg_statistic"] = 98,
 	["req_shop_goods"] = 169,
 	["req_shop_goods_buy"] = 173,
 	["req_sys_open_add"] = 160,
 	["req_system_task_client_event"] = 213,
 	["req_system_task_commit"] = 201,
 	["req_talent_lev_up"] = 180,
 	["req_task_accept"] = 138,
 	["req_task_client_add_progress"] = 139,
 	["req_task_commit"] = 140,
 	["req_task_finished"] = 141,
 	["req_task_reset_progress"] = 142,
 	["req_task_state"] = 143,
 	["req_task_trace"] = 144,
 	["req_task_visible"] = 145,
 	["req_teach_add"] = 178,
 	["req_teach_reward"] = 176,
 	["req_unlock"] = 165,
 	["req_unlock_begin"] = 167,
 	["req_unlock_success"] = 168,
 	["req_weapon_lev_up"] = 115,
 	["req_weapon_lock"] = 116,
 	["req_weapon_refine"] = 117,
 	["req_weapon_stage_up"] = 118,
 	["req_world_level_degrade"] = 198,
 	["req_world_level_upgrade"] = 199,
 	["resp_activity"] = 218,
 	["resp_activity_award"] = 209,
 	["resp_activity_finish_task"] = 210,
 	["resp_activity_info"] = 211,
 	["resp_adventure"] = 83,
 	["resp_alchemy"] = 223,
 	["resp_alchemy_info"] = 219,
 	["resp_client_cmd"] = 205,
 	["resp_client_login"] = 5,
 	["resp_client_quit"] = 159,
 	["resp_condition_state"] = 81,
 	["resp_duplicate_enter"] = 75,
 	["resp_duplicate_finish"] = 76,
 	["resp_duplicate_quit"] = 77,
 	["resp_duplicate_state"] = 78,
 	["resp_ecosystem_entity_state"] = 12,
 	["resp_ecosystem_hit"] = 13,
 	["resp_ecosystem_state"] = 14,
 	["resp_ecosystem_transport_point"] = 15,
 	["resp_ecosystem_update"] = 16,
 	["resp_energy_info"] = 7,
 	["resp_example"] = 90,
 	["resp_formation_list"] = 42,
 	["resp_formation_name"] = 43,
 	["resp_formation_update"] = 44,
 	["resp_formation_use"] = 45,
 	["resp_gm_cmd"] = 64,
 	["resp_gm_exec"] = 65,
 	["resp_gm_list"] = 66,
 	["resp_guide_add"] = 86,
 	["resp_guide_init"] = 87,
 	["resp_heartbeat"] = 6,
 	["resp_hero_lev_up"] = 46,
 	["resp_hero_list"] = 47,
 	["resp_hero_skill_lev_up"] = 48,
 	["resp_hero_stage_up"] = 49,
 	["resp_hero_star_up"] = 50,
 	["resp_hero_sync_property"] = 51,
 	["resp_hero_use"] = 52,
 	["resp_information"] = 57,
 	["resp_information_nick_name"] = 58,
 	["resp_information_photo_id"] = 59,
 	["resp_information_signature"] = 60,
 	["resp_item_init"] = 25,
 	["resp_item_list"] = 26,
 	["resp_item_reward"] = 27,
 	["resp_item_update"] = 28,
 	["resp_item_use"] = 29,
 	["resp_mailing_exchange"] = 184,
 	["resp_mailing_info"] = 185,
 	["resp_map_enter"] = 99,
 	["resp_map_info"] = 100,
 	["resp_map_mark"] = 101,
 	["resp_map_mark_remove"] = 102,
 	["resp_map_sync_position"] = 103,
 	["resp_map_system_jump"] = 197,
 	["resp_map_to_transport_point"] = 104,
 	["resp_mercenary_alert_value"] = 190,
 	["resp_mercenary_list"] = 191,
 	["resp_mercenary_main_info"] = 192,
 	["resp_mercenary_rank"] = 193,
 	["resp_mercenary_reward_list"] = 194,
 	["resp_partner_init"] = 156,
 	["resp_partner_update"] = 157,
 	["resp_role_asset_info"] = 8,
 	["resp_role_init"] = 129,
 	["resp_scene_msg_operate_list"] = 105,
 	["resp_scene_msg_statistic"] = 106,
 	["resp_shop_goods"] = 170,
 	["resp_shop_goods_buy"] = 171,
 	["resp_statistic_info"] = 69,
 	["resp_sys_open_add"] = 161,
 	["resp_system_task_cancel"] = 214,
 	["resp_system_task_cancel_list"] = 215,
 	["resp_system_task_finished_list"] = 202,
 	["resp_system_task_list"] = 203,
 	["resp_talent_info"] = 181,
 	["resp_task_accept"] = 146,
 	["resp_task_client_add_progress"] = 147,
 	["resp_task_commit"] = 148,
 	["resp_task_finished"] = 149,
 	["resp_task_reset_progress"] = 150,
 	["resp_task_state"] = 151,
 	["resp_task_trace"] = 152,
 	["resp_task_visible"] = 153,
 	["resp_teach_last_id"] = 179,
 	["resp_teach_reward"] = 177,
 	["resp_unlock_list"] = 166,
 	["resp_weapon_init"] = 119,
 	["resp_weapon_lev_up"] = 120,
 	["resp_weapon_lock"] = 121,
 	["resp_weapon_refine"] = 122,
 	["resp_weapon_stage_up"] = 123,
 	["resp_weapon_update"] = 124,
 	["resp_world_level"] = 200,
 	["s2e_hello_world"] = 135,
 	["s2e_verify_battle"] = 136,
 	["struct_activity_task"] = 212,
 	["struct_alchemy"] = 220,
 	["struct_alchemy_formula"] = 224,
 	["struct_alchemy_history"] = 221,
 	["struct_battle"] = 137,
 	["struct_duplicate"] = 126,
 	["struct_ecosystem_drop"] = 17,
 	["struct_entity_born"] = 18,
 	["struct_entity_state"] = 19,
 	["struct_formation"] = 110,
 	["struct_gm"] = 67,
 	["struct_gm_args_desc"] = 68,
 	["struct_goods"] = 172,
 	["struct_hero"] = 111,
 	["struct_hero_skill"] = 112,
 	["struct_item"] = 79,
 	["struct_kv"] = 130,
 	["struct_map_mark"] = 107,
 	["struct_mercenary"] = 195,
 	["struct_partner"] = 158,
 	["struct_position"] = 108,
 	["struct_progress"] = 131,
 	["struct_reward_show"] = 174,
 	["struct_role_scene_msg"] = 109,
 	["struct_solution"] = 225,
 	["struct_system_task"] = 204,
 	["struct_task"] = 132,
 	["struct_tree"] = 70,
 	["struct_weapon"] = 125,
}

M.MSG_NAME = {
 	[133] = "e2s_hello_world",
 	[134] = "e2s_verify_battle",
 	[175] = "rep_teach_add",
 	[216] = "req_activity",
 	[206] = "req_activity_award",
 	[207] = "req_activity_finish_task",
 	[208] = "req_activity_info",
 	[82] = "req_adventure",
 	[222] = "req_alchemy",
 	[217] = "req_alchemy_info",
 	[113] = "req_battle_frame",
 	[114] = "req_battle_verify",
 	[1] = "req_client_file_record",
 	[2] = "req_client_login",
 	[3] = "req_client_quit",
 	[80] = "req_condition_state",
 	[71] = "req_duplicate_enter",
 	[72] = "req_duplicate_finish",
 	[73] = "req_duplicate_quit",
 	[74] = "req_duplicate_state",
 	[9] = "req_ecosystem_entity_state",
 	[10] = "req_ecosystem_hit",
 	[11] = "req_ecosystem_state",
 	[88] = "req_example",
 	[89] = "req_example_spec",
 	[30] = "req_formation_list",
 	[31] = "req_formation_name",
 	[32] = "req_formation_update",
 	[33] = "req_formation_use",
 	[61] = "req_gm_cmd",
 	[62] = "req_gm_exec",
 	[63] = "req_gm_list",
 	[84] = "req_guide_add",
 	[85] = "req_guide_init",
 	[226] = "req_hacking_build",
 	[4] = "req_heartbeat",
 	[34] = "req_hero_change_weapon",
 	[154] = "req_hero_equip_partner",
 	[35] = "req_hero_lev_up",
 	[36] = "req_hero_list",
 	[37] = "req_hero_skill_lev_up",
 	[38] = "req_hero_stage_up",
 	[39] = "req_hero_star_up",
 	[40] = "req_hero_sync_property",
 	[155] = "req_hero_unequip_partner",
 	[41] = "req_hero_use",
 	[53] = "req_information",
 	[54] = "req_information_nick_name",
 	[55] = "req_information_photo_id",
 	[56] = "req_information_signature",
 	[20] = "req_item_drop",
 	[21] = "req_item_list",
 	[22] = "req_item_lock",
 	[23] = "req_item_sell",
 	[24] = "req_item_use",
 	[182] = "req_mailing_active",
 	[183] = "req_mailing_exchange",
 	[91] = "req_map_enter",
 	[92] = "req_map_info",
 	[93] = "req_map_mark",
 	[94] = "req_map_mark_remove",
 	[95] = "req_map_sync_position",
 	[196] = "req_map_system_jump",
 	[96] = "req_map_to_transport_point",
 	[186] = "req_mercenary_clean_alert_value",
 	[187] = "req_mercenary_discover_state",
 	[188] = "req_mercenary_fight_state",
 	[189] = "req_mercenary_reward_list",
 	[163] = "req_partner_lev_up",
 	[162] = "req_partner_level_up",
 	[227] = "req_partner_show_get_window",
 	[164] = "req_partner_skill_lev_up",
 	[127] = "req_quit",
 	[128] = "req_role_init",
 	[97] = "req_scene_msg_operate",
 	[98] = "req_scene_msg_statistic",
 	[169] = "req_shop_goods",
 	[173] = "req_shop_goods_buy",
 	[160] = "req_sys_open_add",
 	[213] = "req_system_task_client_event",
 	[201] = "req_system_task_commit",
 	[180] = "req_talent_lev_up",
 	[138] = "req_task_accept",
 	[139] = "req_task_client_add_progress",
 	[140] = "req_task_commit",
 	[141] = "req_task_finished",
 	[142] = "req_task_reset_progress",
 	[143] = "req_task_state",
 	[144] = "req_task_trace",
 	[145] = "req_task_visible",
 	[178] = "req_teach_add",
 	[176] = "req_teach_reward",
 	[165] = "req_unlock",
 	[167] = "req_unlock_begin",
 	[168] = "req_unlock_success",
 	[115] = "req_weapon_lev_up",
 	[116] = "req_weapon_lock",
 	[117] = "req_weapon_refine",
 	[118] = "req_weapon_stage_up",
 	[198] = "req_world_level_degrade",
 	[199] = "req_world_level_upgrade",
 	[218] = "resp_activity",
 	[209] = "resp_activity_award",
 	[210] = "resp_activity_finish_task",
 	[211] = "resp_activity_info",
 	[83] = "resp_adventure",
 	[223] = "resp_alchemy",
 	[219] = "resp_alchemy_info",
 	[205] = "resp_client_cmd",
 	[5] = "resp_client_login",
 	[159] = "resp_client_quit",
 	[81] = "resp_condition_state",
 	[75] = "resp_duplicate_enter",
 	[76] = "resp_duplicate_finish",
 	[77] = "resp_duplicate_quit",
 	[78] = "resp_duplicate_state",
 	[12] = "resp_ecosystem_entity_state",
 	[13] = "resp_ecosystem_hit",
 	[14] = "resp_ecosystem_state",
 	[15] = "resp_ecosystem_transport_point",
 	[16] = "resp_ecosystem_update",
 	[7] = "resp_energy_info",
 	[90] = "resp_example",
 	[42] = "resp_formation_list",
 	[43] = "resp_formation_name",
 	[44] = "resp_formation_update",
 	[45] = "resp_formation_use",
 	[64] = "resp_gm_cmd",
 	[65] = "resp_gm_exec",
 	[66] = "resp_gm_list",
 	[86] = "resp_guide_add",
 	[87] = "resp_guide_init",
 	[6] = "resp_heartbeat",
 	[46] = "resp_hero_lev_up",
 	[47] = "resp_hero_list",
 	[48] = "resp_hero_skill_lev_up",
 	[49] = "resp_hero_stage_up",
 	[50] = "resp_hero_star_up",
 	[51] = "resp_hero_sync_property",
 	[52] = "resp_hero_use",
 	[57] = "resp_information",
 	[58] = "resp_information_nick_name",
 	[59] = "resp_information_photo_id",
 	[60] = "resp_information_signature",
 	[25] = "resp_item_init",
 	[26] = "resp_item_list",
 	[27] = "resp_item_reward",
 	[28] = "resp_item_update",
 	[29] = "resp_item_use",
 	[184] = "resp_mailing_exchange",
 	[185] = "resp_mailing_info",
 	[99] = "resp_map_enter",
 	[100] = "resp_map_info",
 	[101] = "resp_map_mark",
 	[102] = "resp_map_mark_remove",
 	[103] = "resp_map_sync_position",
 	[197] = "resp_map_system_jump",
 	[104] = "resp_map_to_transport_point",
 	[190] = "resp_mercenary_alert_value",
 	[191] = "resp_mercenary_list",
 	[192] = "resp_mercenary_main_info",
 	[193] = "resp_mercenary_rank",
 	[194] = "resp_mercenary_reward_list",
 	[156] = "resp_partner_init",
 	[157] = "resp_partner_update",
 	[8] = "resp_role_asset_info",
 	[129] = "resp_role_init",
 	[105] = "resp_scene_msg_operate_list",
 	[106] = "resp_scene_msg_statistic",
 	[170] = "resp_shop_goods",
 	[171] = "resp_shop_goods_buy",
 	[69] = "resp_statistic_info",
 	[161] = "resp_sys_open_add",
 	[214] = "resp_system_task_cancel",
 	[215] = "resp_system_task_cancel_list",
 	[202] = "resp_system_task_finished_list",
 	[203] = "resp_system_task_list",
 	[181] = "resp_talent_info",
 	[146] = "resp_task_accept",
 	[147] = "resp_task_client_add_progress",
 	[148] = "resp_task_commit",
 	[149] = "resp_task_finished",
 	[150] = "resp_task_reset_progress",
 	[151] = "resp_task_state",
 	[152] = "resp_task_trace",
 	[153] = "resp_task_visible",
 	[179] = "resp_teach_last_id",
 	[177] = "resp_teach_reward",
 	[166] = "resp_unlock_list",
 	[119] = "resp_weapon_init",
 	[120] = "resp_weapon_lev_up",
 	[121] = "resp_weapon_lock",
 	[122] = "resp_weapon_refine",
 	[123] = "resp_weapon_stage_up",
 	[124] = "resp_weapon_update",
 	[200] = "resp_world_level",
 	[135] = "s2e_hello_world",
 	[136] = "s2e_verify_battle",
 	[212] = "struct_activity_task",
 	[220] = "struct_alchemy",
 	[224] = "struct_alchemy_formula",
 	[221] = "struct_alchemy_history",
 	[137] = "struct_battle",
 	[126] = "struct_duplicate",
 	[17] = "struct_ecosystem_drop",
 	[18] = "struct_entity_born",
 	[19] = "struct_entity_state",
 	[110] = "struct_formation",
 	[67] = "struct_gm",
 	[68] = "struct_gm_args_desc",
 	[172] = "struct_goods",
 	[111] = "struct_hero",
 	[112] = "struct_hero_skill",
 	[79] = "struct_item",
 	[130] = "struct_kv",
 	[107] = "struct_map_mark",
 	[195] = "struct_mercenary",
 	[158] = "struct_partner",
 	[108] = "struct_position",
 	[131] = "struct_progress",
 	[174] = "struct_reward_show",
 	[109] = "struct_role_scene_msg",
 	[225] = "struct_solution",
 	[204] = "struct_system_task",
 	[132] = "struct_task",
 	[70] = "struct_tree",
 	[125] = "struct_weapon",
}

return M
