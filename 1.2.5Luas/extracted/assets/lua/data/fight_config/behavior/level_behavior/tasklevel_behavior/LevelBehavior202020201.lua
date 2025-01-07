LevelBehavior202020201 = BaseClass("LevelBehavior202020201")

--集合关卡
function LevelBehavior202020201.GetGenerates()
	local generates = {2040104,203040201,203040202}
	return generates
end

function LevelBehavior202020201:__init(fight)
	self.fight = fight
end


function LevelBehavior202020201:Init()
	self.missionState=0
	self.ClickKey = true
	self.selectedNumbers = {}
	self.roleFrame = nil
	self.tipsKey=false
	self.gameStart=false
	self.initialTime=60
	self.ballTotalNum=9
	self.score = 0
	self.red = 0
	self.yellow = 0

	self.ballList={
		[1]={instanceId=nil,positionName="Position1"},
		[2]={instanceId=nil,positionName="Position2"},
		[3]={instanceId=nil,positionName="Position3"},
		[4]={instanceId=nil,positionName="Position4"},
		[5]={instanceId=nil,positionName="Position5"},
		[6]={instanceId=nil,positionName="Position6"},
		[7]={instanceId=nil,positionName="Position7"},
		[8]={instanceId=nil,positionName="Position8"},
		[9]={instanceId=nil,positionName="Position9"},
	}
	
	self.airWall={
		[1]={instanceId=nil,positionName="Cube1"},
		[2]={instanceId=nil,positionName="Cube2"},
		[3]={instanceId=nil,positionName="Cube3"},
		[4]={instanceId=nil,positionName="Cube4"},
		
		
		
		}
	
	
	self.gameResult=nil
	self.enter = nil
	self.taskId=302020101
	self.levelId=202020201
	self.ballCalculate=0
end


