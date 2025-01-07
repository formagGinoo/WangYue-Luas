Behavior2030532 = BaseClass("Behavior2030532",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType

function Behavior2030532.GetGenerates()
	local generates = {}
	return generates
end

function Behavior2030532:Init()
	self.me= self.instanceId
	self.ecoId = nil --生态id
	self.groupEcoMember = nil --生态组内成员,生态id
	self.groupMember = {} --生态组内成员，实例id
	self.groupKeyList = {} --生态组内的密钥列表
	self.groupKeyLineList = {} --密钥连接线的数组

	self.keyEntity = 2030533 --密钥实体
	self.goal = 0 --所需要的密钥数量
	self.keyNum = 0 --现在拥有的密钥数量
	self.fxkeyLockLine = nil --未解锁时的密钥连线
	self.fxkeyLockLineList = {} --未解锁时的密钥连线组
	self.fxkeyUnlockLine = nil --解锁时的密钥连线特效
	self.fxkeyUnlockLineList = {} --解锁时的密钥连线特效组
	self.keyPos = 0 --密钥位置
	self.keyPosList = {} --密钥生成位置

	self.state = 0 --玩法状态
	self.stateEnum = {Default = 0, Start = 1 ,Starting = 2,Searching = 3, Success = 4 , End = 5 , Stop = 6} --玩法状态枚举
	
	self.groupKeyAllList = 
	{
		[1] = {hack = false,keyId = nil,lineId = nil,guideId = nil,fxguideId = nil},
		[2] = {hack = false,keyId = nil,lineId = nil,guideId = nil,fxguideId = nil},
		[3] = {hack = false,keyId = nil,lineId = nil,guideId = nil,fxguideId = nil},
		[4] = {hack = false,keyId = nil,lineId = nil,guideId = nil,fxguideId = nil},
		[5] = {hack = false,keyId = nil,lineId = nil,guideId = nil,fxguideId = nil},
		}
	 
	self.guideHack = nil --骇入物的指引
	
	self.groupMonitorList = {} --摄像头列表
	self.monitor = 2030504 --摄像头实体的id
	self.fxgroupMonitorList = {} --摄像头的特效组
	
	--玩法的距离相关属性
	self.dis = 0 --角色与骇入物的距离
	self.disLimit = 5 --在特殊状态下，不能超出的距离
	self.disOn = false
	self.disOn1 = false
	
	self.disMax = 50 --最大距离
	
	self.ctrlRole = 0

	
	self.paramMe = {} --自己的额外参数
	self.param = {} --密钥的额外参数
	
	self.fxcircle = nil
	self.guide = false --当前是否开启了引导
	self.guideStateEnum = {default = 0, hackGuide = 1, keyGuide = 2,rewardGuide = 3,endGuide = 4}
	self.guideState = self.guideStateEnum.default
	self.guideDis = 15 --引导图标出现的距离
	
	self.fxguideStateEnum = {default = 0, hackGuide = 1,keyGuide = 2,rewardGuide = 3,endGuide = 4} --闪烁特效状态枚举
	self.fxguideState = self.fxguideStateEnum.default --闪烁特效状态
	
	self.reward = 2001
	self.rewardId = nil 
	self.rewardecoId = nil
end


function Behavior2030532:LateInit()

	self.ecoId = BehaviorFunctions.GetEntityEcoId(self.me) --获取生态id
	self.state = self.stateEnum.Default --状态设置成默认
	self.ctrlRole = BehaviorFunctions.GetCtrlEntity() --获取操控角色
	
	self.ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoId) --获得生态状态
	
	self.roleState = BehaviorFunctions.GetEntityState(self.ctrlRole) --获得角色状态
	self.mepos = BehaviorFunctions.GetPositionP(self.me)
end


