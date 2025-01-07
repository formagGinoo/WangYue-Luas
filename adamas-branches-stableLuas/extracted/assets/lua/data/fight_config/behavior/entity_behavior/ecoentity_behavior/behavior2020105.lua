Behavior2020105 = BaseClass("Behavior2020105",EntityBehaviorBase)
--大悬钟
function Behavior2020105.GetGenerates()

end

function Behavior2020105:Init()
	self.me = self.instanceId
	self.localactive = false
	self.map = nil

	self.UnlockedEffect = nil
	
	----任务保底
	self.canActive = true
end


function Behavior2020105:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	--获取地图
	if not self.map then
		self.map = Fight.Instance:GetFightMap(self.role)
	end
	
	self.EcoId = BehaviorFunctions.GetEntityEcoId(self.me)           --生态id
	self.isActive = BehaviorFunctions.CheckEntityEcoState(self.me)   --生态状态
	
	----修改交互为飞天
	--if (not self.feitian) and self.isActive == true and BehaviorFunctions.CheckTaskId(105010501) then
		--BehaviorFunctions.ChangeWorldInteractInfo(self.me,"Textures/UI/Story/icon_dialog_talk.png", "传送")
		----打开交互组件
		--BehaviorFunctions.SetEntityWorldInteractState(self.me, true)
		--self.feitian = true
	--end	
	
	----修改交互为飞天
	--if (not self.feitian) and self.isActive == true then
		--if self.map ==10020001 and BehaviorFunctions.CheckTaskId(105010501) then
			--BehaviorFunctions.ChangeWorldInteractInfo(self.me,"Textures/Icon/Single/FuncIcon/Trigger_Transform.png", "传送")
			----打开交互组件
			--BehaviorFunctions.SetEntityWorldInteractState(self.me, true)
			--self.feitian = true
		--elseif self.map == 10020005 then
			--BehaviorFunctions.ChangeWorldInteractInfo(self.me,"Textures/Icon/Single/FuncIcon/Trigger_Transform.png", "传送")
			----打开交互组件
			--BehaviorFunctions.SetEntityWorldInteractState(self.me, true)
			--self.feitian = true
		--end
	--end
end


--交互
function Behavior2020105:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	
	if instanceId ==self.me then
		----地面敲钟
		--if self.map == 10020001 then
			if self.isActive == false then
				--敲钟解锁地图
				BehaviorFunctions.InteractEntityHit(self.me)
				--关闭交互组件
				BehaviorFunctions.SetEntityWorldInteractState(self.me, false)
				--设置状态	
				self.localactive = true
				self.isActive = true	
				----修改交互为飞天
				--BehaviorFunctions.ChangeWorldInteractInfo(self.me,"Textures/Icon/Single/FuncIcon/Trigger_Transform.png","传送")
				

			elseif self.isActive == true then 
				--BehaviorFunctions.AddBuff(1,self.role,900000010)--隐身buff
				----判断在哪张地图
				--local Map = Fight.Instance:GetFightMap(self.role)
				--if Map == 10020001 then
					----地面飞天柜城
					--BehaviorFunctions.WorldTimeLineSwitch(10020005)
				--elseif Map == 10020005 then
					----天柜城飞地面
					--BehaviorFunctions.WorldTimeLineSwitch(10020001)
				--end
			--end
		end
		----天柜城敲钟
		--if self.map == 10020004 then
			--BehaviorFunctions.AddBuff(1,self.role,900000010)--隐身buff

			----同步角色位置
			----	local rolePos = {x=0,y=0,z=0}
			----rolePos.x,rolePos.y,rolePos.z = BehaviorFunctions.GetEntityTransformPos(self.me,"rolePos")  --“rolePos”点挂在prefab上
			----BehaviorFunctions.DoSetPosition(self.role,rolePos.x,rolePos.y,rolePos.z)
			----BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.me)


			------设置timeline位置
			----local timelineLookPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,5,0)  --实体偏移坐标
			----local timelinePos = BehaviorFunctions.GetPositionP(self.me) --
			------BehaviorFunctions.StartStoryDialog(601010301,{},nil,nil,timelinePos,timelineLookPos)
			--local timeline1Pos = BehaviorFunctions.GetPositionP(self.me)
			--self.pos2 = {x=298.6,y=118.5,z=1757}
			--self.pos3 = {x=296.5,y=118.5,z=1761.5}
			----天柜城飞地面
			--BehaviorFunctions.WorldTimeLineSwitch(10020001)
		--end
	end
end

--Timeline结束后移除人物隐藏
function Behavior2020105:StoryEndEvent(dialogId)
	if dialogId == 601010401 then
		BehaviorFunctions.RemoveBuff(self.role,900000010)
	end
end

