-- Automatically generated - do not edit.

Config = Config or {}
Config.DataDropIdSegment = Config.DataDropIdSegment or {}


local DataDropIdSegment = Config.DataDropIdSegment
DataDropIdSegment.FindLength = 4
DataDropIdSegment.Find = {
	[-1] = {layer = -1, min_id = 1, max_id = 99999},
	[1] = {layer = 1, min_id = 100000, max_id = 199999},
	[0] = {layer = 0, min_id = 200000, max_id = 9999999},
	[2] = {layer = 2, min_id = 10000000, max_id = 99999999},
}
	

return DataDropIdSegment
