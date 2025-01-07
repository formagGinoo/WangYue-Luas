LevelBehavior99999998 = BaseClass("LevelBehavior99999998",LevelBehaviorBase)
--过河给个船
function LevelBehavior99999998.GetGenerates()
	local generates = {}
	return generates
end


function LevelBehavior99999998:Init()
	self.missionState = 0
	self.teachPos = Vec3.New(2191,102,964)
	self.bluePrint = {
		blueprint_id = 1716794490,
		build_id = 0,
		child_list = {

		},
		image_path = "",
		name = "自定义蓝图1",
		nodes = {
			{
				build_id = 1002,
				child_list = {

				},
				connect_node = "",
				connect_point = {
					{
						child_bone_name = "ConnectPoint_1",
						parent_bone_name = "ConnectPoint_3 (1)",
						point_type = "1"
					}
				},
				index = 1,
				node_name = "",
				offset = {
					pos_x = 21634,
					pos_y = 5023,
					pos_z = 15178
				},
				parent_index = {
					3
				},
				parent_transform_name = {

				},
				rotate = {
					pos_x = 13151,
					pos_y = 1800276,
					pos_z = 1799460
				}
			},
			{
				build_id = 1002,
				child_list = {

				},
				connect_node = "",
				connect_point = {
					{
						child_bone_name = "ConnectPoint_1",
						parent_bone_name = "ConnectPoint_4 (1)",
						point_type = "1"
					}
				},
				index = 2,
				node_name = "",
				offset = {
					pos_x = -21646,
					pos_y = -2197,
					pos_z = 15497
				},
				parent_index = {
					3
				},
				parent_transform_name = {

				},
				rotate = {
					pos_x = 17992,
					pos_y = 1800339,
					pos_z = 445
				}
			},
			{
				build_id = 1001,
				child_list = {

				},
				connect_node = "",
				connect_point = {

				},
				index = 3,
				node_name = "",
				offset = {
					pos_x = 0,
					pos_y = 0,
					pos_z = 0
				},
				parent_index = {

				},
				parent_transform_name = {

				},
				rotate = {
					pos_x = 0,
					pos_y = 0,
					pos_z = 0
				}
			},
			{
				build_id = 1003,
				child_list = {

				},
				connect_node = "",
				connect_point = {
					{
						child_bone_name = "ConnectPoint_14",
						parent_bone_name = "ConnectPoint_1",
						point_type = "1"
					}
				},
				index = 4,
				node_name = "",
				offset = {
					pos_x = -52,
					pos_y = 2723,
					pos_z = -9
				},
				parent_index = {
					3
				},
				parent_transform_name = {

				},
				rotate = {
					pos_x = -11,
					pos_y = 1814645,
					pos_z = 6
				}
			}
		}
	}
end

function LevelBehavior99999998:Update()
	self.time = BehaviorFunctions.GetFightFrame()/30
	self.frame = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.missionState == 0 then
		Fight.Instance.clientFight.buildManager.buildController:TempCreateBlueprint(self.bluePrint,{x = 2191,y = 103,z = 964}, {x =0,y = -12,z = 0})
		self.teachEntity = BehaviorFunctions.CreateEntity(2001,nil,self.teachPos.x,self.teachPos.y,self.teachPos.z)
		self.missionState = 1
	elseif self.missionState == 1 then
		local distance = BehaviorFunctions.GetDistanceFromTarget(self.teachEntity,self.role)
		if distance < 5 then
			BehaviorFunctions.ShowGuideImageTips(20038)
			self.missionState = 999
		end
	end
end

function LevelBehavior99999998:RemoveLevel(levelId)

end