function LevelBehavior202020201:Update()
	self.frame = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	local Vector1=BehaviorFunctions.GetPositionP(self.role)
	local Vector2= BehaviorFunctions.GetTerrainPositionP("Position_Role",10020001,"Logic202020101")
	self.quitDistance=BehaviorFunctions.GetDistanceFromPos(Vector1,Vector2)
	
	
	
	if self.npcInform==nil then
		self.npcInform=BehaviorFunctions.GetNpcEntity(8010228)
	end
	if self.npcInform 
		and self.npc==nil then
		self.npc=self.npcInform.instanceId
	end
	
	--创建特效
	if  self.missionState == 0 then
		if self.npc then
			local pos = BehaviorFunctions.GetTerrainPositionP("Position_Role",10020001,"Logic202020101")
			self.shootLevel=BehaviorFunctions.CreateEntity(200000108,nil,pos.x,pos.y,pos.z)
			self.time=self.initialTime
			self.ballNum=self.ballTotalNum
			self.ballCalculate=0
			

			self.missionState = 1
		end
	end
	
	
	--站到触发区域
	if self.missionState==1 then

		
		
		
		self.entityId = BehaviorFunctions.GetEntityTemplateId(self.role)
		if self.clickStart==true then
			self.clickStart=false
			if self.entityId==1002 then
				BehaviorFunctions.StopMove(self.role)
				BehaviorFunctions.DoSetEntityState(self.role,FightEnum.EntityState.Idle)
				for i=1,4 do
					local pos = BehaviorFunctions.GetTerrainPositionP(self.airWall[i].positionName,10020001,"Logic202020101")
					self.airWall[i].instanceId=BehaviorFunctions.CreateEntity(2040104,nil,pos.x,pos.y,pos.z)
				end
				
				
				
				
				
				BehaviorFunctions.ShowCommonTitle(4,"击破红色气球，小心黄色气球",true)
				self.tips1=BehaviorFunctions.GetEntityFrame(self.role)
				--设置位置
				local pos = BehaviorFunctions.GetTerrainPositionP("Position_Role",10020001,"Logic202020101")
				BehaviorFunctions.DoSetPosition(self.role,pos.x,pos.y,pos.z)
				--设置朝向
				local rotation = BehaviorFunctions.GetTerrainRotationP("Position_Role",10020001,"Logic202020101")
				BehaviorFunctions.SetEntityEuler(self.role,rotation.x,rotation.y,rotation.z)
				
				local posBall = BehaviorFunctions.GetTerrainPositionP(self.ballList[6].positionName,10020001,"Logic202020101")
				self.empty = BehaviorFunctions.CreateEntity(2001,nil,posBall.x,posBall.y,posBall.z)
				self.levelCam=BehaviorFunctions.CreateEntity(22001,nil,nil,nil,nil,nil,nil,nil,202020201)
				BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
				BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
				
				BehaviorFunctions.SetFightPanelVisible("111110111")
				BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",false)
				BehaviorFunctions.SetFightMainNodeVisible(2,"O",false)
				BehaviorFunctions.SetFightMainNodeVisible(2,"K",false)
				BehaviorFunctions.SetFightMainNodeVisible(2,"I",false)
				BehaviorFunctions.SetFightMainNodeVisible(2,"R",false)
				BehaviorFunctions.AddEntitySign(1,10000032,-1)
				BehaviorFunctions.RemoveEntity(self.shootLevel)
				self.missionState=2
				
			else
				BehaviorFunctions.ShowTip(10010015)
			end
			self.clickStart=false
			
		end
		--添加交互
		if not self.tips1 then
			local pos = BehaviorFunctions.GetDistanceFromTarget(self.role,self.shootLevel)
			if pos <= 3 then
				self.enter = true
			else
				self.enter = false
			end
			--交互列表
			if self.enter then
				if self.isTrigger then
					return
				end
				self.isTrigger = self.shootLevel
				if not self.isTrigger then
					return
				end
				self.interactUniqueId = BehaviorFunctions.WorldInteractActive(WorldEnum.InteractType.Check,nil,"开始射击",1)
			else
				if self.isTrigger  then
					self.isTrigger = false
					BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
				end
			end			
		end
		
		
		
	end
	

	--显示倒计时
	if self.missionState ==2 then
		self.noteTime=BehaviorFunctions.GetEntityFrame(self.role)
		--游戏开启提示
		if self.tips1
			and self.noteTime-self.tips1>150 then
			BehaviorFunctions.ShowTip(10010010)
			self.tips2=BehaviorFunctions.GetEntityFrame(self.role)
			self.tips1=nil
		end

		if self.tips2
			and self.noteTime-self.tips2>30 then
			BehaviorFunctions.ShowTip(10010011)
			self.tips3=BehaviorFunctions.GetEntityFrame(self.role)
			self.tips2=nil
		end

		if self.tips3
			and self.noteTime-self.tips3>30 then
			BehaviorFunctions.ShowTip(10010012)
			self.tips3=nil
			self.tips4=BehaviorFunctions.GetEntityFrame(self.role)
		end

		if self.tips4
			and self.noteTime-self.tips4>30 then
			BehaviorFunctions.ShowTip(10010013)
			self.tips4=nil
			self.gameStart=true
			
			if BehaviorFunctions.CheckEntity(self.levelCam) then
				BehaviorFunctions.RemoveEntity(self.levelCam)
				BehaviorFunctions.RemoveEntity(self.empty)
			end
			
			
		end


		--创建气球
		if self.gameStart==true then
			local numbers = {1,2,3,4,5,6,7,8,9}
			self.gameStart=false
			-- 使用循环从数组中随机抽取 5 个数字，并将它们添加到 selectedNumbers 数组中
			for i = 1, self.ballNum do
				-- 生成一个随机索引值，范围在 1 到当前数组长度之间
				local randomIndex = math.random(1, #numbers)

				-- 从数组中取出这个随机索引对应的数字，并将它添加到 selectedNumbers 数组中
				table.insert(self.selectedNumbers,numbers[randomIndex])

				-- 从原始数组中删除已选定的数字，以避免重复选择
				table.remove(numbers,randomIndex)
			end

			for k,v in ipairs(self.selectedNumbers) do
				for m = 1, self.ballNum do
					if v==m then
						local pos = BehaviorFunctions.GetTerrainPositionP(self.ballList[m].positionName,10020001,"Logic202020101")
						if BehaviorFunctions.Probability(7000) then
							self.ballList[m].instanceId=BehaviorFunctions.CreateEntity(203040201,nil,pos.x,pos.y,pos.z)
							self.red = self.red + 1
							else
							self.ballList[m].instanceId=BehaviorFunctions.CreateEntity(203040202,nil,pos.x,pos.y,pos.z)
							self.yellow = self.yellow + 1 
						end
						
					end

				end


			end
			self.gameTime=BehaviorFunctions.GetEntityFrame(self.role)
			BehaviorFunctions.ShowTip(10010021,self.score)
			BehaviorFunctions.ShowTip(10010014,self.ballCalculate,self.red)
			--BehaviorFunctions.ChangeTitleTipsDesc(10010014,self.ballCalculate)
			BehaviorFunctions.ShowTip(30000000,self.time)
			
			BehaviorFunctions.PlayGuide(2048,1)
			
			
			
		end


		--游戏开始
		if self.gameTime then
			self.selectedNumbers={}
			if self.time>0
				and BehaviorFunctions.GetEntityFrame(self.role)-self.gameTime==30 
				and not self.gameResult then

				self.time=self.time-1
				self.gameTime=BehaviorFunctions.GetEntityFrame(self.role)
				BehaviorFunctions.ShowTip(30000000,self.time)
			end
			
			--用于判断各种情况
			if not self.gameResult then
				--时间到
				if self.time==0 then
					BehaviorFunctions.ShowTip(10010019)
					BehaviorFunctions.ShowCommonTitle(5,"击破全部气球",false)
					self:Delay("ResetGame",4)
					self.gameResult=false
				--离开射击区域
				elseif self.quitDistance>2 then
					BehaviorFunctions.ShowTip(10010020)
					self:Delay("ResetGame",4)
					BehaviorFunctions.ShowCommonTitle(5,"击破全部气球",false)
					self.gameResult=false
				--气球全部击破
				elseif self.ballCalculate==9 or self.ballCalculate >= self.red then
					self.ballCalculate=0
					BehaviorFunctions.ShowCommonTitle(5,"击破全部气球",true)
					--BehaviorFunctions.SendTaskProgress(self.taskId,1,1)

					self.score = self.score + self.yellow
					
					
					BehaviorFunctions.ShowTip(10010021,self.score)
					
					for m = 1, self.ballTotalNum do
						if self.ballList[m].instanceId
							and BehaviorFunctions.CheckEntity(self.ballList[m].instanceId) then
							BehaviorFunctions.RemoveEntity(self.ballList[m].instanceId)
							self.ballList[m].instanceId=nil
						end
					end
					
					--BehaviorFunctions.ShowCommonTitle(5,self.score,true)
					
					self.gameResult=false
				end
			end
			
			--失败将所有气球移除
			if self.gameResult==false then
				for m = 1, self.ballTotalNum do
					if self.ballList[m].instanceId
						and BehaviorFunctions.CheckEntity(self.ballList[m].instanceId) then
						BehaviorFunctions.RemoveEntity(self.ballList[m].instanceId)
						self.ballList[m].instanceId=nil
					end
				end
				
			end
			
			
			

	
			--当游戏有了结果，把按钮打开，把npc
			if self.gameResult~=nil then
				for i=1,4 do
					if BehaviorFunctions.CheckEntity(self.airWall[i].instanceId) then
						BehaviorFunctions.RemoveEntity(self.airWall[i].instanceId)
					end
				end
				BehaviorFunctions.FinishGuide(2048,1)
				BehaviorFunctions.HideTip(10010014)
				--BehaviorFunctions.HideTip(10010021)
				BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",true)
				BehaviorFunctions.SetFightMainNodeVisible(2,"O",true)
				BehaviorFunctions.SetFightMainNodeVisible(2,"K",true)
				BehaviorFunctions.SetFightMainNodeVisible(2,"I",true)
				BehaviorFunctions.SetFightMainNodeVisible(2,"R",true)
				BehaviorFunctions.RemoveEntitySign(1,10000032,-1)
				self.gameTime=nil
				self.gameResult=nil
				self.missionState=3
				BehaviorFunctions.SetFightPanelVisible("-1")
				
				
				BehaviorFunctions.RemoveLevel(self.levelId)
				
			end
		end
	end
	
	
	
	
	
end



function LevelBehavior202020201:__delete()

end




--function LevelBehavior202020201:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	--if attackInstanceId==self.role then
		--LogError(hitInstanceId)
	--end
--end


function LevelBehavior202020201:Die(attackInstanceId,dieInstanceId)
	for k,v in pairs(self.ballList) do
		if v.instanceId==dieInstanceId then
			
			
			
			if BehaviorFunctions.GetEntityTemplateId(v.instanceId) == 203040201 then
				self.ballCalculate=self.ballCalculate+1
				self.score=self.score+1
				BehaviorFunctions.ChangeTitleTipsDesc(10010021,self.score)
			elseif BehaviorFunctions.GetEntityTemplateId(v.instanceId) == 203040202 then
				self.score=self.score-1
				self.yellow = self.yellow - 1
				BehaviorFunctions.ChangeTitleTipsDesc(10010021,self.score)
				BehaviorFunctions.ShowTip(10010022)
			end
			
			BehaviorFunctions.ChangeTitleTipsDesc(10010014,self.ballCalculate,self.red)
		end
	end
end





function LevelBehavior202020201:Delay(kind,time)
	if kind=="ResetGame" then
		BehaviorFunctions.AddDelayCallByTime(time,self,self.ResetGame)
	end
	if kind=="BlackOpen" then
		BehaviorFunctions.AddDelayCallByTime(time,self,self.BlackOpen)
	end
end
	
	
	
function LevelBehavior202020201:ResetGame()
	self.selectedNumbers={}
	BehaviorFunctions.ShowBlackCurtain(false,0.5)
	self.missionState = 0
end

function LevelBehavior202020201:BlackOpen()
	BehaviorFunctions.ShowBlackCurtain(true,0.5)
	self:Delay("ResetGame",1)
end



--点击交互:播放退出关卡
function LevelBehavior202020201:WorldInteractClick(uniqueId)
	self.isTrigger = false


	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		self.tipsKey=true
		self.clickStart=true
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
	end
end
