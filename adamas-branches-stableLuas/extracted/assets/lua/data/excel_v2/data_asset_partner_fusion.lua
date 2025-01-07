-- Automatically generated - do not edit.

Config = Config or {}
Config.DataAssetPartnerFusion = Config.DataAssetPartnerFusion or {}


local DataAssetPartnerFusion = Config.DataAssetPartnerFusion
DataAssetPartnerFusion.FindLength = 37
DataAssetPartnerFusion.Find = {
	[1] = {id = 1, master_affix_level = 1, slave_affix_level = 1, result_affix_level = 2, weight = 10000},
	[2] = {id = 2, master_affix_level = 1, slave_affix_level = 2, result_affix_level = 2, weight = 10000},
	[3] = {id = 3, master_affix_level = 1, slave_affix_level = 2, result_affix_level = 3, weight = 6000},
	[4] = {id = 4, master_affix_level = 1, slave_affix_level = 3, result_affix_level = 3, weight = 10000},
	[5] = {id = 5, master_affix_level = 1, slave_affix_level = 3, result_affix_level = 4, weight = 3600},
	[6] = {id = 6, master_affix_level = 1, slave_affix_level = 4, result_affix_level = 4, weight = 10000},
	[7] = {id = 7, master_affix_level = 1, slave_affix_level = 4, result_affix_level = 5, weight = 2160},
	[8] = {id = 8, master_affix_level = 1, slave_affix_level = 5, result_affix_level = 5, weight = 10000},
	[9] = {id = 9, master_affix_level = 2, slave_affix_level = 1, result_affix_level = 2, weight = 10000},
	[10] = {id = 10, master_affix_level = 2, slave_affix_level = 1, result_affix_level = 3, weight = 6000},
	[11] = {id = 11, master_affix_level = 2, slave_affix_level = 2, result_affix_level = 3, weight = 10000},
	[13] = {id = 13, master_affix_level = 2, slave_affix_level = 3, result_affix_level = 3, weight = 10000},
	[14] = {id = 14, master_affix_level = 2, slave_affix_level = 3, result_affix_level = 4, weight = 6000},
	[15] = {id = 15, master_affix_level = 2, slave_affix_level = 4, result_affix_level = 4, weight = 10000},
	[16] = {id = 16, master_affix_level = 2, slave_affix_level = 4, result_affix_level = 5, weight = 3600},
	[17] = {id = 17, master_affix_level = 2, slave_affix_level = 5, result_affix_level = 5, weight = 10000},
	[18] = {id = 18, master_affix_level = 3, slave_affix_level = 1, result_affix_level = 3, weight = 10000},
	[19] = {id = 19, master_affix_level = 3, slave_affix_level = 1, result_affix_level = 4, weight = 3600},
	[20] = {id = 20, master_affix_level = 3, slave_affix_level = 2, result_affix_level = 3, weight = 10000},
	[21] = {id = 21, master_affix_level = 3, slave_affix_level = 2, result_affix_level = 4, weight = 6000},
	[22] = {id = 22, master_affix_level = 3, slave_affix_level = 3, result_affix_level = 4, weight = 10000},
	[23] = {id = 23, master_affix_level = 3, slave_affix_level = 4, result_affix_level = 4, weight = 10000},
	[24] = {id = 24, master_affix_level = 3, slave_affix_level = 4, result_affix_level = 5, weight = 6000},
	[25] = {id = 25, master_affix_level = 3, slave_affix_level = 5, result_affix_level = 5, weight = 10000},
	[26] = {id = 26, master_affix_level = 4, slave_affix_level = 1, result_affix_level = 4, weight = 10000},
	[27] = {id = 27, master_affix_level = 4, slave_affix_level = 1, result_affix_level = 5, weight = 2160},
	[28] = {id = 28, master_affix_level = 4, slave_affix_level = 2, result_affix_level = 4, weight = 10000},
	[29] = {id = 29, master_affix_level = 4, slave_affix_level = 2, result_affix_level = 5, weight = 3600},
	[30] = {id = 30, master_affix_level = 4, slave_affix_level = 3, result_affix_level = 4, weight = 10000},
	[31] = {id = 31, master_affix_level = 4, slave_affix_level = 3, result_affix_level = 5, weight = 6000},
	[32] = {id = 32, master_affix_level = 4, slave_affix_level = 4, result_affix_level = 5, weight = 10000},
	[33] = {id = 33, master_affix_level = 4, slave_affix_level = 5, result_affix_level = 5, weight = 10000},
	[34] = {id = 34, master_affix_level = 5, slave_affix_level = 1, result_affix_level = 5, weight = 10000},
	[35] = {id = 35, master_affix_level = 5, slave_affix_level = 2, result_affix_level = 5, weight = 10000},
	[36] = {id = 36, master_affix_level = 5, slave_affix_level = 3, result_affix_level = 5, weight = 10000},
	[37] = {id = 37, master_affix_level = 5, slave_affix_level = 4, result_affix_level = 5, weight = 10000},
	[38] = {id = 38, master_affix_level = 5, slave_affix_level = 5, result_affix_level = 5, weight = 10000},
}
	
local DataAssetPartnerFusion = Config.DataAssetPartnerFusion
DataAssetPartnerFusion.GetRateListLength = 25
DataAssetPartnerFusion.GetRateList = {
	["1_1"] = {{2, 10000}},
	["1_2"] = {{2, 10000}, {3, 6000}},
	["1_3"] = {{3, 10000}, {4, 3600}},
	["1_4"] = {{4, 10000}, {5, 2160}},
	["1_5"] = {{5, 10000}},
	["2_1"] = {{2, 10000}, {3, 6000}},
	["2_2"] = {{3, 10000}},
	["2_3"] = {{3, 10000}, {4, 6000}},
	["2_4"] = {{4, 10000}, {5, 3600}},
	["2_5"] = {{5, 10000}},
	["3_1"] = {{3, 10000}, {4, 3600}},
	["3_2"] = {{3, 10000}, {4, 6000}},
	["3_3"] = {{4, 10000}},
	["3_4"] = {{4, 10000}, {5, 6000}},
	["3_5"] = {{5, 10000}},
	["4_1"] = {{4, 10000}, {5, 2160}},
	["4_2"] = {{4, 10000}, {5, 3600}},
	["4_3"] = {{4, 10000}, {5, 6000}},
	["4_4"] = {{5, 10000}},
	["4_5"] = {{5, 10000}},
	["5_1"] = {{5, 10000}},
	["5_2"] = {{5, 10000}},
	["5_3"] = {{5, 10000}},
	["5_4"] = {{5, 10000}},
	["5_5"] = {{5, 10000}},
}
	

return DataAssetPartnerFusion
