-- Automatically generated - do not edit.

Config = Config or {}
Config.DataAlchemyElementCoexist = Config.DataAlchemyElementCoexist or {}


local DataAlchemyElementCoexist = Config.DataAlchemyElementCoexist
DataAlchemyElementCoexist.FindLength = 5
DataAlchemyElementCoexist.Find = {
	[1] = {type = 1, name = "金", coexist = 3, remark = "金生水"},
	[2] = {type = 2, name = "木", coexist = 4, remark = "木生火"},
	[3] = {type = 3, name = "水", coexist = 2, remark = "水生木"},
	[4] = {type = 4, name = "火", coexist = 5, remark = "火生土"},
	[5] = {type = 5, name = "土", coexist = 1, remark = "土生金"},
}
	

return DataAlchemyElementCoexist
