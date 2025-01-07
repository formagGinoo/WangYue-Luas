-- Automatically generated - do not edit.

Config = Config or {}
Config.DataTradeOrder = Config.DataTradeOrder or {}


local DataTradeOrder = Config.DataTradeOrder
DataTradeOrder.FindLength = 8

DataTradeOrder.FindbyStoreId = {
	[101] = { [10101] = 10101, [10102] = 10102, [10103] = 10103, [10104] = 10104, [10105] = 10105,},
	[102] = { [10201] = 10201, [10202] = 10202,},
	[103] = { [10301] = 10301,},
}

DataTradeOrder.Find = {
	[10101] = { desc1 = "我想要苹果蘑菇汤。", desc2 = "如果是阴阳平衡的就更好了。", expect_item = {{11012,},{11013,},{11011,1000,},}, id = 10101, need_item_count = 1, negotiate_id = 10101, page = 1, reward_item_count = 2000, reward_item_id = 2, store_id = 101,},
	[10102] = { desc1 = "我想要两份苹果蘑菇汤。", desc2 = "只要不是阴的就可以。", expect_item = {{11013,},{11012,500,},{11011,1000,},}, id = 10102, need_item_count = 2, negotiate_id = 10102, page = 1, reward_item_count = 5000, reward_item_id = 2, store_id = 101,},
	[10103] = { desc1 = "我想要鲜香三宝汤。", desc2 = "如果是阴阳平衡的就更好了。", expect_item = {{11022,},{11023,},{11021,2,},}, id = 10103, need_item_count = 1, negotiate_id = 10102, page = 1, reward_item_count = 10, reward_item_id = 3, store_id = 101,},
	[10104] = { desc1 = "浑浊，稀少，分不清内部思绪的残念，就如微弱的火堆一般，随时消逝。", expect_item = {{20101,2000,},}, id = 10104, need_item_count = 1, negotiate_id = 10103, page = 2, reward_item_count = 10000, reward_item_id = 2, store_id = 101,},
	[10105] = { desc1 = "想收购一些水果。", desc2 = "性寒凉的水果更佳", expect_item = {{10331,500,},{10342,600,},{10345,700,},{10340,},}, id = 10105, need_item_count = 3, negotiate_id = 10103, page = 1, reward_item_count = 5000, reward_item_id = 2, store_id = 101,},
	[10201] = { desc1 = "我想要仙岛三味。", desc2 = "如果是阴阳平衡的就更好了。", expect_item = {{11031,500,},{11032,},{11033,},}, id = 10201, need_item_count = 1, negotiate_id = 10201, page = 1, reward_item_count = 5000, reward_item_id = 2, store_id = 102,},
	[10202] = { desc1 = "我想要灵芝鲜果炖。", desc2 = "如果是阴阳平衡的就更好了。", expect_item = {{11041,1000,},{11042,},{11043,},}, id = 10202, need_item_count = 1, negotiate_id = 10201, page = 1, reward_item_count = 10000, reward_item_id = 2, store_id = 102,},
	[10301] = { desc1 = "我想要一个任务物品升燃的残念", desc2 = "就在你身上", expect_item = {{20102,10,},}, id = 10301, need_item_count = 1, negotiate_id = 10301, page = 2, reward_item_count = 50, reward_item_id = 3, store_id = 103,},
}


return DataTradeOrder
