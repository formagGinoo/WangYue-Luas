-- Automatically generated - do not edit.

Config = Config or {} 
Config.DataTaskNode = Config.DataTaskNode or {}


local DataTaskNode = Config.DataTaskNode
DataTaskNode.data_task_node_length = 27
DataTaskNode.data_task_node = {
	[19801] = {id = 19801, pre_node = {}, accept_lev = 1, condition = {}, tasks = {1980101}},
	[30102] = {id = 30102, pre_node = {}, accept_lev = 1, condition = {}, tasks = {3010201}},
	[30103] = {id = 30103, pre_node = {30102}, accept_lev = 1, condition = {{"finish_task", {3010201}}}, tasks = {3010301}},
	[30104] = {id = 30104, pre_node = {30103}, accept_lev = 1, condition = {{"finish_task", {3010301}}}, tasks = {3010401}},
	[30105] = {id = 30105, pre_node = {}, accept_lev = 1, condition = {}, tasks = {3010501}},
	[30106] = {id = 30106, pre_node = {30105}, accept_lev = 1, condition = {{"finish_task", {3010501}}}, tasks = {3010601}},
	[30107] = {id = 30107, pre_node = {30106}, accept_lev = 1, condition = {{"finish_task", {3010601}}}, tasks = {3010701}},
	[30108] = {id = 30108, pre_node = {}, accept_lev = 1, condition = {}, tasks = {3010801}},
	[30109] = {id = 30109, pre_node = {30108}, accept_lev = 1, condition = {{"finish_task", {3010801}}}, tasks = {3010901}},
	[30110] = {id = 30110, pre_node = {30109}, accept_lev = 1, condition = {{"finish_task", {3010901}}}, tasks = {3011001}},
	[30111] = {id = 30111, pre_node = {}, accept_lev = 1, condition = {}, tasks = {3011101}},
	[30112] = {id = 30112, pre_node = {30111}, accept_lev = 1, condition = {{"finish_task", {3011101}}}, tasks = {3011201}},
	[30113] = {id = 30113, pre_node = {30112}, accept_lev = 1, condition = {{"finish_task", {3011201}}}, tasks = {3011301}},
	[30114] = {id = 30114, pre_node = {}, accept_lev = 1, condition = {}, tasks = {3011401}},
	[30115] = {id = 30115, pre_node = {30114}, accept_lev = 1, condition = {{"finish_task", {3011401}}}, tasks = {3011501}},
	[30116] = {id = 30116, pre_node = {30115}, accept_lev = 1, condition = {{"finish_task", {3011501}}}, tasks = {3011601}},
	[30117] = {id = 30117, pre_node = {}, accept_lev = 1, condition = {}, tasks = {3011701}},
	[30197] = {id = 30197, pre_node = {30117}, accept_lev = 1, condition = {{"finish_task", {3011701}}}, tasks = {3011702}},
	[30118] = {id = 30118, pre_node = {30197}, accept_lev = 1, condition = {{"finish_task", {3011702}}}, tasks = {3011801}},
	[30119] = {id = 30119, pre_node = {30118}, accept_lev = 1, condition = {{"finish_task", {3011801}}}, tasks = {3011901}},
	[30120] = {id = 30120, pre_node = {}, accept_lev = 1, condition = {}, tasks = {3012001}},
	[30121] = {id = 30121, pre_node = {30120}, accept_lev = 1, condition = {{"finish_task", {3012001}}}, tasks = {3012101}},
	[30122] = {id = 30122, pre_node = {30121}, accept_lev = 1, condition = {{"finish_task", {3012101}}}, tasks = {3012201}},
	[30123] = {id = 30123, pre_node = {}, accept_lev = 1, condition = {}, tasks = {3012301}},
	[30124] = {id = 30124, pre_node = {30123}, accept_lev = 1, condition = {{"finish_task", {3012301}}}, tasks = {3012401}},
	[30125] = {id = 30125, pre_node = {30124}, accept_lev = 1, condition = {{"finish_task", {3012401}}}, tasks = {3012501}},
	[30126] = {id = 30126, pre_node = {}, accept_lev = 1, condition = {}, tasks = {3012601}},
}
	

DataTaskNode.FindTasksInfo = {
	[1980101] = { id = 19801,},
	[3010201] = { id = 30102,},
	[3010301] = { id = 30103,},
	[3010401] = { id = 30104,},
	[3010501] = { id = 30105,},
	[3010601] = { id = 30106,},
	[3010701] = { id = 30107,},
	[3010801] = { id = 30108,},
	[3010901] = { id = 30109,},
	[3011001] = { id = 30110,},
	[3011101] = { id = 30111,},
	[3011201] = { id = 30112,},
	[3011301] = { id = 30113,},
	[3011401] = { id = 30114,},
	[3011501] = { id = 30115,},
	[3011601] = { id = 30116,},
	[3011701] = { id = 30117,},
	[3011702] = { id = 30197,},
	[3011801] = { id = 30118,},
	[3011901] = { id = 30119,},
	[3012001] = { id = 30120,},
	[3012101] = { id = 30121,},
	[3012201] = { id = 30122,},
	[3012301] = { id = 30123,},
	[3012401] = { id = 30124,},
	[3012501] = { id = 30125,},
	[3012601] = { id = 30126,},
}