function Behavior2030532:Update()
	self.ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoId) --获得生态状态
	--如果当前状态是未完成的状态
	if self.ecoState == 0 then	
		--玩法在默认状态下------------------------------------------------------------------------------------------------------------------------------------------------
		if self.state == self.stateEnum.Default then
			--获取生态组成员生态id
			if self.ecoId then
				self.groupEcoMember = BehaviorFunctions.GetEcoEntityGroupMember(nil,nil,self.ecoId)
				--self.groupEcoMember =  BehaviorFunctions.GetEcoEntityGroup(nil,self.ecoId,nil)
			end
			
			if self.groupEcoMember then
				--把生态id转化为实体id
				if next(self.groupEcoMember) ~= nil then
					for i ,v in pairs(self.groupEcoMember) do
						local id = BehaviorFunctions.GetEcoEntityByEcoId(v) --获得实体id
						if id then
							self.entId = BehaviorFunctions.GetEntityTemplateId(id) --根据实例id获得实体配置id
						end
						
						self.param = BehaviorFunctions.GetEcoEntityExtraParam(v)

						--判断此物体是否是骇入物
						if id == self.me then
							--把骇入物插入到总数组里
							table.insert(self.groupMember,id)
							self.paramMe = BehaviorFunctions.GetEcoEntityExtraParam(v)
							self.ecoState = BehaviorFunctions.GetEcoEntityState(v) --获得生态状态
							BehaviorFunctions.SetEntityHackEffectIsTask(self.me, true) --把自己设置成任务目标，显示金色特效

						--此物体是密钥或其他
						else
							if next(self.param) then
								if self.param[1].isKey == 'TRUE' then
									local posKey = BehaviorFunctions.GetEcoEntityBornPosition(v)
									self.key = BehaviorFunctions.CreateEntityByEntity(self.me,self.keyEntity,posKey.x,posKey.y,posKey.z,nil,nil,nil)
									BehaviorFunctions.SetEntityHackButtonInformation(self.key,HackingConfig.HackingKey.Up,"获得密钥","hack_hackkey",40,"骇入获得密钥，解锁访问权限")
									--把密钥持有者插入到总数组和密钥数组里
									table.insert(self.groupMember,self.key)
									table.insert(self.groupKeyList,self.key)
								end
							end
							
							if id then
								if self.entId then
									if self.entId == self.monitor then
										table.insert(self.groupMonitorList,id)
									elseif self.entId == self.reward then
										self.rewardId = id
										self.rewardecoId = v
									end
								end
							end
						end
					end
				end
			end			
			

			
			
			
			
			--↓骇入物和密钥的骇入状态整理↓--------------------------------------------------------------------------
			--关闭所有密钥实体的骇入功能
			if next(self.groupKeyList) ~= nil then
				for i ,v in pairs(self.groupKeyList) do
					BehaviorFunctions.SetEntityHackEnable(v,false) --关闭所有密钥的骇入功能
				end
			end

			
			--开启骇入物的骇入功能
			BehaviorFunctions.SetEntityHackEnable(self.me,true)
			--关闭“获得奖励”按钮
			if BehaviorFunctions.GetHackingButtonIsActive(self.me,HackingConfig.HackingKey.Up) ~= false then
				BehaviorFunctions.SetHackingButtonActive(self.me, HackingConfig.HackingKey.Up,false)
			end
			--↑骇入物和密钥的骇入状态整理↑---------------------------------------------------------------------------
			
			--需要的骇入密钥的数量
			self.goal = #self.groupKeyList
			self.goal1 = tostring(self.goal)
			
			BehaviorFunctions.SetEntityHackInformation(self.me,"缺少密钥，拒绝访问","Textures/Icon/Single/HackIcon/HackLock.png","获得密钥，解锁访问权限")
			
			--玩法状态切换
			self.state = self.stateEnum.Start
			
		--玩法在开始状态下-----------------------------------------------------------------------------------------------------------------------------------------------
		elseif self.state == self.stateEnum.Start then

			
			--计算与角色的距离，如果距离近于一定水平，则显示指引图标
			self.dis = BehaviorFunctions.GetDistanceFromTarget(self.me,self.ctrlRole)
			if self.dis < self.guideDis and self.guideState == self.guideStateEnum.default then
				self.guideHack = BehaviorFunctions.AddEntityGuidePointer(self.me,FightEnum.GuideType.Check,0.5)
				self.guideState = self.guideStateEnum.hackGuide --切换骇入的状态
				BehaviorFunctions.ShowTip(203053205)
				
				--显示图文教学
				if BehaviorFunctions.CheckTeachIsFinish(20035) == false then
					BehaviorFunctions.ShowGuideImageTips(20035)
					--BehaviorFunctions.AddDelayCallByTime(1.5,BehaviorFunctions,BehaviorFunctions.ShowGuideImageTips,self.teach)
				end
				
				
			elseif self.dis > self.guideDis and self.guideState == self.guideStateEnum.hackGuide then
				BehaviorFunctions.RemoveEntityGuidePointer(self.guideHack)
				--BehaviorFunctions.RemoveEntity(self.guideHack)
				self.guideHack = nil
				self.guideState = self.guideStateEnum.default
				BehaviorFunctions.HideTip(203053205)
			end
			
			--判断玩家是否在骇入模式下，如果在骇入模式，则会增加高亮特效
			self.roleState = BehaviorFunctions.GetEntityState(self.ctrlRole) --获得角色状态
			if self.roleState == FightEnum.EntityState.Hack then --判断是否是骇入状态下
				if self.fxguideState == self.fxguideStateEnum.default then
					self.fxguideState = self.fxguideStateEnum.hackGuide
					
					self.fxhackGuide = BehaviorFunctions.CreateEntity(2030532006,self.me,self.mepos.x,self.mepos.y,self.mepos.z)
				end
			elseif self.fxguideState ~= self.fxguideStateEnum.default then
				self.fxguideState = self.fxguideStateEnum.default
				if self.fxhackGuide then
					BehaviorFunctions.RemoveEntity(self.fxhackGuide)
				end
			end
			
			
			
		--玩法在开始中的状态下-----------------------------------------------------------------------------------------------------------------------------------------------
		elseif self.state == self.stateEnum.Starting then
			
			BehaviorFunctions.ShowTip(203053201) --提示，寻找密钥
			BehaviorFunctions.ChangeSubTipsDesc(1,203053201,self.keyNum,self.goal)
			
			--关闭对骇入物目标的引导
			if  self.guideState == self.guideStateEnum.hackGuide or self.guideState == self.guideStateEnum.default then
				BehaviorFunctions.RemoveEntityGuidePointer(self.guideHack)
				self.guideHack = nil
				self.guideState = self.guideStateEnum.keyGuide
			end
			
			
			--遍历生态组成员，把骇入功能打开，让密钥可以被骇入。
			if next(self.groupMember) then
				for i =1 , #self.groupMember do
					BehaviorFunctions.SetEntityHackEnable(self.groupMember[i],true) --开启所有实体的骇入功能
				end
			end
			
			--将密钥与骇入连线一一对应，将未解锁的骇入连线连接
			if next(self.groupKeyList) then
				for i=1, #self.groupKeyList do
					
					self.groupKeyAllList[i].keyId = self.groupKeyList[i] --将keyId对应到钥匙数组中
					
					--密钥连接线
					local targetPos = BehaviorFunctions.GetPositionP(self.groupKeyList[i])
					self.fxkeyLockLine = BehaviorFunctions.CreateEntity(2030532001,self.me,0,0,0) --创建未解锁的密钥连接线
					self.fxkeyLockLineDis = BehaviorFunctions.GetTransformDistance(self.me,"HackPoint",self.groupKeyList[i],"HackPoint") --获取骇入物与密钥持有者的距离
					BehaviorFunctions.ClientEffectRelation(self.fxkeyLockLine,self.groupKeyList[i],"HackPoint",self.me,"HackPoint",self.fxkeyLockLineDis) --将骇入物与密钥持有者的连接
					self.groupKeyAllList[i].lineId = self.fxkeyLockLine --将未骇入的连线一一对应到要是数组中
					
					--给每个密钥增加引导图标
					if self.guideState == self.guideStateEnum.keyGuide then
						self.groupKeyAllList[i].guideId = BehaviorFunctions.AddEntityGuidePointer(self.groupKeyAllList[i].keyId,FightEnum.GuideType.Check,0.5)
					end
					
					----给每个密钥增加引导特效
					--self.roleState = BehaviorFunctions.GetEntityState(self.ctrlRole) --获得角色状态
					--if self.roleState == FightEnum.EntityState.Hack then --判断是否是骇入状态下
						--if self.fxguideState == self.fxguideStateEnum.default then
							--self.fxguideState = self.fxguideStateEnum.hackGuide
							--BehaviorFunctions.SetEntityHackEffectIsTask(self.me, true)
							--self.fxhackGuide = BehaviorFunctions.CreateEntity(2030532006,self.me,self.mepos.x,self.mepos.y,self.mepos.z)
						--end
					--end
					
					--把每个密钥设成任务目标，变成金色
					BehaviorFunctions.SetEntityHackEffectIsTask(self.groupKeyAllList[i].keyId, true)
					
				end
			end
			
			--把指引特效的状态设为默认
			self.fxguideState = self.fxguideStateEnum.default
			
			
			--玩法状态切换,进入搜索状态
			self.state = self.stateEnum.Searching
			
		--玩法在搜索状态下-----------------------------------------------------------------------------------------------------------------------------------------------
		elseif self.state == self.stateEnum.Searching then
			
			--获得当前操控角色和距离
			self.ctrlRole = BehaviorFunctions.GetCtrlEntity()
			self.dis = BehaviorFunctions.GetDistanceFromTarget(self.me,self.ctrlRole)
			self.roleState = BehaviorFunctions.GetEntityState(self.ctrlRole) --获得角色状态

			if next(self.paramMe) then
				--范围限制
				if self.paramMe[1].Limit == 'TRUE' then
					
					--判断玩家是否在骇入模式下，如果在骇入模式，则会增加高亮特效
					if self.roleState == FightEnum.EntityState.Hack then --判断是否是骇入状态下
						if self.fxguideState == self.fxguideStateEnum.default then
							self.fxguideState = self.fxguideStateEnum.keyGuide --重置指引特效状态
							--骇入物的指引特效
							if self.fxhackGuide == nil then
								self.fxhackGuide = BehaviorFunctions.CreateEntity(2030532006,self.me,self.mepos.x,self.mepos.y,self.mepos.z)
							end
							--骇入密钥的特效指引
							if next(self.groupKeyAllList) then
								for i = 1, #self.groupKeyAllList do
									if self.groupKeyAllList[i].hack == false and self.groupKeyAllList[i].keyId ~= nil then
										local posGuide = BehaviorFunctions.GetPositionP(self.groupKeyAllList[i].keyId)
										self.groupKeyAllList[i].fxguideId = BehaviorFunctions.CreateEntity(2030532006,self.groupKeyAllList[i].keyId,posGuide.x,posGuide.y,posGuide.z)
									end
								end
							end
	
							--摄像头的特效指引
							if next(self.groupMonitorList) then
								for i = 1, #self.groupMonitorList do
									local posMonitor = BehaviorFunctions.GetPositionP(self.groupMonitorList[i])
									self.fxmonitor = BehaviorFunctions.CreateEntityByEntity(self.groupMonitorList[i],2030532004,posMonitor.x,posMonitor.y,posMonitor.z)
									table.insert(self.fxgroupMonitorList,self.fxmonitor)
								end
							end
	
							--骇入范围的指引
							--创建地面限定范围移动特效
							if self.fxcircle == nil then
								self.mepos = BehaviorFunctions.GetPositionP(self.me)
								self.high = BehaviorFunctions.CheckPosHeight(self.mepos)
								self.fxcircle = BehaviorFunctions.CreateEntity(2030532003,nil,self.mepos.x,(self.mepos.y-self.high),self.mepos.z)
							end
						else
							--在范围内
							if self.dis < self.disLimit then
								if self.disOn == true then
									self.disOn = false
									if next(self.groupKeyAllList)  then
										for i = 1 ,#self.groupKeyAllList do
											if self.groupKeyAllList[i].hack == false and self.groupKeyAllList[i].keyId ~= nil then
												BehaviorFunctions.SetEntityHackEnable(self.groupKeyAllList[i].keyId,true) --开启所有物体的骇入功能
	
												if self.groupKeyAllList[i].keyId ~= nil and self.groupKeyAllList[i].hack == false and self.groupKeyAllList[i].lineId  == nil then
													--骇入连线特效
													self.fxkeyLockLine = BehaviorFunctions.CreateEntity(2030532001,self.me,0,0,0) --创建未解锁的密钥连接线
													self.fxkeyLockLineDis = BehaviorFunctions.GetTransformDistance(self.me,"HackPoint",self.groupKeyAllList[i].keyId,"HackPoint") --获取骇入物与密钥持有者的距离
													BehaviorFunctions.ClientEffectRelation(self.fxkeyLockLine,self.groupKeyAllList[i].keyId,"HackPoint",self.me,"HackPoint",self.fxkeyLockLineDis) --将骇入物与密钥持有者的连接
													self.groupKeyAllList[i].lineId = self.fxkeyLockLine
												end

												--骇入密钥的特效指引
												if next(self.groupKeyAllList) then
													for i = 1, #self.groupKeyAllList do
														if self.groupKeyAllList[i].hack == false and self.groupKeyAllList[i].keyId ~= nil and self.groupKeyAllList[i].fxguideId == nil then
															local posGuide = BehaviorFunctions.GetPositionP(self.groupKeyAllList[i].keyId)
															self.groupKeyAllList[i].fxguideId = BehaviorFunctions.CreateEntity(2030532006,self.groupKeyAllList[i].keyId,posGuide.x,posGuide.y,posGuide.z)
														end
													end
												end
	
												--摄像头的特效指引
												if next(self.groupMonitorList) then
													for i = 1, #self.groupMonitorList do
														local posMonitor = BehaviorFunctions.GetPositionP(self.groupMonitorList[i])
														self.fxmonitor = BehaviorFunctions.CreateEntityByEntity(self.groupMonitorList[i],2030532004,posMonitor.x,posMonitor.y,posMonitor.z)
														table.insert(self.fxgroupMonitorList,self.fxmonitor)
													end
												end
												
												--密钥的指引图标
												if self.groupKeyAllList[i].hack == false and self.groupKeyAllList[i].keyId ~= nil and self.groupKeyAllList[i].guideId == nil then
													self.groupKeyAllList[i].guideId = BehaviorFunctions.AddEntityGuidePointer(self.groupKeyAllList[i].keyId,FightEnum.GuideType.Check,0.5)
												end
												
												--移除骇入物的指引图标
												if self.guideHack then
													BehaviorFunctions.RemoveEntityGuidePointer(self.guideHack)
													self.guideHack = nil
												end
												
											end
										end
									end
	
									BehaviorFunctions.SetEntityHackEnable(self.me,true)
									BehaviorFunctions.HideTip(203053204)
									BehaviorFunctions.ShowTip(203053201)
									BehaviorFunctions.ChangeSubTipsDesc(1,203053201,self.keyNum,self.goal)
	
								end
							--在范围外
							else
								if self.disOn == false then
									self.disOn = true
									
									--移除连接线特效
									if next(self.groupKeyAllList) then
										for i = 1, #self.groupKeyAllList do
											if self.groupKeyAllList[i].hack == false  and self.groupKeyAllList[i].keyId ~= nil and self.groupKeyAllList[i].lineId then
												--移除未解锁的连接特效
												BehaviorFunctions.ClientEffectRemoveRelation(self.groupKeyAllList[i].lineId)
												BehaviorFunctions.RemoveEntity(self.groupKeyAllList[i].lineId)
												self.groupKeyAllList[i].lineId = nil
											end
										end
									end
									
									if next(self.groupMember) ~= nil then
										for i ,v in pairs(self.groupKeyList) do
											BehaviorFunctions.SetEntityHackEnable(v,false) --关闭所有物体的骇入功能
										end
									end
									BehaviorFunctions.SetEntityHackEnable(self.me,false)
									
									
									BehaviorFunctions.HideTip(203053201)
									BehaviorFunctions.ShowTip(203053204)
									--骇入物的指引图标
									if self.guideHack == nil then
										
										self.guideHack = BehaviorFunctions.AddEntityGuidePointer(self.me,FightEnum.GuideType.Check,0.5)
									end
									
									--移除密钥的指引图标
									if next(self.groupKeyAllList) then
										for i = 1, #self.groupKeyAllList do
											if self.groupKeyAllList[i].guideId  then
												BehaviorFunctions.RemoveEntityGuidePointer(self.groupKeyAllList[i].guideId)
												self.groupKeyAllList[i].guideId = nil
											end
										end
									end
									
									--移除密钥指引特效
									if next(self.groupKeyAllList) then
										for i = 1, #self.groupKeyAllList do
											if self.groupKeyAllList[i].fxguideId then
												BehaviorFunctions.RemoveEntity(self.groupKeyAllList[i].fxguideId)
												self.groupKeyAllList[i].fxguideId = nil
											end
										end
									end
	
									--移除摄像头的指引
									if next(self.fxgroupMonitorList) then
										for i = 1, #self.fxgroupMonitorList do
											BehaviorFunctions.RemoveEntity(self.fxgroupMonitorList[i])
										end
									end
								end
							end
						end
					else
						--退出骇入模式的情况
						if self.fxguideState ~= self.fxguideStateEnum.default then
							self.fxguideState = self.fxguideStateEnum.default
							--移除骇入物的引导特效
							if self.fxhackGuide then
								BehaviorFunctions.RemoveEntity(self.fxhackGuide)
								self.fxhackGuide = nil
							end
							--移除密钥指引特效
							if next(self.groupKeyAllList) then
								for i = 1, #self.groupKeyAllList do
									if self.groupKeyAllList[i].hack == false then
										BehaviorFunctions.RemoveEntity(self.groupKeyAllList[i].fxguideId)
										self.groupKeyAllList[i].fxguideId = nil
									end
								end
							end
	
							--移除摄像头的指引特效
							if next(self.fxgroupMonitorList) then
								for i = 1, #self.fxgroupMonitorList do
									BehaviorFunctions.RemoveEntity(self.fxgroupMonitorList[i])
								end
							end
	
							--移除骇入范围的指引
							if self.fxcircle then
								BehaviorFunctions.RemoveEntity(self.fxcircle)
								self.fxcircle = nil
							end
							
						else
	
							--在范围内
							if self.dis < self.disLimit then
								if self.disOn1 == false then
									self.disOn1 = true
									--移除骇入物的引导图标
									if self.guideHack then
										BehaviorFunctions.RemoveEntityGuidePointer(self.guideHack)
										self.guideHack = nil
									end
									
									--密钥指引特效
									if next(self.groupKeyAllList) then
										for i = 1, #self.groupKeyAllList do
											if self.groupKeyAllList[i].hack == false and self.groupKeyAllList[i].keyId ~= nil and self.groupKeyAllList[i].guideId == nil then
												self.groupKeyAllList[i].guideId = BehaviorFunctions.AddEntityGuidePointer(self.groupKeyAllList[i].keyId,FightEnum.GuideType.Check,0.5)
											end
											
											if self.groupKeyAllList[i].hack == false and self.groupKeyAllList[i].keyId ~= nil and self.groupKeyAllList[i].lineId == nil then
												BehaviorFunctions.SetEntityHackEnable(self.groupKeyAllList[i].keyId,true) --开启所有物体的骇入功能
												--创建骇入连线特效
												self.fxkeyLockLine = BehaviorFunctions.CreateEntity(2030532001,self.me,0,0,0) --创建未解锁的密钥连接线
												self.fxkeyLockLineDis = BehaviorFunctions.GetTransformDistance(self.me,"HackPoint",self.groupKeyAllList[i].keyId,"HackPoint") --获取骇入物与密钥持有者的距离
												BehaviorFunctions.ClientEffectRelation(self.fxkeyLockLine,self.groupKeyAllList[i].keyId,"HackPoint",self.me,"HackPoint",self.fxkeyLockLineDis) --将骇入物与密钥持有者的连接
												self.groupKeyAllList[i].lineId = self.fxkeyLockLine
											end	
											
											
										end
									end
									
									BehaviorFunctions.HideTip(203053204)
									BehaviorFunctions.ShowTip(203053201) --提示，寻找密钥
									BehaviorFunctions.ChangeSubTipsDesc(1,203053201,self.keyNum,self.goal)	
								end
								
							else
								if self.disOn1 == true then
									self.disOn1 = false
									BehaviorFunctions.HideTip(203053201)
									BehaviorFunctions.ShowTip(203053204) --提示，寻找密钥
	
									--骇入物的引导图标
									if self.guideHack  == nil then
										self.guideHack = BehaviorFunctions.AddEntityGuidePointer(self.me,FightEnum.GuideType.Check,0.5)
									end
	
									--移除密钥指引图标
									if next(self.groupKeyAllList) then
										for i = 1, #self.groupKeyAllList do
											if self.groupKeyAllList[i].guideId then
												BehaviorFunctions.RemoveEntityGuidePointer(self.groupKeyAllList[i].guideId)
												self.groupKeyAllList[i].guideId = nil
											end
											--移除连接线特效
											if self.groupKeyAllList[i].hack == false  and self.groupKeyAllList[i].keyId ~= nil and self.groupKeyAllList[i].lineId ~= nil then
												--移除未解锁的连接特效
												BehaviorFunctions.ClientEffectRemoveRelation(self.groupKeyAllList[i].lineId)
												BehaviorFunctions.RemoveEntity(self.groupKeyAllList[i].lineId)
												self.groupKeyAllList[i].lineId = nil
											end

										end
									end
								end
							end
						end
					end
					
					
						
					
				else

				end
			else
				--判断玩家是否在骇入模式下，如果在骇入模式，则会增加高亮特效
				if self.roleState == FightEnum.EntityState.Hack then --判断是否是骇入状态下
					if self.fxguideState == self.fxguideStateEnum.default then
						self.fxguideState = self.fxguideStateEnum.keyGuide --重置指引特效状态
						--骇入物的指引
						if self.fxhackGuide == nil then
							self.fxhackGuide = BehaviorFunctions.CreateEntity(2030532006,self.me,self.mepos.x,self.mepos.y,self.mepos.z)
						end
						--骇入密钥的特效指引
						if next(self.groupKeyAllList) then
							for i = 1, #self.groupKeyAllList do
								if self.groupKeyAllList[i].hack == false and self.groupKeyAllList[i].keyId ~= nil then
									local posGuide = BehaviorFunctions.GetPositionP(self.groupKeyAllList[i].keyId)
									self.groupKeyAllList[i].fxguideId = BehaviorFunctions.CreateEntity(2030532006,self.groupKeyAllList[i].keyId,posGuide.x,posGuide.y,posGuide.z)
								end
							end
						end

						--摄像头的特效指引
						if next(self.groupMonitorList) then
							for i = 1, #self.groupMonitorList do
								local posMonitor = BehaviorFunctions.GetPositionP(self.groupMonitorList[i])
								self.fxmonitor = BehaviorFunctions.CreateEntityByEntity(self.groupMonitorList[i],2030532004,posMonitor.x,posMonitor.y,posMonitor.z)
								table.insert(self.fxgroupMonitorList,self.fxmonitor)
							end
						end
					end
				else
					--退出骇入模式的情况
					if self.fxguideState ~= self.fxguideStateEnum.default then
						self.fxguideState = self.fxguideStateEnum.default
						--移除引导
						if self.fxhackGuide then
							BehaviorFunctions.RemoveEntity(self.fxhackGuide)
							self.fxhackGuide = nil
						end
						--移除密钥指引特效
						if next(self.groupKeyAllList) then
							for i = 1, #self.groupKeyAllList do
								if self.groupKeyAllList[i].hack == false then
									BehaviorFunctions.RemoveEntity(self.groupKeyAllList[i].fxguideId)
									self.groupKeyAllList[i].fxguideId = nil
								end
							end
						end

						--移除摄像头的指引
						if next(self.fxgroupMonitorList) then
							for i = 1, #self.fxgroupMonitorList do
								BehaviorFunctions.RemoveEntity(self.fxgroupMonitorList[i])
							end
						end
					end
				end
			end

			if self.dis > self.disMax then
				BehaviorFunctions.HideTip(203053201)
			end
			
			
		--玩法在胜利状态下------------------------------------------------------------------------------------------------------------------------------------------------
		elseif self.state == self.stateEnum.Success then
			
			--将奖励按钮显示出来
			if BehaviorFunctions.GetHackingButtonIsActive(self.me,HackingConfig.HackingKey.Up) == false then
				BehaviorFunctions.SetHackingButtonActive(self.me, HackingConfig.HackingKey.Up,true)
				BehaviorFunctions.HideTip(203053201)
				BehaviorFunctions.ShowTip(203053202)
				BehaviorFunctions.SetEntityHackInformation(self.me,"数据库","Textures/Icon/Single/HackIcon/Databases.png","访问成功！")
				
				BehaviorFunctions.SetEntityHackButtonInformation(self.me,HackingConfig.HackingKey.Up,"窃取资料","hack_databases",20,"已解除锁定，骇入以获得奖励")
				
			end
			
			--显示奖励的指引图标
			if self.guideState == self.guideStateEnum.keyGuide then
				self.guideState = self.guideStateEnum.rewardGuide
				self.guideHack = BehaviorFunctions.AddEntityGuidePointer(self.me,FightEnum.GuideType.TreasureBox,0.5)
			end
			
			--判断玩家是否在骇入模式下，如果在骇入模式，则会增加高亮特效
			self.roleState = BehaviorFunctions.GetEntityState(self.ctrlRole) --获得角色状态
			if self.roleState == FightEnum.EntityState.Hack then --判断是否是骇入状态下
				if self.fxguideState == self.fxguideStateEnum.default then
					self.fxguideState = self.fxguideStateEnum.rewardGuide --重置指引特效状态
					--骇入物的指引
					if self.fxhackGuide == nil then
						self.fxhackGuide = BehaviorFunctions.CreateEntity(2030532006,self.me,self.mepos.x,self.mepos.y,self.mepos.z)
					end

				end
			else
				--退出骇入模式的情况
				if self.fxguideState ~= self.fxguideStateEnum.default then
					self.fxguideState = self.fxguideStateEnum.default
					if self.fxhackGuide then
						BehaviorFunctions.RemoveEntity(self.fxhackGuide)
						self.fxhackGuide = nil
					end
					--摄像头的指引
					if next(self.fxgroupMonitorList) then
						for i = 1, #self.fxgroupMonitorList do
							BehaviorFunctions.RemoveEntity(self.fxgroupMonitorList[i])
						end
					end
				end
			end
			
			if next(self.paramMe) then
				--范围限制
				if self.paramMe[1].Limit == 'TRUE' then
					if self.fxcircle then
						BehaviorFunctions.RemoveEntity(self.fxcircle)
						self.fxcircle = nil
					end
				end
			end	



		--玩法结束-------------------------------------------------------------------------------------------------------------------------------------------------------
		elseif self.state == self.stateEnum.End then

			

			
	
		--玩法中止-------------------------------------------------------------------------------------------------------------------------------------------------------
		elseif self.state == self.stateEnum.Stop then
	
	
		end
	else

		BehaviorFunctions.SetEntityHackEnable(self.me,false) --关闭所有密钥的骇入功能
	end
