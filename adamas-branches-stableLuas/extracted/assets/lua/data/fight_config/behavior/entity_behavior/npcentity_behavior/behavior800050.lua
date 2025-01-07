Behavior800050 = BaseClass("Behavior800050",EntityBehaviorBase)

function Behavior800050.GetGenerates()
	 local generates = {}
	 return generates
end
function Behavior800050:Init()
	self.NpcCommon = BehaviorFunctions.CreateBehavior("NpcCommon",self)
	self.me = self.instanceId
	self.chatTarget = 0
	self.shopState = 0

	
end

function Behavior800050:LateInit()
	self.NpcCommon:LateInit()
end


function Behavior800050:Update()
	self.NpcCommon:Update()
	self.chatTarget = BehaviorFunctions.GetCtrlEntity()
	self.act = BehaviorFunctions.GetPlayingAnimationName(self.me, layer)
end

function Behavior800050:WorldInteractClick(uniqueId,instanceId)
	local id = BehaviorFunctions.GetEntityTemplateId(instanceId)
	--如果是交互商铺
	if id == 2020109 then
		self:LookAtRole(1000,1000)
		--self:LookAtRole(180,460)
		BehaviorFunctions.StartNPCDialog(501280401,self.me)
		self.shopState = 2
	end
	--交互摊贩
	if id == 8011005 then
		self:LookAtRole(180,460)
		--self:LookAtRole(180,460)
		BehaviorFunctions.StartNPCDialog(501280201,self.me)
		self.shopState = 1
	end
	
end

function Behavior800050:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if triggerInstanceId == self.me then
		self.interactUniqueId = BehaviorFunctions.WorldNPCInteractActive(self.me,"小吃摊贩")
	end
end

function Behavior800050:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if triggerInstanceId == self.me then
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	end
end

--退出商店逻辑
function Behavior800050:OnExitShop(shop_id)
	local s = shop_id
	if s == 1005 then
		if self.shopState == 1 then
			BehaviorFunctions.StartNPCDialog(501280301,self.me)
			BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.chatTarget,false,180,460,-2)
		elseif self.shopState == 2 then
			BehaviorFunctions.StartNPCDialog(501280501,self.me)
			self:LookAtRole(270,460)
			--self:LookAtRole(180,460)
		end

	end

end



function Behavior800050:StoryPassEvent(dialogId)
	
	if dialogId == 501280402 then
		BehaviorFunctions.PlayAnimation(self.me,"baoxiong_in")
	end
	--if dialogId == 501280202 then
		--BehaviorFunctions.PlayAnimation(self.me,"Chayao_in")
	--end
end

function Behavior800050:StoryEndEvent(dialogId)
	if dialogId == 501280201 or dialogId == 501280301 or dialogId == 501280501 then
		BehaviorFunctions.PlayAnimation(self.me,"Standback")
		BehaviorFunctions.DoLookAtPositionByLerp(self.me,1535,103,1355,false,270,260)
		--BehaviorFunctions.DoLookAtPositionByLerp(self.me,1535,103,1355,false,1000,1000)
	elseif dialogId == 501280401 then
		BehaviorFunctions.PlayAnimation(self.me,"Standback")
		BehaviorFunctions.DoLookAtPositionByLerp(self.me,1535,103,1355,false,180,260)
		--BehaviorFunctions.DoLookAtPositionByLerp(self.me,1535,103,1355,false,240,260)
	end
end

function Behavior800050:LookAtRole(spd2,spd3)
	BehaviorFunctions.CancelLookAt(self.me)
	BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.chatTarget,false,spd2,spd3,-2)
	BehaviorFunctions.PlayAnimation(self.me,"Standback")
	BehaviorFunctions.DoLookAtTargetImmediately(self.chatTarget,self.me)
end