FightResultWin = BaseClass("FightResultWin",BaseView)
FightResultWin.MODULE = FightFacade
function FightResultWin:__init()
	self:SetAsset("Prefabs/UI/FightResultWin/FightResultWin.prefab")
	self.itemAniSequence = nil
	self.exitSequence = nil
	
	self.itemList = {}
	self.itemObjs = {}
end

function FightResultWin:__delete()
	if self.exitSequence ~= nil then
		self.exitSequence:Kill(false)
		self.exitSequence = nil
	end

	if self.itemAniSequence ~= nil then
		self.itemAniSequence:Kill(false)
		self.itemAniSequence = nil
	end
	
	
	for _, v in pairs(self.itemObjs) do
		ItemManager.Instance:PushItemToPool(v)
	end
	self.itemObjs = {}
end

function FightResultWin:__CacheObject()
	self.canvas = self.transform:GetComponent(Canvas)
end

function FightResultWin:__BindListener()
	self:Find("exit_/btn",Button).onClick:AddListener(self:ToFunc("Exit"))
	
end

-- TODO 道具部分之后要改成动态加载 需要重新处理
function FightResultWin:Exit()
	local mainAnimator = self:Find(nil, Animator)
	
	mainAnimator:SetBool("IsExit", true)
	local tempSequence = DOTween.Sequence()
	for k, v in pairs(self.itemObjs) do
		local exitFunc = function()
			v.objectTransform:GetComponent(Animator):SetBool("IsExit", true)
		end
		tempSequence:AppendInterval(0.1)
		tempSequence:AppendCallback(exitFunc)
	end

	self["20021"]:SetActive(false)
	self.exit_canvas:DOFade(0, 0.5)
	local exitFunc = function ()
		tempSequence:Kill()
		tempSequence = nil
		Fight.Instance:SetFightState(FightEnum.FightState.Exit)
		self:Destroy()
	end

	if not self.timer then
		self.timer = LuaTimerManager.Instance:AddTimer(1, 0.8, exitFunc, 1)
	end
	
	self:Reset()
end

function FightResultWin:Reset()

	for i = 1, #self.itemObjs do
		ItemManager.Instance:PushItemToPool(self.itemObjs[i])
	end
	self.itemList = {}
	self.itemObjs = {}
end

function FightResultWin:__Show()
	EventMgr.Instance:Fire(EventName.ActiveView, FightEnum.UIActiveType.Main, false)
	self["20021"]:SetActive(true)

	if self.itemInfoList and next(self.itemInfoList) then
		self.itemAniSequence = DOTween.Sequence()
		self.itemAniSequence:AppendInterval(1)

		for k, itemInfoData in pairs(self.itemInfoList) do
			local itemInfo = {template_id = itemInfoData[1], count = itemInfoData[2], can_lock = false, nameShow = true, effectShow = true}
			local item = ItemManager.Instance:GetItem(self.ItemParent.transform, itemInfo, false)
			table.insert(self.itemObjs, item)

			local setItemActive = function ()
				item.object:SetActive(true)
			end
			self.itemAniSequence:AppendInterval(0.15)
			self.itemAniSequence:AppendCallback(setItemActive)
		end
	end
	
	self.exitSequence = DOTween.Sequence()


	local callBackExit = function ()
		self["20022"]:SetActive(true)
	end
	local tween = self.exit_canvas:DOFade(1, 0.25)
	self.exitSequence:AppendInterval(2.25)
	self.exitSequence:Append(tween)
	self.exitSequence:AppendCallback(callBackExit)
end

function FightResultWin:__Hide()
	if self.timer then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
        self.timer = nil
    end
end

function FightResultWin:SetItemInfo(itemInfoList)
	self.itemInfoList = itemInfoList

end