end

function Behavior2030532:Hacking(instanceId)
	--选中骇入目标的时候，开始玩法
	if instanceId == self.me and self.state == self.stateEnum.Start then
		self.state = self.stateEnum.Starting --把状态设为进行中
	end
	
	if instanceId == self.me and self.state == self.stateEnum.Success then
		
		
	end
	
end

--点击上侧按钮
function Behavior2030532:HackingClickUp(instanceId)
	
	--当收集全密钥之后，对骇入物执行“激活”功能
	if instanceId == self.me then
		--当前处于胜利状态下，则可以获得奖励
		if self.state == self.stateEnum.Success then
			--获得奖励
			BehaviorFunctions.HideTip(203053202)
			--BehaviorFunctions.ShowTip(203053203)
			--关闭骇入物的骇入功能，无法再次骇入
			BehaviorFunctions.SetEntityHackEnable(self.me,false) --关闭密钥持有者的骇入功能
			
			--移除已解锁的连线特效
			for i = 1, #self.groupKeyAllList do
				if self.groupKeyAllList[i].lineId and self.groupKeyAllList[i].hack == true then
					self.groupKeyAllList[i].hack = false
					--移除未解锁的连接特效
					BehaviorFunctions.ClientEffectRemoveRelation(self.groupKeyAllList[i].lineId)
					BehaviorFunctions.RemoveEntity(self.groupKeyAllList[i].lineId)
					self.groupKeyAllList[i].lineId = nil
				end
			end
			
			--移除骇入物的标志图示
			--移除密钥标志
			if self.guideState == self.guideStateEnum.rewardGuide then
				BehaviorFunctions.RemoveEntityGuidePointer(self.guideHack)
				self.guideHack = nil
				self.guideState = self.guideStateEnum.endGuide
			end
			
			if next(self.paramMe) then
				--如果地面有特效，移除圈圈特效
				if self.paramMe[1].Limit == 'TRUE' and self.fxcircle then

					BehaviorFunctions.RemoveEntity(self.fxcircle)
					self.fxcircle = nil
				end
			end


			--取消设置成任务目标
			BehaviorFunctions.SetEntityHackEffectIsTask(self.me, false)
			
			
			
			--移除指示特效
			if self.fxhackGuide then
				BehaviorFunctions.RemoveEntity(self.fxhackGuide)
				self.fxhackGuide = nil
			end
			
			-----------------------奖励-----------------------------
			--获取生态组成员生态id
			if self.ecoId then
				self.groupEcoMemberReward = BehaviorFunctions.GetEcoEntityGroupMember(nil,nil,nil,self.me)
				--self.groupEcoMember =  BehaviorFunctions.GetEcoEntityGroup(nil,self.ecoId,nil)
			end

			
			if self.groupEcoMemberReward then
				--把生态id转化为实体id
				if next(self.groupEcoMemberReward) ~= nil then
					for i ,v in pairs(self.groupEcoMemberReward) do
						local id = v.instanceId --获得实体id
						if id then
							self.entId = BehaviorFunctions.GetEntityTemplateId(id) --根据实例id获得实体配置id
						end

						if id then
							if self.entId then
								if self.entId == self.reward then
									self.rewardId = id
									self.rewardecoId = v.ecoId
								end
							end
						end
					end
				end
			end


			
			--移除奖励空实体，获得奖励
			if self.rewardId then
				BehaviorFunctions.ExitHackingMode()
				BehaviorFunctions.InteractEntityHit(self.rewardId,true)--后端交互
				BehaviorFunctions.RemoveEntity(self.rewardId)
				self.rewardId = nil
			end
			
			self.ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoId) --获得生态状态
			if self.ecoState == 0  then
				--BehaviorFunctions.SetEcoEntityState(self.ecoId,1)
				self.ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoId) --获得生态状态
			end
			
			self.groupEcoMember = {} --清空
			
			self.state = self.stateEnum.End --状态切换到end
		end
	end
	
	
	--获得密钥功能
	if self.groupKeyList and self.state == self.stateEnum.Searching then
		if next(self.groupKeyList) then
			for i = 1, #self.groupKeyAllList do
				if self.groupKeyAllList[i].keyId == instanceId and self.groupKeyAllList[i].hack == false then
					self.groupKeyAllList[i].hack = true
					--移除未解锁的连接特效
					BehaviorFunctions.ClientEffectRemoveRelation(self.groupKeyAllList[i].lineId)
					BehaviorFunctions.RemoveEntity(self.groupKeyAllList[i].lineId)
					self.groupKeyAllList[i].lineId = nil
					
					--创建并连接已解锁的连线特效
					self.fxkeyUnlockLineDis = BehaviorFunctions.GetTransformDistance(self.me,"HackPoint",instanceId,"HackPoint") --获取骇入物与密钥持有者的距离
					self.fxkeyUnlockLine = BehaviorFunctions.CreateEntity(2030532002,self.me,0,0,0) --创建未解锁的密钥连接线
					BehaviorFunctions.ClientEffectRelation(self.fxkeyUnlockLine,self.me,"HackPoint",instanceId,"HackPoint",self.fxkeyUnlockLineDis) --将骇入物与密钥持有者的连接
					self.groupKeyAllList[i].lineId = self.fxkeyUnlockLine

					
					--移除密钥标志
					if self.groupKeyAllList[i].guideId then
						BehaviorFunctions.RemoveEntityGuidePointer(self.groupKeyAllList[i].guideId)
						self.groupKeyAllList[i].guideId = nil
					end
					
					--取消设置成任务目标
					BehaviorFunctions.SetEntityHackEffectIsTask(self.groupKeyAllList[i].keyId, false)
					
					--密钥计算
					self:GetKey(self.groupKeyAllList[i].keyId) 
							
					--判断是否有指示特效并移除
					if self.groupKeyAllList[i].fxguideId ~= nil then
						BehaviorFunctions.RemoveEntity(self.groupKeyAllList[i].fxguideId)
						self.groupKeyAllList[i].fxguideId = nil
					end
				end
			end
		end
	end

