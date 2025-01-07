PartnerBornAndExist = BaseClass("PartnerBornAndExist",EntityBehaviorBase)

function PartnerBornAndExist:Init()
    Log("PartnerBornAndExist:Init()")
    self.PartnerAllBehavior = self.ParentBehavior
    self.PartnerAllParm = self.MainBehavior.PartnerAllParm
    self.PartnerCastSkill = self.MainBehavior.PartnerCastSkill
    self.me = self.instanceId
    self.role = BehaviorFunctions.GetEntityOwner(self.me)
    self.existOnStart = false --初始在场
    self.bornOffset = Vec3.New(2,0,0) --偏移
    self.bornRadius = 3 --点位不合法的时候搜索合法点位的半径
    self.residentTime = -1 --驻场时间，秒。负数永久
    self.start = false
    self.existState = 0--0，永久在场，1在场，2等待退场，3退场
    self.curResidentTime = 0
end

function PartnerBornAndExist:Start()
    self.role = BehaviorFunctions.GetEntityOwner(self.me)
    if self.existOnStart and BehaviorFunctions.CheckEntity(self.role) and BehaviorFunctions.CheckEntityForeground(self.role) and not BehaviorFunctions.CheckPartnerShow(self.role) then
        local followRadius = 3
		local pos,result = BehaviorFunctions.GetChangeOptimumPos(self.role,nil,followRadius,1,followRadius,followRadius,2)
        if result then
            self.start = true
            self:Enter(pos)
        end
    end
end

function PartnerBornAndExist:Update()
	self.role = BehaviorFunctions.GetEntityOwner(self.me)
	local show = BehaviorFunctions.CheckPartnerShow(self.role)
    if not show and not self.start then
        self:Start()
        return
    end
	
    local show = BehaviorFunctions.GetEntityValue(self.me,"partnerShow")
    if show then
        BehaviorFunctions.SetEntityValue(self.me,"partnerShow",false)
        self.curResidentTime = self.residentTime
        self.existState = self.curResidentTime < 0 and 0 or 1--三目运算符，小于0永久在场
    end

    if self.existState == 0 then--永久在场
        if self:CheckTempExit() then
            self:TempExit()
        end
    elseif self.existState == 1 then--限时在场
        if self.curResidentTime > 0 then
            self.curResidentTime = self.curResidentTime - 1/30
            if self.curResidentTime < 0 then
                if BehaviorFunctions.CanCtrl(self.me) then
                    self:Exit()
                else
                    self.existState = 2--等待退场
                end
            else
                if self:CheckTempExit() then
                    self:TempExit()
                end
            end
        end
    elseif self.existState == 2 then --等待退场
        if BehaviorFunctions.CanCtrl(self.me) then
            self:Exit()
        end
    elseif self.existState == 3 then--已经退场
        if self.curResidentTime < 0 and not self:CheckTempExit() then--永久在场
            self.start = false--临时退场后重新召唤出场
        end
    end
    
end

function PartnerBornAndExist:CheckTempExit()--临时退场状态，游泳、攀爬、滑翔、下落、表演
    local state = BehaviorFunctions.GetEntityState(self.role)
    return state == FightEnum.EntityState.Perform
    or state == FightEnum.EntityState.Slide 
    or state == FightEnum.EntityState.Climb 
    or state == FightEnum.EntityState.Swim 
    or state == FightEnum.EntityState.Glide 
    or state == FightEnum.EntityState.OpenDoor 
    or state == FightEnum.EntityState.Build 
    or state == FightEnum.EntityState.Hack 
end

function PartnerBornAndExist:TempExit()--临时退场
	self:Exit()
end

function PartnerBornAndExist:Enter(pos)--进场
    self.curResidentTime = self.residentTime
    self.existState = self.curResidentTime < 0 and 0 or 1--三目运算符，小于0永久在场
    -- local pos1 = self:GetPosition()
    -- local _,pos = CombinationFunctions.GetCanBornPosition(pos1,0)
	--LogError("Enter1 "..pos.x.."  "..pos.y.."  "..pos.z)
	local pos1 = BehaviorFunctions.GetPositionP(self.role)
	local dis = BehaviorFunctions.GetDistanceFromPos(pos,pos1)
	--LogError("dis "..dis)
	--LogError("Enter2 "..pos1.x.."  "..pos1.y.."  "..pos1.z)
    BehaviorFunctions.DoSetPosition(self.me,pos.x,pos.y,pos.z)
    BehaviorFunctions.DoLookAtPositionImmediately(self.me,self.PartnerAllParm.roleFrontPos.x,self.PartnerAllParm.roleFrontPos.y,self.PartnerAllParm.roleFrontPos.z,true)	--设置朝向
	BehaviorFunctions.ShowPartner(self.role, true)
	BehaviorFunctions.AddBuff(self.me,self.me,1000055)
end

function PartnerBornAndExist:Exit()--退场
	Log("PartnerBornAndExist:Exit()")
    self.existState = 3
    self.curResidentTime = self.residentTime
    self.PartnerCastSkill:EndCreatePartnerSkill()
end

function PartnerBornAndExist:GetPosition()
    return BehaviorFunctions.GetEntityPositionOffset(self.role,self.bornOffset.x,self.bornOffset.y,self.bornOffset.z)
end

--切人判断：如果是跟随类佩从且初始在场且当前不在场且创建者切上场
function PartnerBornAndExist:OnSwitchPlayerCtrl(oldInstanceId,instanceId)
	if self.PartnerAllParm.partnerType == 3 and self.existOnStart == true 
		and self.role == BehaviorFunctions.GetCtrlEntity()
		and not BehaviorFunctions.CheckPartnerShow(instanceId) then
			local followRadius = 3
			local pos,result = BehaviorFunctions.GetChangeOptimumPos(self.role,nil,followRadius,1,followRadius,followRadius,2)
			if result then--找不到在场位置
				self:Enter(pos)
			else
				self.needEnter = true--不确定需求，暂不处理
			end
	end
end

--死亡移除自己的佩从
function PartnerBornAndExist:Die(attackInstanceId,dieInstanceId)
	local role = BehaviorFunctions.GetEntityOwner(self.me)
	if dieInstanceId == role and BehaviorFunctions.CheckPartnerShow(dieInstanceId) then
		self:Exit()
	end
end