end

--点击下侧按钮
function Behavior2030532:HackingClickDown(instanceId)
	if instanceId == self.me then

	end
end

--点击右侧按钮
function Behavior2030532:HackingClickRight(instanceId)
	if instanceId == self.me then

	end
end

--点击左侧按钮
function Behavior2030532:HackingClickLeft(instanceId)
	if instanceId == self.me then

	end
end


--获得密钥
function Behavior2030532:GetKey(instanceId)
	BehaviorFunctions.SetEntityHackEnable(instanceId,false) --关闭密钥持有者的骇入功能
	self.keyNum = self.keyNum + 1 --密钥拥有数量加1
	BehaviorFunctions.ChangeSubTipsDesc(1,203053201,self.keyNum,self.goal)
	
	--如果密钥数量大于需要数量，则进入成功状态
	if self.keyNum >= self.goal then
		self.state = self.stateEnum.Success
		self.fxguideState = self.fxguideStateEnum.default
		
		--摄像头的指引
		if next(self.fxgroupMonitorList) then
			for i = 1, #self.fxgroupMonitorList do
				BehaviorFunctions.RemoveEntity(self.fxgroupMonitorList[i])
			end
		end

	end
end


function Behavior2030532:KeyInput(key, status)
	if key == FightEnum.KeyEvent.HackShiftBuild and status == FightEnum.KeyInputStatus.Up then
		self.ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoId) --获得生态状态
		if self.ecoState == 1  then
			BehaviorFunctions.SetEcoEntityState(self.ecoId,0)
		end
	end
end